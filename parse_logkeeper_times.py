from __future__ import print_function

import collections
import datetime
import re
import os.path
import sys

import dateutil.parser

startPattern = re.compile(r" (?P<time>[0-9\-T:\.\+Z]+) Running (?P<testname>[\w\.:]+)\.\.\.$")
endPattern = re.compile(r" (?P<time>[0-9\-T:\.\+Z]+) Writing output of [A-z]+ (?P<testname>[\w\./:]+) to [\w\./:]+\.$")

def main(filename):
    start = collections.defaultdict(list)
    end = collections.defaultdict(list)

    with open(filename, "r") as fp:
        for line in fp:
            start_match = startPattern.search(line)
            end_match = endPattern.search(line)

            if start_match is not None:
                start_time = dateutil.parser.parse(start_match.group("time"))
                start[start_match.group("testname")].append(start_time)

            if end_match is not None:
                end_time = dateutil.parser.parse(end_match.group("time"))
                end[os.path.basename(end_match.group("testname"))].append(end_time)

    total_time = datetime.timedelta()
    num_tests = 0

    for testname in end:
        end_times = end[testname]
        if testname not in start:
            print("Didn't find log message for %s starting" % (testname))
            continue
        start_times = start[testname]
        for (start_time, end_time) in zip(start_times, end_times):
            time_spent = end_time - start_time
            if time_spent.total_seconds() > 30:
                print("Getting test id for %s was really slow %s, start=%s, end=%s" %
                      (testname, time_spent, start_time, end_time))
            total_time += time_spent
            num_tests += 1

    print()
    print("Getting test ids from logkeeper took %0.1f seconds on average" %
          (total_time.total_seconds() / float(num_tests)))

    print("%s was spent getting test ids across all jobs in total" % (total_time))

if __name__ == "__main__":
    main(sys.argv[1])
