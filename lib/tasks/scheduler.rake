desc "This task is called once a day by the Heroku scheduler add-on"
task :daily_tasks => :environment do
  puts "Updates player's actions"
  User.add_actions
  puts "Drawing today's tower"
  Brick.draw_tower
  puts "Done!"
end

desc "This task is called more often, to keep things moving"
task :hourly_tasks => :environment do
  #A generous range so that orders can be resolved
  currentBricks = BuildOrder.where(resolve_at: (DateTime.now - 2.minute)..(DateTime.now + 2.minute), used: nil)
  BuildOrder.resolve(currentBricks);
  # puts "Resolve all the build orders"
  # updates = BuildOrder.resolve_orders
  # puts "Makes unsupported bricks fall."
  # updates = Brick.gravity(updates)
  # puts "Writing all news updates"
  # NewsItem.write_updates(updates)
end