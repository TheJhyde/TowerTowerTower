include ActionView::Helpers::TextHelper

class BuildOrder < ActiveRecord::Base
	belongs_to :user
	belongs_to :stranger
	has_many :events
	serialize :x, Array
	serialize :y, Array

	def self.resolve_orders
		orders = BuildOrder.where(used: nil).where(["resolve_at < ?", (DateTime.now + 1.minute)])
		orders.each do |order|
			order.place_bricks
		end
		Brick.check_strength
		Brick.gravity
		#NewsItem.write_updates(news);
	end

	def place_bricks
		x.each_with_index do |x, i|
			if Brick.where(x: x, y: self.y[i]).length > 0
				#Then there's already a brick there
				Brick.where(x: x, y: self.y[i]).each do |brick|
					#If they are the same color, make them stronger
					if brick.color == self.colors
						brick.update(strength: brick.strength + 1)
						Event.create(category: "strengthened", original_player: brick.user, placing_player: self.user, brick: brick, build_order: self)
					else
						#If they are different colors, make them weaker
						brick.update(strength: brick.strength - 1)
						#If strength falls below zero, destroy the brick
						if brick.strength < 0
							Event.create(category: "demolished", original_player: brick.user, placing_player: self.user, brick: brick, build_order: self)
							brick.destroy
						else
							Event.create(category: "weakened", original_player: brick.user, placing_player: self.user, brick: brick, build_order: self)
						end
					end
				end
			else
				#Then there isn't a brick there. Add one to the tower.
				brick = Brick.create(x: x, y: self.y[i], color: self.colors, user: self.user)
				Event.create(category: "placed", placing_player: self.user, build_order: self, brick: brick)
			end
		end
		update_attribute(:used, DateTime.now)
	end

end
