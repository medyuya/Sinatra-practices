# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'pg'
require 'connection_pool'

DB_POOL = ConnectionPool.new(size: 5, timeout: 5) do
  PG.connect(
    dbname: 'postgres',
    host: 'localhost',
    port: 5432,
    sslmode: 'disable'
  )
end

before do
  @conn = DB_POOL.with { |conn| conn }
end

enable :method_override

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = @conn.exec('SELECT * FROM memos')

  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  @conn.exec_params('INSERT INTO memos (title, memo) VALUES ($1, $2)', [params[:title], params[:message]])
  @memos = @conn.exec('SELECT * FROM memos')

  erb :index
end

get '/memos/:id' do
  @memo = @conn.exec('SELECT * FROM memos WHERE id = $1', [params[:id].to_i])

  erb :show
end

get '/memos/:id/edit' do
  @memo = @conn.exec('SELECT * FROM memos WHERE id = $1', [params[:id].to_i])

  erb :edit
end

patch '/memos/:id' do
  @conn.exec_params('UPDATE memos SET title = $1, memo = $2 WHERE id = $3', [params[:title], params[:message], params[:id].to_i])
  @memos = @conn.exec('SELECT * FROM memos')

  erb :index
end

delete '/memos/:id' do
  @conn.exec('DELETE FROM memos WHERE id = $1', [params[:id].to_i])
  @memos = @conn.exec('SELECT * FROM memos')

  erb :index
end
