# Acts as a null object.
class NullPiece
  attr_reader :color, :moved_two, :to_s

  def initialize
    @color     = :null
    @moved_two = nil
  end

  def to_s
    "-"
  end
end
