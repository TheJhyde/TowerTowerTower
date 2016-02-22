class StaticPagesController < ApplicationController
  before_action :check_admin, only: [:admin, :news_items]

  #The home page, with all the global stats
  def home
    if(logged_in?)
      @towers = Brick.order(:y).last.y + 1
      @bricks = Brick.count
      @news_items = current_user.news_items.order(created_at: :desc).paginate(page: params[:page], per_page: 20)
    end
  end

  def about
  end

  def admin
  end

  #Page for the reporting problems page
  def report
  	@error = NewsItem.new
  end

  #Handles posts to from problem reports, makes them into an update for the admins
  def submit
  	@message = NewsItem.new(error_params)
    #No shenagins, you hear!
    @message.message = ActionView::Base.full_sanitizer.sanitize(@message.message)
    #Gives this message to all admins
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

  def news_items
        @news_items = NewsItem.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  private
  	def error_params
  		params.require(:news_item).permit(:message)
  	end
end
