# encoding: utf-8

require_relative 'piece.rb'
require_relative 'stepping_piece.rb'
require_relative 'sliding_piece.rb'
require_relative 'rook.rb'

class Pawn < Piece

  DELTA = {
    white: [-1, 0],
    black: [1, 0]
  }

  ATTACK_DELTAS = {
    white: [[-1, 1], [-1, -1]],
    black: [[1, 1], [1, -1]]
  }

  attr_reader :render

  def initialize(color, pos, board)
    super(color, pos, :pawn, board)

    @delta = DELTA[color]
    @attacks = ATTACK_DELTAS[color]
    @can_move_twice = true

    if color == :white
      @render = "♙"
    else
      @render = "♟"
    end
  end

  def can_move_twice?
    (color == :black && pos[0] == 1) ||
      (color == :white && pos[0] == 6)
  end

  def moves
    new_poses = []

    return [] if pos[0] == 0 || pos[0] == 7

    forward_pos = [self.pos[0] + @delta[0], self.pos[1] + @delta[1]]
    new_poses << forward_pos if !@board.occupied?(forward_pos)

    if can_move_twice? && !@board.occupied?(forward_pos)
      double_pos = [self.pos[0] + @delta[0] * 2, self.pos[1] + @delta[1]]
      new_poses << double_pos if !@board.occupied?(double_pos)
    end

    @attacks.each do |attack|
      attack_pos = [self.pos[0] + attack[0], self.pos[1] + attack[1]]
      new_poses << attack_pos if attacking_valid?(attack_pos)
    end

    new_poses
  end

  def promote(promotion_rank)
    case promotion_rank
    when :queen then SlidingPiece.new(color, pos, :queen, board)
    when :rook then Rook.new(color, pos, board)
    when :bishop then SlidingPiece.new(color, pos, :bishop, board)
    when :knight then SteppingPiece.new(color, pos, :knight, board)
    end
  end

  protected
  def attacking_valid?(pos)
    @board.in_bounds?(pos) && @board.occupied_by_other_color?(pos, color)
  end

end
