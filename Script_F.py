################## METADATA ##################
# NAME: Etkin Pınar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-19
##############################################

import re

def lookslikelogin(login): 
    if re.match(r"[a-z][0-9]{2}([a-z]{5})$", login): # login should starts with a letter and ends with 5 letters and have two digits
        return True
    else:
        return False

login = input("Enter a login name: ")
while login:
    if lookslikelogin(login):
        print("Input '{}' looks like a student login :-)".format(login))
    else: 
        print("Input '{}' does not look like a student login :-(".format(login))
    login = input("Enter a login name: ")
