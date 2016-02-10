include Magick

class Brick < ActiveRecord::Base
	belongs_to :user

	@@brick_width = 16
	@@brick_height = 6
	@@offset = 10
	@@pic_height = 1000
	@@pic_width = 100

	def self.gravity
		Brick.where.not(y: 0).each do |brick|
			#If there are no brick underneath, that is
			if Brick.where(x: brick.x, y: brick.y - 1).length == 0
				unless brick.user.nil?
					brick.user.news_items << NewsItem.create(msg_type: "update", 
						message: "One of your bricks fell and was destroyed.")
				end
				brick.destroy
			end
		end
	end

	def self.draw_tower
		#An empty image
		picture = Image.new(@@pic_width, @@pic_height){self.background_color = "white"}
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
		file_name = "tower#{DateTime.now.strftime("%s")}.png"
		picture.write(file_name)

		#Ok, now I gotta send this picture to be store on the Amazon S3 I've got for this project
		s3 = Aws::S3::Resource.new(region:'us-east-1')
		obj = s3.bucket('towerbricklightning').object('AKIAI3PINHWVOTQCT6EA')
		obj.upload_file("#{file_name}")

		#File.delete(file_name)
	end

	def x_to_pic
		x * @@brick_width + @@offset
	end

	def y_to_pic
		@@pic_height - (y+1) * @@brick_height
	end
end
