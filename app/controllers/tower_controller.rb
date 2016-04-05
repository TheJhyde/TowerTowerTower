class TowerController < ApplicationController
	def index
		@tower = Brick.all.as_json
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

	def history
		@brick = Brick.find(params["id"].to_i)

		build_event = @brick.events.where(category: Event.categories[:placed]).first
		if build_event
			@order = build_event.build_order
		end
		@glyphs = Glyph.all

		respond_to do |format|
      		format.js
    	end
	end
end