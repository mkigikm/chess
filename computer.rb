require_relative 'board'
require 'byebug'

class Computer
  OVER_9000 = 9_001

  attr_accessor :board, :color

  def initialize(eval_method)
    @eval_method = eval_method
  end

  def get_move
    send(@eval_method)
  end

  def make_move(input, color)
    p input
    @board.move(input[0], input[1], :queen)
  end

  def controlled_pieces
    @board.all_pieces.select {|piece| piece.color == color}
  end

  def random
    valid_pieces = controlled_pieces.select do |piece|
      !piece.valid_moves.empty?
    end

    rand_piece = valid_pieces.sample
    start = rand_piece.pos
    end_pos = rand_piece.valid_moves.sample

    [start, end_pos]
  end

  def evaluate_ai_move
    max_score = -OVER_9000
    best_move = nil

    controlled_pieces.each do |piece|
      piece.valid_moves.each do |move|
        duped = board.dup
        duped.move(piece.pos, move)
        score = evaluate_board(duped)

        if score > max_score
          best_move = [piece.pos, move]
          max_score = score
        end
      end
    end

    best_move
  end

  def evaluate_pieces(board)
    score = 0.0

    board.all_pieces.each do |piece|
      material_value = case piece.type
      when :queen then 9
      when :rook then 5
      when :bishop then 3
      when :knight then 3
      when :pawn then 1
      when :king then 200
      end

      movement_value = piece.moves.count * 0.1
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

  def evaluate_board(board)
    other_color = color == :white ? :black : :white

    if board.checkmate?(other_color)
      return OVER_9000
    end

    score = evaluate_pieces(board)
    #score += 50 if board.in_check?(other_color)
    score + evaluate_pawns(board)
  end
end
