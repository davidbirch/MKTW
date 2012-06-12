class PagesController < ApplicationController
    
  def home
    querystring = "
  SELECT tweets.sentimentname, tags.description, COUNT(*) AS tag_count
  FROM tweets
  INNER JOIN tags ON tweets.id = tags.tweet_id
  GROUP BY tags.description
  HAVING tag_count > 2
  ORDER BY tag_count DESC
  LIMIT 0, 50
  "
    @results = Tag.find_by_sql(querystring)
    
  end  

end
