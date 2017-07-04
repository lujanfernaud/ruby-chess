# Sets players properties and starts game.
class GameSetup
  attr_reader :game, :player1, :player2, :players

  def initialize
    @player1 = Player.new("Player 1", :null)
    @player2 = Player.new("Player 2", :null)
    @game    = Game.new(player1, player2)
  end

  def setup
    ask_names_and_colors
    game.start_game
  rescue Interrupt
    game.exit_game
  end

  private

  def ask_names_and_colors
    ask_name_for(player1)
    set_players_colors
    ask_name_for(player2)
  end

  def ask_name_for(player)
    clear_screen
    puts "Please, introduce #{player.name} name:"
    player.name = gets.chomp
  end

  def set_players_colors
    clear_screen
    puts "#{player1.name}, do you want to be black or white?:"
    player1.color = sanitize_color(gets.chomp.to_sym)
    player2.color = player1.color == :black ? :white : :black
  end

  def sanitize_color(input)
    loop do
      return input if input == :black || input == :white

      clear_screen
      puts "Please #{player1.name}, introduce 'black' or 'white':"
      input = gets.chomp.to_sym
    end
  end

  def clear_screen
    system "clear" or system "cls"
  end
end
