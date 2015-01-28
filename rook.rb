require_relative 'sliding_piece'

class Rook < SlidingPiece

  attr_accessor :castle_rights

  def initialize(color, pos, board)
    super(color, pos, :rook, board)

    @castle_rights = true
  end

end
