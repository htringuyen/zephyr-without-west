# Ledpattern

An sample application named `ledpattern` that has two blinking LEDs and one button controlling the blink frequencies of the LEDs.

## Build

__Prerequisite__: `zephyrww` installed

In root dir of this sample application,

```bash
# build for EK RA8M1 to ./builds/ek_ra8m1
zephyrwwb -b ek_ra8m1 -z=v4.1.0 .

# build for nrf52840dk/nrf52840 to ./builds/nrf52840dk_nrf52840
zephyr -b nrf52840dk/nrf52840
```