#!/usr/bin/env python3

import sys
import html

for line in sys.stdin:
    sys.stdout.write(html.escape(line))
