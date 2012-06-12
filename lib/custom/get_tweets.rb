# required libraries
require 'tweetstream'
require 'mysql2'
require 'json'
require 'net/http'
require 'logger'
require 'yaml'

# initialise the log
log = Logger.new(File.expand_path("../../../log/collect_tweets.log", __FILE__))

##########################################################################################
begin

  # constants 
  RAILS_ENVIRONMENT = "development" # used to open the database
  
  # temporary - set this as the companylist
  companylist = 'Qantas'
  
  
  # access the database
  db_yaml = YAML.load_file(File.expand_path("../../../config/database.yml", __FILE__))
  db_config = db_yaml[RAILS_ENVIRONMENT]
  
  # Initialise the database
  db = Mysql2::Client.new(
    :host => "localhost",
    :username => db_config["username"],
    :password => db_config["password"],
    :database => db_config["database"]
  )
  log.debug("Connected to the database - Server Info: #{db.server_info}")
  
  # access the tweet stream
  ts_yaml = YAML.load_file(File.expand_path("../../../config/tweetstream.yml", __FILE__))
  ts_config = ts_yaml[RAILS_ENVIRONMENT]
  
  # Debug purposes only
  #ts_config.each {|key, value|
  #  puts "#{key} = #{value}"
  #} 
  
  # Log in to the tweetstream
  log.debug("Initialising the Tweetstream")
  TweetStream.configure do |config|
    config.consumer_key = ts_config["consumer_key"]
    config.consumer_secret = ts_config["consumer_secret"]
    config.oauth_token = ts_config["oauth_token"]
    config.oauth_token_secret = ts_config["oauth_token_secret"]
    config.auth_method = ts_config["auth_method"]
  end
  
  # call the tweetstream client
  TweetStream::Client.new.track(companylist) do |status|
    log.debug("status = #{status}")
    puts "#{status}"
    
    #CreateTweetObjects(db,log,status,companylist)
  end
    
rescue Exception => e  
  # on error just log the error message
  log.error(e.message)  
  log.error(e.backtrace.inspect)
end

# Close the database
if db
  db.close 
  log.debug("Database closed")
end
##########################################################################################
