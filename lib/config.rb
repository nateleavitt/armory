require 'etcd'

class Config
  # a config for the :service/:environment
  # the config will be stored in ETCD as
  # /armory/:service_name/:environment
  # the json object value will be formatted as
  # {
  #   "keys":[
  #     {
  #       "name":"api_key",
  #       "value":"123qwe123qwe"
  #     },
  #     {
  #       "name":"aws_location",
  #       "value":"aws.amazon.com"
  #     }
  #   ]
  # }
  #

  attr_accessor :keys, :service, :env
  ETCD = Etcd.client(host: ENV['DOCKER_HOST'], port: 4001)
  @@format_error = "Please format your json data correctly. See https://github.com/nateleavitt/armory for the proper format"

  def initialize(attrs={})
    self.keys = {}
    attrs.each { |key, val| send("#{key}=", val) } if !attrs.empty?
  end

  def self.find(service, env)
    config = self.new(service: service, env: env)
    config.keys = ETCD.get("/armory/#{config.service}/#{config.env}").value[:keys]
    return config
  end

  def save
    ETCD.set("/armory/#{@service}/#{@env}", value: {keys: @keys})
  end

  def create_env(json_obj)
    json_env = JSON.parse(json_obj).to_hash
    if json_env["name"] == 'env' && !json_env["value"].empty?
      self.env = json_env[:value]
    else
      raise @@format_error
    end
  end

  def create_keys(json_keys)
    new_keys = validate_format_of(json_keys)
    new_keys.each do |key|
      self.keys[key[:name]] = key[:value]
    end
  end

  def find_key(key)
    if @keys.has_key?(key)
      raise 'Key not found'
    else
      { name: key, value: @keys[key] }
    end
  end

  def update_key(key, value)
    if @keys.has_key?(key)
      raise 'Key not found'
    else
      @keys[key] = JSON.parse(value)
      self.save
    end
  end

  private

    def validate_format_of(json_keys)
      new_keys = JSON.parse(json_keys).to_hash
      if new_keys.has_key?("keys")
        new_keys["keys"].each do |key|
          if !key.has_key?("name") && !key.has_key?("value")
            raise @@format_error
          end
        end
      else
        raise @@format_error
      end
    end

end
