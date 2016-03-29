include ActionView::Helpers::TextHelper

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

	#I'm routing this method through News Items because I'm pretty sure clockwork has it's own
	#class called event. So it gets confused if I try to call an event method
	def self.write_updates
		Event.write_updates
	end

	#This is a pointless function that only exists to test scheduler apps
	#It does something where it's very clear if it happened or not
	def self.log_called
		msg = NewsItem.create(msg_type: "news", message: "This function got called, which is a thing you wanted to happen.")
		User.first.news_items << msg
	end
end
