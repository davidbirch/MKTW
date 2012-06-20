class User < ActiveRecord::Base
  
  # associations
  has_many :tweets
  
end
