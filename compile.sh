set -e

scons_opts_default="CC=$(which clang) CXX=$(which clang++) -j 24 --mute"
scons_opts_asan="--allocator=system --opt=off --sanitize=address" 
scons_opts_gdb="--allocator=tcmalloc --opt=off --gdbserver"

env_opts_asan="ASAN_SYMBOLIZER_PATH=$(which llvm-symbolizer-3.6)"

#########################################
### by default compile core with ASAN  ###
#########################################
if [ "$#" -ne 1 ]; then

    
    # regular compile
    #echo 'compiling core'
    #time scons $scons_opts_default core

    # compile with gdbserver
    #echo 'compiling core with debug symbols and gdbserver'
    #time scons $scons_opts_default $scons_opts_gdb core

    # compile with address sanitizer
    echo 'compiling core with ASan'
    $env_opts_scons time scons $scons_opts_default $scons_opts_asan core

    echo "last core compile on branch\n`git branch`\nwith changed files\n`git diff --name-only master`\nwith diff from master\n`git diff master`" > esha/last_compile

fi

#############################################################
### compile the specific target given on the command line ###
#############################################################
if [ "$#" -eq 1 ]; then

    echo 'compiling' $1 'with ASAN'
    $env_opts_scons time scons $scons_opts_default $scons_opts_asan $1

    #echo 'compiling' $1 'with debug symbols'
    #time scons $scons_opts_default $scons_opts_gdb $1

fi

####### how to compile a library directly with dynamic linker #######
#time scons $scons_opts_default --link-model=dynamic \$BUILD_DIR/mongo/s/libcluster_last_error_info.so

