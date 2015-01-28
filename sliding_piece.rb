# encoding: utf-8

require_relative 'piece.rb'

class SlidingPiece < Piece

  DELTAS = {
    queen: [[0, 1], [1, 0], [0, -1], [-1, 0],
    [1, 1], [1, -1], [-1, -1], [-1, 1]],
    bishop: [[1, 1], [1, -1], [-1, -1], [-1, 1]],
    rook: [[1, 0], [0, 1], [-1, 0], [0, -1]]
  }

  attr_reader :render, :castle_rights

  def initialize(color, pos, type, board)
    super

    @deltas = DELTAS[type]

    if type == :queen && color == :white
      @render = "♕"
    elsif type == :queen && color == :black
      @render = "♛"
    elsif type == :bishop && color == :white
      @render = "♗"
    elsif type == :bishop && color == :black
      @render = "♝"
    elsif type == :rook && color == :white
      @render = "♖"
    else
      @render = "♜"
    end

    if type == :rook
      @castle_rights = true
    end
  end

  def moves
    new_poses = []

    @deltas.each do |delta|
      (1..7).each do |multiple|
        new_pos = [pos[0] + delta[0] * multiple,
                   pos[1] + delta[1] * multiple]
        if valid?(new_pos)
          new_poses << new_pos
        end
        if !@board.in_bounds?(new_pos) || @board.occupied?(new_pos)
          break
        end
      end
    end

    new_poses
  end

end
