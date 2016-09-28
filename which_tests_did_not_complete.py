import sys
import re
from urllib2 import urlopen, Request


if (len(sys.argv) < 2):
    print("Usage: which_tests_did_not_complete.py <file or url>")
    sys.exit(0)

filename = sys.argv[1]

def handle(filename):
    if filename.startswith("http://") or filename.startswith("https://"):
        request = Request(filename, headers={"Accept" : "text/plain"})
        response = urlopen(request)
        for line in response:
            yield line
    else:
        with open(filename) as f:
            for line in f:
                yield line


started_tests = []
completed_tests = []

for line in handle(filename):
    m = re.search("Running .*\.js", line)
    if m:
        started_tests.append(m.group(0)[len("Running "):])

    m = re.search("0000 .* ran in", line)
    if m:
        completed_tests.append(m.group(0)[5:-7])

print("tests that started but did not complete:")
print(list(set(started_tests) - set(completed_tests)))

