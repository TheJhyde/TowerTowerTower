class Brick < ActiveRecord::Base
	belongs_to :user

	def self.gravity
		Brick.where.not(y: 0).each do |brick|
			#If there are no brick underneath, that is
			if Brick.where(x: brick.x, y: brick.y - 1).length == 0
				unless brick.user.nil?
					brick.user.news_items << NewsItem.create(msg_type: "update", 
						message: "One of your bricks fell and was destroyed.")
				end
				brick.destroy
			end
		end
	end
end
