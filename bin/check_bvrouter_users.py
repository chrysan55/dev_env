#!/usr/bin/python
# -*- coding: utf-8 -*-

import commands
import json
import time

BVROUTERs = [{'cluster': 'onlineA', 'node': '10.63.80.38'},
             {'cluster': 'onlineB', 'node': '10.63.80.23'},
             {'cluster': 'onlineC', 'node': '10.63.80.21'},
             {'cluster': 'gzns', 'node': '10.133.28.11'}]

def sendmail(mailtext):
    """ send email """
    alarm_time = time.strftime('%Y-%m-%d %X', time.localtime(time.time()))

    texts = ['<PRE>']
    texts.append(u'本周BVRouter线上数据：</b>'.encode('utf-8'))
    texts.append(mailtext)
    texts.append('<PRE>')
    mail_text = '\r\n'.join(texts)

    # send mail
    import smtplib
    import socket
    host = socket.gethostname()
    # email options
    SERVER = "localhost"
    FROM = "root@%s" % host
    TO = ('zhaogang05@baidu.com', 'guyanan@baidu.com', 'gongzhimin@baidu.com')
    SUBJECT = (u"[%s]BVRouter线上数据" %
               alarm_time).encode('utf-8')

    message = """\
From: %s
To: %s
MIME-Version: 1.0
Content-type: text/html
Subject: %s

%s
    """ % (FROM, ", ".join(TO), SUBJECT, mail_text)

    server = smtplib.SMTP(SERVER)
    server.sendmail(FROM, TO, message)
    server.quit()

total_routers = 0
total_vms = 0
lines = []
timestamp = time.strftime('%Y-%m-%d-%X', time.localtime())
for bvr in BVROUTERs:
#for bvr in BVR_NS:
    lines.append('\nCLUSTER %s' % bvr['cluster'])
    if bvr['cluster'] == 'onlineA':
        status, ret = commands.getstatusoutput('bvr-agent bvrouter-list --bvrip %s ' % bvr['node'])
        vrouters = json.loads(ret)
        lines.append('%d vrouters' % len(vrouters))
        total_routers += len(vrouters)

        pre_len = 0
        post_len = 0
        for vrouter in vrouters:
            status, ret = commands.getstatusoutput('bvr-agent nf-rules-show --bvrip %s %s nat' % (bvr['node'], vrouter['vrouter_name']))
            if ret:
                nat_rule = json.loads(ret)
            pre_r_list = nat_rule['PREROUTING']
            post_r_list = nat_rule['POSTROUTING']
            pre_len += len(pre_r_list)
            post_len += len(post_r_list)
        # there are 2 DHCP port in each vrouter
        vm_len = pre_len - len(vrouters) * 2
        lines.append('%d VMs' % vm_len)
        total_vms += vm_len
    else:
        filename = '%s.json.%s' % (bvr['cluster'], timestamp)
        commands.getstatusoutput('bvr-agent dump --bvrip %s %s' % (bvr['node'], filename))
        vrouters = json.load(open(filename, 'r'))
        lines.append('%d vrouters' % len(vrouters))
        total_routers += len(vrouters)
        pre_len = 0
        post_len = 0
        for vrouter in vrouters:
            pre_len += len(vrouter['nat-rules']['PREROUTING'])
            post_len += len(vrouter['nat-rules']['POSTROUTING'])
        vm_len = pre_len - len(vrouters) * 2
        lines.append('%d VMs' % vm_len)
        total_vms += vm_len

lines.append('\nTOTAL: ')
lines.append('%d vrouters' % total_routers)
lines.append('%d VMs' % total_vms)
with file('./res', 'w') as f:
    f.write('\n'.join(lines))

sendmail('\n'.join(lines))
