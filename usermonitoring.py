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
    data = pwd.getpwall()
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
    userList = sorted(userList, key=lambda k: k['UID'])
    return userList

def diskusagehome(uid):
    try:
        username = pwd.getpwuid(uid).pw_name
    except KeyError:
        return None
    if uid == 0:
        directory = "/root"
    elif uid >= 1000:
        directory = "/home/{}".format(username)
    else:
        return None
    output = subprocess.check_output(["sudo", "du", "-sh", "{}".format(directory)])
    size = int(output.partition(b",")[0].decode())
    return size


print("Disk usage of user with UID {} : {} MB".format(1001, diskusagehome(1001)))
