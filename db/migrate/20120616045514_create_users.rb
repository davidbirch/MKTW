class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_guid
      t.string :screen_name
      t.integer :friends_count

      t.timestamps
    end
  end
end
