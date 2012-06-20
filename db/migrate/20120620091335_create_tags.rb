class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :tweet_id
      t.column :tweet_guid, :bigint # manually changed from int to bigint
      t.string :tag_name

      t.timestamps
    end
  end
end
