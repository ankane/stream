require_relative "models"

words = Hash.new(0)
total = 0
hits = 0

n = 4

regex_str = '\Ai want( an?)?'
n.times{ regex_str << '( \w+)?'  }

regex = Regexp.new(regex_str, true) # case-insensitive

Post.each do |post|

  match = regex.match(post.body)
  if match
    word = match[2..(n + 1)].to_a.compact.map{ |w| w.strip }
    words[word] += 1
    hits += 1
  end
  total += 1
end

puts "#{hits} / #{total} matches."
puts words.sort{ |a,b| -1*(a[1]<=>b[1]) }.first(10).map{ |val| "#{val[0]}: #{val[1]}, %.2f%%" % [val[1] * 100.0 / total]  }
