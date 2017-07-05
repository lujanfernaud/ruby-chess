# Controls game flow.
class Game
  attr_reader :board, :screen, :player1, :player2, :players

  def initialize(player1, player2)
    @board   = Board.new
    @screen  = Screen.new(board)
    @player1 = player1
    @player2 = player2
    @players = [player1, player2]
  end

  def start_game
    players_turns
  rescue Interrupt
    exit_game
  end

  def exit_game
    screen.clear
    puts "Thanks for playing. Hope you enjoyed it!\n\n"
    exit
  end

  private

  def players_turns
    loop do
      players.each do |player|
        screen.print_board
        movement = input(player)
        board.move_piece(movement)
      end
    end
  end

  def input(player)
    puts "#{player.name}, introduce a movement:"
    gets.chomp
  end
end
