describe Queen do
  let(:board) { Board.new }
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
  end
end
