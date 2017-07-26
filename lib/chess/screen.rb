# Takes care of almost everything that needs to be printed to the screen.
class Screen
  attr_reader :grid

  def initialize(board)
    @board = board
    @grid  = board.grid
  end

  def print_introduction
    print_main_title
    print_instructions
  end

  def print_main_title
    clear
    puts "   _____ _    _ ______  _____ _____"
    puts "  / ____| |  | |  ____|/ ____/ ____|"
    puts " | |    | |__| | |__  | (___| (___"
    puts " | |    |  __  |  __|  \\___ \\\___  \\"
    puts " | |____| |  | | |____ ____) |___) |"
    puts "  \\_____|_|  |_|______|_____/_____/"
    puts
  end

  def print_board
    clear
    puts
    print_game_header
    puts
    print_game_grid
    puts
  end

  def clear
    system "clear" or system "cls"
  end

  private

  def print_instructions
    puts "Available commands during the game:"
    puts
    puts "- exit"
    puts "- save"
    puts "- load"
    puts
    puts "To move a piece type the piece position and the destination."
    puts "For example: 'a2a4'"
    puts
    puts "To see available destinations for a piece type only the piece position."
    puts "For example: 'a2'"
    puts
    puts "Type 'load' or press ENTER to start the game."
  end

  def print_game_header
    puts "   #################################"
    puts "   #                               #"
    puts "   #             CHESS             #"
    puts "   #                               #"
    puts "   #################################"
  end

  def print_game_grid
    column_letters
    separator_top_and_bottom
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
    separator_top_and_bottom
    column_letters
  end

  def column_letters
    puts "     a   b   c   d   e   f   g   h"
  end

  def separator_top_and_bottom
    puts "   ---------------------------------"
  end

  def separator
    puts "   |                               |"
  end

  def row_numbers
    %w[8 7 6 5 4 3 2 1]
  end

  def print_row(row)
    grid[row].each.with_index do |_column, column_index|
      print " #{row_numbers[row]}" if column_index.zero?
      print " | " if column_index.zero?
      print "   " if (1..7).cover?(column_index)
      print_square(row, column_index)
      print " |" if column_index == 7
      print " #{row_numbers[row]}\n" if column_index == 7
    end
  end

  def print_square(row, column_index)
    print grid[row][column_index]
  end
end
