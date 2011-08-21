require_relative "../models"

i = 0
limit = 1000

n = 3
regex_str = '\Ai want( an?)?'
n.times{ regex_str << '( \w+)?'  }
regex = Regexp.new(regex_str, true) # case-insensitive

while posts = Post.all(:limit => limit, :offset => i * limit) and !posts.empty?
  posts.each do |post|

    match = regex.match(post.body)
    if match
      word = match[2..(n + 1)].to_a.compact.map{ |w| w.strip }
      puts [word.inspect, 1].join("\t")
    end

  end

  i += 1
end
