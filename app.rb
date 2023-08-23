# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'pg'

def db_connection
  conn = PG.connect(
    dbname: 'postgres',
    host: 'localhost',
    port: 5432,
    sslmode: 'disable'
  )

  yield(conn) if block_given?

  conn.close
end

enable :method_override

get '/' do
  redirect '/memos'
end

get '/memos' do
  db_connection do |conn|
    @memos = conn.exec('SELECT * FROM users')
  end

  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  db_connection do |conn|
    conn.exec_params('INSERT INTO users (title, memo) VALUES ($1, $2)', [params[:title], params[:message]])
    @memos = conn.exec('SELECT * FROM users')
  end

  erb :index
end

get '/memos/:id' do
  db_connection do |conn|
    @memo = conn.exec('SELECT * FROM users WHERE id = $1', [params[:id].to_i])
  end

  erb :show
end

get '/memos/:id/edit' do
  db_connection do |conn|
    @memo = conn.exec('SELECT * FROM users WHERE id = $1', [params[:id].to_i])
  end

  erb :edit
end

patch '/memos/:id' do
  db_connection do |conn|
    conn.exec_params('UPDATE users SET title = $1, memo = $2 WHERE id = $3', [params[:title], params[:message], params[:id].to_i])
    @memos = conn.exec('SELECT * FROM users')
  end

  erb :index
end

delete '/memos/:id' do
  db_connection do |conn|
    conn.exec('DELETE FROM users WHERE id = $1', [params[:id].to_i])
    @memos = conn.exec('SELECT * FROM users')
  end

  erb :index
end
