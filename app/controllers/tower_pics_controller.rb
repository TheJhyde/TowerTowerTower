class TowerPicsController < ApplicationController
	def index
		@pic = TowerPic.order(:created_at).last
		redirect_to @pic
	end

	def show
		@pic = TowerPic.find(params["id"])
		@next = @pic.next
		@previous = @pic.previous
	end
end
