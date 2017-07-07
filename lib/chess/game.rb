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

  def retry_turn
    player_turn_without_printing_board(current_player)
  end

  def next_turn
    player_turn_without_printing_board(next_player)
  end

  def try_again
    loop do
      input = gets.chomp.downcase

      case input
      when "y" then restart
      when "n" then finish
      else type_y_or_n
      end
    end
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

  def player_turn_without_printing_board(player)
    movement = input(player)
    board.move_piece(player, movement)
  end

  def input(player)
    puts "#{player.name}, introduce a movement:"
    sanitize_movement(gets.chomp.downcase)
  end

  def sanitize_movement(movement)
    loop do
      return movement if movement =~ /\A[a-h][1-8][a-h][1-8]\z/

      screen.print_board
      puts "Please introduce a correct movement (for example, 'b2b3'):"
      movement = gets.chomp.downcase
    end
  end

  def restart
    Game.new(player1, player2).start
  end

  def type_y_or_n
    screen.print_board
    puts "Please type 'y' or 'n'.\n\n"
    puts "Would you like to play again? (y/n)"
  end
end
