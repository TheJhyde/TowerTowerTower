module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id
	end

	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	def current_user
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(:remember, cookies[:remember_token])
				log_in user
				@current_user = user
			end
		else
			new_user = User.create(actions: Global.player.stranger_actions, 
				name: "Mysterious Stranger #{User.count + 1}", 
				signed_up: false)
			log_in new_user #This is weird because I'm logging the user in but they won't be actually be logged in
			@current_user = new_user
		end
	end

	def logged_in?
		!current_user.nil? && current_user.signed_up
	end

	def logged_in_user
		unless logged_in?
			store_location
			flash[:danger] = "You must log in to do that"
			redirect_to login_url
		end
	end

	def current_user?(user)
		user == current_user
	end

	def check_admin
		unless current_user.admin?
			flash[:danger] = "Only admins may access that page."
			redirect_to current_user
		end
	end

	def has_actions
		unless current_user.actions > 0
			flash[:danger] = "You are out of <a href ='/actions' target = '_blank'>actions</a> for day. You'll get more at noon EST."
      		redirect_to tower_index_path
		end
	end

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	def log_out
		forget(current_user)
		#session.delete(:user_id)
		reset_session
		@current_user = nil
	end

	def store_location
		session[:forwarding_url] = request.url if request.get?
	end

	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end
end
