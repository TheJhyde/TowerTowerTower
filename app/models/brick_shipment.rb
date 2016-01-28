class BrickShipment < ActiveRecord::Base
	belongs_to :user
	serialize :strength, Array
	serialize :color, Array
end
