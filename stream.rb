require "yajl/http_stream"
require "simple_oauth"

require_relative "models"

url = "http://stream.twitter.com/1/statuses/filter.json"
params = {:track => "i want"}

# Read OAuth config file and symbolize keys.
oauth = YAML.load_file("config/oauth.yml").inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
oauth_header = SimpleOAuth::Header.new("POST", url, params, oauth)

words = {}
captured = 0

trap("INT") do
  puts "\n\nCaptured #{captured} objects from the stream"
  puts "CTRL+C caught, later!"
  exit(0)
end

Yajl::HttpStream.post(url, params, {:symbolize_keys => true, :headers => {"Authorization" => oauth_header}}) do |hash|
  next if hash[:delete]

  begin
    Post.create!(:id => hash[:id], :user => hash[:user][:screen_name], :body => hash[:text], :created_at => hash[:created_at])
    putc "."
  rescue DataObjects::IntegrityError => e
    putc "X"
  end
  captured += 1
  puts if captured % 20 == 0
end
