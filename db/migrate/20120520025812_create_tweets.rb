class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      
      t.string :message
      t.string :username
      t.string :guid
      t.string :company
      t.string :sentimentname
      t.string :sentimentvalue
      
      t.timestamps
    end
  end
end
