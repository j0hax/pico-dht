from time import sleep
import network

nic = network.WLAN(network.STA_IF)
nic.active(True)
nic.connect("SSID", "PASSWORD")

while not nic.isconnected():
    print("Waiting for connection...")
    sleep(3)

import mip

mip.install("dht")
