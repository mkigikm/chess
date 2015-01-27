require_relative 'piece.rb'

class SteppingPiece < Piece
  def initialize(color, pos, deltas)
    super(color, pos)

    @deltas = deltas
  end

  def moves
    new_poses = []

    possible_pos = @deltas.collect do |delta|
      new_pos = [pos[0] + delta[0], pos[1] + delta[1]]
      new_poses << new_pos if @board.in_bounds?(new_pos)
    end

    new_poses
  end
end
