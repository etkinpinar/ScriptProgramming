################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 1 - Python
# DATE OF LAST CHANGE: 2019-04-23
##############################################

import re

def aggregatelog(filename):
    keys = ['IPaddress', 'Day', 'Month', 'Year', 'Method', 'Path', 'Status Code', 'Size', 'Referer', 'User-Agent' ]
    #initialize elements dictionary 
    elements = {key: {} for key in keys}
    #re pattern to seperate sections
    sep_re = re.compile(r'([\d\.]+).*?\[(\d+)/(.*?)/(\d+).*?\].*?"(.*?) (.*?) .*?".*?(\d+) (.*?) "(.*?)" "(.*?)"') 
    with open(filename, "r") as logfile:
        for line in logfile:
            line = line.strip()
            #tuple contains different sections such as ip address,method,etc.
            try:
                sections = sep_re.match(line).groups()
            except:
                continue
            #evaluating sections
            for i in range(len(sections)):    
                elements[keys[i]][sections[i]] = elements[keys[i]].setdefault(sections[i], 0) + 1     
    return elements
