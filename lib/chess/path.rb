# Checks if there are no pieces from the origin to the destination.
class Path
  attr_reader :grid, :piece
  attr_reader :from_row, :to_row, :from_column, :to_column

  DIRECTIONS = { row:    { down:  1, up:   -1 },
                 column: { left: -1, right: 1 } }.freeze

  def self.empty?(grid:, piece:, to:)
    new(grid, piece, to).empty?
  end

  def self.empty_tresspassing?(grid:, piece:, to:)
    new(grid, piece, to).empty_tresspassing?
  end

  def initialize(grid, piece, to)
    @grid        = grid
    @piece       = piece
    @from_row    = piece.position[0]
    @from_column = piece.position[1]
    @to_row      = to[0]
    @to_column   = to[1]
    @path        = []
  end

  def empty?
    return true if piece.is_a?(Knight)

    add_directions_to_path
    add_diagonals_to_path
    check_path
  end

  def empty_tresspassing?
    return true if piece.is_a?(Knight)

    add_directions_to_path
    add_diagonals_to_path
    check_path_tresspassing
  end

  private

  attr_accessor :path

  def add_directions_to_path
    return add_columns_in_direction(:left)  if same_row && left
    return add_columns_in_direction(:right) if same_row && right
    return add_rows_in_direction(:up)       if same_column && up
    return add_rows_in_direction(:down)     if same_column && down
  end

  def add_diagonals_to_path
    return add_squares_in_diagonal(:down, :right) if down && right
    return add_squares_in_diagonal(:down, :left)  if down && left
    return add_squares_in_diagonal(:up, :right)   if up && right
    return add_squares_in_diagonal(:up, :left)    if up && left
  end

  def check_path
    available = proc do |position|
      empty_square_in?(position) || opponent_king_in?(position)
    end

    path.all?(&available)
  end

  def check_path_tresspassing
    available = proc do |position|
      empty_square_in?(position) || opponent_piece_in?(position)
    end

    path.all?(&available)
  end

  def empty_square_in?(position)
    piece_in(position).color == :null
  end

  def opponent_king_in?(position)
    piece_in(position).is_a?(King) &&
      piece_in(position).color == piece.opponent_color
  end

  def opponent_piece_in?(position)
    piece_in(position).color == piece.opponent_color
  end

  def piece_in(position)
    grid[position[0]][position[1]]
  end

  def same_row
    from_row == to_row
  end

  def same_column
    from_column == to_column
  end

  def left
    from_column > to_column
  end

  def right
    from_column < to_column
  end

  def up
    from_row > to_row
  end

  def down
    from_row < to_row
  end

  def add_columns_in_direction(direction)
    column_step = DIRECTIONS[:column][direction]

    from_column.step(to_column, column_step) do |column|
      next  if column == from_column
      break if column == to_column
      path << [to_row, column]
    end
  end

  def add_rows_in_direction(direction)
    row_step = DIRECTIONS[:row][direction]

    from_row.step(to_row, row_step) do |row|
      next  if row == from_row
      break if row == to_row
      path << [row, to_column]
    end
  end

  def add_squares_in_diagonal(row_direction, column_direction)
    row_step    = DIRECTIONS[:row][row_direction]
    column_step = DIRECTIONS[:column][column_direction]

    from_row.step(to_row, row_step) do |row|
      next  if row == from_row
      break if row == to_row
      from_column.step(to_column, column_step) do |column|
        next  if column == from_column
        break if column == to_column
        path << [row, column]
        column_step > 0 ? column_step += 1 : column_step -= 1
        break
      end
    end
  end
end
