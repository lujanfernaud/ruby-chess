# Coordinates to match how rows and columns are named in the board
# to their positions in the grid.
#
# Letters represent columns and numbers represent rows.
#
# Examples:
#
# a1 == grid[7][0]
# a2 == grid[6][0]
# h7 == grid[1][7]
# h6 == grid[2][7]
#
module Coordinates
  COORDINATES = { "a" => 0, "b" => 1, "c" => 2, "d" => 3,
                  "e" => 4, "f" => 5, "g" => 6, "h" => 7,
                  "1" => 7, "2" => 6, "3" => 5, "4" => 4,
                  "5" => 3, "6" => 2, "7" => 1, "8" => 0 }.freeze

  def self.translate_to_numeric(coordinates)
    letter = COORDINATES[coordinates[0]]
    number = COORDINATES[coordinates[1]]

    [number, letter]
  end

  def self.translate_to_alphanumeric(coordinates)
    letter = COORDINATES.key(coordinates[1])
    number = COORDINATES.select { |_key, value| value == coordinates[0] }
                        .flatten.reverse[1]

    letter + number
  end
end
