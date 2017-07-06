describe Bishop do
  let(:game_setup) { GameSetup.new }
  let(:game)       { game_setup.game }
  let(:board)      { Board.new(game) }

  let(:bishop) do
    described_class.new(color: :black, position: [0, 2], board: board)
  end

  describe "attributes" do
    it "has a color" do
      expect(bishop.color).to be(:black)
    end

    it "has four allowed moves" do
      expect(bishop.allowed_moves.length).to be(28)
    end

    context "when the piece is black" do
      it "is represented as 'b'" do
        expect(bishop.to_s).to eq("b")
      end
    end

    context "when the piece is white" do
      let(:white_bishop) do
        described_class.new(color: :white, position: [7, 2], board: board)
      end

      it "is represented as 'B'" do
        expect(white_bishop.to_s).to eq("B")
      end
    end
  end
end
