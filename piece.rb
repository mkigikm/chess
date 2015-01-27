# encoding: utf-8

require_relative 'board.rb'

class Piece

  attr_reader :color, :type
  attr_accessor :pos, :board

  def initialize(color, pos, type, board)
    @color = color
    @pos = pos
    @type = type
    @board = board
    board[@pos] = self
  end

  def moves
    raise NotImplementedError
  end

  def move_into_check?(pos)
    board_dup = board.dup

    board_dup.move!(@pos, pos)
    board_dup.in_check?(color)
  end

  def valid?(pos)
    @board.in_bounds?(pos) && @board.can_move_into?(color, pos)
  end

  def valid_moves
    moves.reject { |pos| move_into_check?(pos) }
  end


end
