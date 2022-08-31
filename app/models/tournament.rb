class Tournament < ApplicationRecord
    has_many :players
    has_many :rounds

    # With the players set, generates rounds and sets players as best as it can.
    def generate_rounds
        players.each do |player|
            player.rounds.clear
        end

        num_players = players.count

        if num_players < 4
            round = rounds.build(position: 0)
            round.players = players
        end
    end
end
