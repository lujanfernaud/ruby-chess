# Holds representation of the board.
class Board
  include Coordinates

  attr_reader :game, :grid, :screen, :coordinates, :en_passant
  attr_reader :current_player, :current_piece, :last_moved_piece

  def initialize(game)
    @game = game
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

    move(from, to)

    return king_in_checkmate if king_in_checkmate?
    return king_in_check     if king_in_check?
    return stalemate         if stalemate?
  end

  protected

  attr_writer :grid, :last_moved_piece, :en_passant

  private

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
    puts "You can only move pieces that are #{current_player.color}.\n\n"
    game.retry_turn
  end

  def move_not_possible
    screen.print_board
    puts "The move is not possible.\n\n"
    game.retry_turn
  end

  def move(from, to)
    Move.piece(from, to, board: self)
  end

  def king_in_check
    screen.print_board
    puts "Check!\n\n"
    game.next_turn
  end

  def king_in_check?
    @last_moved_piece.allowed_move?(king.position)
  end

  def king_in_checkmate
    screen.print_board
    puts "Checkmate! #{current_player.name} WINS!\n\n"
    puts "Would you like to play again? (y/n)"
    game.play_again
  end

  def king_in_checkmate?
    king_in_check? && king.cannot_escape?(opponent)
  end

  def stalemate
    screen.print_board
    puts "Stalemate. There is no winner.\n\n"
    puts "Would you like to play again? (y/n)"
    game.play_again
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
