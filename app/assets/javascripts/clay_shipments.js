$(document).on("page:change", function(){
	//Check if we're on the right page
	if($(".clay_shipments.new").length == 0){
		return
	}

	var holding = 0;

	//Lets you move things around in your pack
	$('.grid').click(function(){
		if(holding == 0){
			$(this).removeClass('grid').addClass('grid_selected');
			holding = $(this);
		}else{
			// Sends these changes to the server, so it can do the same
			changes = {"a": holding.attr("id").replace("grid", ""), "b": $(this).attr("id").replace("grid", "")};
			$.post('/clay_shipments/rearrange', changes);
			
			//put the original square back to a solid border			
			holding.removeClass('grid_selected').addClass('grid');
			//Get the color of the original square
			var swapClay = holding.attr('class');
			//set the original square as the new square
			holding.removeClass().addClass($(this).attr("class"));
			//Set the new square as the original square
			$(this).removeClass().addClass(swapClay);

			holding = 0;
		}
	});

	$('.glyph').click(function(){
	  $('#text_area').append($(this).find("img").prop('outerHTML'));
	  // console.log($(this).find("img").prop('outerHTML'));
	  //console.log($(this).children().attr("id"));
	  $('#shipment_message').val($('#shipment_message').val() + $(this).children().attr("id") + " ");
	});
});