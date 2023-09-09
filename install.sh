#!/bin/bash

echo "Hello co2meter"

sh <(curl -L https://raw.githubusercontent.com/StefanSchroeder/co2meter/main/install.sh)

git clone https://github.com/StefanSchroeder/co2meter.git

cd co2meter
make hwconfig pre fetch install

echo "Done"



