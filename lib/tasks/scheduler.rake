desc "This task is called by the Heroku scheduler add-on"
task :daily_tasks => :environment do
  puts "Clearing out unfinished clay shipments"
  ClayShipment.clear_out
  puts "Just deletes all the mines, we don't need them anymore"
  Mine.delete_all
  puts "Done!"
end