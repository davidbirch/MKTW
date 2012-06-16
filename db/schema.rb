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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120616045514) do

  create_table "new_raw_tweets", :force => true do |t|
    t.text     "raw"
    t.string   "tweet_guid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "parsed_raw_tweets", :force => true do |t|
    t.text     "raw"
    t.string   "tweet_guid"
    t.string   "parse_status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "tweets", :force => true do |t|
    t.string   "tweet_text"
    t.string   "tweet_created_at"
    t.string   "tweet_guid"
    t.string   "tweet_source"
    t.string   "user_guid"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "user_guid"
    t.string   "screen_name"
    t.integer  "friends_count"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
