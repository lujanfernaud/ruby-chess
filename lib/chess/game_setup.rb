# Sets players properties and starts game.
class GameSetup
  attr_reader :game, :screen, :player1, :player2

  def initialize
    @player1 = Player.new("Player 1", :null)
    @player2 = Player.new("Player 2", :null)
    @game    = Game.new(player1, player2)
    @screen  = game.screen
  end

  def setup
    introduction
    ask_names_and_colors
    game.start
  rescue Interrupt
    game.finish
  end

  private

  def introduction
    screen.print_introduction
    sanitize_command(gets.chomp.downcase)
  end

  def sanitize_command(input)
    loop do
      return game.load_game if input =~ /load/
      return game.finish    if input =~ /exit/
      break                 if input.empty?

      introduction
    end
  end

  def ask_names_and_colors
    ask_name_for(player1)
    set_players_colors
    ask_name_for(player2)
  end

  def ask_name_for(player)
    screen.print_main_title
    puts "Please, introduce #{player.name} name:"
    player.name = check_input(gets.chomp)
  end

  def check_input(input)
    input =~ /exit/ ? game.finish : input
  end

  def set_players_colors
    screen.print_main_title
    puts "#{player1.name}, do you want to be black or white?:"
    player1.color = sanitize_color(gets.chomp.downcase.to_sym)
    player2.color = choose_player2_color
  end

  def sanitize_color(input)
    loop do
      return input       if input == :black || input == :white
      return game.finish if input =~ /exit/

      input = please_introduce_black_or_white
    end
  end

  def please_introduce_black_or_white
    screen.print_main_title
    puts "Please #{player1.name}, introduce 'black' or 'white':"
    gets.chomp.downcase.to_sym
  end

  def choose_player2_color
    player1.color == :black ? :white : :black
  end
end
