class User

  include Mongoid::Document

  field :login

  has_many_related :followers, :foreign_key => 'followed_id', :class_name => 'Follow'
  has_many_related :followed_users, :foreign_key => 'follower_id', :class_name => 'Follow'

end
