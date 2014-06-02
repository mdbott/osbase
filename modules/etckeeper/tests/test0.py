#!/usr/bin/python
# See http://study.itsupt.dsd:8585/puppetvm/file/tip/README for testing details
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


    if modname == 'etckeeper':
        out('module template do nothing test', 'SUCCESS')
        sys.exit(0)
    else:
        out('this module requires a a testing module', 'FAILURE')
        out('please write a functional %s' % script_path, 'LOG')
        sys.exit(1)


if __name__ == "__main__":
    main()
