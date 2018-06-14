#!/bin/csh

foreach time (`seq 1 3 20`)
    source get_temps.sh
    date >> temperature.log
    cat temps.dat >> temperature.log
    sleep 1800
end
exit
