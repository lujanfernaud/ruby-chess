# Takes care of almost everything that needs to be printed to the screen.
class Printer
  attr_reader :grid

  def initialize(board)
    @board = board
    @grid  = board.grid
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

  private

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
