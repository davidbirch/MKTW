class Tweet < ActiveRecord::Base
  
  # associations
  has_many :tags, :dependent => :destroy
  
end
