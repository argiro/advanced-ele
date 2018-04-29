
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       readSerial.py
# [Project]        Advanced Electronics Laboratory course [FINAL LAB PROJECT]
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Python/ROOT
# [Created]        May  5, 2017
# [Modified]       May 23, 2017
# [Description]    Python script to read dark-count data from FPGA through USB/UART RS-232 serial
#                  interface. Uses ROOT components to monitor "on-line" recorded count values. 
#
# [Notes]          Execute the script with
#
#                     linux% python -i readSerial.py
#
# [Version]        1.0
# [Revisions]      05.05.2017 - Created
#-----------------------------------------------------------------------------------------------------


## components from Python STL
import sys
import time
import math

## from Python serial library
import serial


## ROOT
import ROOT

ROOT.gROOT.SetStyle("Plain")


## create a ROOT TGraph object to keep "on-line" track of measured data

Npt = 1

graph = ROOT.TGraphErrors(Npt)

graph.SetMarkerStyle(21)
graph.SetMarkerSize(1.0)

graph.SetTitle("Counts vs. run number")


period = 7.0

counts = 0

rate = 0.000

xError = 0.0
yError = 0.0




## create a new RS-232 connection and configure transaction parameters
## (baud-rate, optional parity, number of stop-bits and optional software/hardware flow controls)

if(len(sys.argv) == 2) :
	portName = sys.argv[1]
else :
	portName = "/dev/ttyUSB1"



s = serial.Serial()

s.port      = portName                 # target port for connection
s.baudrate  = 9600                     # Baud rate
s.bytesize  = serial.EIGHTBITS         # number of payload bits per byte
s.parity    = serial.PARITY_NONE       # enable/disable parity check
s.stopbits  = serial.STOPBITS_ONE      # number of stop bits
s.timeout   = None                     # timeout in seconds
s.xonoff    = False                    # enable/disable software flow control
s.rtscts    = False                    # enable/disable RTS/CTS hardware flow control
s.dsrdtr    = False                    # enable/disable DSR/DTR hardware flow control 


## open the connection
print "Trying to open serial connection to", s.name, "..."


try :
	s.open()

	graph.Draw("AP")

	ROOT.gPad.SetGridx()
	ROOT.gPad.SetGridy()
	ROOT.gPad.Modified()
	ROOT.gPad.Update()

	print "Successfully connected to", s.name , "\n"
	print "Type Ctrl-C to quit the script"

except serial.SerialException as error :

	raise SystemExit("**ERROR: Cannot open serial connection to %s" % s.name)


## write the content of the incoming serial stream to a plain-text ASCII file

f = open("./data.dat","w")


## iterator over runs
index = 1


print "\nRun\t Counts\t Rate [Hz]\n"

## loop until a Ctrl-C interrupt is issued at the command line
while(1) :

	try :
		rx_data = s.read(9)

		counts = int(rx_data)
        	rate = counts/period

		yError = math.sqrt(counts)

		print "%d\t %d\t %f" % (index, counts, rate)

		## plot the point with Posson error
		graph.SetPoint(index-1, index, counts )
		graph.SetPointError(index-1, xError, yError)

		## update the canvas
		ROOT.gPad.Modified()
		ROOT.gPad.Update()

		## write data to text file
		f.write("%s\t" % index)
		f.write("%s\n" % counts)

		index = index + 1

		#if( index > Npt ) :
		#	graph.Expand(index)


	## catch a Ctrl-C interrupt to safely exit from the while loop
	except KeyboardInterrupt :

		print "\nBye!\n"
		break


## save the plot into a ROOT file

fout = ROOT.TFile("data.root", "RECREATE")

graph.Write()
fout.Close()

## close the pointer to text file
f.close()


## close the serial port connection when done
s.close()
