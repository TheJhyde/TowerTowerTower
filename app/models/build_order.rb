include ActionView::Helpers::TextHelper

class BuildOrder < ActiveRecord::Base
	belongs_to :user
	serialize :colors, Array
	serialize :x, Array
	serialize :y, Array

	def self.resolve_orders
		BuildOrder.where(used: nil).order(:created_at).each do |order|
			placed_bricks = 0;
			destroyed_bricks = 0;
			order.colors.each_with_index do |color, i|
				if Brick.where(x: order.x[i], y: order.y[i]).length > 0
					#Then there's already a brick there - destroy it.
					#There should be more than one brick there, but just in case we destroy all.

					Brick.where(x: order.x[i], y: order.y[i]).each do |brick|
						unless brick.user.nil?
							if order.user.nil?
								brick.user.news_items << NewsItem.create(msg_type: "update", 
									message: "A brick you placed was destroyed by a brick placed by a mysterious stranger.")
							else
								brick.user.news_items << NewsItem.create(msg_type: "update", 
									message: "A brick you placed was destroyed by a brick placed by #{order.user.name}")
							end
						end
						brick.destroy
					end
					destroyed_bricks += 1
				else
					#Then there isn't a brick there. Add it to the tower.
					placed_bricks += 1
					Brick.create(x: order.x[i], y: order.y[i], color: color, user: order.user)
				end
			end
			msg = ""
			if placed_bricks > 0
				msg += "You successfully placed #{pluralize(placed_bricks, 'brick')} on the tower."
			end
			if destroyed_bricks > 0
				msg += "Your bricks destroyed #{pluralize(destroyed_bricks, 'brick')} in a collision."
			end

			unless order.user.nil?
				order.user.news_items << NewsItem.create(msg_type: "update", message: msg)
			end

			order.update(used: DateTime.now)
		end
	end
end
