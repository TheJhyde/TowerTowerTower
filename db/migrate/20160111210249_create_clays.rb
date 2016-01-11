class CreateClays < ActiveRecord::Migration
  def change
    create_table :clays do |t|
      t.integer :clay
      t.belongs_to :clay_shipment, index: true

      t.timestamps null: false
    end
  end
end
