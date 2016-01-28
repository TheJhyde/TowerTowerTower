#System variables--------------------------------------------------------------------------
Tbl::Application.config.x.img_url = "https://s3.amazonaws.com/towerbricklightning/glyphs/"

#Player variables------------------------------------------------------------------------------
Tbl::Application.config.x.max_actions = 20
Tbl::Application.config.x.daily_actions = 3
Tbl::Application.config.x.starting_actions = 5

#Mining variables ----------------------------------------------------------------------------
#How many mines appear on a page
Tbl::Application.config.x.total_mines = 3
#How many times the server will attempt to get clay when you mine
Tbl::Application.config.x.mine_actions = 4
#Pack width
Tbl::Application.config.x.pack_width = 5
#Pack height
Tbl::Application.config.x.pack_height = 2
#The total size of the pack
Tbl::Application.config.x.pack_total = Rails.configuration.x.pack_width * Rails.configuration.x.pack_height
#Clay types
Tbl::Application.config.x.clay_types = 3 #How many kinds of clay there are
Tbl::Application.config.x.red = 0
Tbl::Application.config.x.brown = 1
Tbl::Application.config.x.black = 2
Tbl::Application.config.x.no_clay = -1
#The maximum number of clay you can find in a mine
Tbl::Application.config.x.mine_max = 10
#The minimum number of clay you can find in a mine
Tbl::Application.config.x.mine_min = 8
#How big the initial amount of clay put into the mine should be
Tbl::Application.config.x.clay_start = 4

#Brick Making variables-----------------------------------------------------------
Tbl::Application.config.x.clay_shipments = 3

Tbl::Application.config.x.oven_width = 4
Tbl::Application.config.x.oven_height = 2

#How much of the clay must be the same in order for the brick to be strong
Tbl::Application.config.x.strong_amount = 5
#How much the clay must be the same in order for the brick to be medium strength
Tbl::Application.config.x.strong_amount = 3
