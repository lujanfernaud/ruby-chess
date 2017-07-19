# Holds color and allowed moves for kings.
class King < Piece
  INITIAL_POSITIONS  = [[0, 4], [7, 4]].freeze

  CASTLING_POSITIONS = { black: { queen_side: [[0, 2], [0, 3]],
                                  king_side:  [[0, 6], [0, 5]] },
                         white: { queen_side: [[7, 2], [7, 3]],
                                  king_side:  [[7, 6], [7, 5]] } }.freeze

  def initialize(color:, position:, board:)
    @color     = color
    @position  = position
    @board     = board
    @moved_two = false
    @allowed_moves = [[-1, 0], [-1, 1], [0, 1], [1, 1],
                      [1, 0], [1, -1], [0, -1], [-1, -1]]
  end

  def allowed_move?(to)
    add_castling_moves if initial_position?
    valid_destinations_not_into_check.include?(to)
  end

  def valid_destinations?
    !valid_destinations.empty?
  end

  def in_check?
    @board.last_moved_piece.allowed_move?(position)
  end

  def cannot_escape?
    escape_destinations = valid_destinations_tresspassing - opponent_destinations
    not_moving_into_check(escape_destinations).empty?
  end

  def can_castle_to?(side)
    return false unless initial_position? && side
    (castling_destinations(side) - opponent_destinations).size == 2
  end

  def castling_destination(side)
    return unless initial_position? && side
    CASTLING_POSITIONS[color][side].first
  end

  def to_s
    color == :black ? "k" : "K"
  end

  private

  def add_castling_moves
    @allowed_moves << [0, -2] << [0, 2]
  end

  def initial_position?
    INITIAL_POSITIONS.include?(position)
  end

  def valid_destinations_not_into_check
    not_moving_into_check(valid_destinations)
  end

  def not_moving_into_check(escape_destinations)
    escape_destinations.each_with_object [] do |destination, result|
      piece_from_destination = @board.grid[destination[0]][destination[1]]

      remove_piece_from(destination)
      result << destination unless opponent_destinations.include?(destination)
      place_back_to(destination, piece_from_destination)
    end
  end

  def remove_piece_from(destination)
    @board.grid[destination[0]][destination[1]] = NullPiece.new
  end

  def place_back_to(destination, piece_from_destination)
    @board.grid[destination[0]][destination[1]] = piece_from_destination
  end

  def opponent_destinations
    opponent_pieces.flat_map { |piece| piece.valid_destinations }
  end

  def opponent_pieces
    @board.grid.flatten.select { |piece| piece.color == opponent_color }
  end

  def castling_destinations(side)
    CASTLING_POSITIONS[color][side].map do |move|
      move if valid_move?(move[0], move[1])
    end.compact
  end
end
