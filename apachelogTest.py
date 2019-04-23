################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-23
##############################################

import apachelog

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











   # elements = {'IPaddress':{}, 'Date':{}, 'Method':{}, 'Path':{}, 'Status Code':{},
    #            'Size':{}, 'Referer':{}, 'User-Agent':{} }
    #turn keys into a list, it makes easier to write sections into a dictionary 
    #keys = list(elements)
