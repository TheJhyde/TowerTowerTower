class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :number, default: 0, null: false
      t.references :brick
      t.references :build_order
      t.references :original_player
      t.references :placing_player

      t.timestamps null: false
    end
  end
end
