include Magick

class Brick < ActiveRecord::Base
	belongs_to :user
	belongs_to :stranger
	has_many :events

	@@brick_width = Global.tower.brick_width/5
	@@brick_height = Global.tower.brick_height/5
	@@pic_width = @@brick_width * (Global.tower.bricks_layer + 2)
	@@offset = (@@pic_width - @@brick_width * Global.tower.bricks_layer)/2
	@@pic_height = Global.tower.level_height * @@brick_width * Global.tower.max_levels

	def self.gravity(news = [])
		Brick.where.not(y: 0).order(:y).each do |brick|
			#If there are no brick underneath, that is
			if Brick.where(x: ((brick.x-1)..(brick.x+1)), y: brick.y - 1).length == 0
				unless brick.user.nil?
					# brick.user.news_items << NewsItem.create(msg_type: "update", 
					# 	message: "One of your bricks fell and was destroyed.")
					news = NewsItem.add_to(news, brick.user.id, "fell")
				end
				brick.destroy
			end
		end
		return news
	end

	def self.check_strength(news = [])
		Brick.all.each do |brick|
			#Bricks which are too weak for their level are destroyed
			if brick.strength < (brick.level+1/3).round
				brick.destroy
				news = NewsItem.add_to(news, brick.user.id, "weak")
			end
		end
	end

	def self.draw_tower
		#An empty image
		picture = Image.new(@@pic_width, @@pic_height){self.background_color = "rgb(200,200,200)"}
		#A drawing thing
		tower = Magick::Draw.new
		tower.stroke("black")
		#Draw all of the bricks
		Brick.all.each do |brick|
			if brick.color == 0
				tower.fill("rgb(200, 0, 0)")
			elsif brick.color == 1
				tower.fill("rgb(0, 200, 0)")
			elsif brick.color == 2
				tower.fill("rgb(0, 0, 200)")
			end
			tower.rectangle(brick.x_to_pic, brick.y_to_pic, 
				brick.x_to_pic + @@brick_width, brick.y_to_pic + @@brick_height)
		end
		tower.draw(picture)
		#Save the file
		file_name = "tower#{DateTime.now.strftime("%s")}.png"
		picture.write(file_name)

		#Send picture to be stored on the Amazon S3 I've got for this project
		s3 = Aws::S3::Resource.new(region:'us-east-1')
		obj = s3.bucket('towerbricklightning').object("tower/#{file_name}")
		obj.upload_file(file_name)
		TowerPic.create(file: file_name)

		#Delete the photo so it doesn't clutter up the place/interfer with heroku somehow
		File.delete(file_name)
	end

	def x_to_pic
		x * @@brick_width + @@offset
	end

	def y_to_pic
		@@pic_height - (y+1) * @@brick_height
	end
end
