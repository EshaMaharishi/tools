set -e

# regular parallel compile
#CC=$(which clang) CXX=$(which clang++) time scons -j 24 --quiet core

# compile with gdbserver
#CC=$(which clang) CXX=$(which clang++) time scons --allocator=system --quiet --opt=off --gdbserver -j 24 core
#CC=$(which clang) CXX=$(which clang++) time scons --allocator=system --quiet --opt=off --gdbserver -j 24 build/opt/mongo/db/s/metadata_test

# compile with address sanitizer
#CC=$(which clang) CXX=$(which clang++) ASAN_SYMBOLIZER_PATH=$(which llvm-symbolizer) time scons  --quiet --allocator=system --opt=off --sanitize=address -j 24 core

CC=$(which clang) CXX=$(which clang++) ASAN_SYMBOLIZER_PATH=$(which llvm-symbolizer) time scons  --quiet --allocator=system --opt=off --sanitize=address -j 24 unittests

printf "last compile on branch\n`git branch`\nwith changed files\n`git diff --name-only master`\nwith diff from master\n`git diff master`" > esha/last_compile
