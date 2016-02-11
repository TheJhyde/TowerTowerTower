class CreateTowerPics < ActiveRecord::Migration
  def change
    create_table :tower_pics do |t|
      t.string :file

      t.timestamps null: false
    end
  end
end
