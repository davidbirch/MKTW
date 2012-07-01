# ************************************************************************
# ** temporary script to get all records and update the sentiment value **
# ** created DB 28/06                                                   **
# ************************************************************************

# required libraries
require 'rubygems'
require 'mysql2'
require 'json'
require 'logger'
require 'time'
require 'yaml'
require 'net/http'
#require 'tweetstream'

# required shared code
require "./#{File.dirname(__FILE__)}/shared_tweet_code.rb"

# initialise the log
log = Logger.new(File.expand_path(TWEET_LOG_FILE_PATH, __FILE__))
log.info("Starting temp_update_sentiment.rb")

begin
  
  # access the database
  db_yaml = YAML.load_file(File.expand_path("../../../config/database.yml", __FILE__))
  db_config = db_yaml[RAILS_ENVIRONMENT]
  
  # Initialise the database
  # Note that the information required to open the database is in the shared_tweet_code file
  db = Mysql2::Client.new(
    :host => "localhost",
    :username => db_config["username"],
    :password => db_config["password"],
    :database => db_config["database"]
  )
  
  # on a restart log how many records are existing in the new_raw_tweets table
  log.info("temp_update_sentiment.rb is connected to the database - Server Info: #{db.server_info}")
  
  # select all tweets in new_raw_tweets for processing
  log.info("Starting monitor process")
  querystring ="
  SELECT id, tweet_text,  sentiment
  FROM tweets"
  log.debug("Run database query: #{querystring}")
  
  # execute the database query
   results = db.query(querystring)
    log.debug("Number of rows in tweets: #{results.count}")
    
    results.each do |row|
   
      tweet_id = row["id"]
      tweet_text = row["tweet_text"]
      sentiment = row["sentiment"]
      
      if sentiment == ""   
        # calculate the sentiment value
        # get the sentiment value
        sentiment_result = GetSentimentValue(log,tweet_text)
        sentiment = sentiment_result["sentiment"]["name"]
        tweet_updated_at = Time.now
        
        # update the sentiment value
        querystring = "
    UPDATE tweets
    SET sentiment = '#{sentiment}', updated_at = '#{tweet_updated_at}'
    WHERE id = '#{tweet_id}'"
        
         # execute the database query to create the user
        log.debug("Run database query: #{querystring}")
        db.query(querystring)
      end
    end
      
rescue Exception => e  
  # on error just log the error message
  log.error(e.message)  
  log.error(e.backtrace.inspect)
end



