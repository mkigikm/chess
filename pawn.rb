require_relative 'piece.rb'
require 'byebug'

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
  attr_accessor :can_move_twice

  def initialize(color, pos)
    super(color, pos, :pawn)

    @delta = DELTA[color]
    @attacks = ATTACK_DELTAS[color]
    @can_move_twice = true

    if color == :white
      @render = "♙"
    else
      @render = "♟"
    end
  end

  def moves
    new_poses = []

    forward_pos = [self.pos[0] + @delta[0], self.pos[1] + @delta[1]]
    new_poses << forward_pos if !@board.occupied?(forward_pos)

    if !@board.occupied?(forward_pos) && @can_move_twice
      double_pos = [self.pos[0] + @delta[0] * 2, self.pos[1] + @delta[1]]
      new_poses << double_pos if !@board.occupied?(double_pos)
    end

    @attacks.each do |attack|
      attack_pos = [self.pos[0] + attack[0], self.pos[1] + attack[1]]
      new_poses << attack_pos if valid?(attack_pos)
    end

    new_poses

  end

  def valid?(pos)
    @board.in_bounds?(pos) && @board.occupied_by_other_color?(pos, color)
  end
end
