class Board
    attr_accessor :board
    def initialize
        @board = [[" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                  [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                  [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                  [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                  [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                  [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "]]
    end
    def board_reset
        @board = [[" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                 [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                 [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                 [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                 [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                 [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "]]
    end
    def board_display
        puts"""
        |#{@board[5][0]}|#{@board[5][1]}|#{@board[5][2]}|#{@board[5][3]}|#{@board[5][4]}|#{@board[5][5]}|#{@board[5][6]}|\n
        |#{@board[4][0]}|#{@board[4][1]}|#{@board[4][2]}|#{@board[4][3]}|#{@board[4][4]}|#{@board[4][5]}|#{@board[4][6]}|\n
        |#{@board[3][0]}|#{@board[3][1]}|#{@board[3][2]}|#{@board[3][3]}|#{@board[3][4]}|#{@board[3][5]}|#{@board[3][6]}|\n
        |#{@board[2][0]}|#{@board[2][1]}|#{@board[2][2]}|#{@board[2][3]}|#{@board[2][4]}|#{@board[2][5]}|#{@board[2][6]}|\n
        |#{@board[1][0]}|#{@board[1][1]}|#{@board[1][2]}|#{@board[1][3]}|#{@board[1][4]}|#{@board[1][5]}|#{@board[1][6]}|\n
        |#{@board[0][0]}|#{@board[0][1]}|#{@board[0][2]}|#{@board[0][3]}|#{@board[0][4]}|#{@board[0][5]}|#{@board[0][6]}|\n
        | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
        """
    end
    def place_piece(column, marker)
        col = column - 1
        @board.each_with_index do |row, row_index|
            if @board[row_index][col] == " _ "
                
                @board[row_index][col] = " #{marker} "
                break
            end
        end
    end
    def check_array?(arr, marker)
        win_string = marker + marker + marker + marker
        no_spaces = arr.map{ |str| str.gsub(" ", "") }
        result = no_spaces.join("")
        if result.match(win_string)
            return true
        end
    end
    def check_win(marker)
        win_string = marker + marker + marker + marker
        #checks rows
        @board.each do |row|
            if check_array?(row, marker)
                return true
            end
        end
        #checks columns
        (0..6).each do |col|
            column = [@board[0][col], @board[1][col],@board[2][col],@board[3][col],@board[4][col],@board[5][col]]
            if check_array?(column, marker)
                return true
            end
        end
        #checks right diagonals from the top 
        (0..3).each do |start_col|
            row = 0
            arr = []
            (0..6).each do |col_adder|
                if row <= 5
                    if start_col + col_adder <= 6
                        column = start_col + col_adder  # Fixed the typo here
                        
                        arr << @board[row][column]
                        row += 1
                    end
                end
            end
            if check_array?(arr, marker)
                return true
            end
        end

        #checks right diagonals from the left side
        max_col=6 #starts one higher that it will see
        (1..2).each do |start_row|
            max_col -= 1
            arr = []
            row = 0 + start_row
            (0..5).each do |column|
                # puts "arr: #{arr} row: #{row} col: #{column}"
                if row <= 5
                    if column <= max_col
                        arr << @board[row][column]
                        row += 1
                    end
                end
            end
            if check_array?(arr, marker)
                return true
            end
        end


        return false 
    end
end
class Player
    attr_accessor :marker, :name
    def initialize(name)
        @name = name
        @marker = "X"
    end
    def update_marker(x)
        @marker = x
    end
end

class Game
    def initialize(board, p1, p2)
        @board = board
        @p1 = p1
        @p2 = p2
        @p2.update_marker("O")
        @turn = 0
        @current_turn = @p1
    end
end
if __FILE__ == $0
    board = Board.new
    board.board_display
    board.board = [[" _ ", " _ ", " _ ", " X ", " X ", " _ ", " _ "],
            [" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "]]
    board.check_win("X")
    p1 = Player.new("hunter")
    p2 = Player.new("bot")
    g = Game.new(board, p1, p2)
end