class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :tweet_id
      t.integer :tweet_guid
      t.string :tag_name

      t.timestamps
    end
  end
end
