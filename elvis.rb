require 'sinatra'
require 'redis'
require 'json'

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
update '/:app/:env/:key' do
  check_for_json
  body JSON.parse request.body.read
  app = "#{params[:app]}:#{params[:env]}"
  REDIS.hset(app, params[:key], body[app])
end

# create new keys,vals for config
post '/:app/:env', :provides => :json do
  check_for_json
  body = JSON.parse request.body.read
  app = "#{params[:app]}:#{params[:env]}"
  REDIS.mapped_hmset(app, body[app])
end

private
  def check_for_json
    pass unless request.accept? 'application/json'
  end
