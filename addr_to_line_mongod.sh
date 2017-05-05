sed -e 's/.*+//g' $1 | sed -e 's/)//g' > addrs_extracted_mongod
addr2line -e mongod < addrs_extracted_mongod 
