class Stranger < ActiveRecord::Base
	has_many :bricks
	has_many :build_orders

	#Adds an action to all strangers
	def self.add_actions
		Stranger.all.each do |stranger|
			stranger.actions += Global.player.stranger_actions
			if stranger.actions > Global.player.max_actions
				stranger.actions = Global.player.max_actions
			end
			stranger.save
		end
	end
end
