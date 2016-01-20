require 'test_helper'

class ClayShipmentNewTestTest < ActionDispatch::IntegrationTest
  def setup
  	@user = users(:coolgoat)
  end

  test "valid attempt at making a clay shipment" do
  	log_in_as(@user)
  	get new_clay_shipment_path
  	assert_template 'clay_shipments/new'
  	#These lines aren't work :( I want to press the mine button, check if it's changed
  	#assert_select "#grid0.blank", 1
  	#get edit_clay_shipment_path('mine1')
  	#assert_select "#grid0.blank", 0

  	#Then do that a few more times, checking it for each mine

  	#Then press submit, check if the buttons have appeared

  	#I may need to bring on something else in order to properly test these ajax elements
  	#To which I saw uuuuuuuuugh... ugh.
  end
end
