class CompaniesController < ApplicationController
  
  # GET /companies
  # GET /companies.json
  def index
    @title = "Positive Sentiment | Companies"
    @keywords = ""
    
    @companies = Company.paginate(:per_page => 20, :page => params[:page])  
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @company }
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show    
    
    @company = Company.find(params[:id])
    
    @title = "Positive Sentiment | Company: "+params[:id]
    @keywords = ""
    
    # tweets by day
    querystring = "
    SELECT DATE(tweet_created_at) AS tweet_day,
           DATE_FORMAT(tweet_created_at,'%Y,%c,%e') AS tweet_datetime_formatted,
           COUNT(id) AS tweet_day_count,
           COUNT(id) - COUNT(NULLIF(sentiment,'Negative')) AS tweet_day_negative_count,
           COUNT(id) - COUNT(NULLIF(sentiment,'Positive')) AS tweet_day_positive_count
    FROM tweets
    GROUP BY tweet_day
    ORDER BY tweet_day ASC"
    @tweets_by_day = Tweet.find_by_sql(querystring)
    
    # today's tweets by hour
    querystring = "
    SELECT DATE(tweet_created_at) AS tweet_day,
           EXTRACT(HOUR FROM tweet_created_at) AS tweet_hour,
           DATE_FORMAT(tweet_created_at,'%Y,%c,%e,%H') AS tweet_datetime_formatted,
           COUNT(id) AS tweet_day_count,
           COUNT(id) - COUNT(NULLIF(sentiment,'Negative')) AS tweet_day_negative_count,
           COUNT(id) - COUNT(NULLIF(sentiment,'Positive')) AS tweet_day_positive_count
    FROM tweets
    WHERE DATE(tweet_created_at) = CURDATE()
    GROUP BY tweet_hour
    ORDER BY tweet_hour ASC"
    @tweets_by_hour_for_one_day = Tweet.find_by_sql(querystring)
    
    # this week's tweets by hour
    querystring = "
    SELECT DATE(tweet_created_at) AS tweet_day,
           EXTRACT(HOUR FROM tweet_created_at) AS tweet_hour,
           DATE_FORMAT(tweet_created_at,'%Y,%c,%e,%H') AS tweet_datetime_formatted,
           COUNT(id) AS tweet_day_count,
           COUNT(id) - COUNT(NULLIF(sentiment,'Negative')) AS tweet_day_negative_count,
           COUNT(id) - COUNT(NULLIF(sentiment,'Positive')) AS tweet_day_positive_count
    FROM tweets
    WHERE DATE(tweet_created_at) >= CURDATE() - INTERVAL DAYOFWEEK(CURDATE())+6 DAY
    GROUP BY tweet_day, tweet_hour
    ORDER BY tweet_day ASC, tweet_hour ASC"
    @tweets_by_hour_for_one_week = Tweet.find_by_sql(querystring)
    
    
    
    
            
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @company }
    end
  end
  
end
