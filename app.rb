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
  CSV.open("memos.csv", "a") do |csv|
    csv << [CSV.read("memos.csv").count + 1, params[:title], params[:message]]
  end
  @memos = CSV.read("memos.csv")
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