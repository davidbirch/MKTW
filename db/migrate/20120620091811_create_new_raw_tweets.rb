class CreateNewRawTweets < ActiveRecord::Migration
  def change
    create_table :new_raw_tweets do |t|
      t.text :raw
      t.integer :tweet_guid

      t.timestamps
    end
  end
end
