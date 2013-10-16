require 'active_support/core_ext'
require 'webrick'
require 'rails_lite'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class MyController < ControllerBase
  def go
    #render_content("hello world!", "text/html")

    # after you have template rendering, uncomment:
    render :show

    # after you have sessions going, uncomment:
#    session["count"] ||= 0
#    session["count"] += 1
#    render :counting_show
  end
end

server.mount_proc '/' do |req, res|
  if req.path =~ /redir_to_(www\..+\..{2,4})(\z|[_\\\b\/+\-])/
    MyController.new(req, res, req.attributes).redirect_to($1)
  else
    MyController.new(req, res, req.attributes).go
  end
end

server.start
