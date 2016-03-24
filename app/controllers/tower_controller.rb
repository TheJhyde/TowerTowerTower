class TowerController < ApplicationController
	def index
		# bottom = params["level"].to_i * (Global.tower.level_height - Global.tower.overlap) 
		# top = bottom + Global.tower.level_height
		if params["time"].nil?
			this_level = Brick.where(level: params["level"].to_i)
			one_down = Brick.where(y: params["level"].to_i * Global.tower.level_height)
			one_up = Brick.where(y: (params["level"].to_i + 1) * Global.tower.level_height + 1);
			@tower = this_level + one_up + one_down
		else
			#NONE OF THIS IS RELEVANT ANYMORE
			#DON"T USE IT UNTIL IT"S BEEN REVAMPED!!
			#last_order = Time.at(params["time"].to_i).to_datetime
			#Five minutes is just a chunk of time to ensure I don't catch any of the bricks
			#Added in this update by accident
			#@tower = Brick.where(["created_at < ?", (last_order - 5.minutes)]).where(y: (bottom..top))
		end
		respond_to do |format|
      		format.json {render json: @tower }
      		format.html
    	end
	end

	def show
		if params["time"].nil?
			this_level = Brick.where(level: params["id"].to_i)
			one_down = Brick.where(y: params["id"].to_i * Global.tower.level_height)
			one_up = Brick.where(y: (params["id"].to_i + 1) * Global.tower.level_height + 1);
			@tower = this_level + one_up + one_down
		else
			#NONE OF THIS IS RELEVANT ANYMORE
			#DON"T USE IT UNTIL IT"S BEEN REVAMPED!!
			#last_order = Time.at(params["time"].to_i).to_datetime
			#Five minutes is just a chunk of time to ensure I don't catch any of the bricks
			#Added in this update by accident
			#@tower = Brick.where(["created_at < ?", (last_order - 5.minutes)]).where(y: (bottom..top))
		end

		respond_to do |format|
      		format.json {render json: @tower }
    	end
	end
end