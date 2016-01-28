class CreateBrickShipments < ActiveRecord::Migration
  def change
    create_table :brick_shipments do |t|
      t.string :strength
      t.string :color
      t.string :message
      t.datetime :used

      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
