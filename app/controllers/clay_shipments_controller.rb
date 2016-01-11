class ClayShipmentsController < ApplicationController
  include ClayShipmentsHelper
  def new
  	#Make n mines and save their id's in the session
  	create_mines
  	@mines = TOTAL_MINES
  	#Creates a new clay shipment
  	@shipment = ClayShipment.new
  	#Assigns the shipment to the current user
  	@shipment.user = current_user
  end

  def index
  end

  def create
  end

  def edit
  end
end
