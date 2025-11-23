# We enable the hardware interfaces SPI and I2C.
hwconfig:
	/boot/dietpi/func/dietpi-set_hardware spi enable
	/boot/dietpi/func/dietpi-set_hardware i2c enable

# We fetch some tools and everything necessary for building 
# the programs.
pre:
	apt install -y vim git build-essential libfreetype6-dev libjpeg-dev libopenjp2-7-dev libtiff6 libxcb1
	/boot/dietpi/dietpi-software install 130 
	/usr/local/bin/pip3 install -U luma.led_matrix spidev

# This is the SCD30-software sample for Raspberry-Pi.
# We use the example from this repo and patch it tweak it for 
# our needs.
# We checkout an older version.
build:
	git clone https://github.com/Sensirion/raspberry-pi-i2c-scd30 scd30
	cd scd30 && git checkout 66cac334b2820581d8c334e013d39b658ea70f3b && git apply ../scd.patch && make

install: 
	mkdir -p /usr/local/bin/

	install scd30.sh /usr/local/bin
	install scd30readshow.py /usr/local/bin
	install scd30/scd30_i2c_example_usage /usr/local/bin/scd30forever

	install scd30readshow.service /etc/systemd/system/
	systemctl enable scd30readshow.service 
	systemctl start scd30readshow.service 

