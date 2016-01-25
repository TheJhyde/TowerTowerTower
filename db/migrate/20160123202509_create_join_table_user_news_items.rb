class CreateJoinTableUserNewsItems < ActiveRecord::Migration
  def change
    create_join_table :users, :news_items do |t|
      t.index [:user_id, :news_item_id]
      t.index [:news_item_id, :user_id]
    end
  end
end
