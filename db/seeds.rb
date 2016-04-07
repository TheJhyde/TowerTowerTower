images = 'both bottom bring builder builders column despair down error hole large left
monster neither no destroy pyramid right up warning within white black top'

meanings = images

#Adds the glyphs to the database
urls = images.split(' ')
words = meanings.split(' ')
words.each do |word|
	word.upcase!
end
words.uniq!

urls.each_with_index do |url, i|
	Glyph.find_or_create_by(url: url, meaning: words[i])
end

# intro = NewsItem.find_or_create_by(id: 1)
# intro.update(msg_type: "new", message: "Welcome to Tower Brick Lightning! To get updates 
# 	about the game, check out our <a href ='http://towerbricklightning.tumblr.com/'>tumblr</a>
# 	 or <a href='https://twitter.com/TBLGame'>twitter</a>.")

#Make a foundation
# 100.times do |i|
# 	new_brick = Brick.find_or_create_by(x: i, y: 0)
# 	new_brick.color = rand(2)
# 	new_brick.user = User.first
# 	new_brick.level = -1;
# 	new_brick.strength = 0;
# 	new_brick.save
# end

# #Make's a pyramid to demonstrate concepts
# (1..15).each do |i|
# 	((15 - i)*2).times do |j|
# 		new_brick = Brick.find_or_create_by(x: j+50+i, y: i)
# 		new_brick.color = rand(2)
# 		new_brick.user = User.first
# 		new_brick.level = (i - 1)/10;
# 		new_brick.strength = rand(3);
# 		new_brick.save
# 	end
# end

# me = User.find_or_create_by(name: "Cool Goat")
# me.update(admin: true, email: "jkhyde86@gmail.com", activated: true, actions: 100, password: User.digest('password'))