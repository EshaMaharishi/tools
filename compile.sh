set -e

# regular parallel compile
#time scons -j 24 core

# compile with gdbserver
#time scons --allocator=system --opt=off --gdbserver -j 24 core

# compile with address sanitizer
ASAN_SYMBOLIZER_PATH=$(which llvm-symbolizer) time scons --allocator=system --opt=off --sanitize=address -j 24 core

printf "last compile on branch\n`git branch`\nwith changed files\n`git diff --name-only master`\nwith diff from master\n`git diff master`" > esha/last_compile
