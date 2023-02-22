import json
import errno

from lib.dht import DHT22
from machine import Pin, ADC


led = Pin("LED", Pin.OUT)
sensor = DHT22(Pin(15, Pin.IN, Pin.PULL_UP))

sensor_temp = ADC(4)
conversion_factor = 3.3 / (1 << 16)


def measure_onboard() -> float:
    voltage = sensor_temp.read_u16() * conversion_factor
    c = 27 - (voltage - 0.706) / 0.001721
    return round(c, 1)


def measure() -> dict:
    t = 0
    h = 0
    o = 0
    err = 0

    try:
        sensor.measure()
        t = sensor.temperature()
        h = sensor.humidity()
        o = measure_onboard()
    except OSError as exc:
        err = exc.errno

    return {"temperature": t, "onboard": o, "humidity": h, "error": err}


def report(t):
    led.on()
    data = measure()
    print(json.dumps(data))
    led.off()


from machine import Timer

tim = Timer()
tim.init(period=3000, mode=Timer.PERIODIC, callback=report)
