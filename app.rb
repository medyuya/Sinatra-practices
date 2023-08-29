# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'pg'

enable :method_override

class DatabaseConnector
  @connection = nil

  def self.connection
    @connection ||= PG.connect(
      dbname: 'postgres',
      host: 'localhost',
      port: 5432,
      sslmode: 'disable'
    )
  end
end

helpers do
  def db_connection
    DatabaseConnector.connection
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = db_connection.exec('SELECT * FROM memos ORDER BY id')

  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  redirect '/memos' if params[:title].strip.empty?
  db_connection.exec_params('INSERT INTO memos (title, memo) VALUES ($1, $2)', [params[:title], params[:memo]])

  redirect '/memos'
end

get '/memos/:id' do
  @memo = db_connection.exec('SELECT * FROM memos WHERE id = $1', [params[:id].to_i]).first

  erb :show
end

get '/memos/:id/edit' do
  @memo = db_connection.exec('SELECT * FROM memos WHERE id = $1', [params[:id].to_i]).first

  erb :edit
end

patch '/memos/:id' do
  redirect '/memos' if params[:title].strip.empty?
  db_connection.exec_params('UPDATE memos SET title = $1, memo = $2 WHERE id = $3', [params[:title], params[:memo], params[:id].to_i])

  redirect '/memos'
end

delete '/memos/:id' do
  db_connection.exec('DELETE FROM memos WHERE id = $1', [params[:id].to_i])

  redirect '/memos'
end
