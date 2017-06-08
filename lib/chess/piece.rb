# Common attributes and behaviour for all pieces.
class Piece
  attr_reader :color, :allowed_moves

  def initialize
    @color = color
    @allowed_moves = []
  end
end
