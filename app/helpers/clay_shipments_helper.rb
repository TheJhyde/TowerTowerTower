include ActionView::Helpers::TextHelper

module ClayShipmentsHelper
	MINE_ACTIONS = 4
	PACK_SIZE = 10

	def create_mines
		Settings.mining.total_mines.times do |i|
			if(session["mine#{i}"].nil?)
				session["mine#{i}"] = Mine.new_mine.id
			end	
		end
	end

	def extract_clay
		@mine = Mine.find(session[params[:id]])
	    @shipment = ClayShipment.find(session["clay_shipment"])
	    red_clay = 0;
	    brown_clay = 0;
	    black_clay = 0;

	    MINE_ACTIONS.times do
	    	if @shipment.clay.include?(-1)
	    		r = rand(3)
		    	case r
		    	when 0
		    		if @mine.red_clay > 0
		      			@mine.update(red_clay: @mine.red_clay - 1)
		      			@shipment.clay[@shipment.clay.index(-1)] = 0
		      			red_clay += 1
		    		end
		    	when 1
		    		if @mine.brown_clay > 0
		      			@mine.update(brown_clay: @mine.brown_clay - 1)
		      			@shipment.clay[@shipment.clay.index(-1)] = 1
		      			brown_clay += 1
		    		end
		    	when 2
		    		if @mine.black_clay > 0
		      			@mine.update(black_clay: @mine.black_clay - 1)
 		      			@shipment.clay[@shipment.clay.index(-1)] = 2
		      			black_clay += 1
		    		end
		    	else
		    		puts "extract_clay put out a case that shouldn't: #{r}"
		    	end
	    	else
	    	end
	    end
	    @shipment.save()
	    write_update(red_clay, brown_clay, black_clay)
	end

	def write_update(red, brown, black)
		@update = ""
		if (red + brown + black) == 0
			if @shipment.clay.include?(-1)
				@update += "That mine is tapped out."
			end
		else
			@update = "You found "
			clays = []

			if red > 0
				clays << pluralize(red, 'red clay')
			end

			if brown > 0
				clays << pluralize(brown, 'brown clay')
			end

			if black > 0
				clays << pluralize(black, 'black clay')
			end

			@update += clays.to_sentence + "."
		end

		if !@shipment.clay.include?(-1)
			@update += " Your pack is full."
		end
	end

	def clear_session
		session["clay_shipment"] = nil
		Settings.mining.total_mines.times do |i|
			Mine.find(session["mine#{i}"]).delete
			session["mine#{i}"] = nil
		end
		session["finished_clay"] = false
	end
end
