require_relative 'piece.rb'
require_relative 'board.rb'

class Game

  def initialize
    @board = Board.standard_board
    @turn = :white
  end

  def run
    until @board.over?(@turn)
      puts @board.inspect
      begin
        puts "Please enter your move: (in the form of f2, f3)"
        input = gets.chomp.split(', ')

        @board.user_move(input[0], input[1], @turn)
      rescue ArgumentError => e
        puts "You did it wrong."
        puts "Error was: #{e.message}"
        retry
      end
      @turn = @turn == :white ? :black : :white
    end
  end

end
