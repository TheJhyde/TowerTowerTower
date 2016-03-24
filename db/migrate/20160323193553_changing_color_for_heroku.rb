class ChangingColorForHeroku < ActiveRecord::Migration
  def change
  	remove_column :build_orders, :colors
  	add_column :build_orders, :colors, :integer, :default => 0
  end
end