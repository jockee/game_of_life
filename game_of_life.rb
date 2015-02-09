require 'matrix'

class GameOfLife
  ROWS = 30
  COLS = 100
  LIVE_PERCENTAGE = 0.1
  SLEEP = 0.5

  def initialize
    @board = Matrix.build(ROWS, COLS) { rand(0) < LIVE_PERCENTAGE  }
  end

  def run
    loop { tick }
  end

  private

  def tick
    @board = Matrix.build(ROWS, COLS) { |row, col| alive_in_next_gen?(row, col) }
    sleep SLEEP
    output
  end

  def alive_in_next_gen?(row, col)
    @board[row, col] && [2, 3].include?(live_neighbours(row, col)) ||
      !@board[row, col] && live_neighbours(row, col) == 3
  end

  def live_neighbours(row, col)
    relative_neighbour_positions.reduce(0) do |acc, (relrow, relcol)|
      next acc if out_of_bounds?(relrow + row, relcol + col)

      acc + (@board[relrow + row, relcol + col] ? 1 : 0)
    end
  end

  def out_of_bounds?(row, col)
    !(0..@board.row_size-1).cover?(row) || !(0..@board.column_count-1).cover?(col)
  end

  def relative_neighbour_positions
    [
      [-1, -1], [-1, 0], [-1, 1],
      [0,  -1],          [0,  1],
      [1,  -1], [1,  0], [1,  1]
    ]
  end

  def output
    puts "\n" * 10
    @board.each_with_index do |alive, row, col|
      print "#{alive ? 'O' : ' ' }"
      print "\n" if (col + 1) == @board.column_count
    end
  end
end

GameOfLife.new.run
