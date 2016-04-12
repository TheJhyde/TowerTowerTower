class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])  
      if current_user.build_orders.count == 0
        current_user.delete
      end
      #If the mysterious stranger does have any build orders, they should probably be
      #Given to the current user and they should lose actions to correspond
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
    @user = {id: current_user.id}
    #The highest the user can go
    if current_user.bricks.count > 0
      @user[:max_level] = current_user.bricks.order(:y).last.level.level + 1
    else
      @user[:max_level] = -1
    end
    #The level the user should currently be at
    if session[:level].nil?
      @user[:level] = @user[:max_level] - 1
    else
      @user[:level] = session[:level]
	end

	if session[:offset].nil?
	  # @user[:offset] = Global.tower.bricks_layer/2
	  # I don't know which brick this puts you near. The farthest right one maybe?
	  @user[:offset] = Level.where(level: @user[:level]).first.bricks.first.x
	else
	  @user[:offset] = session[:offset]
	end

    #The color of the bricks
    if session[:color].nil?
      session[:color] = rand(2)
    end
    @user[:color] = session[:color]

    #How the bricks should be laid out
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

    respond_to do |format|
          format.json {render json: @user }
	end
	#Sets the level and the offset back to nil and therefore their default values
	session[:level] = nil
	session[:offset] = nil
  end
end
