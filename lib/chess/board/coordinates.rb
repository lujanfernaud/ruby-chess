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

module Coordinates
  COORDINATES = { "a" => 0, "b" => 1, "c" => 2, "d" => 3,
                  "e" => 4, "f" => 5, "g" => 6, "h" => 7,
                  "1" => 7, "2" => 6, "3" => 5, "4" => 4,
                  "5" => 3, "6" => 2, "7" => 1, "8" => 0 }.freeze
end
