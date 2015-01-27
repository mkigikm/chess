require_relative 'board.rb'

class Piece

  attr_reader :color
  attr_accessor :pos

  def initialize(color, pos)
    @color = color
    @pos = pos
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
