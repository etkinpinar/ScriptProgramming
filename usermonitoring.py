################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-20
##############################################

import pwd
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
