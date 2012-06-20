class CompanyKeyword < ActiveRecord::Base
  
  # associations
  has_many :tweets
  belongs_to :company
  
end
