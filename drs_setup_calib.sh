#! /bin/sh

#rcdaq_client daq_end
#rcdaq_client daq_shutdown
#sleep 5

# this makes this easily copied to another place, just change this definition
export AREA=$HOME/drs_setup

if ! rcdaq_client daq_status > /dev/null 2>&1 ; then

    echo "No rcdaq_server running, starting..."
    rcdaq_server > $AREA/rcdaq.log 2>&1 & 
    sleep 2

    ELOG=$(which elog 2>/dev/null)
    [ -n "$ELOG" ]  && rcdaq_client elog localhost 8082 RCDAQLog
fi

if ! rcdaq_client daq_status -l | grep -q "DRS Plugin" ; then 

    echo "Loading the plugin..."
    rcdaq_client load librcdaqplugin_drs.so
fi

# we need the $0 as absolute path b/c we pass it on to a "file" device further down
D=`dirname "$0"`
B=`basename "$0"`
MYSELF="`cd \"$D\" 2>/dev/null && pwd || echo \"$D\"`/$B"
CURRDIR=`pwd`

# we make the run numbers persistent
rcdaq_client daq_setrunnumberfile $AREA/.last_rcdaq_runnumber.txt

# add the appropriate sub-area for your data
rcdaq_client daq_define_runtype junk      /home/uiuc/data/junk/junk_%08d-%04d.prdf
rcdaq_client daq_define_runtype pedestals /home/uiuc/data/pedestals/pedestal_%08d-%04d.prdf
rcdaq_client daq_define_runtype run          /home/uiuc/data/run/run_%08d-%04d.prdf
rcdaq_client daq_define_runtype calibration  /home/uiuc/data/calibration/calibration_%08d-%04d.prdf

# we are starting out with "junk"
rcdaq_client daq_setruntype junk

# we clear any existing readlists
rcdaq_client daq_clear_readlist

# we add this very file to the begin-run event

###############################
# Some commands
###############################

# this script captures one frame off the webcams in $CURRDIR/snapshotN.jpg
rcdaq_client create_device device_command 9 0 $CURRDIR/cam_capture.sh

# this script gets temperature reading from rpi
rcdaq_client create_device device_command 9 0 $CURRDIR/get_temps.sh

###############################
# Add packets to data stream
###############################

# add thhis very script tp packet 900
rcdaq_client create_device device_file 9 900 "$MYSELF"

# begining of run
# add the snaphot picure to packet 940
 rcdaq_client create_device device_file 9 940  $CURRDIR/snapshot1.jpg 256
# add the snaphot picure to packet 941
 rcdaq_client create_device device_file 9 941  $CURRDIR/snapshot2.jpg 256

# add the temperature to packet 910 (for human) and 911 (ascii)
 rcdaq_client create_device device_file 9 910  $CURRDIR/temps.dat
 rcdaq_client create_device device_filenumbers 9 911  $CURRDIR/temps.dat

# end of run
# add the snaphot picure to packet 940
# rcdaq_client create_device device_file 12 942  $CURRDIR/snapshot1.jpg 256
# add the snaphot picure to packet 941
#rcdaq_client create_device device_file 12 943  $CURRDIR/snapshot2.jpg 256

# add the temperature to packet 912 (for human) and 913 (ascii)
# rcdaq_client create_device device_file 12 912  $CURRDIR/temps.dat
# rcdaq_client create_device device_filenumbers 12 913  $CURRDIR/temps.dat


###############################
# Add commands
###############################

# this script adds the same snapshot and temp to "Run started" elog entry 
rcdaq_client create_device device_command 9 0 "$CURRDIR/add_all_to_start_elog.sh"
# this script adds the same snapshot and temp to "Run end" elog entry 
# rcdaq_client create_device device_command 12 0 "$CURRDIR/add_all_to_end_elog.sh"

###############################
# Read actual data
###############################

# and finally, the readout of the DRS4
rcdaq_client create_device device_drs_by_serialnumber -- 1 1001 2703 0x21 -1 n 500 1 0 1024 200
rcdaq_client create_device device_drs_by_serialnumber -- 1 1002 2702 0x10 24 p 500 1 0 1024 200
rcdaq_client create_device device_drs_by_serialnumber -- 1 1003 2550 0x10 20 p 500 1 0 1024 200
rcdaq_client create_device device_drs_by_serialnumber -- 1 1004 2539 0x10 20 p 500 1 0 1024 200



#rcdaq_client create_device device_drs -- 1 1001 0x21 -7 n 400 1 0 1024 


#for low gain set baseline at 250 
#delay as 798
# 0x21 == ch 1 trigger, 0x28 == ch 4 trigger
# Argument list: eventtype, subeventid, trigger, triggerthreshold = -0.2, const int slope = 0 (0,1 or N,P), const int delay = 0, const int speed = 0, const int start = 0, nch   = 0, const int baseline center = 0

rcdaq_client daq_list_readlist

# rcdaq_client daq_set_maxbuffersize 16
# rcdaq_client daq_status -l





