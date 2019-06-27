#! /home/bcc/neutron/bin/python

import os
import time
import json
from bvragent.bvr import api

last_stats = {}

def run():
    global last_stats

    res = api.request('bond-interface-stat-show',  resp_type=api.RESPONSE_ALL)
    stats = json.loads(res.get('data'))[0]
    if 'rxpkts' in stats and 'rxpkts' in last_stats:
        rxpps = int(stats['rxpkts']) - int(last_stats['rxpkts'])
    else:
        rxpps = 0
    if 'txpkts' in stats and 'txpkts' in last_stats:
        txpps = int(stats['txpkts']) - int(last_stats['txpkts'])
    else:
        txpps = 0
    if 'rxbytes' in stats and 'rxbytes' in last_stats:
        rxbps = (int(stats['rxbytes']) - int(last_stats['rxbytes'])) * 8
    else:
        rxbps = 0
    if 'txbytes' in stats and 'txbytes' in last_stats:
        txbps = (int(stats['txbytes']) - int(last_stats['txbytes'])) * 8
    else:
        txbps = 0
    last_stats = stats
    if rxbps and rxpps and txbps and txpps:
        print 'RX: %s bps, %s pps | TX: %s bps, %s pps' % (rxbps, rxpps, txbps, txpps)
        #print 'RX: %s bps, %s pps | TX: %s bps, %s pps' % ('{0:,}'.format(rxbps), '{0:,}'.format(rxpps), '{0:,}'.format(txbps), '{0:,}'.format(txpps))

if __name__ == '__main__':
    with file('./stats.pid', 'w') as f:
            f.write(str(os.getpid()))
    while 1:
        try:
            now = time.time()
            run()
            sleep_time = now + 1 - time.time()
            time.sleep(sleep_time)
        except Exception as e:
            print 'EXCEPTION: %s' % str(e)
            continue
