require 'bundler'
require 'uri'
Bundler.require

class Figr < Sinatra::Application

  configure do
    register Sinatra::Flash
    set :sessions, true
    set :session_secret, 'DqIWXEx729NjQOVdaasvAhfTk2l1dURLBx8al38wMuAoByYktICTLrnoKTIqY'
    set :inline_templates, true
    uri = URI.parse("")
    ETCD = Etcd.client
  end

  # use Rack::Auth::Basic, "Restricted Area" do |username, password|
  #   username == ENV['AUTH_USERNAME'] and password == ENV['AUTH_PASSWORD']
  # end

  before do
    authenticate!
  end

  get '/' do
    if flash[:notice]
      flash[:notice]
    else
      puts 'Hello World.. this is Figr'
    end
  end

  # get the app environment config
  get '/:app/:env' do
    ETCD.get("#{params[:app]}/#{params[:env]}")
  end

  # get the key
  get '/:app/:env/:key' do
    ETCD.get("#{params[:app]}/#{params[:env]}/#{params[:key]}")
  end

  # update the key
  put '/:app/:env/:key' do
    check_for_json
    body = JSON.parse request.body.read
    ETCD.set("#{params[:app]}/#{params[:env]}/#{params[:key]}", body["val"])
  end

  # create new keys,vals for config
  post '/:app/:env', :provides => :json do
    check_for_json
    body = JSON.parse request.body.read
    ETCD.set("#{params[:app]}/#{params[:env]}", body)
  end

  private
    def check_for_json
      pass unless request.accept? 'application/json'
    end

    def auth_hash
      # request.env['omniauth.auth']
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
