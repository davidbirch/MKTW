# ************************************************************************
# ** script to monitor TweetStream and drop tweets in new_raw_tweets    **
# ** created DB 28/06                                                   **
# ************************************************************************

# required libraries
require 'rubygems'
require 'mysql2'
require 'json'
require 'logger'
require 'yaml'
require 'net/http'
require 'tweetstream'

# required shared code
require "./#{File.dirname(__FILE__)}/shared_tweet_code.rb"

# initialise the log
log = Logger.new(File.expand_path(TWEET_LOG_FILE_PATH, __FILE__))
log.info("Starting get_tweets.rb")

begin
    
  # temporary - set this as the companylist
  companylist = 'Qantas'
  
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
  log.info("get_tweets.rb is connected to the database - Server Info: #{db.server_info}")
  
  # log the row count for 'new_raw_tweets'
  results = db.query("SELECT id FROM new_raw_tweets")
  log.info("Number of rows in new_raw_tweets: #{results.count}")
    
  # access the tweet stream
  ts_yaml = YAML.load_file(File.expand_path("../../../config/tweetstream.yml", __FILE__))
  ts_config = ts_yaml[RAILS_ENVIRONMENT]
  
  # Debug purposes only
  #ts_config.each {|key, value|
  #  puts "#{key} = #{value}"
  #} 
  
  # Log in to the tweetstream
  log.info("Initialising the Tweetstream")
  TweetStream.configure do |config|
    config.consumer_key = ts_config["consumer_key"]
    config.consumer_secret = ts_config["consumer_secret"]
    config.oauth_token = ts_config["oauth_token"]
    config.oauth_token_secret = ts_config["oauth_token_secret"]
    config.auth_method = ts_config["auth_method"]
  end
  
  # call the tweetstream client
  TweetStream::Client.new.track(companylist) do |status|
    # create the raw tweet object
    CreateRawTweet(db,log,status) 
  end
    
rescue Exception => e  
  # on error just log the error message
  log.error(e.message)  
  log.error(e.backtrace.inspect)
end

# Close the database
if db
  db.close 
  log.info("Database closed")
end
##########################################################################################
