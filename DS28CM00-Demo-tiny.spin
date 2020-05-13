{
    --------------------------------------------
    Filename: DS28CM00-Demo-tiny.spin
    Author: Jesse Burt
    Description: Demo of the DS28CM00 64-bit ROM ID chip (SPIN-only version)
    Copyright (c) 2020
    Started Oct 27, 2019
    Updated Feb 7, 2020
    See end of file for terms of use.
    --------------------------------------------
    NOTE: The driver will start successfully if the Propeller's EEPROM is on
        the chosen I2C bus and return data from the EEPROM! Make sure the EEPROM is
        somehow disabled or test the chip using different I/O pins.
}

CON

    _clkmode    = cfg#_clkmode
    _xinfreq    = cfg#_xinfreq

    LED         = cfg#LED1
    SER_RX      = 31
    SER_TX      = 30
    SER_BAUD    = 115_200

    SCL_PIN     = 26
    SDA_PIN     = 27

OBJ

    cfg     : "core.con.boardcfg.flip"
    ser     : "com.serial.terminal"
    time    : "time"
    io      : "io"
    ssn     : "tiny.identification.ssn.ds28cm00.i2c"

VAR

    byte _ser_cog
    byte _sn[8]

PUB Main | i

    Setup
    ser.NewLine
    ser.Str (string("Device Family: $"))
    ser.Hex (ssn.DeviceFamily, 2)
    ser.Str (string(ser#NL, ser#LF, "Serial Number: $"))
    ssn.SN (@_sn)
    repeat i from 0 to 7
        ser.Hex (_sn.byte[i], 2)
    ser.Str (string(ser#NL, ser#LF, "CRC: $"))
    ser.Hex (ssn.CRC, 2)
    ser.Str (string(", Valid: "))
    case ssn.CRCValid
        TRUE: ser.Str (string("Yes"))
        FALSE: ser.Str (string("No"))
    ser.Str (string(ser#NL, ser#LF, "Halting"))
    FlashLED (LED, 100)

PUB Setup

    repeat until ser.StartRXTX(SER_RX, SER_TX, 0, SER_BAUD)
    time.MSleep(30)
    ser.Clear
    ser.Str(string("Serial terminal started", ser#NL, ser#LF))
    if ssn.Startx (SCL_PIN, SDA_PIN)
        ser.Str (string("DS28CM00 driver started", ser#NL, ser#LF))
    else
        ser.Str (string("DS28CM00 driver failed to start - halting", ser#NL, ser#LF))
        ssn.Stop
        time.MSleep (5)
        ser.Stop
        FlashLED(LED, 500)

#include "lib.utility.spin"

DAT
{
    --------------------------------------------------------------------------------------------------------
    TERMS OF USE: MIT License

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
    associated documentation files (the "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
    following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial
    portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
    LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    --------------------------------------------------------------------------------------------------------
}