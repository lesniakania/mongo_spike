class User
  include Mongoid::Document

  field :user_id
  field :nick
  field :name
  field :location
  field :page_rank
end
