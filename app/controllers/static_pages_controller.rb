class StaticPagesController < ApplicationController
  before_action :check_admin, only: [:admin, :news_items]

  #The home page, with all the global stats
  def home
    if(logged_in?)
      @tower = Brick.all
      @news_items = current_user.news_items.order(created_at: :desc).paginate(page: params[:page], per_page: 20)
    end
  end

  def about
  end

  def admin
	@show_mode = session[:show]
  end

  #Page for the reporting problems
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

  def show_mode
	session[:show] = !session[:show]
	redirect_to :admin
  end

  def news_items
        @news_items = NewsItem.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def actions
  end

  def strength
  end

  def gravity
  end

  def level
  end

  private
  	def error_params
  		params.require(:news_item).permit(:message)
  	end
end
