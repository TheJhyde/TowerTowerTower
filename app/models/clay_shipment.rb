class ClayShipment < ActiveRecord::Base
	belongs_to :user
	serialize :clay, Array
	#validates :message, presence: true
	after_initialize :init

	def init
		if clay[0].nil?
			Rails.configuration.x.pack_total.times do
				self.clay << -1
			end
		end
	end

	def self.clear_out
		ClayShipment.where(message: nil).each do |shipment|
			shipment.delete
		end
	end

	#Picks N random shipments and returns them
	def self.random(number)
		ClayShipment.where(used: nil).where.not(message: nil).order("RANDOM()").limit(number)
	end

	def hide_clay
		@secret_clay = []
		clay.each do |i|
			if i == -1
				@secret_clay << -1
			else
				@secret_clay << 1
			end
		end
		return @secret_clay
	end
end
