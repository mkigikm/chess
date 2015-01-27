# encoding: utf-8

require_relative 'board.rb'
require_relative 'piece.rb'
require_relative 'sliding_piece.rb'
require_relative 'stepping_piece.rb'
require_relative 'pawn.rb'
require_relative 'human.rb'
require_relative 'chess_error.rb'


class Game

  def initialize(white_player, black_player)
    @board = Board.standard_board
    @turn = :white

    @white_player = white_player
    @black_player = black_player
    @white_player.board = @board
    @black_player.board = @board
  end

  def run
    current_player = @white_player
    until @board.over?(@turn)
      puts @board.inspect
      begin
        input = current_player.get_move
        current_player.make_move(input, @turn)
      rescue ChessError => e
        puts "You did it wrong."
        puts "Error was: #{e.message}"
        retry
      end
      current_player = current_player == @white_player ? @black_player : @white_player
      @turn = @turn == :white ? :black : :white
    end

    if @board.checkmate?(:white)
      puts "This is the white player (ノ ゜Д゜)ノ ︵ ┻━┻ ."
    elsif @board.checkmate?(:black)
      puts "This is the black player (ノ ゜Д゜)ノ ︵ ┻━┻ ."
    else
      puts "wow, a tie"
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  human1 = Human.new
  human2 = Human.new
  Game.new(human1, human2).run
end
