require 'socket'
require 'ipaddr'

MULTICAST_ADDR = "225.4.5.6" 
PORT = 5000

ip =  IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new("0.0.0.0").hton

sock = UDPSocket.new
sock.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP, ip)
sock.bind(Socket::INADDR_ANY, PORT)

loop do
  msg, info = sock.recvfrom(1024)
  if msg == 'yes'
    x = Thread.new {`xtightvncviewer -fullscreen -viewonly #{info[2]}`}  
    #puts 'compartilhando'
  else
    #Thread.kill x
    `killall xtightvncviewer`
    #puts 'nada' 
  end
end
