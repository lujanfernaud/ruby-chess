describe Queen do
  let(:game_setup) { GameSetup.new }
  let(:game)       { game_setup.game }
  let(:board)      { Board.new(game) }

  let(:queen) do
    described_class.new(color: :black, position: [0, 3], board: board)
  end

  describe "attributes" do
    it "has a color" do
      expect(queen.color).to be(:black)
    end

    it "has eight allowed moves" do
      expect(queen.allowed_moves.length).to be(56)
    end

    context "when the piece is black" do
      it "is represented as 'q'" do
        expect(queen.to_s).to eq("q")
      end
    end

    context "when the piece is white" do
      let(:white_queen) do
        described_class.new(color: :white, position: [7, 3], board: board)
      end

      it "is represented as 'Q'" do
        expect(white_queen.to_s).to eq("Q")
      end
    end
  end
end
