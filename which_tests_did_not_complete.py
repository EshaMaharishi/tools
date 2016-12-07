#!/usr/bin/env python
import sys
import re

if (len(sys.argv) < 2):
    print("Usage: which_tests_did_not_complete.py <task_logs.txt>")
    sys.exit(0)

filename = sys.argv[1]

started_tests = []
completed_tests = []
test_logs = {}

with open(filename) as f:
    content = f.readlines();

for line in content:

    # jstests
    m = re.search("Running .*\.js", line)
    if m:
        started_tests.append(m.group(0)[len("Running "):])

    m = re.search("0000 .* ran in", line)
    if m:
        completed_tests.append(m.group(0)[5:-7])

    m = re.search("Writing output of JSTest jstests.+[\\\\/](\w+\.js) to (http.*/)\.", line)
    if m:
        test_logs[m.group(1)] = m.group(2)

    # hooks
    m = re.search("Starting Hook (\w+:\w+) under executor \w+\.\.\.", line)
    if m:
        started_tests.append(m.group(1))

    m = re.search("Writing output of Hook (\w+:\w+) to (http.*/)\.", line)
    if m:
        test_logs[m.group(1)] = m.group(2)

    m = re.search("Hook (\w+:\w+) finished\.", line)
    if m:
        completed_tests.append(m.group(1))

    # unittests
    m = re.search("Running .*\.\.\.", line)
    if m:
        started_tests.append(m.group(0)[len("Running "):-3])

    m = re.search("0000 .* ran in", line)
    if m:
        completed_tests.append(m.group(0)[5:-7])

    m = re.search("Writing output of Program (.*) to (http.*/)\.", line)
    if m:
        testName = m.group(1)
        test_logs[testName.split('/')[-1:][0]] = m.group(2)

print("tests that started but did not complete:")
for t in list(set(started_tests) - set(completed_tests)):
    print t, test_logs.get(t, '(log url not available)')
