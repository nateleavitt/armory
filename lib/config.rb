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
  ETCD = Etcd.client(host: ENV['DOCKER_HOST'], port: 4001)
  @@format_error = "Please format your json data correctly. See https://github.com/nateleavitt/armory for the proper format"

  def initialize(service)
    self.envs = {}
    self.service = service
    # attrs.each { |key, val| send("#{key}=", val[key]) } if !attrs.empty?
  end

  def self.find(service)
    config = self.new(service)
    config.envs = JSON.parse(ETCD.get("/armory/#{config.service}").value)
    return config
  end

  def create
    ETCD.set("/armory/#{@service}", value: @envs.to_json)
  end

  def save
    ETCD.update("/armory/#{@service}", value: @envs.to_json)
  end

  def new_service(json_service)
    json_service = JSON.parse(json_service)
    if json_service["service"]
      self.service = json_service["service"]
    else
      raise @@format_error
    end
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
    if @envs.has_key?(env)
      @envs[env]
    else
      raise "Environment does not exist!"
    end
  end

  def new_key(env, json_new_key)
    begin
      new_key = JSON.parse(json_new_key)
      self.envs[env] = self.envs[env].to_h.merge(new_key)
    rescue
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

end
