class ClayShipmentsController < ApplicationController
  before_action :logged_in_user
  before_action :has_actions, only: [:new]
  before_action :check_admin, only: [:index]
  include ClayShipmentsHelper

  def new
    @finished = session["finished_clay"]
    @glyphs = Glyph.all
  	#Make n mines and save their id's in the session
    create_mines
  	#Creates a new clay shipment, if necessary
    if session["clay_shipment"].nil? || !ClayShipment.exists?(session["clay_shipment"])
  	  @shipment = ClayShipment.create(user: current_user)
      session["clay_shipment"] = @shipment.id
    else
      @shipment = ClayShipment.find(session["clay_shipment"])
    end
  end

  def index
    @shipments = ClayShipment.all
    @glyphs = Glyph.all
  end

  def create
    @shipment = ClayShipment.find(session["clay_shipment"])
    @shipment.message = params[:shipment][:message]
    #This needs to check that the message isn't blank
    if @shipment.message.blank?
      flash[:danger] = "Clay Shipments must include a message."
      redirect_to :back
      #render js: "$('#alert').text('Clay shipments must include a message');"
    elsif @shipment.save
      flash[:success] = "Clay Shipment sent! Good job."
      clear_session
      current_user.actions -= 1
      current_user.save
      redirect_to root_url
    else
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

  def show
    @clay = ClayShipment.find(session[params["id"]]).hide_clay
    respond_to do |format|
      format.json { render json: @clay }
    end
  end

  def finish
    shipment = ClayShipment.find(session["clay_shipment"])
    if shipment.clay.count(-1) <= 4
      session["finished_clay"] = true
      @glyphs = Glyph.all
      @finished = true;
    else
      @finished = false;
    end

    respond_to do |format|
      format.js
    end
  end
end
