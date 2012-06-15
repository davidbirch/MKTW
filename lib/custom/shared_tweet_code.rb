################################################################################
#
# This code block contains all the shared code for the collect_tweets application
#
# Version 0.1
# Date: 14/06/2012
################################################################################

# Some constants and global variables are stored here
RAILS_ENVIRONMENT = "development" # used to open the database
TWEET_LOG_FILE_PATH = "../../../log/collect_tweets.log"

  

################################################################################
# This function creates the Raw Tweet Object in the database/model
def CreateTweetObjects(db,log,status)
  
begin
 
  # extract the relevant information from the tweet message
  #raw_tweet = db.escape(status.text) # this string needs to be escaped
  raw_tweet = db.escape(status.to_json)
  tweet_guid = status.id
  tweet_created_at = Time.now # note: this is the Rails created_at, not a Tweet attribute
  tweet_updated_at = tweet_created_at # note: this is the Rails updated_at, not a Tweet attribute
    
  querystring = "
  INSERT INTO new_raw_tweets (raw, guid, created_at, updated_at)
  VALUES('#{raw_tweet}', '#{tweet_guid}', '#{tweet_created_at}', '#{tweet_updated_at}')"
  log.debug("Run database query: #{querystring}")
  
  # execute the write for the tweet message
  db.query(querystring)
  
  # monitor the status of the script and write to the log every 10 minutes
  #time = Time.now.min
  #if time % 10  == 0 && do_once
  #    log.info "Collection up and running"
  #    do_once = false
  #elsif time  % 10 != 0
  #    do_once = true
  #end
  
  # no special return ... just true
  return true
      
  rescue Exception => e  
    # on error just log the error message
    log.error(e.message)  
    log.error(e.backtrace.inspect)
  end
end
################################################################################

def CreateNormalisedRecords(db,log,row)
  
  begin
  
    # the records do not exist so create it
    raw_tweet = row["raw"]
    tweet_guid = row["guid"]
    
    log.debug("Raw Tweet : #{raw_tweet}")
    log.debug("Tweet GUID: #{tweet_guid}")
    
    
  # no special return ... just true
  return true
    
  rescue Exception => e  
    # on error just log the error message
    log.error(e.message)  
    log.error(e.backtrace.inspect)
  end
end
################################################################################

def ParseRawTweet(db,log,row)
  
  begin
  
  # check to see if the record already exists
  querystring = "
  SELECT guid
  FROM parsed_raw_tweets
  WHERE guid = '#{row["guid]"]}'"
  log.debug("Run database query: #{querystring}")
  
  # execute the write for the tweet message
  results = db.query(querystring)
  
  if results.count > 0
    # the record must already exist
    # raise an error message and delete the record in new_raw_tweets
    log.debug("Duplicate entry found (count = #{results.count}) with:
    guid = #{row["guid"]}
    raw  = #{row["raw"]}")
      
  else
    # the record does not exist so create it
    raw_tweet = row["raw"]
    tweet_guid = row["guid"]
    tweet_created_at = Time.now # note: this is the Rails created_at, not a Tweet attribute
    tweet_updated_at = tweet_created_at # note: this is the Rails updated_at, not a Tweet attribute
        
    querystring = "
  INSERT INTO parsed_raw_tweets (raw, guid, created_at, updated_at)
  VALUES('#{raw_tweet}', '#{tweet_guid}', '#{tweet_created_at}', '#{tweet_updated_at}')"
  
    # execute the query
    log.debug("Run database query: #{querystring}")
    db.query(querystring)

    querystring = "
  DELETE FROM new_raw_tweets
  WHERE guid = '#{row["guid]"]}'"
    
    # execute the  query
    log.debug("Run database query: #{querystring}")
    db.query(querystring)

  end
  
  # no special return ... just true
  return true
      
  rescue Exception => e  
    # on error just log the error message
    log.error(e.message)  
    log.error(e.backtrace.inspect)
  end
end
################################################################################

