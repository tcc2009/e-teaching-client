require 'socket'
require 'ipaddr'
require 'RMagick'

MULTICAST_ADDR = "225.4.5.6" 
PORT = 5000
$PIXELS_X = 400
$PIXELS_Y = 300
$HOSTNAME = "aluno1.rb"

ip =  IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new("0.0.0.0").hton
sock = UDPSocket.new
sock.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP, ip)
sock.bind(Socket::INADDR_ANY, PORT)

loop do
  msg, info = sock.recvfrom(1024)
  case msg
    when 'yes'
       t_share = Thread.new {`xtightvncviewer -fullscreen -viewonly #{info[2]}`}
    when 'no'
      `killall xtightvncviewer`
      Thread.kill t_share
    when 'thumb'
      t_thumb = Thread.new do
      	loop do
          #captura imagem do display 0! 
          picture = Magick::Image.capture(silent=true){ self.filename = "root" }
          #Redimensiona para 400x300
          picture.crop_resized!($PIXELS_X, $PIXELS_Y, Magick::ForgetGravity)
          picture.write("/tmp/#{$HOSTNAME}.png")
          sleep 5      
        end
      end
    when 'list'
      Thread.kill t_thumb
  end
end

#  if msg == 'yes'
#    x = Thread.new {`xtightvncviewer -fullscreen -viewonly #{info[2]}`}  
#    #puts 'compartilhando'
#  else
#    #Thread.kill x
#    `killall xtightvncviewer`
#    #puts 'nada' 
#  end
#  
#  if msg == 'thumb'
#    thread = Thread.new do
#      loop do
#        #captura imagem do display 0! 
#        picture = Magick::Image.capture(silent=true){ self.filename = "root" }
#        #Redimensiona para 400x300
#        picture.crop_resized!($PIXELS_X, $PIXELS_Y, Magick::ForgetGravity)
#        picture.write("/tmp/#{$HOSTNAME}.png")
#        sleep 5      
#      end
#      
#    end
#  end
