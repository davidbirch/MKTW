class CreateParsedRawTweets < ActiveRecord::Migration
  def change
    create_table :parsed_raw_tweets do |t|
      t.text :raw
      t.string :guid

      t.timestamps
    end
  end
end
