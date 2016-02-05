class ChangeBuildOrderColorsToString < ActiveRecord::Migration
  def change
  	change_column :build_orders, :colors, :string
  end
end
