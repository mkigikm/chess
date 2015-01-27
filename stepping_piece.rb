require_relative 'piece.rb'

class SteppingPiece < Piece
  DELTAS = {
    king: [[0, 1], [1, 0], [0, -1], [-1, 0],
    [1, 1], [1, -1], [-1, -1], [-1, 1]],
    knight: [[2, 1], [2, -1], [1, 2], [1, -2],
    [-2, 1], [-2, -1], [-1, 2], [-1, -2]]
  }

  def initialize(color, pos, type)
    super(color, pos)

    @deltas = DELTAS[type]
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
