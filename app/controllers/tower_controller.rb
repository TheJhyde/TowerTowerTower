class TowerController < ApplicationController
	def index
		@tower = Brick.all
		respond_to do |format|
      		format.html
      		format.json {render json: @tower }
    	end
	end

	def show
		#Probably for the hidden shows
		#Sssssshhh, tell no one
	end
end
