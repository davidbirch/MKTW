class CreateParsedRawTweets < ActiveRecord::Migration
  def change
    create_table :parsed_raw_tweets do |t|
      t.text :raw
      t.integer :tweet_guid
      t.string :parse_status

      t.timestamps
    end
  end
end
