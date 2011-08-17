require "em-http"
require "em-http/middleware/oauth"
require "simple_oauth"

EM.run do
  conn = EventMachine::HttpRequest.new("http://stream.twitter.com/1/statuses/sample.json")

  # sign the request with OAuth credentials
  oauth_opts = YAML.load_file("config/oauth.yml").inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  conn.use EventMachine::Middleware::OAuth, oauth_opts

  http = conn.get
  http.stream do |chunk|
    putc "."
  end
end
