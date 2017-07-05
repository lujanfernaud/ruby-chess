# Holds representation of the board.
class Board
  include Coordinates

  attr_reader :grid, :screen, :coordinates, :en_passant
  attr_reader :current_player, :current_piece

  def initialize
    @grid = []
    set_board
    @screen           = Screen.new(self)
    @coordinates      = COORDINATES
    @current_player   = nil
    @current_piece    = nil
    @last_moved_piece = NullPiece.new
    @en_passant       = false
  end

  def move_piece(player, coords)
    from = translate_coords(coords[0..1])
    to   = translate_coords(coords[2..3])

    @current_player = player
    @current_piece  = get_piece(from)

    return incorrect_color   unless current_piece.color == current_player.color
    return move_not_possible unless current_piece.allowed_move?(to)
    return pieces_in_between unless empty_path?(to)

    move(from, to)

    return king_in_checkmate if king_in_checkmate?
    return king_in_check     if king_in_check?
    return stalemate         if stalemate?
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
    grid[row(from)][column(from)]
  end

  def row(coords)
    coords[0]
  end

  def column(coords)
    coords[1]
  end

  def incorrect_color
    screen.print_board
    puts "You can only move pieces that are #{current_player.color}."
  end

  def move_not_possible
    screen.print_board
    puts "The move is not possible."
  end

  def pieces_in_between
    screen.print_board
    puts "There are pieces in between."
  end

  def empty_path?(to)
    Path.empty?(grid, current_piece, to)
  end

  def move(from, to)
    remove_piece(from)
    capture_en_passant_piece(from, to) if en_passant_possible?(from, to)
    place_piece(to)
  end

  def remove_piece(from)
    grid[row(from)][column(from)] = NullPiece.new
  end

  def capture_en_passant_piece(from, to)
    grid[row(from)][column(to)] = NullPiece.new
  end

  def en_passant_possible?(from, to)
    piece = grid[row(from)][column(to)]
    en_passant && piece.moved_two
  end

  def place_piece(to)
    grid[row(to)][column(to)] = current_piece
    current_piece.update_position(to)

    @last_moved_piece = current_piece
    @en_passant = current_piece.moved_two?
  end

  def king_in_check
    screen.print_board
    puts "Check."
  end

  def king_in_check?
    @last_moved_piece.allowed_move?(king.position)
  end

  def king_in_checkmate
    screen.print_board
    puts "Checkmate."
  end

  def king_in_checkmate?
    king_in_check? && king.cannot_escape?(opponent)
  end

  def stalemate
    screen.print_board
    puts "Stalemate."
  end

  def stalemate?
    king.valid_destinations? && king.cannot_escape?(opponent)
  end

  def king
    @last_moved_piece.color == :black ? white_king : black_king
  end

  def white_king
    select_king(color: :white)
  end

  def black_king
    select_king(color: :black)
  end

  def select_king(color:)
    grid.flatten
        .select { |piece| piece.is_a?(King) && piece.color == color }
        .first
  end

  def opponent
    @last_moved_piece.color == :black ? black_pieces : white_pieces
  end

  def black_pieces
    select_pieces(color: :black)
  end

  def white_pieces
    select_pieces(color: :white)
  end

  def select_pieces(color:)
    grid.flatten.select { |piece| piece.color == color }
  end
end
