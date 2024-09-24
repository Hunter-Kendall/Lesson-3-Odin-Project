require_relative '../lib/TicTacToe'

describe Board do
    describe "#initialize" do
        it "should initialize the board with the correct initial values" do
            board = Board.new
            expect(board.board).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9])
        end
    end

    describe "#reset_board" do
        it "should reset the board to its initial values" do
            board = Board.new
            board.board = ["X", "O", 3, 4, 5, 6, 7, 8, 9]  # Make some changes to the board
            board.reset_board
            expect(board.board).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9])  # Check if the board is reset
        end
    end

    describe "#display_board" do
        it "should display the current board in the correct format" do
            board = Board.new
            expect { board.display_board }.to output("1|2|3\n_|_|_\n4|5|6\n_|_|_\n7|8|9\n").to_stdout
        end
    end
end

describe Player do
    describe "#initialize" do
        it "should initialize the player with the correct initial values" do
            player = Player.new("John")
            expect(player.name).to eq("John")
            expect(player.tiles).to eq([])
            expect(player.wins).to eq(0)
            expect(player.marker).to eq("X")
        end
    end

    describe "#update_marker" do
        it "should update the player's marker" do
            player = Player.new("Alice")
            player.update_marker("A")
            expect(player.marker).to eq("A")
        end
    end

    describe "#select_tile" do
        let(:game_board) { instance_double(Board, board: ["X", 2, 3, 4, 5, 6, 7, 8, 9]) }
        subject(:player) { described_class.new("Hunter") }
        context "player selects" do
            before do
                valid_input = '3'
                allow(player).to receive(:gets).and_return(valid_input)
            end
            it "open tile" do
                player.select_tile(game_board)
                expect(player.tiles[0]).to eq(3)
            end

        end
        context "player selects" do
            before do
                invalid_input = '1'
                valid_input = '3'
                allow(player).to receive(:gets).and_return(invalid_input, valid_input)
            end
            it "taken tile which expects error message then select correct tile" do
                error_message = "Choose an open space!"
                expect(player).to receive(:puts).with(error_message).once
                player.select_tile(game_board)
            end

        end

        context "player selects" do
            before do
                invalid_input = '0'
                valid_input = '3'
                allow(player).to receive(:gets).and_return(invalid_input, valid_input)
            end
            it "out of range tile which expects error message then select correct tile" do
                error_message = "Out of range! Select an open and existing tile."
                expect(player).to receive(:puts).with(error_message).once
                player.select_tile(game_board)
            end

        end

        # Write test cases to test the select_tile method.
        # You can use test doubles for the 'Board' class to isolate the testing.
    end

    describe "#reset_player" do
        it "should reset the player's tiles" do
            player = Player.new("Bob")
            player.tiles = [1, 2, 3]
            player.reset_player
            expect(player.tiles).to eq([])
        end
    end
end

