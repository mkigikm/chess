class Board

  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) {nil}}
  end

  def []=(pos, piece)
    @grid[pos[0]][pos[1]] = piece
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

end
