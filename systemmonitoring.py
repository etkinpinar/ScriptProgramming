################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-05-17
##############################################

import os
import socket
import time
from systemd import journal
from syslog import (LOG_EMERG, LOG_ALERT, LOG_CRIT, LOG_ERR,
                    LOG_WARNING, LOG_NOTICE, LOG_INFO, LOG_DEBUG)

def recentlogmessages(systemdunit, priority=LOG_WARNING):
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
    #tries to connect and returns True if it succeeds
    try:
        socket.create_connection((address, portnumber))
        return True
    #returns False if it fails
    except:
        return False

def diskusagedir(dirname):
    dirDict = {}
    fileDict = {}
    try:
        for entry in os.scandir(dirname):
            #checks whether it is a file or a directory
            if entry.is_dir():
                #calculates directory's size
                dirSize = 0
                for dirpath,dirnames,filenames in os.walk(entry.path):
                    for f in filenames:
                        dirSize += os.path.getsize(os.path.join(dirpath,f))
                dirDict["D {}".format(entry.name)] = int(dirSize / 1048576)
            else:
                fileDict[entry.name] = int(entry.stat().st_size / 1048576)
        #converts dictionaries to sorted list of tuples
        sortedDirs = sorted(dirDict.items(), key=lambda x: x[1], reverse=True)        
        sortedFiles = sorted(fileDict.items(), key=lambda x: x[1], reverse=True)

        #prints the list cuts if name is longer than expected
        for dir in sortedDirs:
            print("{:20}: {} MiB".format(dir[0][:20], dir[1]))
        for file in sortedFiles:
            print("  {:18}: {} MiB".format(file[0][:18], file[1]))
    
    #meaningful exception messages for users
    except FileNotFoundError as err:
        print("There is not any file or directory named '{}'".format(err.filename))     
    except PermissionError as err:
        print("You do not have permission to access to '{}'".format(err.filename))

