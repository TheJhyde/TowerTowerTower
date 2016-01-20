class StaticPagesController < ApplicationController
  before_action :check_admin, only: [:admin]

  def home
  end

  def about
  end

  def admin
  end
end
