describe Pawn do
  let(:pawn) { described_class.new(color: :white, position: [5, 0]) }

  describe "attributes" do
    it "is a Piece" do
      expect(pawn).to be_kind_of(Piece)
    end

    it "has a color" do
      expect(pawn.color).to eq(:white)
    end

    it "knows its position" do
      expect(pawn.position).to eq([5, 0])
    end

    context "when the color is white" do
      it "has [[-1, 0], [-1, -1], [-1, 1]] as allowed moves" do
        expect(pawn.allowed_moves).to eq([[-1, 0], [-1, -1], [-1, 1]])
      end
    end

    context "when the color is white and the position is the initial one" do
      let(:pawn) { described_class.new(color: :white, position: [6, 0]) }

      it "also has [-2, 0] as an allowed move" do
        expect(pawn.allowed_moves.include?([-2, 0])).to be(true)
      end
    end

    context "when the color is white and the position is not the initial one" do
      let(:pawn) { described_class.new(color: :white, position: [5, 0]) }

      it "doesn't have [-2, 0] as an allowed move" do
        expect(pawn.allowed_moves.include?([-2, 0])).to be(false)
      end
    end

    context "when the color is black" do
      let(:pawn) { described_class.new(color: :black, position: [2, 0]) }

      it "has [[1, 0], [1, 1], [1, -1]] as allowed moves" do
        expect(pawn.allowed_moves).to eq([[1, 0], [1, 1], [1, -1]])
      end
    end

    context "when the color is black and the position is the initial one" do
      let(:pawn) { described_class.new(color: :black, position: [1, 0]) }

      it "also has [2, 0] as a special move" do
        expect(pawn.allowed_moves.include?([2, 0])).to be(true)
      end
    end

    context "when the color is black and the position is not the initial one" do
      let(:pawn) { described_class.new(color: :black, position: [2, 0]) }

      it "doesn't have [2, 0] as a special move" do
        expect(pawn.allowed_moves.include?([2, 0])).to be(false)
      end
    end
  end
end
