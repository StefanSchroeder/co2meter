#!/bin/bash

echo "$0: Hello"

git clone https://github.com/StefanSchroeder/co2meter.git

cd co2meter

make hwconfig pre build install

echo "$0: Done"



