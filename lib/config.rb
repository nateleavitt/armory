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

  attr_accessor :path, :service, :env, :env_map
  docker_host = ENV['DOCKER_HOST'].dup
  docker_host.slice!(":5000")
  ETCD = RestClient::Resource.new("#{docker_host}:4001/v2/keys/armory",
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
    config.env_map = config.parse_json(ETCD[config.path].get)
    return config
  end

  # json should be sent formatted as the following
  # { "name":"name_of_service_or_env" }
  def new_namespace(json)
    json = JSON.parse(json)
    if !json.empty? && json.is_a?(Hash) && json["value"]
      ETCD[@path + "/#{json["value"]}"].put "dir=true"
      return { :result => json["value"] }.to_json
    else
      raise @@format_error
    end
  end

  # json sent in can be a hash of 
  # { "key1":"value1", "key2":"value2" }
  def new_keys(json)
    new_config = JSON.parse(json)
    new_config.each do |k,v|
      unless self.env_map.has_key?(k)
        ETCD[@path + "/#{k}"].put "value=#{v}"
      else
        raise "#{k} is a key that already exists"
      end
    end
    return { :result => new_config}.to_json
  end

  # key is a string of the key you want to retrieve
  def find_key(key)
    if env_map.has_key?(key)
      return { key => env_map[key]}
    else
      raise 'Key not found!'
    end
  end

  # json received should be in the following format
  # { "value":"value_of_key" }
  def update_key(key, json)
    json = JSON.parse(json)
    if env_map.has_key?(key)
      if !json.empty? && json.is_a?(Hash) && json["value"]
          ETCD[@path + "/#{key}"].put "value=#{json["value"]}"
          return { :result => json["value"] }.to_json
      else
        raise @@format_error
      end
    else
      raise 'Key not found!'
    end
  end

  def parse_json(etcd_json)
    env = JSON.parse(etcd_json)
    env_map = {}
    if env["node"]["nodes"]
      env["node"]["nodes"].each do |k|
        key = k["key"]
        key.slice!("/armory#{@path}/")
        env_map[key] = k["value"]
      end
    end
    env_map
  end

end
