#!/usr/bin/env python
import serial, time, lcm
from takktile import takktile_t
lc = lcm.LCM()
try:
    i=0
    arduino = serial.Serial('/dev/tty.usbmodem1411', 9600)
    print "Connection successful"
    while True:
        data = arduino.readline()
        if data:
            try:
                values = [float(j) for j in data.split(" ") if len(j) > 2]
                msg = takktile_t()
                msg.numSensors = len(values)/2
                msg.temperature = values[::2]
                msg.pressure = values[1::2]
                lc.publish("takktile",msg.encode())
                print values
            except ValueError:
                print "invalid string:"
                print data
            #f.write(data)
            i+=1
except:
    "Connection failed"
