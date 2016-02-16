require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	def setup
		ActionMailer::Base.deliveries.clear
	end

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

	test "valid signup information with account activation" do
		get signup_path
		assert_difference 'User.count', 1 do
			post users_path, user: { email: "foo@bar.com",
									 gender: "___!___!_",
									 password: "password",
									 password_confirmation: "password" },
							 		 name: { name_1: "Cool", name_2: "Goat"}
		end
		assert_equal 1, ActionMailer::Base.deliveries.size
		user = assigns(:user)
		assert_not user.activated?
		#Tries to log in without being activated
		log_in_as(user)
		assert_not is_logged_in?
		#Invalid activation information
		get edit_account_activation_path("Junk nonsense")
		assert_not is_logged_in?
		#Valid token, wrong e-mail
		get edit_account_activation_path(user.activation_token, email: "junk nonsense")
		assert_not is_logged_in?
		#All is right now
		get edit_account_activation_path(user.activation_token, email: user.email)
		assert user.reload.activated?
		follow_redirect!

		assert_template 'static_pages/home'
		assert is_logged_in?
	end
end
