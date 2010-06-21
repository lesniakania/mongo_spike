class Arfollow < ActiveRecord::Base
  belongs_to :followed, :class_name => 'Aruser'
  belongs_to :follower, :class_name => 'Aruser'
end
