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

  def in_bounds?(pos)
    pos[0].between?(0, 7) && pos[1].between?(0,7)
  end

  def can_move_into?(color, pos)
    self[pos].nil? || self[pos].color != color
  end

  def move(start, end_pos)
    piece = self[start]
    raise ArgumentError.new("No piece there") if piece.nil?
    if piece.moves.include?(end_pos)
      self[start] = nil
      self[end_pos] = piece
      piece.pos = end_pos
    else
      raise ArgumentError.new("Can't move there")
    end

    nil
  end

  def inspect
    board_str = ""

    8.times do |row|
      8.times do |col|
        piece = self[[row, col]]
        if piece.nil?
          board_str << "."
        else
          board_str << (piece.color == :white ? "w" : "b")
        end
      end
      board_str << "\n"
    end

    board_str
  end
end
