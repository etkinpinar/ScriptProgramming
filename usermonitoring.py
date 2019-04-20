################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-20
##############################################

import pwd
import subprocess
from systemd import login

def listusers():
    userList = []
    data = pwd.getpwall()   #gets the whole data in pwd
    for info in data:       #this for loop extracts only the required data
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
    userList = sorted(userList, key=lambda k: k['UID'])    #sorts the list with ascending order
    return userList

def diskusagehome(uid):
    try:
        username = pwd.getpwuid(uid).pw_name    #checks whether there is a user with the given uid
    except KeyError:
        return None
    if uid == 0:
        directory = "/root"
    elif uid >= 1000:
        directory = "/home/{}".format(username)
    else:
        return None
    output = subprocess.check_output(["sudo", "du", "-sm", "{}".format(directory)])     #uses du with sudo
    size = int(output.partition(b"\t")[0].decode())     #extracts the size from output
    return size
