
##
## GLOBALS for use by build, test, run etc scripts
##
MAJOR=3
MINOR=2
BUGFIX=3
TESTPORT=9909
# $$ at the end will add a random number to the server
TESTSERVER=qgis-server-test$$
URL=http://localhost:${TESTPORT}/
PROJECT=`pwd`/../project-qgis3
TESTIMAGE=/tmp/test$$.jpg

