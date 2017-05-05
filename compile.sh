# exit this script on error
set -e

# if target passed as argument, use that, else default to building core
target="core"
if [ "$#" -eq 1 ]; then
    target=$1
fi
echo 'compiling ' $target

# path to scons script
scons_script="./buildscripts/scons.py"

# scons options
scons_jobs="-j$(grep -c ^processor /proc/cpuinfo)"
#scons_clang="CC=$(which clang) CXX=$(which clang++)" 
scons_clang="--variables-files=etc/scons/mongodbtoolchain_clang.vars"
#scons_gcc="CC=/opt/mongodbtoolchain/v2/bin/gcc CXX=/opt/mongodbtoolchain/v2/bin/g++"
scons_gcc="--variables-files=etc/scons/mongodbtoolchain_gcc.vars"
scons_dynamic="--link-model=dynamic"
scons_no_opt="--opt=off"
scons_asan="--allocator=system --sanitize=address" 
scons_gdbserver="--gdbserver"
scons_debug="--dbg=on"

################################# compile permutations ###################################

# echo "static compile with gcc (for debugging with gdb)"; time python $scons_script $scons_jobs $scons_gcc $scons_debug $scons_no_opt $target

# echo "static compile with clang (for debugging with gdb)"; time python $scons_script $scons_jobs $scons_gcc $scons_no_opt $target

# echo "static compile with gcc with --gdbserver"; time python $scons_script $scons_jobs $scons_gcc $scons_no_opt $scons_gdbserver $target

# echo "static compile with clang with --gdbserver"; time python $scons_script $scons_jobs $scons_clang $scons_no_opt $scons_gdbserver --ssl $target 

# echo "dynamic compile with gcc"; time python $scons_script $scons_jobs $scons_gcc $scons_no_opt $scons_dynamic $target

# echo "dynamic compile with gcc with rocksdb"; time python $scons_script $scons_jobs $scons_gcc $scons_noo_opt $scons_dynamic --ssl CPPPATH="$(echo ~/code/rocksdb/include/) /usr/local/include/" LIBPATH="$(echo ~/code/rocksdb/) /usr/local/lib/" $target

# echo "dynamic compile with clang"; time python $scons_script $scons_jobs $scons_clang $scons_no_opt $scons_dynamic $target

#echo "dynamic compile with clang with address sanitizer (only works with clang)"; ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer-3.8 time python $scons_script $scons_jobs $scons_clang $scons_no_opt $scons_dynamic $scons_asan $scons_dbg  $target


# build asan.ninja
#echo "build ninja for static compile with clang with address sanitizer (only works with clang)"; /opt/mongodbtoolchain/v2/bin/python2 ./buildscripts/scons.py --variables-files=etc/scons/mongodbtoolchain_clang.vars CCFLAGS='-Wa,--compress-debug-sections -gsplit-dwarf' MONGO_VERSION='0.0.0' MONGO_GIT_HASH='unknown' VARIANT_DIR=ninja --modules=ninja --opt=on --dbg=on --allocator=system --sanitize=address --nostrip --config=force asan.ninja

# run with asan.ninja
echo "static compile with clang with address sanitizer"; ninja -f asan.ninja $target

if [ $target="core" ]; then
    echo "last core compile on branch\n`git branch`\nwith changed files\n`git diff --name-only master`\nwith diff from master\n`git diff master`" > esha/last_compile
fi

##########################################################################################

####### how to compile a library directly with dynamic linker #######
#target = \$BUILD_DIR/mongo/s/libcluster_last_error_info.so

# demangler
#python mongosymb.py --symbolizer-path=$(which llvm-symbolizer-3.6) <path/to/executable> < trace
