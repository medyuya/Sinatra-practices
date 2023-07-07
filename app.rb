require 'sinatra'
require 'sinatra/reloader'

get '/' do
  'hello'
  'how  you?'
end

get '/path/to' do
  "this is [/path/to]"
end

get '/hello/*' do |name|
  "hello #{name}. how are you?"
end

get '/erb_template_page' do
  @ddd = 'ggg'
  erb :erb_template_page
end