# ds28cm00-spin 
---------------

This is a P8X32A/Propeller, P2X8C4M64P/Propeller 2 driver object for the Maxim DS28CM00 I2C/SMBus Silicon Serial Number.

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.


## Salient Features

* I2C connection at up to 400kHz
* Reads the 8-bit family code
* Reads the entire 64-bit serial number
* Reads the 8-bit CRC
* Can verify the CRC returned from the chip


## Requirements

P1/SPIN1:
* spin-standard-library
* 1 extra core/cog for the PASM I2C engine (none if bytecode engine used)

P2/SPIN2:
* p2-spin-standard-library


## Compiler Compatibility

| Processor | Language | Compiler               | Backend      | Status                |
|-----------|----------|------------------------|--------------|-----------------------|
| P1        | SPIN1    | FlexSpin (6.9.4)       | Bytecode     | OK                    |
| P1        | SPIN1    | FlexSpin (6.9.4)       | Native/PASM  | OK                    |
| P2        | SPIN2    | FlexSpin (6.9.4)       | NuCode       | Untested              |
| P2        | SPIN2    | FlexSpin (6.9.4)       | Native/PASM2 | OK                    |

(other versions or toolchains not listed are __not supported__, and _may or may not_ work)


## Limitations

* Has the same slave address as commonly available EEPROMs, so care is needed to ensure you're reading from the SSN and not your EEPROM, as the driver may read bytes successfully from it as though it were the SSN chip! Disable your EEPROM somehow, or put this chip on a different set of I/O pins.
* Can toggle the CM bit of the control register between SMBus or I2C mode, but doesn't actually handle anything differently.

