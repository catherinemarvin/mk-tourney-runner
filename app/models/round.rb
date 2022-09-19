class Round < ApplicationRecord
    belongs_to :tournament
    has_and_belongs_to_many :players

    has_many :previous_round_edges, foreign_key: :end_id, class_name: "RoundEdge"
    has_many :previous_rounds, through: :previous_round_edges, source: :start

    has_many :next_round_edges, foreign_key: :start_id, class_name: "RoundEdge"
    has_many :next_rounds, through: :next_round_edges, source: :end
end