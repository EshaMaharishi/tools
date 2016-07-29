sed -e 's/.*#//g' $1 | sed -e 's/ (.*//g' | sed -e 's/.* 0x/0x/g' > addrs_extracted_mongos
addr2line -e mongos < addrs_extracted_mongos 
