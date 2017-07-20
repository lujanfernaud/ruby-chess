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

  def valid_destinations
    []
  end

  def left_in_check?(_destination)
    false
  end

  def in_check?
    false
  end

  def moved_two?
    false
  end

  def to_s
    "·"
  end
end
