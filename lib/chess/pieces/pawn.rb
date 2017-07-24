# Holds color, position and allowed moves for pawns.
class Pawn < Piece
  attr_reader :capturing_moves

  INITIAL_POSITIONS   = { black: [[1, 0], [1, 1], [1, 2], [1, 3],
                                  [1, 4], [1, 5], [1, 6], [1, 7]],
                          white: [[6, 0], [6, 1], [6, 2], [6, 3],
                                  [6, 4], [6, 5], [6, 6], [6, 7]] }.freeze

  PROMOTION_POSITIONS = { black: [[7, 0], [7, 1], [7, 2], [7, 3],
                                  [7, 4], [7, 5], [7, 6], [7, 7]],
                          white: [[0, 0], [0, 1], [0, 2], [0, 3],
                                  [0, 4], [0, 5], [0, 6], [0, 7]] }.freeze

  def initialize(color:, position:, board:)
    @color         = color
    @position      = position
    @board         = board
    @allowed_moves = []
    @moved_two     = false
  end

  def valid_destinations
    prepare_moves
    valid_moves + valid_capturing_moves
  end

  def can_be_promoted?(to)
    PROMOTION_POSITIONS[color].include?(to)
  end

  def update_position(to)
    @moved_two = move_two_from_initial?(to) ? true : false
    @position  = to
  end

  def to_s
    color == :black ? "p" : "P"
  end

  private

  def prepare_moves
    color == :white ? set_moves_for_white : set_moves_for_black
  end

  def set_moves_for_white
    @allowed_moves = []
    @allowed_moves << [-1, 0] if empty_position?(-1)
    @allowed_moves << [-2, 0] if initial_position? && empty_position?(-2)
    @capturing_moves = [[-1, -1], [-1, 1]]
  end

  def set_moves_for_black
    @allowed_moves = []
    @allowed_moves << [1, 0] if empty_position?(1)
    @allowed_moves << [2, 0] if initial_position? && empty_position?(2)
    @capturing_moves = [[1, 1], [1, -1]]
  end

  def empty_position?(destination)
    row    = position[0] + destination
    column = position[1]

    empty_square?(row, column)
  end

  def initial_position?
    INITIAL_POSITIONS[color].include?(position)
  end

  def valid_moves
    allowed_moves.map do |move|
      row    = position[0] + move[0]
      column = position[1] + move[1]
      [row, column] if valid_move?(row, column)
    end.compact
  end

  def valid_capturing_moves
    capturing_moves.map do |move|
      row    = position[0] + move[0]
      column = position[1] + move[1]
      [row, column] if valid_capture?(row, column)
    end.compact
  end

  def valid_capture?(row, column)
    return false unless move_inside_board?(row, column)

    opponent_in_square?(row, column) || en_passant?(row, column)
  end

  def en_passant?(row, column)
    piece = @board.grid[position[0]][column]

    return false unless empty_square?(row, column)

    piece.moved_two? && @board.en_passant == piece
  end

  def move_two_from_initial?(to)
    initial_position? && two_squares?(to)
  end

  def two_squares?(to)
    (to[0] - position[0]).abs == 2
  end
end
