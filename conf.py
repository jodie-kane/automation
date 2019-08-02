#!/usr/bin/python

import sys
import os
import string
import ConfigParser

from ConfigParser import SafeConfigParser, NoSectionError, NoOptionError

from fabric.api import prompt


""" returns boolean true if string is found in list """
def strToBool( str ):
    str = string.upper(str)
    if str in ('Y','YES','T','TRUE','C','CONFIRM','K','KEEP'):
        return True
    else: 
        return False

""" prompt with the supplied message; default is to abort """
def iprompt(qu, dv='A'):
    
    ans = prompt("{}".format(qu), default=dv)
    ans = string.upper(ans)

    if ans in ('A', 'ABORT'):
        print "ABORT!!!" 
        raise SystemExit 

    return ans

""" look in config file for default answers; allow override/confirmation, prompt if missing  """
def uprompt( cfig, section, key, forceprompt=False ):

    try: 
        global verbose
    except:
        pass

    try:

        ans = cfig.get(section, key)

    except (NoSectionError,NoOptionError) as e:

        ans = iprompt("{}: please specify the required value (y/n/A)".format(e))

    try:
        if verbose:
            print("{}: {}".format( key, ans ))
    except: 
        pass 

    if forceprompt:
        cfirm = strToBool(iprompt("Forcing confirm! Please choose (Keep/modify/abort)", 'K'))
    
        if not cfirm:
            return strToBool(iprompt("{}".format(key), ans ))

    return strToBool(ans)

#""" Examples 

# parse config 
sconf = SafeConfigParser()
sconf.optionxform = str
sconf.read('./conf-py.ini')


# uprompt( config, section, key, forceprompt )
# forceprompt
#fp = True

verbose=True
section = 'deploy'
QUD001='Deploy Of Infrastructure'
QUD002='These Exact Words In Release Document'


if uprompt(sconf, section, QUD001, forceprompt=False):
    print(  "START!! ~~~ {} ~~~".format(QUD001) ) 
else:
    print "BOO" 

if uprompt(sconf, section, QUD002, True):
    print("Truthness")
else:
    print("Falsehood")
