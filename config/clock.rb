require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(5.minutes, 'Check Build Orders', tz: 'EST') { BuildOrder.resolve_orders }
end