require 'sinatra'
require 'sinatra/reloader'
require "csv"

enable :method_override

get '/' do
  @memos = CSV.read("memos.csv")
  erb :top
end

get '/memos/new' do
  erb :new
end

post '/memos/confirm' do
  erb :top
end

get '/memos/:id' do
  CSV.foreach("memos.csv") do |col|
    @memo = col if col[0] == params[:id]
  end
  erb :show
end

delete '/memos/:id' do
  erb :top
end