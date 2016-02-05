class Brick < ActiveRecord::Base
	belongs_to :user

	def self.gravity
		Brick.where.not(y: 0).each do |brick|
			#If there are no brick underneath, that is
			if Brick.where(x: brick.x, y: brick.y - 1).length == 0
				puts "Brick at #{brick.x}, #{brick.y} is falling."
				#I blow that brick up! Boom!
				brick.destroy
			end
		end
	end
end
