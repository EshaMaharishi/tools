sed -e 's/.*#//g' $1 | sed -e 's/ (.*//g' | sed -e 's/.* //g' > addrs_extracted
addr2line -e mongos < addrs_extracted 
