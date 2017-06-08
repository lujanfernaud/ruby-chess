describe Rook do
  let(:rook) { described_class.new(color: :white) }

  describe "attributes" do
    it "has a color" do
      expect(rook.color).to be(:white)
    end

    it "has four allowed moves" do
      expect(rook.allowed_moves.length).to be(4)
    end
  end
end
