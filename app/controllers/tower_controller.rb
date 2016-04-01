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

	def brick
		brick = Brick.find(params["id"].to_i)

		@json = {}
		@json[:name] = brick.user.name
		@json[:created_at] = brick.created_at
		@json[:message] = brick.events.where(category: Event.categories[:placed]).first.build_order.message

		respond_to do |format|
      		format.json {render json: @json }
    	end
	end
end