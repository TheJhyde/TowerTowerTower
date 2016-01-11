module ClayShipmentsHelper
	TOTAL_MINES = 3

	def create_mines
		TOTAL_MINES.times do |i|
			session["mine#{i}"] = Mine.new_mine.id
		end
	end
end
