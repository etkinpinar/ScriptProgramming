################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-20
##############################################

import usermonitoring
import os

print("Welcome to test script for 'usermonitoring' module!")
selection = input("Press 1 for listuser() or press 2 for diskusagehome(): ")
while selection !="1" and selection !="2":
    selection = input("Please enter a valid input: ")

if selection == "1":
    for user in usermonitoring.listusers():
        if user['status']:
            status = '*'
        else: 
            status = ' '
        uid = user['UID']
        name = user['username']
        shell = user['shell']
        print(f'{status}| {uid:5}| {name:25}| {shell}')

elif selection == "2":
    uid = input("Press 'Enter' for existing test or enter a UID: ")
    if uid:
        while True:
            try:
                uid = int(uid)
                if usermonitoring.diskusagehome(uid) == None:       #checks whether there is a user with the given uid
                    print("Disk usage of user with UID {} : Could not determine disk usage".format(uid))
                else:
                    print("Disk usage of user with UID {} : {} MB".format(uid, usermonitoring.diskusagehome(uid)))
                break
            except ValueError:
                uid = input("UID must be an integer! Please enter an integer: ")
    
    else:       #existing test
        print("Disk usage of user with UID {} : {} MB".format(0, usermonitoring.diskusagehome(0)))
        print("Disk usage of user with UID {} : {} MB".format(os.geteuid(), usermonitoring.diskusagehome(os.geteuid())))
        if usermonitoring.diskusagehome(8888) == None:   
            print("Disk usage of user with UID {} : Could not determine disk usage".format(8888))     
        else:            
            print("Disk usage of user with UID {} : {} MB".format(8888, usermonitoring.diskusagehome(8888)))
