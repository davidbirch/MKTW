class ParsedRawTweetsController < ApplicationController
  
  # GET /parsed_raw_tweets
  # GET /parsed_raw_tweets.json
  def index
    @title = "Positive Sentiment | Parsed Raw Tweets"
    @keywords = ""
    
    @parsed_raw_tweets = ParsedRawTweet.paginate(:per_page => 20, :page => params[:page])
    
    if params[:parse_status]
      @parsed_raw_tweets = @parsed_raw_tweets.where(:parse_status => params[:parse_status])
    end
   
    if params[:tweet_guid]
      @parsed_raw_tweets = @parsed_raw_tweets.where(:tweet_guid => params[:tweet_guid])
    end 
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @parsed_raw_tweets }
    end
  end

  # GET /parsed_raw_tweets/1
  # GET /parsed_raw_tweets/1.json
  def show    
    
    @parsed_raw_tweet = ParsedRawTweet.find(params[:id])
    
    @title = "Positive Sentiment | Parsed Raw Tweet ID: "+params[:id]
    @keywords = ""
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @parsed_raw_tweet }
    end
  end
  
end
