class ChangeColorToInteger < ActiveRecord::Migration
  def change
  	change_column :build_orders, :colors, :integer
  end
end
