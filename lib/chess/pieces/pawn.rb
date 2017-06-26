# Holds color, position and allowed moves for pawns.
class Pawn < Piece
  attr_reader :capturing_moves

  def initialize(color:, position:, board:)
    @color          = color
    @position       = position
    @board          = board
    @opponent_color = @color == :white ? :black : :white

    if color == :white
      set_allowed_moves_for_white
    else
      set_allowed_moves_for_black
    end
  end

  def allowed_move?(to)
    capturing_moves = prepare_capturing_moves(to)
    (capturing_moves + valid_destinations).include?(to)
  end

  private

  def prepare_capturing_moves(to)
    capturing_moves.map do |move|
      row    = position[0] + move[0]
      column = position[1] + move[1]
      [row, column] if opponent_in_destination?(row, column, to)
    end
  end

  def set_allowed_moves_for_white
    @allowed_moves = [[-1, 0]]
    @allowed_moves << [-2, 0] if initial_position_white
    @capturing_moves = [[-1, -1], [-1, 1]]
  end

  def set_allowed_moves_for_black
    @allowed_moves = [[1, 0]]
    @allowed_moves << [2, 0] if initial_position_black
    @capturing_moves = [[1, 1], [1, -1]]
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
