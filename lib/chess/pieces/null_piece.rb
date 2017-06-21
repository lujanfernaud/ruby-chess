# Acts as a null object.
class NullPiece
  attr_reader :color, :to_s

  def initialize
    @color = :null
  end

  def to_s
    "-"
  end
end
