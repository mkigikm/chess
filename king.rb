require_relative 'stepping_piece'

class King < SteppingPiece

  attr_accessor :castle_rights

  def initialize(color, pos, board)
    super(color, pos, :king, board)

    @castle_rights = true
  end

  def moves
    new_poses = super

    if castle_rights && !board.in_check?(color)
      rook_king_side = board[[pos[0], pos[1] + 3]]
      rook_queen_side = board[[pos[0], pos[1] - 4]]

      if rook_king_side.is_a?(Rook) && rook_king_side.castle_rights
        if rook_king_side.moves.include?([pos[0], pos[1] + 1])
          if !move_into_check?([pos[0], pos[1] + 1])
            new_poses << [pos[0], pos[1] + 2]
          end
        end
      end

      if rook_queen_side.is_a?(Rook) && rook_queen_side.castle_rights
        if rook_queen_side.moves.include?([pos[0], pos[1] - 1])
          if !move_into_check?([pos[0], pos[1] - 1])
            new_poses << [pos[0], pos[1] - 2]
          end
        end
      end
    end

    new_poses
  end
end
