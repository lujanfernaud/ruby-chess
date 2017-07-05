# Common attributes and behaviour for all pieces.
class Piece
  attr_reader :color, :position, :allowed_moves, :moved_two

  def initialize
    @color         = color
    @position      = []
    @allowed_moves = []
    @moved_two     = nil
  end

  def allowed_move?(to)
    valid_destinations.include?(to)
  end

  def valid_destinations
    allowed_moves.map do |move|
      row    = position[0] + move[0]
      column = position[1] + move[1]
      [row, column] if valid_move?(row, column)
    end.compact
  end

  def valid_destinations_tresspassing
    allowed_moves.map do |move|
      row    = position[0] + move[0]
      column = position[1] + move[1]
      [row, column] if move_inside_board?(row, column)
    end.compact
  end

  def update_position(to)
    @position = to
  end

  def moved_two?
    moved_two
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

  def move_inside_board?(row, column)
    (0..7).cover?(row) && (0..7).cover?(column)
  end

  def not_player_piece?(row, column)
    opponent_in_square(row, column) || empty_square?(row, column)
  end

  def opponent_in_square(row, column)
    @board.grid[row][column].color != @color
  end

  def empty_square?(row, column)
    @board.grid[row][column].color == :null
  end
end
