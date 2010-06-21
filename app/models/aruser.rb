class Aruser < ActiveRecord::Base
  has_many :followers, :class_name => 'Arfollow', :foreign_key => 'followed_id'
  has_many :followed_users, :class_name => 'Arfollow', :foreign_key => 'follower_id'
end
