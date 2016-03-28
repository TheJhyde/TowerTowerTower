class Event < ActiveRecord::Base
	belongs_to :brick
	belongs_to :build_order
	belongs_to :original_player, :class_name => "User"
	belongs_to :placing_player, :class_name => "User"

	enum :type [:placed, :fell, :weakened, :destroyed, :strengthened, :worn]
end
