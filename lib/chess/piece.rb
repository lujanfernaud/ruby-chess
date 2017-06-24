# Common attributes and behaviour for all pieces.
class Piece
  attr_reader   :color, :allowed_moves
  attr_accessor :location

  def initialize
    @color         = color
    @location      = []
    @allowed_moves = []
  end

  def allowed_move?(from, to)
    moves = allowed_moves.map do |move|
      row    = from[0] + move[0]
      column = from[1] + move[1]
      [row, column] if valid_move?(row, column)
    end

    moves.include?(to)
  end

  private

  def opponent_in_destination?(row, column, to)
    [row, column] == to && opponent_in_square?(row, column)
  end

  def opponent_in_square?(row, column)
    @board.grid[row][column].color == @opponent_color
  end

  def valid_move?(row, column)
    move_inside_board?(row, column) && not_player_piece?(row, column)
  end

  def not_player_piece?(row, column)
    @board.grid[row][column].color != @color
  end

  def move_inside_board?(row, column)
    (0..7).cover?(row) && (0..7).cover?(column)
  end
end
