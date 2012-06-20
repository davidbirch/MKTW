class CreateParsedRawTweets < ActiveRecord::Migration
  def change
    create_table :parsed_raw_tweets do |t|
      t.text :raw
      t.column :tweet_guid, :bigint # manually changed from int to bigint
      t.string :parse_status

      t.timestamps
    end
  end
end
