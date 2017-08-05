require 'socket'
require 'mongo'
require_relative 'worker'

Socket.udp_server_loop(host='0.0.0.0', 1234) do |msg, msg_src|
  Message.perform_async(msg)
end
