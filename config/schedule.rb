set :environment, "production"

every '*/5 * * * *' do
  rake 'place_bricks'
  rake 'daily_tasks'
end