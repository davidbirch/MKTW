################################################################################
#
# This code block contains all the shared code for the collect_tweets application
#
# Version 0.1
# Date: 14/06/2012
################################################################################

# some constants and global variables are stored here
RAILS_ENVIRONMENT = "development" # used to open the database
TWEET_LOG_FILE_PATH = "../../../log/collect_tweets.log"

################################################################################
def CreateRawTweet(db,log,status)
# this function creates the Raw Tweet Object in the database/model

  begin
   
    # extract the relevant information from the tweet message
    raw_tweet = db.escape(status.to_json)
    tweet_guid = status.id
    tweet_created_at = Time.now # note: this is the Rails created_at, not a Tweet attribute
    tweet_updated_at = tweet_created_at # note: this is the Rails updated_at, not a Tweet attribute
    
    # insert the record into new_raw_tweets  
    querystring = "
    INSERT INTO new_raw_tweets (raw, tweet_guid, created_at, updated_at)
    VALUES('#{raw_tweet}', '#{tweet_guid}', '#{tweet_created_at}', '#{tweet_updated_at}')"
      
    # execute the database query
    #log.debug("Run database query: #{querystring}")
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
    
    return false
  end
end
################################################################################

def CreateNormalisedRecords(db,log,row)
  
  begin
  
    # extract the raw tweet and convert it
    raw_tweet = row["raw"]
    #log.debug("Raw  = #{raw_tweet}")
    tweet_hash = JSON.parse(raw_tweet) # note getting an error on one record that is not valid JSON ...
    #log.debug("Hash = #{tweet_hash}")
    
    # get the tweet id
    tweet_guid = tweet_hash["id"]
        
    # check to see if the record already exists by querying on tweet_guid
    querystring = "
    SELECT tweet_guid
    FROM tweets
    WHERE tweet_guid = '#{tweet_guid}'"
    
    # execute the database query
    log.debug("Run database query: #{querystring}")
    tweet_check = db.query(querystring)
    
    if tweet_check.count > 0
      # the record must already exist
      #log.debug("Duplicate entry found (count = #{tweet_check.count}) with:
      #tweet_guid = #{tweet_guid}
      #raw        = #{row["raw"]}")
      
      # move the raw tweet over to the parsed table
      parse_status = "Success"
      ParseRawTweet(db,log,row,parse_status)
      
    else
      # the record does not exist so create it
      # get the field values to insert
      tweet_text = db.escape(tweet_hash["text"])
      tweet_created_at = tweet_hash["created_at"]
      tweet_source = db.escape(tweet_hash["source"])
      user_guid = tweet_hash["user"]["id"]
        
      tweet_created_at = Time.now # note: this is the Rails created_at, not a Tweet attribute
      tweet_updated_at = tweet_created_at # note: this is the Rails updated_at, not a Tweet attribute
      
      querystring = "
    INSERT INTO tweets (tweet_text, tweet_created_at, tweet_guid, tweet_source, user_guid, created_at, updated_at)
    VALUES('#{tweet_text}', '#{tweet_created_at}', '#{tweet_guid}', '#{tweet_source}', '#{user_guid}', '#{tweet_created_at}', '#{tweet_updated_at}')"
      
      # execute the database query to create the tweet
      #log.debug("Run database query: #{querystring}")
      db.query(querystring)
    
      # check if the user exists before inserting
      querystring = "
    SELECT user_guid
    FROM users
    WHERE user_guid = '#{user_guid}'"
    
      # execute the database query
      #log.debug("Run database query: #{querystring}")
      user_check = db.query(querystring)
      
      if user_check.count > 0
        # the record must already exist
        # do nothing
        
      else
        # the record does not exist so create it
        # get the field values to insert
        user_hash = tweet_hash["user"]
        screen_name = user_hash["screen_name"]
        friends_count = user_hash["friends_count"]
        
        user_created_at = Time.now # note: this is the Rails created_at, not a User attribute
        user_updated_at = user_created_at # note: this is the Rails updated_at, not a User attribute
        
        querystring = "
    INSERT INTO users (user_guid, screen_name, friends_count, created_at, updated_at)
    VALUES('#{user_guid}', '#{screen_name}', '#{friends_count}',  '#{user_created_at}', '#{user_updated_at}')"
  
        # execute the database query to create the user
        log.debug("Run database query: #{querystring}")
        db.query(querystring)
        
      end
      
      # move the raw tweet over to the parsed table
      parse_status = "Success"
      ParseRawTweet(db,log,row,parse_status)
      
    end
     
    # no special return ... just true
    return true
    
  rescue Exception => e
    
    # move the raw tweet over to the parsed table
    parse_status = "Success"
    ParseRawTweet(db,log,row,parse_status)
    
    # on error just log the error message
    log.error(e.message)  
    log.error(e.backtrace.inspect)
    
    return false
  end
end
################################################################################

def ParseRawTweet(db,log,row,parse_status)
  
  begin
  
    # check to see if the record already exists
    querystring = "
    SELECT tweet_guid
    FROM parsed_raw_tweets
    WHERE tweet_guid = '#{row["tweet_guid"]}'"
    #log.debug("Run database query: #{querystring}")
    
    # execute the write for the tweet message
    results = db.query(querystring)
    
    if results.count > 0
      # the record must already exist
      # raise an error message and delete the record in new_raw_tweets
      #log.debug("Duplicate entry found (count = #{results.count}) with:
      #guid = #{row["tweet_guid"]}
      #raw  = #{row["raw"]}")
      
      querystring = "
    DELETE FROM new_raw_tweets
    WHERE tweet_guid = '#{row["tweet_guid"]}'"
      
      # execute the  query
      #log.debug("Run database query: #{querystring}")
      db.query(querystring)
        
    else
      # the record does not exist so create it
      raw_tweet = db.escape(row["raw"])
      tweet_guid = row["tweet_guid"]
      tweet_created_at = Time.now # note: this is the Rails created_at, not a Tweet attribute
      tweet_updated_at = tweet_created_at # note: this is the Rails updated_at, not a Tweet attribute
          
      querystring = "
    INSERT INTO parsed_raw_tweets (raw, tweet_guid, parse_status, created_at, updated_at)
    VALUES('#{raw_tweet}', '#{tweet_guid}', '#{parse_status}', '#{tweet_created_at}', '#{tweet_updated_at}')"
    
      # execute the query
      log.debug("Run database query: #{querystring}")
      db.query(querystring)
  
      querystring = "
    DELETE FROM new_raw_tweets
    WHERE tweet_guid = '#{row["tweet_guid"]}'"
      
      # execute the  query
      #log.debug("Run database query: #{querystring}")
      db.query(querystring)
  
    end
    
    # no special return ... just true
    return true
      
  rescue Exception => e  
    # on error just log the error message
    log.error(e.message)  
    log.error(e.backtrace.inspect)
    
    return false
  end
end
################################################################################

