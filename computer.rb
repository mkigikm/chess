require_relative 'board'
require 'byebug'

class Computer
  OVER_9000 = 9_001

  #BOARD_POS
  attr_accessor :board, :color

  def initialize(eval_method)
    @eval_method = eval_method
  end

  def get_move
    send(@eval_method)
  end

  def other_color(color)
    color == :white ? :black : :white
  end

  def make_move(input, color)
    puts "#{Board.parse(input[0])}, #{Board.parse(input[1])}"
    @board.move(input[0], input[1], :queen)
  end

  def controlled_pieces(board, current_color)
    board.all_pieces.select {|piece| piece.color == current_color}
  end

  def random
    #sleep(1)
    valid_pieces = controlled_pieces(@board, @color).select do |piece|
      !piece.valid_moves.empty?
    end

    rand_piece = valid_pieces.sample
    start = rand_piece.pos
    end_pos = rand_piece.valid_moves.sample

    [start, end_pos]
  end

  def evaluate_ai_move(board=@board, eval_color=@color)
    max_score = -OVER_9000**2
    best_move = nil

    controlled_pieces(board, eval_color).each do |piece|
      piece.valid_moves.each do |move|
        duped = board.dup
        duped.move(piece.pos, move)
        score = evaluate_board(duped, eval_color)

        if score > max_score
          best_move = [piece.pos, move]
          max_score = score
        end
      end
    end

    best_move
  end

  def evaluate_ai_deeper
    max_score = -OVER_9000
    best_move = nil

    controlled_pieces(@board, @color).each do |piece|
      piece.valid_moves.each do |move|
        duped = board.dup
        duped.move(piece.pos, move)

        if duped.checkmate?(other_color(color))
          return [piece.pos, move]
        elsif !duped.over?(other_color(color))
          best_opponent_move = evaluate_ai_move(duped, other_color(color))
          duped.move(*best_opponent_move)
          score = evaluate_board(duped, color)
        else
          score = 0
        end

        if score > max_score
          best_move = [piece.pos, move]
          max_score = score
        end
      end
    end

    if best_move.nil?
      random
    else
      best_move
    end
  end

  def evaluate_pieces(board)
    score = 0.0

    board.all_pieces.each do |piece|
      material_value = case piece.type
      when :queen then 9.0
      when :rook then 5.0
      when :bishop then 3.0
      when :knight then 3.0
      when :pawn then 1.0
      when :king then 200.0
      end

      if piece.type == :queen
        movement_value = (piece.moves.count) * 0.06
      elsif piece.type == :pawn && piece.color == :white
        movement_value = (8 - piece.pos[0]) * 0.175
      elsif piece.type == :pawn && piece.color == :black
        movement_value = piece.pos[0] * 0.175
      else
        movement_value = piece.moves.count * 0.1
      end

      if piece.type == :knight && piece.pos[0].between?(2,5)
        movement_value += 0.8
      end

      if piece.color == color
        score += material_value + movement_value
      else
        score -= material_value + movement_value
      end
    end

    score
  end

  def evaluate_pawns(board)
    score = 0.0

    board.all_pieces.each do |piece|
      next unless piece.is_a?(Pawn)
      if piece.color == color
        score += doubled_pawn_score(piece, board)
        score += blocked_pawn_score(piece, board)
        score += isolated_pawn_score(piece, board)
      else
        score -= doubled_pawn_score(piece, board)
        score -= blocked_pawn_score(piece, board)
        score -= isolated_pawn_score(piece, board)
      end
    end

    score
  end

  def doubled_pawn_score(piece, board)
    col = piece.pos[1]

    1.upto(6) do |row|
      pos = [row, col]
      if pos != piece.pos && board[pos].is_a?(Pawn) && board[pos].color == color
        return -0.5
      end
    end

    0.0
  end

  def blocked_pawn_score(piece, board)
    if piece.valid_moves.count.zero?
      return -0.5
    end

    0.0
  end

  def isolated_pawn_score(piece, board)
    col = piece.pos[1]
    offset_files = [1, -1]
    if col == 0
      offset_files = [1]
    elsif col == 7
      offset_files = [-1]
    end

    offset_files.each do |file|
      1.upto(6) do |row|
        pos = [row, file]
        if board[pos].is_a?(Pawn) && board[pos].color == color
          return 0.0
        end
      end
    end

    -0.5
  end

  def evaluate_board(board, eval_color)
    if board.checkmate?(other_color(eval_color))
      return OVER_9000
    elsif board.checkmate?(eval_color)
      return -OVER_9000
    end

    score = evaluate_pieces(board)
    #score += 50 if board.in_check?(other_color(eval_color))
    score += evaluate_pawns(board)
    eval_color == color ? score : -score
  end
end
