#!/usr/bin/env bash

USER='cn=nagios,ou=sa,o=services'
PASS='n0v3ll'

# with heartbeat monitoring
#CHECKS='--caw 300 --cac 1800 --csw 500000 --csc 100000 --hbw 300 --hbc 600 --tjw 300 --tjc 600'

# only driver state and cache
#CHECKS='--caw 300 --cac 1800 --csw 500000 --csc 10000000'
CHECKS='--caw 300 --cac 1800'

LOGFILE='./check_dxml_drvstate.log'
echo > $LOGFILE

#LDAPTLS_REQCERT=never
#export LDAPTLS_REQCERT

# Get a list of all DXML drivers from the eDir
lstAllDrivers=$(LDAPTLS_REQCERT=never ldapsearch -x -H ldaps://127.0.0.1:1636 -D $USER -w $PASS '(objectClass=DirXML-Driver)' 1.1 | grep -o cn=.*)

for DRIVER in $lstAllDrivers; do
    #./check_dxml_drvstate --username $USER --password $PASS --edirport 1524 --ldapport 1636 --ldapmode SSL --logfile $LOGFILE -vv --driver $DRIVER $CHECKS
    ./check_dxml_drvstate --username "$USER" --password "$PASS" --edirport 1524 --driver "$DRIVER $CHECKS" --short --perfdata
    printf '..%s..' "Status is $? (0=OK, 1=WARNING, 2=CRITICAL)\n"
done