
## components from Python STL
import sys

## from Python serial library
import serial


## create a new RS-232 connection and configure transaction parameters
## (baud-rate, optional parity, number of stop-bits and optional software/hardware flow controls)

if(len(sys.argv) == 2) :
	portName = sys.argv[1]
else :
	portName = "/dev/ttyUSB1"
	#portName = "COM10"


s = serial.Serial()

s.port     = portName
s.baudrate = 9600
s.bytesize = serial.EIGHTBITS
s.parity   = serial.PARITY_NONE
s.stopbits = serial.STOPBITS_ONE
s.timeout  = None
s.xonoff   = False
s.rtscts   = False
s.dsrdtr   = False


s.open()

#s.write('\0') ;   ## wite all-zeroes NULL character i.e. 0x00
s.write('\x00') ;  ## this is equivalent, jusdt use HEX byte code

s.close()
