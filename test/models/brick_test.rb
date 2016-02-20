require 'test_helper'

class BrickTest < ActiveSupport::TestCase
	def setup
		@brick = Brick.first
	end

	#The simplest imaginable test - there is a brick with no support, it should fall
	test "bricks should fall without support" do
		Brick.create(x: 3, y: 100, color: 3)
		Brick.gravity
		assert_equal(1, Brick.count, "The new brick should have been destroyed")
	end

	test "bricks on level zero shouldn't fall" do
		Brick.create(x: 3, y: 0, color: 3)
		Brick.gravity
		assert_equal(2, Brick.count, "The new brick should have been destroyed")
	end

	test "bricks shouldn't fall with support directly below" do
		Brick.create(x: @brick.x, y: @brick.y + 1, color: 3)
		Brick.gravity
		assert_equal(2, Brick.count, "The new brick should not have been destroyed")
	end

	test "bricks shouldn't fall with support to the left" do
		Brick.create(x: @brick.x - 1, y: @brick.y + 1, color: 3)
		Brick.gravity
		assert_equal(2, Brick.count, "The new brick should not have been destroyed")
	end

	test "bricks shouldn't fall with support to the right" do
		Brick.create(x: @brick.x + 1, y: @brick.y + 1, color: 3)
		Brick.gravity
		assert_equal(2, Brick.count, "The new brick should not have been destroyed")
	end

	test "bricks should fall if the bricks below it are too far away" do
		Brick.create(x: @brick.x + 2, y: @brick.y + 1, color: 3)
		Brick.gravity
		assert_equal(1, Brick.count, "The new brick should have been destroyed")

		Brick.create(x: @brick.x - 2, y: @brick.y + 1, color: 3)
		Brick.gravity
		assert_equal(1, Brick.count, "The new brick should have been destroyed")
	end

	test "bricks should fall if the bricks are too far below it" do
		Brick.create(x: @brick.x, y: @brick.y + 2, color: 3)
		Brick.gravity
		assert_equal(1, Brick.count, "The new brick should have been destroyed")

		Brick.create(x: @brick.x - 1, y: @brick.y + 2, color: 3)
		Brick.gravity
		assert_equal(1, Brick.count, "The new brick should have been destroyed")

		Brick.create(x: @brick.x + 1, y: @brick.y + 2, color: 3)
		Brick.gravity
		assert_equal(1, Brick.count, "The new brick should have been destroyed")
	end



	#I'm not sure if theres anything else to test. Does 
end
