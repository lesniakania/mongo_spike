File.open('user_followers.dat', 'r') do |f|
  while line = f.gets
    line = line.split("\t")
    user_follower_id = line[0].to_i
    user_id = line[1].to_i
    follower_id = line[2].to_i
    UserFollower.create(
      :user_followe_id => user_follower_id,
      :user_id => user_id,
      :follower_id => follower_id
    )
  end
end
