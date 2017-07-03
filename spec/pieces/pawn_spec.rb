describe Pawn do
  let(:board) { Board.new }
  let(:grid)  { board.grid }
  let(:pawn)  { described_class.new(color: :white, position: [5, 0], board: board) }
  let(:null_piece) { NullPiece.new }

  let(:empty_board) do
    0.upto(7) do |row|
      0.upto(7) do |column|
        grid[row][column] = null_piece
      end
    end
  end

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
      it "has [[-1, 0]] as an allowed move" do
        pawn.allowed_move?([4, 0])
        expect(pawn.allowed_moves).to eq([[-1, 0]])
      end
    end

    context "when the color is white and the position is the initial one" do
      let(:pawn) { described_class.new(color: :white, position: [6, 0], board: board) }

      it "also has [-2, 0] as an allowed move" do
        pawn.allowed_move?([4, 0])
        expect(pawn.allowed_moves.include?([-2, 0])).to be(true)
      end
    end

    context "when the color is white and the position is not the initial one" do
      let(:pawn) { described_class.new(color: :white, position: [5, 0], board: board) }

      it "doesn't have [-2, 0] as an allowed move" do
        pawn.allowed_move?([3, 0])
        expect(pawn.allowed_moves.include?([-2, 0])).to be(false)
      end
    end

    context "when the color is black" do
      let(:pawn) { described_class.new(color: :black, position: [2, 0], board: board) }

      it "has [[1, 0]] as an allowed move" do
        pawn.allowed_move?([3, 0])
        expect(pawn.allowed_moves).to eq([[1, 0]])
      end
    end

    context "when the color is black and the position is the initial one" do
      let(:pawn) { described_class.new(color: :black, position: [1, 0], board: board) }

      it "also has [2, 0] as a capturing move" do
        pawn.allowed_move?([3, 0])
        expect(pawn.allowed_moves.include?([2, 0])).to be(true)
      end
    end

    context "when the color is black and the position is not the initial one" do
      let(:pawn) { described_class.new(color: :black, position: [2, 0], board: board) }

      it "doesn't have [2, 0] as a capturing move" do
        pawn.allowed_move?([4, 0])
        expect(pawn.allowed_moves.include?([2, 0])).to be(false)
      end
    end

    context "when the piece is black" do
      let(:pawn) { described_class.new(color: :black, position: [1, 0], board: board) }

      it "is represented as 'p'" do
        expect(pawn.to_s).to eq("p")
      end
    end

    context "when the piece is white" do
      it "is represented as 'P'" do
        expect(pawn.to_s).to eq("P")
      end
    end
  end

  describe "#update_position" do
    context "when black is moved two squares from initial position" do
      let(:pawn) { described_class.new(color: :black, position: [1, 0], board: board) }

      it "has moved_two as 'false' before the movement" do
        expect(pawn.moved_two).to be(false)
      end

      it "has moved_two as 'true' after the movement" do
        pawn.update_position([3, 0])
        expect(pawn.moved_two).to be(true)
      end
    end

    context "when black is moved after being moved two" do
      let(:pawn) { described_class.new(color: :black, position: [1, 0], board: board) }

      it "has moved_two as 'true' before the movement" do
        pawn.update_position([3, 0])
        expect(pawn.moved_two).to be(true)
      end

      it "has moved_two as 'false' after the movement" do
        pawn.update_position([4, 0])
        expect(pawn.moved_two).to be(false)
      end
    end

    context "when black is moved one square from initial position" do
      let(:pawn) { described_class.new(color: :black, position: [1, 0], board: board) }

      it "has moved_two as 'false' after the movement" do
        pawn.update_position([2, 0])
        expect(pawn.moved_two).to be(false)
      end
    end

    context "when white is moved two squares from initial position" do
      let(:pawn) { described_class.new(color: :white, position: [6, 0], board: board) }

      it "has moved_two as 'false' before the movement" do
        expect(pawn.moved_two).to be(false)
      end

      it "has moved_two as 'true' after the movement" do
        pawn.update_position([4, 0])
        expect(pawn.moved_two).to be(true)
      end
    end

    context "when white is moved after being moved two" do
      let(:pawn) { described_class.new(color: :white, position: [6, 0], board: board) }

      it "has moved_two as 'true' before the movement" do
        pawn.update_position([4, 0])
        expect(pawn.moved_two).to be(true)
      end

      it "has moved_two as 'false' after the movement" do
        pawn.update_position([3, 0])
        expect(pawn.moved_two).to be(false)
      end
    end

    context "when white is moved one square from initial position" do
      let(:pawn) { described_class.new(color: :white, position: [6, 0], board: board) }

      it "has moved_two as 'false' after the movement" do
        pawn.update_position([5, 0])
        expect(pawn.moved_two).to be(false)
      end
    end
  end

  describe "#allowed_move?" do
    context "when there is an opponent piece in front of a white pawn" do
      let(:black_king) { King.new(color: :black, position: [0, 5], board: board) }
      let(:white_pawn) { described_class.new(color: :white, position: [1, 5], board: board) }

      before do
        empty_board

        grid[0][5] = black_king
        grid[1][5] = white_pawn
      end

      it "does not capture the opponent piece" do
        expect(white_pawn.allowed_move?([0, 5])).to be(false)
      end
    end

    context "when there is an opponent piece in front of a black pawn" do
      let(:black_pawn) { described_class.new(color: :black, position: [6, 5], board: board) }
      let(:white_king) { King.new(color: :white, position: [7, 5], board: board) }

      before do
        empty_board

        grid[6][5] = black_pawn
        grid[7][5] = white_king
      end

      it "does not capture the opponent piece" do
        expect(black_pawn.allowed_move?([7, 5])).to be(false)
      end
    end
  end
end
