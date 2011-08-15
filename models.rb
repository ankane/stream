require "data_mapper"

# Log to STDOUT.
# DataMapper::Logger.new($stdout, :debug)

DataMapper.setup(:default, "mysql://localhost/stream_development")

class Post
  include DataMapper::Resource

  property :id,         Integer, :key => true, :min => 0, :max => 2**32
  property :user,       String
  property :body,       Text
  property :created_at, DateTime
end

DataMapper.finalize

DataMapper.auto_upgrade!
