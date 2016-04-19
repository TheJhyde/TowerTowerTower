class Level < ActiveRecord::Base
  has_many :bricks
  has_many :build_orders
  has_many :stars
  validates :level, presence: true, uniqueness: true

  @default_text = 'Continue building the tower.|Your bricks will be added to the tower <nextTime()>.'

  def self.find_by_y(y)
    my_level = (y - 1)/10
    if Level.where(level: my_level).first.nil?
      Level.create(level: my_level,
                   update_rate: ((my_level+1)/2).round * 5,
                   strength_requirement: ((my_level+1)/3).round,
                   background: 'level_thirteen.jpg',
                   text: @default_text)
    else
      Level.where(level: my_level).first
    end
  end
end