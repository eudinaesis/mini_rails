require 'json'
require 'webrick'

class Session
  def initialize(req)
    cookies = req.cookies
    req_cookie = cookies.find do |cookie|
      cookie.name == "_rails_lite_app"
    end
    req_cookie.nil? ? @cookie = { :token => SecureRandom.urlsafe_base64 } : @cookie = JSON.parse(req_cookie.value)
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    res.cookies.delete_if { |c| c.name == "_rails_lite_app" }
    res.cookies << WEBrick::Cookie.new("_rails_lite_app", @cookie.to_json)
  end
end
