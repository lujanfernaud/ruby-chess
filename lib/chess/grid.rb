# Holds grid for the board.
class Grid < Board
  attr_reader :board, :grid

  def initialize(board)
    @board = board
    @grid  = []
    set_board
  end

  def [](value)
    grid[value]
  end

  def []=(position, value)
    grid[position] = value
  end

  def inject(sym)
    grid.inject(sym)
  end

  def flatten
    grid.flatten
  end

  def select
    grid.select
  end

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
      piece.new(color: color, position: [row, index], board: board)
    end
  end

  def add_empty_rows
    4.times { @grid << Array.new(8) { NullPiece.new } }
  end
end
