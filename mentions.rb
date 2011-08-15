require_relative "models"

users = Hash.new(0)

Post.each do |post|

  post.body.scan(/@\w+/) do |user|
    users[user] += 1
  end

end

puts users.sort{ |a,b| -1*(a[1]<=>b[1]) }.first(10).map{ |val| "#{val[0]}: #{val[1]}" }
