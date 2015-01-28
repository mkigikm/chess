require 'colorize'

require_relative 'piece.rb'
require_relative 'sliding_piece.rb'
require_relative 'stepping_piece.rb'
require_relative 'king.rb'
require_relative 'rook.rb'
require_relative 'pawn.rb'
require_relative 'chess_error'

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
      Rook.new(color,  [row, 0], board)
      Rook.new(color,  [row, 7], board)
      SteppingPiece.new(color, [row, 1], :knight, board)
      SteppingPiece.new(color, [row, 6], :knight, board)
      SlidingPiece.new(color,  [row, 2], :bishop, board)
      SlidingPiece.new(color,  [row, 5], :bishop, board)
      SlidingPiece.new(color,  [row, 3], :queen, board)
      King.new(color, [row, 4], board)
    end

    8.times do |col|
      Pawn.new(:black, [1, col], board)
      Pawn.new(:white, [6, col], board)
    end

    board
  end

  def self.castle_board
    board = Board.new

    [[:white, 7], [:black, 0]].each do |(color, row)|
      Rook.new(color,  [row, 0], board)
      Rook.new(color,  [row, 7], board)
      SlidingPiece.new(color,  [row, 3], :queen, board)
      King.new(color, [row, 4], board)
    end

    board
  end

  def self.load_board(board_file)
    board_str = File.read(board_file)
    rows = board_str.split("\n")
    board = Board.new

    1.upto(8) do |row|
      1.upto(8) do |col|
        char = rows[row][col]
        pos = [row - 1, col - 1]
        case char
        when "♙" then Pawn.new(:white, pos, board)
        when "♟" then Pawn.new(:black, pos, board)
        when "♞" then SteppingPiece.new(:black, pos, :knight, board)
        when "♘" then SteppingPiece.new(:white, pos, :knight, board)
        when "♚" then SteppingPiece.new(:black, pos, :king, board)
        when "♔" then SteppingPiece.new(:white, pos, :king, board)
        when "♕" then SlidingPiece.new(:white,  pos, :queen, board)
        when "♛" then SlidingPiece.new(:black,  pos, :queen, board)
        when "♖" then SlidingPiece.new(:white,  pos, :rook, board)
        when "♜" then SlidingPiece.new(:black,  pos, :rook, board)
        when "♗" then SlidingPiece.new(:white,  pos, :bishop, board)
        when "♝" then SlidingPiece.new(:black,  pos, :bishop, board)
        end
      end
    end

    board
  end

  def self.translate(pos)
    if !(/^[a-h][1-8]$/ =~ pos)
      raise ChessError.new("Invalid coordinates")
    end

    row = 8 - pos[1].to_i
    col = COLUMN_TRANSLATION[pos[0]]

    [row, col]
  end

  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def []=(pos, piece)
    @grid[pos[0]][pos[1]] = piece
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def user_move(start, end_pos, turn_color)
    start, end_pos = Board.translate(start), Board.translate(end_pos)
    if self[start].color != turn_color
      raise ChessError.new("Not your piece.")
    end

    move(start, end_pos)
  end

  def move!(start, end_pos)
    self[end_pos] = self[start]
    self[start] = nil
    self[end_pos].pos = end_pos
  end

  def move(start, end_pos)
    piece = self[start]

    raise ChessError.new("No piece there") if piece.nil?
    if piece.valid_moves.include?(end_pos)
      if piece.is_a?(King) && (end_pos[1] - start[1]).abs != 1
        castle_move!(start, end_pos)
      else
        move!(start, end_pos)
      end
    else
      raise ChessError.new("Can't move there")
    end

    nil
  end

  def castle_move!(king_pos, end_pos)
    king = self[king_pos]

    if end_pos[1] == 6
      rook_pos = [king_pos[0], 7]
    else
      rook_pos = [king_pos[0], 0]
    end
    rook = self[rook_pos]

    if rook_pos[1] == 7 # king side castle
      king_end_pos = [king_pos[0], king_pos[1] + 2]
      rook_end_pos = [rook_pos[0], rook_pos[1] - 2]
    else
      king_end_pos = [king_pos[0], king_pos[1] - 2]
      rook_end_pos = [rook_pos[0], rook_pos[1] + 3]
    end

    move!(king_pos, king_end_pos)
    move!(rook_pos, rook_end_pos)
  end

  def dup
    duped = Board.new

    all_pieces.each do |piece|
      duped_piece = piece.dup
      duped_piece.board = duped
      duped[duped_piece.pos] = duped_piece
    end

    duped
  end

  def inspect
    board_str = "  a  b  c  d  e  f  g  h\n"

    bgcolor = :light_red

    8.times do |row|
      board_str << (8 - row).to_s
      bgcolor = bgcolor == :white ? :light_red : :white

      8.times do |col|
        piece = self[[row, col]]
        if piece.nil?
          board_str << "   ".colorize(:background => bgcolor)
        else
          board_str << " #{piece.render} ".colorize(:background => bgcolor)
        end

        bgcolor = bgcolor == :white ? :light_red : :white
      end

      board_str << "#{8 - row}\n"
    end

    board_str << "  a  b  c  d  e  f  g  h"
    board_str
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

  # used by the Piece class
  def in_bounds?(pos)
    pos.all? { |i| i.between?(0,7) }
  end

  def can_move_into?(color, pos)
    !occupied?(pos) || self[pos].color != color
  end

  def occupied?(pos)
    !self[pos].nil?
  end

  def occupied_by_other_color?(pos, color)
    !self[pos].nil? && self[pos].color != color
  end

  def all_pieces
    @grid.flatten.compact
  end
end
