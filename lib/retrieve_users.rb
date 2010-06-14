File.open('users.dat', 'r') do |f|
  while line = f.gets
    line = line.split("\t")
    user_id = line[0]
    nick = line[1]
    name = line[2] =~ /\\N/ ? nil : line[2]
    location = line[3] =~ /\\N/ ? nil : line[3]
    page_rank = line[4].to_i
    User.create(
      :user_id => user_id,
      :nick => nick,
      :name => name,
      :location => location,
      :page_rank => page_rank
    )
  end
end
