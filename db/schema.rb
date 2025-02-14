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

ActiveRecord::Schema[8.0].define(version: 2025_02_13_063826) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "goal_plans", force: :cascade do |t|
    t.string "title", null: false
    t.string "purpose", null: false
    t.string "repeat_term", null: false
    t.time "repeat_time", null: false
    t.string "advice"
    t.string "duration", default: "entire_day", null: false
    t.integer "duration_length"
    t.string "duration_measure"
    t.bigint "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_goal_plans_on_creator_id"
  end

  create_table "goal_progresses", force: :cascade do |t|
    t.bigint "goal_id", null: false
    t.date "date", null: false
    t.boolean "completed", default: false, null: false
    t.datetime "checked_at"
    t.integer "current_streak", default: 0
    t.integer "longest_streak", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_goal_progresses_on_goal_id"
  end

  create_table "goals", force: :cascade do |t|
    t.string "title", null: false
    t.string "purpose", null: false
    t.string "repeat_term", null: false
    t.time "repeat_time", null: false
    t.string "advice"
    t.boolean "set_reminder", default: false
    t.integer "reminder_minutes"
    t.string "duration", default: "entire_day", null: false
    t.integer "duration_length"
    t.string "duration_measure"
    t.string "graph_type", default: "dot", null: false
    t.boolean "is_private", default: true
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "goal_progresses", "goals"
  add_foreign_key "goals", "users"
end
