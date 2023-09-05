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

createdb:
	echo "CREATE TABLE scd30 (v1 REAL, v2 REAL, v3 REAL, t DATETIME DEFAULT CURRENT_TIMESTAMP)" | sqlite3 /var/run/scd30.db

fetch:
	git clone https://github.com/Sensirion/raspberry-pi-i2c-scd30
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

