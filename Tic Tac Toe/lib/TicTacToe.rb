class Board
    attr_reader :board

    def initialize
        @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    end

    def reset_board
        @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    end

    def display_board
        puts "#{board[0]}|#{board[1]}|#{board[2]}\n_|_|_\n#{board[3]}|#{board[4]}|#{board[5]}\n_|_|_\n#{board[6]}|#{board[7]}|#{board[8]}"
    end
end

class Player
    attr_accessor :tiles, :marker, :wins, :name
    def initialize(name)
        @name = name
        @tiles = []
        @wins = 0
        @marker = "X"
    end
    def update_marker(m)
        @marker = m
    end

    def select_tile(board)
        print "#{name}'s turn: "
        tile = gets.to_i
        if tile > 9 && tile < 1
            puts "Out of range! Select an open and existing tile."
            select_tile(board)
        else
            idx = board.board.find_index(tile)
            if idx == nil
                puts "Choose an open space!"
                
                select_tile(board)
            else
                board.board[idx] = marker
                @tiles << tile
            end
        end
    end
    def reset_player
        @tiles = []
    end
end

class Game
    attr_accessor :current_turn, :x, :o
    def initialize(board, x, o)
        @board = board
        @x = x
        @o = o
        @o.update_marker("O")
        @current_turn = x
        @positions = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
    end

    def player_turn
        if @current_turn == @x
            @board.display_board
            @x.select_tile(@board)
            self.check_win
            @current_turn = @o
            self.player_turn
        else
            @board.display_board
            @o.select_tile(@board)
            self.check_win
            @current_turn = @x
            self.player_turn
        end
    end
    def player_swap
        @board.display_board
        players = [@x, @o]
        @x = players[1]
        puts "x is now #{@x.name}"
        @o = players[0]
        puts "o is now #{@o.name}"
        @x.update_marker("X")
        @o.update_marker("O")
        
    end
    def check_win
        players_tiles = current_turn.tiles
        @positions.each do |pos|
            if players_tiles.include?(pos[0]) && players_tiles.include?(pos[1]) && players_tiles.include?(pos[2])
                @current_turn.wins += 1
                @board.reset_board
                @x.reset_player
                @o.reset_player

                
                puts "#{current_turn.name} wins!"
                puts "#{@x.name}: #{@x.wins} | #{@o.name}: #{@o.wins}"
                return self.next_game
            end
        end
    end
    def next_game
        print "Do you want to play again? (y/n): "
        choice = gets.strip
        puts choice
        if choice == "y"
            
            self.player_swap
            self.player_turn
        else
            exit(true)
        end
    end
end
if __FILE__ == $0
    hunter = Player.new("Hunter")
    bot = Player.new("bot")
    board = Board.new
    game = Game.new(board, hunter, bot)
    game.player_turn
end