# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'

enable :method_override

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = CSV.read('memos.csv')

  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  CSV.open('memos.csv', 'a') do |csv|
    csv << [create_next_id, escape_html(params[:title]), escape_html(params[:message])]
  end
  @memos = CSV.read('memos.csv')

  erb :index
end

get '/memos/:id' do
  CSV.foreach('memos.csv') do |record|
    @memo = record if record[0] == params[:id]
  end

  erb :show
end

get '/memos/:id/edit' do
  CSV.foreach('memos.csv') do |record|
    @memo = record if record[0] == params[:id]
  end

  erb :edit
end

patch '/memos' do
  @memos = CSV.read('memos.csv')
  @memos.each_with_index do |memo, i|
    @memos[i] = [params[:id], escape_html(params[:title]), escape_html(params[:message])] if memo[0] == params[:id]
  end
  CSV.open('memos.csv', 'w') do |csv|
    @memos.each do |memo|
      csv << memo
    end
  end

  erb :index
end

delete '/memos/:id' do
  @memos = CSV.read('memos.csv')
  @memos.reject! { |memo| memo[0] == params[:id] }
  CSV.open('memos.csv', 'w') do |csv|
    @memos.each do |memo|
      csv << memo
    end
  end

  erb :index
end

def create_next_id
  memos = CSV.read('memos.csv')
  return 1 if memos.empty?

  max_id = memos.map { |memo| memo[0].to_i }.max
  max_id + 1
end

def escape_html(text)
  Rack::Utils.escape_html(text)
end
