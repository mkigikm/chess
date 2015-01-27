require_relative 'board'
require 'byebug'

class Computer
  attr_accessor :board, :color

  def get_move
    random
  end

  def make_move(input, color)
    p input
    @board.move(input[0], input[1])
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
end
