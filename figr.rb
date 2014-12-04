require 'sinatra'
require 'omniauth'
require 'omniauth-github'
require 'redis'
require 'json'
require 'sinatra/flash'

class SinatraApp < Sinatra::Base

  configure do
    register Sinatra::Flash
    set :sessions, true
    set :session_secret, 'DqIWXEx729NjQOVdaasvAhfTk2l1dURLBx8al38wMuAoByYktICTLrnoKTIqY'
    set :inline_templates, true
    uri = URI.parse(ENV["REDISCLOUD_URL"])
    REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end

  use OmniAuth::Builder do
    provider :github, ENV["GITHUB_CLIENT"], ENV["GITHUB_SECRET"], scope: "user"
  end

  # Support both GET and POST for callbacks
  %w(get post).each do |method|
    send(method, "/auth/:provider/callback") do
      env['omniauth.auth'] # => OmniAuth::AuthHash
    end
  end

  get '/' do
    if flash[:notice]
      flash[:notice]
    else
      'Hello World.. this is Figr'
    end
  end

  get '/auth/failure' do
    flash[:notice] = params[:message] # if using sinatra-flash or rack-flash
    redirect '/'
  end

  get '/auth/:provider/deauthorized' do
    erb "#{params[:provider]} has deauthorized this app."
  end

  get '/protected' do
    throw(:halt, [401, "Not authorized\n"]) unless session[:authenticated]
    erb "<pre>#{request.env['omniauth.auth'].to_json}</pre><hr>
         <a href='/logout'>Logout</a>"
  end

  get '/logout' do
    session[:authenticated] = false
    redirect '/'
  end

  # get the app environment config
  get '/:app/:env' do
    REDIS.hgetall("#{params[:app]}:#{params[:env]}").to_json
  end

  # get the key
  get '/:app/:env/:key' do
    REDIS.hget("#{params[:app]}:#{params[:env]}", params[:key]).to_json
  end

  # update the key
  put '/:app/:env/:key' do
    check_for_json
    body = JSON.parse request.body.read
    app = "#{params[:app]}:#{params[:env]}"
    REDIS.hset(app, params[:key], body["val"])
  end

  # create new keys,vals for config
  post '/:app/:env', :provides => :json do
    check_for_json
    body = JSON.parse request.body.read
    app = "#{params[:app]}:#{params[:env]}"
    REDIS.mapped_hmset(app, body)
  end

  private
    def check_for_json
      pass unless request.accept? 'application/json'
    end

    def auth_hash
      request.env['omniauth.auth']
    end

end

SinatraApp.run! if __FILE__ == $0
