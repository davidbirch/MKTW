class Tag < ActiveRecord::Base
  
  # associations
  belongs_to :tweet
  
end
