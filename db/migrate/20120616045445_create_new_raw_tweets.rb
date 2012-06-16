class CreateNewRawTweets < ActiveRecord::Migration
  def change
    create_table :new_raw_tweets do |t|
      t.text :raw
      t.string :tweet_guid

      t.timestamps
    end
  end
end
