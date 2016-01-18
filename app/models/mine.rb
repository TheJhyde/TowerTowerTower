class Mine < ActiveRecord::Base

	MAX_MINE = 10
	MIN_MINE = 8

	#Generates a new mine with a random distribution of clays
	def self.new_mine()
		total_clay = rand(MAX_MINE - MIN_MINE) + MIN_MINE
		values = [rand(4)]
		values.push rand(total_clay - values[0])
		values.push total_clay - (values[0] + values[1])
		values.shuffle!
		Mine.create(red_clay: values[0], brown_clay: values[1], black_clay: values[2])
	end
end
