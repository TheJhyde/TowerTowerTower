class BrickShipmentsController < ApplicationController
  before_action :logged_in_user
  before_action :check_admin, only: [:index, :new]
  before_action :has_actions, only: [:new]
  include BrickShipmentsHelper

  def index
  	
  end

  def new
  	@glyphs = Glyph.all
  	select_shipments
  	if session["brick_shipment"].nil?
  		@shipment = BrickShipment.create(user: current_user)
  		session["brick_shipment"] = @shipment.id
  	else
  		@shipment = BrickShipment.find(session["brick_shipment"])
  	end
  end

  def create
  end
end