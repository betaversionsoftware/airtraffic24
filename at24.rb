require 'socket'
require 'date'
require_relative 'worker'

Socket.udp_server_loop(host='0.0.0.0', 1234) do |msg, msg_src|
  puts msg
  Message.perform_async(msg)
end
