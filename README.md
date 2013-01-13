archwiz
=======

Arch Linux Installation Wizard Script

Last Update: 12 Jan 2012

Arch Linux Installation Wizard AKA archwiz,
is an Installation script file to install Arch Linux on a Hard Drive.

This script was originally written by helmuthdu[at]gmail[dot]com prior to Nov 2012.
It was modified by Jeffrey Scott Flesher: jeff[at]lightwizzard[dot]com

Currently I only tested the Mate Install; I did note problems with other Desktops; 
the problem is in the Packages not the script; so most problems may be the packages.

This is a bash script; I think its best to write this as a QT GUI Application; 
then create a Live Arch Disk with a real Installation Program; like other Distributions's, only better; 
so my work on this script is limited; just a fast way of getting going and to show it can be done.

It has many Options:
To start the install from a Flash Drive to a Hard Drive you wish to Format, type:
1.  Boot up Arch Linux ISO and Mount your Flash Drive as such
    mkdir usb # You can call it and mount it anywhere you want, but /mnt is not a good place for it; the root is; so /root/usb is good
    mount /dev/sdb1 usb # where sdb1 is your Flash Drive; assuming you only have to drives in the system; and usb is the folder we created above
    cd usb
    Now we are in Boot Mode:
    ./wiz # This is all Menu Driven.
    Note: The Following command will build the Localized Database, this must be done prior to using this script:
    ./wiz -l # Localize
    Then you must build the Help File if you wish to view it
    ./wiz -h # Help File for browser: file:///home/USERNAME/Full-Path/archwiz/help.html
    Automatic install option is -a, it will automatically preform install.
    ./wiz -a # Automatically install.
    Built in self test is -t
    ./wiz -t # Run all Self-Test

2.  Follow the Instructions: These may change and I do not wish to document them here; so a brief overview.
    This Wizard allows you to create a Software List of all Applications you want to install; 
    this list is also known as a script, since you can just run it from a shell terminal,
    the software list should be created prior to installing the Software,
    even though it may let you make changes to it after its installed,
    best practice is to build the system from a fresh install, 
    instead of trying to patch an existing OS,
    then after a reboot into the new OS created using the Install OS option; 
    it can load the software list using the Load Software option in the menu.

3.  Reboot; now we are in Live Mode:
    cd /home/$USERNAME
    mkdir usb # if it does not exist
    mount /dev/sdb1 usb
    cd usb
    ./wiz -a # Automatically install.
    or
    ./wiz
    Choose option to Load Software
    
Features:

Custom Repository: This script creates a Custom Repository with all Software in it; 
    this way it can be installed multiple times and save bandwidth, 
    also it might be possible to install it on a machine with no Internet access,
    but that has not been tested.
    Currently its limited to just the Core; working on AUR next.

Profile: This script saves all settings as a Profile per user; it has the ability to change user names; 
    so you can create a software package installation and customize it to have all the software you want installed on it,
    and also configure the Hard Drive Partition Scheme to use, while still being able to change both independently of each other,
    you can copy the profiles to another folder and save them, then simple copy them back; in future versions this will allow
    you to name the profiles and load them back.
    
Optimization: This script allows you to Optimize Pacman to use parallel downloads using Aria2, rsync and ppl parisync, as well as use pacget.

All downloads are Automatic, unless they fail to install the first time, then they will drop to interactive mode, so you will have to 
    hit keys manually; if AUR package; you will want to say No to edit configuration files, and Yes to all others.
    
Wizard API:

    The Wizard API is the base of the script engine used to write this script, which in itself only writes another script,
    so this is known as a script engine, whereas the API or Application Programming Interface, is the syntax,
    which is the parameters sent to the function, as such Documenting all the functions would be a huge undertaking in most projects this size,
    so I decided to make this script self Documenting, as well as self Localizing, a non-localized script is worthless to the world,
    in a perfect Society we would all talk the same Language, for me that would be C++, 
    so lets just say that no one can agree on what Language to speak in, let a lone program in, so even this text needs to be translated,
    for those that do not read English; and this is static text; so these instructions really need to be in the script itself;
    which is why its self Documenting; so it can translate that into the language the person reading it can read it in,
    so that is it for this static file, all other Documentation will be built in.
    Every program ever write should do 3 things, besides running flawlessly:
    1. Localized for every language that will be using it.
    2. Self Documenting.
    3. Self Testing, ability to run Test and Determine if program is working correctly.
    
End of Document
