#!/usr/bin/python
# Classification: Unclassified (provisional)

import os
import re
import subprocess
import sys
import time

# Number of seconds to wait between ntpq attempts
ntpq_wait = 10
# Number of ntpq tries:
ntpq_attempts = 5

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

    OS = os.uname()[0]

    if OS == 'Linux':
        ntp_conf_path = '/etc/ntp.conf'
    else:
        ntp_conf_path = '/etc/inet/ntp.conf'

    if not os.access(ntp_conf_path, os.R_OK):
        out('unable to read ' + ntp_conf_path, 'FAILURE')
        sys.exit(1)

    ntp_conf = open(ntp_conf_path).read()

    ntp_server_count = len(re.findall('^server ', ntp_conf, re.MULTILINE))
    if ntp_server_count < 2:
        out('less than two NTP servers in ' + ntp_conf_path, 'FAILURE')
        sys.exit(1)
    else:
        out('at least two NTP servers found in ' + ntp_conf_path, 'SUCCESS')


    # It turns out that waiting for ntpd having selected a server for synchronization is far to
    # slow a process, instead we just wait until ntpd calculated has calculated a roundtrip delay
    # to one of the NTP servers. This still takes a while to calculate so we have to wait
    for i in range(ntpq_attempts):

        time.sleep(ntpq_wait)

        returncode, stdout, stderr = run('ntpq -p')
        if returncode != 0:
            out('ntpq has returned non-zero', 'FAILURE')
            out(stderr)
            sys.exit(1)

        if 'Connection refused' in stderr:
            continue

        lines = stdout.split('\n')

        if len(lines) > 2 and lines[1] == 78*'=':
            server_lines = lines[2:-1]
            delays = [ line.split()[7] for line in server_lines ]
            good_delay = [ delay not in ['0.000', '0.00'] for delay in delays]

            if True in good_delay:
                break

    else:
        out('ntpq -p failing to report a round trip delay', 'FAILURE')
        out(stdout)
        out(stderr)
        sys.exit(1)

    out('ntpq -p reports contact with a timeserver and a round trip delay', 'SUCCESS')
    #out(stdout)
    sys.exit(0)


if __name__ == "__main__":
    main()
