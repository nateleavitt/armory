require 'rest_client'

class Config
  # a config for the :service/:environment
  # the config will be stored in ETCD as
  # /armory/services/:service/envs/:env
  # the json object value will be formatted as
  # {
  #   "api_key":"123qwe123qwe",
  #   "aws_location":"aws.amazon.com"
  # }

  attr_accessor :path, :service, :env
  ETCD = RestClient::Resource.new("#{ENV['DOCKER_HOST']}:4001/v2/keys/armory",
                                 :content_type => "application/json")
  @@format_error = "Please format your json data correctly. See https://github.com/nateleavitt/armory for the proper format"

  def initialize(attrs={})
    path = ""
    if attrs.has_key?(:service)
      self.service = attrs[:service]
      path += "/#{attrs[:service]}" 
    end
    if attrs.has_key?(:env)
      self.env = attrs[:env]
      path += "/#{attrs[:env]}" 
    end
    self.path = path
  end

  def self.find(attrs={})
    config = self.new(attrs)
    config.env = config.parse_json(ETCD[config.path].get)
    return config
  end

  def new_namespace(json)
    json = JSON.parse(json)
    if !json.empty? && json.is_a?(Hash) && json["name"]
      ETCD[@path + "/#{json["name"]}"].put "dir=true"
    else
      raise @@format_error
    end
  end

  def new_keys(json)
    new_config = JSON.parse(json)
    added = []
    new_config.each do |k,v|
      if ETCD[@path + "/#{k}"].put "value=#{v}"
        added << k
      end
    end
    return { "keys added" => added.to_s }.to_json
  end

  def update_key(new_key, json)
    json = JSON.parse(json)
    if !json.empty? && json.is_a?(Hash) && json["value"]
      config = {new_key => json.first.value}
      ETCD[@path + "#{config.first.key}"].set config.first.value
    else
      raise @@format_error
    end
  end

  def find_key(env, key)
    env = get_env(env)
    if env.has_key?(key)
      return env[key]
    else
      raise 'Key not found!'
    end
  end

  def update_key(env, key, value)
    if value["value"]
      env = get_env(env)
      if @envs[env].has_key?(key)
        self.envs[env][key] = JSON.parse(value["value"])
      else
        raise 'Key not found'
      end
    else
      raise @@format_error
    end
  end

  def parse_json(etcd_json)
    env = JSON.parse(etcd_json)
    env_map = {}
    env["node"]["nodes"].each do |k|
      key = k["key"]
      key.slice!("/armory#{@path}/")
      env_map[key] = k["value"]
    end
    return env_map
  end

end
