# Holds color, position and allowed moves for pawns.
class Pawn < Piece
  attr_reader :capturing_moves

  INITIAL_POSITION = { black: [[1, 0], [1, 1], [1, 2], [1, 3],
                               [1, 4], [1, 5], [1, 6], [1, 7]],
                       white: [[6, 0], [6, 1], [6, 2], [6, 3],
                               [6, 4], [6, 5], [6, 6], [6, 7]] }.freeze

  def initialize(color:, position:, board:)
    @color          = color
    @position       = position
    @allowed_moves  = []
    @board          = board
    @opponent_color = @color == :white ? :black : :white
    @moved_two      = false
  end

  def allowed_move?(to)
    prepare_allowed_moves
    capturing_moves = prepare_capturing_moves(to)
    (capturing_moves + valid_destinations).include?(to)
  end

  def update_position(to)
    @moved_two = move_two_from_initial?(to) ? true : false
    @position  = to
  end

  def to_s
    color == :black ? "p" : "P"
  end

  private

  def prepare_allowed_moves
    if color == :white
      set_allowed_moves_for_white
    else
      set_allowed_moves_for_black
    end
  end

  def set_allowed_moves_for_white
    @allowed_moves = []
    @allowed_moves << [-1, 0] if empty_position?(-1)
    @allowed_moves << [-2, 0] if initial_position? && empty_position?(-2)
    @capturing_moves = [[-1, -1], [-1, 1]]
  end

  def set_allowed_moves_for_black
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
    INITIAL_POSITION[color].include?(position)
  end

  def prepare_capturing_moves(to)
    capturing_moves.map do |move|
      row    = position[0] + move[0]
      column = position[1] + move[1]
      [row, column] if valid_capture?(row, column, to)
    end
  end

  def valid_capture?(row, column, to)
    opponent_in_destination?(row, column, to) || en_passant?(to)
  end

  def en_passant?(to)
    column = to[1]
    piece  = @board.grid[position[0]][column]

    return false unless empty_square?(to[0], column)

    piece.moved_two && @board.en_passant
  end

  def move_two_from_initial?(to)
    initial_position? && two_squares?(to)
  end

  def two_squares?(to)
    (to[0] - position[0]).abs == 2
  end
end
