class PagesController < ApplicationController
    
  def home
    @title = "Positive Sentiment"
    @keywords = ""
  #  querystring = "
  #SELECT tweets.sentimentname, tags.description, COUNT(*) AS tag_count
  #FROM tweets
  #INNER JOIN tags ON tweets.id = tags.tweet_id
  #GROUP BY tags.description
  #HAVING tag_count > 2
  #ORDER BY tag_count DESC
  #LIMIT 0, 50
  #"
  #  @results = Tag.find_by_sql(querystring)
    
  end  

  def dashboard
    @title = "Positive Sentiment | Dashboard"
    @keywords = ""
    @page_loaded = "The page was loaded at: #{Time.now}"
  
    querystring = "
    SELECT * FROM new_raw_tweets"
    @new_tweets = Tweet.find_by_sql(querystring)
    
    querystring = "
    SELECT * FROM parsed_raw_tweets"
    @parsed_tweets = Tweet.find_by_sql(querystring)
    
    querystring = "
    SELECT * FROM users"
    @users = Tweet.find_by_sql(querystring)
    
    querystring = "
    SELECT * FROM tweets"
    @tweets = Tweet.find_by_sql(querystring)
    
    querystring = "
    SELECT sentiment, COUNT(*) AS sentiment_count
    FROM tweets
    GROUP BY sentiment"
    @tweet_sentiment_count = Tweet.find_by_sql(querystring)
    
    querystring = "
    SELECT parse_status, COUNT(*) AS parse_status_count
    FROM parsed_raw_tweets
    GROUP BY parse_status"
    @parse_status_count = Tweet.find_by_sql(querystring)
  
    querystring = "
    SELECT DATE(tweet_created_at) AS tweet_by_day, HOUR(tweet_created_at) AS tweet_by_hour, COUNT(*) AS tweet_daily_count
    FROM tweets
    GROUP BY tweet_by_day, tweet_by_hour"
    @tweet_daily_count = Tweet.find_by_sql(querystring)
  
  end
  
  
  
end
