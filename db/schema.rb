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

ActiveRecord::Schema[7.1].define(version: 2023_12_03_154332) do
  create_table "players", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "run_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["run_id", "user_id"], name: "index_players_on_run_id_and_user_id", unique: true
    t.index ["run_id"], name: "index_players_on_run_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "runs", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code", limit: 6, null: false
    t.string "aasm_state"
    t.index ["code"], name: "index_runs_on_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "players", "runs"
  add_foreign_key "players", "users"
end
