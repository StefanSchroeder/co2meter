# co2meter

A Raspberry Pi project to build a CO₂-meter.

Idea: Making sure that there isn't too much carbon dioxide in your
room doesn't stop to make sense just because the epidemic is (mostly)
over. 

We are building a CO₂-meter using 

* a *Raspberry Pi Zero W* single-board minicomputer,
* an LCD display to show the measured values,
* a Sensirion-SCD30 CO₂-sensor to capture the CO₂ values.

## Parts lists

The presented links are not endorsements, just references to the 
type of product that we will use. Buy local!

* Dot Matrix *MAX7219* (4 in 1 Dot Matrix Green) 
  (example brands include AptoFun and Noyito).

* *SCD30*  CO2 SENSOR I2C/MODBUS/PWM DIGITL 
  https://www.digikey.de/short/m9mfn9f1

* Any Raspberry Pi. We will be using a Raspberry Pi Zero W, the Wifi-version,
  to avoid the necessity of attaching a monitor and keyboard.

## Operating system installation

We will use the DietPi Linux distribution, install it on a SD-card and connect
to it over the network using SSH.

Follow the installation instructions here: https://dietpi.com/docs/install/

Things to note: 

* SSH is enabled by default.
* If you don't connect a screen, you need some way to determine the IP-address,
 refer to the dietpi documentation.
* The default *root* user has the default password *dietpi*. 
* The hostname is *dietpi*.

After writing the image file to the SD-card, mount the card and edit 
the files *dietpi.txt* and *dietpi-wifi.txt* to match your setup and network. 
The only entries that I changed were:

In *dietpi-wifi.txt*:

* aWIFI_SSID[0]='MySpecificWifiName'
* aWIFI_KEY[0]='MySuperSecretPassword'

In *dietpi.txt*:

* AUTO_SETUP_KEYBOARD_LAYOUT=de
* AUTO_SETUP_NET_WIFI_ENABLED=1
* AUTO_SETUP_NET_WIFI_COUNTRY_CODE=DE
* AUTO_SETUP_TIMEZONE=Europe/Berlin

Sync the SD-card and eject.

Boot the Raspberry-Pi, find it on the network using the methods described
on page https://dietpi.com/docs/install/.

After first boot we will guided through a wizard to do some housekeeping.

* Change some software installation password. Select 'Cancel'
* Change password for *root* and *dietpi*. Yes, that's a good idea.
* Disable UART/serial.

Go to *dietpi-config*.

Go to *Advanced-options*.

Enable *I2C state* from Off to On.

Enable *SPI state* from Off to On.

Proceed to install the 'minimal-image'.

Then we install a few standard tools.

	apt install vim git build-essential

Reboot the Pi 

	reboot


## The SCD30

### Wiring

Connect the CO2 sensor to the Raspberry Pi.

SCD30  |  RPi
---------------------
VNN 1  |  1 3.3V 
GND 2  |  6 GND
SCL 3  |  5 SCL / GPIO 3 
SDA 4  |  3 SDA / GPIO 2

https://www.raspberrypi.com/documentation/computers/images/GPIO-Pinout-Diagram-2.png

https://developer.sensirion.com/images/sensirion-tutorial-sensirionblegadget-1-6f.jpg

+-------------+
|1234oooxxxx  |
|             |
+-------------+

Visit the Github project

	https://github.com/Sensirion/raspberry-pi-i2c-scd30

and follow the installation instructions, which are essentially:

	git clone https://github.com/Sensirion/raspberry-pi-i2c-scd30
	cd rasp*
	make

Now running

	root@DietPi:~/raspberry-pi-i2c-scd30# ./scd30_i2c_example_usage

Should yield:

	co2_concentration: 540.31 temperature: 24.19 humidity: 48.64 
	co2_concentration: 549.35 temperature: 24.19 humidity: 48.60 
	co2_concentration: 553.16 temperature: 24.20 humidity: 48.59 
	co2_concentration: 545.07 temperature: 24.20 humidity: 48.57

for a couple of screens.

We are using this example program as a starting point for our sensor recorder.
We'll patch the example to write the values to a SQLite database located
at */var/run/scd30.db*. 

We install the dependencies for SQLite3:

	apt install -y libsqlite3-dev sqlite3

Let's first initialize the database:

	sqlite3 /var/run/scd30.db
	CREATE TABLE scd30 ( v1 REAL, v2 REAL, v3 REAL, t DATETIME DEFAULT CURRENT_TIMESTAMP);
	.quit

We now have an empty SQLite database with the right schema.

	patch XXX


# Display

## Wiring

(Taken from: https://max7219.readthedocs.io/en/0.2.3/)

| Board Pin  | Name  | Remarks  | RPi Pin  | RPi Function | 
-------------------------------------------------------
|1  | VCC  | +5V Power  | 2  | 5V0
|2  | GND  | Ground  | 6  | GND
|3  | DIN  | Data In  | 19  | GPIO 10 (MOSI)
|4  | CS  | Chip Select  | 24  | GPIO 8 (SPI CE0)
|5  | CLK  | Clock  | 23  | GPIO 11 (SPI CLK)

Reference: https://dietpi.com/forum/t/running-an-led-dot-matrix-8x32-max7219-on-diet-pi/5518

	dietpi-software install 130 
	apt install build-essential libfreetype6-dev libjpeg-dev 
	pip3 install -U luma.led_matrix 
	cd /tmp
	curl -sSfLO https://github.com/rm-hull/luma.led_matrix/archive/refs/heads/master.tar.gz
	tar xf master.tar.gz
	rm master.tar.gz
	mv luma.led_matrix-master /mnt/dietpi_userdata/luma.led_matrix
	cd /mnt/dietpi_userdata/luma.led_matrix

The python-script *scd30-show.py* reads the latest value from the SQLite database and 
displays them on the matrix display.

We install two services to make sure that the two services are started upon reboot.

One for *reading* of the values from the SCD30 sensor and writing them to a SQLite db.

	install scd30.service /etc/systemd/system/

One for *reading* the values from the SQlite db and setting them on the matrix display.

	install scd30-show.service /etc/systemd/system/

We enable and start the services.

	systemctl enable scd30.service 
	systemctl enable scd30-show.service 
	
