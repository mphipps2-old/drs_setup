ssh rpi 'cd temps && python get_temps.py' #> /dev/null 2>&1
scp rpi:temps/temps.dat .                 #> /dev/null 2>&1
