# ds28cm00-spin 
---------------

This is a P8X32A/Propeller, P2X8C4M64P/Propeller 2 driver object for the Maxim DS28CM00 I2C/SMBus Silicon Serial Number.

## Salient Features

* I2C connection at up to 400kHz
* Reads the 8-bit family code
* Reads the entire 64-bit serial number
* Reads the 8-bit CRC
* Can verify the CRC returned from the chip

## Requirements

* PASM version: Requires 1 extra core/cog for the PASM I2C driver
* SPIN version: none
* P2: N/A

## Compiler compatibility

- P1/Spin1: OpenSpin (tested with 1.00.81)
- P2/Spin2: FastSpin (tested with 4.0.3-beta)

## Limitations

* Has the same slave address as commonly available EEPROMs, so care is needed to ensure you're reading from the SSN and not your EEPROM, as the driver _will_ start and read bytes successfully from it as though it were the SSN chip! Disable your EEPROM somehow, or put this chip on a different set of I/O pins.
* Can toggle the CM bit of the control register between SMBus or I2C mode, but doesn't actually handle anything differently.

## TODO

- [x] Implement CRC verification
- [x] Implement separate version that uses SPIN (P1 bytecode version) I2C driver. Depending on users' needs, the PASM I2C driver may be overkill
