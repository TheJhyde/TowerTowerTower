class Mine < ActiveRecord::Base

	#Generates a new mine with a random distribution of clays
	def self.new_mine()
		total_clay = rand(Rails.configuration.x.mine_max - Rails.configuration.x.mine_min) + Rails.configuration.x.mine_min
		values = [rand(Rails.configuration.x.clay_start)]
		values.push rand(total_clay - values[0])
		values.push total_clay - (values[0] + values[1])
		values.shuffle!
		Mine.create(red_clay: values[0], brown_clay: values[1], black_clay: values[2])
	end
end
