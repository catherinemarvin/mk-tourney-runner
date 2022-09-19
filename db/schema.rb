# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_03_003311) do
  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_players_on_tournament_id"
  end

  create_table "players_rounds", force: :cascade do |t|
    t.integer "player_id"
    t.integer "round_id"
    t.index ["player_id"], name: "index_players_rounds_on_player_id"
    t.index ["round_id"], name: "index_players_rounds_on_round_id"
  end

  create_table "round_edges", force: :cascade do |t|
    t.integer "start_id"
    t.integer "end_id"
    t.index ["end_id"], name: "index_round_edges_on_end_id"
    t.index ["start_id"], name: "index_round_edges_on_start_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "position"
    t.integer "next_round_id"
    t.integer "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "players", "tournaments"
  add_foreign_key "round_edges", "rounds", column: "end_id"
  add_foreign_key "round_edges", "rounds", column: "start_id"
  add_foreign_key "rounds", "rounds", column: "next_round_id"
  add_foreign_key "rounds", "tournaments"
end
