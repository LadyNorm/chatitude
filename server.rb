require 'pg'
require 'sinatra'
require 'json'
require 'sinatra/reloader'
require 'securerandom'

require_relative 'lib/chatserver.rb'

set :bind, '0.0.0.0'

get '/' do
  send_file 'public/index.html'
end

post '/signup' do
  db = Chat::DB.create_db_connection
  username = params[:username]
  password = params[:password]
  new_user = Chat::DB.new_user(username, password, db)
  api_token = Chat::DB.generate_apitoken
  Chat::DB.save_api_key(api_token, new_user['id'], db)
  # localStorage.setItem('apiKey', api_key)
  # redirect to '/'
  return { apiToken: api_token }
end

post '/signin' do
  db = Chat::DB.create_db_connection
  username = params[:username]
  password = params[:password]
  user = Chat::DB.find_user_byname(username, db)
  api_token = Chat::DB.generate_apitoken
  Chat::DB.update_api_key(api_token, user['id'], db)
  return { apiToken: api_token }
end

get '/chats' do
  headers['Content-Type'] = 'application/json'
  db = Chat::DB.create_db_connection
  puts Chat::DB.all_chats(db).to_json
  Chat::DB.all_chats(db).to_json
end

post '/chats' do
  db = Chat::DB.create_db_connection
end