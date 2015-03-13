require 'bundler'
Dir["./lib/*.rb"].each {|file| require file}

Bundler.require

class Armory < Sinatra::Application

  configure do
    enable :logging
    # register Sinatra::Flash
    # set :sessions, true
    # set :session_secret, 'DqIWXEx729NjQOVdaasvAhfTk2l1dURLBx8al38wMuAoByYktICTLrnoKTIqY'
    # This is needed for testing, otherwise the default
    # error handler kicks in
    set :show_exceptions, false
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

  # creates a new service namespace
  # json should be in the following format
  # { "service":"goldfish" }
  post '/' do
    check_for_json
    @config = Config.new("new")
    @config.new_service(request.body.read)
    @config.create
  end

  # create a new service/environment
  # json should be in the following format
  # { "environment":"staging" }
  post '/:service', provides: :json do
    check_for_json
    @config = Config.find(params[:service])
    @config.new_env(request.body.read)
    @config.save
  end

  # get the app environment config
  # will return a hash of key => values
  get '/:service/:env' do
    @config = Config.find(params[:service], logger)
    @config.get_env(params[:env]).to_json
  end

  # create new key,val for config
  # json should be in the following format
  # { "api_key":"1234567" }
  post '/:service/:env', provides: :json do
    check_for_json
    @config = Config.find(params[:service])
    @config.new_key(params[:env], request.body.read)
    @config.save
  end

  # get the key
  # will respond back with json formatted like
  # { "api_key":"1234567" }
  get '/:service/:env/:key' do
    @config = Config.find(params[:service])
    @config.find_key(params[:env], params[:key]).to_json
  end

  # update the key
  # json should be in the following format
  # { "value":"1234567" }
  put '/:service/:env/:key', provides: :json do
    check_for_json
    @config = Config.find(params[:service])
    @config.update_key(params[:env], params[:key], request.body.read)
    @config.save
  end

  error do
    content_type :json
    status 404

    e = env['sinatra.error']
    {:result => 'error', :message => e.message}.to_json
  end

  private

    def check_for_json
      pass unless request.accept? 'application/json'
    end

    def authenticate!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      raise "Not authorized"
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [ ENV['AUTH_USERNAME'], ENV['AUTH_PASSWORD'] ]
    end

end
