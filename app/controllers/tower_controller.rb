class TowerController < ApplicationController
	def index
		bottom = params["level"].to_i * (Rails.configuration.x.level_height - 2) 
		top = bottom + Rails.configuration.x.level_height
		if params["time"].nil?
			@tower = Brick.where(y: (bottom..top))
		else
			last_order = Time.at(params["time"].to_i).to_datetime
			#Five minutes is just a chunk of time to ensure I don't catch any of the bricks
			#Added in this update by accident
			@tower = Brick.where(["created_at < ?", (last_order - 5.minutes)]).where(y: (bottom..top))
		end
		respond_to do |format|
      		format.json {render json: @tower }
      		format.html
    	end
	end
end
