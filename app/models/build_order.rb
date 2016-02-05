class BuildOrder < ActiveRecord::Base
	belongs_to :user
	serialize :colors, Array
	serialize :x, Array
	serialize :y, Array

	def self.resolve_orders
		BuildOrder.where(used: nil).order(:created_at).each do |order|
			order.colors.each_with_index do |color, i|
				if Brick.where(x: order.x[i], y: order.y[i]).length > 0
					puts "Destroyed a brick at #{order.x[i]}, #{order.y[i]}"
					#Then there's already a brick there - destroy it.
					#There should be more than one brick there, but just in case we destroy all.
					Brick.destroy_all(x: order.x[i], y: order.y[i])
				else
					#Then there isn't a brick there. Add it to the tower.
					puts "Added a brick at #{order.x[i]}, #{order.y[i]}"
					Brick.create(x: order.x[i], y: order.y[i], color: color)
				end
			end
			order.update(used: DateTime.now)
		end
	end
end
