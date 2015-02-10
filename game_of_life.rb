require 'matrix'

class GameOfLife
  ROWS = 30
  COLS = 100
  LIVE_PERCENTAGE = 0.1
  SLEEP = 0.3

  def initialize
    @board = Matrix.build(ROWS, COLS) { rand(0) < LIVE_PERCENTAGE }
  end

  def run
    loop do
      @board = Matrix.build(ROWS, COLS) { |row, col| Cell.new(@board, row, col).alive_in_next_gen? }
      sleep SLEEP
      output
    end
  end

  private

  def output
    puts "\n" * 10
    @board.each_with_index do |alive, row, col|
      print "#{alive ? 'O' : ' ' }"
      puts if (col + 1) == @board.column_count
    end
  end

  class Cell
    RELATIVE_NEIGHBOUR_POSITIONS = [
      [-1, -1], [-1, 0], [-1, 1],
      [ 0, -1],          [ 0, 1],
      [ 1, -1], [ 1, 0], [ 1, 1]
    ]

    def initialize(board, row, col)
      @board = board
      @row = row
      @col = col
    end

    def alive_in_next_gen?
      alive && [2, 3].include?(live_neighbour_count) ||
        !alive && live_neighbour_count == 3
    end

    private

    def alive
      @board[@row, @col]
    end

    def live_neighbour_count
      @live_neighbour_count ||= RELATIVE_NEIGHBOUR_POSITIONS.reduce(0) do |acc, (relrow, relcol)|
        next acc unless within_bounds?(relrow + @row, relcol + @col)

        acc + (@board[relrow + @row, relcol + @col] ? 1 : 0)
      end
    end

    def within_bounds?(row, col)
      (0..@board.row_size - 1).cover?(row) && (0..@board.column_count - 1).cover?(col)
    end
  end
end

GameOfLife.new.run
