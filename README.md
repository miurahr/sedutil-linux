# sedutil-linuxpba

This is my fork of [LinuxPBA](https://github.com/Drive-Trust-Alliance/sedutil/tree/master/LinuxPBA) from [Drive-Trust-Alliance/sedutil](https://github.com/Drive-Trust-Alliance/sedutil), suitable for use in an OPAL PBA. \
It removes the 'debug' backdoor password and makes the messages a bit nicer.

## Building

You can build the `linuxpba` binary with `make ARCH=xx` where `xx` is `32` or `64` if you want a 32-bit or 64-bit binary. \
`ARCH` defaults to `64` if not specified. Binaries come out in the `dist` folder.

You can also pack this binary into a pre-built `UEFI64.img` or `BIOS32.img` from https://github.com/Drive-Trust-Alliance/exec, which you can then flash with `sedutil-cli --loadpbaimage`. \
To do this, download `UEFI64.img.gz` or `BIOS32.img.gz` from https://github.com/Drive-Trust-Alliance/exec, unzip and place in the same folder as the `Makefile`, then run `make pbaimage ARCH=xx`.

## Binaries

A prebuilt `linuxpba` 64-bit binary and `UEFI64` image [are available here](https://github.com/stephensolis/sedutil-linuxpba/releases/latest).

**DO NOT TRUST THESE BINARIES!** \
**ALWAYS MANUALLY INSPECT ALL SOURCE CODE AND BUILD EVERYTHING YOURSELF ON A TRUSTED MACHINE!**
