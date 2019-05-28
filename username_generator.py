################## METADATA ##################
# NAME: Etkin Pınar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-05-28
##############################################

import datetime
from unidecode import unidecode

#returns name and surname as elements of a tuple
def nameSplitter(name):
    partedname = name.partition(",")
    name = partedname[0].lower()
    surname = partedname[2].strip().lower()
    return (name, surname)

#creates a list that contains letters in the alphabet
alphabet = []
for i in range(97,123):
    alphabet.append(chr(i))

namefile = "name_list.txt"
names = []
#gets users' names from text file
with open (namefile, "r") as usersfile:
    for line in usersfile:
        if not line.isspace(): names.append(unidecode(line.strip()))

year = datetime.datetime.now().strftime("%y")

#this dictionary maps usernames with their number
usernamedict = {}
for name in names:
    nametuple = nameSplitter(name)
    #gets name from the tuple
    name = nametuple[0]
    #gets surname from the tuple
    surname = nametuple[1]
    #if name is shorter than 3 letters, it adds the last letter to name until it has 3 letters
    while len(name) < 3:
        name = name + name[-1]
    #if surname is only one letter, it adds that letter so that we can have at least 2 letters
    if not len(surname) == 2:
        surname = surname + surname
    #creates username
    username = name[:3] + surname[:2]
    #when it creates a username, it increases the number for that username in the dictionary
    usernamedict[username] = usernamedict.setdefault(username, 0) + 1
    #creates final username
    unique_username = alphabet[usernamedict[username]-1] + year + username
    #writes it to a text file
    with open("unique_usernames.txt", "a") as f:
        f.write(unique_username+'\n')
