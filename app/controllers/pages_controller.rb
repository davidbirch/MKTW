class PagesController < ApplicationController
    
  def home
    @title = "Positive Sentiment"
    @keywords = ""
  
    
  end  

  def dashboard
    @title = "Positive Sentiment | Dashboard"
    @keywords = ""
    @page_loaded = "The page was loaded at: #{Time.now}"
    
    # new_raw_tweets count  
    querystring = "
    SELECT count(id) AS nrt_count from new_raw_tweets"
    @new_raw_tweet_count = Tweet.find_by_sql(querystring)
    
    # parsed_raw_tweets count
    querystring = "
    SELECT count(id) AS prt_count from parsed_raw_tweets"
    @parsed_raw_tweet_count = Tweet.find_by_sql(querystring)
    
    # parsed_raw_tweets by parse success/failure
    querystring = "
    SELECT parse_status, count(id) AS parse_status_count
    FROM parsed_raw_tweets
    GROUP BY parse_status"
    @parse_status_count = Tweet.find_by_sql(querystring)
    
    # companies
    querystring = "
    SELECT count(id) AS company_count from companies"
    @company_count = Tweet.find_by_sql(querystring)
    
    # company_keywords
    querystring = "
    SELECT count(id) AS company_keyword_count from company_keywords"
    @company_keyword_count = Tweet.find_by_sql(querystring)
    
    # users
    querystring = "
    SELECT count(id) AS user_count from users"
    @user_count = Tweet.find_by_sql(querystring)
    
    # tags
    querystring = "
    SELECT count(id) AS tag_count from tags"
    @tag_count = Tweet.find_by_sql(querystring)
    
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
    
    # tweets by sentiment Positive/Neutral/Negative/NA
    querystring = "
    SELECT sentiment, count(id) AS sentiment_count
    FROM tweets
    GROUP BY sentiment"
    @tweet_sentiment_count = Tweet.find_by_sql(querystring)
    
    # tweets by day and hour
    querystring = "
    SELECT DATE(tweet_created_at) AS tweet_by_day, HOUR(tweet_created_at) AS tweet_by_hour, count(id) AS tweet_daily_count
    FROM tweets
    GROUP BY tweet_by_day, tweet_by_hour"
    @tweet_daily_count = Tweet.find_by_sql(querystring)
      
  end
    
end
