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
log.info("Starting temp_create_tags.rb")

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
  log.info("temp_create_tags.rb is connected to the database - Server Info: #{db.server_info}")
  
  querystring ="
  SELECT id, tweet_guid, tweet_text
  FROM tweets"
  log.debug("Run database query: #{querystring}")
  
  # execute the database query
  results = db.query(querystring)
    
  results.each do |row|

    tweet_id = row["id"]
    tweet_guid = row["tweet_guid"]
    tweet_text = row["tweet_text"]

    tweet_text.split(" ").each do |kword|
      
      # Strip the leading and trailing non-alpha characters
      tag_description = db.escape(kword.gsub(/\A[\d_\W]+|[\d_\W]+\Z/, ''))
        
      # Check that this is a valid keyword to create
      # Rule 1 - ignore if the length of the string is less than 4 characters
      if tag_description.length < 4
        # Do nothing
        # log.debug("Skip keyword: #{kword} (too short)")
      # Rule 2 - ignore URIs
      elsif tag_description.start_with?('http://')
        # Do nothing
        # log.debug("Skip keyword: #{kword} (a URI)")
      else
        
        tag_created_at = Time.now # note: this is the Rails created_at, not a Tweet attribute
        tag_updated_at = tag_created_at # note: this is the Rails updated_at, not a Tweet attribute
      
        
        # Construct the query string for the tag object
        querystring = "
  INSERT INTO tags (tweet_id, tweet_guid, tag_name, created_at, updated_at)
  VALUES('#{tweet_id}', '#{tweet_guid}', '#{tag_description}', '#{tag_created_at}', '#{tag_updated_at}')";
        log.debug("Run database query:"+querystring) 
      
        # Execute the write for the tweet message
        db.query(querystring)
      end  
    end
  end
  
rescue Exception => e  
  # on error just log the error message
  log.error(e.message)  
  log.error(e.backtrace.inspect)
end



