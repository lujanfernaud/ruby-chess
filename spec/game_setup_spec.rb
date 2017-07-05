describe GameSetup do
  let(:game_setup) { described_class.new }
  let(:screen)     { game_setup.screen }
  let(:player1)    { game_setup.player1 }
  let(:player2)    { game_setup.player2 }

  describe "#setup" do
    before do
      allow(screen).to receive(:clear)
      allow(game_setup).to receive(:puts)
        .with("Please, introduce Player 1 name:")
      allow(game_setup).to receive(:gets).and_return("Matz", "black", "Sandi")
      allow(game_setup).to receive(:puts)
        .with("Matz, do you want to be black or white?:")
      allow(game_setup).to receive(:puts)
        .with("Please, introduce Player 2 name:")
      allow(game_setup.game).to receive(:start)
      game_setup.setup
    end

    it "sets player 1 name" do
      expect(player1.name).to eq("Matz")
    end

    it "sets player 1 color to :black" do
      expect(player1.color).to eq(:black)
    end

    it "sets player 2 name" do
      expect(player2.name).to eq("Sandi")
    end

    it "sets player 2 color to :white" do
      expect(player2.color).to eq(:white)
    end
  end
end
