describe Knight do
  let(:game_setup) { GameSetup.new }
  let(:game)       { game_setup.game }
  let(:board)      { Board.new(game) }

  let(:knight) do
    described_class.new(color: :black, position: [0, 1], board: board)
  end

  describe "attributes" do
    it "has a color" do
      expect(knight.color).to be(:black)
    end

    it "has eight allowed moves" do
      expect(knight.allowed_moves.length).to be(8)
    end

    context "when the piece is black" do
      it "is represented as 'n'" do
        expect(knight.to_s).to eq("n")
      end
    end

    context "when the piece is white" do
      let(:white_knight) do
        described_class.new(color: :white, position: [7, 1], board: board)
      end

      it "is represented as 'N'" do
        expect(white_knight.to_s).to eq("N")
      end
    end
  end
end
