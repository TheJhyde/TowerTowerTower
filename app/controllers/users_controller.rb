class UsersController < ApplicationController
  # before_action :set_name, only: [:create]
  

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
  	@user = User.new(user_params)
  	@user.name = "#{params[:name][:name_1]} #{params[:name][:name_2]}"
  	@user.user_name = @user.name.downcase.delete " " #spooky
  	if @user.save
      log_in @user
  		flash[:success] = "Welcome #{@user.name}"
  		#I would like this to redirect to the /username page, not /id
  		redirect_to @user
  	else
  		# if @user.errors.any?
  		# 	@user.errors.full_messages.each do |msg|
  		# 		puts "Here's an error: #{msg}"
  		# 	end
  		# end
  		# puts "The user we're passing back is: #{@user.inspect}"
  		@user.name = nil #This is a little hackey
  		render 'new'
  	end
  end

  private #-------------------------------------------------------------------------------

  	def user_params
  		params.require(:user).permit(:email, :gender, :password, :password_confirmation)
  	end

  	# def set_name
  	# 	params.user.name = "#{params.name.name_1} #{params.name.name_2}" 
  	# end
end
