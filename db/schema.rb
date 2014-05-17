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

ActiveRecord::Schema.define(version: 20140515035856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: true do |t|
    t.string "name"
  end

  create_table "events", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "venue_id"
    t.integer  "artist_id"
  end

  add_index "events", ["artist_id"], name: "index_events_on_artist_id", using: :btree
  add_index "events", ["venue_id"], name: "index_events_on_venue_id", using: :btree

  create_table "festivals", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "venues", force: true do |t|
    t.string  "name"
    t.integer "festival_id"
  end

  add_index "venues", ["festival_id"], name: "index_venues_on_festival_id", using: :btree

end
