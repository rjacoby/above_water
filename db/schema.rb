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

ActiveRecord::Schema.define(version: 20150619032901) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "lookups", force: :cascade do |t|
    t.string   "query"
    t.string   "since_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "lookups", ["query"], name: "index_lookups_on_query", unique: true, using: :btree

  create_table "tweets", force: :cascade do |t|
    t.integer  "lookup_id"
    t.string   "tweet_id"
    t.datetime "tweeted_at"
    t.string   "periscope_url"
    t.text     "oembed_code"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tweets", ["lookup_id", "tweet_id"], name: "index_tweets_on_lookup_id_and_tweet_id", unique: true, using: :btree
  add_index "tweets", ["tweet_id"], name: "index_tweets_on_tweet_id", using: :btree

  create_table "whitelist_users", force: :cascade do |t|
    t.string   "handle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "channel"
  end

  add_index "whitelist_users", ["channel"], name: "index_whitelist_users_on_channel", using: :btree
  add_index "whitelist_users", ["handle"], name: "index_whitelist_users_on_handle", unique: true, using: :btree

  add_foreign_key "tweets", "lookups"
end
