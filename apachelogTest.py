################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-06-04
##############################################

import apachelog

#finds the most popular value for the given attribute
def printpopular(dict):
    maximum = max(dict, key=lambda key:dict[key])
    print("  Most popular value is: {} ({} times)".format(maximum, dict[maximum]))

elements = apachelog.aggregatelog("access.log")

print("Number of unique IP addresses: {}".format(len(list(elements['IPaddress']))))
printpopular(elements['IPaddress'])
print("Number of unique HTTP Methods: {}".format(len(list(elements['Method']))))
printpopular(elements['Method'])
print("Number of unique paths: {}".format(len(list(elements['Path']))))
printpopular(elements['Path'])
print("Number of unique months: {}".format(len(list(elements['Month']))))
printpopular(elements['Month'])


