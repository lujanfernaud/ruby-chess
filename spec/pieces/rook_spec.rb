describe Rook do
  let(:game_setup) { GameSetup.new }
  let(:game)       { game_setup.game }
  let(:board)      { Board.new(game) }

  let(:rook) do
    described_class.new(color: :white, position: [7, 0], board: board)
  end

  describe "attributes" do
    it "has a color" do
      expect(rook.color).to be(:white)
    end

    it "has four allowed moves" do
      expect(rook.allowed_moves.length).to be(28)
    end

    context "when the piece is black" do
      let(:black_rook) do
        described_class.new(color: :black, position: [0, 0], board: board)
      end

      it "is represented as 'r'" do
        expect(black_rook.to_s).to eq("r")
      end
    end

    context "when the piece is white" do
      it "is represented as 'R'" do
        expect(rook.to_s).to eq("R")
      end
    end
  end
end
