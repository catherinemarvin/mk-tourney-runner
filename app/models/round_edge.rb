class RoundEdge < ApplicationRecord
    belongs_to :start, foreign_key: :start_id, class_name: "Round"
    belongs_to :end, foreign_key: :end_id, class_name: "Round"
end