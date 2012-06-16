class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet_text
      t.string :tweet_created_at
      t.string :tweet_guid
      t.string :tweet_source
      t.string :user_guid

      t.timestamps
    end
  end
end
