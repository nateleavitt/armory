require 'bundler'
Dir["./lib/*.rb"].each {|file| require file}

Bundler.require

class Armory < Sinatra::Application

  configure do
    enable :logging
    # register Sinatra::Flash
    # set :sessions, true
    # set :session_secret, 'DqIWXEx729NjQOVdaasvAhfTk2l1dURLBx8al38wMuAoByYktICTLrnoKTIqY'
    # set :inline_templates, true
    ETCD = Etcd.client(host: ENV['DOCKER_HOST'], port: 4001)
  end

  before do
    authenticate!
  end

  get '/' do
    'Hello World.. this is Armory'
  end

  get '/health' do
    content_type :json
    begin
      ETCD.get('/stats/self')
    rescue => e
      status 404
      body e.message
    end
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
    @config.add_key(request.body.read)
    @config.save
  end

  # get the key
  get '/:service/:env/:key' do
    content_type :json
    @config = Config.find(params[:service], params[:env])
    @config.get_key(params[:key]).to_json
  end

  # update the key
  put '/:service/:env/:key' do
    content_type :json
    @config = Config.find(params[:service], params[:env])
    @config.update_key(params[:key], request.body.read)
  end

  private

    def check_for_json
      pass unless request.accept? 'application/json'
    end

    def authenticate!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [ ENV['AUTH_USERNAME'], ENV['AUTH_PASSWORD'] ]
    end

end

