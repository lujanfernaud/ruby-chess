# Holds color and allowed moves for rooks.
class Rook < Piece
  CASTLING_POSITIONS = { black: { queen_side: [0, 3],
                                  king_side:  [0, 5] },
                         white: { queen_side: [7, 3],
                                  king_side:  [7, 5] } }.freeze

  def initialize(color:, position:, board:)
    @color    = color
    @position = position
    @board    = board
    @moved    = false
    @allowed_moves = [[-7, 0], [0, 7], [7, 0], [0, -7],
                      [-6, 0], [0, 6], [6, 0], [0, -6],
                      [-5, 0], [0, 5], [5, 0], [0, -5],
                      [-4, 0], [0, 4], [4, 0], [0, -4],
                      [-3, 0], [0, 3], [3, 0], [0, -3],
                      [-2, 0], [0, 2], [2, 0], [0, -2],
                      [-1, 0], [0, 1], [1, 0], [0, -1]]
  end

  def update_position(to)
    super(to)
    @moved ||= true
  end

  def not_moved?
    !@moved
  end

  def castling_destination(side)
    CASTLING_POSITIONS[color][side]
  end

  def to_s
    color == :black ? "r" : "R"
  end
end
