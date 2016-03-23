include ActionView::Helpers::TextHelper

class BuildOrder < ActiveRecord::Base
	belongs_to :user
	belongs_to :stranger
	serialize :x, Array
	serialize :y, Array

	def self.resolve_orders
		bricks = BuildOrder.where(used: nil).where(["resolve_at < ?", (DateTime.now + 2.minute)])
		news = []
		puts "Got the bricks, gonna place them all."
		news = place_bricks(news, bricks);
		puts "Checking if bricks fall"
		news = Brick.gravity(news);
		puts "Check if bricks are strong enough"
		Brick.check_strength();
		puts "We did it! Writing the updates"
		NewsItem.write_updates(news);
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
							#TODO: Tell the brick placer they strengthened a brick
						else
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
					level = (order.y[i] - 1)/10;
					puts "I'm going to try and create a brick now"
					Brick.create(x: x, y: order.y[i], color: order.colors, user: order.user, level: level)
					puts "I created a brick, safe and sound"
				end
			end
			order.update(used: DateTime.now)
		end
		return news
	end
end
