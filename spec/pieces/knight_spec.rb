describe Knight do
  let(:board)  { Board.new }
  let(:knight) { described_class.new(color: :black, board: board) }

  describe "attributes" do
    it "has a color" do
      expect(knight.color).to be(:black)
    end

    it "has eight allowed moves" do
      expect(knight.allowed_moves.length).to be(8)
    end
  end
end
