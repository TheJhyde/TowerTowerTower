//Constants
var PACK_WIDTH = 5;
var PACK_HEIGHT = 2;
var PACK_TOTAL = PACK_WIDTH * PACK_HEIGHT;

$(document).on("page:change", function(){
	//Check if we're on the right page
	if($(".clay_shipments.new").length == 0){
		return
	}

	for(var i = 0; i < PACK_HEIGHT; i++){
		for(var j = 0; j < PACK_WIDTH; j++){
			$('#pack').append("<div id = 'grid" + (i*PACK_WIDTH + j) + "' class = 'blank grid clay'></div>");
		}
		$('#pack').append("<br/>");
	}

	$('.mine').click(function(){
		console.log("You clicked mine " + $(this).attr('id'));
		//And here's where the ajax magic goes
	});

});