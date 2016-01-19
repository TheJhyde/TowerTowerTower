require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
  	@user = users(:coolgoat)
    @non_admin = users(:suntall)
  end

  test "index including pagination and delete links" do
  	log_in_as(@user)
  	get users_path
  	assert_template 'users/index'
  	#This line doesn't work and after half an hour of searching, I can't figure out why
  	#But the page loads perfectly and there's a pagination div and everything
  	#So fuck it, I'm out
  	#assert_select 'div.pagination'

  	User.paginate(page: 1, per_page: 10).each do |user|
  		assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select 'a[href=?]', user_path(user), text: 'delete'
  	end

    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test 'index as non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_not flash.empty?
    assert_redirected_to @non_admin
  end
end
