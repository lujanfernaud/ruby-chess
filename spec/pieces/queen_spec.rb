describe Queen do
  let(:queen) { described_class.new(color: :black) }

  describe "attributes" do
    it "has a color" do
      expect(queen.color).to be(:black)
    end

    it "has eight allowed moves" do
      expect(queen.allowed_moves.length).to be(56)
    end
  end
end
