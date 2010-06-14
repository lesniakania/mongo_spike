File.open('twitts.dat', 'r') do |f|
  while line = f.gets
    line = line.split("\t")
    twitt_id = line[0]
    parent_id = line[1] =~ /\\N/ ? nil : line[1]
    date = DateTime.strptime(line[2], "%Y-%m-%d %H:%M:%S")
    body = line[3]
    user_id = line[4].to_i
    Twitt.create(
      :twitt_id => twitt_id,
      :parent_id => parent_id,
      :date => date,
      :body => body,
      :user_id => user_id
    )
  end
end
