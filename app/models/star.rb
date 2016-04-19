class Star < ActiveRecord::Base
  belongs_to :level

  def self.check_for_found
    Star.where(found: false).each do |star|
      if Brick.where(x: star.x, y: star.y).count > 0
        star.star_found(Brick.where(x: star.x, y: star.y).first.user)
      end
    end
  end

  def star_found(user)
    self.found = true
    self.save
    msg = NewsItem.create(message: "A shard was found on level #{self.level.level} by #{user.name}. All players are given two bonus actions.", msg_type: 'news')
    User.all.each do |user|
      user.actions = user.actions + 2
      user.news_items << msg
      user.save
    end
  end

end
