require_relative "../models"

i = 0
limit = 1000

while posts = Post.all(:limit => limit, :offset => i * limit) and !posts.empty?

  posts.each do |post|
    post.body.scan(/@\w+/) do |username|
      puts [username, 1].join("\t")
    end
  end

  i += 1
end
