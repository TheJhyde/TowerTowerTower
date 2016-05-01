class AddMaxLevelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :max_level, :integer, :default => -1
  end
end
