#! /usr/bin/python
# coding=utf-8
 
import struct
 
data = "200108000000040045000054107000004001e8cac0a8000ac0a800140000c6bb9899002510d9185900000000b680020000000000101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f3031323334353637"
data = "200108000000040045000054107000004001e8cac0a8000ac0a800140000c6bb9899002510d9185900000000b680020000000000101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f3031323334353637"
 
def carry_around_add(a, b):
    c = a + b
    return (c & 0xffff) + (c >> 16)
 
def checksum(msg):
    s = 0
    for i in range(0, len(msg), 2):
        w = ord(msg[i]) + (ord(msg[i+1]) << 8)
        s = carry_around_add(s, w)
    return ~s & 0xffff
 
l = []
for i in range(len(data)/2):
    l.append(data[(2 * i):(2 * i + 2)])
data = l
data = map(lambda x: int(x,16), data)
data = struct.pack("%dB" % len(data), *data)
 
print ' '.join('%02X' % ord(x) for x in data)
print "Checksum: 0x%04x" % checksum(data)
