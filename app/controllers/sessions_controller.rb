class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])      
  		log_in user
  		params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  		redirect_back_or root_url
  	else
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
  	log_out if logged_in?
  	redirect_to root_url
  end

  def index
    @user = {}
    if logged_in?
      @user[:logged] = true
      @user[:id] = current_user.id
      @user[:max_level] = current_user.bricks.order(:y).last.level + 1
    else
      @user[:logged] = false
      @user[:id] = current_stranger.id
      if current_stranger.bricks.count > 0
        @user[:max_level] = current_stranger.bricks.order(:y).last.level + 1
      else
        @user[:max_level] = 1
      end
    end

    if session[:color].nil?
      session[:color] = rand(2)
    end
    @user[:color] = session[:color]

    if session[:ar].nil?
      arrangement = [[0, 0], [0, 0]]
      (Global.tower.shipment_size - 1).times do |i| 
        arrangement[i][0] = rand(3) - 1
        arrangement[i][1] = rand(3) - 1
      end
      arrangement.uniq!
      arrangement.delete([0, 0])
      session[:ar] = arrangement
    end
    @user[:ar] = session[:ar]

    @user[:arrangement]
    respond_to do |format|
          format.json {render json: @user }
      end
  end
end
