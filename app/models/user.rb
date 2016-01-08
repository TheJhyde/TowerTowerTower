class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	validates :name, presence: true, length: {maximum: 50}
	validates :user_name, presence: true, length: {maximum: 50}, format: { with: /\A[a-zA-Z0-9]+\Z/ },
		uniqueness: {case_sensitive: false}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX},
		uniqueness: {case_sensitive: false}
	has_secure_password
	validates :password, presence: true, length: { minimum: 6}

	GENDERS = ['4524', '___!___!_', 'zzzzzz', '<_>']

	NAME_WORDS = "Goat Mountain Tower Sun Moon Star Horse Desert Tree Hammer Cool Warm Kind Tall 
	Fast Green Dark Run Swim Build See Home Child Plan".split(" ")
end
