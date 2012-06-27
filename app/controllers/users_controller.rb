class UsersController < ApplicationController
  
  # GET /users
  # GET /users.json
  def index
    @title = "Positive Sentiment | All Users"
    @keywords = ""
    
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end
  
end
