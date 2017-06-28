# Holds color and allowed moves for kings.
class King < Piece
  def initialize(color:, position:, board:)
    @color    = color
    @position = position
    @board    = board
    @allowed_moves = [[-1, 0], [-1, 1], [0, 1], [1, 1],
                      [1, 0], [-1, 1], [0, -1], [-1, -1]]
  end

  def cannot_escape?(pieces)
    pieces_destinations = pieces.flat_map { |piece| piece.valid_destinations }
    escape_destinations = valid_destinations - pieces_destinations
    escape_destinations.empty?
  end
end
