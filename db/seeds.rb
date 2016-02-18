images = "tower up_top red brick everything_harm mine_build despair down run_is 
bring_lie large_size no_not_never push_destroy both neither row_small column_lucky 
center curse bottom hole left line right within"

meanings = "TOWER UP/TOP RED BRICK EVERYTHING/HARM MINE/BUILD DESPAIR DOWN/GOOD RUN/IS 
BRING/LIE LARGE/SIZE NO/NOT/NEVER PUSH/DESTROY BOTH NEITHER ROW/SMALL COLUMN/LUCKY 
CENTER CURSE BOTTOM HOLE LEFT LINE RIGHT WITHIN"

#Adds the glyphs to the database
urls = images.split(" ")
words = meanings.split(" ")
words.each do |word|
	word.upcase!
end
words.uniq!

urls.each_with_index do |url, i|
	Glyph.create(url: url, meaning: words[i])
end

# NewsItem.create(msg_type: "new", message: "Welcome to Tower Brick Lightning! To get updates 
# 	about the game, check out our <a href ='http://towerbricklightning.tumblr.com/'>tumblr</a>
# 	 or <a href='https://twitter.com/TBLGame'>twitter</a>.")

# 5.times do |i|
# 	2.times do |j|
# 		Brick.create(x: i, y: j, color: rand(3))
# 	end
# end

# 99.times do |n|
# 	name = "#{User::NAME_WORDS.sample} #{User::NAME_WORDS.sample}"
# 	email = "email-#{n}@thejhyde.zone"
# 	password = "password"
# 	gender = "#{User::GENDERS.sample}"
# 	User.create!(name: name,
# 		email: email,
# 		gender: gender,
# 		password: password,
# 		password_confirmation: password,
# 		activated: true,
# 		activated_at: Time.zone.now)
# end