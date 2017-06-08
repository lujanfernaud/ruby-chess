# Holds color, position and allowed moves for pawns.
class Pawn < Piece
  attr_accessor :position

  def initialize(color:, position:)
    @color    = color
    @position = position

    if color == :white
      set_allowed_moves_for_white
    else
      set_allowed_moves_for_black
    end
  end

  private

  def set_allowed_moves_for_white
    @allowed_moves = [[-1, 0], [-1, -1], [-1, 1]]
    @allowed_moves << [-2, 0] if initial_position_white
  end

  def set_allowed_moves_for_black
    @allowed_moves = [[1, 0], [1, 1], [1, -1]]
    @allowed_moves << [2, 0]  if initial_position_black
  end

  def initial_position_white
    initial_position = [[6, 0], [6, 1], [6, 2], [6, 3],
                        [6, 4], [6, 5], [6, 6], [6, 7]]
    initial_position.include?(position)
  end

  def initial_position_black
    initial_position = [[1, 0], [1, 1], [1, 2], [1, 3],
                        [1, 4], [1, 5], [1, 6], [1, 7]]
    initial_position.include?(position)
  end
end
