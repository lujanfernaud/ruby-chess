describe Piece do
  let(:game_setup)   { GameSetup.new }
  let(:game)         { game_setup.game }
  let(:board)        { Board.new(game) }
  let(:grid)         { board.grid }
  let(:piece)        { described_class.new }
  let(:player_black) { Player.new("Matz", :black) }

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
      board.move_piece(player_black, "a7a6")
    end

    it "its position gets updated" do
      piece = grid[2][0]
      expect(piece.position).to eq([2, 0])
    end
  end
end
