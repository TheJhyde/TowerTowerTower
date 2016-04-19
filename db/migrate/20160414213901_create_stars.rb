class CreateStars < ActiveRecord::Migration
  def change
    create_table :stars do |t|
      t.integer :x
      t.integer :y
      t.references :level
      t.boolean :found, default: false

      t.timestamps null: false
    end
  end
end
