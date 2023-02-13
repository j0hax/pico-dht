# dht22
Digital temperature and humidity reporting for the Raspberry Pi Pico

Used to continuously monitor a server room at the Campus Maschinenbau Garbsen.

## Install
Standard DHT drivers were [migrated](https://github.com/micropython/micropython/pull/9220) to `micropython-lib` starting with MicroPython 1.19, so most tutorials on the internet regarding this sensor no longer work!

The only dependency at the moment is [dht](https://github.com/micropython/micropython-lib/blob/master/micropython/drivers/sensor/dht/dht.py), which can be installed OTA by modifying and executing `setup.py` on an internet-connected Pi Pico.

## Usage
This project aims to provide an efficient and flexible temperature and humidity monitor over **serial**. Unfortunately, WPA2-EAP Networks such as eduroam are not supported very well by MicroPython at the moment.

On most Linux hosts, the Pi Pico will be available under `/dev/ttyACM0`, where it will report humidity and temperature as a JSON object, ready to be processed by other programs such as Nagios. The reading processes may need to part of the `dialout` group.

### Connection Errors
If the devices are not soldered and knocked around, a connection may become flaky and a GPIO error can occur. POSIX errnos are reported in the `error` attribute.
