#!/usr/bin/env python
import sys
import re

if (len(sys.argv) < 2):
    print("Usage: which_tests_did_not_complete.py <task_logs.txt>")
    sys.exit(0)

filename = sys.argv[1]

started_tests = []
completed_tests = []

with open(filename) as f:
    content = f.readlines();

for line in content:

    # started
    m = re.search("S. Test : (.*) ...", line)
    if m:
        started_tests.append(m.group(1))

    # completed
    m = re.search("S. Test : (.*) .*ms", line)
    if m:
        completed_tests.append(m.group(1))

print("tests that started but did not complete:")
for t in list(set(started_tests) - set(completed_tests)):
    print t
