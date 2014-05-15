require 'sinatra'
require 'omniauth'
require 'redis'
require 'json'

use OmniAuth::Builder do
  provider :github, '895d6ceada4c2c78df33', '52b990226ddd5662966b7378a7f3b7e348f184f9'
end

configure do
  REDIS = Redis.new
end

get '/' do
  'Hello World.. this is Elvis'
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
