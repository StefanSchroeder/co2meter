#!/usr/bin/env python3

# This python script fetches the last record from a SQLite db
# that was written by another script.
# Next is is shown on the MAX7219 display statically, until it
# gets re-written.

import time
import subprocess
import sys

from luma.led_matrix.device import max7219
from luma.core.interface.serial import spi, noop
from luma.core.render import canvas
from luma.core.legacy import text, show_message
from luma.core.legacy.font import proportional, CP437_FONT, TINY_FONT

serial = spi(port=0, device=0, gpio=noop())
device = max7219(serial, cascaded=4, block_orientation=-90, blocks_arranged_in_reverse_order=False)
device.contrast(16)

p = subprocess.Popen("/usr/local/bin/scd30.sh", stdout=subprocess.PIPE, stderr=subprocess.STDOUT, bufsize=1, universal_newlines=True)
index=1
for line in p.stdout:
    x = line.split()
    with canvas(device) as draw:
        text(draw, (0,0), str(x[index]), fill="white", font=proportional(CP437_FONT))
    index = index + 2
    index = index % 4
p.wait()
exit_code = p.returncode
if exit_code != 0 and fail_on_error:
    raise RuntimeError(f"Shell command failed with exit code {exit_code}. Command: `{cmd}`")
