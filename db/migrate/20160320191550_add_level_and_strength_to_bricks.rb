class AddLevelAndStrengthToBricks < ActiveRecord::Migration
  def change
  	  	add_column :bricks, :level, :integer, :default => 0
  	  	add_column :bricks, :strength, :integer, :default => 0
  end
end
