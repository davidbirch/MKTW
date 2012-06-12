class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|

      t.integer :tweet_id
      t.string :description
      t.string :guid
      
      t.timestamps
    end
  end
end
