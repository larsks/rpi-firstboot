# rpi-firstboot

A mechanism for performing system configuration tasks when you first
boot a Pi with a new disk image.

When `firstboot` is enabled, you may place scripts or other
executables into either `/boot/firstboot/early.d` or
`/boot/firstboot/late.d`.  These scripts will be exited the first time
the Pi boots.  Scripts in `early.d` will execute early on in the boot
process (before networking is up), while scripts in `late.d` will
execute after networking is available.

## Installing firstboot

To install the unit files:

    make install

To activate the units:

    make activate
