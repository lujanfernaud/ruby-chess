describe Piece do
  let(:piece) { described_class.new }

  it "has a color" do
    expect(piece).to respond_to(:color)
  end

  it "has allowed moves" do
    expect(piece).to respond_to(:allowed_moves)
  end
end
