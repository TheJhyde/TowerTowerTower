#Adds the glyphs to the database
def add_glyphs
  images = 'both bottom bring builder builders column despair down error hole large left
  monster neither no destroy pyramid right up warning within white black top'

  meanings = images

  urls = images.split(' ')
  words = meanings.split(' ')
  words.each do |word|
    word.upcase!
  end
  words.uniq!

  urls.each_with_index do |url, i|
    Glyph.find_or_create_by(url: url, meaning: words[i])
  end
end

def add_intro
	intro = NewsItem.find_or_create_by(id: 1)
	intro.update(msg_type: 'new', message: "Welcome to Tower Brick Lightning! To get updates
		about the game, check out our <a href ='http://towerbricklightning.tumblr.com/'>tumblr</a>
		 or <a href='https://twitter.com/TBLGame'>twitter</a>.")
end

def build_foundation
	100.times do |i|
		new_brick = Brick.find_or_create_by(x: i, y: 0)
		new_brick.color = rand(2)
		new_brick.user = User.first
		new_brick.level = -1;
		new_brick.strength = 0;
		new_brick.save
	end
end

def define_levels
  Level.delete_all
  default_text = "Continue building the tower.|Your bricks will be added to the tower <nextTime()>."
  Level.create(level: 0,
               update_rate: 0,
               strength_requirement: 0,
               background: 'level_one.jpg',
               text: "Build the tower. Do not let your bricks <a href ='/gravity'>fall.</a>. Do not <a href = '/strength'>overlap</a> bricks of opposing colors.|
                Click on your bricks or press space to move them. Click submit to add your bricks to the tower.")
  Level.create(level: 1,
               update_rate: 5,
               strength_requirement: 0,
               background: 'level_two.jpg',
               text: "At this height bricks will be added to the tower every five minutes.|
                Your bricks will be added to the tower <nextTime()>. Tell other builders where they'll be. Click glyphs to write your message. Click on glyphs in the message to delete them. All bricks must have messages!")
  Level.create(level: 2,
               update_rate: 5,
               strength_requirement: 1,
               background: 'level_three.jpg',
               text: "Heavy winds on this level will destroy any bricks which don't have at least one <a href='/strength' target='_blank'>strength</a>|
                Your bricks will be added to the tower at <nextTime()> Use the glyphs so other builders make your bricks stronger")
  Level.create(level: 3,
               update_rate: 10,
               strength_requirement: 1,
               background: 'level_four.jpg',
               text: 'Orders are now resolved every 10 minutes.|
                Your bricks will be added to the tower at <nextTime()>. Use the glyphs so other builders make your bricks stronger.')
  Level.create(level: 4,
               update_rate: 10,
               strength_requirement: 1,
               background: 'level_five.jpg',
               text: default_text)
  Level.create(level: 5,
               update_rate: 15,
               strength_requirement: 2,
               background: 'level_six.jpg',
               text: default_text)
  Level.create(level: 6,
               update_rate: 15,
               strength_requirement: 2,
               background: 'level_seven.jpg',
               text: default_text)
  set_levels
end

def set_levels
  Brick.all.each do |brick|
    brick.update(level: Level.find_by_y(brick.y))
  end
  BuildOrder.all.each do |order|
    order.update(level: Level.find_by_y(order.y[0]))
  end
end

define_levels

# me = User.find_or_create_by(name: "Cool Goat")
# me.update(admin: true, email: "jkhyde86@gmail.com", activated: true, actions: 100, password: User.digest('password'))