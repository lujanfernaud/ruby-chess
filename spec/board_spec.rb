describe Board do
  let(:board)       { described_class.new }
  let(:grid)        { board.grid }
  let(:coordinates) { board.coordinates }

  describe "attributes" do
    it "has a coordinates hash" do
      expect(coordinates).to be_kind_of(Hash)
    end

    it "has an 8x8 grid" do
      expect(grid.inject(:+).count).to eq(64)
    end

    it "has two rows of black pieces" do
      black_rows = grid[0..1].flatten
      black_rows.all? { |piece| expect(piece.color).to be(:black) }
    end

    it "has a row of black pawns" do
      black_pawns = grid[1]
      black_pawns.all? { |piece| expect(piece).to be_a(Pawn) }
    end

    it "has two rows of white pieces" do
      white_rows = grid[6..7].flatten
      white_rows.all? { |piece| expect(piece.color).to be(:white) }
    end

    it "has a row of white pawns" do
      white_pawns = grid[6]
      white_pawns.all? { |piece| expect(piece).to be_a(Pawn) }
    end
  end

  describe "#move_piece" do
    context "when the move is possible for a pawn" do
      before do
        board.move_piece("a2a4")
      end

      it "removes pawn from 'a2'" do
        expect(grid[6][0]).to eq("-")
      end

      it "places pawn in 'a4'" do
        expect(grid[4][0]).to be_a(Pawn)
      end
    end

    context "when the move is not possible for a pawn" do
      it "returns 'The move is not possible.'" do
        expect(board.move_piece("a2a5")).to eq("The move is not possible.")
      end

      it "returns 'The move is not possible.'" do
        grid[5][0] = Knight.new(color: :white, board: :board)
        expect(board.move_piece("a2a3")).to eq("The move is not possible.")
      end
    end

    context "when a capturing move is possible for a pawn" do
      before do
        grid[5][1] = Pawn.new(color: :black, position: [5, 1], board: board)
        board.move_piece("a2b3")
      end

      it "removes pawn from 'a2'" do
        expect(grid[6][0]).to eq("-")
      end

      it "eats piece in 'b3'" do
        expect(grid[5][1]).to be_a(Pawn)
      end
    end

    context "when a capturing move is not possible for a pawn" do
      it "returns 'The move is not possible.'" do
        expect(board.move_piece("c2d3")).to eq("The move is not possible.")
      end
    end

    context "when a vertical move is possible for a rook" do
      before do
        grid[5][0] = Rook.new(color: :white, board: board)
        board.move_piece("a3a5")
      end

      it "removes rook from 'a3'" do
        expect(grid[5][0]).to eq("-")
      end

      it "places rook in 'a5'" do
        expect(grid[3][0]).to be_a(Rook)
      end
    end

    context "when a horizontal move is possible for a rook" do
      before do
        grid[0][1] = "-"
        board.move_piece("a8b8")
      end

      it "removes rook from 'a8'" do
        expect(grid[0][0]).to eq("-")
      end

      it "places rook in 'b8'" do
        expect(grid[0][1]).to be_a(Rook)
      end
    end

    context "when the move is not possible for a rook" do
      it "returns 'The move is not possible.'" do
        expect(board.move_piece("a8b1")).to eq("The move is not possible.")
      end
    end

    context "when the move is possible for a knight" do
      before do
        board.move_piece("b8c6")
      end

      it "removes knight from 'b8'" do
        expect(grid[0][1]).to eq("-")
      end

      it "places knight in 'c6'" do
        expect(grid[2][2]).to be_a(Knight)
      end
    end

    context "when the move is not possible for a knight" do
      it "returns 'The move is not possible.'" do
        expect(board.move_piece("b8c8")).to eq("The move is not possible.")
      end
    end

    context "when the move is possible for a bishop" do
      before do
        grid[2][4] = Bishop.new(color: :black, board: board)
        board.move_piece("e6g4")
      end

      it "removes bishop from 'c8'" do
        expect(grid[2][4]).to eq("-")
      end

      it "places bishop in 'e6'" do
        expect(grid[4][6]).to be_a(Bishop)
      end
    end

    context "when the move is not possible for a bishop" do
      it "returns 'The move is not possible.'" do
        expect(board.move_piece("c1c6")).to eq("The move is not possible.")
      end

      it "returns 'There are pieces in between.'" do
        expect(board.move_piece("c8e6")).to eq("There are pieces in between.")
      end
    end

    context "when a vertical move is possible for a king" do
      before do
        grid[1][3] = "-"
        board.move_piece("d8d7")
      end

      it "removes king from 'd8'" do
        expect(grid[0][3]).to eq("-")
      end

      it "places king in 'd7'" do
        expect(grid[1][3]).to be_a(King)
      end
    end

    context "when a diagonal move is possible for a king" do
      before do
        grid[6][4] = "-"
        board.move_piece("d1e2")
      end

      it "removes king from 'd1'" do
        expect(grid[7][3]).to eq("-")
      end

      it "places king in 'e2'" do
        expect(grid[6][4]).to be_a(King)
      end
    end

    context "when a horizontal move is possible for a king" do
      before do
        grid[0][2] = "-"
        board.move_piece("d8c8")
      end

      it "removes rook from 'd8'" do
        expect(grid[0][3]).to eq("-")
      end

      it "places rook in 'c8'" do
        expect(grid[0][2]).to be_a(King)
      end
    end

    context "when the move is not possible for a king" do
      it "returns 'The move is not possible.'" do
        expect(board.move_piece("d8e6")).to eq("The move is not possible.")
      end
    end

    context "when a vertical move is possible for a queen" do
      before do
        grid[2][4] = Queen.new(color: :black, board: board)
        board.move_piece("e6e4")
      end

      it "removes queen from 'e8'" do
        expect(grid[2][4]).to eq("-")
      end

      it "places queen in 'e6'" do
        expect(grid[4][4]).to be_a(Queen)
      end
    end

    context "when a diagonal move is possible for a queen" do
      before do
        grid[5][2] = Queen.new(color: :white, board: board)
        board.move_piece("c3e5")
      end

      it "removes queen from 'e1'" do
        expect(grid[5][2]).to eq("-")
      end

      it "places queen in 'g3'" do
        expect(grid[3][4]).to be_a(Queen)
      end
    end

    context "when a horizontal move is possible for a queen" do
      before do
        grid[2][4] = Queen.new(color: :white, board: board)
        board.move_piece("e6g6")
      end

      it "removes rook from 'e8'" do
        expect(grid[2][4]).to eq("-")
      end

      it "places rook in 'g8'" do
        expect(grid[2][6]).to be_a(Queen)
      end
    end

    context "when the move is not possible for a queen" do
      it "returns 'The move is not possible.'" do
        expect(board.move_piece("e8f6")).to eq("The move is not possible.")
      end
    end
  end
end
