{
----------------------------------------------------------------------------------------------------
    Filename:       DS28CM00-Demo.spin
    Description:    Demo of the DS28CM00 64-bit ROM ID chip
    Author:         Jesse Burt
    Started:        Oct 27, 2019
    Updated:        Oct 19, 2024
    Copyright (c) 2024 - See end of file for terms of use.
----------------------------------------------------------------------------------------------------

    NOTE: If a common EEPROM (e.g. AT24Cxxxx) is on the same I2C bus as the SSN,
        the driver may return data from it instead of the SSN. Make sure the EEPROM is
        somehow disabled or test the SSN using different I/O pins.
}

CON

    _clkmode    = xtal1+pll16x
    _xinfreq    = 5_000_000


OBJ

    time:   "time"
    ser:    "com.serial.terminal.ansi" | SER_BAUD=115_200
    ssn:    "id.ssn.ds28cm00" | SCL=0, SDA=1, I2C_FREQ=100_000


VAR

    byte _sn[8]


PUB main() | i

    setup()
    ssn.serial_num(@_sn)

    ser.printf1(@"Device family: $%02.2x\n\r", ssn.dev_id())
    ser.printf8(@"Serial number: %02.2x%02.2x%02.2x%02.2x%02.2x%02.2x%02.2x%02.2x\n\r", ...
                _sn[7], _sn[6], _sn[5], _sn[4], _sn[3], _sn[2], _sn[1], _sn[0])
    ser.printf1(@"CRC: %02.2x", ssn.crc())

    if ( ssn.crc_valid() )
        ser.strln(@" (good)")
    else
        ser.strln(@" (bad)")

    repeat


PUB setup()

    ser.start()
    time.msleep(30)
    ser.clear()
    ser.strln(@"Serial terminal started")

    if ( ssn.start() )
        ser.strln(@"DS28CM00 driver started")
    else
        ser.strln(@"DS28CM00 driver failed to start - halting")
        repeat


DAT
{
Copyright 2024 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

