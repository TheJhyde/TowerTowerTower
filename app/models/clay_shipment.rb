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
end
