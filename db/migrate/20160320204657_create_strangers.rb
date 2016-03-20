class CreateStrangers < ActiveRecord::Migration
  def change
    create_table :strangers do |t|
      t.integer :number
      t.integer :actions, :default => 2
      t.timestamps null: false

      add_column :bricks, :stranger_id, :integer
      add_column :build_orders, :stranger_id, :integer
    end
  end
end
