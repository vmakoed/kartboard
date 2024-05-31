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

RolActiveRecord::Schema[7.1].define(version: 2024_05_31_202403) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.integer "created_by_id", null: false
    t.integer "game_id", null: false
    t.index ["created_by_id"], name: "index_contests_on_created_by_id"
    t.index ["game_id"], name: "index_contests_on_game_id"
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "games", force: :cascade do |t|
    t.string "title", null: false
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
    t.integer "previous_position"
    t.integer "new_position"
    t.integer "position_difference"
    t.index ["contestant_id"], name: "index_score_logs_on_contestant_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score", default: 1000, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "contestants", "contests"
  add_foreign_key "contestants", "users"
  add_foreign_key "contests", "games"
  add_foreign_key "contests", "users", column: "created_by_id"
  add_foreign_key "score_logs", "contestants"
end
