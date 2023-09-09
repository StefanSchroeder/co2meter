pre:
	apt install -y vim git sqlite3 libsqlite3-dev build-essential libfreetype6-dev libjpeg-dev 
	/boot/dietpi/dietpi-software install 130 
	/usr/local/bin/pip3 install -U luma.led_matrix 

hwconfig:
	/boot/dietpi/func/dietpi-set_hardware spi enable
	/boot/dietpi/func/dietpi-set_hardware i2c enable
	echo "After changing this HW setting, a reboot is required."

fetch:
	git clone https://github.com/Sensirion/raspberry-pi-i2c-scd30 scd30
	pushd scd30 && git apply ../scd.patch && make

install:
	mkdir -p /usr/local/bin/
	install scd30readshow.service /etc/systemd/system/
	install scd30.sh /usr/local/bin
	install scd30readshow.py /usr/local/bin
	install scd30/scd30_i2c_example_usage /usr/local/bin/scd30forever
	systemctl enable scd30readshow.service 
	systemctl start scd30readshow.service 

createdb:
	echo "CREATE TABLE scd30 (v1 REAL, v2 REAL, v3 REAL, t DATETIME DEFAULT CURRENT_TIMESTAMP)" | sqlite3 /scd30.db

# everything below is tooling

show:
	sqlite3 "/scd30.db" "select * from scd30" | awk 'BEGIN { FS="|" }; {print $$4, $$1, $$2 }' > /tmp/result.dat
	tail /tmp/result.dat

