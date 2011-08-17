require "em-http"
require "em-http/middleware/oauth"
require "simple_oauth"
require "yajl"

require_relative "models"

captured = 0

trap("INT") do
  puts "\n\nCaptured #{captured} objects from the stream"
  puts "CTRL+C caught, later!"
  exit(0)
end

parser = Yajl::Parser.new(:symbolize_keys => true)
parser.on_parse_complete = lambda do |tweet|
  next if tweet[:delete]

  begin
    Post.create!(:id => tweet[:id], :user => tweet[:user][:screen_name], :body => tweet[:text], :created_at => tweet[:created_at])
    putc "."
  rescue DataObjects::IntegrityError => e
    putc "X"
  end
  captured += 1
end

EM.run do
  conn = EventMachine::HttpRequest.new("http://stream.twitter.com/1/statuses/filter.json")

  # sign the request with OAuth credentials
  oauth_opts = YAML.load_file("config/oauth.yml").inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  conn.use EventMachine::Middleware::OAuth, oauth_opts

  http = conn.post :body => {:track => "i want"}
  http.stream do |chunk|
    parser << chunk
  end
end
