# Holds representation of the board.
class Board
  include Coordinates

  attr_reader :grid, :coordinates
  attr_reader :black_king, :white_king

  def initialize
    @grid = []
    set_board
    @coordinates = COORDINATES
    @black_king  = grid[0][4]
    @white_king  = grid[7][4]
    @last_moved_position = nil
    @last_moved_piece    = NullPiece.new
  end

  def move_piece(coords)
    from  = translate_coords(coords[0..1])
    to    = translate_coords(coords[2..3])
    piece = get_piece(from)

    return move_not_possible unless move_possible?(piece, from, to)
    return pieces_in_between unless empty_path?(piece, from, to)

    remove_piece(from)
    place_piece(piece, to)

    return king_in_check if king_in_check?
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
    royal_row = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    @grid << royal_row.map { |piece| piece.new(color: color, board: self) }
  end

  def add_pawn_row(color, row)
    pawn_row = Array.new(8) { Pawn }
    @grid << pawn_row.map.with_index do |pawn, index|
      pawn.new(color: color, position: [row, index], board: self)
    end
  end

  def add_empty_rows
    4.times { @grid << Array.new(8) { NullPiece.new } }
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
    grid[from[0]][from[1]] = NullPiece.new
  end

  def place_piece(piece, to)
    grid[to[0]][to[1]]   = piece
    @last_moved_position = to
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
    PathChecker.new(grid, piece, from, to).empty_path?
  end

  def king_in_check
    "Check."
  end

  def king_in_check?
    move_possible?(last_moved_piece, @last_moved_position, king_position)
  end

  def last_moved_piece
    @last_moved_piece = grid[@last_moved_position[0]][@last_moved_position[1]]
  end

  def king_position
    king = @last_moved_piece.color == :black ? white_king : black_king
    row  = grid.detect { |line| line.include?(king) }
    [grid.index(row), row.index(king)]
  end
end
