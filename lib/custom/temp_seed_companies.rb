# ************************************************************************
# ** temporary script to create the companies records                   **
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
log.info("Starting temp_seed_companies.rb")

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
  log.info("temp_seed_companies.rb is connected to the database - Server Info: #{db.server_info}")
  
  # select all tweets in parsed_raw_tweets for processing
  log.info("Starting monitor process")
  querystring ="
  SELECT raw, tweet_guid
  FROM parsed_raw_tweets"
  log.debug("Run database query: #{querystring}")
  
  # use temp here so that it can be called manually
  # in future investigate running a continuous while loop ....
  temp = true
  while temp
    
    # execute the database query
    results = db.query(querystring)
    #log.debug("Number of rows in new_raw_tweets: #{results.count}")
    
    results.each do |row|
  
      # the record does not exist so create it
      raw_tweet = db.escape(row["raw"])
      tweet_guid = row["tweet_guid"]
      tweet_created_at = Time.now # note: this is the Rails created_at, not a Tweet attribute
      tweet_updated_at = tweet_created_at # note: this is the Rails updated_at, not a Tweet attribute
          
      querystring = "
    INSERT INTO new_raw_tweets (raw, tweet_guid, created_at, updated_at)
    VALUES('#{raw_tweet}', '#{tweet_guid}', '#{tweet_created_at}', '#{tweet_updated_at}')"
      
      # execute the query
      # log.debug("Run database query: #{querystring}")
      db.query(querystring)
  
      querystring = "
    DELETE FROM parsed_raw_tweets
    WHERE tweet_guid = '#{tweet_guid}'"
      
      # execute the query
      log.debug("Run database query: #{querystring}")
      db.query(querystring)
      
    end
    
    #only run once for debugging
    temp = false
    
  end
  
  # this message should never get called
  log.debug("parse_tweets.rb exited the 'while true' loop")
  
rescue Exception => e  
  # on error just log the error message
  log.error(e.message)  
  log.error(e.backtrace.inspect)
end

# close the database
if db
  db.close 
  log.info("Database closed")
end
##########################################################################################
