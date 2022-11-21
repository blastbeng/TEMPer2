#!/bin/bash
# 
# By: Sheila S. Wilson
# Get the temperature from a USB Temper Thermometer
#
# Original from: https://funprojects.blog/2021/05/02/temper-usb-temperature-sensor
#   Archived as: https://archive.fo/nrR0r
#   
#   find the HID device from the kernel msg via dmesg
#   parse the line get HID device
#get the hidraw device from the string
hid=$(echo "/dev/hidraw1")
exec 5<> $hid
# send out query msg
echo -e '\x00\x01\x80\x33\x01\x00\x00\x00\x00\c' >&5
# get binary response
#  OUT=$(dd count=1 bs=8 <&5 2>/dev/null | xxd -p)
OUT=$(dd count=2 bs=8 <&5 2>/dev/null | xxd -p)
# characters 5-8 is the device temp in hex x1000
DHEX4=${OUT:4:4}
DDVAL=$((16#$DHEX4))
DCTEMP=$(bc <<< "scale=2; $DDVAL/100")
#  echo "Device: $DCTEMP"

# characters 20-23 is the probe temp in hex x1000
PHEX4=${OUT:20:4}
PDVAL=$((16#$PHEX4))
PCTEMP=$(bc <<< "scale=2; $PDVAL/100")
#  echo "Probe: $PCTEMP" 

# Output the temperature in JSON format
#echo "{ \"Device\" : \"$DCTEMP\" , \"Probe\" : \"$PCTEMP\" }" 

echo $PCTEMP
