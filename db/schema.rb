# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140812020944) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: true do |t|
    t.string "name"
    t.string "soundcloud_url"
    t.string "soundcloud_track_url"
  end

  create_table "events", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "festival_id"
    t.integer  "venue_id"
    t.integer  "artist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["artist_id"], name: "index_events_on_artist_id", using: :btree
  add_index "events", ["festival_id"], name: "index_events_on_festival_id", using: :btree
  add_index "events", ["venue_id"], name: "index_events_on_venue_id", using: :btree

  create_table "festivals", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "website"
    t.string   "twitter_handle"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",         default: false
    t.boolean  "show_schedule",  default: false
  end

  create_table "schedule_events", force: true do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.integer  "event_id",    null: false
    t.integer  "schedule_id", null: false
  end

  add_index "schedule_events", ["event_id"], name: "index_schedule_events_on_event_id", using: :btree
  add_index "schedule_events", ["schedule_id"], name: "index_schedule_events_on_schedule_id", using: :btree

  create_table "schedules", force: true do |t|
    t.string   "hashed_id"
    t.integer  "festival_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "schedules", ["festival_id"], name: "index_schedules_on_festival_id", using: :btree
  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id", using: :btree

  create_table "trackers", force: true do |t|
    t.string  "instance_class",             null: false
    t.integer "instance_id",                null: false
    t.string  "subject",                    null: false
    t.integer "count",          default: 0
  end

  create_table "users", force: true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "email",                      null: false
    t.boolean "admin",      default: false
  end

  create_table "venues", force: true do |t|
    t.string  "name"
    t.integer "festival_id"
  end

  add_index "venues", ["festival_id"], name: "index_venues_on_festival_id", using: :btree

end
