archwiz
=======

Arch Linux Installation Wizard Script

Last Update: 19 Nov 2012

Arch Linux Installation Wizard AKA archwiz,
is an Installation script file to install Arch Linux on a Hard Drive.

This script was origanly written by helmuthdu[at]gmail[dot]com prior to Nov 2012.
It was modified by Jeffrey Scott Flesher: jeff[at]lightwizzard[dot]com

Currently I only tested the Mate Install; I did note problems with other Desktops; 
the problem is in the Packages not the script; so most problems may be the packages.

This is a bash script; I think its best to write this as a QT GUI app; 
then create a Live Arch Disk with a real Installation Program; like other Distro's, only better; 
so my work on this script is limited; just a fast way of getting going and to show it can be done.

It has many Options:
To start the install from a Flash Drive to a Hard Drive you wish to Format, type:
1. Boot up Arch Linux ISO and Mount your Flash Drive as such
mkdir usb # You can call it and mount it anywhere you want, but /mnt is not a good place for it; the root is; so /root/usb is good
mount /dev/sdb1 usb # where sdb1 is your Flash Drive; assuming you only have to drives in the system; and usb is the folder we created above
cd usb
./archwiz.sh -a # -a will automatically assume this is a new install

2. Follow the Instructions: These may change and I do not wish to document them here; so a brief overview.

This Wizard allows you to create a Software List of all Applications you want to install; 
then after a reboot into the new OS created using the -a option; 
it can load the software list using the follow command:
./archwiz.sh -l # this will load the Software list; it will ask you if you want to load it and give you a chance to change some settings.

