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
  
  # create the company records
  company_name = 'Qantas'
  company_description = 'Qantas Airways Limited (Qantas) is an Australian airline company. The Company is engaged in the operation of international and domestic air transportation services, and the provision of time definite freight services. Qantas is also engaged in the sale of international and domestic holiday tours, and associated support activities, including flight training, catering, passenger and ground handling, and engineering and maintenance. It is organized into four segments: Qantas, Jetstar, Qantas Holidays and Qantas Flight Catering. Qantas acquired 18 % of Pacific Airlines Joint Stock Aviation Company via a controlled entity on July 31, 2007. On July 2, 2007, Qantas acquired, via a controlled entity, 67.27% of DPEX Transport Group Pte Ltd. On July 2, 2007, it also acquired Asia Express Holdings Pte Ltd. On March 20, 2007, it acquired a 75% interest in Tour East Australia Pty Limited. The investment in Air New Zealand Limited was sold in June 2007.'
  asx_code = 'QAN'
  company_created_at = Time.now # note: this is the Rails created_at, not a Tweet attribute
  company_updated_at = company_created_at # note: this is the Rails updated_at, not a Tweet attribute

  querystring = "
    INSERT INTO companies (company_name, company_description, asx_code, created_at, updated_at)
    VALUES('#{company_name}', '#{company_description}', '#{asx_code}', '#{company_created_at}', '#{company_updated_at}')"
      
  # execute the query
  log.debug("Run database query: #{querystring}")
  db.query(querystring)
 
  #assign the company_id
  company_id = db.last_id
  company_keyword = 'Qantas'
 
  querystring = "
    INSERT INTO company_keywords (company_name, company_keyword, company_id, created_at, updated_at)
    VALUES('#{company_name}', '#{company_keyword}', '#{company_id}', '#{company_created_at}', '#{company_updated_at}')"
      
  # execute the query
  log.debug("Run database query: #{querystring}")
  db.query(querystring)
 
 
 
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
