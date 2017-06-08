# Holds color and allowed moves for rooks.
class Rook < Piece
  def initialize(color:)
    @color = color
    @allowed_moves = [[-7, 0], [0, 7], [7, 0], [0, -7]]
  end
end
