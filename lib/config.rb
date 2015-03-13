require 'etcd'

class Config
  # a config for the :service/:environment
  # the config will be stored in ETCD as
  # /armory/:service_name/:environment
  # the json object value will be formatted as
  # {
  #  "staging": {
  #    "api_key":"123qwe123qwe",
  #    "aws_location":"aws.amazon.com"
  #  },
  #  "production": {
  #    "api_key":"123qwe123qwe",
  #    "aws_location":"aws.amazon.com"
  #  }
  # }

  attr_accessor :service, :envs
  ETCD = Etcd.client(host: ENV['DOCKER_HOST'], port: ENV['ETCD_PORT'])
  @@format_error = "Please format your json data correctly. See https://github.com/nateleavitt/armory for the proper format"

  def initialize(attrs={})
    self.envs = {}
    attrs.each { |key, val| send("#{key}=", val) } if !attrs.empty?
  end

  def self.find(service)
    config = self.new(service: service)
    config.envs = JSON.parse(ETCD.get("/armory/#{service}").value)
    return config
  end

  def create
    ETCD.set("/armory/#{@service.to_sym}", value: @envs.to_json)
  end

  def save
    ETCD.update("/armory/#{@service.to_sym}", value: @envs.to_json)
  end

  def new_service(json_service)
    self.service = JSON.parse(json_service)
    raise @@format_error unless @service.has_key?(:service)
  end

  def new_env(json_env)
    begin
      json_env = JSON.parse(json_env)["environment"]
      self.envs[json_env] = {}
    rescue
      raise @@format_error
    end
  end

  def get_env(env)
    if @envs.has_key?(env.to_sym)
      @envs[env.to_sym]
    else
      raise "Environment does not exist!"
    end
  end

  def new_key(env, json_new_key)
    begin
      new_key = JSON.parse(json_new_key)
      self.envs[env.to_sym] = @envs[env.to_sym].to_h.merge(new_key)
    rescue
      raise @@format_error
    end
  end

  def find_key(env, key)
    env = get_env(env)
    if env.has_key?(key.to_sym)
      return env[key.to_sym]
    else
      raise 'Key not found!'
    end
  end

  def update_key(env, key, value)
    if value["value"]
      env = get_env(env)
      if @envs[env].has_key?(key.to_sym)
        self.envs[env][key.to_sym] = JSON.parse(value["value"])
      else
        raise 'Key not found'
      end
    else
      raise @@format_error
    end
  end

end
