require 'byebug'
require_relative 'piece.rb'
require_relative 'sliding_piece.rb'
require_relative 'stepping_piece.rb'
require_relative 'pawn.rb'

class Board

  COLUMN_TRANSLATION = {
    'a' => 0,
    'b' => 1,
    'c' => 2,
    'd' => 3,
    'e' => 4,
    'f' => 5,
    'g' => 6,
    'h' => 7
  }


  def self.standard_board
    board = Board.new

    [[:white, 7], [:black, 0]].each do |(color, row)|
      SlidingPiece.new(color,  [row, 0], :rook).place(board)
      SlidingPiece.new(color,  [row, 7], :rook).place(board)
      SteppingPiece.new(color, [row, 1], :knight).place(board)
      SteppingPiece.new(color, [row, 6], :knight).place(board)
      SlidingPiece.new(color,  [row, 2], :bishop).place(board)
      SlidingPiece.new(color,  [row, 5], :bishop).place(board)
      SlidingPiece.new(color,  [row, 3], :queen).place(board)
      SteppingPiece.new(color, [row, 4], :king).place(board)
    end

    8.times do |col|
      Pawn.new(:black, [1, col]).place(board)
      Pawn.new(:white, [6, col]).place(board)
    end

    board
  end

  def self.translate(pos)
    if !(/^[a-h][1-8]$/ =~ pos)
      raise ArgumentError.new("Invalid coordinates")
    end
    
    row = 8 - pos[1].to_i
    col = COLUMN_TRANSLATION[pos[0]]

    [row, col]
  end

  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) {nil}}
  end

  def []=(pos, piece)
    @grid[pos[0]][pos[1]] = piece
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def in_bounds?(pos)
    pos[0].between?(0, 7) && pos[1].between?(0,7)
  end

  def can_move_into?(color, pos)
    self[pos].nil? || self[pos].color != color
  end

  def occupied?(pos)
    !self[pos].nil?
  end

  def occupied_by_other_color?(pos, color)
    !self[pos].nil? && self[pos].color != color
  end

  def user_move(start, end_pos, turn_color)
    start, end_pos = Board.translate(start), Board.translate(end_pos)
    if self[start].color != turn_color
      raise ArgumentError.new("Not your piece.")
    end

    move(start, end_pos)
  end

  def move(start, end_pos)
    #debugger
    piece = self[start]

    raise ArgumentError.new("No piece there") if piece.nil?
    if piece.valid_moves.include?(end_pos)
      self[start] = nil
      self[end_pos] = piece
      piece.pos = end_pos

      if piece.class == Pawn
        piece.can_move_twice = false
      end
    else
      raise ArgumentError.new("Can't move there")
    end

    nil
  end

  def move!(start, end_pos)
    self[end_pos] = self[start]
    self[start] = nil
    self[end_pos].pos = end_pos
  end

  def inspect
    board_str = ""

    8.times do |row|
      8.times do |col|
        piece = self[[row, col]]
        if piece.nil?
          board_str << "."
        else
          board_str << piece.render
        end
      end

      board_str << "\n"
    end

    board_str
  end

  def all_pieces
    @grid.flatten.compact
  end

  def in_check?(color)
    pieces = all_pieces

    king = pieces.find do |piece|
      piece.type == :king && piece.color == color
    end

    pieces.any? do |piece|
      piece.color != color && piece.moves.include?(king.pos)
    end
  end

  def over?(color)
    pieces = all_pieces.select { |piece| piece.color == color}


    pieces.all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def checkmate?(color)
    over?(color) && in_check?(color)
  end

end
