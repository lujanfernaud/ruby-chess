describe Board do
  let(:game_setup)   { GameSetup.new }
  let(:game)         { game_setup.game }
  let(:board)        { described_class.new(game) }
  let(:screen)       { board.screen }
  let(:grid)         { board.grid }
  let(:coordinates)  { board.coordinates }
  let(:null_piece)   { NullPiece.new }
  let(:null_square)  { null_piece.to_s }
  let(:player_black) { Player.new("Matz", :black) }
  let(:player_white) { Player.new("Sandi", :white) }

  let(:same_color_black)  { "You can only move pieces that are #{player_black.color}.\n\n"}
  let(:same_color_white)  { "You can only move pieces that are #{player_white.color}.\n\n"}
  let(:move_not_possible) { "The move is not possible.\n\n" }
  let(:check)             { "Check!\n\n" }
  let(:checkmate_black)   { "Checkmate! #{player_black.name} WINS!\n\n" }
  let(:checkmate_white)   { "Checkmate! #{player_white.name} WINS!\n\n" }
  let(:stalemate)         { "Stalemate. There is no winner.\n\n" }
  let(:play_again)        { "Would you like to play again? (y/n)" }

  let(:empty_board) do
    0.upto(7) do |row|
      0.upto(7) do |column|
        grid[row][column] = null_piece
      end
    end
  end

  describe "attributes" do
    it "has an 8x8 grid" do
      expect(grid.inject(:+).count).to eq(64)
    end

    it "has two rows of black pieces" do
      black_rows = grid[0..1].flatten
      black_rows.all? { |piece| expect(piece.color).to be(:black) }
    end

    it "has a row of black pawns" do
      black_pawns = grid[1]
      black_pawns.all? { |piece| expect(piece).to be_a(Pawn) }
    end

    it "has two rows of white pieces" do
      white_rows = grid[6..7].flatten
      white_rows.all? { |piece| expect(piece.color).to be(:white) }
    end

    it "has a row of white pawns" do
      white_pawns = grid[6]
      white_pawns.all? { |piece| expect(piece).to be_a(Pawn) }
    end
  end

  describe "#move_piece" do
    before do
      allow(screen).to receive(:print_board)
      allow(board).to receive(:puts)
      allow(game).to receive(:retry_turn)
      allow(game).to receive(:next_turn)
      allow(game).to receive(:play_again)
    end

    context "when the color of the player and the piece are not the same" do
      it "says so when the player is white and the piece black" do
        allow(board).to receive(:puts).with(same_color_white)
        board.move_piece(player_white, "a6a5")
        expect(board).to have_received(:puts).with(same_color_white)
      end

      it "says so when the player is black and the piece white" do
        allow(board).to receive(:puts).with(same_color_black)
        board.move_piece(player_black, "b2b3")
        expect(board).to have_received(:puts).with(same_color_black)
      end
    end

    context "when the move is possible for a pawn" do
      before do
        board.move_piece(player_white, "a2a4")
      end

      it "removes pawn from 'a2'" do
        expect(grid[6][0].to_s).to eq(null_square)
      end

      it "places pawn in 'a4'" do
        expect(grid[4][0]).to be_a(Pawn)
      end
    end

    context "when the move is not possible for a pawn" do
      it "returns 'The move is not possible.'" do
        allow(board).to receive(:puts).with(move_not_possible)
        board.move_piece(player_white, "a2a5")
        expect(board).to have_received(:puts).with(move_not_possible)
      end

      it "returns 'The move is not possible.'" do
        grid[5][0] = Knight.new(color: :white, position: [5, 0], board: :board)

        allow(board).to receive(:puts).with(move_not_possible)
        board.move_piece(player_white, "a2a3")
        expect(board).to have_received(:puts).with(move_not_possible)
      end
    end

    context "when a capturing move is possible for a pawn" do
      before do
        grid[5][1] = Pawn.new(color: :black, position: [5, 1], board: board)
        board.move_piece(player_white, "a2b3")
      end

      it "removes pawn from 'a2'" do
        expect(grid[6][0].to_s).to eq(null_square)
      end

      it "eats piece in 'b3'" do
        expect(grid[5][1]).to be_a(Pawn)
      end
    end

    context "when a capturing move is not possible for a pawn" do
      it "returns 'The move is not possible.'" do
        allow(board).to receive(:puts).with(move_not_possible)
        board.move_piece(player_white, "c2d3")
        expect(board).to have_received(:puts).with(move_not_possible)
      end
    end

    context "when an 'en passant' capturing move is possible for a pawn" do
      before do
        board.move_piece(player_black, "a7a5")
        board.move_piece(player_black, "a5a4")
        board.move_piece(player_white, "b2b4")
        board.move_piece(player_black, "a4b3")
      end

      it "removes pawn from 'a4'" do
        expect(grid[4][0].to_s).to eq(null_square)
      end

      it "removes captured pawn from 'b4'" do
        expect(grid[4][1].to_s).to eq(null_square)
      end

      it "places pawn in 'b3'" do
        expect(grid[5][1]).to be_a(Pawn)
      end
    end

    context "when an 'en passant' capturing move is possible for a pawn" do
      before do
        board.move_piece(player_white, "b2b4")
        board.move_piece(player_white, "b4b5")
        board.move_piece(player_black, "a7a5")
        board.move_piece(player_white, "b5a6")
      end

      it "removes pawn from 'b5'" do
        expect(grid[5][1].to_s).to eq(null_square)
      end

      it "removes captured pawn from 'a5'" do
        expect(grid[5][0].to_s).to eq(null_square)
      end

      it "places pawn in 'a6'" do
        expect(grid[2][0]).to be_a(Pawn)
      end
    end

    context "when a vertical move is possible for a rook" do
      before do
        grid[5][0] = Rook.new(color: :white, position: [5, 0], board: board)
        board.move_piece(player_white, "a3a5")
      end

      it "removes rook from 'a3'" do
        expect(grid[5][0].to_s).to eq(null_square)
      end

      it "places rook in 'a5'" do
        expect(grid[3][0]).to be_a(Rook)
      end
    end

    context "when a horizontal move is possible for a rook" do
      before do
        grid[0][1] = null_piece
        board.move_piece(player_black, "a8b8")
      end

      it "removes rook from 'a8'" do
        expect(grid[0][0].to_s).to eq(null_square)
      end

      it "places rook in 'b8'" do
        expect(grid[0][1]).to be_a(Rook)
      end
    end

    context "when the move is not possible for a rook" do
      it "returns 'The move is not possible.'" do
        allow(board).to receive(:puts).with(move_not_possible)
        board.move_piece(player_black, "a8b1")
        expect(board).to have_received(:puts).with(move_not_possible)
      end
    end

    context "when the move is possible for a knight" do
      before do
        board.move_piece(player_black, "b8c6")
      end

      it "removes knight from 'b8'" do
        expect(grid[0][1].to_s).to eq(null_square)
      end

      it "places knight in 'c6'" do
        expect(grid[2][2]).to be_a(Knight)
      end
    end

    context "when the move is not possible for a knight" do
      it "returns 'The move is not possible.'" do
        allow(board).to receive(:puts).with(move_not_possible)
        board.move_piece(player_black, "b8c8")
        expect(board).to have_received(:puts).with(move_not_possible)
      end
    end

    context "when the move is possible for a bishop" do
      before do
        grid[2][4] = Bishop.new(color: :black, position: [2, 4], board: board)
        board.move_piece(player_black, "e6g4")
      end

      it "removes bishop from 'c8'" do
        expect(grid[2][4].to_s).to eq(null_square)
      end

      it "places bishop in 'e6'" do
        expect(grid[4][6]).to be_a(Bishop)
      end
    end

    context "when the move is not possible for a bishop" do
      it "returns 'The move is not possible.'" do
        allow(board).to receive(:puts).with(move_not_possible)
        board.move_piece(player_white, "c1c6")
        expect(board).to have_received(:puts).with(move_not_possible)
      end
    end

    context "when a vertical move is possible for a queen" do
      before do
        grid[1][3] = null_piece
        board.move_piece(player_black, "d8d4")
      end

      it "removes queen from 'd8'" do
        expect(grid[0][3].to_s).to eq(null_square)
      end

      it "places queen in 'd4'" do
        expect(grid[4][3]).to be_a(Queen)
      end
    end

    context "when a diagonal move is possible for a queen" do
      before do
        grid[6][4] = null_piece
        board.move_piece(player_white, "d1h5")
      end

      it "removes queen from 'd1'" do
        expect(grid[7][3].to_s).to eq(null_square)
      end

      it "places queen in 'h5'" do
        expect(grid[3][7]).to be_a(Queen)
      end
    end

    context "when a horizontal move is possible for a queen" do
      before do
        grid[7][2] = null_piece
        grid[7][1] = null_piece
        board.move_piece(player_white, "d1b1")
      end

      it "removes queen from 'd1'" do
        expect(grid[7][3].to_s).to eq(null_square)
      end

      it "places queen in 'b1'" do
        expect(grid[7][1]).to be_a(Queen)
      end
    end

    context "when the move is not possible for a queen" do
      it "returns 'The move is not possible.'" do
        allow(board).to receive(:puts).with(move_not_possible)
        board.move_piece(player_black, "e8f6")
        expect(board).to have_received(:puts).with(move_not_possible)
      end
    end

    context "when a vertical move is possible for a king" do
      before do
        grid[1][4] = null_piece
        board.move_piece(player_black, "e8e7")
      end

      it "removes king from 'e8'" do
        expect(grid[0][4].to_s).to eq(null_square)
      end

      it "places king in 'e7'" do
        expect(grid[1][4]).to be_a(King)
      end
    end

    context "when a diagonal move is possible for a king" do
      before do
        grid[6][5] = null_piece
        board.move_piece(player_white, "e1f2")
      end

      it "removes king from 'd1'" do
        expect(grid[7][4].to_s).to eq(null_square)
      end

      it "places king in 'e2'" do
        expect(grid[6][5]).to be_a(King)
      end
    end

    context "when a horizontal move is possible for a king" do
      before do
        grid[0][3] = null_piece
        board.move_piece(player_black, "e8d8")
      end

      it "removes king from 'd8'" do
        expect(grid[0][4].to_s).to eq(null_square)
      end

      it "places king in 'c8'" do
        expect(grid[0][3]).to be_a(King)
      end
    end

    context "when the move is not possible for a king" do
      it "returns 'The move is not possible.'" do
        allow(board).to receive(:puts).with(move_not_possible)
        board.move_piece(player_black, "d8e6")
        expect(board).to have_received(:puts).with(move_not_possible)
      end
    end

    context "the white king is in check" do
      before do
        grid[1][0] = null_piece  # Remove pawn in front of black rook.
        grid[6][4] = null_piece  # Remove pawn in front of white king.
        board.move_piece(player_white, "e1e2") #
        board.move_piece(player_white, "e2e3") # Move king.
      end

      it "returns 'Check.'" do
        allow(board).to receive(:puts).with(check)
        board.move_piece(player_black, "a8a3")
        expect(board).to have_received(:puts).with(check)
      end
    end

    context "the black king is in check" do
      before do
        grid[6][0] = null_piece  # Remove pawn in front of white rook.
        grid[1][4] = null_piece  # Remove pawn in front of black king.
        board.move_piece(player_black, "e8e7") #
        board.move_piece(player_black, "e7e6") # Move king.
      end

      it "returns 'Check.'" do
        allow(board).to receive(:puts).with(check)
        board.move_piece(player_white, "a1a6")
        expect(board).to have_received(:puts).with(check)
      end
    end

    context "the white king is in checkmate" do
      before do
        grid[1][2] = null_piece  # Remove pawn in front of black bishop.
        grid[6][3] = null_piece  # Remove pawn in front of white queen.
      end

      it "returns 'Checkmate.'" do
        allow(board).to receive(:puts).with(checkmate_black)
        board.move_piece(player_black, "d8a5")
        expect(board).to have_received(:puts).with(checkmate_black)
      end
    end

    context "the white king is in checkmate" do
      before do
        grid[1][4] = null_piece  # Remove pawn in front of black king.
        grid[6][5] = null_piece  # Remove pawn in front of white bishop.
      end

      it "returns 'Checkmate.'" do
        allow(board).to receive(:puts).with(checkmate_black)
        board.move_piece(player_black, "d8h4")
        expect(board).to have_received(:puts).with(checkmate_black)
      end
    end

    context "the black king is in checkmate" do
      before do
        grid[6][2] = null_piece  # Remove pawn in front of white bishop.
        grid[1][3] = null_piece  # Remove pawn in front of black queen.
      end

      it "returns 'Checkmate.'" do
        allow(board).to receive(:puts).with(checkmate_white)
        board.move_piece(player_white, "d1a4")
        expect(board).to have_received(:puts).with(checkmate_white)
      end
    end

    context "the black king is in checkmate" do
      before do
        grid[6][4] = null_piece  # Remove pawn in front of white king.
        grid[1][5] = null_piece  # Remove pawn in front of black bishop.
      end

      it "returns 'Checkmate.'" do
        allow(board).to receive(:puts).with(checkmate_white)
        board.move_piece(player_white, "d1h5")
        expect(board).to have_received(:puts).with(checkmate_white)
      end
    end

    context "the black player is in stalemate" do
      let(:black_king)   { King.new(color: :black, position: [0, 5], board: board) }
      let(:white_bishop) { Bishop.new(color: :white, position: [1, 5], board: board) }
      let(:white_king)   { King.new(color: :white, position: [3, 5], board: board) }

      before do
        empty_board

        grid[0][5] = black_king
        grid[1][5] = white_bishop
        grid[3][5] = white_king
      end

      it "returns 'Stalemate.'" do
        allow(board).to receive(:puts).with(stalemate)
        board.move_piece(player_white, "f5f6")
        expect(board).to have_received(:puts).with(stalemate)
      end
    end

    context "the black player is in stalemate" do
      let(:black_king)   { King.new(color: :black, position: [0, 0], board: board) }
      let(:black_bishop) { Bishop.new(color: :black, position: [0, 1], board: board) }
      let(:white_rook)   { Rook.new(color: :white, position: [0, 7], board: board) }
      let(:white_king)   { King.new(color: :white, position: [3, 1], board: board) }

      before do
        empty_board

        grid[0][0] = black_king
        grid[0][1] = black_bishop
        grid[0][7] = white_rook
        grid[3][1] = white_king
      end

      it "returns 'Stalemate.'" do
        allow(board).to receive(:puts).with(stalemate)
        board.move_piece(player_white, "b5b6")
        expect(board).to have_received(:puts).with(stalemate)
      end
    end

    context "the black player is in stalemate" do
      let(:black_king)   { King.new(color: :black, position: [7, 0], board: board) }
      let(:white_rook)   { Rook.new(color: :white, position: [6, 1], board: board) }
      let(:white_king)   { King.new(color: :white, position: [4, 2], board: board) }

      before do
        empty_board

        grid[7][0] = black_king
        grid[6][1] = white_rook
        grid[4][2] = white_king
      end

      it "returns 'Stalemate.'" do
        allow(board).to receive(:puts).with(stalemate)
        board.move_piece(player_white, "c4c3")
        expect(board).to have_received(:puts).with(stalemate)
      end
    end

    context "the black player is in stalemate" do
      let(:black_king)   { King.new(color: :black, position: [0, 0], board: board) }
      let(:white_bishop) { Bishop.new(color: :white, position: [4, 5], board: board) }
      let(:white_king)   { King.new(color: :white, position: [3, 0], board: board) }

      before do
        empty_board

        grid[0][0] = black_king
        grid[4][5] = white_bishop
        grid[3][0] = white_king
      end

      it "returns 'Stalemate.'" do
        allow(board).to receive(:puts).with(stalemate)
        board.move_piece(player_white, "a5a6")
        expect(board).to have_received(:puts).with(stalemate)
      end
    end
  end
end
