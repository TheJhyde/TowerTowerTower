class AddToBuildOrders < ActiveRecord::Migration
  def change
  	add_column :build_orders, :x, :string
  	add_column :build_orders, :y, :string
  	remove_column :build_orders, :strengths
  end
end
