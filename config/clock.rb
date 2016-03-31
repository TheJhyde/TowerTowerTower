require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.hour, 'Run Build Orders', tz: 'EST', :at => ['**:00', '**:05', '**:10', '**:15', '**:20', '**:25', '**:30', '**:35', '**:40', '**:45', '**:50', '**:55']) { BuildOrder.resolve_orders }
  every(20.minutes, 'Write events', :at => ['**:00', '**:20', '**:40']) { NewsItem.write_updates }
  #every(1.day, 'Update actions', :at => '12:00', tz: 'EST') {User.add_actions}
  every(1.hour, 'Update actions', :at => '**:00', tz: 'EST') {User.add_actions}
end