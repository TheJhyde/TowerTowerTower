module BrickShipmentsHelper
	def select_shipments
		#Add a check to see if there's already some clay shipments in there
		@clays = ClayShipment.random(Rails.configuration.x.clay_shipments)
		@clays.each_with_index do |clay, i|
			session["clay#{i}"] = clay.id
		end
	end

end
