#!/usr/bin/python

import time
import commands
import json
import sys
if len(sys.argv) != 2:
    print 'Usage: %s BVRIP' % sys.argv[0]
    exit
bvrip = sys.argv[1]
y = None
for i in range(10):
  now = time.time()
  ret=commands.getoutput('bvr-agent bond-interface-stat-show --bvrip %s' % bvrip)
  x=json.loads(ret)
  if y is not None:
    print 'RX pps: %d \t TX pps: %d \t|\tRX bps: %d \t TX bps: %d' % (int(x[0]["rxpkts"])-int(y[0]["rxpkts"]), int(x[0]["txpkts"])-int(y[0]["txpkts"]), int(x[0]["rxbytes"])*8-int(y[0]["rxbytes"])*8, int(x[0]["txbytes"])*8-int(y[0]["txbytes"])*8)
  y=x
  sleep_time = now + 1 - time.time()
  if sleep_time > 0:
    time.sleep(sleep_time)
