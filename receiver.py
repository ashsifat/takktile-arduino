#!/usr/bin/env python
import lcm
from takktile import takktile_t
def handler(channel, data):
    msg = takktile_t.decode(data)
    print "%d sensors:" % msg.numSensors
    for i in range(msg.numSensors):
        print "%f %f" % (msg.pressure[i], msg.temperature[i])
lc = lcm.LCM()
subscription = lc.subscribe("takktile", handler)
try:
    while True:
        lc.handle()
except KeyboardInterrupt:
    pass
lc.unsubscribe(subscription)
