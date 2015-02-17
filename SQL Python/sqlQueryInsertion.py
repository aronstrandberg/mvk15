import pxssh
try:                                                            
    s = pxssh.pxssh()
    hostname = 'mvk.cloudapp.net'
    username = 'azureuser'
    password = 'Kanelbulle1'
    s.login (hostname, username, password)
    print 'Login successful'
    s.sendline ('psql mvktest')
    # Ondlig loop, TODO: Battre
    while True:
        NAME = raw_input('Name: ')  # Byt dessa mot dronens data
        AGE = raw_input('Age: ')
        EMAIL = raw_input('Email: ')
        query = "INSERT INTO info(name,age,email) values(\'%s\',%s,\'%s\');"\
            %(NAME,AGE,EMAIL)
        print query
        s.sendline (query)
    s.logout()
except pxssh.ExceptionPxssh, e:
    print "pxssh failed on login."
    print str(e)