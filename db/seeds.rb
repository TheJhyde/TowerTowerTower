# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

images = "tower up_top red brown black brick clay everything_harm mine_build work_game
despair down bread run_is language glyph bring_lie large_size no_not_never push_destroy
both neither row_small column_lucky center build_haunted avoid_prevent triangle_carry
wisdom_pile strong weak_gods curse"

meanings = "TOWER UP/TOP RED BROWN BLACK BRICK CLAY EVERYTHING/HARM MINE/BUILD GAME/WORK
DESPAIR DOWN/GOOD BREAD RUN/IS LANGUAGE GLYPH BRING/LIE LARGE/SIZE NO/NOT/NEVER PUSH/DESTROY 
BOTH NEITHER ROW/SMALL COLUMN/LUCKY CENTER BAKE/HAUNTED AVOID/PREVENT TRIANGLE/CARRY 
WISDOM/PILE STRONG WEAK/GODS CURSE"

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