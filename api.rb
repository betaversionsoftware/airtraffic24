require 'sinatra'
require 'mongo'
require 'json'

set :bind, '0.0.0.0'

configure do
  db = Mongo::Client.new('mongodb://mongo:27017/atr24')  
  set(:mongo_db, db)
  set(:ignore_colls, {'_id': 0, 'ground': 0, 'position': 0})
  set(:include_colls, {'_id': 0, 'icao': 1, 'callsign': 1})
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

get '/current' do
  settings.mongo_db[:current].find.projection(settings.ignore_colls).to_a.to_json
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,POST,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
  200
end
