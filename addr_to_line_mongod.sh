sed -e 's/.*#//g' $1 | sed -e 's/ (.*//g' | sed -e 's/.* //g' > addr2line -e mongod 
