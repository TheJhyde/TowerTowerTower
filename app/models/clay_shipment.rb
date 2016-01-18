class ClayShipment < ActiveRecord::Base
	belongs_to :user
	serialize :clay, Array
	#validates :message, presence: true
	after_initialize :init

	def init
		if clay[0].nil?
			10.times do
				self.clay << -1
			end
		end
	end
end
