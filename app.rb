require 'sinatra'
require 'sinatra/reloader'
require "csv"

enable :method_override

get '/' do
  erb :top
end

get '/memos/new' do
  erb :new
end

post '/memos/confirm' do
  erb :top
end

get '/memos/:id' do
  erb :show
end

delete '/memos/:id' do
  erb :top
end