# ************************************************************************
# ** contains all shared code for the 'collect_tweets' group of scripts **
# ** created DB 28/06                                                   **
# ************************************************************************

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
    log.debug("Run database query: #{querystring}")
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
    tweet_hash = JSON.parse(raw_tweet) # note +was+ getting an error on one record that is not valid JSON ...
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
    
    elsif false
      # put other filters here
      
      # is marketing?
      # is rubbish?
      # is unrelated?
          
    else
      # the record does not exist so create it
      # get the field values to insert
      tweet_text = db.escape(tweet_hash["text"])
      tweet_original_created_at = Time.parse(tweet_hash["created_at"])
      tweet_source = db.escape(tweet_hash["source"])
      user_guid = tweet_hash["user"]["id"]
      
      # get the sentiment value
      sentiment_result = GetSentimentValue(log,tweet_text)
      sentiment = sentiment_result["mood"]
        
      tweet_created_at = Time.now # note: this is the Rails created_at, not a Tweet attribute
      tweet_updated_at = tweet_created_at # note: this is the Rails updated_at, not a Tweet attribute
      
      # create the user first so that the proper association can be created
      
      # check if the user exists before inserting
      querystring = "
    SELECT id
    FROM users
    WHERE user_guid = '#{user_guid}'"
    
      # execute the database query
      #log.debug("Run database query: #{querystring}")
      user_check = db.query(querystring)
      
      if user_check.count > 1
        # multiple matching user records - error
        #log.debug("Error - multiple(#{user_check.count}) user records for user_guid #{user_guid}")
        # still create with id of zero so that the data is captured
        user_id = 0
      
      elsif user_check.count == 1
        # the record must already exist
        # just get the user id
        user_check.each do |user|
          user_id = user["id"]
        end
   
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
        
        #assign the user_id
        user_id = db.last_id
      end
    
      # now create the tweet object
      querystring = "
    INSERT INTO tweets (tweet_text, tweet_created_at, tweet_guid, tweet_source, user_guid, user_id, sentiment, created_at, updated_at)
    VALUES('#{tweet_text}', '#{tweet_original_created_at}', '#{tweet_guid}', '#{tweet_source}', '#{user_guid}', '#{user_id}', '#{sentiment}', '#{tweet_created_at}', '#{tweet_updated_at}')"
      
      # execute the database query to create the tweet
      log.debug("Run database query: #{querystring}")
      db.query(querystring)
      
      # create the keywords
      tweet_id = db.last_id
      
      tweet_text.split(" ").each do |kword|
      
        # Strip the leading and trailing non-alpha characters
        tag_description = db.escape(kword.gsub(/\A[\d_\W]+|[\d_\W]+\Z/, ''))
          
        # Check that this is a valid keyword to create
        # Rule 1 - ignore if the length of the string is less than 4 characters
        if tag_description.length < 4
          #Do nothing
          #log.debug("Skip keyword: #{kword} (too short)")
        # Rule 2 - ignore URIs
        elsif tag_description.start_with?('http://')
          #Do nothing
          #log.debug("Skip keyword: #{kword} (a URI)")
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
      
      # move the raw tweet over to the parsed table
      parse_status = "Success"
      ParseRawTweet(db,log,row,parse_status)
      
    end
     
    # no special return ... just true
    return true
    
  rescue Exception => e
    
    # on error just log the error message
    log.error(e.message)  
    log.error(e.backtrace.inspect)
    
    # move the raw tweet over to the parsed table
    parse_status = "Failure"
    ParseRawTweet(db,log,row,parse_status)
    
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
    log.debug("Run database query: #{querystring}")
    
    # execute the write for the tweet message
    results = db.query(querystring)
    
    if results.count > 0
      # the record must already exist
      # raise an error message and delete the record in new_raw_tweets
      log.debug("Duplicate entry found (count = #{results.count}) with guid = #{row["tweet_guid"]}")
      
      querystring = "
    DELETE FROM new_raw_tweets
    WHERE tweet_guid = '#{row["tweet_guid"]}'"
      
      # execute the  query
      log.debug("Run database query: #{querystring}")
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
      log.debug("Run database query: #{querystring}")
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

def GetSentimentValue(log,message)
  
  # --- tweetsentiments is now a paid service ---
  # Get the sentiments on each tweet using the tweetsentiment API
  # http://data.tweetsentiments.com:8080/api/search.json?topic=<topic to analyze>
  #sentiment_url = "http://data.tweetsentiments.com:8080/api/analyze.json?q="+messa
    
  # access the api key
  vh_yaml = YAML.load_file(File.expand_path("../../../config/viralheat.yml", __FILE__))
  vh_config = vh_yaml[RAILS_ENVIRONMENT]
  
  # Get the sentiments on each tweet using the viralheat API
  # https://www.viralheat.com/api/sentiment/review.json?text=i%20dont%20like%20this&api_key=<your api key>  
  sentiment_url = "https://www.viralheat.com/api/sentiment/review.json?text="+message+"&api_key="+vh_config["api_key"]

  log.debug("Execute sentiment query:
  #{sentiment_url}")
  
  #
  url_encoded = URI::encode(sentiment_url) 
  uri = URI.parse(url_encoded)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
  request = Net::HTTP::Get.new(uri.request_uri)

  response = http.request(request)
  sentiment_data = response.body
  sentiment_result = JSON.parse(sentiment_data)
   
  # every time this is called wait to avoid the rate limit
  # sleep 2 
  log.debug("Result:
  #{sentiment_result}")
    
  return sentiment_result
end
################################################################################

