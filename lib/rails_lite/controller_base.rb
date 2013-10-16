require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params={})
    @req = req
    @res = res
    @params = Params.new(req)
    @already_built_response = false
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
  end

  def redirect_to(url)
    @res.status = 302
    @res["Location"] = "http://#{url}"
    # @res.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect, "http://#{url}")
    session.store_session(@res)
    @already_built_response = true
  end

  def render_content(content, type)
    @res.content_type = type
    @res.body = content
    session.store_session(@res)
    @already_built_response = true
  end

  def render(template_name)
    template_file_path = "views/#{self.class.name.underscore}/#{template_name}.html.erb"
    template = ERB.new(File.read(template_file_path))
    template_result = template.result(binding)
    render_content(template_result, "html")
  end

  def invoke_action(name)
  end
end
