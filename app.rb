require 'rubygems'
require 'sinatra'

get '/' do
  erb :index
end

post '/' do
  @card = params[:card]
  erb :result
end