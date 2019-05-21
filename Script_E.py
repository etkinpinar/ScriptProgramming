################## METADATA ##################
# NAME: Etkin Pınar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-09
##############################################

alphabet = {}
with open("alphabet.txt", "r") as alphabetfile:
    lineNumber = 1
    for line in alphabetfile: 
        alphabet[line.strip()] = lineNumber
        lineNumber += 1
for keys in alphabet:
    print("{} : {}".format(keys,alphabet[keys]))