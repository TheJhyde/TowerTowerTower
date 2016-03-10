class AddResolveAtToBuildOrders < ActiveRecord::Migration
  def change
  	add_column :build_orders, :resolve_at, :datetime, :default => DateTime.now
  end
end
