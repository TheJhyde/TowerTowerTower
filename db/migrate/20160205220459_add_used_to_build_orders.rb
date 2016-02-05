class AddUsedToBuildOrders < ActiveRecord::Migration
  def change
    add_column :build_orders, :used, :datetime
  end
end
