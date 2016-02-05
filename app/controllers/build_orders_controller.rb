class BuildOrdersController < ApplicationController
	def new
		@tower = Brick.all
		@glyphs = Glyph.all
		@orders = BuildOrder.all
	end

	def finished
		@glyphs = Glyph.all
		@order = BuildOrder.new
		respond_to do |format|
			format.js
		end
	end

	def create
		@order = BuildOrder.new(build_order_params)
		@order.user = current_user
		if @order.save
			flash[:success] = "You have placed your bricks!"
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
