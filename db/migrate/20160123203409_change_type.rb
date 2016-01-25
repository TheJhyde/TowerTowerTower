class ChangeType < ActiveRecord::Migration
  def change
  	rename_column :news_items, :type, :msg_type
  end
end
