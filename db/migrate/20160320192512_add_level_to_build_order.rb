class AddLevelToBuildOrder < ActiveRecord::Migration
  def change
  	  	add_column :build_orders, :level, :integer, :default => 0
  end
end
