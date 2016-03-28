class Event < ActiveRecord::Base
	belongs_to :brick
	belongs_to :build_order
	belongs_to :original_player, :class_name => "User"
	belongs_to :placing_player, :class_name => "User"

	enum category: [:placed, :fell, :weakened, :demolished, :strengthened, :worn]
end
