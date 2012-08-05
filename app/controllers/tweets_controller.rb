class TweetsController < ApplicationController
  
  # GET /tweets
  # GET /tweets.json
  def index
    @title = "Positive Sentiment | Tweets"
    @keywords = ""
    
    @tweets = Tweet.paginate(:per_page => 20, :page => params[:page])

    if params[:sentiment]
      @tweets = @tweets.where(:sentiment => params[:sentiment])
    end
    
    if params[:company_keyword]
      @tweets = @tweets.where(:company_keyword => params[:company_keyword])
    end
    
    if params[:tweet_source]
      @tweets = @tweets.where(:tweet_source => params[:tweet_source])
    end
   
    if params[:tweet_guid]
      @tweets = @tweets.where(:tweet_guid => params[:tweet_guid])
    end
    
    if params[:user_guid]
      @tweets = @tweets.where(:user_guid => params[:user_guid])
    end 
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tweets }
    end
  end
  
end
