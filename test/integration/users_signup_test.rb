require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	test "invalid signup information" do
		get signup_path
		assert_no_difference 'User.count' do
			post users_path, user: { email: "dumb@invalid",
									 gender: "",
									 password: 				"foo",
									 password_confirmation: "bar" },
							 name: { name_1: "_", name_2: ""}
		end
		assert_template 'users/new'
	end

	test "valid signup information" do
		get signup_path
		assert_difference 'User.count', 1 do
			post_via_redirect users_path, user: { email: "foo@bar.com",
												  gender: "___!___!_",
												  password: "password",
												  password_confirmation: "password" },
							 			   name: { name_1: "Cool", name_2: "Goat"}
		end
		assert_template 'users/show'
	end
end