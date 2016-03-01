include ActionView::Helpers::TextHelper

class BuildOrder < ActiveRecord::Base
	belongs_to :user
	serialize :colors, Array
	serialize :x, Array
	serialize :y, Array

	def self.resolve_orders(news = [])
		BuildOrder.where(used: nil).order(:created_at).each do |order|
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

	def self.getOrders(level, date)
		if date == 0
			orders = BuildOrder.where(used: nil)
		else
			last_order = Time.at(date).to_datetime
			orders = BuildOrder.where( used: last_order..(last_order + 5.minute) )
		end

		bottom = level * (Rails.configuration.x.level_height - 2) 
		top = bottom + Rails.configuration.x.level_height

		orders.select{|order| order.y.any?{|y| y >= bottom && y <= top} }
	end
end
