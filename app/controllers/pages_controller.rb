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
  
    querystring = "SELECT * FROM new_raw_tweets"
    @new_tweets = Tweet.find_by_sql(querystring)
    
    querystring = "SELECT * FROM parsed_raw_tweets"
    @parsed_tweets = Tweet.find_by_sql(querystring)
    
    querystring = "SELECT * FROM tweets"
    @tweets = Tweet.find_by_sql(querystring)
    
    querystring = "SELECT * FROM users"
    @users = Tweet.find_by_sql(querystring)
    
  end
  
  
end
