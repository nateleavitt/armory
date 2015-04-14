Dir["./app/*.rb"].each {|file| require file}

class Armory < Sinatra::Application
  include Authorize

  configure do
    enable :logging
    # register Sinatra::Flash
    # set :sessions, true
    # set :session_secret, 'DqIWXEx729NjQOVdaasvAhfTk2l1dURLBx8al38wMuAoByYktICTLrnoKTIqY'
    # This is needed for testing, otherwise the default
    # error handler kicks in
    set :show_exceptions, false
    set :server, :puma
  end

  before do
    authenticate!
    content_type :json
  end

  get '/' do
    'Hello World.. this is Armory'
  end

  get '/health' do
    ETCD.get('/stats/self')
  end

  # get an array of all services setup in armory
  # { "services":["goldfish","customerhub"] }
  get '/services', provides: :json do
    @config = Config.find
    { :result => @config.env_map.keys}.to_json
  end

  # creates a new service namespace
  # json should be in the following format
  # { "name":"goldfish" }
  post '/services' do
    check_for_json
    @config = Config.new
    @config.new_namespace(request.body.read)
  end


  # get an array of all envs setup for the
  # given service
  # { "envs":["testing","staging"] }
  get '/services/:service/envs', provides: :json do
    @config = Config.find(service: params[:service])
    { :result => @config.env_map.keys}.to_json
  end

  # create a new service/environment
  # json should be in the following format
  # { "name":"staging" }
  post '/services/:service/envs', provides: :json do
    check_for_json
    @config = Config.find(service: params[:service])
    @config.new_namespace(request.body.read)
  end

  # get the config for a specific env
  # will return a map of key:value
  get '/services/:service/envs/:env/config', provides: :json do
    @config = Config.find(service: params[:service], env: params[:env])
    { :result => @config.env_map}.to_json
  end

  # create new key,val for config
  # json should be in the following format
  # { "key1":"value1", "key2":"value2" }
  post '/services/:service/envs/:env/config', provides: :json do
    check_for_json
    @config = Config.find(service: params[:service], env: params[:env])
    @config.new_keys(request.body.read)
  end

  # get the key
  # will respond back with json formatted like
  # { "api_key":"1234567" }
  get '/services/:service/envs/:env/config/:key', provides: :json do
    @config = Config.find(service: params[:service], env: params[:env])
    { :result => @config.find_key(params[:key])}.to_json
  end

  # update the key
  # json should be in the following format
  # { "value":"1234567" }
  put '/services/:service/envs/:env/config/:key', provides: :json do
    check_for_json
    @config = Config.find(service: params[:service], env: params[:env])
    @config.update_key(params[:key], request.body.read)
  end

  error do
    content_type :json
    # status 404

    e = env['sinatra.error']
    { :result => 'error', :message => e.message }.to_json
  end

  not_found do
    { :result => 'error', :message => "404 Not found!" }.to_json
  end

  private

    def check_for_json
      pass unless request.accept? 'application/json'
    end

end
