# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'pg'

enable :method_override

get '/' do
  redirect '/memos'
end

get '/memos' do
  conn = PG.connect(
    dbname: 'postgres',
    host: 'localhost',
    port: 5432,
    sslmode: 'disable'
  )

  @memos = conn.exec('SELECT * FROM users')
  conn.close

  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  conn = PG.connect(
    dbname: 'postgres',
    host: 'localhost',
    port: 5432,
    sslmode: 'disable'
  )

  conn.exec_params('INSERT INTO users (title, memo) VALUES ($1, $2)', [params[:title], params[:message]])
  @memos = conn.exec('SELECT * FROM users')
  conn.close

  erb :index
end

get '/memos/:id' do
  conn = PG.connect(
    dbname: 'postgres',
    host: 'localhost',
    port: 5432,
    sslmode: 'disable'
  )

  @memo = conn.exec('SELECT * FROM users WHERE id = $1', [params[:id].to_i])
  conn.close

  erb :show
end

get '/memos/:id/edit' do
  conn = PG.connect(
    dbname: 'postgres',
    host: 'localhost',
    port: 5432,
    sslmode: 'disable'
  )

  @memo = conn.exec('SELECT * FROM users WHERE id = $1', [params[:id].to_i])
  conn.close

  erb :edit
end

patch '/memos' do
  conn = PG.connect(
    dbname: 'postgres',
    host: 'localhost',
    port: 5432,
    sslmode: 'disable'
  )

  conn.exec_params('UPDATE users SET title = $1, memo = $2 WHERE id = $3', [params[:title], params[:message], params[:id].to_i])
  @memos = conn.exec('SELECT * FROM users')
  conn.close

  erb :index
end

delete '/memos/:id' do
  conn = PG.connect(
    dbname: 'postgres',
    host: 'localhost',
    port: 5432,
    sslmode: 'disable'
  )

  conn.exec('DELETE FROM users WHERE id = $1', [params[:id].to_i])
  @memos = conn.exec('SELECT * FROM users')
  conn.close

  erb :index
end

def create_next_id
  memos = CSV.read('memos.csv')
  return 1 if memos.empty?

  max_id = memos.map { |memo| memo[0].to_i }.max
  max_id + 1
end

def cancel_new_line(text)
  text.gsub(/\r\n/, "\n")
end
