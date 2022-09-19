class Tournament < ApplicationRecord
    has_many :players
    has_many :rounds

    # With the players set, generates rounds and sets players as best as it can.
    def generate_rounds
        players.each do |player|
            player.rounds.clear
        end

        num_players = players.length

        if num_players <= 4
            round = rounds.build()
            round.players = players
            return
        end

        num_full_rounds = num_players / 4
        num_leftover = num_players % 4

        # Tracks the number of rounds to create
        round_position = 0

        if num_full_rounds > 4
            # TODO(catherine): Do recursion.
            # round_1_winners = num_full_rounds
            # solve(round_1_winners)
            # point round_1_winners to fill starting from beginning
            return
        end

        if num_leftover == 0
            final_round = rounds.build()
            players.each_slice(4) do |player_chunk|
                round = rounds.build(players: player_chunk, position: round_position)
                round_position += 1
                round.next_rounds << final_round
            end
            final_round.position = round_position
            # TODO(catherine): Add functionality to enable multiple previous/next rounds
            # final_round = rounds.build()
            # extra_round = rounds.build(next_round = final_round)
            # players.each_slice(4) do |player_chunk|
            #     if players.length == 4:
            #         round = rounds.build(players = player_chunk, next_round = extra_round)
            #     end
            # end
        end
    end
end
