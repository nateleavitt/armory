class Config
  # a config for the :service/:environment
  # the config will be stored in ETCD as
  # /armory/:service_name/:environment
  # the json object value will be formatted as
  # {
  #   "name":"production",
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
  #
  attr_accessor :keys, :service, :env

  def find(service, env)
    self.service = service
    self.env = env
    self.keys = ETCD.get("/armory/#{@service}/#{@env}").value[:keys]
  end

  def save
    ETCD.set("/armory/#{@service}/#{@env}", value: {keys: @keys})
  end

  def add_key(key_obj)
    key = JSON.parse(key_obj)
    self.keys[key[:name]] = key[:value]
  end

  def get_key(key)
    begin
      if @keys.has_key?(key)
        raise 'Key not found'
      else
        { value: @keys[key] }
      end
    rescue => e
       status 404
       body e.message
    end
  end

  def update_key(key, value)
    begin
      if self.keys.has_key?([params[:key]])
        raise 'Key not found'
      else
        self.keys[params[:key]] = JSON.parse(value)
        self.save
      end
    rescue => e
       status 404
       body e.message
    end
  end

end
