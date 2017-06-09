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
    context "when the move is possible" do
      before do
        grid[6][0] = "P"
        allow(board).to receive(:move_possible?).and_return(true)
        board.move_piece("a2a3")
      end

      it "removes piece from position" do
        expect(grid[6][0]).to eq("-")
      end

      it "places piece in new position" do
        expect(grid[5][0]).to eq("P")
      end
    end
  end

  context "when the move is not possible" do
    before do
      grid[6][0] = "P"
      allow(board).to receive(:move_possible?).and_return(false)
    end

    it "returns 'The move is not possible.'" do
      expect(board.move_piece("a2b3")).to eq("The move is not possible.")
    end
  end
end
