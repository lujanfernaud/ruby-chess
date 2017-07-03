# Holds color and allowed moves for bishops.
class Bishop < Piece
  def initialize(color:, position:, board:)
    @color    = color
    @position = position
    @board    = board
    @allowed_moves = [[-7, 7], [-7, -7], [7, 7], [7, -7],
                      [-6, 6], [-6, -6], [6, 6], [6, -6],
                      [-5, 5], [-5, -5], [5, 5], [5, -5],
                      [-4, 4], [-4, -4], [4, 4], [4, -4],
                      [-3, 3], [-3, -3], [3, 3], [3, -3],
                      [-2, 2], [-2, -2], [2, 2], [2, -2],
                      [-1, 1], [-1, -1], [1, 1], [1, -1]]
  end

  def to_s
    color == :black ? "b" : "B"
  end
end
