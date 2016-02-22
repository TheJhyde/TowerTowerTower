class BuildOrdersController < ApplicationController
	before_action :has_actions, only: [:new]
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
				flash[:success] = "You have placed your bricks! Your order will be resolved at #{(DateTime.now + 1.hour).strftime("%l %p")}. You have #{current_user.actions} actions left for the day."
				current_user.update(actions: current_user.actions - 1)
			else
				flash[:success] = "Bricks placed! Your order will be resolved at #{(DateTime.now + 1.hour).strftime("%l %p")}. Want to see what happened to your bricks? Sign up to find out!"
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

	private
		def build_order_params
			params.require(:build_order).permit(:message, :colors, :x, :y)
		end
end
