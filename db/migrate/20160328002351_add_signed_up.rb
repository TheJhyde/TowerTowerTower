class AddSignedUp < ActiveRecord::Migration
  def change
  	  	add_column :users, :signed_up, :boolean, :default => true
  end
end
