# Holds color and allowed moves for queens.
class Queen < Piece
  def initialize(color:)
    @color = color
    @allowed_moves = [[-7, 0], [-7, 7], [0, 7], [7, 7],
                      [7, 0], [-7, 7], [0, -7], [-7, -7]]
  end
end
