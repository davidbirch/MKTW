# ************************************************************************
# ** script to parse records as they are dropped into new_raw_tweets    **
# ** created DB 28/06                                                   **
# ************************************************************************

# required libraries
require 'rubygems'
require 'mysql2'
require 'json'
require 'logger'
require 'time'
require 'yaml'
require "net/http"
#require 'tweetstream'

# required shared code
require "#{File.dirname(__FILE__)}/shared_tweet_code.rb"

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
  log.info("parse_tweets.rb is connected to the database - Server Info: #{db.server_info}")
  
  # select all tweets in new_raw_tweets for processing
  log.info("Starting monitor process")
  querystring ="
  SELECT raw, tweet_guid
  FROM new_raw_tweets"
  log.debug("Run database query: #{querystring}")
  
  # use i here so that it can be called manually
  # in future investigate running a continuous while loop ....
  temp = true
  while temp
    
    # execute the database query
    results = db.query(querystring)
    #log.debug("Number of rows in new_raw_tweets: #{results.count}")
    
    # this will run every 10 minutes
    # loop for 100
    i = 0
    results.each do |row|
  
      # create the normalised records
      # first check to see if it already exists
      # then move it to the parsed table - status 'success'
      CreateNormalisedRecords(db,log,row)
      
      i+=1
      #print "#{i}
      #"
      break if i==100
    end
    
    # increment
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
