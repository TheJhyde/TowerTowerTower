class AddCurseToUsers < ActiveRecord::Migration
  def change
    add_column :users, :curse, :string, default: "bees"
  end
end
