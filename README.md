# ds28cm00-spin 
---------------

This is a P8X32A/Propeller driver object for the Maxim DS28CM00 I2C/SMBus Silicon Serial Number.

## Salient Features

* Operates at up to 400kHz
* Reads the 8-bit family code
* Reads the 48-bit serial number
* Reads the 8-bit CRC

## Requirements

* Requires 1 extra core/cog for the PASM I2C driver

## Limitations

* Has the same slave address as commonly available EEPROMs, so care is needed to ensure you're reading from the SSN and not your EEPROM, as the driver _will_ start and read bytes successfully from it as though it were the SSN chip! Disable your EEPROM somehow, or put this chip on a different set of I/O pins.
* Doesn't calculate the CRC of the serial number on the Propeller to verify the CRC that's read from the chip.
* Can toggle the CM bit of the control register between SMBus or I2C mode, but doesn't actually handle anything differently.

## TODO

* Implement CRC verification
* Implement separate version that uses SPIN I2C driver. Depending on users' needs, the PASM I2C driver may be overkill
