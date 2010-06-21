class Twitt

  include Mongoid::Document

  field :twitt_id, :type => Integer
  field :parent_id, :type => Integer, :index => true
  field :date, :type => Date
  field :body
  field :user_id, :type => Integer
  
end
