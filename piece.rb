require_relative 'board.rb'

class Piece

  attr_reader :color, :type
  attr_accessor :pos

  def initialize(color, pos, type)
    @color = color
    @pos = pos
    @type = type
  end

  def place(board)
    @board = board
    board[@pos] = self
  end

  def moves
    raise NotImplementedError
  end

  def valid?(pos)
    @board.in_bounds?(pos) && @board.can_move_into?(color, pos)
  end

end
