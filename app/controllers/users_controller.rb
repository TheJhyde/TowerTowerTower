class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :check_admin, only: [:index, :destroy]
  
  def new
  	@user = User.new
  end

  def show
  	@user = User.find_by id: params[:id]
  	if @user.nil?
  		@user = User.find_by user_name: params[:id]
  	end
  	#debugger
  end

  def create
    @user = current_user
  	@user.name = "#{params[:name][:name_1]} #{params[:name][:name_2]}"
  	@user.user_name = @user.name.downcase.delete " " #spooky
    @user.signed_up = true
  	if @user.save && @user.update_attributes(user_params)
      @user.actions = Global.player.starting_actions
      #@user.send_activation_email
      log_in @user
  		flash[:success] = "Welcome #{current_user.name}"
  		redirect_to '/'
  	else
      @user.update(signed_up: false, name: nil, user_name: nil)
      @names = params[:name]
      @gender = params[:user][:gender]
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(edit_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed. Fuck that guy."
    redirect_to users_url
  end

  private #-------------------------------------------------------------------------------

  	def user_params
  		params.require(:user).permit(:email, :gender, :curse, :password, :password_confirmation)
  	end

    def edit_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

  	# def set_name
  	# 	params.user.name = "#{params.name.name_1} #{params.name.name_2}" 
  	# end
end
