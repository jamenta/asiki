# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170302185855) do

  create_table "contest_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "comment"
    t.integer  "user_id"
    t.integer  "contest_id"
    t.index ["contest_id"], name: "index_contest_comments_on_contest_id"
    t.index ["user_id"], name: "index_contest_comments_on_user_id"
  end

  create_table "contestants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "contest_id"
    t.boolean  "accepted"
    t.index ["contest_id"], name: "index_contestants_on_contest_id"
    t.index ["user_id"], name: "index_contestants_on_user_id"
  end

  create_table "contests", force: :cascade do |t|
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "contest_name"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "user_id"
    t.string   "emoji_title",  default: ":earth_americas:"
    t.index ["user_id"], name: "index_contests_on_user_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string   "exercise_description"
    t.integer  "workout_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "points"
    t.integer  "reps_per_round"
    t.index ["workout_id"], name: "index_exercises_on_workout_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "post_id"
    t.string   "user_type"
    t.integer  "user_id"
    t.index ["post_id"], name: "index_favorites_on_post_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
    t.index ["user_type"], name: "index_favorites_on_user_type_and_user_id"
  end

  create_table "friend_invitations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "email"
    t.index ["user_id"], name: "index_friend_invitations_on_user_id"
  end

  create_table "friends", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status"
    t.index ["user_id"], name: "index_friends_on_user_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "contest_id"
    t.string   "email"
    t.date     "expiration"
    t.index ["contest_id"], name: "index_invitations_on_contest_id"
    t.index ["email"], name: "index_invitations_on_email"
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "sender_id"
    t.string   "message"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "notification_type"
    t.string   "description"
    t.boolean  "read",              default: false
    t.integer  "user_id"
    t.string   "link_url"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "comment"
    t.integer  "user_id"
    t.integer  "workout_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "current"
    t.index ["user_id"], name: "index_posts_on_user_id"
    t.index ["workout_id"], name: "index_posts_on_workout_id"
  end

  create_table "results", force: :cascade do |t|
    t.integer  "reps"
    t.integer  "exercise_id"
    t.integer  "workout_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "post_id"
    t.index ["exercise_id"], name: "index_results_on_exercise_id"
    t.index ["post_id"], name: "index_results_on_post_id"
    t.index ["user_id"], name: "index_results_on_user_id"
    t.index ["workout_id"], name: "index_results_on_workout_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "state"
    t.string   "results_settings"
    t.string   "emoji_title"
    t.string   "gravatar"
    t.boolean  "gravatar_bool",    default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "workouts", force: :cascade do |t|
    t.integer  "workout_length"
    t.string   "video_url"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.date     "start_date"
    t.date     "end_date"
    t.string   "image_url"
    t.string   "short_description"
    t.string   "long_description"
    t.string   "gif_url"
    t.boolean  "rounds",            default: false
  end

end
