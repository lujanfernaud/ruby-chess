# Holds representation of the board.
class Board
  attr_accessor :grid
  attr_reader   :coordinates, :piece

  COORDINATES = { "a" => 0, "b" => 1, "c" => 2, "d" => 3,
                  "e" => 4, "f" => 5, "g" => 6, "h" => 7,
                  "1" => 7, "2" => 6, "3" => 5, "4" => 4,
                  "5" => 3, "6" => 2, "7" => 1, "8" => 0 }.freeze

  def initialize
    @grid = Array.new(8) { Array.new(8) { "-" } }
    @coordinates = COORDINATES
  end

  def move_piece(coords)
    from  = translate_coords(coords[0..1])
    to    = translate_coords(coords[2..3])
    piece = get_piece(from)

    return move_not_possible unless move_possible?(piece, from, to)

    remove_piece(from)
    place_piece(piece, to)
  end

  private

  def translate_coords(coords)
    letter = coordinates[coords[0]] # Represents column.
    number = coordinates[coords[1]] # Represents row.
    [number, letter]
  end

  def get_piece(coords)
    grid[coords[0]][coords[1]]
  end

  def remove_piece(from)
    grid[from[0]][from[1]] = "-"
  end

  def place_piece(piece, to)
    grid[to[0]][to[1]] = piece
  end

  def move_not_possible
    "The move is not possible."
  end

  def move_possible?(piece, from, to)
    # TODO
  end
end
