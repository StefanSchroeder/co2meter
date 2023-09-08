#!/usr/bin/env python3

# This python script fetches the last record from a SQLite db
# that was written by another script.
# Next is is shown on the MAX7219 display statically, until it
# gets re-written.

# Every SLEEP_SECS we cycle between temperature [in °C] and CO2 level [in ppm].

import time
import sqlite3
import subprocess
import sys

SLEEP_SECS = 15.0

from luma.led_matrix.device import max7219
from luma.core.interface.serial import spi, noop
from luma.core.render import canvas
from luma.core.legacy import text, show_message
from luma.core.legacy.font import proportional, CP437_FONT, TINY_FONT

DB = '/scd30.db'

def get_last_values(index):
    sqConn = sqlite3.connect(DB)
    cursor = sqConn.cursor()
    read_table = """SELECT v1, v2, v3, t from 'scd30' ORDER BY t DESC LIMIT 1;"""
    cursor.execute(read_table)
    records = cursor.fetchall()
    lastValue = 0
    for row in records:
        lastValue = row[index]
    
    cursor.close()
    sqConn.close()
    return lastValue

def main():
    serial = spi(port=0, device=0, gpio=noop())
    device = max7219(serial, cascaded=4, block_orientation=-90, blocks_arranged_in_reverse_order=False)
    device.contrast(16)

    while True:
        for i in (0, 1):
            with canvas(device) as draw:
                text(draw, (0,0), str(get_last_values(i)), fill="white", font=proportional(CP437_FONT))
            time.sleep(SLEEP_SECS)

if __name__ == "__main__":
    main()

def subcall_stream(cmd, fail_on_error=True):
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, bufsize=1, universal_newlines=True)
    for line in p.stdout:
        sys.stdout.write(line)
    p.wait()
    exit_code = p.returncode
    if exit_code != 0 and fail_on_error:
        raise RuntimeError(f"Shell command failed with exit code {exit_code}. Command: `{cmd}`")
    return(exit_code)


