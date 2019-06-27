import socket
import sys

IP, PORT = sys.argv[1].split(':')

address = (IP, int(PORT))
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

while True:
    msg = raw_input()
    if not msg:
        break
    s.sendto(msg, address)
    data, addr = s.recvfrom(2048)
    print 'received: %s from (%s)' % (data, addr)

s.close()

