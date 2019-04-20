import usermonitoring

for user in usermonitoring.listusers():
    if user['status']:
        status = '*|'
    else: 
        status = ' |'
    uid = user['UID']
    name = user['username']
    shell = user['shell']
    print(f'{status} {uid:5}| {name:25}| {shell}')
