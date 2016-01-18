class CreateGlyphs < ActiveRecord::Migration
  def change
    create_table :glyphs do |t|
      t.string :url
      t.string :meaning
      t.timestamps null: false
    end
  end
end
