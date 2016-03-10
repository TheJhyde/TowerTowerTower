include ActionView::Helpers::TextHelper

class BuildOrder < ActiveRecord::Base
	belongs_to :user
	serialize :colors, Array
	serialize :x, Array
	serialize :y, Array

	def self.resolve_orders(news = [], bricks)
		news = place_bricks(news, bricks);
		news = Brick.gravity(news);
		NewsItem.write_updates(news);
	end

	def self.place_bricks(news = [], bricks)
		bricks.each do |order|
			order.colors.each_with_index do |color, i|
				if Brick.where(x: order.x[i], y: order.y[i]).length > 0
					#Then there's already a brick there - destroy it.
					#There should be more than one brick there, but just in case we destroy all.
					Brick.where(x: order.x[i], y: order.y[i]).each do |brick|
						unless brick.user.nil?
							news = NewsItem.add_to(news, brick.user.id, "destroyed")
						end
						brick.destroy
					end
					unless order.user.nil?
						news = NewsItem.add_to(news, order.user.id, "destroyed")
					end
				else
					#Then there isn't a brick there. Add it to the tower.
					unless order.user.nil?
						news = NewsItem.add_to(news, order.user.id, "placed")
					end
					Brick.create(x: order.x[i], y: order.y[i], color: color, user: order.user)
				end
			end
			order.update(used: DateTime.now)
		end
		return news
	end
end
