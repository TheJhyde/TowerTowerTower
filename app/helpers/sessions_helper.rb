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
		end
	end

	def logged_in?
		!current_user.nil?
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
		if logged_in?
			unless current_user.actions > 0
				flash[:danger] = "You are out of actions for day. You'll get more actions at noon EST."
	      		redirect_to '/'
			end
		else
			if session["acted"].nil?
				session["acted"] = 0;
				session["acted_date"] = DateTime.now.utc.to_i;
			else
				if session["acted_date"] < 1.day.ago.utc.to_i
					session["acted"] = 0;
					session["acted_date"] = DateTime.now.utc.to_i;
				end
				if session["acted"] >= Global.player.stranger_actions
					flash[:success] = "Bricks placed! You've used up your actions for the day. Sign up or come back tomorrow build more!"
		      		redirect_to '/'
		      	end
			end
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
