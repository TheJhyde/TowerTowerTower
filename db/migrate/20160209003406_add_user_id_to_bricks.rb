class AddUserIdToBricks < ActiveRecord::Migration
  def change
  	add_column :bricks, :user_id, :integer
  end
end
