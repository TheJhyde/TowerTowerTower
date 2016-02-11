class BuildOrdersController < ApplicationController
	before_action :has_actions, only: [:new]

	def new
		#@tower = Brick.all
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
		@order.user = current_user
		if @order.save
			flash[:success] = "You have placed your bricks!"
			current_user.update(actions: current_user.actions - 1)
			redirect_to '/'
		else
			flash[:danger] = "There was an error!"
			render 'new'
		end
	end

	private
		def build_order_params
			params.require(:build_order).permit(:message, :colors, :x, :y)
		end
end
