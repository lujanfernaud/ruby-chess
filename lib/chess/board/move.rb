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
    special_actions
    place_piece
  end

  private

  def remove_piece
    grid[row(from)][column(from)] = NullPiece.new
  end

  def special_actions
    capture_en_passant_piece if en_passant_possible?
    promote_pawn             if pawn_promotion_possible?

    return unless trying_to_do_castling?

    do_castling if castling_possible?
  end

  def capture_en_passant_piece
    grid[row(from)][column(to)] = NullPiece.new
  end

  def en_passant_possible?
    piece = grid[row(from)][column(to)]
    board.en_passant && piece.moved_two?
  end

  def pawn_promotion_possible?
    current_piece.can_be_promoted?(to)
  end

  def trying_to_do_castling?
    current_piece.castling_destination(castling_side) == to
  end

  def do_castling
    move_rook(castling_side)
  end

  def castling_side
    case column(from) <=> column(to)
    when  1 then :queen_side
    when -1 then :king_side
    else         false
    end
  end

  def move_rook(side)
    from = rook.position
    to   = rook.castling_destination(side)

    grid[row(from)][column(from)] = NullPiece.new
    grid[row(to)][column(to)] = rook
  end

  def rook
    rooks = grid.flatten.select do |piece|
      piece.is_a?(Rook) && piece.color == current_piece.color
    end

    castling_side == :queen_side ? rooks.first : rooks.last
  end

  def castling_possible?
    return board.move_not_possible unless castling?

    castling?
  end

  def castling?
    king_not_in_check? && king_can_castle? && rook.not_moved?
  end

  def king_not_in_check?
    !current_piece.in_check?
  end

  def king_can_castle?
    current_piece.can_castle_to?(castling_side)
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
