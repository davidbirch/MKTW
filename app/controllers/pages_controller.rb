class PagesController < ApplicationController
    
  def home
    
    @tweets = []
    Twitter.search("Qantas", :rpp => 1500).map do |status|
      @tweets <<  "#{status.from_user}: #{status.text}"
    end
  end  

end
