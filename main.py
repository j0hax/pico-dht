import json
import errno
from utime import sleep
import _thread

from lib.dht import DHT11
from machine import Pin, ADC

# Address the onboard LED
led = Pin("LED", Pin.OUT)

# Address the DHT22 Module
sensor = DHT11(Pin(15, Pin.IN, Pin.PULL_UP))

# Address the onboard temperature diode
sensor_diode = ADC(4)

# Reference voltage divided by ADC resolution
conversion_factor = 3.3 / (1 << 16)

# Synchronization control
baton = _thread.allocate_lock()

# Our Data dict
data = dict()

def measure_onboard() -> float:
    """Measures temperature using a diode on the RP2040.
    The calculated temperature may fluctuate with the reference voltage.
    For more information see section 4.9.5 of the RP2040 documentation.
    """
    voltage = sensor_diode.read_u16() * conversion_factor
    c = 27 - (voltage - 0.706) / 0.001721
    return round(c)


def measure() -> dict:
    """Measures DHT and onboard temperature values.
    In case of any I/O errors, the errno field will be set.
    """
    led.on()
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


def report():
    """Designed to run on the RP2040s second core.
    Its job is to update the data dict at a periodic rate.
    While measuring, the onboard LED will be turned on.
    """
    global data
    while True:
        led.on()
        baton.acquire()
        data = measure()
        baton.release()
        led.off()
        sleep(1)

_thread.start_new_thread(report, ())

sleep(2)
while True:
    sleep(0.1)
    baton.acquire()
    print(json.dumps(data))
    baton.release()
