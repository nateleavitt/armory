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
  end

  get '/' do
    'Hello World.. this is Armory'
  end

  get '/health' do
    content_type :json
    ETCD.get('/stats/self')
  end

  # create a new service/environment
  post '/:service' do
    @config = Config.new(service: params[:service])
    @config.create_env(request.body.read)
    logger.info "**** here is config #{@config.inspect}"
    # @config.save
  end

  # get the app environment config
  get '/:service/:env' do
    content_type :json
    @config = Config.find(params[:service], params[:env])
    @config.to_json
  end

  # create new key,val for config
  post '/:service/:env', :provides => :json do
    @config = Config.find(params[:service], params[:env])
    @config.create_keys(request.body.read)
    @config.save
  end

  # get the key
  get '/:service/:env/:key' do
    content_type :json
    @config = Config.find(params[:service], params[:env])
    @config.find_key(params[:key]).to_json
  end

  # update the key
  put '/:service/:env/:key', :provides => :json do
    content_type :json
    @config = Config.find(params[:service], params[:env])
    @config.update_key(params[:key], request.body.read)
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
