class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    return !!(
      req.request_method.downcase.to_sym == http_method &&
      pattern.match(req.path)
    )
  end

  def run(req, res)
    m = pattern.match(req.path)
    route_params = {}
    m.names.each_with_index do |name, index|
      route_params[name.to_sym] = m.captures[index]
    end
    controller_class.new(req, res, route_params).invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    routes.find do |route|
      route.matches?(req)
    end
  end

  def run(req, res)
    matched_route = match(req)
    matched_route.nil? ? res.status = 404 : matched_route.run(req, res)
  end
end
