class User
  include Mongoid::Document

  field :user_id
  field :nick
  field :name
  field :location
  field :page_rank

  has_many_related :twitts
end
