# TCP client  
  
import socket  
import sys

IP, PORT = sys.argv[1].split(':')

address = (IP, int(PORT))
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  
s.connect(address)  
  
s.send('hihi')  

s.close()
