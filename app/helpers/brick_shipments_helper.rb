module BrickShipmentsHelper
	def select_shipments
		#Add a check to see if there's already some clay shipments in there
		# @clays = ClayShipment.random(Rails.configuration.x.clay_shipments)
		# @clays.each_with_index do |clay, i|
		# 	if session
		# 	session["clay#{i}"] = clay.id
		# end

		@clays = []
		Rails.configuration.x.clay_shipments.times do |i|
			if session["clay#{i}"].nil?
				clay = ClayShipment.random(1).first
				session["clay#{i}"] = clay.id
				clay.used = DateTime.now
				@clays << clay
			else
				@clays << ClayShipment.find(session["clay#{i}"])
			end
		end
	end

	def makeBrick(clay)
		redClay = clay.count("#{Rails.configuration.x.red}")
		brownClay = clay.count("#{Rails.configuration.x.brown}")
		blackClay = clay.count("#{Rails.configuration.x.black}")
		if redClay >= brownClay && redClay >= blackClay
			{color: Rails.configuration.x.red, strength: getStrength(redClay)}
		elsif brownClay >= blackClay
			{color: Rails.configuration.x.brown, strength: getStrength(brownClay)}
		else
			{color: Rails.configuration.x.black, strength: getStrength(blackClay)}
		end
	end

	def getStrength(clay)
		if clay >= 5
			3
		elsif clay >= 3
			2
		else
			1
		end
	end

end
