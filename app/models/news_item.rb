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

	def self.write_updates(news)
		news.each do |user_hash|
			user = User.find(user_hash["user"].to_i)
			msg = ""
			if user_hash["placed"] > 0
				msg += "You placed #{pluralize(user_hash['placed'], 'brick')} on the tower. "
			end
			if user_hash['destroyed'] > 0
				msg += "#{pluralize(user_hash['destroyed'], 'of your brick')} were destroyed in collisions. "
			end
			if user_hash['fell'] > 0
				msg += "#{pluralize(user_hash['fell'], 'of your brick')} fell and were destroyed."
			end
			user.news_items << NewsItem.create(msg_type: "update", message: msg)
		end
	end

	#Takes the news hash I'm building and tells you if it contains a given player
	def self.add_to(news, id, key)
		news.each do |hash|
			if hash["user"] == id
				hash[key] = hash[key] + 1
				return news
			end
		end
		hash = {"user" => id, "#{key}" => 1}
		hash.default = 0
		news << hash
	end
end
