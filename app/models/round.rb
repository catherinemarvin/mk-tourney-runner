class Round < ApplicationRecord
    belongs_to :tournament
    has_one :previous_round, class_name: "Round", foreign_key: "next_round_id"
    belongs_to :next_round, class_name: "Round", optional: true
    has_and_belongs_to_many :players
end