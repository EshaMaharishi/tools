sed -e 's/.*#//g' $1 | tee | sed -e 's/ (.*//g'  | tee | sed -e 's/.* //g' > addrs_extracted 
