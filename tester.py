#!/usr/bin/env python
import serial, time
f=open("asdf.csv", "w")
try:
    i=0
    arduino = serial.Serial('/dev/tty.usbmodem1411', 9600)
    print "Connection successful"
    while True:
        data = arduino.readline()
        if data:
            print str(i) + " " + data
            f.write(data)
            i+=1
except:
    print "Connection failed"
f.close()
