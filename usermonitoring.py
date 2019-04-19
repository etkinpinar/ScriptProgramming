################## METADATA ##################
# NAME: Etkin Pınar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-19
##############################################
import pwd

def listusers():
    userList = []
    data = pwd.getpwall()
    for info in data:
        user = {
            "UID": info[2],
            "username": info[0],
            "shell" :info[6]
            #,"status": True
        }
        userList.append(user)
    return userList

for user in listusers():print(user)