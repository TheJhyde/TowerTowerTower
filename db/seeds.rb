# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

name_words = "Goat Mountain Tower Sun Moon Star Horse Desert Tree Hammer Cool Warm Kind Tall 
	Fast Green Dark Run Swim Build See Home Child Plan"

words = name_words.split(" ")
words.each do |word|
	NameWord.create(word: word)
end