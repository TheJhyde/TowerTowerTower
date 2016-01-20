//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require p5
//= require p5.dom
//= require turbolinks
//= require clay_shipments
//= require_self

$(document).on("page:change", function(){
	$('.glyph').click(function(){
	  var $glyph = $(this)
	  $('#text_area').append($glyph.find("img").prop('outerHTML'));
	  $('#shipment_message').val(function(index, value){
	    return value + $glyph.find("p").attr("id") + " ";
	  });
	});
});