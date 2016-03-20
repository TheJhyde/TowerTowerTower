desc "This task is called once a day by the Heroku scheduler add-on"
task :daily_tasks => :environment do
  puts "Updates player's actions"
  User.add_actions
  puts "Updates mysterious strangers actions"
  Stranger.add_actions
  puts "Drawing today's tower"
  #Brick.draw_tower
  puts "Done!"
end

desc "Takes all the bricks and runs them"
task :resolve_orders => :environment do
  #A generous range so that orders can be resolved
  currentBricks = BuildOrder.where(used: nil).where("resolve_at < ?", (DateTime.now + 2.minute))
  BuildOrder.resolve_orders(currentBricks);
  # puts "Resolve all the build orders"
  # updates = BuildOrder.resolve_orders
  # puts "Makes unsupported bricks fall."
  # updates = Brick.gravity(updates)
  # puts "Writing all news updates"
  # NewsItem.write_updates(updates)
end