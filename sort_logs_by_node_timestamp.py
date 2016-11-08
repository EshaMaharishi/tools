#!/usr/bin/env python
import sys
import re

if (len(sys.argv) < 2):
    print("Usage: sort_logs_by_process_timestamp.py <raw_logs> > <ordered_logs>")
    sys.exit(0)

filename = sys.argv[1]

timestamp_to_line = {}
lines_without_timestamps = []

with open(filename) as f:
    content = f.readlines();

for line in content:

    # If the line was logged by a mongod or mongos node, use the inner timestamp after the node descriptor (e.g., "c23014|").
    # Example line:
    # [js_test:remove3] 2016-11-07T19:01:39.980+0000 c23014| 2016-11-07T19:01:39.979+0000 D REPL     [rsBackgroundSync] Cannot select sync source because it is not up: ip-10-152-38-201:23012
    m = re.search("\| .*\+0000 . ", line)
    if m:
        timestamp_to_line[m.group(0)[2:-3]] = line
        continue

    # If the line was logged by a mongo shell process, user the inner timestamp after the outer timestamp.
    # Example line:
    # [js_test:remove3] 2016-11-07T19:01:39.998+0000 2016-11-07T19:01:39.996+0000 I NETWORK  [thread1] reconnect ip-10-152-38-201:23012 (10.152.38.201) failed failed
    m = re.search("0000 .*\+0000 . ", line)
    if m:
        timestamp_to_line[m.group(0)[5:-3]] = line
        continue

    # Otherwise, use the outer timestamp.
    # Example line:
    # [js_test:remove3] 2016-11-07T19:01:42.411+0000 ReplSetTest stop *** Shutting down mongod in port 23012 ***
    m = re.search("201.*\+0000 ", line)
    if m:
        timestamp_to_line[m.group(0)] = line
        continue

    # Save any lines that we could not find timestamps in for reporting later.
    lines_without_timestamps.append(line)

# Sort the lines by our chosen timestamps.
sorted_timestamps = sorted(timestamp_to_line)

# Print the lines ordered by our chosen timestamps to *stdout*.
for timestamp in sorted_timestamps:
    sys.stdout.write(timestamp_to_line[timestamp])

# Report any lines that we could not find timestamps in to *stderr*.
sys.stderr.write("\n*** The following lines did not include timestamps, and were not included in the output: ***\n")
for line in lines_without_timestamps:
    sys.stderr.write("\n> " + line)
sys.stderr.write("\n")
