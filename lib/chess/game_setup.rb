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
    game.start
  rescue Errno::ENOENT
    no_saved_game
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
      return ask_names_and_colors if input.empty?
      return game.load_game       if input =~ /load/
      return game.finish          if input =~ /exit/

      setup
    end
  end

  def ask_names_and_colors
    ask_name_for(player1)
    set_players_colors
    ask_name_for(player2)
  rescue Errno::ENOENT
    no_saved_game
  end

  def ask_name_for(player)
    screen.print_main_title
    puts "Please, introduce #{player.name} name:"
    player.name = check_input(gets.chomp)
  end

  def check_input(input)
    return game.load_game if input =~ /load/
    return game.finish    if input =~ /exit/

    input
  end

  def set_players_colors
    screen.print_main_title
    puts "#{player1.name}, do you want to be black or white?:"
    player1.color = sanitize_color(gets.chomp.downcase.to_sym)
    player2.color = choose_player2_color
  end

  def sanitize_color(input)
    loop do
      return input          if input == :black || input == :white
      return game.load_game if input =~ /load/
      return game.finish    if input =~ /exit/

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

  def no_saved_game
    screen.print_main_title
    puts "There is no saved game to load. Please press ENTER to continue."
    sanitize_command(gets.chomp.downcase)
    game.start
  rescue Errno::ENOENT
    no_saved_game
  end
end
