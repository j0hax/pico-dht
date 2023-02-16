import json
import errno

from lib.dht import DHT22
from machine import Pin

sensor = DHT22(Pin(15, Pin.IN, Pin.PULL_UP))


def measure() -> dict:
    t = 0
    h = 0
    err = 0

    try:
        sensor.measure()
        t = sensor.temperature()
        h = sensor.humidity()
    except OSError as exc:
        err = exc.errno

    return {"temperature": t, "humidity": h, "error": err}


def report(t):
    data = measure()
    print(json.dumps(data))


from machine import Timer

tim = Timer()
tim.init(period=5000, mode=Timer.PERIODIC, callback=report)
