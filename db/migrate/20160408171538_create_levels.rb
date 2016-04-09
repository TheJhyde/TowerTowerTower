class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :background
      t.string :text
      t.integer :level
      t.integer :strength_requirement
      t.integer :update_rate
      t.timestamps null: false
    end

    add_reference :build_orders, :level, index: true
    add_reference :bricks, :level, index: true

    remove_column :build_orders, :level
    remove_column :bricks, :level
  end
end
