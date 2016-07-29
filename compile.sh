# exit script on error
set -e

# if target passed as argument, use that, else default to building core
target="core"
if [ "$#" -eq 1 ]; then
    target=$1
fi
echo 'compiling ' $target

# path to scons script
scons_script="/home/eshamaharishi/code/mongo/buildscripts/scons.py"

# scons options
scons_jobs="-j 24"
scons_clang="CC=$(which clang) CXX=$(which clang++)" 
scons_gcc="CC=/opt/mongodbtoolchain/v2/bin/gcc CXX=/opt/mongodbtoolchain/v2/bin/g++"
scons_dynamic="--link-model=dynamic"
scons_no_opt="--opt=off"
scons_asan="--allocator=system --sanitize=address" 
scons_gdbserver="--gdbserver"

# environment options
env_asan="ASAN_SYMBOLIZER_PATH=$(which llvm-symbolizer-3.6)"

################################# compile permutations ###################################

# static compile with gcc (for debugging with gdb)
#time python $scons_script $scons_jobs $scons_gcc $scons_no_opt $target

# static compile with clang (for debugging with gdb)
#time python $scons_script $scons_jobs $scons_gcc $scons_no_opt $target

# static compile with gdbserver (gcc)
#time python $scons_script $scons_jobs $scons_gcc $scons_no_opt $scons_gdbserver $target

# static compile with gdbserver (clang)
#time python $scons_script $scons_jobs $scons_clang $scons_no_opt $scons_gdbserver $target

# dynamic compile with gcc
#time python $scons_script $scons_jobs $scons_gcc $scons_no_opt $scons_dynamic $target

# dynamic compile with clang
time python $scons_script $scons_jobs $scons_clang $scons_no_opt $scons_dynamic $target

# dynamic compile with address sanitizer (only works with clang)
#ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer-3.6 time python $scons_script $scons_jobs $scons_clang $scons_no_opt $scons_dynamic $scons_asan $target

if [ $target="core" ]; then
    echo "last core compile on branch\n`git branch`\nwith changed files\n`git diff --name-only master`\nwith diff from master\n`git diff master`" > esha/last_compile
fi

##########################################################################################

####### how to compile a library directly with dynamic linker #######
#target = \$BUILD_DIR/mongo/s/libcluster_last_error_info.so

# demangler
#python mongosymb.py --symbolizer-path=$(which llvm-symbolizer-3.6) <path/to/executable> < trace
