include ActionView::Helpers::TextHelper

module ClayShipmentsHelper

	def create_mines
		Rails.configuration.x.total_mines.times do |i|
			if session["mine#{i}"].nil? || !Mine.exists?(session["mine#{i}"])
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

	    Rails.configuration.x.mine_actions.times do
	    	if @shipment.clay.include?(Rails.configuration.x.no_clay)
	    		r = rand(Rails.configuration.x.clay_types)
		    	case r
		    	when Rails.configuration.x.red
		    		if @mine.red_clay > 0
		      			@mine.update(red_clay: @mine.red_clay - 1)
		      			@shipment.clay[@shipment.clay.index(-1)] = Rails.configuration.x.red
		      			red_clay += 1
		    		end
		    	when Rails.configuration.x.brown
		    		if @mine.brown_clay > 0
		      			@mine.update(brown_clay: @mine.brown_clay - 1)
		      			@shipment.clay[@shipment.clay.index(-1)] = Rails.configuration.x.brown
		      			brown_clay += 1
		    		end
		    	when Rails.configuration.x.black
		    		if @mine.black_clay > 0
		      			@mine.update(black_clay: @mine.black_clay - 1)
 		      			@shipment.clay[@shipment.clay.index(-1)] = Rails.configuration.x.black
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
			if @shipment.clay.include?(Rails.configuration.x.no_clay)
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

		if !@shipment.clay.include?(Rails.configuration.x.no_clay)
			@update += " Your pack is full."
		end
	end

	def clear_session
		session["clay_shipment"] = nil
		Rails.configuration.x.total_mines.times do |i|
			Mine.find(session["mine#{i}"]).delete
			session["mine#{i}"] = nil
		end
		session["finished_clay"] = false
	end
end
