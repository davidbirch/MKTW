class Company < ActiveRecord::Base
  
  # associations
  has_many :company_keywords
  has_many :company_prices
  
end
