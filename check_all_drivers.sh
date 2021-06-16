USER=cn=nagios,ou=sa,o=services
PASS=n0v3ll

# with heartbeat monitoring
#CHECKS='--caw 300 --cac 1800 --csw 500000 --csc 100000 --hbw 300 --hbc 600 --tjw 300 --tjc 600'

# only driver state and cache
#CHECKS='--caw 300 --cac 1800 --csw 500000 --csc 10000000'
CHECKS='--caw 300 --cac 1800'

LOGFILE='./check_dxml_drvstate.log'
echo > $LOGFILE

LDAPTLS_REQCERT=never
export LDAPTLS_REQCERT

for DRIVER in `ldapsearch -x -H ldaps://127.0.0.1:1636 -D $USER -w $PASS '(objectClass=DirXML-Driver)' 1.1 | grep -o cn=.*`; do
    #./check_dxml_drvstate --username $USER --password $PASS --edirport 1524 --ldapport 1636 --ldapmode SSL --logfile $LOGFILE -vv --driver $DRIVER $CHECKS
    ./check_dxml_drvstate --username $USER --password $PASS --edirport 1524 --driver $DRIVER $CHECKS --short --perfdata
    echo "Status is $? (0=OK, 1=WARNING, 2=CRITICAL)"
    echo
done

