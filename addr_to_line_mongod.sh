sed -e 's/.*#//g' $1 | sed -e 's/ (.*//g' | sed -e 's/.* 0x/0x/g' > addrs_extracted_mongod
addr2line -e mongod < addrs_extracted_mongod 
