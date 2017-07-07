# Acts as a null object.
class NullPiece
  attr_reader :color, :moved_two, :to_s

  def initialize
    @color     = :null
    @moved_two = nil
  end

  def allowed_move?(_argument)
    false
  end

  def moved_two?
    false
  end

  def to_s
    "·"
  end
end
