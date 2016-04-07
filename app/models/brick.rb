class Brick < ActiveRecord::Base
	before_create :set_level

	belongs_to :user
	has_many :events

	def self.gravity(news = [])
		Brick.where.not(y: 0).order(:y).each do |brick|
			#If there are no brick underneath, that is
			if Brick.where(x: ((brick.x-1)..(brick.x+1)), y: brick.y - 1).length == 0
				Event.create(category: "fell", original_player: brick.user)
				brick.destroy
			end
		end
		return news
	end

	def self.check_strength(news = [])
		Brick.all.each do |brick|
			#Bricks which are too weak for their level are destroyed
			if brick.strength < ((brick.level+1)/3).round
				Event.create(category: "worn", original_player: brick.user)
				brick.destroy
				#news = NewsItem.add_to(news, brick.user.id, "weak")
			end
		end
	end

	private
		def set_level
			self.level = (self.y - 1)/10
		end
end
