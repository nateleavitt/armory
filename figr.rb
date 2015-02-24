require 'bundler'
Bundler.require

class Figr < Sinatra::Application

  configure do
    enable :logging
    # register Sinatra::Flash
    # set :sessions, true
    # set :session_secret, 'DqIWXEx729NjQOVdaasvAhfTk2l1dURLBx8al38wMuAoByYktICTLrnoKTIqY'
    # set :inline_templates, true
    ETCD = Etcd.client
  end

  before do
    authenticate!
  end

  get '/' do
    'Hello World.. this is Figr'
  end

  # get the app environment config
  get '/:app/:env' do
    begin 
      return ETCD.get("/#{params[:app]}/#{params[:env]}")
    rescue => e
       status 404
       body e.message
    end
  end

  # get the key
  get '/:app/:env/:key' do
    begin 
      values = ETCD.get("/#{params[:app]}/#{params[:env]}").value
      val = JSON.parse(values)[params[:key]]
      if val.nil?
        raise "Key not found" 
      else
        return val
      end
    rescue => e
       status 404
       body e.message
    end
  end

  # update the key
  put '/:app/:env/:key' do
    check_for_json
    ETCD.set("/#{params[:app]}/#{params[:env]}", value: request.body.read)
  end

  # create new keys,vals for config
  post '/:app/:env', :provides => :json do
    check_for_json
    ETCD.set("/#{params[:app]}/#{params[:env]}", value: request.body.read)
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
