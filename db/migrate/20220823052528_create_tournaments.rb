class CreateTournaments < ActiveRecord::Migration[7.0]
  def change
    create_table :tournaments do |t|
      t.string :title
      t.date :date

      t.timestamps
    end

    create_table :players do |t|
      t.string :name
      t.belongs_to :tournament, index: true, foreign_key: true

      t.timestamps
    end

    create_table :rounds do |t|
      t.integer :position
      t.references :next_round, foreign_key: { to_table: :rounds }
      t.belongs_to :tournament, index: true, foreign_key: true

      t.timestamps
    end

    create_table :players_rounds do |t|
      t.belongs_to :player
      t.belongs_to :round
    end
  end
end
