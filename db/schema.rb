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

ActiveRecord::Schema.define(:version => 20120701034747) do

  create_table "companies", :force => true do |t|
    t.string   "company_name"
    t.string   "company_description"
    t.string   "asx_code"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "company_keywords", :force => true do |t|
    t.string   "company_keyword"
    t.integer  "company_id"
    t.string   "company_name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "company_prices", :force => true do |t|
    t.datetime "price_time"
    t.decimal  "price_value",  :precision => 10, :scale => 0
    t.integer  "company_id"
    t.string   "company_name"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "new_raw_tweets", :force => true do |t|
    t.text     "raw"
    t.integer  "tweet_guid", :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "parsed_raw_tweets", :force => true do |t|
    t.text     "raw"
    t.integer  "tweet_guid",   :limit => 8
    t.string   "parse_status"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "tags", :force => true do |t|
    t.integer  "tweet_id"
    t.integer  "tweet_guid", :limit => 8
    t.string   "tag_name"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "tweets", :force => true do |t|
    t.string   "tweet_text"
    t.datetime "tweet_created_at"
    t.integer  "tweet_guid",         :limit => 8
    t.string   "tweet_source"
    t.integer  "user_id"
    t.integer  "user_guid",          :limit => 8
    t.integer  "company_keyword_id"
    t.string   "company_keyword"
    t.string   "sentiment"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "user_guid",         :limit => 8
    t.string   "screen_name"
    t.integer  "friends_count"
    t.string   "name"
    t.string   "profile_image_url"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

end
