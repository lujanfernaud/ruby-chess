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
    return false if king.in_check? && piece_is_not_a_king

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
      [row, column] if valid_tresspassing_move?(row, column)
    end.compact
  end

  def update_position(to)
    @position = to
  end

  def can_be_promoted?(_to)
    false
  end

  def can_castle_to?(_side)
    false
  end

  def castling_destination(_side)
    false
  end

  def opponent_color
    color == :white ? :black : :white
  end

  def moved_two?
    moved_two
  end

  private

  def king
    select_king || NullPiece.new
  end

  def select_king
    @board.grid.flatten.select do |piece|
      piece.is_a?(King) && piece.color == color
    end.first
  end

  def piece_is_not_a_king
    self.class != King
  end

  def valid_move?(row, column)
    return false unless move_inside_board?(row, column)
    empty_path?(row, column) && not_player_piece_in?(row, column)
  end

  def valid_tresspassing_move?(row, column)
    return false unless move_inside_board?(row, column)
    empty_path_tresspassing?(row, column) && not_player_piece_in?(row, column)
  end

  def move_inside_board?(row, column)
    (0..7).cover?(row) && (0..7).cover?(column)
  end

  def empty_path?(row, column)
    Path.empty?(grid: @board.grid, piece: self, to: [row, column])
  end

  def empty_path_tresspassing?(row, column)
    Path.empty_tresspassing?(grid: @board.grid, piece: self, to: [row, column])
  end

  def not_player_piece_in?(row, column)
    opponent_in_square?(row, column) || empty_square?(row, column)
  end

  def opponent_in_square?(row, column)
    @board.grid[row][column].color == opponent_color
  end

  def empty_square?(row, column)
    @board.grid[row][column].color == :null
  end
end
