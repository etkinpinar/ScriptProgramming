################## METADATA ##################
# NAME: Etkin Pınar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-09
##############################################

users = []
with open("users.csv", "r") as usersfile:
    users = usersfile.readline().strip().split(",")
users.sort()
with open("sortedUsers.txt", "w") as newUsersFile:
    for user in users:
        print(user, file=newUsersFile)
