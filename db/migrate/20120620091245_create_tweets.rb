class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet_text
      t.string :tweet_created_at
      t.integer :tweet_guid
      t.string :tweet_source
      t.integer :user_id
      t.integer :user_guid
      t.integer :company_keyword_id
      t.string :company_keyword
      t.string :sentiment

      t.timestamps
    end
  end
end
