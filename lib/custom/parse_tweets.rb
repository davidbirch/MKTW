# required libraries
require 'rubygems'
require 'tweetstream'
require 'mysql2'
require 'json'
require 'net/http'
require 'logger'
require 'yaml'

# required shared code
require "./#{File.dirname(__FILE__)}/shared_tweet_code.rb"

# initialise the log
log = Logger.new(File.expand_path(TWEET_LOG_FILE_PATH, __FILE__))
log.info("Starting parse_tweets.rb")

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
  log.debug("parse_tweets.rb is connected to the database - Server Info: #{db.server_info}")
  
  log.info("Starting monitor process")
  querystring ="
  SELECT raw, guid
  FROM new_raw_tweets"
  log.debug("Run database query: #{querystring}")
  
  temp = true
  while temp
    # execute the write for the tweet message
    results = db.query(querystring)
    log.debug("Number of rows in new_raw_tweets: #{results.count}")
    
    results.each do |row|
      
      # create the normalised records
      # first check to see if it already exists
      CreateNormalisedRecords(db,log,row)
      
      # move the raw tweet over to the parsed table
      # first check to see if
      # (1) it has been created and
      # (2) it doesnt already exist in the parsed table
      #ParseRawTweet(db,log,row)
      
    end
    temp = false
  end
  log.debug("parse_tweets.rb exited the 'while true' loop")
  
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
