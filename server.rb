require 'pg'
require 'sinatra'
require 'json'

require_relative 'lib/chatitude.rb'

set :bind, '0.0.0.0'

get '/' do
  send_file 'public/index.html'
end

post '/signup' do
  db = Chat::DB.create_db_connection
  username = params[:username]
  password = params[:password]
  new_user = Chat::DB.new_user(username, password, db)
  api_token = Chat::DB.find_api_key(new_user['id'], db)
  # localStorage.setItem('apiKey', api_key)
  # redirect to '/'
  return { apiToken: api_token }
end
