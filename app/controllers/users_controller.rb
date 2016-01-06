class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def show
  	@user = User.find_by user_name: params[:id]
  	#debugger
  end
end
