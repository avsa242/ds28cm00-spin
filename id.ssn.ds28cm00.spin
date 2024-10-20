{
----------------------------------------------------------------------------------------------------
    Filename:       id.ssn.ds28cm00.spin
    Description:    Driver for the DS28CM00 64-bit I2C Silicon Serial Number
    Author:         Jesse Burt
    Started:        Oct 27, 2019
    Updated:        Oct 19, 2024
    Copyright (c) 2024 - See end of file for terms of use.
----------------------------------------------------------------------------------------------------

    NOTE: This chip responds to the same slave address as the EEPROM on a Propeller 1 board.
    If it is placed on the same bus, it is likely to cause communication issues due to the conflict
}

CON

    { default I/O settings; these can be overridden in the parent object }
    SCL         = 0
    SDA         = 1
    I2C_FREQ    = 100_000
    I2C_ADDR    = 0


    SLAVE_WR    = core.SLAVE_ADDR
    SLAVE_RD    = core.SLAVE_ADDR|1

    BUS_I2C     = 0
    BUS_SMBUS   = 1


OBJ

{ decide: Bytecode I2C engine, or PASM? Default is PASM if BC isn't specified }
#ifdef DS28CM00_I2C_BC
    i2c:    "com.i2c.nocog"                     ' BC I2C engine
#else
    i2c:    "com.i2c"                           ' PASM I2C engine
#endif
    core:   "core.con.ds28cm00"                 ' HW-specific constants
    time:   "time"                              ' timekeeping methods
    crcs:   "math.crc"                          ' CRC routines


PUB null()
' This is not a top-level object


PUB start(): status
' Start using default I/O settings
    return startx(SCL, SDA, I2C_FREQ)


PUB startx(SCL_PIN, SDA_PIN, I2C_HZ): status
' Start the driver with custom I/O settings
'   SCL_PIN:    I2C clock, 0..31
'   SDA_PIN:    I2C data, 0..31
'   I2C_HZ:     I2C clock speed (max official specification is 400_000 but is unenforced)
'   Returns:
'       cog ID+1 of I2C engine on success (= calling cog ID+1, if the bytecode I2C engine is used)
'       0 on failure
    if ( lookdown(SCL_PIN: 0..31) and lookdown(SDA_PIN: 0..31) )
        if ( status := i2c.init(SCL_PIN, SDA_PIN, I2C_HZ) )
            time.usleep(core.T_POR)
            if ( dev_id() == core.DEVID_RESP )  ' verify this is actually a DS28CM00
                return
    ' if this point is reached, something above failed
    ' Double check I/O pin assignments, connections, power
    ' Lastly - make sure you have at least one free core/cog
    return FALSE


PUB stop()
' Stop the driver
    i2c.deinit()


PUB bus_mode(): m
' Get bus mode
'   Returns: BUS_I2C (0) or BUS_SMBUS(1)
    mode := 0
    readreg(core.CTRL_REG, 1, @m)


PUB bus_set_mode(mode)
' Set bus mode to I2C or SMBus
'   Valid values: BUS_I2C (0) or BUS_SMBUS(1)
    cmd_pkt.byte[0] := SLAVE_WR
    cmd_pkt.byte[1] := core.CTRL_REG
    cmd_pkt.byte[2] := (BUS_I2C #> mode <# BUS_SMBUS)

    i2c.start()
    i2c.wrblock_lsbf(@cmd_pkt, 3)
    i2c.stop()


PUB crc(): c
' Read the CRC byte from the chip
' NOTE: The CRC is of the first 56-bits of the ROM (8 bits Device Family Code + 48 bits Serial Number)
    readreg(core.CRC, 1, @c)


PUB crc_valid(): v | tmp[2]
' Test CRC returned from chip for equality with calculated CRC
'   Returns TRUE if CRC is valid, FALSE otherwise
    tmp := 0
    readreg(core.DEV_FAMILY, 7, @tmp)
    return ( crc() == crcs.dallas_maxim_crc8(@tmp, 7) )


PUB dev_id(): id
' Reads the Device ID (Family Code)
'   Returns $70
    id := 0
    readreg(core.DEV_FAMILY, 1, @id)


PUB serial_num(ptr_buff)
' Reads the unique 64-bit serial number into buffer at address ptr_buff
' NOTE: This buffer must be 8 bytes in length.
    readreg(core.DEV_FAMILY, 8, ptr_buff)


PRI readreg(reg_nr, nr_bytes, ptr_buff) | cmd_pkt
' Read nr_bytes from the slave device into ptr_buff
    case reg_nr
        core.DEV_FAMILY..core.CTRL_REG:
        other:
            return

    cmd_pkt.byte[0] := SLAVE_WR
    cmd_pkt.byte[1] := reg_nr

    i2c.start()
    i2c.wrblock_lsbf(@cmd_pkt, 2)
    i2c.start()
    i2c.write(SLAVE_RD)
    i2c.rdblock_lsbf(ptr_buff, nr_bytes, i2c.NAK)
    i2c.stop()


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

