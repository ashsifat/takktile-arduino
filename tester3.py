#!/usr/bin/env python
import serial, time
try:
    i=0
    p1x=0
    p1y=0
    p2x=80
    p2y=0
    p3x=80
    p3y=140
    p4x=0
    p4y=140
    p5x=40
    p5y=50
    copx=[]
    copy=[]
    arduino = serial.Serial('/dev/ttyACM0', 115200)
    print "Connection successful"
    while True:
        data = arduino.readline()
        if data:
            try:
		print "data", data
                values = [float(j) for j in data.split(",") if len(j) > 2]
                print "values", values
		if values[4]:
			data1= 50200-values[0]
			data2= 53200-values[1]
			data3= 28000-values[2]
			data4= 57500-values[3]
			data5= 58300-values[4]
			print "data1", data1
			print "data2", data2
			print "data3", data3
			print "data4", data4
			print "data5", data5
			force= data1/41.83 +data2/37.95 + data3/74.07 + data4/60.91 + data5/37.01
			print "force:", force
			force1= data1/41.83
			force2= data2/37.95
			force3= data3/74.07
			force4= data4/60.91
			force5= data5/37.01
			cx=(force1*p1x+force2*p2x+force3*p3x+force4*p4x+force5*p5x)/force
			cy=(force1*p1y+force2*p2y+force3*p3y+force4*p4y+force5*p5y)/force
			copx.append(cx)
			copy.append(cy)
		print "x:", copx
		print "y:", copy
		
#50100.0, 53000.0, 28100.0, 57500.0, 58300.0
		
#		if values[0]>20000:
#			print "done"
#		else :
#			print "none"
            except ValueError:
                print "invalid string:"
               
		
            i+=1
except:
    "Connection failed"
