class ChangingColorForHeroku < ActiveRecord::Migration
  def change
  	remove_column :build_orders, :color
  	add_column :build_orders, :color, :integer, :default => 0
  end
end