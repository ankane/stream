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
  if tweet[:delete]
    putc "X"
  else
    begin
      Post.create!(:id => tweet[:id], :user => tweet[:user][:screen_name], :body => tweet[:text], :created_at => tweet[:created_at])
      putc "."
    rescue DataObjects::IntegrityError => e
      putc "*"
    end
    captured += 1
  end
end

EM.run do
  url = "http://stream.twitter.com/1/statuses/filter.json"
  conn = EventMachine::HttpRequest.new(url, :connect_timeout => 5, :inactivity_timeout => 0)

  # sign the request with OAuth credentials
  oauth_opts = YAML.load_file("config/oauth.yml").inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  conn.use EventMachine::Middleware::OAuth, oauth_opts

  http = conn.post :body => {:track => "i want"}
  http.headers do |headers|
    if headers.status == 200
      http.stream do |chunk|
        parser << chunk
      end
    else
      puts "#{headers.http_status}: #{headers.http_reason}"
      EM.stop
    end
  end
  http.callback do |callback|
    puts "callback: #{callback}"
    EM.stop
  end
  http.errback do |error|
    puts "error: #{error}"
    EM.stop
  end
end
