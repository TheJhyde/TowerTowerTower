class NewsItem < ActiveRecord::Base
	has_and_belongs_to_many :users
	validates :message, presence: true
end
