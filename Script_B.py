################## METADATA ##################
# NAME: Etkin Pınar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-09
##############################################

number = input("Enter a number: ")
while number:
    if int(number) > 42:
        print("Your number is greater than 42.")
    elif int(number) < 42:
        print("Your number is less than 42.")
    else:
        print("Your number is exactly 42.")
    number = input("Enter a number: ")
