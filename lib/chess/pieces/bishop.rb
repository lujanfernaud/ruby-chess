# Holds color and allowed moves for bishops.
class Bishop < Piece
  def initialize(color:)
    @color = color
    @allowed_moves = [[-7, 7], [-7, -7], [7, 7], [7, -7]]
  end
end
