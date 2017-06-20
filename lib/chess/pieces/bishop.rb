# Holds color and allowed moves for bishops.
class Bishop < Piece
  def initialize(color:, board:)
    @color = color
    @board = board
    @allowed_moves = [[-7, 7], [-7, -7], [7, 7], [7, -7],
                      [-6, 6], [-6, -6], [6, 6], [6, -6],
                      [-5, 5], [-5, -5], [5, 5], [5, -5],
                      [-4, 4], [-4, -4], [4, 4], [4, -4],
                      [-3, 3], [-3, -3], [3, 3], [3, -3],
                      [-2, 2], [-2, -2], [2, 2], [2, -2],
                      [-1, 1], [-1, -1], [1, 1], [1, -1]]
  end
end
