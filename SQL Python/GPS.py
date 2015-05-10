import gps
import pxssh
import getpass

class Connection:
    global id
    id = 1

    # inital setup
    def setup(self):
        try:
            global s
            #Connect to database using SSH
            s = pxssh.pxssh()
            HOSTNAME = 'mvk.cloudapp.net'
            USERNAME = 'azureuser'
            PASSWORD = getpass.getpass('Password: ')
            s.login (HOSTNAME, USERNAME, PASSWORD)
            print 'Login successful'
            s.sendline('sudo -i -u postgres')
            s.sendline ('psql mvk')
        except pxssh.ExceptionPxssh, e:
            print "pxssh failed on login."
            print str(e)

    # Increment the lapcounter in table Laps
    def start_new_lap(self):
        s.sendline("INSERT INTO laps(droneid) VALUES("+str(id)+");")

    # SQL insert
    def sql(self, time, lon, lat, speed, alt):
        TIME = time 
        LONG = lon
        LAT = lat
        SPEED = speed
        ALT = alt
        LAP = "(SELECT MAX(id) FROM laps WHERE droneid = "+str(id)+")"
        QUERY = "INSERT INTO location(timestamp, longitude, latitude, speed, altitude, lap) VALUES(\'%s\',%s,%s,%s,%s,%s);"\
            %(TIME,LONG,LAT,SPEED, ALT, LAP)
        print QUERY
        s.sendline (QUERY)

    def die(self):
        s.logout

# init a connection to database
c = Connection()
c.setup()

# Listen on port 2947 (gpsd) of localhost
session = gps.gps("localhost", "2947")
# magic
session.stream(gps.WATCH_ENABLE | gps.WATCH_NEWSTYLE)

c.start_new_lap()

# continously transmit data to the database
while True:
    time = None
    lon = None
    lat = None
    speed = None
    alt = None
    try:
        # fetch point from gps
        report = session.next()
        
        # Wait for a 'TPV' report and display the current time
        # To see all report data, uncomment the line below
        # print report
        if report['class'] == 'TPV':
            if hasattr(report, 'time'):
                time =  report.time
        if report['class'] == 'TPV':
            if hasattr(report, 'lon'):
                lon =  report.lon
        if report['class'] == 'TPV':
            if hasattr(report, 'lat'):
                lat =  report.lat
        if report['class'] == 'TPV':
            if hasattr(report, 'speed'):
                speed = report.speed * gps.MPS_TO_KPH
        if report['class'] == 'TPV':
            if hasattr(report, 'alt'):
                alt = report.alt

    except KeyError:
                pass

    # used to end a lap
    except KeyboardInterrupt:
                c.sql('-1', -1, -1, -1, -1) #send a control query to indicate stop of lap
                quit()

    # handling of GPSD termination
    except StopIteration:
                session = None
                print "GPSD has terminated"
    c.sql(time, lon, lat, speed, alt)

c.die()
