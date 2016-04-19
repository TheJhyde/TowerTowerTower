class BuildOrdersController < ApplicationController
  before_action :has_actions, only: [:new, :create]
  before_action :check_admin, only: [:index]

  def new

  end

  def finished
    @glyphs = Glyph.all
    @order = BuildOrder.new
    respond_to do |format|
      format.js
    end
  end

  def create
    if session[:ar].nil?
      redirect_to new_build_order_path
    end

    @order = BuildOrder.new
    @order.x = params["build_order"]["x"].split(" ").map { |x| x.to_i }
    @order.y = params["build_order"]["y"].split(" ").map { |x| x.to_i }
    @order.level = Level.find_by_y(@order.y[0])

    if params["build_order"]["message"].empty? && @order.level.level >= 1
      flash[:danger] = "Bricks must have a message."
      redirect_to new_build_order_path and return
    end
    @order.message = params["build_order"]["message"]
    @order.colors = session[:color]
    @order.user = current_user

    interval = @order.level.update_rate
    if interval > 0
      @order.resolve_at = Time.now.ceil_to(interval.minutes)
    else
      @order.resolve_at = DateTime.now
    end

    last_order = current_user.build_orders.order(:created_at).last
    if !last_order.nil? && last_order.created_at > (Time.now - 5.seconds)
      @order.delete
      flash[:danger] = 'You may only submit one order every five seconds.'
      redirect_to new_build_order_path and return
    end

    if @order.save
      current_user.update(actions: (current_user.actions - 1))
      if interval == 0
        @order.place_bricks
        Brick.check_strength
        Brick.gravity
        msg = Event.order_events(current_user)
      else
        resolve_time = "#{@order.resolve_at.strftime("%l:%M %p")}"
        msg = "Bricks placed. Your order will be resolved at #{resolve_time}."
      end

      flash[:success] = msg
      flash[:info] = "You have reached <a href = '/achievement_levels' class = 'achievement_level'>Achievement Level</a> #{current_user.bricks.order(:y).last.level.level} - #{current_user.bricks.count + current_user.build_orders.count}. Congratulations."
      flash[:warning] = "The tower has reached <span class = 'achievement_level'>Achievement Level</span> #{Brick.count} - #{Brick.all.order(:y).last.level.level}. My condolences."
      flash[:alert] = "You have #{current_user.actions} <a href ='/actions' target = '_blank'>actions</a> left for the day."
      session[:color] = nil
      session[:ar] = nil
      session[:level] = @order.level.level
	  session[:offset] = @order.x[0]

      redirect_to new_build_order_path
    else
      flash[:danger] = 'There was an error!'
      render 'new'
    end
  end

  # Shows all of the build orders
  def index
    @build_orders = BuildOrder.paginate(page: params[:page], per_page: 10)
    @glyphs = Glyph.all
  end


  def show
    if params[:id] == '0'
      @last_order = BuildOrder.where.not(used: nil).order(:used).last.used
      first_last_order = BuildOrder.where(["used >= ?", (@last_order - 5.minute)]).order(:used).first.used
      redirect_to "/build_orders/#{first_last_order.to_i}"
    else
      @last_order = Time.at(params[:id].to_i).to_datetime
      @orders = BuildOrder.where(used: (@last_order..(@last_order + 5.minute)))
      @glyphs = Glyph.all
      #What happens if this gets too low?
      prev_order = BuildOrder.where(["used < ?", @last_order]).order(:used).last.used;
      @prev = BuildOrder.where(["used > ?", (prev_order - 5.minute)]).order(:used).first;
      @next = BuildOrder.where(["used > ?", (@last_order + 5.minutes)]).order(:used).first
      respond_to do |format|
        format.json { render json: @orders }
        format.html
      end
    end
  end

  #Pulls up a list of orders for display on the site
  def get_orders
    current_level = Level.where(level: params[:level].to_i);
    if params[:id].to_i == 0
      #Shows all the build orders that haven't been used yet
      @orders = BuildOrder.where(level: current_level, used: nil)
    else
      #shows all the build orders that were used around the given time
      last_order = Time.at(date).to_datetime
      @orders = BuildOrder.where(used: last_order..(last_order + 5.minute), level: current_level)
    end

    @glyphs = Glyph.all
    respond_to do |format|
      format.js
    end
  end

  private
  def build_order_params
    params.require(:build_order).permit(:message, :colors, :x, :y)
  end
end
