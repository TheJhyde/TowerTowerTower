# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

images = "noun_24037_cc noun_27816 noun_66244_cc noun_68015_cc noun_86908_cc noun_147109_cc noun_167462_cc
noun_204737_cc noun_206666_cc noun_209743_cc noun_213102_cc noun_213212_cc noun_213235_cc noun_213271_cc
noun_213421_cc noun_213492_cc noun_213496_cc noun_214299_cc noun_214573_cc noun_214576_cc noun_214780_cc
noun_214820_cc noun_214827_cc noun_214866_cc noun_214934_cc noun_215208_cc noun_215364_cc noun_215365_cc
noun_215367_cc noun_215570_cc"

meanings = "just him know take people into year your good some could them see 
	other than then now look only come its over think also back after use two how our work first well 
	way even new want because any these give day most us"

urls = images.split(" ")
words = meanings.split(" ")
words.each do |word|
	word.upcase!
end
words.uniq!

urls.each_with_index do |url, i|
	Glyph.create(url: url, meaning: words[i])
end