require 'json'
require 'webrick'

class Session
  def initialize(req)
    cookies = req.cookies
    p "REQUEST COOKIES HERE:"
    p cookies
    req_cookie = cookies.find do |cookie|
      cookie.name == "_rails_lite_app"
    end
    req_cookie.nil? ? @cookie = { :token => SecureRandom.urlsafe_base64 } : @cookie = JSON.parse(req_cookie.value)
    p "INTERNAL COOKIE OBJECT HERE"
    p @cookie
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    p "AND NOW RESPONSE COOKIES"
    p res.cookies
    res.cookies.delete_if { |c| c.name == "_rails_lite_app" }
    res.cookies << WEBrick::Cookie.new("_rails_lite_app", @cookie.to_json)
  end
end
