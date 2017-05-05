set -e

#############################################################
### compile the specific target given on the command line ###
#############################################################
if [ "$#" -eq 1 ]; then

scons -j 24 --tree=derived $1

fi
