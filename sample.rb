require "yajl/http_stream"
require "simple_oauth"

url = "http://stream.twitter.com/1/statuses/sample.json"

# Read OAuth config file and symbolize keys.
oauth = YAML.load_file("config/oauth.yml").inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
oauth_header = SimpleOAuth::Header.new("GET", url, {}, oauth)

Yajl::HttpStream.get(url, :headers => {"Authorization" => oauth_header}) do |tweet|
  putc "."
end
