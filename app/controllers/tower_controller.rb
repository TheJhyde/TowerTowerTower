class TowerController < ApplicationController
	def index
		@tower = Brick.all.as_json
		@tower.each do |brick|
			info = "This brick was placed by "
			if !brick["user_id"].nil?
				info += User.find(brick["user_id"]).name
			elsif !brick["stranger_id"].nil?
				info += Stranger.find(brick.stranger_id).name
			else
				info += "Nobody"
			end
			info += " on #{brick["created_at"].strftime("%_m/%-d, %l:%M %p")}."
			brick["info"] = info
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
		end

		respond_to do |format|
      		format.json {render json: @tower }
    	end
	end
end