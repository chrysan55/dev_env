#!/usr/bin/python

import os
import time
import json
import traceback
import logger
import threading
from multiprocessing.dummy import Pool as ThreadPool
from bvragent.bvr import api

LOG = logger.get_logger()
BVRS = [
    '10.63.80.23',
    '10.63.80.26',
    '10.63.82.37',
    '10.63.141.11',
    '10.63.82.42',
    '10.63.141.12'
]
last_to = 0
last_back = 0
last_drop = 0
last_dnat = 0
last_snat = 0
last_port_pkts = {}


def collect_filter(bvrip):
    nf = api.request('nf-rules-show', server=bvrip, resp_type=api.RESPONSE_ALL, bvrouter='qrouter-8821ef23-445d-425c-8df6-3cc4d1eae634', table='filter')
    nf = json.loads(nf.get('data'))
    for item in nf[u'FORWARDING']:
        if item[u'source-ip'] == u'10.16.92.190/32' and item[u'destination-ip'] == u'192.168.2.159/32':
            back = int(item[u'hit_pkts'])
        if item[u'source-ip'] == u'192.168.2.159/32' and item[u'destination-ip'] == u'10.16.92.190/32':
            to = int(item[u'hit_pkts'])
        if item[u'destination-ip'] == u'10.0.0.0/8':
            drop = int(item[u'hit_pkts'])
    return [to, back, drop]


def collect_nat(bvrip):
    nf = api.request('nf-rules-show', server=bvrip, resp_type=api.RESPONSE_ALL, bvrouter='qrouter-8821ef23-445d-425c-8df6-3cc4d1eae634', table='nat')
    nf = json.loads(nf.get('data'))
    for item in nf[u'PREROUTING']:
        if item[u'destination-ip'] == u'10.17.70.83' and item[u'to-ip'] == u'192.168.2.159':
            dnat = int(item[u'hit_pkts'])
    for item in nf[u'POSTROUTING']:
        if item[u'to-ip'] == u'10.17.70.83' and item[u'source-ip'] == u'192.168.2.159':
            snat = int(item[u'hit_pkts'])
    return [dnat, snat]

def collect_port(bvrip):
    ret = {}
    ports = api.request('router-ifs-show', server=bvrip, resp_type=api.RESPONSE_ALL, bvrouter='qrouter-8821ef23-445d-425c-8df6-3cc4d1eae634')
    ports = json.loads(ports.get('data'))
    for port in ports:
        ret[port[u'ifname']] = [int(port[u'rx_pkts']), int(port[u'tx_pkts'])]
    return ret


def summary_filter(res1, res2):
    return [res1[0] + res2[0], res1[1] + res2[1], res1[2] + res2[2]]

def summary_nat(res1, res2):
    return [res1[0] + res2[0], res1[1] + res2[1]]

def summary_port(res1, res2):
    res = {}
    for port in res1:
        if port in res2:
            res[port] = [res1[port][0] + res2[port][0], res1[port][1] + res2[port][1]]
        else:
            res[port] = [res1[port][0], res1[port][1]]
    return res


def run():
    global last_to, last_back, last_drop, last_port_pkts, last_dnat, last_snat
    pool = ThreadPool(6)
    to, back, drop= reduce(summary_filter,
                           pool.map(collect_filter, BVRS))
    port_pkts = reduce(summary_port,
                       pool.map(collect_port, BVRS))
    dnat, snat = reduce(summary_nat,
                        pool.map(collect_nat, BVRS))
    LOG.info('192.168.2.159 -> 10.16.92.190 : Egress %d pkts, Ingress %d pkts.' % (to - last_to, back - last_back))
    LOG.info('192.168.2.159 <-> 10.16.92.190 : SNAT %d pkts, DNAT %d pkts.' % (snat - last_snat, dnat - last_dnat))
    LOG.info('10.0.0.0/8 DROP: %d pkts.' % (drop - last_drop))
    for port in port_pkts:
        if port in last_port_pkts:
            LOG.info('%s : RX %d pkts, TX %d pkts.' % (port,
                                                       port_pkts[port][0] - last_port_pkts[port][0],
                                                       port_pkts[port][1] - last_port_pkts[port][1]))
    last_to = to
    last_back = back
    last_drop = drop
    last_port_pkts = port_pkts
    last_dnat = dnat
    last_snat = snat


if __name__ == '__main__':
    with file('./monitor.pid', 'w') as f:
            f.write(str(os.getpid()))
    while 1:
        try:
            now = time.time()
            run()
            sleep_time = now + 10 - time.time()
            time.sleep(sleep_time)
        except Exception as e:
            LOG.error('EXCEPTION: %s' % str(e))
            continue
