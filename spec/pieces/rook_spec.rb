describe Rook do
  let(:board) { Board.new }
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
  end
end
