require 'uri'

class Params
  def initialize(req, route_params={})
    @params = {}
    ####
    p @params
    ####
    unless req.query_string.nil?
      @params.merge!(parse_www_encoded_form(req.query_string))
    end
    unless req.body.nil?
      @params.merge!(parse_request_body(req.body))
    end
    @params
  end

  def [](key)
  end

  def to_s
    @params.to_s
  end

  private
  
  def parse_www_encoded_form(www_encoded_form)
    ary = URI.decode_www_form(www_encoded_form)
    hash = {}
    ary.each do |element|
      hash[element.first] = element.last
    end
    hash
  end
  
  def parse_request_body(req_body)
    ary = URI.decode_www_form(req_body)
    top_hash = {}
    ary.each do |element|
      keys = parse_key(element.first)
      nested_hash_insert(keys, element.last, top_hash)
    end
    top_hash
  end
  
  def nested_hash_insert(keys, value, hash)
    if keys.size == 1
      hash[keys.first] = value
    else
      top_level = keys.shift
      hash[top_level] ||= {}
      nested_hash_insert(keys, value, hash[top_level])
    end
  end

  def parse_key(key)
    # key_array = []
    # until (match = /(\w+)(?:\]\[|\[|\]){0,2}(.*)\z/.match(key)) == nil
    #   key_array << $1
    #   key = $2
    # end
    key_array = key.split(/\]\[|\[|\]/)
  end
end
