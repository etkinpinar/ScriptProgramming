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

#function prints out the log list for recentlogmessages() function
def printLogs(logList):  
    if logList:
        for log in logList[-10:]: print(log)
    else:
        print("Logs not found. Either there is no recent log messages with given priority or there is no such unit.")

###########  Main begins  ###########

print("Welcome to test script for 'systemmonitoring' module!")
selection = (input("Press 1 for recentlogmessages() or press 2 for probtcpport(): ")).strip()
while selection !="1" and selection !="2" and selection:
    selection = (input("Please enter a valid input: ")).strip()
    
if selection == "1":
    logList = []                    
    selection = (input("Press 'Enter' for existing test or enter a systemd unit: ")).strip()
    if selection:
        print("\u001b[37;1m---- {} Logs ----\u001b[0m".format(selection))
        logList = systemmonitoring.recentlogmessages(selection)
        printLogs(logList)
    else:
        #random systemd units with info priority for testing
        unitList = [["rsyslog.service",LOG_INFO], ["cron.service",LOG_INFO], 
                    ["aaaw.daemon",LOG_INFO], ["network.service",LOG_INFO]]   
    
        for unit in unitList:
            #query without specifying priority level
            print("\u001b[37;1m--- {} Logs with priority {} ---\u001b[0m".format(unit[0],LOG_WARNING))
            logList = systemmonitoring.recentlogmessages(unit[0])
            printLogs(logList)        
            
            #query with specifying priority level
            print("\u001b[37;1m--- {} Logs with priority {} ---\u001b[0m".format(unit[0],unit[1]))
            logList = systemmonitoring.recentlogmessages(unit[0],unit[1])
            printLogs(logList)

elif selection == "2":
    selection = input("Press 'Enter' for existing test or enter an ip address and port: ")
    
    #seperates port number from the ip address
    selection = selection.rstrip().replace(" ", ":").split(":")
    
    if selection[0] != "":
        if systemmonitoring.probtcpport(selection[0], selection[1]): status = "success" 
        else: status = "fail"
        print("Probing {} on port {}: {}".format(selection[0], selection[1], status))      
    else:
        #random address-port combinations
        addressList= [["127.0.0.1", "25"], ["127.0.0.1","80"], ["127.0.0.53","53"],
                      ["www.something.com","443"], ["127.0.0.1","6899"], ["www.google.com","443"]]
        
        for address in addressList:
            if systemmonitoring.probtcpport(address[0],address[1]): status = "success" 
            else: status = "fail"
            print("Probing {} on port {}: {}".format(address[0], address[1], status))
