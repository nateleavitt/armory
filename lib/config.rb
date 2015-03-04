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

  def self.find(service, env)
    self.service = service
    self.env = env
    self.keys = ETCD.get("/armory/#{@service}/#{@env}").value[:keys]
  end

  def save
    ETCD.set("/armory/#{@service}/#{@env}", value: {keys: @keys})
  end

  def add_key(json_keys)
    new_keys = validate_format_of(json_keys)
    new_keys.each do |key|
      self.keys[key[:name]] = key[:value]
    end
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

  private

    def validate_format_of(json_keys)
      error = "Please format your json data correctly. See https://github.com/nateleavitt/armory for the proper format"

      begin
        new_keys = JSON.parse(json_keys)
        if new_keys.has_key?(:keys)
          new_keys[:keys].to_hash.each do |key|
            if !key.has_key?(:name) && !key.has_key?(:value)
              raise error
            end
          end
        else
          raise error
        end
      rescue => e
        status 404
        body.e.message
      end
    end

end
