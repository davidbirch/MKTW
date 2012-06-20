class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :user_guid
      t.string :screen_name
      t.integer :friends_count
      t.string :name
      t.string :profile_image_url

      t.timestamps
    end
  end
end
