class CreateBricks < ActiveRecord::Migration
  def change
    create_table :bricks do |t|
      t.integer :x
      t.integer :y
      t.integer :color

      t.timestamps null: false
    end
  end
end
