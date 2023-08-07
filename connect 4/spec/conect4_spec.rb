require_relative '../lib/connect4'

describe Board do
    describe "#reset_board"do
        it "expect board to reset" do
            board = Board.new
            board.board = [["x", "sdadf", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", "adf", " _ ", " _ "]]  # Make some changes to the board
            board.board_reset
            expect(board.board).to eq([[" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "]]) 
        end
    end
    describe "#place_piece" do
        context "places piece on desired column." do
            it "column has no values" do
                board = Board.new
                board.place_piece(1, "X")
                expect(board.board).to eq([[" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                    [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                    [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                    [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                    [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                    [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "]])
            end
            it "column has no values" do
                board = Board.new
                board.place_piece(1, "X")
                board.place_piece(1, "X")
                expect(board.board).to eq([[" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                    [" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                    [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                    [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                    [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                    [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "]])
            end
        end
    end
    describe "#flip_board" do
        it "flips the current board" do
            board = Board.new
            board.board = [[" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                           [" _ ", " X ", " _ ", " _ ", " _ ", " _ ", " _ "],
                           [" _ ", " _ ", " X ", " _ ", " _ ", " _ ", " _ "],
                           [" _ ", " _ ", " _ ", " X ", " _ ", " _ ", " _ "],
                           [" _ ", " _ ", " _ ", " _ ", " X ", " _ ", " _ "],
                           [" _ ", " _ ", " _ ", " _ ", " _ ", " X ", " _ "]]
            result = board.flip_board
            expect(result).to eq([[" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " X "],
                                  [" _ ", " _ ", " _ ", " _ ", " _ ", " X ", " _ "],
                                  [" _ ", " _ ", " _ ", " _ ", " X ", " _ ", " _ "],
                                  [" _ ", " _ ", " _ ", " X ", " _ ", " _ ", " _ "],
                                  [" _ ", " _ ", " X ", " _ ", " _ ", " _ ", " _ "],
                                  [" _ ", " X ", " _ ", " _ ", " _ ", " _ ", " _ "]])
            
        end
    end
    describe "#check_win" do
        it "Row win"do

            board = Board.new
            board.board = [[" _ ", " X ", " X ", " X ", " X ", " X ", " _ "],
            [" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "]]
            result = board.check_win("X")
            expect(result).to be true
        end
        it "Row win second row" do

            board = Board.new
            board.board = [[" _ ", " X ", " X ", " X ", " _ ", " _ ", " _ "],
            [" X ", " X ", " X ", " X ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "]]
            result = board.check_win("X")
            expect(result).to be true
        end

        it "column win" do
            board = Board.new
            board.board = [[" _ ", " X ", " X ", " X ", " _ ", " _ ", " _ "],
            [" X ", " X ", " X ", " _ ", " _ ", " _ ", " _ "],
            [" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "]]
            result = board.check_win("X")
            expect(result).to be true
        end
        it "column win other column" do
            board = Board.new
            board.board = [[" _ ", " X ", " X ", " X ", " _ ", " _ ", " _ "],
            [" X ", " X ", " X ", " _ ", " _ ", " _ ", " _ "],
            [" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " X "],
            [" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " X "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " X "],
            [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " X "]]
            result = board.check_win("X")
            expect(result).to be true
        end
        it "diagonal win to the right" do
            board = Board.new
            board.board = [[" X ", " X ", " _ ", " _ ", " _ ", " _ ", " _ "],
                           [" X ", " X ", " X ", " _ ", " _ ", " _ ", " _ "],
                           [" X ", " _ ", " X ", " _ ", " _ ", " _ ", " X "],
                           [" _ ", " _ ", " _ ", " X ", " _ ", " _ ", " _ "],
                           [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                           [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " X "]]
            result = board.check_win("X")
            expect(result).to be true
        end
        it "more diagonal win to the right" do
            board = Board.new
            board.board = [[" X ", " X ", " _ ", " _ ", " _ ", " _ ", " _ "],
                           [" X ", " _ ", " X ", " _ ", " _ ", " _ ", " _ "],
                           [" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                           [" _ ", " X ", " _ ", " X ", " _ ", " _ ", " _ "],
                           [" _ ", " _ ", " X ", " _ ", " _ ", " _ ", " _ "],
                           [" _ ", " _ ", " _ ", " X ", " _ ", " _ ", " _ "]]
            result = board.check_win("X")
            expect(result).to be true
        end
        it "even more diagonal win to the right" do
            board = Board.new
            board.board = [[" X ", " X ", " _ ", " X ", " _ ", " _ ", " _ "],
                           [" X ", " X ", " X ", " _ ", " X ", " _ ", " _ "],
                           [" X ", " _ ", " _ ", " _ ", " _ ", " X ", " _ "],
                           [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " X "],
                           [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                           [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "]]
            result = board.check_win("X")
            expect(result).to be true
        end
        it "diagonal wins to the left" do
            board = Board.new
            board.board = [[" X ", " X ", " _ ", " _ ", " _ ", " _ ", " X "],
                           [" X ", " X ", " X ", " _ ", " _ ", " X ", " _ "],
                           [" X ", " _ ", " _ ", " _ ", " X ", " _ ", " _ "],
                           [" _ ", " _ ", " _ ", " X ", " _ ", " _ ", " _ "],
                           [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                           [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "]]
            result = board.check_win("X")
            expect(result).to be true
        end
        it "more diagonal wins to the left" do
            board = Board.new
            board.board = [[" X ", " _ ", " _ ", " X ", " _ ", " _ ", " X "],
                           [" _ ", " _ ", " X ", " _ ", " _ ", " X ", " _ "],
                           [" X ", " X ", " _ ", " _ ", " _ ", " _ ", " _ "],
                           [" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                           [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "],
                           [" _ ", " _ ", " _ ", " _ ", " _ ", " _ ", " _ "]]
            result = board.check_win("X")
            expect(result).to be true
        end

        it "more diagonal wins to the left" do
            board = Board.new
            board.board = [[" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " X "],
                           [" _ ", " _ ", " _ ", " _ ", " _ ", " X ", " _ "],
                           [" X ", " _ ", " _ ", " _ ", " _ ", " _ ", " X "],
                           [" _ ", " _ ", " _ ", " _ ", " _ ", " X ", " _ "],
                           [" _ ", " _ ", " _ ", " _ ", " X ", " _ ", " _ "],
                           [" _ ", " _ ", " _ ", " X ", " _ ", " _ ", " _ "]]
            result = board.check_win("X")
            expect(result).to be true
        end
    end
end

describe Player do
    describe "#update_marker" do
        it "changes marker from X to O" do
            me = Player.new("Hunter")
            me.update_marker("O")
            marker = me.marker
            expect(marker).to eq("O")
        end
    end
end

describe Game do
    
end