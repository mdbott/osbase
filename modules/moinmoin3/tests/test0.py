#!/usr/bin/python
# == Classification: Unclassified (provisional)
#

import os
import re
import subprocess
import sys


# Due to our convention it's safe to assume argv[0] matches /etc/puppet/modules/name/tests/testN.py
script_path = sys.argv[0]
modname = script_path.split(os.sep)[-3]
testname = os.path.basename(script_path)
# trim off the extension .py:
testname = testname[:testname.rfind('.')]


def out(message, level="LOG"):
    '''where level is one of LOG, SUCCESS, FAILURE'''
    message = message.rstrip('\n')
    for line in message.split('\n'):
        print "POSTTEST", level, "module", modname, testname, '-', line


def run(command):
    '''run command in shell, returning (returncode, stdout,stderr)'''
    p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    output = p.communicate()
    return [p.returncode] + list(output)



def main():

    ns_count = 0
    for line in open('/etc/resolv.conf'):
        if re.match('^nameserver [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$', line):
            ns_count += 1

    if ns_count < 3:
        out('less than three nameservers configured', 'FAILURE')
        sys.exit(1)
    else:
        out('at least three nameservers found', 'SUCCESS')


    host_ip = [ ['sgd3.ssde.dsd', '170.157.133.106'],
                ['study.itsupt.dsd', '170.157.142.230'] ]

    for host, ip in host_ip:
        returncode, stdout, stderr = run('nslookup ' + host)
        if stdout.find('Address: ' + ip) == -1:
            out('nslookup for %s failure' % host, 'FAILURE')
            out(stdout)
            sys.exit(1)
        else:
            out('nslookup for %s succeeded' % host, 'SUCCESS')

    for host, ip in host_ip:
        # -c means different things betwee GNU/Linux & SunOS :(
        returncode, stdout, stderr = run('ping -c 3 ' + host)
        if returncode == 0:
            out('ping %s succeeded' % host, 'SUCCESS')
        else:
            out('ping %s failured' % host, 'FAILURE')
            out(stderr)
            sys.exit(1)

    sys.exit(0)


if __name__ == "__main__":
    main()
