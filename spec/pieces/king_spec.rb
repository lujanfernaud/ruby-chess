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
  end
end
