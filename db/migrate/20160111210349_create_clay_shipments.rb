class CreateClayShipments < ActiveRecord::Migration
  def change
    create_table :clay_shipments do |t|
      t.string :message
      t.datetime :used
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
