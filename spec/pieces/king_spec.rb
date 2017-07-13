describe King do
  let(:game_setup) { GameSetup.new }
  let(:game)       { game_setup.game }
  let(:board)      { Board.new(game) }

  let(:king_black) do
    described_class.new(color: :black, position: [0, 4], board: board)
  end

  let(:king_white) do
    described_class.new(color: :white, position: [7, 4], board: board)
  end

  describe "attributes" do
    it "has a color" do
      expect(king_black.color).to be(:black)
    end

    it "has eight allowed moves" do
      expect(king_black.allowed_moves.length).to be(8)
    end

    context "when the piece is black" do
      it "is represented as 'k'" do
        expect(king_black.to_s).to eq("k")
      end
    end

    context "when the piece is white" do
      let(:white_king) do
        described_class.new(color: :white, position: [7, 4], board: board)
      end

      it "is represented as 'K'" do
        expect(white_king.to_s).to eq("K")
      end
    end
  end

  describe "#allowed_move?" do
    context "when the black king is in the initial position" do
      it "adds castling moves" do
        king_black.allowed_move?([0, 2])
        expect(king_black.allowed_moves).to include([0, -2], [0, 2])
      end
    end

    context "when the black king is not in the initial position" do
      before do
        king_black.update_position([1, 4])
      end

      it "doesn't add castling moves" do
        king_black.allowed_move?([1, 2])
        expect(king_black.allowed_moves).not_to include([0, -2], [0, 2])
      end
    end

    context "when the white king is in the initial position" do
      it "adds castling moves" do
        king_white.allowed_move?([0, 2])
        expect(king_white.allowed_moves).to include([0, -2], [0, 2])
      end
    end

    context "when the white king is not in the initial position" do
      before do
        king_white.update_position([6, 4])
      end

      it "doesn't add castling moves" do
        king_white.allowed_move?([6, 2])
        expect(king_white.allowed_moves).not_to include([0, -2], [0, 2])
      end
    end
  end
end
