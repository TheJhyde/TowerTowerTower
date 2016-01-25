class StaticPagesController < ApplicationController
  before_action :check_admin, only: [:admin]

  def home
    @clays = ClayShipment.count
    @mines = 0
    @towers = 0
  end

  def about
  end

  def admin
  end

  def report
  	@error = NewsItem.new
  end

  def submit
  	@message = NewsItem.new(error_params)
  	@message.users << User.where(admin: true)
  	@message.msg_type = "error_report"
  	if @message.save
  		flash[:success] = "Thank you for your report"
  		redirect_to '/'
  	else
  		flash[:danger] = "There was an error with the error reporting. That's just fucked up."
  		render 'report'
  	end
  end

  private
  	def error_params
  		params.require(:news_item).permit(:message)
  	end
end
