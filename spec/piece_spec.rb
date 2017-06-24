describe Piece do
  let(:board) { Board.new }
  let(:grid)  { board.grid }
  let(:piece) { described_class.new }

  it "has a color" do
    expect(piece).to respond_to(:color)
  end

  it "knows its position" do
    expect(piece).to respond_to(:position)
  end

  it "has allowed moves" do
    expect(piece).to respond_to(:allowed_moves)
  end

  context "when a piece is moved" do
    before do
      board.move_piece("a7a6")
    end

    it "its position gets updated" do
      piece = grid[2][0]
      expect(piece.position).to eq([2, 0])
    end
  end
end
