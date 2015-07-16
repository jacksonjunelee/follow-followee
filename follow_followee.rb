require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'better_errors'
require 'httparty'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

# ActiveRecord::Base.establish_connection({
# 	adapter: 'postgresql',
# 	database: 'tunr_db',
# 	host: 'localhost'
# })
#
# after { ActiveRecord::Base.connection.close }

get '/' do
    erb :'home/home'
end

get '/search' do
  response = HTTParty.get("https://api.instagram.com/v1/users/search?q=#{params[:search]}&client_id=f2a780c71c044f519ba176c8b60d0ce8")
  @data = response["data"]
  erb :'results'
end

get '/follow_search/:id' do
  @flash = "Followers Of #{params[:username]}" if params[:username]
  response = HTTParty.get("https://api.instagram.com/v1/users/#{params[:id]}/follows?client_id=f2a780c71c044f519ba176c8b60d0ce8")
  if response["meta"]["error_type"]
    erb :'error_404'
  else
    @data = response["data"]
    erb :'results'
  end
end

get '/follow_by_search/:id' do
  @flash = "Users Followed By #{params[:username]}" if params[:username]
  response = HTTParty.get("https://api.instagram.com/v1/users/#{params[:id]}/followed-by?client_id=f2a780c71c044f519ba176c8b60d0ce8")
  if response["meta"]["error_type"]
    erb :'error_404'
  else
    @data = response["data"]
    erb :'results'
  end
end
