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
		@order.x = params["build_order"]["x"].split(" ").map{|x| x.to_i}
		@order.y = params["build_order"]["y"].split(" ").map{|x| x.to_i}
		@order.level = (@order.y[0] - 1) / Global.tower.level_height;

		if params["build_order"]["message"].empty? && @order.level >= 1
			flash[:danger] = "Bricks must have a message."
			redirect_to new_build_order_path and return
		end
		@order.message = params["build_order"]["message"]
		@order.colors = session[:color]
		@order.user = current_user

		interval = ((@order.level+1)/2).round * 5
		if interval > 0
			@order.resolve_at = Time.now.ceil_to(interval.minutes)
		else
			@order.resolve_at = DateTime.now
		end

		if @order.save
			#Right here check if there's a duplicate order from the recent past
			if(interval == 0)
				@order.place_bricks
				Brick.check_strength
				Brick.gravity
				resolve_time = "now"
			else
				resolve_time = "at #{@order.resolve_at.strftime("%l:%M %p")}"
			end
			current_user.update(actions: (current_user.actions - 1))
			flash[:success] = "Bricks placed. Your order will be resolved #{resolve_time}. You have #{current_user.actions} <a href ='/actions' target = '_blank'>actions</a> left for the day."

			session[:color] = nil
			session[:ar] = nil
			session[:level] = @order.level

			redirect_to new_build_order_path
		else
			flash[:danger] = "There was an error!"
			render 'new'
		end
	end

	# Shows all of the build orders
	def index
		@build_orders = BuildOrder.paginate(page: params[:page], per_page: 10)
		@glyphs = Glyph.all
	end


	def show
		if params[:id] == "0"
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
	      		format.json {render json: @orders }
	      		format.html
	    	end
    	end
	end

	#Pulls up a list of orders for display on the site
	def get_orders
		if params[:id].to_i == 0
			#Shows all the build orders that haven't been used yet
			@orders = BuildOrder.where(level: params[:level].to_i, used: nil)
		else
			#shows all the build orders that were used around the given time
			last_order = Time.at(date).to_datetime
			@orders = BuildOrder.where( used: last_order..(last_order + 5.minute) )
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
