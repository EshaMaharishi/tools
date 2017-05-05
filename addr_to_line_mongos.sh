sed -e 's/.*+//g' $1 | sed -e 's/)//g' > addrs_extracted_mongos
addr2line -e mongos < addrs_extracted_mongos 
