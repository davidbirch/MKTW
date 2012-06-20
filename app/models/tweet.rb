class Tweet < ActiveRecord::Base
  
  # associations
  belongs_to :user
  has_many :tags
  belongs_to :company_keyword
  
end
