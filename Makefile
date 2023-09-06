install:
	mkdir -p /usr/local/bin/
	#
	install scd30forever /usr/local/bin
	install scd30-show.py /usr/local/bin
	#
	install scd30.service /etc/systemd/system/
	install scd30-show.service /etc/systemd/system/
	#
	systemctl enable scd30.service 
	systemctl enable scd30-show.service 

hwconfig:
	/boot/dietpi/func/dietpi-set_hardware spi enable
	/boot/dietpi/func/dietpi-set_hardware i2c enable
	echo "After changing this HW setting, a reboot is required."

createdb:
	echo "CREATE TABLE scd30 (v1 REAL, v2 REAL, v3 REAL, t DATETIME DEFAULT CURRENT_TIMESTAMP)" | sqlite3 /var/run/scd30.db

pre:
	apt install -y vim git sqlite3 libsqlite3-dev build-essential libfreetype6-dev libjpeg-dev 
	/boot/dietpi/dietpi-software install 130 
	pip3 install -U luma.led_matrix 

fetch:
	git clone https://github.com/Sensirion/raspberry-pi-i2c-scd30 scd30
	echo "apply patch and build"

stop:
	systemctl stop scd30-show.service
	systemctl stop scd30.service
restart:
	systemctl restart scd30-show.service
	systemctl restart scd30.service
status:
	systemctl status scd30
	systemctl status scd30-show

show:
	sqlite3 "/var/run/scd30.db" "select * from scd30" | awk 'BEGIN { FS="|" }; {print $$4, $$1, $$2 }' > /tmp/result.dat
	tail /tmp/result.dat

