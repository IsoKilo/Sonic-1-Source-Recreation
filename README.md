# Sonic 1 Source Recreation

An attempt at recreating Sonic 1's source code by means of extrapolating information from other ports/sequels.

---

![build - incomplete](https://img.shields.io/static/v1?label=build&message=incomplete&color=C00000)

![progress - 5%](https://img.shields.io/static/v1?label=progress&message=5%&color=C00000)

This recreation is made with a revision 01 ROM of Sonic the Hedgehog disassembled in IDA Pro version 7.0. With some code also integrated from the prototype of Sonic the Hedgehog.

## Data Resources

* [SEGA Mega Drive Hard Initial Program](https://drive.google.com/file/d/1HUr01ejGtCrN2KQa6t99y1c2N2wRj08_/view)
* [Sound Source  68k Source Code](https://hiddenpalace.org/File:Sega_of_Japan_Mega_Drive_Sound_Documents_-_MD_Sound_Sample_(68000%2BZ80)_Floppy.zip)
* [February 1990 R&D Sonic 1 Footage](https://tcrf.net/Prerelease:Sonic_the_Hedgehog_(Genesis)/February_1990)
* [Sonic 2 Nick Arcade Symbol Tables](https://tcrf.net/Proto:Sonic_the_Hedgehog_2_(Genesis)/Nick_Arcade_Prototype/Symbol_Tables)
* [Sonic 2 Nick Arcade Debug Mode Source Code](https://tcrf.net/Proto:Sonic_the_Hedgehog_2_(Genesis)/Nick_Arcade_Prototype#Object_List.2FSource_Code)
* [Sonic CD Gems Collection ELFs](https://git.sr.ht/~benoitren/soniccddecompilation)
* [Sonic & Knuckles Collection Executable Symbols](https://forums.sonicretro.org/index.php?threads/the-sonic-3-knuckles-source-code.3280/)
* [Sonic Jam Symbols](https://forums.sonicretro.org/index.php?threads/sonic-jam-symbol-leaks-and-the-further-search-for-more-original-s1-cd-2-3-k-source-code-labels.38990/)
* [Sonic 1 Mobile Graphics File Names](https://forums.sonicretro.org/index.php?threads/sonic-mobile-and-original-sonic-1-labels.9700/)
* Sonic 1 Mobile Decompiled Code

## Building

To keep true to Sonic 1's development set-up, the project targets [2500AD's X68k assembler](https://archive.org/details/2500ad-x68k), which needs to be ran in MS-DOS. Make sure X68k.EXE and LINK.EXE are located in the root of the C:\ drive, and run the "S.CMD" file.

## Disclaimer

Repository maintainers do not claim ownership of any code or data presented. This project is maintained for educational use only, commercial use is strictly prohibited.
