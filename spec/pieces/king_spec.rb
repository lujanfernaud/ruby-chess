describe King do
  let(:board) { Board.new }
  let(:king) do
    described_class.new(color: :black, position: [0, 4], board: board)
  end

  describe "attributes" do
    it "has a color" do
      expect(king.color).to be(:black)
    end

    it "has eight allowed moves" do
      expect(king.allowed_moves.length).to be(8)
    end

    context "when the piece is black" do
      it "is represented as 'k'" do
        expect(king.to_s).to eq("k")
      end
    end

    context "when the piece is white" do
      let(:white_king) do
        described_class.new(color: :white, position: [7, 4], board: board)
      end

      it "is represented as 'K'" do
        expect(white_king.to_s).to eq("K")
      end
    end
  end
end
