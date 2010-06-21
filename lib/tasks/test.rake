require 'benchmark'

task :run_test => :environment do
  puts "Deleting data..."
  User.delete_all
  Follow.delete_all
  Aruser.delete_all
  Arfollow.delete_all

  puts "Generating new user data in memory..."
  user_data = (0...2000).map do
    { :login => Faker::Internet.user_name + rand(10000).to_s }
  end.uniq

  arusers = []
  users = []
  puts "Saving users to databases..."
  Benchmark.bm do |x|
    x.report("mysql:") do
      arusers += user_data.map { |ud| Aruser.create!(ud) }
    end
    x.report("mongo:") do
      users += user_data.map { |ud| User.create!(ud) }
    end
  end

  puts "Generating follow data in memory..."
  follow_data = (0...100000).map do
    [Math.sqrt(rand(user_data.count)).to_i, rand(user_data.count)]
  end.uniq.find_all { |pair| pair[0] != pair[1] }

  puts "Saving follows to databases..."
  Benchmark.bm do |x|
    x.report("mysql:") do
      follow_data.each { |fd| Arfollow.create!(:followed => arusers[fd[0]], :follower => arusers[fd[1]]) }
    end
    x.report("mongo:") do
      follow_data.each { |fd| Follow.create!(:followed => users[fd[0]], :follower => users[fd[1]]) }
    end
  end

  puts "Creating super users..."
  user_data << { :login => 'billgates' }
  user_data << { :login => 'stevejobs' }
  arusers += user_data.last(2).map { |ud| Aruser.create!(ud) }
  users += user_data.last(2).map { |ud| User.create!(ud) }

  new_user_data = (0...20000).map do
    { :login => Faker::Internet.user_name + rand(10000).to_s }
  end.uniq
  new_arusers = new_user_data.map { |ud| Aruser.create!(ud) }
  new_users = new_user_data.map { |ud| User.create!(ud) }

  puts "Creating super user 1..."
  bg_followers = (0...(new_user_data.count / 2)).map { rand(new_user_data.count) }.uniq
  bg_followers.each do |i|
    Arfollow.create! :followed => arusers[-2], :follower => new_arusers[i]
    Follow.create! :followed => users[-2], :follower => new_users[i]
  end

  puts "Creating super user 2..."
  sj_followers = (0...(new_user_data.count / 2)).map { rand(new_user_data.count) }.uniq
  sj_followers.each do |i|
    Arfollow.create! :followed => arusers[-1], :follower => new_arusers[i]
    Follow.create! :followed => users[-1], :follower => new_users[i]
  end

  puts "Super user 1 has #{bg_followers.length} followers"
  puts "Super user 2 has #{sj_followers.length} followers"
  puts "common followers: #{(bg_followers & sj_followers).length}"

  # most_followed = follow_data.group_by { |fd| fd.first }.map { |k, v| [k, v.length] }.sort_by { |pair| pair[1] }.last(2)
  # most_followed2, most_followed1 = most_followed
  # most_followed1_id, most_followed1_count = most_followed1
  # most_followed2_id, most_followed2_count = most_followed2
  # puts "Most followed user: ##{most_followed1_id} - #{most_followed1_count} followers."
  # puts "Second most followed user: ##{most_followed2_id} - #{most_followed2_count} followers."

  puts "Fetching list of followers for both super users (separately)"
  results = []
  Benchmark.bm do |x|
    x.report("mysql:") do
      # results << arusers[most_followed1_id].followers.to_a.length
      results << arusers[-2].reload.followers.to_a.length
      results << arusers[-1].reload.followers.to_a.length
    end
    x.report("mongo:") do
      # results << users[most_followed1_id].followers.to_a.length
      results << users[-2].reload.followers.to_a.length
      results << users[-1].reload.followers.to_a.length
    end
  end
  puts "Got: #{results.inspect}."

  puts "Comparing two follower lists:"
  results = []
  Benchmark.bm do |x|
    x.report("mysql with joins   ") do
      join = Aruser.find_by_sql("select a.follower_id from (select follower_id from arfollows where followed_id = #{arusers[-2].id}) as a inner join (select follower_id from arfollows where followed_id = #{arusers[-1].id}) as b on (a.follower_id = b.follower_id)").map(&:follower_id)
      results << join.length
    end
    x.report("mysql without joins") do
      a = arusers[-2].reload.followers.map(&:follower_id)
      b = arusers[-1].reload.followers.map(&:follower_id)
      join = a & b
      results << join.length
    end
    x.report("mongo standard     ") do
      a = users[-2].reload.followers.map(&:follower_id)
      b = users[-1].reload.followers.map(&:follower_id)
      join = a & b
      results << join.length
    end
  end
  puts "Got: #{results.inspect}."

  puts "Done."
end
