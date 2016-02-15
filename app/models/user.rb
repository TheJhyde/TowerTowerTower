class User < ActiveRecord::Base
	attr_accessor :remember_token, :activation_token
	#Befores
	before_save :downcase_email
	before_create :create_activation_digest
	#Validations, so many validations
	validates :name, presence: true, length: {maximum: 50}
	validates :user_name, presence: true, length: {maximum: 50}, format: { with: /\A[a-zA-Z0-9]+\Z/ },
		uniqueness: {case_sensitive: false}, allow_nil: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX},
		uniqueness: {case_sensitive: false}
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
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

	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	#Adds an action to all users
	def self.add_actions
		User.all.each do |user|
			user.actions += Rails.configuration.x.daily_actions
			if user.actions > Rails.configuration.x.max_actions
				user.actions = Rails.configuration.x.max_actions
			end
			user.save
		end
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
