require 'sidekiq'
require 'mongo'
require 'date'
require 'json'
require 'active_support/all'

mongo_client = Mongo::Client.new('mongodb://mongo:27017/atr24')
traffic = mongo_client[:traffic]

result = traffic.find({last_seen: { '$gte': 12.hours.ago }}).distinct('callsign')

puts result.count
