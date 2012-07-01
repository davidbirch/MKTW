class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet_text
      t.datetime :tweet_created_at
      t.column :tweet_guid, :bigint # manually changed from int to bigint
      t.string :tweet_source
      t.integer :user_id
       t.column :user_guid, :bigint # manually changed from int to bigint
      t.integer :company_keyword_id
      t.string :company_keyword
      t.string :sentiment

      t.timestamps
    end
  end
end
