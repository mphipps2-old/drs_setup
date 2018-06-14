#! /bin/sh

CURRDIR=`pwd`

echo "adding images and temps"
[ -f $CURRDIR/snapshot1.jpg ] || exit
[ -f $CURRDIR/snapshot2.jpg ] || exit
[ -f $CURRDIR/temps.dat ] || exit
 
if elog -h localhost -p 8082 -l RCDAQLog -w last | grep -q "Run.*started" 
then
    # we get the last entry id
    LASTID=$(elog -h localhost -p 8082 -l RCDAQLog -w last | head -n 1 | awk '{print $NF}')
    
    echo "added image and temps to elog"
    elog -h localhost -p 8082 -l RCDAQLog -e $LASTID -f $CURRDIR/temps.dat -f $CURRDIR/snapshot1.jpg -f $CURRDIR/snapshot2.jpg > /dev/null 2>&1

fi

