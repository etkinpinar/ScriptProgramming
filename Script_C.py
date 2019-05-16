################## METADATA ##################
# NAME: Etkin Pınar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-09
##############################################

alphabet = []
with open("alphabet.txt", "r") as alphabetfile:
    for line in alphabetfile:
        alphabet.append(line.strip())
for letters in alphabet:
    print(letters, end = "")
else: print()
length = len(alphabet)
for i in range(length):
    print("Letter number {} is {}".format(i, alphabet[i]))