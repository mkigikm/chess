require_relative 'board.rb'

class Piece

  attr_reader :color, :pos

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
end
