class BuildOrdersController < ApplicationController
	before_action :has_actions, only: [:new, :create]
	before_action :check_admin, only: [:index]

	def new
		@glyphs = Glyph.all
		@orders = BuildOrder.where(used: nil)
	end

	def finished
		@glyphs = Glyph.all
		@order = BuildOrder.new
		respond_to do |format|
			format.js
		end
	end

	def create
		if params["build_order"]["message"].empty?
			flash[:danger] = "Bricks must have a message."
			redirect_to new_build_order_path and return
		end

		@order = BuildOrder.new
		@order.message = params["build_order"]["message"]
		@order.x = params["build_order"]["x"].split(" ").map{|x| x.to_i}
		@order.y = params["build_order"]["y"].split(" ").map{|x| x.to_i}
		@order.colors = params["build_order"]["colors"].split(" ").map{|x| x.to_i}

		if logged_in?
			@order.user = current_user
		end

		if @order.save
			if logged_in?
				current_user.update(actions: current_user.actions - 1)
				flash[:success] = "Bricks placed. Your order will be resolved at #{(DateTime.now + 1.hour).strftime("%l %p")}. You have #{current_user.actions} actions left for the day."
			else
				flash[:success] = "Bricks placed. Your order will be resolved at #{(DateTime.now + 1.hour).strftime("%l %p")}. Sign up to see what happened to your bricks."
				session["acted"] = session["acted"] + 1;
				session["build_order"] = @order.id
			end
			redirect_to new_build_order_path
		else
			flash[:danger] = "There was an error!"
			render 'new'
		end
	end

	def index
		@build_orders = BuildOrder.paginate(page: params[:page], per_page: 10)
		@glyphs = Glyph.all
	end

	def show
		if params[:id] == "0"
			last_order = BuildOrder.where.not(used: nil).order(:used).last.used
			redirect_to "/build_orders/#{last_order.to_i}"
		else
			last_order = Time.at(params[:id].to_i + 1).to_datetime
			@orders = BuildOrder.where(used: ((last_order - 1.hour)..last_order))
			@glyphs = Glyph.all
			#What happens if this gets too low?
			@prev = BuildOrder.where(["used < ?", (last_order - 5.minutes)]).last.used.to_i;
			#This is always putting out the same value reagrdless of what last_order is
			#Not even the most recent one, which is weird
			next_order = BuildOrder.where(["used > ?", (last_order + 5.minutes)]).order(:used).first
			unless next_order.nil?
				@next = next_order.used.to_i
			else
				@next = 0;
			end
			respond_to do |format|
	      		format.json {render json: @orders }
	      		format.html
	    	end
    	end
	end

	private
		def build_order_params
			params.require(:build_order).permit(:message, :colors, :x, :y)
		end
end
