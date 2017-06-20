describe Bishop do
  let(:board)  { Board.new }
  let(:bishop) { described_class.new(color: :black, board: board) }

  describe "attributes" do
    it "has a color" do
      expect(bishop.color).to be(:black)
    end

    it "has four allowed moves" do
      expect(bishop.allowed_moves.length).to be(28)
    end
  end
end
