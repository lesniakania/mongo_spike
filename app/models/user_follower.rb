class UserFollower
  include Mongoid::Document

  field :user_follower_id
  field :user_id
  field :follower_id
end
