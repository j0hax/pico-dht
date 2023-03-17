import json
import errno

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


def measure_onboard() -> float:
    """Measures temperature using a diode on the RP2040.
    The calculated temperature may fluctuate with the reference voltage.
    For more information see section 4.9.5 of the RP2040 documentation.
    """
    voltage = sensor_diode.read_u16() * conversion_factor
    c = 27 - (voltage - 0.706) / 0.001721
    return round(c, 1)


def measure() -> dict:
    """Measures DHT22 and onboard temperature values.
    In case of any I/O errors, the errno field will be set.
    """
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
    """Measures data and prints it as JSON to serial.
    While measuring, the onboard LED will be turned on.
    """
    led.on()
    data = measure()
    print(json.dumps(data))
    led.off()


from machine import Timer

tim = Timer()
tim.init(period=3000, mode=Timer.PERIODIC, callback=report)
