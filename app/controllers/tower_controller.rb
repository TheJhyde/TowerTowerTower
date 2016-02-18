class TowerController < ApplicationController
	def index
		bottom = params["level"].to_i * (Rails.configuration.x.level_height - 10) 
		top = bottom + Rails.configuration.x.level_height
		@tower = Brick.where(y: (bottom..top))
		respond_to do |format|
      		format.json {render json: @tower }
      		format.html
    	end
	end
end
