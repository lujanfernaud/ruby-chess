# Takes care of moving pieces.
class Move < Board
  attr_reader :board, :grid, :current_piece
  attr_reader :from,  :to

  def initialize(from, to, board)
    @board         = board
    @grid          = board.grid
    @screen        = board.screen
    @current_piece = board.current_piece
    @from          = from
    @to            = to
  end

  def self.piece(from, to, board:)
    new(from, to, board).move
  end

  def move
    remove_piece
    capture_en_passant_piece if en_passant_possible?
    promote_pawn if pawn_promotion_possible?
    place_piece
  end

  private

  def remove_piece
    grid[row(from)][column(from)] = NullPiece.new
  end

  def capture_en_passant_piece
    grid[row(from)][column(to)] = NullPiece.new
  end

  def en_passant_possible?
    piece = grid[row(from)][column(to)]
    board.en_passant && piece.moved_two?
  end

  def pawn_promotion_possible?
    return false unless current_piece.is_a?(Pawn)
    current_piece.promotion_position[current_piece.color].include?(to)
  end

  def place_piece
    grid[row(to)][column(to)] = current_piece
    current_piece.update_position(to)

    update_last_moved_piece
    update_en_passant
  end

  def update_last_moved_piece
    board.last_moved_piece = current_piece
  end

  def update_en_passant
    board.en_passant = current_piece.moved_two?
  end
end
