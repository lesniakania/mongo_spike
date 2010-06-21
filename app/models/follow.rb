class Follow

  include Mongoid::Document

  belongs_to_related :followed
  belongs_to_related :follower

end
