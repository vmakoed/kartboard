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

ActiveRecord::Schema[7.1].define(version: 2024_02_13_205211) do
  create_table "contestants", force: :cascade do |t|
    t.integer "contest_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "place", null: false
    t.index ["contest_id"], name: "index_contestants_on_contest_id"
    t.index ["user_id", "contest_id"], name: "index_contestants_on_user_id_and_contest_id", unique: true
    t.index ["user_id"], name: "index_contestants_on_user_id"
  end

  create_table "contests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "score_logs", force: :cascade do |t|
    t.integer "contestant_id", null: false
    t.integer "previous_score", null: false
    t.integer "new_score", null: false
    t.integer "score_difference", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contestant_id"], name: "index_score_logs_on_contestant_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score", default: 1000, null: false
  end

  add_foreign_key "contestants", "contests"
  add_foreign_key "contestants", "users"
  add_foreign_key "score_logs", "contestants"
end
