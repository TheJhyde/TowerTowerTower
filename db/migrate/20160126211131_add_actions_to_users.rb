class AddActionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :actions, :integer, default: 2
  end
end
