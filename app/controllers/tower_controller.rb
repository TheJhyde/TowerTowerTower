class TowerController < ApplicationController
	def index
		bottom = params["level"].to_i * Rails.configuration.x.level_height
		top = (params["level"].to_i + 1) * Rails.configuration.x.level_height
		@tower = Brick.where(y: (bottom..top))
		respond_to do |format|
      		format.json {render json: @tower }
    	end
	end

	def show
		#Probably for the hidden shows
		#Sssssshhh, tell no one
	end
end
