include ActionView::Helpers::TextHelper

class BuildOrder < ActiveRecord::Base
	belongs_to :user
	belongs_to :stranger
	has_many :events
	serialize :x, Array
	serialize :y, Array

	def self.resolve_orders
		bricks = BuildOrder.where(used: nil).where(["resolve_at < ?", (DateTime.now + 2.minute)])
		news = []
		news = place_bricks(news, bricks);
		Brick.gravity(news);
		Brick.check_strength();
		#NewsItem.write_updates(news);
	end

	def self.place_bricks(news = [], bricks)
		bricks.each do |order|
			order.x.each_with_index do |x, i|
				if Brick.where(x: x, y: order.y[i]).length > 0
					#Then there's already a brick there
					Brick.where(x: x, y: order.y[i]).each do |brick|
						#If they are the same color, make them stronger
						if brick.color == order.colors
							brick.update(strength: brick.strength + 1)
							Event.create(category: "strengthened", original_player: brick.user, placing_player: order.user, brick: brick, build_order: order)
						else
							#If they are different colors, make them weaker
							brick.update(strength: brick.strength - 1)
							#If strength falls below zero, destroy the brick
							if brick.strength < 0
								Event.create(category: "demolished", original_player: brick.user, placing_player: order.user, brick: brick, build_order: order)
								# unless brick.user.nil?
								# 	news = NewsItem.add_to(news, brick.user.id, "destroyed")
								# end
								brick.destroy
							else
								Event.create(category: "weakened", original_player: brick.user, placing_player: order.user, brick: brick, build_order: order)
							end
							#TODO: Tell the brick placer they weakened or destroyed a brick
						end
					end
				else
					#Then there isn't a brick there. Add it to the tower.
					# unless order.user.nil?
					# 	news = NewsItem.add_to(news, order.user.id, "placed")
					# end
					level = (order.y[i] - 1)/10;
					brick = Brick.create(x: x, y: order.y[i], color: order.colors, user: order.user, level: level)
					Event.create(category: "placed", placing_player: order.user, build_order: order, brick: brick)
				end
			end
			order.update(used: DateTime.now)
		end
		return news
	end
end
