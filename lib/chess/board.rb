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
    @last_moved_piece = NullPiece.new
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
    add_royal_row(color: :black, row: 0)
    add_pawn_row(color: :black, row: 1)
    add_empty_rows
    add_pawn_row(color: :white, row: 6)
    add_royal_row(color: :white, row: 7)
  end

  def add_royal_row(color:, row:)
    royal_row = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    add_pieces_for(royal_row, color, row)
  end

  def add_pawn_row(color:, row:)
    pawn_row = Array.new(8) { Pawn }
    add_pieces_for(pawn_row, color, row)
  end

  def add_pieces_for(pieces_row, color, row)
    @grid << pieces_row.map.with_index do |piece, index|
      piece.new(color: color, position: [row, index], board: self)
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

  def get_piece(from)
    row    = from[0]
    column = from[1]

    grid[row][column]
  end

  def remove_piece(from)
    row    = from[0]
    column = from[1]

    grid[row][column] = NullPiece.new
  end

  def place_piece(piece, to)
    row    = to[0]
    column = to[1]

    grid[row][column] = piece
    @last_moved_piece = piece
    piece.position    = to
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
    move_possible?(@last_moved_piece, @last_moved_piece.position, king_position)
  end

  def king_position
    king = @last_moved_piece.color == :black ? white_king : black_king
    king.position
  end
end
