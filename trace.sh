echo 'Usage: trace.sh <binary with debug symbols> <output containing backtrace>'

grep -o '{"backtrace.*$' $2 > trace
python ~/code/mongo/buildscripts/mongosymb.py --symbolizer-path=/usr/bin/llvm-symbolizer-3.6 $1 < trace
