# Holds representation of the board.
class Board
  include Coordinates

  attr_reader :grid, :coordinates, :piece

  def initialize
    @grid = []
    set_board
    @coordinates = COORDINATES
  end

  def move_piece(coords)
    from  = translate_coords(coords[0..1])
    to    = translate_coords(coords[2..3])
    piece = get_piece(from)

    return move_not_possible unless move_possible?(piece, from, to)
    return pieces_in_between unless empty_path?(piece, from, to)

    remove_piece(from)
    place_piece(piece, to)
  end

  private

  attr_writer :grid

  def set_board
    add_royal_row(:black)
    add_pawn_row(:black, 1)
    add_empty_rows
    add_pawn_row(:white, 6)
    add_royal_row(:white)
  end

  def add_royal_row(color)
    @grid << [Rook.new(color: color, board: self),
              Knight.new(color: color, board: self),
              Bishop.new(color: color, board: self),
              King.new(color: color, board: self),
              Queen.new(color: color, board: self),
              Bishop.new(color: color, board: self),
              Knight.new(color: color, board: self),
              Rook.new(color: color, board: self)]
  end

  def add_pawn_row(color, row)
    @grid << [Pawn.new(color: color, position: [row, 0], board: self),
              Pawn.new(color: color, position: [row, 1], board: self),
              Pawn.new(color: color, position: [row, 2], board: self),
              Pawn.new(color: color, position: [row, 3], board: self),
              Pawn.new(color: color, position: [row, 4], board: self),
              Pawn.new(color: color, position: [row, 5], board: self),
              Pawn.new(color: color, position: [row, 6], board: self),
              Pawn.new(color: color, position: [row, 7], board: self)]
  end

  def add_empty_rows
    4.times { @grid << %w[- - - - - - - -] }
  end

  # Translates coordinates as expressed in the board
  # to their positions in the grid.
  # Letter represents column and number represents row.
  # Example: "a2" would be translated as [6, 0]

  def translate_coords(coords)
    letter = coordinates[coords[0]]
    number = coordinates[coords[1]]
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
    piece.allowed_move?(from, to)
  end

  def pieces_in_between
    "There are pieces in between."
  end

  def empty_path?(piece, from, to)
    return true if piece.is_a?(Knight)

    from_row    = from[0]
    from_column = from[1]
    to_row      = to[0]
    to_column   = to[1]
    way         = []

    if from_row == to_row && from_column > to_column
      from_column.step(to_column, -1) do |column|
        next if column == from_column
        way << [to_row, column]
      end
    elsif from_row == to_row && from_column < to_column
      from_column.step(to_column, 1) do |column|
        next if column == from_column
        way << [to_row, column]
      end
    elsif from_column == to_column && from_row > to_row
      from_row.step(to_row, -1) do |row|
        next if row == from_row
        way << [row, to_column]
      end
    elsif from_column == to_column && from_row < to_row
      from_row.step(to_row, 1) do |row|
        next if row == from_row
        way << [row, to_column]
      end
    elsif from_row < to_row && from_column < to_column
      from_row.step(to_row, 1) do |row|
        next if row == from_row
        from_column.step(to_column, 1) do |column|
          next if column == from_column
          way << [row, column]
        end
      end
    elsif from_row < to_row && from_column > to_column
      from_row.step(to_row, 1) do |row|
        next if row == from_row
        from_column.step(to_column, -1) do |column|
          next if column == from_column
          way << [row, column]
        end
      end
    elsif from_row > to_row && from_column < to_column
      from_row.step(to_row, -1) do |row|
        next if row == from_row
        from_column.step(to_column, 1) do |column|
          next if column == from_column
          way << [row, column]
        end
      end
    elsif from_row > to_row && from_column > to_column
      from_row.step(to_row, -1) do |row|
        next if row == from_row
        from_column.step(to_column, -1) do |column|
          next if column == from_column
          way << [row, column]
        end
      end
    end

    empty = proc { |square| grid[square[0]][square[1]] == "-" }

    way[0..-2].all?(&empty)
  end
end
