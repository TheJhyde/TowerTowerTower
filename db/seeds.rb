images = "tower up_top red brick everything_harm mine_build despair down run_is 
bring_lie large_size no_not_never push_destroy both neither row_small column_lucky 
center curse bottom hole left line right within"

meanings = "TOWER UP/TOP RED BRICK EVERYTHING/HARM MINE/BUILD DESPAIR DOWN/GOOD RUN/IS 
BRING/LIE LARGE/SIZE NO/NOT/NEVER PUSH/DESTROY BOTH NEITHER ROW/SMALL COLUMN/LUCKY 
CENTER CURSE BOTTOM HOLE LEFT LINE RIGHT WITHIN"

#Adds the glyphs to the database
# urls = images.split(" ")
# words = meanings.split(" ")
# words.each do |word|
# 	word.upcase!
# end
# words.uniq!

# urls.each_with_index do |url, i|
# 	Glyph.create(url: url, meaning: words[i])
# end

# NewsItem.create(msg_type: "new", message: "Welcome to Tower Brick Lightning! To get updates 
# 	about the game, check out our <a href ='http://towerbricklightning.tumblr.com/'>tumblr</a>
# 	 or <a href='https://twitter.com/TBLGame'>twitter</a>.")

# 5.times do |i|
# 	15.times do |j|
# 		Brick.create(x: i, y: j, color: rand(3))
# 	end
# end

100.times do |i|
	new_brick = Brick.find_or_create_by(x: i, y: 0)
	new_brick.color = rand(2)
	new_brick.user = User.first
	new_brick.level = -1;
	new_brick.strength = 0;
	new_brick.save
end