set -e

### compile core with ASAN by default
if [ "$#" -ne 1 ]; then

echo 'compiling core'

# regular parallel compile
#CC=$(which clang) CXX=$(which clang++) time scons -j 24 --quiet core

# compile with gdbserver
#CC=$(which clang) CXX=$(which clang++) time scons --allocator=system --quiet --opt=off --gdbserver -j 24 core

# compile with address sanitizer
CC=$(which clang) CXX=$(which clang++) ASAN_SYMBOLIZER_PATH=$(which llvm-symbolizer) time scons  --quiet --allocator=system --opt=off --sanitize=address -j 24 core

printf "last core compile on branch\n`git branch`\nwith changed files\n`git diff --name-only master`\nwith diff from master\n`git diff master`" > esha/last_compile

fi

### compile the specific target given on the command line
if [ "$#" -eq 1 ]; then
echo 'compiling ' $1
CC=$(which clang) CXX=$(which clang++) ASAN_SYMBOLIZER_PATH=$(which llvm-symbolizer) time scons --allocator=system --opt=off --sanitize=address -j 24 $1 
fi
