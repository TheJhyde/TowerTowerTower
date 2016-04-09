class LevelsController < ApplicationController

  def index
    @level = Level.all
  end

  def show
    this_level = Level.where(level: params[:id]).first
    @level = {}
    @level['level'] = this_level
    one_down = Brick.where(y: params["id"].to_i * Global.tower.level_height)
    one_up = Brick.where(y: (params["id"].to_i + 1) * Global.tower.level_height + 1);
    @level['bricks'] = this_level.bricks + one_down + one_up
    respond_to do |format|
      format.json {render json: @level }
    end
  end
end