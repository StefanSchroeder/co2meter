#!/bin/bash

echo "Hello co2meter"

git clone https://github.com/StefanSchroeder/co2meter.git

cd co2meter

make hwconfig pre fetch install

echo "Done"



