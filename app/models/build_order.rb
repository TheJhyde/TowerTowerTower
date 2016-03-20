include ActionView::Helpers::TextHelper

class BuildOrder < ActiveRecord::Base
	belongs_to :user
	serialize :x, Array
	serialize :y, Array

	def self.resolve_orders(news = [], bricks)
		news = place_bricks(news, bricks);
		news = Brick.gravity(news);
		new = Brick.check_strength();
		NewsItem.write_updates(news);
	end

	def self.place_bricks(news = [], bricks)
		bricks.each do |order|
			order.x.each_with_index do |x, i|
				if Brick.where(x: x, y: order.y[i]).length > 0
					#Then there's already a brick there
					Brick.where(x: x, y: order.y[i]).each do |brick|
						#If they are the same color, make them stronger
						puts "Brick color #{brick.color} vs order color #{order.colors}"
						if brick.color == order.colors
							puts "They are equal"
							brick.update(strength: brick.strength + 1)
							#TODO: Tell the brick placer they strengthened a brick
						else
							puts "They are not equal"
							#If they are different colors, make them weaker
							brick.update(strength: brick.strength - 1)
							#If strength falls below zero, destroy the brick
							if brick.strength < 0
								unless brick.user.nil?
									#Tell the user their brick was destroyed
									news = NewsItem.add_to(news, brick.user.id, "destroyed")
								end
								brick.destroy
							end
							#TODO: Tell the brick placer they weakened or destroyed a brick
						end
					end
				else
					#Then there isn't a brick there. Add it to the tower.
					unless order.user.nil?
						news = NewsItem.add_to(news, order.user.id, "placed")
					end
					level = (order.y[i] - order.y[i] % (Global.tower.level_height - Global.tower.overlap)) / (Global.tower.level_height - Global.tower.overlap);
					Brick.create(x: x, y: order.y[i], color: order.colors, user: order.user, level: level)
				end
			end
			order.update(used: DateTime.now)
		end
		return news
	end
end
