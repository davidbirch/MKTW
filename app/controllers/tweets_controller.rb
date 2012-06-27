class TweetsController < ApplicationController
  
  # GET /tweets
  # GET /tweets.json
  def index
    @title = "Positive Sentiment | All Tweets"
    @keywords = ""
    
    @tweets = Tweet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tweets }
    end
  end
  
end
