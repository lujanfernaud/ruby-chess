# Holds color and allowed moves for rooks.
class Rook < Piece
  def initialize(color:, position:, board:)
    @color    = color
    @position = position
    @board    = board
    @allowed_moves = [[-7, 0], [0, 7], [7, 0], [0, -7],
                      [-6, 0], [0, 6], [6, 0], [0, -6],
                      [-5, 0], [0, 5], [5, 0], [0, -5],
                      [-4, 0], [0, 4], [4, 0], [0, -4],
                      [-3, 0], [0, 3], [3, 0], [0, -3],
                      [-2, 0], [0, 2], [2, 0], [0, -2],
                      [-1, 0], [0, 1], [1, 0], [0, -1]]
  end

  def to_s
    color == :black ? "r" : "R"
  end
end
