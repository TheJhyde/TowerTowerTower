class TowerController < ApplicationController
	def index
		bottom = params["level"].to_i * (Rails.configuration.x.level_height - 10) 
		top = bottom + Rails.configuration.x.level_height
		if params["hour"].nil?
			@tower = Brick.where(y: (bottom..top))
		else
			@tower = Brick.where(["created_at < ?", (params["hour"].to_i+1).hour.ago]).where(y: (bottom..top))
		end
		respond_to do |format|
      		format.json {render json: @tower }
      		format.html
    	end
	end
end