describe Game do
    let(:hunter) { Player.new("Hunter") }
    let(:bot) { Player.new("bot") }
    let(:board) { Board.new }

    describe "#initialize" do
        it "should initialize the game with the correct initial values" do
            game = Game.new(board, hunter, bot)
            expect(game.current_turn).to eq(hunter)
            expect(game.x).to eq(hunter)
            expect(game.o).to eq(bot)
        end
    end

    describe "#player_swap" do
        it "should swap the players correctly" do
            game = Game.new(board, hunter, bot)
            game.player_swap
            expect(game.current_turn).to eq(bot)
            expect(game.x).to eq(bot)
            expect(game.o).to eq(hunter)
        end
    end

    describe "#check_win" do
        # Write test cases to test the check_win method.
        # You can use test doubles for the 'Player' class to isolate the testing.
        let(:game_board) { instance_double(Board, board: ["X", "X", "X", "O", "O", 6, 7, 8, 9]) }
        let(:player_1) { instance_double(Player, tiles: [], marker: "X", wins: 0) }
        let(:player_2) { instance_double(Player, tiles: [], marker: "O", wins: 0) }
        subject(:game) { described_class.new(game_board, player_1, player_2) }

        context "when player is" do
            before do
                allow(player_1).to receive(:tiles).and_return([1, 2, 7])
                allow(player_2).to receive(:tiles).and_return([4, 5, 9])
                allow(player_2).to receive(:update_marker).and_return("O")
            end
            it 'not in a winning position' do
                expect(game.check_win).to be false
            end
        end
        context "when player is" do
            before do
                allow(player_1).to receive(:tiles).and_return([1, 2, 3])
                allow(player_2).to receive(:tiles).and_return([4, 5, 9])
                allow(player_2).to receive(:update_marker).and_return("O")
                allow(player_1).to receive(:wins=)
                allow(player_2).to receive(:reset_player)
                allow(player_1).to receive(:reset_player)

                allow(game_board).to receive(:reset_board)
            end
            it 'in a winning position of 1,2,3' do
                expect(game.check_win).to be true
            end
            it 'winning player wins increases by 1' do
                expect(player_1).to receive(:wins=).with(1)
                game.check_win

            end
        end
        context "when player is" do
            before do
                allow(player_1).to receive(:tiles).and_return([4, 5, 6])
                allow(player_2).to receive(:tiles).and_return([4, 5, 9])
                allow(player_2).to receive(:update_marker).and_return("O")
                allow(player_1).to receive(:wins=)
                allow(player_2).to receive(:reset_player)
                allow(player_1).to receive(:reset_player)

                allow(game_board).to receive(:reset_board)
            end
            it 'in a winning position of 4,5,6' do
                expect(game.check_win).to be true
            end
            it 'winning player wins increases by 1' do
                expect(player_1).to receive(:wins=).with(1)
                game.check_win

            end
        end
        context "when player is" do
            before do
                allow(player_1).to receive(:tiles).and_return([7, 8, 9])
                allow(player_2).to receive(:tiles).and_return([4, 5, 9])
                allow(player_2).to receive(:update_marker).and_return("O")
                allow(player_1).to receive(:wins=)
                allow(player_2).to receive(:reset_player)
                allow(player_1).to receive(:reset_player)

                allow(game_board).to receive(:reset_board)
            end
            it 'in a winning position of 7,8,9' do
                expect(game.check_win).to be true
            end
            it 'winning player wins increases by 1' do
                expect(player_1).to receive(:wins=).with(1)
                game.check_win

            end
        end
        context "when player is" do
            before do
                allow(player_1).to receive(:tiles).and_return([1, 4, 7])
                allow(player_2).to receive(:tiles).and_return([4, 5, 9])
                allow(player_2).to receive(:update_marker).and_return("O")
                allow(player_1).to receive(:wins=)
                allow(player_2).to receive(:reset_player)
                allow(player_1).to receive(:reset_player)

                allow(game_board).to receive(:reset_board)
            end
            it 'in a winning position of 1,4,7' do
                expect(game.check_win).to be true
            end
            it 'winning player wins increases by 1' do
                expect(player_1).to receive(:wins=).with(1)
                game.check_win

            end
        end
        context "when player is" do
            before do
                allow(player_1).to receive(:tiles).and_return([2, 5, 8])
                allow(player_2).to receive(:tiles).and_return([4, 5, 59])
                allow(player_2).to receive(:update_marker).and_return("O")
                allow(player_1).to receive(:wins=)
                allow(player_2).to receive(:reset_player)
                allow(player_1).to receive(:reset_player)

                allow(game_board).to receive(:reset_board)
            end
            it 'in a winning position of 2, 5, 8' do
                expect(game.check_win).to be true
            end
            it 'winning player wins increases by 1' do
                expect(player_1).to receive(:wins=).with(1)
                game.check_win

            end
        end
        context "when player is" do
            before do
                allow(player_1).to receive(:tiles).and_return([3, 6, 9])
                allow(player_2).to receive(:tiles).and_return([4, 5, 9])
                allow(player_2).to receive(:update_marker).and_return("O")
                allow(player_1).to receive(:wins=)
                allow(player_2).to receive(:reset_player)
                allow(player_1).to receive(:reset_player)

                allow(game_board).to receive(:reset_board)
            end
            it 'in a winning position of 3,6,9' do
                expect(game.check_win).to be true
            end
            it 'winning player wins increases by 1' do
                expect(player_1).to receive(:wins=).with(1)
                game.check_win

            end
        end
        context "when player is" do
            before do
                allow(player_1).to receive(:tiles).and_return([1, 5, 9])
                allow(player_2).to receive(:tiles).and_return([4, 5, 9])
                allow(player_2).to receive(:update_marker).and_return("O")
                allow(player_1).to receive(:wins=)
                allow(player_2).to receive(:reset_player)
                allow(player_1).to receive(:reset_player)

                allow(game_board).to receive(:reset_board)
            end
            it 'in a winning position of 1, 5, 9' do
                expect(game.check_win).to be true
            end
            it 'winning player wins increases by 1' do
                expect(player_1).to receive(:wins=).with(1)
                game.check_win

            end
        end
        context "when player is" do
            before do
                allow(player_1).to receive(:tiles).and_return([3, 7, 5])
                allow(player_2).to receive(:tiles).and_return([4, 5, 9])
                allow(player_2).to receive(:update_marker).and_return("O")
                allow(player_1).to receive(:wins=)
                allow(player_2).to receive(:reset_player)
                allow(player_1).to receive(:reset_player)

                allow(game_board).to receive(:reset_board)
            end
            it 'in a winning position of 3, 7, 5. numbers are mixed' do
                expect(game.check_win).to be true
            end
            it 'winning player wins increases by 1' do
                expect(player_1).to receive(:wins=).with(1)
                game.check_win

            end
        end
    end

    describe "#next_game" do
        # Write test cases to test the next_game method.
        # You can use test doubles and stubs/mocks for 'gets' method to simulate user input.
        let(:game_board) { instance_double(Board, board: ["X", "X", "X", "O", "O", 6, 7, 8, 9]) }
        let(:player_1) { instance_double(Player, tiles: [], marker: "X", wins: 0) }
        let(:player_2) { instance_double(Player, tiles: [], marker: "O", wins: 0) }
        subject(:game) { described_class.new(board, hunter, bot) }
        context "players want to play again" do
            before do
                yes = "y"
                allow(game).to receive(:gets).and_return(yes)
                allow(game).to receive(:player_swap)
                allow(game).to receive(:player_turn)
            end
            it "receives player_swap" do
                expect(game).to receive(:player_swap)
                game.next_game
            end
            it "receives player_turn" do
                expect(game).to receive(:player_turn)
                game.next_game
            end
        end
    end

    describe "#player_turn" do
        # Write test cases to test the player_turn method.
        # You can use test doubles and stubs/mocks for 'gets' method to simulate user input.
        let(:board) { instance_double(Board) }
        let(:hunter) { instance_double(Player, tiles: [], name: "Hunter", wins: 0) }
        let(:bot) { instance_double(Player, tiles: [], name: "bot", wins: 0) }
        subject(:game) { described_class.new(board, hunter, bot) }

        context "turn is X" do
            before do
                allow(hunter).to receive(:update_marker)
                allow(bot).to receive(:update_marker)
                allow(board).to receive(:display_board)
                allow(hunter).to receive(:select_tile)
                allow(bot).to receive(:select_tile)
                allow(game).to receive(:check_win).and_return(true)
                allow(game).to receive(:next_game)
            end

            it "and X wins" do
                expect(game).to receive(:next_game)
                game.player_turn
            end

            it "should call check_win" do
                expect(game).to receive(:check_win).and_call_original
                game.player_turn
            end
        end
        context "turn is X" do
            before do
                allow(hunter).to receive(:update_marker)
                allow(bot).to receive(:update_marker)
                allow(board).to receive(:display_board)
                allow(hunter).to receive(:select_tile)
                allow(bot).to receive(:select_tile)
                allow(game).to receive(:check_win).and_return(true)
                allow(game).to receive(:next_game)
            end

            it "should call player_turn" do
                expect(game).to receive(:player_turn).and_call_original
                game.player_turn
            end
        end

        # Add similar tests for when turn is O

        context "turn is O" do
            before do
                allow(hunter).to receive(:update_marker)
                allow(bot).to receive(:update_marker)
                allow(game).to receive(:current_turn).and_return(bot)
                allow(board).to receive(:display_board)
                allow(hunter).to receive(:select_tile)
                allow(bot).to receive(:select_tile)
                allow(game).to receive(:check_win).and_return(true)
                allow(game).to receive(:next_game)
            end

            it "and O wins" do
                expect(game).to receive(:next_game)
                game.player_turn
            end

            it "should call check_win" do
                expect(game).to receive(:check_win).and_call_original
                game.player_turn
            end
        end
        context "turn is O" do
            before do
                allow(hunter).to receive(:update_marker)
                allow(bot).to receive(:update_marker)
                allow(board).to receive(:display_board)
                allow(game).to receive(:current_turn).and_return(bot)
                allow(hunter).to receive(:select_tile)
                allow(bot).to receive(:select_tile)
                allow(game).to receive(:check_win).and_return(true)
                allow(game).to receive(:next_game)

            end

            it "should call player_turn" do
                expect(game).to receive(:player_turn).and_call_original
                game.player_turn
            end
        end
        context "no one wins" do
            before do
                allow(hunter).to receive(:update_marker)
                allow(bot).to receive(:update_marker)
                allow(board).to receive(:display_board)
                allow(hunter).to receive(:select_tile)
                allow(bot).to receive(:select_tile)
                allow(game).to receive(:turn).and_return(9)
                allow(game).to receive(:next_game)


            end
            it "because its a draw message" do
                message = "Game is a Draw!"
                expect(game).to receive(:puts).with(message).once
                game.player_turn
            end
            it "because its a draw and run next_game" do
                message = "Game is a Draw!"
                expect(game).to receive(:next_game)
                game.player_turn
            end
        end
    end
end
