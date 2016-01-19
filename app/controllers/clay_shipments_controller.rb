class ClayShipmentsController < ApplicationController
  before_action :logged_in_user
  before_action :check_admin, only: [:index]
  include ClayShipmentsHelper

  def new
    @finished = session["finished_clay"]
    @glyphs = Glyph.all
  	#Make n mines and save their id's in the session
    create_mines
  	#Creates a new clay shipment, if necessary
    if(session["clay_shipment"].nil?)
  	  @shipment = ClayShipment.create(user: current_user)
      session["clay_shipment"] = @shipment.id
    else
      @shipment = ClayShipment.find(session["clay_shipment"])
    end
  end

  def index
    @shipments = ClayShipment.all
  end

  def create
    shipment = ClayShipment.find(session["clay_shipment"])
    shipment.message = params[:shipment][:message]
    #This needs to check that the message isn't blank
    if shipment.save
      clear_session
      redirect_to root_url
    else
      flash[:danger] = "Not work"
      render "new"
    end
  end

  def edit
    extract_clay

    respond_to do |format|
      format.js
    end
  end

  def rearrange
    shipment = ClayShipment.find(session["clay_shipment"])
    shipment.clay[params[:a].to_i], shipment.clay[params[:b].to_i] = shipment.clay[params[:b].to_i], shipment.clay[params[:a].to_i]
    shipment.save
    render :nothing => true
  end

  def finish
    session["finished_clay"] = true
    @glyphs = Glyph.all
    respond_to do |format|
      format.js
    end
  end
end
