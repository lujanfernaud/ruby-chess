# Common attributes and behaviour for all pieces.
class Piece
  attr_reader :color, :allowed_moves

  def initialize
    @color = color
    @allowed_moves = []
  end

  def allowed_move?(from, to)
    moves = allowed_moves.map do |move|
      row    = from[0] + move[0]
      column = from[1] + move[1]
      [row, column] if move_inside_board?(row, column)
    end

    moves.include?(to)
  end

  private

  def move_inside_board?(row, column)
    (0..7).cover?(row) && (0..7).cover?(column)
  end
end
