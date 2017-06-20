# Holds color and allowed moves for kings.
class King < Piece
  def initialize(color:, board:)
    @color = color
    @board = board
    @allowed_moves = [[-1, 0], [-1, 1], [0, 1], [1, 1],
                      [1, 0], [-1, 1], [0, -1], [-1, -1]]
  end
end
