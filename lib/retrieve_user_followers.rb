File.open('user_followers.dat', 'r') do |f|
  while line = f.gets
    line = line.split("\t")
    user_follower_id = line[0]
    user_id = line[1]
    follower_id = line[2] =~ /\\N/ ? nil : line[2]
    UserFollower.create(
      :user_followe_id => user_follower_id,
      :user_id => user_id,
      :follower_id => follower_id
    )
  end
end
