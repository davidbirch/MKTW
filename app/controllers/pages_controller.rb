class PagesController < ApplicationController
    
  def home
    @title = "Positive Sentiment"
    @keywords = ""
    @page_loaded = "The page was loaded at: #{Time.now}"
    
    # standard record counts
    @tweet_count = Tweet.count
    @user_count = User.count
    @company_count = Company.count
    @tag_count = Tag.count
    @parsed_raw_tweet_count = ParsedRawTweet.count
    @new_raw_tweet_count = NewRawTweet.count
    @company_keyword_count = CompanyKeyword.count
    @company_price_count = CompanyPrice.count
    
    # parsed_raw_tweets by parse success/failure
    querystring = "
    SELECT parse_status, count(id) AS parse_status_count
    FROM parsed_raw_tweets
    GROUP BY parse_status"
    @parse_status_count = Tweet.find_by_sql(querystring)
    
    # tweets by sentiment Positive/Neutral/Negative/NA
    querystring = "
    SELECT sentiment, count(id) AS sentiment_count
    FROM tweets
    GROUP BY sentiment"
    @tweet_sentiment_count = Tweet.find_by_sql(querystring)
    
    # tweets by day
    querystring = "
    SELECT DATE(tweet_created_at) AS tweet_by_day, count(id) AS tweet_daily_count
    FROM tweets
    GROUP BY tweet_by_day"
    @tweet_daily_count = Tweet.find_by_sql(querystring)
      
    
    
  end  

  def dashboard
    @title = "Positive Sentiment | Dashboard"
    @keywords = ""
    @page_loaded = "The page was loaded at: #{Time.now}"
    
    
   
    
    
    # top 50 tags
    querystring = "
    SELECT tweets.sentiment, tags.tag_name, count(*) AS tag_count
    FROM tweets
    INNER JOIN tags ON tweets.id = tags.tweet_id
    
    GROUP BY tweets.sentiment, tags.tag_name
    HAVING tag_count > 2
    ORDER BY tag_count DESC
    LIMIT 0, 50"
    @top_tags_count = Tweet.find_by_sql(querystring)
     
     # top 50 tags today
    querystring = "
    SELECT tweets.sentiment, tweets.tweet_created_at, tags.tag_name, count(*) AS tag_count
    FROM tweets
    INNER JOIN tags ON tweets.id = tags.tweet_id
    WHERE DATE(tweets.tweet_created_at) = DATE(NOW())
    GROUP BY tweets.sentiment, tags.tag_name
    HAVING tag_count > 2
    ORDER BY tag_count DESC
    LIMIT 0, 50"
    @top_tags_count_today = Tweet.find_by_sql(querystring)
        
    # tweets
    querystring = "
    SELECT count(id) AS tweet_count from tweets"
    @tweet_count = Tweet.find_by_sql(querystring)
    
    
    
  end
    
end
