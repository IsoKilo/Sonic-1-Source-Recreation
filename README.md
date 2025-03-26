# Sonic 1 Source Recreation

An attempt at recreating Sonic 1's source code by means of extrapolating information from other ports/sequels.

---

![build - incomplete](https://img.shields.io/static/v1?label=build&message=incomplete&color=C00000)

![progress - 10%](https://img.shields.io/static/v1?label=progress&message=10%&color=C00000)

This recreation is made with a revision 01 ROM of Sonic the Hedgehog disassembled in IDA Pro version 7.0. With some code also integrated from the prototype of Sonic the Hedgehog.

## Progress

| Status | Goal |
| -------- | -------- |
| Mostly complete | Uncover information about source code and pin labels and details to ROM and code. |
| In progress | Disassemble the ROM using original labels and equates. |
| Not started | Export disassembly into source files. |
| Not started | Touch up details that couldn't be done in IDA. (Macros, comments, etc.) |
| Not started | Build a functional ROM under a simulated development environment in DOS with X68k. |
| Not started | Incorporate prototype code and data. |

### Side Goals

* Replicate full development environment. (Digitizer, Sound Source Editor, CMM, serial port demo recorder)
* Build bit-perfect ROM.
* Make branches for building revision 0 and prototype ROMs.
* Port to C.

## Resources

Check the [project wiki](https://github.com/IsoKilo/Sonic-1-Source-Recreation/wiki) for all resources on Sonic 1's source code.

## Disclaimer

Repository maintainers do not claim ownership of any code or data presented. This project is maintained for educational use only, commercial use is strictly prohibited.
