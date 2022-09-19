class CreateRoundEdges < ActiveRecord::Migration[7.0]
  def change
    create_table :round_edges do |t|
      t.references :start, foreign_key: { to_table: :rounds }
      t.references :end, foreign_key: { to_table: :rounds }
    end

    change_table :rounds do |t|
      t.remove :next_round, type: :integer
      t.remove_index :next_round_id
    end
  end
end
