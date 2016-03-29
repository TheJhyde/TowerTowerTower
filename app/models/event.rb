class Event < ActiveRecord::Base
	belongs_to :brick
	belongs_to :build_order
	belongs_to :original_player, :class_name => "User"
	belongs_to :placing_player, :class_name => "User"

	enum category: [:placed, :fell, :weakened, :demolished, :strengthened, :worn]

	def self.write_updates()
		User.where(signed_up: true).each do |user|
			new_placed = user.placing_events.where(["created_at > ?", (DateTime.now - 20.minute)])
			new_bricks = user.brick_events.where(["created_at > ?", (DateTime.now - 20.minute)])
			#new_placed = user.placing_events
			#new_bricks = user.brick_events
			news = ""
			#------Simple, one person events----------
			#All of the bricks successfully placed
			if new_placed.where(category: categories[:placed]).count > 0
				news += "You placed #{new_placed.where(category: categories[:placed]).count} bricks on the tower.<br>"
			end
			#All of the bricks that fell
			if new_bricks.where(category: categories[:fell]).count > 0
				news += "#{new_bricks.where(category: categories[:fell]).count} of your bricks fell.<br>"
			end
			#All of the bricks destroyed by the elements
			if new_bricks.where(category: categories[:worn]).count > 0
				news += "#{new_bricks.where(category: categories[:worn]).count} of your bricks were destroyed for not being strong enough for their level.<br>"
			end
			#---------Bricks which you placed that did things to other's bricks--------
			#All the bricks worn down by your bricks
			if new_placed.where(category: categories[:weakened]).count > 0
				news += "Your bricks collided with bricks placed by "
				names = []
				new_placed.where(category: categories[:weakened]).each do |event|
					names << event.original_player.name
				end
				names.uniq!
				news += "#{names.to_sentence} weakening them.<br>"
			end
			#All the bricks destroyed by your bricks.
			if new_placed.where(category: categories[:demolished]).count > 0
				news += "Your bricks collided with bricks placed by "
				names = []
				new_placed.where(category: categories["demolish"]).each do |event|
					names << event.original_player.name
				end
				news += "#{names.to_sentence} destroying them.<br>"
			end
			#All the bricks strengthened by your bricks.
			if new_placed.where(category: categories["strengthened"]).count > 0
				news += "Your bricks collided with bricks placed by "
				names = []
				new_placed.where(category: categories["strengthened"]).each do |event|
					names << event.original_player.name
				end
				news += "#{names.to_sentence} strengthening them.<br>"
			end

			#-------Bricks other people placed which did things to your bricks
			#All the bricks worn down by your bricks
			if new_bricks.where(category: categories[:weakened]).count > 0
				news += "Bricks placed by  "
				names = []
				new_bricks.where(category: categories[:weakened]).each do |event|
					names << event.placing_player.name
				end
				news += "#{names.to_sentence} weakening your bricks.<br>"
			end
			#All the bricks destroyed by your bricks.
			if new_placed.where(category: categories[:demolished]).count > 0
				news += "Bricks placed by "
				names = []
				new_bricks.where(category: categories["demolish"]).each do |event|
					names << event.placing_player.name
				end
				news += "#{names.to_sentence} destroyed your bricks.<br>"
			end
			#All the bricks strengthened by your bricks.
			if new_placed.where(category: categories["strengthened"]).count > 0
				news += "Bricks placed by "
				names = []
				new_bricks.where(category: categories["strengthened"]).each do |event|
					names << event.placing_player.name
				end
				news += "#{names.to_sentence} strengthened your bricks.<br>"
			end

			unless news.blank?
				update = NewsItem.create(message: news, msg_type: "news")
				user.news_items << update
			end
		end
	end
end
