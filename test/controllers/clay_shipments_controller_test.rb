require 'test_helper'

class ClayShipmentsControllerTest < ActionController::TestCase
  def setup
	@user = users(:coolgoat)
  end

  test "should get new" do
  	log_in_as(@user)
    get :new
    assert_response :success
  end

  test "should get index" do
  	log_in_as(@user)
    get :index
    assert_response :success
  end

  test "should redirect new when not logged in" do
  	get :new
  	assert_not flash.empty?
  	assert_redirected_to login_url
  end

  test "should redirect index when not logged in" do
  	get :index
  	assert_not flash.empty?
  	assert_redirected_to login_url
  end

  #Should I test the other ones? They're all urls for ajax, so I dunno

end
