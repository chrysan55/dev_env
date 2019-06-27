# TCP server

import socket

address = ('0.0.0.0', 6666)
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(address)
s.listen(5)

while True:
        ss, addr = s.accept()
        print 'got connected from ',addr
        ra = ss.recv(512)
        print 'receive data: ', ra
