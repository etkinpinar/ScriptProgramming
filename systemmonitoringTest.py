################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-22
##############################################

import systemmonitoring
from syslog import (LOG_EMERG, LOG_ALERT, LOG_CRIT, LOG_ERR,
                    LOG_WARNING, LOG_NOTICE, LOG_INFO, LOG_DEBUG)

#function prints out the log list
def printLogs(logList):  
    if logList:
        for log in logList[-10:]: print(log)
    else:
        print("Logs not found. Either there is no recent log messages or there is no such unit.")

###########  Main begins  ###########

print("Welcome to test script for 'systemmonitoring' module!")
selection = input("Press 1 for recentlogmessages() or press 2 for probtcpport(): ")
while selection !="1" and selection !="2" and selection:
    selection = input("Please enter a valid input: ")
    
if selection == "1":
    logList = []                    
    selection = input("Press 'Enter' for existing test or enter a systemd unit: ")
    if selection:
        print("\u001b[37;1m---- {} Logs ----\u001b[0m".format(selection))
        logList = systemmonitoring.recentlogmessages(selection)
        printLogs(logList)
    else:
        #random systemd units for testing
        unitList = ["rsyslog.service", "cron.service", "aaa.daemon"]   
    
        for unit in unitList:
            print("\u001b[37;1m---- {} Logs ----\u001b[0m".format(unit))
            logList = systemmonitoring.recentlogmessages(unit)
            printLogs(logList)

elif selection == "2":
    print("Selection number 2")
    
    
    
    
    
    
    
    
    
