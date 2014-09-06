#!/usr/bin/env io

Vehicle := Object clone
Vehicle description := "Something to take you far away"

Car := Vehicle clone
ferrari := Car clone

Car slotNames println           # list(type)
ferrari slotNames println       # list()

Car description println         # Something to take you far away
ferrari description println     # Something to take you far away

ferrari proto println           # Car_0x19bcb80: type = "Car"
Car     proto println           # Vehicle_0x19c9f10: description = "Something..." type = "Vehicle"
Vehicle proto println           # Object_0x17c1a10: type = Object_type() .....
Object  proto println           # Object_17e5720: Car = Car_0x19bcb80 Vehicle = Vehicle_0x19c9f10 Protos = xxx Lobby = xxxx ....
