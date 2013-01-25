#!/usr/bin/env python
import serial, time
try:
    i=0
    arduino = serial.Serial('/dev/tty.usbmodem1411', 9600)
    print "Connection successful"
    while True:
        data = arduino.readline()
        if data:
            try:
                values = [float(j) for j in data.split(" ") if len(j) > 2]
                print values
            except ValueError:
                print "invalid string:"
                print data
            i+=1
except:
    "Connection failed"
