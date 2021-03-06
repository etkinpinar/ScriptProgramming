################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-06-04
##############################################

import systemmonitoring
from syslog import (LOG_EMERG, LOG_ALERT, LOG_CRIT, LOG_ERR,
                    LOG_WARNING, LOG_NOTICE, LOG_INFO, LOG_DEBUG)
from os import getuid
import pwd

#function prints out the log list for recentlogmessages() function
def printLogs(logList):  
    if logList:
        for log in logList[-10:]: print(log)
    else:
        print("Logs not found. Either there is no recent log messages with given priority or there is no such unit.")

print("Welcome to test script for 'systemmonitoring' module!")
selection = (input("Press 1 for recentlogmessages(), press 2 for probtcpport() or press 3 for diskusagedir(): ")).strip()
while selection !="1" and selection !="2" and selection !="3" and selection:
    selection = (input("Please enter a valid input: ")).strip()
######  recentlogmessages() begins ######  
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
                    ["aaaw.daemon",LOG_INFO], ["network.service",LOG_INFO], ["ssh.service",LOG_INFO]]   
    
        for unit in unitList:
            #query without specifying priority level
            print("\u001b[37;1m--- {} Logs with priority {} ---\u001b[0m".format(unit[0],LOG_WARNING))
            logList = systemmonitoring.recentlogmessages(unit[0])
            printLogs(logList)        
            
            #query with specifying priority level
            print("\u001b[37;1m--- {} Logs with priority {} ---\u001b[0m".format(unit[0],unit[1]))
            logList = systemmonitoring.recentlogmessages(unit[0],unit[1])
            printLogs(logList)
#######  recentlogmessages() ends #######  

#########  probtcpport() begins #########
elif selection == "2":
    selection = input("Press 'Enter' for existing test or enter an ip address and port: ")
    
    #seperates port number from the ip address
    selection = selection.strip().replace(" ", ":").split(":")
    
    if selection[0] != "":
        if systemmonitoring.probtcpport(selection[0], selection[1]): status = "success" 
        else: status = "fail"
        print("Probing {} on port {}: {}".format(selection[0], selection[1], status))      
    else:
        #random address-port combinations
        addressList= [["127.0.0.1", "25"], ["127.0.0.1","666"], ["www.example.com","443"],
                      ["www.something.com","443"], ["his.se","443"], ["www.google.com","443"]]
        
        for address in addressList:
            if systemmonitoring.probtcpport(address[0],address[1]): status = "success" 
            else: status = "fail"
            print("Probing {} on port {}: {}".format(address[0], address[1], status))
##########  probtcpport() ends ########## 

#########  diskusagedir() begins ######## 
elif selection == "3":
    selection = (input("Press 'Enter' for existing test or enter a path: ")).strip()
    if selection:
        systemmonitoring.diskusagedir(selection)
    else:
        currentUser = pwd.getpwuid(getuid()).pw_name
        currentUserHome = " /home/{} ".format(currentUser)
        print("\u001b[37;1m{:-^27}\u001b[0m".format(currentUserHome))
        systemmonitoring.diskusagedir(currentUserHome.strip())
        print("\u001b[37;1m{:-^27}\u001b[0m".format(" /tmp "))
        systemmonitoring.diskusagedir("/tmp")
        print("\u001b[37;1m{:-^27}\u001b[0m".format(" /invalid/directory "))
        systemmonitoring.diskusagedir("/invalid/directory")
        print("\u001b[37;1m{:-^27}\u001b[0m".format(" /root "))
        systemmonitoring.diskusagedir("/root")
    
##########  diskusagedir() ends #########     
