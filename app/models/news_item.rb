class NewsItem < ActiveRecord::Base
	has_and_belongs_to_many :users
	validates :message, presence: true

	def self.tell_all(news)
		 broadcast = NewsItem.create(msg_type: "news", message: news)
		 User.all.each do |user|
		 	user.news_items << broadcast
		 	user.save
		 end
	end
end
