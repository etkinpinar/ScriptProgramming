################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-24
##############################################

import pwd
import subprocess
from systemd import login
import psutil

def listusers():
    userList = []
    #gets the whole data in pwd
    data = pwd.getpwall()   
    
    #for loop that extracts only the required data
    for info in data:       
        user = {
            'UID': info[2], 
            'username': info[0], 
            'shell': info[6]
        }
        for online in login.uids():
            if online == info[2]:
               user['status']= True
               break
            else:
                user['status']= False
        userList.append(user)
    
    #sorts the list with ascending order
    userList = sorted(userList, key=lambda k: k['UID'])    
    return userList

def diskusagehome(uid):
    try:
        #checks whether there is a user with the given uid
        username = pwd.getpwuid(uid).pw_name    
    except:
        return None
    if uid == 0:
        directory = "/root"
    elif uid >= 1000:
        directory = "/home/{}".format(username)
    else:
        return None
    #uses du with sudo
    output = subprocess.check_output(["sudo", "du", "-sm", "{}".format(directory)])     

    #extracts the size from output
    size = int(output.partition(b"\t")[0].decode())     
    return size

def cputimeperuser():
    cputimes = {}
    #takes every running process with username and cpu times
    for process in psutil.process_iter(attrs=['username', 'cpu_times']): 
        #links cpu times to usernames in the dictionary    
        cputimes[process.username()] = cputimes.setdefault(process.username(), 0) + (process.cpu_times().user + process.cpu_times().system)
    return cputimes
