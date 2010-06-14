Twitt.all.each do |t|
  u = User.first(:conditions => { :user_id => t.user_id })
  t.user = u
  t.save
end