# Controls game flow.
class Game
  attr_reader :board, :grid, :player1, :player2, :players

  def initialize(player1, player2)
    @board   = Board.new
    @grid    = @board.grid
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
    clear_screen
    puts "Thanks for playing. Hope you enjoyed it!\n\n"
    exit
  end

  private

  def players_turns
    loop do
      players.each do |player|
        print_board
        movement = input(player)
        board.move_piece(movement)
      end
    end
  end

  def input(player)
    puts "#{player.name}, introduce a movement:"
    gets.chomp
  end

  def print_board
    clear_screen
    puts
    print_game_title
    puts
    print_game_grid
    puts
  end

  def clear_screen
    system "clear" or system "cls"
  end

  def print_game_title
    puts "   #################################"
    puts "   #                               #"
    puts "   #             CHESS             #"
    puts "   #                               #"
    puts "   #################################"
  end

  def print_game_grid
    column_letters
    separator
    print_row(0)
    separator
    print_row(1)
    separator
    print_row(2)
    separator
    print_row(3)
    separator
    print_row(4)
    separator
    print_row(5)
    separator
    print_row(6)
    separator
    print_row(7)
    separator
    column_letters
  end

  def column_letters
    puts "     a   b   c   d   e   f   g   h"
  end

  def separator
    puts "   ---------------------------------"
  end

  def row_numbers
    %w[8 7 6 5 4 3 2 1]
  end

  def print_row(row)
    grid[row].each.with_index do |_column, column_index|
      print " #{row_numbers[row]}" if column_index.zero?
      print " | " if column_index.zero?
      print " | " if (1..7).cover?(column_index)
      print_square(row, column_index)
      print " |" if column_index == 7
      print " #{row_numbers[row]}\n" if column_index == 7
    end
  end

  def print_square(row, column_index)
    print grid[row][column_index]
  end
end
