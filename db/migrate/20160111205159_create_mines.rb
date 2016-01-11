class CreateMines < ActiveRecord::Migration
  def change
    create_table :mines do |t|
      t.integer :red_clay
      t.integer :brown_clay
      t.integer :black_clay

      t.timestamps null: false
    end
  end
end
