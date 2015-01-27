require_relative 'board'

class Human
  attr_accessor :board

  def get_move
    puts "Please enter your move: (in the form of f2, f3)"
    gets.chomp.split(', ')
  end

  def make_move(input, color)
    @board.user_move(input[0], input[1], color)
  end
end
