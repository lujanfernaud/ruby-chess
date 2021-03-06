describe Game do
  let(:game_setup) { GameSetup.new }
  let(:game)       { game_setup.game }
  let(:board)      { game.board }
  let(:screen)     { game.screen }
  let(:player1)    { game.player1 }
  let(:player2)    { game.player2 }

  describe "#start" do
    before do
      player1.color = :black
      player2.color = :white
      allow(game).to receive(:loop).and_yield
      allow(screen).to receive(:print_board)
      allow(game).to receive(:puts).with("Player 1, introduce a movement:")
      allow(game).to receive(:puts).with("Player 2, introduce a movement:")
      allow(game).to receive(:gets).and_return("b2b3")
      allow(game.board).to receive(:move_piece)
      game.start
    end

    it "prints board" do
      expect(screen).to have_received(:print_board).twice
    end

    it "asks player 1 to introduce a movement" do
      expect(game).to have_received(:puts)
        .with("Player 1, introduce a movement:")
    end

    it "asks player 2 to introduce a movement" do
      expect(game).to have_received(:puts)
        .with("Player 2, introduce a movement:")
    end
  end

  describe "#play_again" do
    before do
      allow(game).to receive(:loop).and_yield
    end

    it "resets board when 'y'" do
      allow(game).to receive(:gets).and_return("y")
      allow(game).to receive(:restart)
      game.play_again
      expect(game).to have_received(:restart)
    end

    it "exits game when 'n'" do
      allow(game).to receive(:gets).and_return("n")
      allow(game).to receive(:finish)
      game.play_again
      expect(game).to have_received(:finish)
    end
  end

  describe "#finish" do
    before do
      allow(screen).to receive(:system).with("clear")
      allow(screen).to receive(:system).with("cls")
      allow(game).to receive(:puts)
        .with("Thanks for playing. Hope you enjoyed it!\n\n")
      allow(game).to receive(:exit)
      game.finish
    end

    it "prints exit message" do
      expect(game).to have_received(:puts)
        .with("Thanks for playing. Hope you enjoyed it!\n\n")
    end

    it "exits game" do
      expect(game).to have_received(:exit)
    end
  end
end
