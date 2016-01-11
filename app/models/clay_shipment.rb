class ClayShipment < ActiveRecord::Base
	has_many :clays
	belongs_to :user
end
