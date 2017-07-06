require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/1' }
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/1' }
end

class Message
  include Sidekiq::Worker

  def perform(msg)
    valid_msg = %i(callsign altitude speed lat lng track squawk)
	  
    log = msg.split(',')
    msg_n = log[1].to_i

    icao = log[4]
    plane = {}

    plane[:last_msg] = DateTime.now

    case msg_n
    when 1
      plane[:callsign] = log[10].strip unless log[10].empty?
    when 2
      plane[:altitude] = log[11].to_i unless log[11].empty?
      plane[:speed] = log[12].to_i unless log[12].empty?
      plane[:track] = log[13].to_i unless log[13].empty?
      plane[:lat] = log[14].to_f unless log[14].empty?
      plane[:lng] = log[15].to_f unless log[15].empty?
    when 3
      plane[:altitude] = log[11].to_i unless log[11].empty?
      plane[:lat] = log[14].to_f unless log[14].empty?
      plane[:lng] = log[15].to_f unless log[15].empty?
    when 4
      plane[:speed] = log[12].to_i unless log[12].empty?
      plane[:track] = log[13].to_i  unless log[13].empty?
    when 5
      plane[:altitude] = log[11].to_i unless log[11].empty?
    when 6
      plane[:altitude] = log[11].to_i unless log[11].empty?
      plane[:squawk] = log[17].to_i unless log[17].empty?
    when 7
      plane[:altitude] = log[11].to_i unless log[11].empty?
    end

    valid = valid_msg.all? { |v| plane.key?(v) }
  end
end
