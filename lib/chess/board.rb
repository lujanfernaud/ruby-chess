# Holds representation of the board.
class Board
  include Coordinates

  attr_reader :game, :grid, :screen, :en_passant
  attr_reader :current_player, :current_piece, :last_moved_piece

  def initialize(game)
    @game             = game
    @grid             = Grid.new(self)
    @screen           = Screen.new(self)
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

    Move.piece(from, to, board: self)

    return king_in_checkmate if king_in_checkmate?
    return king_in_check     if king_in_check?
    return stalemate         if stalemate?
  end

  protected

  attr_writer :grid, :current_piece, :last_moved_piece, :en_passant

  def move_not_possible
    screen.print_board
    puts "The move is not possible.\n\n"
    game.retry_turn
  end

  private

  # Translates coordinates as expressed in the board
  # to their positions in the grid.
  # Letter represents column and number represents row.
  # Example: "a2" would be translated as [6, 0]

  def translate_coords(coords)
    letter = COORDINATES[coords[0]]
    number = COORDINATES[coords[1]]

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

  def promote_pawn
    screen.print_board
    puts "To which piece would you like to promote the pawn?"
    choose_piece_for_pawn_promotion
  end

  def choose_piece_for_pawn_promotion
    pieces_to_promote_to = %w[rook knight bishop queen]

    loop do
      input = STDIN.gets.chomp.strip.downcase
      return switch_current_piece(input) if pieces_to_promote_to.include?(input)
      incorrect_piece_to_promote_to
    end
  end

  def switch_current_piece(input)
    piece_class_name = Object.const_get(input.capitalize)
    promoted_piece   = create_new_piece(piece_class_name)
    @current_piece   = promoted_piece
  end

  def create_new_piece(piece_class)
    piece_class.new(color:    current_piece.color,
                    position: current_piece.position,
                    board:    self)
  end

  def incorrect_piece_to_promote_to
    screen.print_board
    puts "The pawn can only be promoted to a rook, knight, bishop or queen.\n\n"
    puts "To which piece would you like to promote the pawn?"
  end

  def king_in_check
    screen.print_board
    puts "The #{current_piece.opponent_color} king is in check!\n\n"
    game.next_turn
  end

  def king_in_check?
    king.in_check?
  end

  def king_in_checkmate
    screen.print_board
    puts "Checkmate! #{current_player.name} WINS!\n\n"
    puts "Would you like to play again? (y/n)"
    game.play_again
  end

  def king_in_checkmate?
    king.in_check? && king.cannot_escape?
  end

  def stalemate
    screen.print_board
    puts "Stalemate. There is no winner.\n\n"
    puts "Would you like to play again? (y/n)"
    game.play_again
  end

  def stalemate?
    king.valid_destinations? && king.cannot_escape?
  end

  def king
    @last_moved_piece.color == :black ? select_king(:white) : select_king(:black)
  end

  def select_king(color)
    grid.flatten.select { |piece| piece.is_a?(King) && piece.color == color }[0]
  end
end
