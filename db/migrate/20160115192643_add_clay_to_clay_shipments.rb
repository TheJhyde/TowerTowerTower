class AddClayToClayShipments < ActiveRecord::Migration
  def change
    add_column :clay_shipments, :clay, :text
  end
end
