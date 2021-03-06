class Twitt
  include Mongoid::Document

  field :twitt_id
  field :parent_id, :index => true
  field :date
  field :body
  field :user_id

  belongs_to_related :user

  validates_presence_of :body, :message => "body is required"
end
