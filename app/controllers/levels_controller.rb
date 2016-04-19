class LevelsController < ApplicationController
  before_action :check_admin, only: [:index, :new, :create, :edit, :update]

  def index
    @levels = Level.all
  end

  def new
    @level = Level.new
  end

  def create
    @level = Level.create(level_params)
    if @level.save
      redirect_to level_path
    else
      render 'new'
    end

  end

  def edit
    @level = Level.find(params[:id])
  end

  def update
    @level = Level.find(params[:id])
    if @level.update_attributes(level_params)
      flash[:success] = 'Updated level'
      redirect_to levels_path
    else
      render 'edit'
    end
  end

  def show
    this_level = Level.where(level: params[:id]).first
    @level = {}
    @level['level'] = this_level
    one_down = Brick.where(y: params["id"].to_i * Global.tower.level_height)
    one_up = Brick.where(y: (params["id"].to_i + 1) * Global.tower.level_height + 1);
    @level['bricks'] = this_level.bricks + one_down + one_up
    @level['stars'] = this_level.stars.where(found: false);
    respond_to do |format|
      format.json {render json: @level }
    end
  end

  private
    def level_params
      params.require(:level).permit(:level, :strength_requirement, :update_rate, :background, :text)
    end
end