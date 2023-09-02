# co2meter

A Raspberry Pi project to build a CO₂-meter.

Idea: Making sure that there isn't too much carbondioxid in your
room doesn't stop to make sense just because the epidemic is (mostly)
over. 

We are building a CO₂-meter using 

* a Raspberry Pi single-board minicomputer,
* an LCD display to show the measured values,
* a Sensirion-SCD30 CO₂-sensor.

## Parts lists

The presented links are not endorsements, just references to the 
type of product that we will use. Buy local!

* Dot Matrix *MAX7219* (4 in 1 Dot Matrix Green) 
  (example brands include AptoFun and Noyito).

* *SCD30*  CO2 SENSOR I2C/MODBUS/PWM DIGITL 
  https://www.digikey.de/short/m9mfn9f1

Use the search on the https://www.digikey.de website if you are in Germany.

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
* The default *root* user has the default password *dietpi*. Change the password at the earliest opportunity.


