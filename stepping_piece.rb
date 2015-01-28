# encoding: utf-8

require_relative 'piece.rb'

class SteppingPiece < Piece

  DELTAS = {
    king: [[0, 1], [1, 0], [0, -1], [-1, 0],
    [1, 1], [1, -1], [-1, -1], [-1, 1]],
    knight: [[2, 1], [2, -1], [1, 2], [1, -2],
    [-2, 1], [-2, -1], [-1, 2], [-1, -2]]
  }

  attr_reader :render

  def initialize(color, pos, type, board)
    super

    @deltas = DELTAS[type]
    if type == :king && color == :white
      @render = "♔"
    elsif type == :king && color == :black
      @render = "♚"
    elsif type == :knight && color == :white
      @render = "♘"
    else
      @render = "♞"
    end

    if type == :king
      @castle_rights = true
    end
  end

  def moves
    new_poses = []

    @deltas.each do |delta|
      new_pos = [pos[0] + delta[0], pos[1] + delta[1]]
      if valid?(new_pos)
        new_poses << new_pos
      end
    end
    

    new_poses
  end

end
