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

fetch:
	git clone http://github.com/StefanSchroeder/co2meter.git
	git clone https://github.com/Sensirion/raspberry-pi-i2c-scd30
stop:
	systemctl stop scd30-show.service
	systemctl stop scd30.service
start:
	systemctl restart scd30-show.service
	systemctl restart scd30.service
status:
	systemctl status scd30
	systemctl status scd30-show

show:
	sqlite3 "/var/run/scd30.db" "select * from scd30" | awk 'BEGIN { FS="|" }; {print $$4, $$1, $$2 }' > /tmp/result.dat

