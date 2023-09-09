hwconfig:
	/boot/dietpi/func/dietpi-set_hardware spi enable
	/boot/dietpi/func/dietpi-set_hardware i2c enable
	echo "After changing this HW setting, a reboot is required."

pre:
	apt install -y vim git build-essential libfreetype6-dev libjpeg-dev 
	/boot/dietpi/dietpi-software install 130 
	/usr/local/bin/pip3 install -U luma.led_matrix 

fetch:
	git clone https://github.com/Sensirion/raspberry-pi-i2c-scd30 scd30
	#cd scd30 && git apply ../scd.patch && make

install:
	mkdir -p /usr/local/bin/

	install scd30.sh /usr/local/bin
	install scd30readshow.py /usr/local/bin
	install scd30/scd30_i2c_example_usage /usr/local/bin/scd30forever

	install scd30readshow.service /etc/systemd/system/
	systemctl enable scd30readshow.service 
	systemctl start scd30readshow.service 

