class ChangeEventTypeName < ActiveRecord::Migration
  def change
  	rename_column :events, :number, :category
  	change_column_default :users, :curse, nil
  	remove_column :users, :user_name, :string
  end
end
