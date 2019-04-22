################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-21
##############################################

import socket
import time
from systemd import journal
from syslog import (LOG_EMERG, LOG_ALERT, LOG_CRIT, LOG_ERR,
                    LOG_WARNING, LOG_NOTICE, LOG_INFO, LOG_DEBUG)

def recentlogmessages(systemdunit, priority=LOG_INFO):
    logList = []
    j = journal.Reader()
    log_time = time.time() - (24 * 60**2 + 30 * 60)
    
    #sets time
    j.seek_realtime(log_time)
    
    #sets priority
    j.log_level(priority)
    
    #matches with the given systemd unit
    j.add_match(_SYSTEMD_UNIT=systemdunit)
    
    #adds entries to the logList
    for entry in j:
        logList.append(entry['MESSAGE'])
    return logList

def probtcpport(address, portnumber):
    try:
        socket.create_connection((address, portnumber))
        return True
    except:
        return False
