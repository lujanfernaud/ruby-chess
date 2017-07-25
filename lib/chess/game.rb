# Controls game flow.
class Game
  attr_reader :board, :screen, :player1, :player2
  attr_reader :current_player, :next_player

  def initialize(player1, player2)
    @board          = Board.new(self)
    @screen         = Screen.new(board)
    @player1        = player1
    @player2        = player2
    @current_player = nil
    @next_player    = nil
  end

  def start
    players_turns
  rescue Interrupt
    finish
  end

  def retry_turn
    player_turn_without_printing_board
  end

  def retry_turn_printing(message)
    screen.print_board
    puts message
    retry_turn
    players_turns
  end

  def next_turn
    save_players_based_on(next_player)
    player_turn_without_printing_board
  end

  def play_again
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

  def load_game
    yaml = YAML.load(File.open(game_file))

    update_game_data_from(yaml)

    retry_turn_printing(game_loaded)
  end

  private

  def players
    [player1, player2]
  end

  def players_turns
    loop do
      players.each do |player|
        next if player == current_player
        save_players_based_on(player)
        player_turn(player)
      end
    end
  end

  def save_players_based_on(player)
    @current_player = player
    @next_player    = players.reject { |plyr| plyr == player }.first
  end

  def player_turn(player)
    screen.print_board
    movement = input(player)
    board.move_piece(player, movement)
  end

  def player_turn_without_printing_board
    movement = input(current_player)
    board.move_piece(current_player, movement)
  end

  def input(player)
    puts "#{player.name}, introduce a movement:"
    sanitize(gets.chomp.downcase)
  end

  def sanitize(movement)
    loop do
      return board.possible_moves_for(movement) if movement =~ /\A[a-h][1-8]\z/

      return movement  if movement =~ /\A[a-h][1-8][a-h][1-8]\z/
      return save_game if movement =~ /save/
      return load_game if movement =~ /load/
      return finish    if movement =~ /exit/

      movement = please_introduce_a_correct_movement
    end
  end

  def save_game
    yaml = YAML.dump(game_data)

    File.open(game_file, "w") { |file| file.puts yaml }

    retry_turn_printing(game_saved)
  end

  def game_data
    { "board"          => board,
      "screen"         => screen,
      "player1"        => player1,
      "player2"        => player2,
      "current_player" => current_player,
      "next_player"    => next_player }
  end

  def game_file
    "saved_game.yaml"
  end

  def update_game_data_from(yaml)
    @board          = yaml["board"]
    @screen         = yaml["screen"]
    @player1        = yaml["player1"]
    @player2        = yaml["player2"]
    @current_player = yaml["current_player"]
    @next_player    = yaml["next_player"]
  end

  def game_saved
    "Game saved.\n\n"
  end

  def game_loaded
    "Game loaded.\n\n"
  end

  def please_introduce_a_correct_movement
    screen.print_board
    puts "Please introduce a correct movement (for example, 'b2b3'):"
    gets.chomp.downcase
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
