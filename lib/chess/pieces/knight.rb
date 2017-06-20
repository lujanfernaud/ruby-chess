# Holds color and allowed moves for knights.
class Knight < Piece
  def initialize(color:, board:)
    @color = color
    @board = board
    @allowed_moves = [[-2,  1], [-1,  2], [1,  2], [2,  1],
                      [-2, -1], [-1, -2], [1, -2], [2, -1]]
  end
end
