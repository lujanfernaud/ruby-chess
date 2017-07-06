# Controls game flow.
class Game
  attr_reader :board, :screen, :player1, :player2, :players
  attr_reader :current_player, :next_player

  def initialize(player1, player2)
    @board          = Board.new(self)
    @screen         = Screen.new(board)
    @player1        = player1
    @player2        = player2
    @players        = [player1, player2]
    @current_player = nil
    @next_player    = nil
  end

  def start
    players_turns
  rescue Interrupt
    finish
  end

  def retry_turn(player)
    movement = input(player)
    board.move_piece(player, movement)
  end

  def finish
    screen.clear
    puts "Thanks for playing. Hope you enjoyed it!\n\n"
    exit
  end

  private

  def players_turns
    loop do
      players.each do |player|
        save_players_based_on(player)
        player_turn(player)
      end
    end
  end

  def save_players_based_on(player)
    @current_player = player
    @next_player    = players.reject { |plyr| plyr == player }
  end

  def player_turn(player)
    screen.print_board
    movement = input(player)
    board.move_piece(player, movement)
  end

  def input(player)
    puts "#{player.name}, introduce a movement:"
    gets.chomp
  end
end
