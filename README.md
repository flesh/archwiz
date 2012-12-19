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
1.  Boot up Arch Linux ISO and Mount your Flash Drive as such
    mkdir usb # You can call it and mount it anywhere you want, but /mnt is not a good place for it; the root is; so /root/usb is good
    mount /dev/sdb1 usb # where sdb1 is your Flash Drive; assuming you only have to drives in the system; and usb is the folder we created above
    cd usb
    ./wiz # This is all Menu Driven.

2.  Follow the Instructions: These may change and I do not wish to document them here; so a brief overview.
    This Wizard allows you to create a Software List of all Applications you want to install; 
    then after a reboot into the new OS created using the Install OS option; 
    it can load the software list using the Load Software option in the menu.

3.  Reboot.
    mount /dev/sdb1 usb
    cd usb
    ./wiz
    Choose option to Load Software
    
Features:

Custom Repository: This script creates a Custom Repository with all Sofware in it; 
    this way it can be installed multiple times and save bandwidth, 
    also it might be possible to install it on a machine with no Internet access,
    but that has not been tested.
    Currently its limited to just the Core; working on AUR next.

Profile: This script saves all settings as a Profile per user; it has the ablility to change user names; 
    so you can create a software package installation and customize it to have all the software you want installed on it,
    and also configure the Hard Drive Partition Scheme to use, while still being able to change both independenly of each other,
    you can copy the profiles to another folder and save them, then simple copy them back; in future versions this will allow
    you to name the profiles and load them back.
    
Optimization: This script allows you to Optimize Pacman to use parallel downloads using Aria2, rsync and ppl parisync, as well as use pacget.

All downloads are Automatic, unless they fail to install the first time, then they will drop to interactive mode, so you will have to 
    hit keys manually; if AUR package; you will want to say No to edit configuration files, and Yes to all others.
    

    
