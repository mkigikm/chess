require_relative 'board'

class Human
  attr_accessor :board, :color

  def get_move
    puts "Please enter your move: (in the form of f2, f3)"
    puts "If promoting pawn, give a third argument (Q, R, N, or B)."
    gets.chomp.split(', ')
  end

  def make_move(input, color)
    @board.user_move(input[0], input[1], input[2], color)
  end
end
