class User < ActiveRecord::Base
	attr_accessor :remember_token, :activation_token, :reset_token
	#Befores
	before_save :downcase_email, if: "signed_up?"
	before_create :create_activation_digest

	#Validations, so many validations
	validates :name, presence: true, length: {maximum: 50}
	has_secure_password validations: false
	#Checks all of these for a real user
	with_options :if => Proc.new{|user| user.signed_up? } do |signed_user|
		signed_user.validates :password, presence: true, length: { minimum: 6 }
		VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
		signed_user.validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX},
		uniqueness: {case_sensitive: false}
	end
	
	#Relationships. Users own a lot of stuff
	has_and_belongs_to_many :news_items
	has_many :build_orders
	has_many :bricks
	
	#Some variables used for the sign up form
	GENDERS = ['4524', '___!___!_', 'zzzzzz', '<_>']
	NAME_WORDS = "Goat Mountain Tower Sun Moon Star Horse Desert Tree Hammer Cool Warm Kind Tall 
	Fast Green Dark Run Swim Build See Home Child Plan".split(" ")
	CURSES = "bees/no skin/constant darkness/a confusion of senses/an evil ghost/the inability to die".split("/")

	#Returns the hash digest of the given string
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    	BCrypt::Password.create(string, cost: cost)
	end

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	def self.daily_tasks
  		User.add_actions
	end

	#Adds an action to all users
	def self.add_actions
		User.all.each do |user|
			if user.signed_up
				user.actions += Global.player.daily_actions
			else
				user.actions += Global.player.stranger_actions
			end

			if user.actions > Global.player.max_actions
				user.actions = Global.player.max_actions
			end
			user.save
		end
	end

	def activate
		update_attribute(:activated, true);
		update_attribute(:activated_at, Time.zone.now);
	end

	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end

	private
		def downcase_email
			self.email = email.downcase
		end

		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end
end
