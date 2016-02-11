#I don't know why these are Tbl, which was the old name of the project
#But I'm not inclined to go figure it out
#System variables--------------------------------------------------------------------------
Tbl::Application.config.x.glyph_url = "https://s3.amazonaws.com/towerbricklightning/glyphs/"
Tbl::Application.config.x.img_url = "https://s3.amazonaws.com/towerbricklightning/"

#Player variables------------------------------------------------------------------------------
Tbl::Application.config.x.max_actions = 9
Tbl::Application.config.x.daily_actions = 2
Tbl::Application.config.x.starting_actions = 3

#Clay types
Tbl::Application.config.x.clay_types = 3 #How many kinds of clay there are
Tbl::Application.config.x.red = 0
Tbl::Application.config.x.brown = 1
Tbl::Application.config.x.black = 2
Tbl::Application.config.x.no_clay = -1

#Tower variables
Tbl::Application.config.x.brick_height = 40
Tbl::Application.config.x.brick_width = 40

Tbl::Application.config.x.bricks_layer = 10 #How many bricks there are in each level

Tbl::Application.config.x.screen_height = 500
Tbl::Application.config.x.screen_width = 
	Rails.configuration.x.brick_width * (Rails.configuration.x.bricks_layer + 2)
#How many bricks there are on each level
Tbl::Application.config.x.level_height = 
	(Rails.configuration.x.screen_height/Rails.configuration.x.brick_height).floor + 1

Tbl::Application.config.x.shipment = 2 #Players get this many bricks in each shipment

Tbl::Application.config.x.max_levels = 10