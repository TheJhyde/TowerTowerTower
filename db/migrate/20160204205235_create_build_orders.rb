class CreateBuildOrders < ActiveRecord::Migration
  def change
    create_table :build_orders do |t|
      t.string :message
      t.integer :colors
      t.integer :strengths
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
