#!/bin/bash
#
LAST_UPDATE="19 Nov 2012 14:33"
SCRIPT_VERSION="1.0"
SCRIPT_NAME="archwiz"
SCRIPT_EXT=".sh"
#-------------------------------------------------------------------------------
# This script will install Arch Linux, although it could be adapted to install any Linux distro that uses the same package names.
# This Script Assumes you wish GPT disk format, and gives you the choice to use UEFI, BIOS or no boot loader.
# The first time you use it, call it with the -a or -da for debugging help if needed, this will start the Wizard, follow instructions.
# You have the Option of Installing Software, this is just a list of Configuration files, and will save a series of files for later use.
# After reboot you have the option to run -i to install software; you can load the Software list if you already saved it; or create a new one.
# If after reboot you have no Internet access, run the Script with a -n and pick option 1 to setup network, then the option to ping.
#-------------------------------------------------------------------------------
# Programmers:
# 1. Created by helmuthdu mailto: helmuthdu[at]gmail[dot]com prior to Nov 2012
# 2. Refactored and Added Functionallity by Jeffrey Scott Flesher to make it a Wizard.
#-------------------------------------------------------------------------------
# Changes:
#-------------------------------------------------------------------------------
# @FIX
# 1. Localization
# 2. Save all installed and removed into file for testing
# 3. Finish Menu load and save option.
# 4. Custom Install
# 5. Ask what drive to save log files to; only if live mode, case running from root, and want logs on flash drive.
#-------------------------------------------------------------------------------
# This Program is under the Free License. It is Free of any License or Laws Governing it.
# You are Free to apply what ever License you wish to it below this License.
# The Free License means that the End User has total Freedom will using the License,
# whereas all other License types fall short due to the Laws governing them,
# Free License is not covered by any Law, all programmers writting under the Free License,
# take an oath that the Software Contains No Malace: Viruses, Malware, or Spybots...
# and only does what it was intended to do, notifing End Users before doing it.
# All Programmers and End Users are Free to Distribute or Modify this script,
# as long as they list themselves as Programmers and Document Changes.
#-------------------------------------------------------------------------------
# Other LICENSES:
# 1. GNU
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#-------------------------------------------------------------------------------
#
#VARIABLES {{{
# DESKTOP ENVIRONMENT {{{
SCRIPT_DIR=`pwd`
#
LOG_PATH="$SCRIPT_DIR/LOG"
CONFIG_PATH="$SCRIPT_DIR/CONFIG"
MENU_PATH="$SCRIPT_DIR/MENU"
USER_FOLDER="$SCRIPT_DIR/USER"
ERROR_LOG="$LOG_PATH/$SCRIPT_NAME-error.log"
ACTIVITY_LOG="$LOG_PATH/$SCRIPT_NAME-activity.log"
SCRIPT_LOG="$LOG_PATH/$SCRIPT_NAME-script.log"
#
AUR=`echo -e "Arch User Repository (AUR)"`
declare -i DEBUGGING=0
declare -i MATE_INSTALLED=0
declare -i GNOME_INSTALL=0
declare -i XFCE_INSTALLED=0
declare -i E17_INSTALLED=0
declare -i KDE_INSTALLED=0
declare -i LXDE_INSTALLED=0
declare -i OPENBOX_INSTALLED=0
declare -i AWESOME_INSTALLED=0
declare -i GNOME_INSTALLED=0
declare -i CINNAMON_INSTALLED=0
declare -i UNITY_INSTALLED=0
declare -i IS_INSTALL_SOFTWARE=0
declare -i IS_LAST_CONFIG_LOADED=0
declare -i SAVED_SOFTWARE=0
declare -i ETH0_ACTIVE=0
declare -i ETH1_ACTIVE=0
declare -i ETH2_ACTIVE=0
declare -i FAST_INSTALL=0
declare -i DISK_PROFILE=0
declare -i BOOT_MODE=0
declare -i DRIVE_FORMATED=0
INSTALL_DEVICE='sda'
declare -i BOOT_PARTITION_NO=2
declare -a LOCALE_ARRAY=( "" ) 
declare -a USER_GROUPS=( "" ) 
declare -a LIST_DEVICES=( "" ) 
declare -a NIC=( "" )
USERNAME='archlinux'
USERPASSWD='archlinux'
ROOTPASSWD='archlinux'
declare -i INSTALL_TYPE=1
declare -i REFRESH_REPO=1
declare -i REFRESH_AUR=1
declare -i IS_CUSTOM_NAMESERVER=0
CUSTOM_NS1="192.168.1.1"
CUSTOM_NS2="192.168.0.1"
CUSTOM_NS_SEARCH="localhost"
#
declare -i CONFIG_KDE=0
declare -i CONFIG_XORG=0
declare -i CONFIG_ORPHAN=0
declare -i CONFIG_TOR=0
declare -i CONFIG_SSH=0
#
declare -i RUN_AUR_ROOT=1
declare -i WEBSERVER=0
declare -i CUSTOM_MIRRORLIST=0
declare -i SAFE_MODE=0
declare -i FLESH=0
declare -i VIDEO_CARD=7
declare -a VIDEO_CARDS=("nVidia" "Nouveau" "Intel" "ATI" "Vesa" "Virtualbox" "Skip");
# 
DATE_TIME=`date +"%m-%d-%y @ %r" `
TEXT_SCRIPT_ID=$"Arch Linux Installation Script: $SCRIPT_NAME Verions: $SCRIPT_VERSION Last updated: $LAST_UPDATE"
#
AUR_PACKAGE_FOLDER="/root/aur_packages"
NETWORK_MANAGER="networkmanager" # or wicd
#
declare -a PACKAGE_CHECK_FAILURES=( "mate" "mate-extras" "base-devel" )
#
declare -a PACKMANAGER=( "" )
declare -a PACKMANAGER_NAME=( "" )
#
declare -a CORE_INSTALL=( "" )
declare -a AUR_INSTALL=( "" )
declare -a FAILED_CORE_INSTALL=( "" )
declare -a FAILED_AUR_INSTALL=( "" )
# This will throw an error if device is not found @FIX, how to hide error message
check_eth0="$(ifconfig eth0 | grep 'inet addr:')"
check_eth1="$(ifconfig eth1 | grep 'inet addr:')"
check_eth2="$(ifconfig eth2 | grep 'inet addr:')"
#
CONFIG_HOSTNAME="archlinux"
#
# Software Packages:
# If I declare them here, I can use them in menus
# I could make this multi-distro by putting in if $DISTRO == Arch statements
INSTALL_MATE="mate mate-session-manager mate-extras mate-screensaver gnome-icon-theme trayer gvfs-smb gvfs-afc"
AV_STUDIO="audacity ardour avidemux avidemux-cli avidemux-qt blender brasero cdrkit cheese devede dvd+rw-tools dvdauthor enca ffmpeg gaupol gimp gcolor2 gpicview gtk2 gthumb gtkmm handbrake handbrake-cli inkscape kdegraphics kdenlive kino libdvdread libxml++ mcomix mypaint mjpegtools mjpegtools mpgtx mencoder openshot python2-numpy python-lxml uniconvertor shotwell scribus simple-scan scons twolame wicd xnviewmp"
AV_STUDIO_AUR="gimp-paint-studio gimphelp-scriptfu gimp-resynth gimpfx-foundry gimp-plugin-pandora gimp-plugin-saveforweb"
INSTALL_SCIENCE_EDUCATION="stellarium celestia"
INSTALL_UTILITES="faac gpac espeak faac antiword unrtf odt2txt txt2tags nrg2iso bchunk gnome-disk-utility"
#
declare -i CREATE_SCRIPT=0
declare -a AUR_HELPERS=("yaourt" "packer" "pacaur")
declare -i CONFIG_VERIFIED=0
AUR_HELPER="yaourt"
declare -a FSTAB=("UUID" "DEV" "LABEL");
declare -i FSTAB_CONFIG=1
declare -i FSTAB_EDIT=0
#
# Disk
#
declare -i IS_SSD=0
declare -i EDIT_GDISK=0
declare -i IS_DISK_CONFIG_LOADED=0
declare -i IS_SOFTWARE_CONFIG_LOADED=0
declare -i BOOT_SYSTEM_TYPE=1
declare -i IS_BOOT_PARTITION=0
declare -i UEFI=1
UEFI_SIZE="512M"
BOOT_SIZE="1G"
ROOT_SIZE="50G"
ROOT_FORMAT="ext4"
declare -i IS_SWAP_PARTITION=0
SWAP_SIZE="4G"
declare -i IS_HOME_PARTITION=0
declare -i IS_HOME_DRIVE=0
HOME_SIZE="0"
HOME_FORMAT="ext4"
declare -i IS_VAR_PARTITION=0
declare -i IS_VAR_DRIVE=0 
VAR_SIZE="13G"
VAR_FORMAT="ext4"
declare -i IS_TMP_PARTITION=0
declare -i IS_TMP_SIZE=0
TMP_SIZE="1G"
TMP_FORMAT="ext4"
OPTION=" "
#
# AUTOMATICALLY DETECTS THE SYSTEM LANGUAGE {{{
# automatically detects the system language based on your locale
LANGUAGE=`locale | sed '1!d' | sed 's/LANG=//' | cut -c1-5` # en_US 
LOCALE="$LANGUAGE" # en_US 
COUNTRY_CODE=${LOCALE#*_} # en_US = en-US 
LANGUAGE_LO="en-US"
LANGUAGE_HS="en"
LANGUAGE_AS="en"
LANGUAGE_KDE="en_gb"
LANGUAGE_FF="en_gb"
KEYBOARD="us" # used to drill down into more specific layouts for some; not the same as KEYMAP necessarily  
KEYMAP="us"
ZONE="America"
SUBZONE="Los_Angeles"
set_language="$LANGUAGE" # Run function to set defaults
#}}}
# ARCH {{{
ARCHI=`uname -m`
#}}}
# COLORS {{{
# Regular Colors
Black='\e[0;30m'        # Black
Blue='\e[0;34m'         # Blue
Cyan='\e[0;36m'         # Cyan
Green='\e[0;32m'        # Green
Purple='\e[0;35m'       # Purple
Red='\e[0;31m'          # Red
White='\e[0;37m'        # White
Yellow='\e[0;33m'       # Yellow
# Bold
BBlack='\e[1;30m'       # Black
BBlue='\e[1;34m'        # Blue
BCyan='\e[1;36m'        # Cyan
BGreen='\e[1;32m'       # Green
BPurple='\e[1;35m'      # Purple
BRed='\e[1;31m'         # Red
BWhite='\e[1;37m'       # White
BYellow='\e[1;33m'      # Yellow
#}}}
# PROMPT {{{
prompt1="Enter your option: "
prompt2="Enter n° of options (ex: 1 2 3 or 1-3): "
prompt3="You have to manual enter the following commands, then press ${BYellow}ctrl+d${White} or type ${BYellow}exit${White}:"
#}}}
EDITOR=nano
declare -a EDITORS=("nano" "emacs" "vi" "vim" "joe");
# Get current Device Script is Executing from
SCRIPT_DEVICE=`df | grep -w "$SCRIPT_DIR" | awk {'print \$1'}`
SCRIPT_DEVICE="${SCRIPT_DEVICE:5:3}"
MOUNTPOINT="/mnt"
#}}}
#SUPPORT FUNCTIONS {{{
# -----------------------------------------------------------------------------
# PRINT LINE {{{
# USAGE      : print_line 
# DESCRIPTION: Prints a line of dashes --- accross the screen.
# NOTES      :
# AUTHOR     : helmuthdu
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
print_line()
{ 
    printf "%$(tput cols)s\n"|tr ' ' '-'
} 
#}}}
# -----------------------------------------------------------------------------
# PRINT TITLE {{{
# USAGE      : print_title "Text"
# DESCRIPTION: This will print a Header and clear the screen
# NOTES      :
# AUTHOR     : helmuthdu
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
print_title()
{ 
    clear
    print_line
    echo -e "# ${BWhite}$1${White}"
    print_line
    echo ""
} 
#}}}
# -----------------------------------------------------------------------------
# PRINT INFO {{{
# USAGE      : print_info "Text"
# DESCRIPTION: Prints information on screen for end users to read, in a Column that is as wide as display will allow.
# NOTES      :
# AUTHOR     : helmuthdu
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
print_info()
{ 
    # Console width number
    T_COLS=`tput cols`
    echo -e "${BWhite}$1${White}\n" | fold -sw $(( $T_COLS - 18 )) | sed 's/^/\t/'
} #}}}
# -----------------------------------------------------------------------------
# PRINT THIS {{{
# USAGE      : print_this "Text"
# DESCRIPTION: Like print_info, without a blank line
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
print_this()
{ 
    # Console width number
    T_COLS=`tput cols`
    echo -e "${BWhite}$1${White}" | fold -sw $(( $T_COLS - 18 )) | sed 's/^/\t/'
} 
#}}}
# -----------------------------------------------------------------------------
# PRINT WARNING {{{
# USAGE      : print_warning "Text"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
print_warning()
{ 
    # Console width number
    T_COLS=`tput cols`
    echo -e "${BRed}$1${White}\n" | fold -sw $(( $T_COLS - 1 ))
} 
#}}}
# -----------------------------------------------------------------------------
# CHECK BOX {{{
# USAGE      : checkbox
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
checkbox()
{ 
    # display [X] or [ ]
    [[ "$1" -eq 1 ]] && echo -e "${BBlue}[${BWhite}X${BBlue}]${White}" || echo -e "${BBlue}[${White} ${BBlue}]${White}";
} 
#}}}
# -----------------------------------------------------------------------------
# CHECKBOX PACKAGE {{{
# USAGE      : checkbox_package checkboxlist
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
checkbox_package()
{ 
    # check if [X] or [ ]
    check_package "$1" && checkbox 1 || checkbox 0
} 
# -----------------------------------------------------------------------------
#}}}
# CONTAINS ELEMENT {{{
# USAGE      : contains_element
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
contains_element()
{ 
    # check if an element exist in a string
    for e in "${@:2}"; do [[ $e == $1 ]] && break; done;
} 
#}}}
# -----------------------------------------------------------------------------
# INVALID OPTION {{{
# USAGE      : invalid_option
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
invalid_option()
{ 
    print_line
    if [ -z "$1" ]; then
        echo $"Invalid option. Try another one."
    else
        echo $"$1 Invalid option. Try another one."
    fi
    pause_function "$LINENO"
} 
# -----------------------------------------------------------------------------
#}}}
# INVALID OPTIONS {{{
# USAGE      : invalid_options
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
invalid_options()
{
    print_line
    if [ -z "$1" ]; then
        echo $"Invalid option. Try another one."
    else
        echo $"$1 Invalid option. Try another one."
    fi
} 
#}}}
# -----------------------------------------------------------------------------
# PAUSE FUNCTION {{{
# USAGE      : pause_function
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
pause_function()
{
    # Pass in $LINENO
    print_line
    read -e -sn 1 -p "Press any key to continue ($1)..."
} 
#}}}
# -----------------------------------------------------------------------------
# INSTALLED CORE {{{
# USAGE      : installed_core "package-name"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
installed_core()
{
    if [ -z "$CORE_INSTALL" ]; then
        CORE_INSTALL[0]="$1" # Accessing below first will give unbound variable error
    else
        CORE_INSTALL[$[${#CORE_INSTALL[@]}]]="$1"
    fi    
}
#}}}
# -----------------------------------------------------------------------------
# FAILED INSTALL CORE {{{
# USAGE      : failed-install_core "package-name"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
failed_install_core()
{
    if [ -z "$FAILED_CORE_INSTALL" ]; then
        FAILED_CORE_INSTALL[0]="$1" # Accessing below first will give unbound variable error
    else
        FAILED_CORE_INSTALL[$[${#FAILED_CORE_INSTALL[@]}]]="$1"
    fi    
}
#}}}
# -----------------------------------------------------------------------------
# INSTALLED AUR {{{
# USAGE      : installed_aur "package-name"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
installed_aur()
{
    if [ -z "$AUR_INSTALL" ]; then
        AUR_INSTALL[0]="$1" # Accessing below first will give unbound variable error
    else
        AUR_INSTALL[$[${#AUR_INSTALL[@]}]]="$1"
    fi    
}
#}}}
# -----------------------------------------------------------------------------
# FAILED INSTALL AUR {{{
# USAGE      : failed_install_aur "package-name"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
failed_install_aur()
{
    if [ -z "$FAILED_AUR_INSTALL" ]; then
        FAILED_AUR_INSTALL[0]="$1" # Accessing below first will give unbound variable error
    else
        FAILED_AUR_INSTALL[$[${#FAILED_AUR_INSTALL[@]}]]="$1"
    fi    
}
#}}}
# -----------------------------------------------------------------------------
# CHECK PACKAGE {{{
# USAGE      : check_package "Single-Package-to-Check"
# DESCRIPTION: checks single package
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
check_package()
{
    refresh_pacman
    # check if a package is already installed
    pacman -Q "$PACKAGE" &> /dev/null && return 0;
    return 1 # Not Found
} 
#}}}
# -----------------------------------------------------------------------------
# REFRESH PACMAN {{{
# USAGE      : refresh_pacman
# DESCRIPTION: Refresh pacman
# NOTES      : 
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
refresh_pacman()
{
    if [[ $REFRESH_REPO -eq 1 ]]; then
        REFRESH_REPO=0
        pacman -Syy
    fi
} 
#}}}
# -----------------------------------------------------------------------------
#SYSTEM UPDATE {{{
# USAGE      : system_upgrade
# DESCRIPTION: Set a var so you do not do this every call, then perform a pacman-optimize
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
system_upgrade()
{
    print_title "UPDATING YOUR Pacman SYSTEM"
    if [[ "$REFRESH_REPO" -eq 1 ]]; then
        optimize_pacman
        pacman -Syy --noconfirm
        pacman -Su --noconfirm
        pacman -Sc && pacman-optimize
        REFRESH_REPO=0
    else
        pacman -Su --noconfirm
    fi
}
#}}}
# -----------------------------------------------------------------------------
# UPDATE SYSTEM {{{
# USAGE      : update_system
# DESCRIPTION: 
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
update_system()
{
    sudo pacman -Syy && sudo pacman -Su --noconfirm && yaourt -Syua --noconfirm && yaourt -Syua --devel --noconfirm
}
#}}}
# -----------------------------------------------------------------------------
# OPTIMIZE PACMAN {{{
# USAGE      : optimize_pacman
# DESCRIPTION: 
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
optimize_pacman()
{
    if [[ "$MOUNTPOINT" == " " ]]; then
        PACMAN_FILE="$MOUNTPOINT/etc/pacman.conf"
    else
        PACMAN_FILE="/etc/pacman.conf"
    fi
    if ! is_string_in_file "$PACMAN_FILE" "XferCommand = /usr/bin/aria2c" ; then
        if [[ "$ROOT_FORMAT" == "ext4" ]]; then
            sed '/[options]/a > XferCommand = /usr/bin/aria2c --allow-overwrite=true -c --file-allocation=none --log-level=error -m2 --max-connection-per-server=2 --max-file-not-found=5 --min-split-size=5M --no-conf --remote-time=true --file-allocation=falloc --summary-interval=60 -t5 -d / -o %o %u' $PACMAN_FILE
        else
            sed '/[options]/a > XferCommand = /usr/bin/aria2c --allow-overwrite=true -c --file-allocation=none --log-level=error -m2 --max-connection-per-server=2 --max-file-not-found=5 --min-split-size=5M --no-conf --remote-time=true --summary-interval=60 -t5 -d / -o %o %u' $PACMAN_FILE
        fi
    fi
    # http://xyne.archlinux.ca/repos/
    # http://xyne.archlinux.ca/#signing-key
    if ! is_string_in_file "$PACMAN_FILE" "[xyne-i686]" ; then
        if [[ "$ARCHI" != "x86_64" ]]; then
            sed '$ a > [xyne-i686]' $PACMAN_FILE
            sed '$ a > SigLevel = Required' $PACMAN_FILE
            sed '$ a > Server = http://xyne.archlinux.ca/repos/xyne-i686' $PACMAN_FILE
        if
    fi
    #
    if ! is_string_in_file "$PACMAN_FILE" "[xyne-any]" ; then
        sed '$ a > [xyne-any]' $PACMAN_FILE
        sed '$ a > SigLevel = Required' $PACMAN_FILE
        sed '$ a > Server = http://xyne.archlinux.ca/repos/xyne-any' $PACMAN_FILE
    fi
    #
    if ! is_string_in_file "$PACMAN_FILE" "[xyne-x86_64]" ; then
        if [[ "$ARCHI" == "x86_64" ]]; then
            sed '$ a > [xyne-x86_64]' $PACMAN_FILE
            sed '$ a > SigLevel = Required' $PACMAN_FILE
            sed '$ a > Server = http://xyne.archlinux.ca/repos/xyne-x86_64  ' $PACMAN_FILE
        if
    fi
    # python3 pyalpm
}
#}}}
# -----------------------------------------------------------------------------
# RESTART INTERNET {{{
# USAGE      : restart_internet
# DESCRIPTION: 
# NOTES      : 
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
restart_internet()
{
    if [[ "$NETWORK_MANAGER" == "networkmanager" ]]; then
        systemctl restart NetworkManager.service
    elif [[ "$NETWORK_MANAGER" == "wicd" ]]; then
        systemctl restart wicd.service
    fi
}
#}}}
# -----------------------------------------------------------------------------
# PACKAGE INSTALL {{{
# USAGE      : package_install "SPACE DELIMITED LIST OF PACKAGES TO INSTALL" "NAME-OF-PACKAGE-MANAGER"
# DESCRIPTION: Install package from core or additional Repositories.
# NOTES      : Install one at a time, check to see if already install, if fails, try again with with confirm.
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
package_install()
{
    refresh_pacman
    # install packages one at a time using pacman to check if package is already loaded.
    for PACKAGE in $1; do
        if ! check_package "$PACKAGE" ; then
            print_info $"Installing Package $PACKAGE for Package Manager $2"
            pacman -S --noconfirm --needed "$PACKAGE"
            is_in_array "PACKAGE_CHECK_FAILURES[@]" "$PACKAGE" # some packages do not register, i.e. mate and mate-extras, so this is a work around; so you do not get stuck in a loop @FIX make a list
            if [ "$?" -eq 0 ]; then
                if ! check_package "$PACKAGE" ; then
                    print_this "${BRed} Retry ${BWhite} install package $PACKAGE for Package Manager $2"
                    print_this "Refreshing pacman Database and Updates..."
                    pacman -Syu
                    pacman -S --noconfirm --needed --force "$PACKAGE" # Install with the force
                    if ! check_package "$PACKAGE" ; then
                        if ! is_internet ; then
                            restart_internet
                            sleep 13
                            if ! is_internet ; then
                                failed_install_core "$PACKAGE"
                                write_error "pacman did not install Package $PACKAGE for Package Manager $2 - Internet check failed." "$LINENO"
                                print_warning "Pacman Package $PACKAGE did not install for Package Manager $2. - Internet check failed."
                                # @FIX what to do now: restart network adapter
                                exit 0
                            else
                                print_this "Refreshing pacman Database and Updates..."
                                pacman -Syu
                            fi
                        fi             
                        print_this "${BRed} Retry ${BWhite}  install package $PACKAGE for Package Manager $2 with Manual intervention."
                        pacman -S --needed "$PACKAGE" # Install with Manual Interaction
                        # Last try     
                        if ! check_package "$PACKAGE" ; then
                            failed_install_core "$PACKAGE"
                            write_error "pacman did not install Package $PACKAGE for Package Manager $2" "$LINENO"
                            print_warning "Pacman Package $PACKAGE did not install for Package Manager $2."
                        fi
                    fi
                else
                    installed_core "$PACKAGE"
                fi
            fi
        else
            installed_core "$PACKAGE" # Already Installed
        fi
    done
    echo "Package Manager $2 Complete..."
} 
#}}}
# -----------------------------------------------------------------------------
# PACKAGE REMOVE {{{
# USAGE      : package_remove "SPACE DELIMITED LIST OF PACKAGES TO REMOVE" "NAME-OF-PACKAGE-MANAGER"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
package_remove()
{
    refresh_pacman
    for PACKAGE in $1; do
        if check_package "$PACKAGE" ; then
            echo "Removing package $PACKAGE"
            # pacman -Rcsn --noconfirm "$PACKAGE" # This operation is recursive, and must be used with care since it can remove many potentially needed packages.
            pacman -Rddn --noconfirm "$PACKAGE" # We wish to remove some apps that will be replace with ones that replace it, so do not remove dependancies.
        fi
    done
} 
#}}}
# -----------------------------------------------------------------------------
# GET AUR PACKAGES {{{
# USAGE      :  get_aur_packages "package-name" "$AUR_PACKAGE_FOLDER"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_aur_packages()
{ 
    White='\e[0;37m'        # White
    BWhite='\e[1;37m'       # Bold White
    BRed='\e[1;31m'         # Red
    #
    echo -e "${BWhite}\t Downloading: $1.tar.gz from https://aur.archlinux.org/packages/${1:0:2}/$1/$1.tar.gz${White}"
    # @FIX replace with curl
    # do_curl "/home/$USERNAME/$1.tar.gz" "https://aur.archlinux.org/packages/${1:0:2}/$1/$1.tar.gz"
    curl -o $1.tar.gz https://aur.archlinux.org/packages/${1:0:2}/$1/$1.tar.gz
    if [ -f "$1.tar.gz" ]; then
        if tar zxvf "$1.tar.gz" ; then
            rm "$1.tar.gz"
            cd "$1"
            if [[ "$RUN_AUR_ROOT" -eq 1 ]]; then
                makepkg -si --noconfirm --asroot
            else
                makepkg -si --noconfirm
            fi    
         else
             echo -e "${BRed}\t File Currupted: curl -o $1.tar.gz https://aur.archlinux.org/packages/${1:0:2}/$1/$1.tar.gz${White}"
         fi
    else
        echo -e "${BRed}\t File Not Found: curl -o $1.tar.gz https://aur.archlinux.org/packages/${1:0:2}/$1/$1.tar.gz${White}"
    fi
}
#}}}
# -----------------------------------------------------------------------------
#
export -f get_aur_packages # need to export so if we are running as user it will find it
#
# AUR DOWNLOAD PACKAGE {{{
# USAGE      : aur_download_packages
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
aur_download_packages()
{ 
    print_info 'AUR Package Downloader.'
    for PACKAGE in $1; do
        if [ ! -d "$AUR_PACKAGE_FOLDER" ]; then
            make_dir "$AUR_PACKAGE_FOLDER" "$LINENO"
        fi
        chown -R "$USERNAME:$USERNAME" "$AUR_PACKAGE_FOLDER"
        cd "$AUR_PACKAGE_FOLDER"
        if [[ "$RUN_AUR_ROOT" -eq 1 ]]; then
            # exec command as root - Only way to make it unattended, and the Evils of this are fine on a new install.
            # @FIX actually this may not work and need to be removed; but maybe not here, but in user configuration for sure
            get_aur_packages "$PACKAGE" "$AUR_PACKAGE_FOLDER" # Run as Root, Evil but fast
        else
            # exec command as user instead of root
            su $USERNAME -c "get_aur_packages \"$PACKAGE\"" # Run as User
        fi    
    done
    cd "$SCRIPT_DIR"
} 
#}}}
# -----------------------------------------------------------------------------
# AUR PACKAGE INSTALL {{{
# USAGE      : aur_package_install $1"SPACE DELIMITED LIST OF PACKAGES TO INSTALL FROM AUR" $2"NAME-OF-PACKAGE-MANAGER"
# DESCRIPTION: Install AUR Package using AUR_HELPER
# NOTES      : Install one at a time, check to see if its already installed, if fail, try again with confirm.
#            : --needed --recursive --force --upgrades
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
aur_package_install()
{
    if [[ $REFRESH_AUR -eq 1 ]]; then
        REFRESH_AUR=0
        if [[ "$RUN_AUR_ROOT" -eq 1 ]]; then
           "$AUR_HELPER" --noconfirm -Syu # Run as Root, no so Evil here but fast
        else
            su - $USERNAME -c "$AUR_HELPER --noconfirm -Syu" # Run as User
        fi
    fi
    declare -i retry_times=0
    # install package from aur
    for PACKAGE in $1; do
        if ! check_package "$PACKAGE" ; then
            AUR_CONFIRM="--noconfirm"
            retry_times=0
            YN_OPTION=1
            while [[ "$YN_OPTION" -ne 0 ]]; do
                print_this "$AUR_HELPER $PACKAGE"
                if [[ "$RUN_AUR_ROOT" -eq 1 ]]; then
                    "$AUR_HELPER" $AUR_CONFIRM --needed -S "$PACKAGE" # Run as Root, no so Evil here but fast
                else
                    su - $USERNAME -c "$AUR_HELPER $AUR_CONFIRM --needed -S $PACKAGE" # Run as User
                fi
                # check if the package was not installed
                # some packages do not register, i.e. mate and mate-extras, so this is a work around; so you do not get stuck in a loop @FIX make a list
                is_in_array "PACKAGE_CHECK_FAILURES[@]" "$PACKAGE" 
                if [ "$?" -eq 0 ]; then
                    if ! check_package "$PACKAGE" ; then
                        print_this "Refreshing $AUR_HELPER Database and Updates..."
                        $AUR_HELPER -Syu
                        # Manual Intervention may resolve this issue
                        if [[ "$RUN_AUR_ROOT" -eq 1 ]]; then
                            $AUR_HELPER --force --needed -S "$PACKAGE" # Run as Root, no so Evil here but fast
                        else
                            su - $USERNAME -c "$AUR_HELPER --needed --force -S $PACKAGE" # Run as User
                        fi
                        if ! check_package "$PACKAGE" ; then
                            # @FIX try to find solution to why this is happening and put it here
                            if ! is_internet ; then
                                restart_internet
                                sleep 13
                                if ! is_internet ; then
                                    failed_install_core "$PACKAGE"
                                    write_error "$AUR_HELPER did not install Package $PACKAGE for Package Manager $2 - Internet check failed." "$LINENO"
                                    print_warning "$AUR_HELPER Package $PACKAGE did not install for Package Manager $2. - Internet check failed."
                                    # @FIX what to do now
                                    exit 0
                                fi
                            fi             
                            print_this "Refreshing $AUR_HELPER Database and Updates..."
                            $AUR_HELPER -Syu
                            # Manual Intervention may resolve this issue
                            if [[ "$RUN_AUR_ROOT" -eq 1 ]]; then
                                $AUR_HELPER --force --needed -S "$PACKAGE" # Run as Root, no so Evil here but fast
                            else
                                su - $USERNAME -c "$AUR_HELPER --needed --force -S $PACKAGE" # Run as User
                            fi
                            if ! check_package "$PACKAGE" ; then
                                if [[ "$retry_times" -ge 1 ]]; then
                                    read_input_yn "Package $PACKAGE from $2 not installed, try install again?" 0
                                else
                                    read_input_yn "Package $PACKAGE from $2 not installed, try install again?" 1
                                fi
                                if [[ "$YN_OPTION" -eq 0 ]]; then
                                    failed_install_aur "$PACKAGE"
                                fi
                            fi
                        fi
                        AUR_CONFIRM=" "
                        ((retry_times++))
                        #sleep 30
                        #if [[ $((retry_times)) -gt 3 ]]; then
                        #    write_error "$AUR_HELPER did not install package $PACKAGE" "$LINENO"
                        #    print_warning "$AUR_HELPER did not install package $PACKAGE; Retrying $retry_times of 3 times."
                        #    YN_OPTION=0
                        #fi
                    else
                        installed_aur "$PACKAGE"
                        YN_OPTION=0
                    fi
                fi
            done
        else
            installed_aur "$PACKAGE"
        fi
    done
} 
#}}}
# -----------------------------------------------------------------------------    
# UMOUNT PARTITION {{{
# USAGE      : umount_partition
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
umount_partition()
{
    swapon -s|grep $1 && swapoff $1 # check if swap is on and umount
    mount|grep $1 && umount $1      # check if partition is mounted and umount
}
#}}}
# -----------------------------------------------------------------------------
#PACKMAN PACKAGE SIGNING {{{
# USAGE      : configure_pacman_package_signing
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
configure_pacman_package_signing()
{
    if [[ ! -d /etc/pacman.d/gnupg ]]; then
        print_title "PACMAN PACKAGE SIGNING - https://wiki.archlinux.org/index.php/Pacman-key"
        print_info $"Pacman-key is a new tool available with pacman 4. It allows the user to manage pacmans list of trusted keys in the new package signing implementation."
        haveged -w 1024 # adding during pacstrap
        pacman-key --init --keyserver pgp.mit.edu
        pacman-key --populate archlinux
        killall haveged
        #package_remove 'haveged' "REMOVE-HAVEGED"
    fi
    echo $"Pacman Package Signing Configured"
}
#}}}
# -----------------------------------------------------------------------------
# CONFIGURE AUR HELPER {{{
# USAGE      : configure_aur_helper
# DESCRIPTION: Configure AUR Helper, should only be run from Live Mode
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
configure_aur_helper()
{
    # base-devel installed with pacstrap
    if [[ "$AUR_HELPER" == 'yaourt' ]]; then
        if ! check_package "yaourt" ; then
            print_info "Configuring AUR Helper $AUR_HELPER"
            package_install "yajl namcap" "INSTALL-AUR-HELPER-$AUR_HELPER"
            pacman -D --asdeps yajl namcap
            aur_download_packages "package-query yaourt"
            pacman -D --asdeps package-query
            if ! check_package "yaourt" ; then
                echo "Yaourt not installed. EXIT now"
                write_error "$AUR_HELPER not Installed" "$LINENO"
                # @FIX how to fix this
                pause_function "$LINENO"
                return 1
            fi
        fi
    elif [[ "$AUR_HELPER" == 'packer' ]]; then
        if ! check_package "packer" ; then
            print_info "Configuring AUR Helper $AUR_HELPER"
            package_install "git jshon" "INSTALL-AUR-HELPER-$AUR_HELPER"
            pacman -D --asdeps jshon
            aur_download_packages "packer"
            if ! check_package "packer" ; then
                echo "Packer not installed. EXIT now"
                write_error "$AUR_HELPER not Installed" "$LINENO"
                pause_function
                return 1
            fi
        fi
    elif [[ "$AUR_HELPER" == 'pacaur' ]]; then
        if ! check_package "pacaur" ; then
            print_info "Configuring AUR Helper $AUR_HELPER"
            package_install "yajl expac" "INSTALL-AUR-HELPER-$AUR_HELPER"
            pacman -D --asdeps yajl expac
            #fix pod2man path
            ln -s /usr/bin/core_perl/pod2man /usr/bin/
            aur_download_packages "cower pacaur"
            pacman -D --asdeps cower
            if ! check_package "pacaur" ; then
                echo "Pacaur not installed. EXIT now"
                write_error "$AUR_HELPER not Installed" "$LINENO"
                pause_function
                return 1
            fi
        fi
    fi
    $AUR_HELPER -S pm2ml python3-aur
    # $AUR_HELPER -Syua --devel --noconfirm # Do I need to do this?
    return 0
}
#}}}
# -----------------------------------------------------------------------------
# CONFIGURE SUDO {{{
# USAGE      : configure_sudo
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
configure_sudo()
{
    if ! check_package "sudo" ; then
        print_title 'SUDO - https://wiki.archlinux.org/index.php/Sudo'
        package_install "sudo"  "INSTALL-CONFIG-SUDO"
    fi
    if [[ ! -f  /etc/sudoers.aui ]]; then
        copy_file "/etc/sudoers" "/etc/sudoers.aui" "$LINENO"
        ## Uncomment to allow members of group wheel to execute any command
        sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers
        ## Same thing without a password (not secure)
        #sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//' /etc/sudoers
        # This config is especially helpful for those using terminal multiplexers like screen, tmux, or ratpoison, and those using sudo from scripts/cronjobs:
        echo '' >> /etc/sudoers
        echo 'Defaults !requiretty, !tty_tickets, !umask' >> /etc/sudoers
        echo 'Defaults visiblepw, path_info, insults, lecture=always' >> /etc/sudoers
        echo 'Defaults loglinelen = 0, logfile =/var/log/sudo.log, log_year, log_host, syslog=auth' >> /etc/sudoers
        echo 'Defaults passwd_tries = 8, passwd_timeout = 1' >> /etc/sudoers
        echo 'Defaults env_reset, always_set_home, set_home, set_logname' >> /etc/sudoers
        echo 'Defaults !env_editor, editor=/usr/bin/vim:/usr/bin/vi:/usr/bin/nano' >> /etc/sudoers
        echo 'Defaults timestamp_timeout=300' >> /etc/sudoers
        echo 'Defaults passprompt="[sudo] password for %u: "' >> /etc/sudoers
        echo "$USERNAME   ALL=(ALL) ALL" >> /etc/sudoers
        echo "Defaults:$USERNAME      !authenticate" >> /etc/sudoers
        copy_file "/etc/sudoers" "${SCRIPT_DIR}/etc/sudoers" "$LINENO"
    fi
    echo $"Sudo Configured"
}
#}}}
# -----------------------------------------------------------------------------
# IS STRING IN FILE {{{
# USAGE      : is_string_in_file $1"/full-path/file" $2"string"
# DESCRIPTION: Return true if string is in file
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
is_string_in_file()
{
    if [ -z "$2" ]; then
        return 1
    fi
    if [ -e "$1" ]; then
        count=`egrep -ic "$2" "$1"`
        if [ $count -gt 0 ]; then
        	return 0
        fi
    fi
    return 1
}
#}}}
# -----------------------------------------------------------------------------
# IS BREAKABLE {{{
# USAGE      : is_breakable
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
is_breakable() 
{ 
    # back, done or quit
    [[ "$1" == "$2" ]] && break;
} 
#}}}
# -----------------------------------------------------------------------------
# READ INPUT {{{
# USAGE      : read_input
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
read_input()
{ 
    read -p "$prompt1" OPTION
} 
#}}}
# -----------------------------------------------------------------------------
# GET INPUT OPTION {{{
# USAGE      : get_input_option [array of devices] "default"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_input_option()
{ 
    declare -a array=("${!1}")
    typeset -i total=${#array[@]}
    typeset -i index=0
    for var in "${array[@]}"; do
        echo "$((++index))) ${var}"
    done    
    echo "Choose a number between 1 and $total"
    print_this "Default is $2 (${array[$(($2 - 1))]})"
    YN_OPTION=0
    while [[ "$YN_OPTION" -ne 1 ]]; do
        read_input
        if [ -z "$OPTION" ]; then
            OPTION=$2
            break;
        fi
        if ! [[ "$OPTION" =~ ^[0-9]+$ ]] ; then
            invalid_options "$OPTION"
        elif [[ "$OPTION" -le $total && "$OPTION" -ne "0" ]]; then
            break;
        else
            invalid_options "$OPTION"
        fi
    done    
} 
#}}}
# -----------------------------------------------------------------------------
# READ INPUT OPTIONS {{{
# USAGE      : read_input_options "String of values: 1 2 3 or 1-3" 
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
read_input_options()
{ 
    local line=""
    local packages=""
    read -p "$prompt2" OPTION
    array=("$OPTION")
    for line in ${array[@]/,/ }; do
        if [[ ${line/-/} != $line ]]; then
            for ((i=${line%-*}; i<=${line#*-}; i++)); do
                packages+=($i);
            done
        else
            packages+=($line)
        fi
    done
    OPTIONS=(`echo "${packages[@]}" | tr '[:upper:]' '[:lower:]'`)
    write_log "read_input_options  $1 = $OPTION" "$LINENO"
} 
#}}}
# -----------------------------------------------------------------------------
# READ INPUT YN {{{
# USAGE      : read_input_yn
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
read_input_yn()
{ 
    local MY_OPTION=0
    # read_input_yn "Is this Correct" 1
    YN_OPTION="$2" # Set Default value
    # GET INPUT YN {{{
    get_input_yn()
    {
        echo ""
        if [[ "$2" == "1" ]]; then
            read  -n 1 -p "$1 [Y/n]: " 
        else
            read  -n 1 -p "$1 [y/N]: " 
        fi
        YN_OPTION=`echo "$REPLY" | tr '[:upper:]' '[:lower:]'`
        echo ""
    }
    #}}}
    MY_OPTION=0
    while [[ "$MY_OPTION" -ne 1 ]]; do
        get_input_yn "$1" "$2"
        if [ -z "$YN_OPTION" ]; then
            MY_OPTION=1
            YN_OPTION=$2
        elif [[ "$YN_OPTION" == 'y' ]]; then
            MY_OPTION=1
            YN_OPTION=1
        elif [[ "$YN_OPTION" == 'n' ]]; then
            MY_OPTION=1
            YN_OPTION=0
        else 
            MY_OPTION=0
            if [[ "$2" -eq 1 ]]; then
                print_warning "Wrong Key, [Y]es or [n]o required."
            else
                print_warning "Wrong Key, [y]es or [N]o required."
            fi
            pause_function "$LINENO"
        fi
    done
    write_log "read_input_yn [$2] answer $YN_OPTION" "$LINENO" # Left out data, it could be a password or user name.
} 
#}}}
# -----------------------------------------------------------------------------
# READ INPUT DEFAULT {{{
# USAGE      : read_input_default
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
read_input_default()
{ 
    # read_input_default "Enter Data" "Default-Date"
    read -e -p "$1 >" -i "$2" OPTION
    echo ""
    write_log "read_input_default" "$LINENO"
} 
#}}}
# -----------------------------------------------------------------------------
# READ INPUT DATA {{{
# USAGE      : read_input_data "DATA"
# DESCRIPTION: Read Data
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
read_input_data()
{ 
    read -p "$1 : " OPTION
    write_log "read_input_data  $1 = $OPTION" "$LINENO" 
} 
#}}}
# -----------------------------------------------------------------------------
# VERIFY INPUT DEFAULT DATA {{{
# USAGE      : verify_input_default_data "Prompt" "Default-Value" "Default 1=Yes or 0=No" | verify_input_default_data "My Var" "$MYVAR" 1
# DESCRIPTION:
# NOTES:
# AUTHOR: Flesher
# VERSION:
# CREATED:
# REVISION:
verify_input_default_data()
{ 
    read_verify_input()
    {
        echo ""
        read -e -p $"Enter $1 >" -i "$2" OPTION
        echo ""
    }
    YN_OPTION=0
    while [[ "$YN_OPTION" -ne 1 ]]; do
        read_verify_input "$1" "$2"
        read_input_yn $"Verify $1: [$OPTION]" "$3"
        if [ -z "$OPTION" ]; then
            echo "Can not be empty!"
            YN_OPTION=0
        fi
    done
    write_log "verify_input_data $1 = $YN_OPTION" "$LINENO" # Left out data, it could be a password or user name.
} 
#}}}
# -----------------------------------------------------------------------------
# VERIFY INPUT DATA {{{
# USAGE      : verify_input_data "" ""
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
verify_input_data()
{ 
    read_verify_input()
    {
        read -p $"Enter $1 : " OPTION
    }
    YN_OPTION=0
    while [[ "$YN_OPTION" -ne 1 ]]; do
        read_verify_input "$1"
        read_input_yn $"Verify $1: [$OPTION]" "$2"
        if [ -z "$OPTION" ]; then
            echo "Can not be empty!"
            YN_OPTION=0
        fi
    done
    write_log "verify_input_data $1 = $YN_OPTION" "$LINENO" # Left out data, it could be a password or user name.
} 
#}}}
# -----------------------------------------------------------------------------
# MAKE DIR {{{
# USAGE      : make_dir "mydir" "$LINENO"
# DESCRIPTION: Make Directory
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
make_dir()
{
    if [[ -n "$1" ]]; then # Check for Empty
        [[ ! -d "$1" ]] && mkdir -pv "$1"
        if [ -d "$1" ]; then
            write_log "make_dir $1 from $2 at $DATE_TIME" "$LINENO"
            return 0
        else
            write_error "make_dir $1 failed to create directory from line $2." "$LINENO"
            write_log "Log" "$LINENO"
            return 1
        fi
    else
        write_error "Empty: make_dir [$1] failed to create directory from line $2." "$LINENO"
        write_log "Log" "Empty: $LINENO"
        return 1
    fi
}
#}}}
# -----------------------------------------------------------------------------
# MAKE FILE {{{
# USAGE      : make_file "FileName.ext" "$LINENO"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
make_file()
{
    if [ -n "$1" && -n "$2" ]; then # Check for Empty
        [[ ! -f "$1" ]] && touch "$1"    
        if [ -f "$1" ]; then
            write_log "make_file $1 from $2 at $DATE_TIME" "$LINENO"
            return 0
        else
            write_error "make_file $1 failed to create file at $DATE_TIME." "$LINENO"
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
            return 1
        fi
    else
        write_error "Empty: make_file [$1] failed to create file at $DATE_TIME." "$LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "Empty: make_file [$1] at $3 on line $LINENO"; fi
        return 1
    fi
}
#}}}
# -----------------------------------------------------------------------------
# IS WILDCARD FILE {{{
# USAGE      : is_wildcard_file "/from/path/" "filter" 
# DESCRIPTION: Test for Files: is_wildcard_file "/from/path/" "log" # if *.log exist
# NOTES      : filter: if ' ' all, else use extention. If looking for a '/path/.hidden' file, a /path/* fails, so use no wild card, i.e. /path/
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
is_wildcard_file()
{
    get_filter()
    {
       echo $(find "$1" -type f \( -name "*.$2" \))
    }
    if [[ "$2" == " " ]]; then
        if find "$1" -maxdepth 0 -empty | read; then
            return 1  # EMPTY
        else
            return 0  # NOT EMPTY
        fi
    else
        FILTER=$(get_filter "$1" "$2")
        if [ -z "${FILTER}" ]; then    
            return 1  # EMPTY
        else
            return 0  # NOT EMPTY
        fi
    fi
}
#}}}
# -----------------------------------------------------------------------------
# COPY FILES {{{
# USAGE      : copy_files $1"/full-path/" $2"ext" $3"/full-path/to_must_end_with_a_slash/" $4"$LINENO" # All files with .ext extentions
# USAGE      : copy_files $1"/full-path/" $2" "   $3"/full-path/to_must_end_with_a_slash/" $4"$LINENO" # All files including .hidden
# DESCRIPTION: LINENO is for Logging and Debugging
# NOTES      : If looking for a '/path/.hidden' file, a /path/* fails, so use no wild card, i.e. /path/
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
copy_files()
{
    if ! is_wildcard_file "$1" "$2" ; then # " " | "ext" 
        if [[ "$2" == " " ]]; then
            write_error "Files Not Found! copy_files->is_wildcard_file [$1] to [$3] failed to copy file from $4 at $DATE_TIME." "$LINENO"
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "Files Not Found! copy_files -rfv [$1] to [$3] from $4 ($LINENO)"; fi
        else
            write_error "Files Not Found! copy_files->is_wildcard_file [$1*.$2] to [$3] failed to copy file from $4 at $DATE_TIME." "$LINENO"
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "Files Not Found! copy_files -fv [$1*.$2] to [$3] from $4 ($LINENO)"; fi
        fi
        return 1
    fi
    local dir_to="${3%/*}"
    # local file_to="${3##*/}"
    if [[ ! -d "$dir_to" && -n "$dir_to" ]]; then  # Check for Empty
        make_dir "$dir_to" "$LINENO"
    fi
    if [[ -n "$1" && -n "$3" ]]; then  # Check for Empty
        if [[ "$2" == " " ]]; then
            TEMP=$(cp -rfv "$1." "$3")     # /path/. copy all files and folders recursively
        else
            TEMP=$(cp -fv "$1*.$2" "$3")   # /path/*.ext copy only files with matching extensions
        fi
        if [ $? -eq 0 ]; then
            if [[ "$2" == " " ]]; then
                write_log "copy_files -rfv [$1] to [$3] from $4 at $DATE_TIME" "$LINENO"
            else
                write_log "copy_files -fv [$1*.$2] to [$3] from $4 at $DATE_TIME" "$LINENO"
            fi
            return 0
        else
            if [[ "$2" == " " ]]; then
                write_error "copy_files -rfv [$1] to [$3] failed to copy file from $4." "$LINENO"
            else
                write_error "copy_files -fv [$1*.$2] to [$3] failed to copy file from $4 at $DATE_TIME." "$LINENO"
            fi
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "copy_files $1*.$2 to $3 from $4 returned $TEMP ($LINENO)"; fi
            return 1
        fi
    else
        write_error "Empty: copy_files [$1*.$2] to [$2] failed to copy file from $3 at $DATE_TIME." "$LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "Empty: copy_files [$1*.$2] to [$2] from $3 ($LINENO)"; fi
        return 1
    fi
}
#}}}
# -----------------------------------------------------------------------------
# COPY FILE {{{
# USAGE      : copy_file "/full-path/from.ext" "/full-path/to_must_end_with_a_slash/" "$LINENO"
# DESCRIPTION: LINENO is for Logging and Debugging
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
copy_file()
{
    # 
    if [ ! -f "$1" ]; then
        write_error "File Not Found! copy_file $1 to $2 failed to copy file from $3 at $DATE_TIME." "$LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "File Not Found! copy_file $1 to $2 from $3 ($LINENO)"; fi
        return 1
    fi
    local dir_to="${2%/*}"
    # local file_to="${2##*/}"
    if [[ ! -d "$dir_to" && -n "$dir_to" ]]; then # Check for Empty
        make_dir "$dir_to" "$LINENO"
    fi
    if [[ -n "$1" && -n "$2" ]]; then # Check for Empty
        cp -fv "$1" "$2"
        if [ $? -eq 0 ]; then
            write_log "copy_file $1 to $2 from $3 at $DATE_TIME" "$LINENO"
            return 0
        else
            write_error "copy_file $1 to $2 failed to copy file from $3 at $DATE_TIME." "$LINENO"
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "copy_file $1 to $2 from $3 ($LINENO)"; fi
            return 1
        fi
    else
        write_error "Empty: copy_file [$1] to [$2] failed to copy file from $3 at $DATE_TIME." "$LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "Empty: copy_file [$1] to [$2] from $3 ($LINENO)"; fi
        return 1
    fi
}
#}}}
# -----------------------------------------------------------------------------
# COPY DIRECTORY {{{
# USAGE      : copy_dir "/full-path/" "/full-path/to_must_end_with_a_slash/" "$LINENO"
# DESCRIPTION: LINENO is for Logging and Debugging
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
copy_dir()
{
    local dir_to="${2%/*}"
    # local file_to="${2##*/}"
    if [ ! -d "$dir_to" ]; then
        if [ -n "$dir_to" ]; then
            make_dir "$dir_to" "$LINENO"
        fi
    fi
    if [[ -n "$1" && -n "$2" ]]; then
        TEMP=$(cp -rfv "$1" "$2")
        if [ $? -eq 0 ]; then
            write_log "copy_dir [$1] to [$2] from $3 at $DATE_TIME" "$LINENO"
            return 0
        else
            write_error "copy_dir [$1] to [$2] failed to copy file from $3 returned $TEMP at $DATE_TIME." "$LINENO"
            # @FIX if /etc resolv.conf needs its attributes changed
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
            return 1
        fi
    else
        write_error "Empty: copy_dir [$1] to [$2] failed to copy file from $3 at $DATE_TIME." "$LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
        return 1
    fi
}
#}}}
# -----------------------------------------------------------------------------
# IS INTERNET {{{
# USAGE      : is_internet
# DESCRIPTION: Check if Internet is up by Pinging two Major DNS servers
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
is_internet()
{
    host1="google.com"
    host2="wikipedia.org"
    print_info $"Checking for Internet Connection..."
    ((ping -w5 -c3 "$host1" || ping -w5 -c3 "$host2") > /dev/null 2>&1) && return 0 || return 1
}
#}}}
# -----------------------------------------------------------------------------
# GET INDEX {{{
# USAGE      : get_index
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_index() 
{
    # get_index "ARRAY[@]" "Find-This" # return in $?
    declare -a i_array=("${!1}")
    typeset -i total=${#i_array[@]}
    typeset -i index=0
    for (( index=0; index<${total}; index++ )); do
        if [[ "${i_array[$index]}" = "$2" ]]; then
            return $[index]
        fi
    done
}    
#}}}
# ----------------------------------------------------------------------------- 
# IS LAST ITEM {{{
# USAGE      : is_last_item
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
is_last_item() 
{
    declare -a i_array=("${!1}")
    typeset -i total=${#i_array[@]}
    typeset -i index=0
    for (( index=0; index<${total}; index++ )); do
        if [[ "${i_array[$index]}" = "$2" ]]; then
            if [[ $[index + 1] -eq ${#i_array[@]} ]]; then
                return 0
            else
                return 1
            fi
        fi
    done
}    
#}}}
# ----------------------------------------------------------------------------- 
# WRITE ERROR {{{
# USAGE      : write_error "Error" "$LINENO"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
write_error()
{
    echo "$1 ($2)" >> "$ERROR_LOG"
}
#}}}
# ----------------------------------------------------------------------------- 
# WRITE LOG {{{
# USAGE      : write_log "Log" "$LINENO"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
write_log()
{
    echo "$1 ($2)"  >> "$ACTIVITY_LOG"
}
#}}}
# -----------------------------------------------------------------------------
# TRIM {{{
# USAGE      : trim
# DESCRIPTION: Remove space on Rigt and Left of string
# NOTES      :
#               MY_SPACE=" Left and Right "
#               MY_SPACE=$(trim "$MY_SPACE")
#               echo "trim |$MY_SPACE|"
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
trim() 
{ 
    echo $(rtrim "$(ltrim "$1")")
}
#}}}
# -----------------------------------------------------------------------------
# LEFT TRIM {{{
# USAGE      : ltrim
# DESCRIPTION: Remove space on Left of string
# NOTES      :
#               MY_SPACE=" Left and Right "
#               MY_SPACE=$(ltrim "$MY_SPACE")
#               echo "ltrim |$MY_SPACE|"
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
ltrim()
{
    # Remove Left or Leading Space
    echo "$1" | sed 's/^ *//g'
}
#}}}
# -----------------------------------------------------------------------------
# RIGHT TRIM {{{
# USAGE      : rtrim
# DESCRIPTION: Remove space on Right of string
# NOTES      :
#               MY_SPACE=" Left and Right "
#               MY_SPACE=$(rtrim "$MY_SPACE")
#               echo "rtrim |$MY_SPACE|"
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
rtrim()
{
    # Remove Right or Trailing Space
    echo "$1" | sed 's/ *$//g'
}
#}}}
# -----------------------------------------------------------------------------
# IS USER {{{
# USAGE      : is_user "USERNAME"
# DESCRIPTION: Checks if USERNAME exist
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
is_user()
{
    egrep -i "^$1" /etc/passwd
    return $?
}
#}}}
# -----------------------------------------------------------------------------
# IS GROUP {{{
# USAGE      : is_group "GROUPNAME"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
is_group()
{
    egrep -i "^$1" /etc/group
    return $?
}
#}}}
# -----------------------------------------------------------------------------
# IS USER IN GROUP {{{
# USAGE      : is_user_in_group "GroupName"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
is_user_in_group()
{
    groups "$USERNAME" | grep "$1"
    return $?
}
#}}}
# -----------------------------------------------------------------------------
# ADD USER 2 GROUP {{{
# USAGE      : add_user_2_group "GroupName"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
add_user_2_group()
{
    if ! is_user_in_group "$1" ; then
        passwd -a $USERNAME "$1"
        write_log "add_user_2_group $1" "$LINENO"    
        return 1
    fi
    return 0
}
#}}}
# -----------------------------------------------------------------------------
# ADD GROUP {{{
# USAGE      : add_group "GroupName"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
add_group()
{
    if ! is_group "$1" ; then
        groupadd "$1"
        write_log "add_group $1" "$LINENO"    
        return 1
    fi
    return 0
}
#}}}
# -----------------------------------------------------------------------------
# CONFIG XINITRC {{{
# USAGE      : config_xinitrc
# DESCRIPTION: Edit .xinitrc file for manual start of Desktop
# NOTES      : https://wiki.archlinux.org/index.php/Xinitrc
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
config_xinitrc()
{ 
    # create a xinitrc file in home user directory
    # exec gnome-session-cinnamon
    echo $("echo -e \"exec ck-launch-session $1\" >> /home/\$USERNAME/.xinitrc; chown -R \$USERNAME:\$USERNAME /home/\$USERNAME/.xinitrc")
} 
#}}}
# *****************************************************************************
# Menu System
# *****************************************************************************
# USAGE      : 
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
Menu=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )                # MAIN MENU
DESKTOP_ENVIRONMENT=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) # DESKTOP ENVIRONMENT
DISPLAY_MANAGER=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )     # DISPLAY MANAGER
ACCESSORIES_APPS=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )    # ACCESSORIES APPS
DEVELOPMENT_APPS=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )    # DEVELOPMENT APPS
OFFICE_APPS=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )         # OFFICE APPS
#SubMenuA=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
#SubMenuA=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
#SubMenuA=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
#SubMenuA=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
#SubMenuA=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
#SubMenuA=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
#SubMenuA=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
#SubMenuA=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )

SubMenuA=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
SubMenuA1=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
SubMenuA2=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )

SubMenuB=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
SubMenuB1=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
SubMenuB2=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
#
declare -i SAVED_MENU=0
declare -i SAVED_SUBMENU=0
declare -i SAVED_SSMENU=0
# SAVE ARRAY {{{
save_array()
{
    declare -a array=("${!1}")
    typeset -i total=${#array[@]}
    for (( i=0; i<${total}; i++ )); do
        if [[ "$i" == 0 ]]; then
            echo "${array[$i]}"  > "$MENU_PATH/$2"
        else
            echo "${array[$i]}" >> "$MENU_PATH/$2"
        fi
    done
}
#}}}
# -----------------------------------------------------------------------------
# LOAD ARRAY {{{
# USAGE      : load_array
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
load_array()
{
    if [[ -f "$1" ]]; then
        while read line; do 
            echo "$line" 
        done < "$MENU_PATH/$1"
    else
        typeset -i total=${#Menu[@]}
        for (( i=0; i<${total}; i++ )); do
            echo "0" 
        done
    fi
}
#}}}
# -----------------------------------------------------------------------------
# SAVE MENU {{{
# USAGE      : save_menu
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
save_menu()
{
    print_info "Saved"
    save_array "Menu[@]"  "Menu.db"
    #    
    save_array "DESKTOP_ENVIRONMENT[@]"  "DESKTOP_ENVIRONMENT.db"
    save_array "DISPLAY_MANAGER[@]"  "DISPLAY_MANAGER.db"
    save_array "ACCESSORIES_APPS[@]"  "ACCESSORIES_APPS.db"
    save_array "ACCESSORIES_APPS[@]"  "ACCESSORIES_APPS.db"
    save_array "DEVELOPMENT_APPS[@]"  "DEVELOPMENT_APPS.db"
    save_array "OFFICE_APPS[@]"  "OFFICE_APPS.db"
    #save_array "SubMenuA[@]"  "SubMenuA.db"
    #save_array "SubMenuA[@]"  "SubMenuA.db"
    #save_array "SubMenuA[@]"  "SubMenuA.db"
    #
    save_array "SubMenuA[@]"  "SubMenuA.db"
    save_array "SubMenuA1[@]" "SubMenuA1.db"
    save_array "SubMenuA2[@]" "SubMenuA2.db"

    save_array "SubMenuB[@]"  "SubMenuB.db"
    save_array "SubMenuB1[@]" "SubMenuB1.db"
    save_array "SubMenuB2[@]" "SubMenuB2.db"
    pause_function "$LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# LOAD MENU {{{
# USAGE      : load_menu
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
load_menu()
{
    Menu=( $(load_array "Menu.db") )
    #
    DESKTOP_ENVIRONMENT=( $(load_array "DESKTOP_ENVIRONMENT.db") )
    DISPLAY_MANAGER=( $(load_array "DISPLAY_MANAGER.db") )
    ACCESSORIES_APPS=( $(load_array "ACCESSORIES_APPS.db") )
    DEVELOPMENT_APPS=( $(load_array "DEVELOPMENT_APPS.db") )
    OFFICE_APPS=( $(load_array "OFFICE_APPS.db") )
    #SubMenuA=( $(load_array "SubMenuA.db") )
    #SubMenuA=( $(load_array "SubMenuA.db") )
    #SubMenuA=( $(load_array "SubMenuA.db") )
    #SubMenuA=( $(load_array "SubMenuA.db") )
    #SubMenuA=( $(load_array "SubMenuA.db") )
    #SubMenuA=( $(load_array "SubMenuA.db") )
    #SubMenuA=( $(load_array "SubMenuA.db") )
    #
    SubMenuA=( $(load_array "SubMenuA.db") )
    SubMenuA1=( $(load_array "SubMenuA1.db") )
    SubMenuA2=( $(load_array "SubMenuA2.db") )

    SubMenuB=( $(load_array "SubMenuB.db") )
    SubMenuB1=( $(load_array "SubMenuB1.db") )
    SubMenuB2=( $(load_array "SubMenuB2.db") )
}
#}}}
# -----------------------------------------------------------------------------
#
SPACE='\x20'
#
# MAIN MENU {{{
checklist=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
clear_main()
{
    checklist=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
}
#}}}
# -----------------------------------------------------------------------------
# SUB MENU {{{
checklistsub=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
clear_sub()
{
    checklistsub=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
}
#}}}
# -----------------------------------------------------------------------------
# SUB MENU {{{
checklistsubsub=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
clear_subsub()
{
    checklistsubsub=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
}
#}}}
# -----------------------------------------------------------------------------
MM_ITEMS=()
RESET_MM=1
# {{{
clear_mainmenu()
{ 
    MM_ITEMS=()
    RESET_MM=1
} 
#}}}
# -----------------------------------------------------------------------------
# MAIN MENU ITEM {{{
# USAGE      : mainmenu_item
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
mainmenu_item()
{ 
    # 1. Menu Item: Alpha Numberic
    # 2. Menu Description
    # 3. Package Name
    # 4. Warning
    if [[ $RESET_MM -eq 1 ]]; then
        RESET_MM=0
        MM_ITEMS[0]="$1) $(checkbox ${checklist[$1]}) ${BWhite}$2${White} ${BYellow}$3${White} ${BRed}$4${White}"
    else
        MM_ITEMS[$[${#MM_ITEMS[@]}]]="$1) $(checkbox ${checklist[$1]}) ${BWhite}$2${White} ${BYellow}$3${White} ${BRed}$4${White}"
    fi
} 
#}}}
# -----------------------------------------------------------------------------
# PRINT MAIN MENU {{{
# USAGE      : print_mm
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
print_mm()
{ 
    typeset -i total=${#MM_ITEMS[@]}
    typeset -i index=0
    tput sgr0
    for (( index=0; index<${total}; index++ )); do
        if [[ "$index" -lt 9 ]]; then
            echo -e "${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${MM_ITEMS[$index]}"; tput sgr0
        else
            echo -e "${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${MM_ITEMS[$index]}"; tput sgr0    
        fi
    done
    if [[ "$1" == 'Q' ]]; then
        MY_ACTION=$"Quit"
        echo ""
        echo -e "${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}Q) $MY_ACTION"; tput sgr0 
        echo ""
    elif [[ "$1" == 'B' ]]; then
        MY_ACTION=$"Back"
        echo ""
        echo -e $"${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}B) $MY_ACTION"; tput sgr0 
        echo ""
    elif [[ "$1" == 'D' ]]; then
        MY_ACTION=$"Done"
        echo ""
        echo -e $"${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}D) $MY_ACTION"; tput sgr0 
        echo ""
    fi
} 
#}}}
# -----------------------------------------------------------------------------
SM_ITEMS=()
RESET_SM=1
# CLEAR SUB MENU {{{
# USAGE      : clear_smenu
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
clear_smenu()
{ 
    SM_ITEMS=()
    RESET_SM=1
} 
#}}}
# -----------------------------------------------------------------------------
# SUB MENU ITEM {{{
# USAGE      : submenu_item 
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
submenu_item()
{ 
    # 1. Menu Item: Alpha Numberic
    # 2. Menu Description
    # 3. Package Name
    # 4. Warning
    if [[ $RESET_SM -eq 1 ]]; then
        RESET_SM=0
        SM_ITEMS[0]="$1) $(checkbox ${checklistsub[$1]}) ${BWhite}$2${White} ${BYellow}$3${White} ${BRed}$4${White}"
    else
        SM_ITEMS[$[${#SM_ITEMS[@]}]]="$1) $(checkbox ${checklistsub[$1]}) ${BWhite}$2${White} ${BYellow}$3${White} ${BRed}$4${White}"
    fi
} 
#}}}
# -----------------------------------------------------------------------------
# PRINT SUB MENU {{{
# USAGE      : print_sm
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
print_sm()
{ 
    typeset -i total=${#SM_ITEMS[@]}
    typeset -i index=0
    tput sgr0
    for (( index=0; index<${total}; index++ )); do
        if [[ "$index" -lt 9 ]]; then
            echo -e "${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SM_ITEMS[$index]}"; tput sgr0
        else
            echo -e "${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SM_ITEMS[$index]}"; tput sgr0    
        fi
    done
    if [[ "$1" == 'Q' ]]; then
        MY_ACTION=$"Quit"
        echo ""
        echo -e "${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}Q) $MY_ACTION"; tput sgr0 
        echo ""
    elif [[ "$1" == 'B' ]]; then
        MY_ACTION=$"Back"
        echo ""
        echo -e $"${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}B) $MY_ACTION"; tput sgr0 
        echo ""
    elif [[ "$1" == 'D' ]]; then
        MY_ACTION=$"Done"
        echo ""
        echo -e $"${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}D) $MY_ACTION"; tput sgr0 
        echo ""
    fi
} 
#}}}
# -----------------------------------------------------------------------------
SSUBM_ITEMS=( "" )
RESET_SSM=1
# {{{
clear_ssmenu()
{ 
    SSUBM_ITEMS=( "" )
    RESET_SM=1
} 
#}}}
# -----------------------------------------------------------------------------
# SUB-SUB MENU ITEM {{{
# USAGE      : subsubmenu_item
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
subsubmenu_item()
{ 
    # 1. Menu Item: Alpha Numberic
    # 2. Menu Description
    # 3. Package Name
    # 4. Warning
    if [[ $RESET_SSM -eq 1 ]]; then
        RESET_SSM=0
        SSUBM_ITEMS[0]="$1) $(checkbox ${checklistsubsub[$1]}) ${BWhite}$2${White} ${BYellow}$3${White} ${BRed}$4${White}"
    else
        SSUBM_ITEMS[$[${#SSUBM_ITEMS[@]}]]="$1) $(checkbox ${checklistsubsub[$1]}) ${BWhite}$2${White} ${BYellow}$3${White} ${BRed}$4${White}"
    fi
} 
#}}}
# -----------------------------------------------------------------------------
# PRINT SUB SUB MENU {{{
# USAGE      : print_ssm
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
print_ssm()
{ 
    typeset -i total=${#SSUBM_ITEMS[@]}
    typeset -i index=0
    tput sgr0
    for (( index=0; index<${total}; index++ )); do
        if [[ "$index" -lt 9 ]]; then
            echo -e "${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SSUBM_ITEMS[$index]}"; tput sgr0
        else
            echo -e "${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SSUBM_ITEMS[$index]}"; tput sgr0    
        fi
    done
    if [[ "$1" == 'Q' ]]; then
        MY_ACTION=$"Quit"
        echo ""
        echo -e "${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}Q) $MY_ACTION"; tput sgr0 
        echo ""
    elif [[ "$1" == 'B' ]]; then
        MY_ACTION=$"Back"
        echo ""
        echo -e $"${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}B) $MY_ACTION"; tput sgr0 
        echo ""
    elif [[ "$1" == 'D' ]]; then
        MY_ACTION=$"Done"
        echo ""
        echo -e $"${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}D) $MY_ACTION"; tput sgr0 
        echo ""
    fi
} 
#}}}
# -----------------------------------------------------------------------------
# *******************************************************************************************************************************
# ADD PACKAGEMANAGER NAME  {{{
# USAGE      : add_packagemanager_name
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
add_packagemanager_name()
{
    if [ "${#PACKMANAGER_NAME}" -eq 0 ]; then
        PACKMANAGER_NAME[0]="$1"
    else
        PACKMANAGER_NAME[${#PACKMANAGER_NAME[*]}]="$1"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# ADD PACKAGEMANAGER {{{
# USAGE      : add_packagemanager "COMMAND-LINE" "NAME-OF-PACKAGE"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
add_packagemanager()
{
    if [ -z "$2" ]; then
        print_warning $"Wrong Paramaters to add_packagemanager"
        exit 0
    fi
    CMD="$(rtrim $1)"
    if [[ -z "$CMD" || "$CMD" == "" ]]; then
        return 1
    fi
    is_in_array "PACKMANAGER_NAME[@]" "$2"
    #if is_in_array "PACKMANAGER_NAME[@]" "$2" -eq 0 ; then
    if [ "$?" -eq 0 ]; then
        if [ "${#PACKMANAGER}" -eq 0 ]; then
            PACKMANAGER[0]="$1"
        else
            PACKMANAGER[${#PACKMANAGER[*]}]="$1"
        fi
        add_packagemanager_name "$2"
    else
        # Replace it with this new value
        get_index "PACKMANAGER_NAME[@]" "$2" # return in $?
        PACKMANAGER[$(($?))]="$1"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# 
# ADD MODULE {{{
# USAGE      :  add_module
# DESCRIPTION:
# NOTES      : Call per Module
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
add_module()
{ 
    add_packagemanager "echo \"# Load $1 at boot\" > /etc/modules-load.d/${1}.conf; echo \"${1}\" >> /etc/modules-load.d/${1}.conf; modprobe $1" "$2"
} 
#}}}
# -----------------------------------------------------------------------------
TEMPVAR="NONE"
# IS IN ARRAY {{{
# USAGE      : is_in_array
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
is_in_array()
{
    declare -a array=("${!1}")     # Array 
    typeset -i total=${#array[@]}
    typeset -i i=0
    for (( i=0; i<${total}; i++ )); do        # Array
        if [ "$2" == "${array[$i]}" ]; then
            TEMPVAR="$2"
            return 0
        fi
    done
    return 1
}
#}}}
# -----------------------------------------------------------------------------

declare -a REMOVED_INDEXES=( "" ) 
# CLEAR REMOVE INDEX {{{
# USAGE      : clear_removed_index
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
clear_removed_index()
{
    REMOVED_INDEXES=( "" )
}
#}}}
# -----------------------------------------------------------------------------
# ADD REMOVED INDEX {{{
# USAGE      : add_removed_index
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
add_removed_index()
{
    if [ -z "$REMOVED_INDEXES" ]; then
        REMOVED_INDEXES[0]="$1" # Accessing below first will give unbound variable error
    else
        REMOVED_INDEXES[$[${#REMOVED_INDEXES[@]}]]="$1"
    fi    
}
#}}}
# -----------------------------------------------------------------------------
# REMOVE ARRAY INDEXES {{{
# USAGE      : remove_array_indexes
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
remove_array_indexes()
{
    declare -a array=("${!1}")     # Array passed in: ( "This" "That" "That" ) 
    typeset -i total=${#array[@]}
    typeset -i itotal=${#REMOVED_INDEXES[@]}
    declare -a sarray=( "" )
    typeset -i i=0
    typeset -i j=0
    typeset -i y=0
    for (( i=0; i<${total}; i++ )); do        # Array 
        y=0
        for (( j=0; j<${itotal}; j++ )); do   # Array of indexes to remove: ( 2 6 8 )
            if [ "$i" = "${REMOVED_INDEXES[$j]}" ]; then
                y=1
                break;
            fi
        done
        if [[ "$y" -ne 1 ]]; then
            sarray[$y]="${array[$i]}"
        fi
    done
}
# REMOVE ARRAY DUPLICATES {{{
# USAGE      : remove_array_duplicates
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
remove_array_duplicates()
{
    # Test Code
    # MY_ARR=("MY" "MY" "2" "2" "LIST" "LIST" "OK")
    # typeset -i total=${#MY_ARR[@]}
    # echo ${MY_ARR[@]} # Prints: MY MY 2 2 LIST LIST OK
    # MY_ARR=( $(remove_dups MY_ARR[@]) )
    # echo ${MY_ARR[@]} # Prints: MY 2 LIST OK    declare -a array=("${!1}")
    # for (( index=0; index<${total}; index++ )); do echo "ARRAY= ${MY_ARR[$index]}"; done # to echo with new line
    declare -a array=("${!1}")
    typeset -i total=${#array[@]}
    declare -a sarray=( "" )
    typeset -i i=0
    typeset -i j=0
    typeset -i y=0
    for (( i=0; i<${total}; i++ )); do
        (( j = i + 1 ))
        while (( j < total )); do
            if [ "${array[$i]}" = "${array[$j]}" ]; then
                break
            fi
            (( j = j + 1 ))
        done
        if [[ "$j" = "$total" ]]; then
            sarray[$y]="${array[$i]}"
            (( y = y + 1 ))
        else
            add_removed_index "$i"
        fi
    done
    # Must echo to fill array
    for element in ${sarray[*]}; do
        echo "${element}"
    done
}
#}}}
# -----------------------------------------------------------------------------
# REMOVE DUPLICATES {{{
# USAGE      : remove_duplicates
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
remove_duplicates()
{
    # Create and Array and assign it to MY_STRING
    MY_STRING=`echo "$1" | tr " " "\n" | sort | uniq`
    MY_STRING=`echo "$MY_STRING" | tr "\n" " "`
}
#}}}
# -----------------------------------------------------------------------------
# ADD USER GROUP {{{
# USAGE      : add_user_group
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
add_user_group()
{
    if [[ ${#USER_GROUPS} -eq 0 ]]; then
        USER_GROUPS[0]="$1" # Accessing below first will give unbound variable error
    else
        USER_GROUPS[${#USER_GROUPS[*]}]="$1"
    fi    
    #assert "$1" "$USER_GROUPS[$[${#USER_GROUPS[@]}]]" "$LINENO"
    USER_GROUPS=( $( remove_array_duplicates "USER_GROUPS[@]") )
}
#}}}
# -----------------------------------------------------------------------------
# LOAD CUSTOM SOFTWARE {{{
# USAGE      : load_custom_software
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
load_custom_software()
{
    # Hand edited list of software not in Script
    if [[ -f "$CONFIG_PATH/custom-software-list.txt" ]]; then
        print_info $"Edit or review file first."
        $EDITOR "$CONFIG_PATH/custom-software-list.txt"
        # @FIX add name section to file
        # Name
        # software-2-install more and-more
        # like load_last-config
        while read line; do 
            add_packagemanager "package_install '$line" "NAME" # @FIX
        done < "$CONFIG_PATH/custom-software-list.txt"
    else
        echo "No $CONFIG_PATH/custom-software-list.txt file found!"
        pause_function "$LINENO"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# CREATE CONFIG {{{
# USAGE      : create_config
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
create_config()
{
    get_hostname              # $CONFIG_HOSTNAME
    get_user_name             # $USERNAME
    get_editor                # $EDITOR
    configure_keymap          # $KEYMAP
    get_keyboard_layout       # $KEYBOARD
    get_country_code          # $COUNTRY_CODE
    configure_timezone        # $ZONE and $SUBZONE
    get_locale                # $LOCALE
    choose_aurhelper          # $AUR_HELPER get_run_aur_root $RUN_AUR_ROOT
    custom_nameservers        # $IS_CUSTOM_NAMESERVER
    get_flesh                 # $FLESH
    get_aur_package_folder    # $AUR_PACKAGE_FOLDER
    save_last_config
}
#}}}
# -----------------------------------------------------------------------------
# Change User {{{
# USAGE      : change_user
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
change_user()
{
    load_last_config
    get_hostname              # $CONFIG_HOSTNAME
    get_user_name             # $USERNAME
    get_aur_package_folder    # $AUR_PACKAGE_FOLDER
    save_last_config
}
#}}}
# -----------------------------------------------------------------------------
# VERIFY CONFIG {{{
# USAGE      : verify_config
# DESCRIPTION: Verify Configfiguration settings.
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
verify_config()
{
    if [[ "$CONFIG_VERIFIED" -eq 1 ]]; then return 0; fi
    CONFIG_VERIFIED=1
    is_software_files
    if [[ "$IS_SOFTWARE_CONFIG_LOADED" -eq 1 ]]; then            
        print_info "A Configuration file has been detected, you can edit it, then verfiy you wish to continue using it."
        show_loaded # Ask if you wish to load Software and Last Config
        print_info "You can just change User Name, or whole configuration."
        read_input_yn "Do you wish to change User Name" 0
        if [[ "$YN_OPTION" -eq 1 ]]; then
            change_user
        fi       
        read_input_yn "Do you wish to edit these settings" 0
        if [[ "$YN_OPTION" -eq 1 ]]; then
            create_config
        fi
    fi
    #
    if [[ -f "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db" && "$BOOT_MODE" -eq 1 ]]; then
        print_info $"You now need to verify the Disk Settings"
        show_disk_profile
        read_input_yn "Do you wish change Disk Profile" 0
        if [[ "$YN_OPTION" -eq 1 ]]; then
            edit_disk
        else
            show_disk_profile
            read_input_yn "Do you wish to continue with this Disk Profile" 1
            if [[ "$YN_OPTION" -eq 0 ]]; then
                print_warning "Run Script again, after you decide on a Disk Profile."
                exit 1
            else
                DISK_PROFILE=1
            fi
        fi
    fi
    #
    if [ -f "$USER_FOLDER/.xinitrc" ]; then             # "$SCRIPT_DIR/USER"
        read_input_yn "Import User Folder settings" 1
        if [[ "$YN_OPTION" -eq 1 ]]; then
            copy_files "$USER_FOLDER/" " " "/home/$USERNAME/" "$LINENO"
        fi
    else
        if [[ "$MOUNTPOINT" == " " ]]; then
            USER_FOLDER="/home/$USERNAME"
        else
            USER_FOLDER="$SCRIPT_DIR/USER"
            make_dir "$USER_FOLDER/" "$LINENO"
        fi
        if [ ! -f "$USER_FOLDER/.xinitrc" ]; then
            if [ ! -f /etc/skel/.xinitrc ]; then                    # Create .xinitrc file in user folder
                echo "#!/bin/sh"                                    > "$USER_FOLDER/.xinitrc"
                echo "if [ -d /etc/X11/xinit/xinitrc.d ]; then"    >> "$USER_FOLDER/.xinitrc"
                echo "    for f in /etc/X11/xinit/xinitrc.d/*; do" >> "$USER_FOLDER/.xinitrc"
                echo "        [ -x \"\$f\" ] && . \"\$f\""         >> "$USER_FOLDER/.xinitrc"
                echo "    done"                                    >> "$USER_FOLDER/.xinitrc"
                echo "    unset f"                                 >> "$USER_FOLDER/.xinitrc"
                echo "fi"                                          >> "$USER_FOLDER/.xinitrc"
                echo " "                                           >> "$USER_FOLDER/.xinitrc"
            else
                copy_file "/etc/skel/.xinitrc" "$USER_FOLDER/" "$LINENO"
            fi
        fi
    fi
    print_info "Configuration File Check Completed..."
    return 0
}
#}}}
# -----------------------------------------------------------------------------
# YES NO {{{
# USAGE      : yes_no [0=no, 1=yes]
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
yes_no()
{
    if [[ "$1" -eq 1 ]]; then
        echo $"Yes"
    else
        echo $"No"
    fi
}
#}}}
# -----------------------------------------------------------------------------

# SHOW PACKMANAGER {{{
# USAGE      : show_packmanager
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
show_packmanager()
{
    total=${#PACKMANAGER[@]}
    for (( index=0; index<${total}; index++ )); do
        # @FIX more; figure out how many lines to show
        echo -e "${PACKMANAGER[$index]}"
    done
}
#}}}
# -----------------------------------------------------------------------------
# SHOW LOADED {{{
# USAGE      : show_loaded
# DESCRIPTION: Show Loaded Variables
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
show_loaded()
{
    print_this "Software Configuration Database is built using the Full install mode with -a, or -i for Install Software mode, then saved to this file."
    read_input_yn "Load Software Configuration Database" 1 
    if [[ "YN_OPTION" -eq 1 ]]; then
        load_software
        if [[ "$IS_SOFTWARE_CONFIG_LOADED" -eq 0 ]]; then
            print_warning "Software Config failed to load at line $LINENO"
            exit 0
        fi
        print_title "Configuration and Software Install Variables:"
        print_this "$TEXT_SCRIPT_ID"
        echo -e "WEBSERVER            = ${BWhite}$WEBSERVER${White}"
        echo -e "CONFIG_ORPHAN        = ${BWhite}$(yes_no $CONFIG_ORPHAN)${White}"
        echo -e "CONFIG_XORG          = ${BWhite}$(yes_no $CONFIG_XORG)${White}"
        echo -e "CONFIG_SSH           = ${BWhite}$(yes_no $CONFIG_SSH)${White}"
        echo -e "CONFIG_TOR           = ${BWhite}$(yes_no $CONFIG_TOR)${White}"
        echo -e "CONFIG_KDE           = ${BWhite}$(yes_no $CONFIG_KDE)${White}"
        echo -e "USER_GROUPS          = ${BWhite}${USER_GROUPS[*]}${White}"
        echo -e "VIDEO_CARD           = ${BWhite}${VIDEO_CARDS[$(($VIDEO_CARD - 1))]}${White}"
        echo -e " "
        read_input_yn "View Package Manager Commands: Use Shift-PageUp and Down if scrolls off screen." 1 
        if [[ "YN_OPTION" -eq 1 ]]; then
            show_packmanager
        fi      
        echo -e " "
    fi
    read_input_yn "Load User Configuration Database" 1 
    if [[ "YN_OPTION" -eq 1 ]]; then
        load_last_config
        if [[ "$IS_LAST_CONFIG_LOADED" -eq 0 ]]; then
            print_warning "Software Config failed to load at line $LINENO"
            exit 0
        fi
        echo -e " "
        echo -e "The below Configuration Settings can be changed without re-running Software install."
        echo -e ""
        echo -e "FLESH                = ${BWhite}$(yes_no $FLESH)${White}"
        echo -e "CUSTOM_MIRRORLIST    = ${BWhite}$(yes_no $CUSTOM_MIRRORLIST)${White}"
        echo -e "NETWORK_MANAGER      = ${BWhite}$NETWORK_MANAGER${White}"
        echo -e "FSTAB_CONFIG         = ${BWhite}${FSTAB[$((FSTAB_CONFIG - 1))]}${White}"
        echo -e "FSTAB_EDIT           = ${BWhite}$(yes_no $FSTAB_EDIT)${White}"
        echo -e "Time ZONE/SUBZONE    = ${BWhite}$ZONE/$SUBZONE${White}"
        echo -e "COUNTRY_CODE         = ${BWhite}$COUNTRY_CODE${White}"
        echo -e "KEYMAP               = ${BWhite}$KEYMAP${White}"
        echo -e "KEYBOARD             = ${BWhite}$KEYBOARD${White}"
        echo -e "IS_CUSTOM_NAMESERVER = ${BWhite}$(yes_no $IS_CUSTOM_NAMESERVER) DNS1=$CUSTOM_NS1 DNS2=$CUSTOM_NS1 Search=$CUSTOM_NS_SEARCH${White}"
        echo -e "AUR_HELPER           = ${BWhite}$AUR_HELPER${White}" 
        echo -e "AUR_PACKAGE_FOLDER   = ${BWhite}$AUR_PACKAGE_FOLDER${White}" 
        echo -e "RUN_AUR_ROOT         = ${BWhite}$(yes_no $RUN_AUR_ROOT)${White}"
        total=${#LOCALE_ARRAY[@]}
        for (( index=0; index<${total}; index++ )); do
            echo -e "LOCALE $index         = ${BWhite} ${LOCALE_ARRAY[$index]} ${White}"
        done
        echo -e "CONFIG_HOSTNAME      = ${BWhite}$CONFIG_HOSTNAME${White}"
        echo -e "EDITOR               = ${BWhite}$EDITOR${White}"
        echo -e "USERNAME             = ${BWhite}$USERNAME${White}"
        echo -e " "
    fi
}
#}}}
# -----------------------------------------------------------------------------
# SHOW DISK PROFILE {{{
# USAGE      : show_disk_profile
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
show_disk_profile()
{
    load_disk_config
    print_title "Disk Profile: Configuration Variables:"
    print_this "$TEXT_SCRIPT_ID"
    echo -e "UEFI                 = ${BWhite} $(yes_no $UEFI) ${White}"
    if [[ "$UEFI" -eq 1 ]]; then
        echo -e "UEFI_SIZE            = ${BWhite} $UEFI_SIZE ${White}"
    fi
    echo -e "IS_BOOT_PARTITION    = ${BWhite} $(yes_no $IS_BOOT_PARTITION) ${White}"
    if [[ "$IS_BOOT_PARTITION" -eq 1 ]]; then
        echo -e "BOOT_SIZE            = ${BWhite} $BOOT_SIZE ${White}"
    fi
    echo -e "IS_SWAP_PARTITION    = ${BWhite} $(yes_no $IS_SWAP_PARTITION) ${White}"
    if [[ "$IS_SWAP_PARTITION" -eq 1 ]]; then
        echo -e "SWAP_SIZE            = ${BWhite} $SWAP_SIZE ${White}"
    fi
    echo -e "ROOT_SIZE            = ${BWhite} $ROOT_SIZE ${White}"
    echo -e "ROOT_FORMAT          = ${BWhite} $ROOT_FORMAT ${White}"
    echo -e "IS_HOME_PARTITION    = ${BWhite} $(yes_no $IS_HOME_PARTITION) ${White}"
    if [[ "$IS_HOME_PARTITION" -eq 1 ]]; then
        echo -e "HOME_SIZE            = ${BWhite} $HOME_SIZE ${White}"
        echo -e "HOME_FORMAT          = ${BWhite} $HOME_FORMAT ${White}"
        echo -e "IS_HOME_DRIVE        = ${BWhite} $(yes_no $IS_HOME_DRIVE) ${White}"
    fi
    echo -e "IS_VAR_PARTITION     = ${BWhite} $(yes_no $IS_VAR_PARTITION) ${White}"
    if [[ "$IS_VAR_PARTITION" -eq 1 ]]; then
        echo -e "VAR_SIZE             = ${BWhite} $VAR_SIZE ${White}"
        echo -e "VAR_FORMAT           = ${BWhite} $VAR_FORMAT ${White}"
        echo -e "IS_VAR_DRIVE         = ${BWhite} $(yes_no $IS_VAR_DRIVE) ${White}"
    fi
    echo -e "IS_TMP_PARTITION     = ${BWhite} $(yes_no $IS_TMP_PARTITION) ${White}"
    if [[ "$IS_TMP_PARTITION" -eq 1 ]]; then
        echo -e "IS_TMP_SIZE          = ${BWhite} $(yes_no $IS_TMP_SIZE ) ${White}"
        echo -e "TMP_SIZE             = ${BWhite} $TMP_SIZE ${White}"
        echo -e "TMP_FORMAT           = ${BWhite} $TMP_FORMAT ${White}"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# SAVE INSTALL {{{
# USAGE      : save_install
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
save_install()
{
    # CORE_INSTALL
    total=${#CORE_INSTALL[@]}
    for (( i=0; i<${total}; i++ )); do
        if [[ "$i" == 0 ]]; then
            echo "${CORE_INSTALL[$i]}"        >  "$CONFIG_PATH/$SCRIPT_NAME-core-installed.db"      # installed_core  - array
        else
            echo "${CORE_INSTALL[$i]}"        >> "$CONFIG_PATH/$SCRIPT_NAME-core-installed.db"      # installed_core  - array
        fi
    done
    # AUR_INSTALL
    total=${#AUR_INSTALL[@]}
    for (( i=0; i<${total}; i++ )); do
        if [[ "$i" == 0 ]]; then
            echo "${AUR_INSTALL[$i]}"         >  "$CONFIG_PATH/$SCRIPT_NAME-aur-installed.db"       # installed_aur - array
        else
            echo "${AUR_INSTALL[$i]}"         >> "$CONFIG_PATH/$SCRIPT_NAME-aur-installed.db"       # installed_aur - array
        fi
    done
    # FAILED_CORE_INSTALL
    total=${#FAILED_CORE_INSTALL[@]}
    for (( i=0; i<${total}; i++ )); do
        if [[ "$i" == 0 ]]; then
            echo "${FAILED_CORE_INSTALL[$i]}" >  "$CONFIG_PATH/$SCRIPT_NAME-failed-core-install.db" # failed_install_core  - array
        else
            echo "${FAILED_CORE_INSTALL[$i]}" >> "$CONFIG_PATH/$SCRIPT_NAME-failed-core-install.db" # failed_install_core  - array
        fi
    done
    # FAILED_AUR_INSTALL
    total=${#FAILED_AUR_INSTALL[@]}
    for (( i=0; i<${total}; i++ )); do
        if [[ "$i" == 0 ]]; then
            echo "${FAILED_AUR_INSTALL[$i]}"  >  "$CONFIG_PATH/$SCRIPT_NAME-failed-aur-install.db"  # failed_install_aur - array
        else
            echo "${FAILED_AUR_INSTALL[$i]}"  >> "$CONFIG_PATH/$SCRIPT_NAME-failed-aur-install.db"  # failed_install_aur - array
        fi
    done
}
#}}}
# -----------------------------------------------------------------------------
# SAVE SOFTWARE {{{
# USAGE      : save_software
# DESCRIPTION: All variables that effect PACKMANAGER
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
save_software()
{
    # add_packagemanager PACKMANAGER PACKMANAGER_NAME
    # PACKMANAGER_NAME
    typeset -i total=${#PACKMANAGER_NAME[@]}
    for (( i=0; i<${total}; i++ )); do
        if [[ "$i" == 0 ]]; then
            echo "${PACKMANAGER_NAME[$i]}"  > "$CONFIG_PATH/$SCRIPT_NAME-packagemanager-name.db" # add_packagemanager  - array
        else
            echo "${PACKMANAGER_NAME[$i]}" >> "$CONFIG_PATH/$SCRIPT_NAME-packagemanager-name.db" # add_packagemanager  - array
        fi
    done
    # PACKMANAGER
    typeset -i total=${#PACKMANAGER[@]}
    for (( i=0; i<${total}; i++ )); do
        if [[ "$i" == 0 ]]; then
            echo "${PACKMANAGER[$i]}"       > "$CONFIG_PATH/$SCRIPT_NAME-packagemanager.db"      # add_packagemanager  - array
        else
            echo "${PACKMANAGER[$i]}"      >> "$CONFIG_PATH/$SCRIPT_NAME-packagemanager.db"      # add_packagemanager  - array
        fi
    done
    #    
    # USER_GROUPS
    total=${#USER_GROUPS[@]}
    for (( i=0; i<${total}; i++ )); do
        if [[ "$i" == 0 ]]; then
            echo "${USER_GROUPS[$i]}"      >  "$CONFIG_PATH/$SCRIPT_NAME-user-groups.db"         # add_user_group         - array
        else
            echo "${USER_GROUPS[$i]}"      >> "$CONFIG_PATH/$SCRIPT_NAME-user-groups.db"         # add_user_group         - array
        fi
    done
    # WEBSERVER
    echo "?WEBSERVER"      > "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    echo "$WEBSERVER"     >> "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    # CONFIG_ORPHAN
    echo "?CONFIG_ORPHAN" >> "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    echo "$CONFIG_ORPHAN" >> "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    # CONFIG_XORG
    echo "?CONFIG_XORG"   >> "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    echo "$CONFIG_XORG"   >> "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    # CONFIG_SSH
    echo "?CONFIG_SSH"    >> "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    echo "$CONFIG_SSH"    >> "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    # CONFIG_TOR
    echo "?CONFIG_TOR"    >> "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    echo "$CONFIG_TOR"    >> "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    # CONFIG_KDE
    echo "?CONFIG_KDE"    >> "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    echo "$CONFIG_KDE"    >> "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    # VIDEO_CARD
    echo "?VIDEO_CARD"    >> "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    echo "$VIDEO_CARD"    >> "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
    #
    save_last_config
}
#}}}
# -----------------------------------------------------------------------------
# SAVE LAST CONFIG {{{
# USAGE      : save_last_config
# DESCRIPTION: Save Last Config
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
save_last_config()
{
    if [ "${#LOCALE_ARRAY}" -eq 0 ]; then
        print_warning "Nothing has been configured yet! LOCALE_ARRAY=${LOCALE_ARRAY[*]} is empty on line $LINENO"
        exit 0
    fi
    # 
    # CONFIG_HOSTNAME
    echo "?CONFIG_HOSTNAME"      >  "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$CONFIG_HOSTNAME"      >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # USERNAME
    echo "?USERNAME"             >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$USERNAME"             >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # KEYBOARD
    echo "?KEYBOARD"             >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$KEYBOARD"             >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # NETWORK_MANAGER
    echo "?NETWORK_MANAGER"      >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$NETWORK_MANAGER"      >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # EDITOR
    echo "?EDITOR"               >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$EDITOR"               >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # KEYMAP
    echo "?KEYMAP"               >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$KEYMAP"               >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # COUNTRY_CODE
    echo "?COUNTRY_CODE"         >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$COUNTRY_CODE"         >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # FSTAB_CONFIG
    echo "?FSTAB_CONFIG"         >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$FSTAB_CONFIG"         >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # FSTAB_EDIT
    echo "?FSTAB_EDIT"           >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$FSTAB_EDIT"           >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # LOCALE
    echo "?LOCALE"               >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$LOCALE"               >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # AUR_HELPER
    echo "?AUR_HELPER"           >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$AUR_HELPER"           >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # AUR_PACKAGE_FOLDER
    echo "?AUR_PACKAGE_FOLDER"   >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$AUR_PACKAGE_FOLDER"   >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # RUN_AUR_ROOT
    echo "?RUN_AUR_ROOT"         >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$RUN_AUR_ROOT"         >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # IS_CUSTOM_NAMESERVER
    echo "?IS_CUSTOM_NAMESERVER" >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$IS_CUSTOM_NAMESERVER" >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # CUSTOM_MIRRORLIST
    echo "?CUSTOM_MIRRORLIST"    >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$CUSTOM_MIRRORLIST"    >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # FLESH
    echo "?FLESH"                >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$FLESH"                >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # ZONE
    echo "?ZONE"                 >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$ZONE"                 >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # SUBZONE
    echo "?SUBZONE"              >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    echo "$SUBZONE"              >> "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
    # LOCALE_ARRAY
    # ${#LOCALE_ARRAY[*]}
    total=${#LOCALE_ARRAY[@]}
    for (( i=0; i<${total}; i++ )); do
        if [[ "$i" == 0 ]]; then
            echo "${LOCALE_ARRAY[$i]}"         >  "$CONFIG_PATH/$SCRIPT_NAME-locale.db"       #   - array
        else
            echo "${LOCALE_ARRAY[$i]}"         >> "$CONFIG_PATH/$SCRIPT_NAME-locale.db"       #   - array
        fi
    done
    #
    IS_LAST_CONFIG_LOADED=1
}
#}}}
# -----------------------------------------------------------------------------
# SAVE DISK CONFIG {{{
# USAGE      : save_disk_config
# DESCRIPTION: Save Disk Configuration
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
save_disk_config()
{
    # 
    # UEFI
    echo "?UEFI" >  "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$UEFI" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # UEFI_SIZE
    echo "?UEFI_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$UEFI_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # IS_BOOT_PARTITION
    echo "?IS_BOOT_PARTITION" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$IS_BOOT_PARTITION" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # BOOT_SYSTEM_TYPE
    echo "?BOOT_SYSTEM_TYPE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$BOOT_SYSTEM_TYPE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # BOOT_SIZE
    echo "?BOOT_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$BOOT_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # IS_SWAP_PARTITION
    echo "?IS_SWAP_PARTITION" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$IS_SWAP_PARTITION" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # SWAP_SIZE
    echo "?SWAP_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$SWAP_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # ROOT_SIZE
    echo "?ROOT_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$ROOT_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # ROOT_FORMAT
    echo "?ROOT_FORMAT" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$ROOT_FORMAT" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # IS_HOME_PARTITION
    echo "?IS_HOME_PARTITION" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$IS_HOME_PARTITION" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # HOME_SIZE
    echo "?HOME_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$HOME_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # HOME_FORMAT
    echo "?HOME_FORMAT" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$HOME_FORMAT" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # IS_HOME_DRIVE
    echo "?IS_HOME_DRIVE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$IS_HOME_DRIVE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # IS_VAR_PARTITION
    echo "?IS_VAR_PARTITION" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$IS_VAR_PARTITION" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # VAR_SIZE
    echo "?VAR_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$VAR_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # VAR_FORMAT
    echo "?VAR_FORMAT" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$VAR_FORMAT" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # IS_VAR_DRIVE
    echo "?IS_VAR_DRIVE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$IS_VAR_DRIVE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # IS_TMP_PARTITION
    echo "?IS_TMP_PARTITION" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$IS_TMP_PARTITION" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # IS_TMP_SIZE
    echo "?IS_TMP_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$IS_TMP_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # TMP_SIZE
    echo "?TMP_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$TMP_SIZE" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # TMP_FORMAT
    echo "?TMP_FORMAT" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$TMP_FORMAT" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # EDIT_GDISK
    echo "?EDIT_GDISK" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$EDIT_GDISK" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    # IS_SSD
    echo "?IS_SSD" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
    echo "$IS_SSD" >> "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
}
#}}}
# -----------------------------------------------------------------------------

# IS SOFTWARE FILES {{{
# USAGE      : is_software_files
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
is_software_files()
{
    TEST_1=0
    TEST_2=0
    TEST_3=0
    TEST_4=0
    if [[ -f "$CONFIG_PATH/$SCRIPT_NAME-packagemanager-name.db" ]]; then
        TEST_1=1
    fi
    if [[ -f "$CONFIG_PATH/$SCRIPT_NAME-packagemanager.db" ]]; then
        TEST_2=1
    fi
    if [[ -f "$CONFIG_PATH/$SCRIPT_NAME-user-groups.db" ]]; then
        TEST_3=1
    fi
    if [[ -f "$CONFIG_PATH/$SCRIPT_NAME-software-config.db" ]]; then
        TEST_4=1
    fi
    if [[ "$TEST_1" -eq 1 && "$TEST_2" -eq 1 && "$TEST_3" -eq 1 && "$TEST_4" -eq 1 ]]; then
        IS_SOFTWARE_CONFIG_LOADED=1
    fi
    unset TEST_1
    unset TEST_2
    unset TEST_3
    unset TEST_4
}
#}}}
# -----------------------------------------------------------------------------
# LOAD SOFTWARE {{{
# USAGE      : load_software
# DESCRIPTION: Load Software Configuration files
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
load_software()
{
    # Test each file
    TEST_1=0
    TEST_2=0
    TEST_3=0
    TEST_4=0
    #
    # PACKMANAGER_NAME - add_packagemanager - array
    if [[ -f "$CONFIG_PATH/$SCRIPT_NAME-packagemanager-name.db" ]]; then
        i=0
        while read line; do 
            PACKMANAGER_NAME[$((i++))]="$line"
        done < "$CONFIG_PATH/$SCRIPT_NAME-packagemanager-name.db"
        TEST_1=1
    else
        echo "No $CONFIG_PATH/$SCRIPT_NAME-packagemanager-name.db"
        pause_function "$LINENO"
    fi
    # PACKMANAGER - add_packagemanager - array
    if [[ -f "$CONFIG_PATH/$SCRIPT_NAME-packagemanager.db" ]]; then
        i=0
        while read line; do 
            PACKMANAGER[$((i++))]="$line"
        done < "$CONFIG_PATH/$SCRIPT_NAME-packagemanager.db"
        TEST_2=1
    else
        echo "No $CONFIG_PATH/$SCRIPT_NAME-packagemanager.db"
        pause_function "$LINENO"
    fi
    #
    # users - add_user_group - array
    if [[ -f "$CONFIG_PATH/$SCRIPT_NAME-user-groups.db" ]]; then
        while read line; do 
            add_user_group "$line"
        done < "$CONFIG_PATH/$SCRIPT_NAME-user-groups.db"
        TEST_3=1
    else
        echo "No $CONFIG_PATH/$SCRIPT_NAME-user-groups.db"
        pause_function "$LINENO"
    fi
    # Store only if 1
    if [[ -f "$CONFIG_PATH/$SCRIPT_NAME-software-config.db" ]]; then
        while read line; do 
            if [[ "${line:0:1}" == "?" ]]; then
                THE_VAR="${line:1}"
            else
                case "$THE_VAR" in
                    "WEBSERVER")   
                        WEBSERVER="$line"    
                        ;;
                    "CONFIG_ORPHAN")
                        CONFIG_ORPHAN="$line"
                        ;;
                    "CONFIG_XORG")
                        CONFIG_XORG="$line"
                        ;;
                    "CONFIG_SSH")
                        CONFIG_SSH="$line"
                        ;;
                    "CONFIG_TOR")
                        CONFIG_TOR="$line"
                        ;;
                    "CONFIG_KDE")
                        CONFIG_KDE="$line"
                        ;;
                    "VIDEO_CARD")
                        VIDEO_CARD="$line"
                        ;;
               esac
            fi
        done < "$CONFIG_PATH/$SCRIPT_NAME-software-config.db"
        TEST_4=1
    else
        echo "No $CONFIG_PATH/$SCRIPT_NAME-software-config.db"
        pause_function "load_software $LINENO"
    fi
    if [[ "$TEST_1" -eq 1 && "$TEST_2" -eq 1 && "$TEST_3" -eq 1 && "$TEST_4" -eq 1 ]]; then
        IS_SOFTWARE_CONFIG_LOADED=1
    fi
    unset TEST_1
    unset TEST_2
    unset TEST_3
    unset TEST_4
}
#}}}
# -----------------------------------------------------------------------------
# LOAD LAST CONFIG {{{
# USAGE      : load_last_config
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
load_last_config()
{
    # CONFIG_HOSTNAME USERNAME RUN_AUR_ROOT KEYBOARD
    # 
    if [[ -f "$CONFIG_PATH/$SCRIPT_NAME-last-config.db" ]]; then
        while read line; do 
            if [[ "${line:0:1}" == "?" ]]; then
                THE_VAR="${line:1}"
            else
                case "$THE_VAR" in
                    "CONFIG_HOSTNAME")
                        CONFIG_HOSTNAME="$line"
                        ;;
                    "USERNAME")
                        USERNAME="$line"
                        ;;
                    "RUN_AUR_ROOT")
                        RUN_AUR_ROOT="$line"
                        ;;
                    "KEYBOARD")
                        KEYBOARD="$line"
                        ;;
                    "NETWORK_MANAGER")
                        NETWORK_MANAGER="$line"
                        ;;
                    "EDITOR")
                        EDITOR="$line"
                        ;;
                    "KEYMAP")
                        KEYMAP="$line"
                        ;;
                    "COUNTRY_CODE")
                        COUNTRY_CODE="$line"
                        ;;
                    "FSTAB_CONFIG")
                        FSTAB_CONFIG="$line"
                        ;;
                    "FSTAB_EDIT")
                        FSTAB_EDIT="$line"
                        ;;
                    "LOCALE")
                        LOCALE="$line"
                        ;;
                    "AUR_HELPER")
                        AUR_HELPER="$line"
                        ;;
                    "IS_CUSTOM_NAMESERVER")
                        IS_CUSTOM_NAMESERVER="$line"
                        ;;
                    "CUSTOM_MIRRORLIST")
                        CUSTOM_MIRRORLIST="$line"
                        ;;
                    "FLESH")
                        FLESH="$line"
                        ;;
                    "ZONE")
                        ZONE="$line"
                        ;;
                    "SUBZONE")
                        SUBZONE="$line"
                        ;;
                    "AUR_PACKAGE_FOLDER")
                        AUR_PACKAGE_FOLDER="$line"
                        ;;
               esac
            fi
        done < "$CONFIG_PATH/$SCRIPT_NAME-last-config.db"
        IS_LAST_CONFIG_LOADED=1
    else
        echo "No $CONFIG_PATH/$SCRIPT_NAME-last-config.db"
        pause_function "$LINENO"
    fi
    if [[ "$IS_CUSTOM_NAMESERVER" -eq 1 ]]; then
        read_nameserver
    fi
    # LOCALE_ARRAY
    declare -i i=0
    if [[ -f "$CONFIG_PATH/$SCRIPT_NAME-locale.db" ]]; then
        while read line; do 
            LOCALE_ARRAY[$((i++))]="$line"
        done < "$CONFIG_PATH/$SCRIPT_NAME-locale.db"
    else
        IS_LAST_CONFIG_LOADED=0
        echo "No $CONFIG_PATH/$SCRIPT_NAME-locale.db"
        pause_function "$LINENO"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# LOAD DISK CONFIG {{{
# USAGE      : load_disk_config
# DESCRIPTION: Load Disk Configuration
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
load_disk_config()
{
    if [[ -f "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db" ]]; then
        while read line; do 
            if [[ "${line:0:1}" == "?" ]]; then
                THE_VAR="${line:1}"
            else
                case "$THE_VAR" in
                    "UEFI")
                        UEFI="$line"
                        ;;
                    "UEFI_SIZE")
                        UEFI_SIZE="$line"
                        ;;
                    "IS_BOOT_PARTITION")
                        IS_BOOT_PARTITION="$line"
                        ;;
                    "BOOT_SYSTEM_TYPE")
                        BOOT_SYSTEM_TYPE="$line"
                        ;;
                    "BOOT_SIZE")
                        BOOT_SIZE="$line"
                        ;;
                    "IS_SWAP_PARTITION")
                        IS_SWAP_PARTITION="$line"
                        ;;
                    "SWAP_SIZE")
                        SWAP_SIZE="$line"
                        ;;
                    "ROOT_SIZE")
                        ROOT_SIZE="$line"
                        ;;
                    "ROOT_FORMAT")
                        ROOT_FORMAT="$line"
                        ;;
                    "IS_HOME_PARTITION")
                        IS_HOME_PARTITION="$line"
                        ;;
                    "HOME_SIZE")
                        HOME_SIZE="$line"
                        ;;
                    "HOME_FORMAT")
                        HOME_FORMAT="$line"
                        ;;
                    "IS_HOME_DRIVE")
                        IS_HOME_DRIVE="$line"
                        ;;
                    "IS_VAR_PARTITION")
                        IS_VAR_PARTITION="$line"
                        ;;
                    "VAR_SIZE")
                        VAR_SIZE="$line"
                        ;;
                    "VAR_FORMAT")
                        VAR_FORMAT="$line"
                        ;;
                    "IS_VAR_DRIVE")
                        IS_VAR_DRIVE="$line"
                        ;;
                    "IS_TMP_PARTITION")
                        IS_TMP_PARTITION="$line"
                        ;;
                    "IS_TMP_SIZE")
                        IS_TMP_SIZE="$line"
                        ;;
                    "TMP_SIZE")
                        TMP_SIZE="$line"
                        ;;
                    "TMP_FORMAT")
                        TMP_FORMAT="$line"
                        ;;
                    "EDIT_GDISK")
                        EDIT_GDISK="$line"
                        ;;
                    "IS_SSD")
                        IS_SSD="$line"
                        ;;
               esac
            fi
        done < "$CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
        IS_DISK_CONFIG_LOADED=1
    else
        echo "No $CONFIG_PATH/$SCRIPT_NAME-disk-config.db"
        pause_function "load_disk_config $LINENO"
    fi
}
#}}}
# *******************************************************************************************************************************
# *******************************************************************************************************************************
# *******************************************************************************************************************************
# DO CURL }}}
# @FIX finish function
# USAGE      : do_curl $1[/Full-PATH/File-Name.tar.gz] $2[http://url.org/path/filename.tar.gz] 
# DESCRIPTION: File-Name is the output file to save as... URL is full URL, PATH and File Name
# NOTES      : This will assume you have an tar archive file, download it, extract it, rm tar file, mv files to $3,
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
do_curl()
{
    # this allows any archive type, instead of hard coding tar.gz
    curl -o $1 $2
    if [ -f "$1" ]; then
        if tar zxvf "$1" ; then
            rm $1 # This will delete the tar Archive file only
            chown -R $USERNAME:$USERNAME /home/$USERNAME/  # beats having to parse the file name or pass another parameter
            return 0
        else
             echo -e "${BRed}\t File Currupted: curl -o $1 $2 ${White}"
             return 1
        fi
    else
        echo -e "${BRed}\t File Not Found: curl -o $1 $2 ${White}"
        return 1
    fi
}
#}}}
# -----------------------------------------------------------------------------

#CREATE NEW USER {{{
# USAGE      : create_new_user
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
create_new_user()
{
    read -p "Username: " USERNAME
    groupadd $USERNAME
    useradd -m -g $USERNAME -G $USERNAME,wheel,users -s /bin/bash $USERNAME
    chfn $USERNAME
    passwd $USERNAME
    pause_function
    configure_user_account
} 
#}}}
# -----------------------------------------------------------------------------
# USER CONFIG {{{
# This is run by User, Library is unavailable, unless you export all the functions to use it.
# 1 = $USERNAME 
#
# USAGE      : user_config "USERNAME"
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
user_config()
{
    # Must define here or export before coming in
    BRed='\e[1;31m'         # Red
    BWhite='\e[1;37m'       # White
    White='\e[0;37m'        # White
    # cd /home/$USERNAME or cd ~
    echo -e $"\t${BWhite} Configuring User: $1 ${White}"
    if [[ ! -f "/home/$1/.Xauthority" && ! -h "/home/$1/.Xauthority" ]]; then # if its not a file or a link
        echo ""
        ln -sv `dirname $(xauth info | awk '/Authority file/{print $3}')` /home/$1/.Xauthority
    fi
    if [[ ! -f "/home/$1/.Xauthority" && ! -h "/home/$1/.Xauthority" ]]; then # just in case failure;
        echo -e "${BRed} Failure in creating .Xauthority; try generate new one. ${White}"
        xauth generate :0 . trusted # I get no display on 0
    fi
    if [[ ! -f "/home/$1/.Xauthority" && ! -h "/home/$1/.Xauthority" ]]; then # just in case failure;
        echo -e "${BRed} Failure in creating .Xauthority; try add new one. ${White}"
        xauth add `echo "${DISPLAY}" | sed 's/.*\(:.*\)/\1/'` . `mcookie` # Bug in empty DISPLAY, fix in dbus-core-systemd-user-sessions
    fi
    if [[ ! -f "/home/$1/.Xauthority" && ! -h "/home/$1/.Xauthority" ]]; then # just in case failure; last resort
        echo -e "${BRed} Failure in creating .Xauthority, giving up and creating file. ${White}"
        touch /home/$1/.Xauthority
        echo -e $"\t${BWhite} User Configuration Completed with Errors.${White}"
        return 0
    fi
    #
    echo -e $"\t${BWhite} User Configuration Completed.${White}"
    return 1
}
#}}}
# -----------------------------------------------------------------------------
export -f user_config # need to export so if we are running as user it will find it
# CONFIGURE USER ACCOUNT {{{
# USAGE      : configure_user_account
# DESCRIPTION: This function gets called after software is installed, so configure what is needed here
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
configure_user_account()
{
    print_info "Configuring User Account $USERNAME..."
    print_info "BASHRC - https://wiki.archlinux.org/index.php/Bashrc"
    #
    make_dir "/home/$USERNAME/.config"  "$LINENO"   # Just checking
    chown $USERNAME:$USERNAME /home/$USERNAME/.config
    chmod 755 /home/$USERNAME/.config
    make_dir "/home/$USERNAME/.cache"   "$LINENO"   # Just checking
    chmod 755 /home/$USERNAME/.cache
    make_dir "/home/$USERNAME/.config/fontconfig" "$LINENO"
    #
    # @FIX helmuthdu replace with custom repo
    #
    if [[ "$EDITOR" == "vim" ]]; then
        package_install "vim ctags ack" "CONFIG-USER-VIM" 
        git clone https://github.com/helmuthdu/vim /home/$USERNAME/vim
        if [ ! -d "/home/$USERNAME/vim" ]; then
            print_warning "vim failed to Download at ($LINENO)"
            write_error "configure_user_account: vim failed to Download" "$LINENO"
        else
            mv vim /home/$USERNAME/.vim
            ln -sf /home/$USERNAME/.vim/vimrc /home/$USERNAME/.vimrc
        fi
        git clone https://github.com/helmuthdu/pentadactyl /home/$USERNAME/pentadactyl
        if [ ! -d "/home/$USERNAME/pentadactyl" ]; then
            print_warning "pentadactyl failed to Download at ($LINENO)"
            write_error "configure_user_account: pentadactyl failed to Download" "$LINENO"
        else
            # PENTADACTYL [FIREFOX]
            mv /home/$USERNAME/pentadactyl /home/$USERNAME/.pentadactyl
            ln -sf /home/$USERNAME/.pentadactyl/pentadactylrc /home/$USERNAME/.pentadactylrc
        fi
    elif [[ "$EDITOR" == "emacs" ]]; then
        package_install "emacs" "CONFIG-USER-EMACS"
    fi
    git clone https://github.com/helmuthdu/dotfiles /home/$USERNAME/dotfiles
    if [ ! -d "/home/$USERNAME/dotfiles" ]; then
        print_warning "git clone https://github.com/helmuthdu/dotfiles /home/$USERNAME -> dotfiles failed to Download at ($LINENO)"
        write_error "configure_user_account: dotfiles failed to Download" "$LINENO"
    else
        cp -f /home/$USERNAME/dotfiles/.bashrc /home/$USERNAME/dotfiles/.dircolors /home/$USERNAME/dotfiles/.dircolors_256 /home/$USERNAME/dotfiles/.nanorc ~/  # should be root
        cp -f /home/$USERNAME/dotfiles/.bashrc /home/$USERNAME/dotfiles/.dircolors /home/$USERNAME/dotfiles/.dircolors_256 /home/$USERNAME/dotfiles/.nanorc /home/$USERNAME/   # USERNAME
        cp -f /home/$USERNAME/dotfiles/fonts.conf /home/$USERNAME/.config/fontconfig
        rm -fr /home/$USERNAME/dotfiles
    fi
    print_this $"${BWhite} Configuring Dot Files...${White}"
    if [[ "$EDITOR" == "nano" ]]; then
        echo -e $"\tConfiguring Nano..."
        sed -i '/EDITOR/s/vim/nano/' /home/$USERNAME/.bashrc
        sed -i '/VISUAL/s/vim/nano/' /home/$USERNAME/.bashrc
        sed -i '/EDITOR/s/vim/nano/' ~/.bashrc
        sed -i '/VISUAL/s/vim/nano/' ~/.bashrc
    elif [[ "$EDITOR" == "vim" ]]; then
        echo -e $"\t${BWhite} Configuring Vim...${White}"
        # VIM
        # VIMRC
    elif [[ "$EDITOR" == "joe" ]]; then
        echo -e $"\t${BWhite}Configuring Joe...${White}"
        sed -i '/EDITOR/s/vim/joe/' /home/$USERNAME/.bashrc
        sed -i '/VISUAL/s/vim/joe/' /home/$USERNAME/.bashrc
        sed -i '/EDITOR/s/vim/joe/' ~/.bashrc
        sed -i '/VISUAL/s/vim/joe/' ~/.bashrc
    elif [[ "$EDITOR" == "emacs" ]]; then
        echo -e $"\t${BWhite}Configuring Emacs...${White}"
        sed -i '/EDITOR/s/vim/emacs\ -nw/' /home/$USERNAME/.bashrc
        sed -i '/VISUAL/s/vim/emacs\ -nw/' /home/$USERNAME/.bashrc
        sed -i '/EDITOR/s/vim/emacs\ -nw/' ~/.bashrc
        sed -i '/VISUAL/s/vim/emacs\ -nw/' ~/.bashrc
    fi
    #    
    make_dir "/home/$USERNAME/Downloads" "$LINENO"
    make_dir "/home/$USERNAME/Documents" "$LINENO"
    make_dir "/home/$USERNAME/Pictures"  "$LINENO"
    make_dir "/home/$USERNAME/Videos"    "$LINENO"
    make_dir "/home/$USERNAME/Music"     "$LINENO"
    #
    copy_file "/etc/skel/.bash_logout"  "/home/$USERNAME/.bash_logout"  "$LINENO"
    copy_file "/etc/skel/.bash_profile" "/home/$USERNAME/.bash_profile" "$LINENO"
    copy_file "/etc/skel/.bashrc"       "/home/$USERNAME/.bashrc"       "$LINENO"
    #copy_file "/etc/skel/.zshrc"        "/home/$USERNAME/.zshrc"      "$LINENO"
    #copy_file "/etc/skel/.xinitrc"      "/home/$USERNAME/.xinitrc"      "$LINENO"
    #copy_file "/etc/skel/.xsession"     "/home/$USERNAME/.xsession"     "$LINENO"
    # @FIX add all others
    if [[ "$MATE_INSTALLED" -eq 1 ]]; then
        touch /home/$USERNAME/.dmrc
        echo "[Desktop]" >> /home/$USERNAME/.dmrc
        echo "Session=mate" >> /home/$USERNAME/.dmrc
    elif [[ "$CINNAMON_INSTALLED" -eq 1 ]]; then
        touch /home/$USERNAME/.dmrc
        echo "[Desktop]" >> /home/$USERNAME/.dmrc
        echo "Session=cinnamon" >> /home/$USERNAME/.dmrc
    fi
    #
    chown -R $USERNAME:$USERNAME /home/$USERNAME
    #chmod -R 775 /home/$USERNAME/  # User=RWX, Group=RWX and Others=R
    #
    chmod 770 /home/$USERNAME/.bash_logout  # User=RWX, Group=RWX and Others=None
    chmod 770 /home/$USERNAME/.bash_profile # User=RWX, Group=RWX and Others=None
    chmod 770 /home/$USERNAME/.bashrc       # User=RWX, Group=RWX and Others=None
    #chmod 770 /home/$USERNAME/.xinitrc      # User=RWX, Group=RWX and Others=None
    #chmod 770 /home/$USERNAME/.xsession     # User=RWX, Group=RWX and Others=None
    #
#    pause_function "about to execute user_config $LINENO"
    return 0
    # skip this; left here to show how I trid to fix this; turns out to be a bug in systemd
    echo "export XAUTHORITY=/home/$USERNAME/.Xauthority" >> /etc/profile
    cd /home/$USERNAME/
    su $USERNAME -c "user_config \"${USERNAME}\"" # Must run as User
    if [ "$?" -eq 0 ]; then
        write_error "Failure in creating .Xauthority for user: $USERNAME function: user_config" "$LINENO"
        print_warning "Failure in creating .Xauthority for user: $USERNAME function: user_config"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "eval PACKMANAGER at line $LINENO"; fi
    fi
    cd /"$SCRIPT_DIR" # Is this required, if cd from within a su, it shouldn't leave the pwd there, it should revert back, as if it never happened.
    chmod 600 /home/$USERNAME/.Xauthority # User=RW, Group and Others=None
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.Xauthority
    #
} 
#}}}
# -----------------------------------------------------------------------------
# SELECT/CREATE USER {{{
# USAGE      : select_user
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
select_user()
{
        print_title "SELECT/CREATE USER ACCOUNT - https://wiki.archlinux.org/index.php/Users_and_Groups"
        users=(`cat /etc/passwd | grep "/home" | cut -d: -f1`);
        PS3="$prompt1"
        echo "Avaliable Users:"
        if [[ $(( ${#users[@]} )) -gt 0 ]]; then
            print_warning "WARNING: THE SELECTED USER MUST HAVE SUDO PRIVILEGES"
        else
            echo ""
        fi
        select OPT in "${users[@]}" "Create new user"; do
            if [[ $OPT == "Create new user" ]]; then
                create_new_user
                break
            elif contains_element "$OPT" "${users[@]}"; then
                USERNAME=$OPT
                break
            else
                invalid_option
            fi
        done
        [[ ! -f /home/$USERNAME/.bashrc ]] && configure_user_account;
}
#}}}
# -----------------------------------------------------------------------------
# ASSERT {{{
# USAGE      : assert
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
assert()                  #  If condition false,
{                         #+ exit from script with error message.
    E_PARAM_ERR=98
    E_ASSERT_FAILED=99
    #
    if [ -z "$3" ]; then      # Not enough parameters passed.
        return $E_PARAM_ERR   # No damage done.
    fi
    lineno=$3
    if [ ! $2 ]; then
        echo "Assertion failed:  \"$2\""
        echo "File \"$0\", line $lineno"
        exit $E_ASSERT_FAILED
    else
        if [[ "$DEBUGGING" -eq 1 ]]; then echo "assert (Passed in [$1] - checking [$2] at line number: [$3])"; fi
        return 1 #  and continue executing script.
    fi  
} 
#}}}
# -----------------------------------------------------------------------------
# GET AUR PACKAGE FOLDER {{{
# USAGE      : get_aur_package_folder
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_aur_package_folder()
{
    print_title "https://aur.archlinux.org/ and https://wiki.archlinux.org/index.php/AUR_User_Guidelines"
    read_input_default "Enter Path for AUR Packages [/home/$USERNAME/aur-packages/] " "/home/$USERNAME/aur-packages/"
    AUR_PACKAGE_FOLDER="$OPTION"
    #
    if make_dir "$AUR_PACKAGE_FOLDER" "$LINENO" ; then
        print_warning $"Counld not create folder $AUR_PACKAGE_FOLDER"
        pause_function "$LINENO"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# GET NETWORK DEVICE {{{
# USAGE      : get_network_devices
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_network_devices()
{
    i=0
    if [[ -n "$check_eth0"  ]]; then
        ETH0_ACTIVE=1
        NIC[$((i++))]="eth0"
        echo "device eth0 active $check_eth0"
    fi
    if [[ -n "$check_eth1"  ]]; then
        ETH1_ACTIVE=1
        NIC[$((i++))]="eth1"
        echo "device eth1 active $check_eth1"
    fi
    if [[ -n "$check_eth2" ]]; then
        ETH2_ACTIVE=1
        NIC[$((i++))]="eth2"
        echo "device eth2 active $check_eth2"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# SHOW USERS {{{
# USAGE      : show_users
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
show_users()
{
    echo $(gawk -F: '{ print $1 }' /etc/passwd)
}
#}}}
# -----------------------------------------------------------------------------
# FIX NETWORK {{{
# USAGE      : fix_network
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
fix_network()
{
    if [[ "$NETWORK_MANAGER" == "networkmanager" ]]; then
        # networkmanager
        # Internet is down; no use trying to install software
        #if ! check_package networkmanager ; then
        #    if [[ $KDE_INSTALLED -eq 1 ]]; then
        #        package_install "networkmanager kdeplasma-applets-networkmanagement" "INSTALL-NETWORKMANAGER-KDE"
        #        if [[ $MATE_INSTALLED -eq 1 ]]; then
        #            package_install "network-manager-applet" "INSTALL-NETWORKMANAGER-MATE"
        #        fi
        #    else
        #        package_install "networkmanager network-manager-applet" "INSTALL-NETWORKMANAGER-OTHER"
        #    fi
        #    package_install "networkmanager-dispatcher-ntpd" "INSTALL-NETWORKMANAGER"
        #fi
        #add_group "networkmanager"
        #add_user_2_group "networkmanager" 
        systemctl enable NetworkManager.service
        systemctl start NetworkManager.service
    elif [[ "$NETWORK_MANAGER" == "wicd" ]]; then
        #if ! check_package networkmanager ; then
        #    if [[ $KDE -eq 1 ]]; then
        #        aur_package_install "wicd wicd-kde" "AUR-INSTALL-NETWORKMANAGER-KDE"
        #    else
        #        package_install "wicd wicd-gtk" "INSTALL-NETWORKMANAGER-GTK"
        #    fi
        #fi                    
        systemctl enable wicd.service
        systemctl start wicd.service
        wicd-client
    fi
    # @FIX More testing and repairing
    sleep 20
    if ! is_internet ; then
        echo "Tried to fix network connection; you may have to run this script again."
        sleep 10
    fi
}
#}}}
# -----------------------------------------------------------------------------
# NETWORK TROUBLESHOOTING {{{
# USAGE      : network_troubleshooting
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
network_troubleshooting()
{
    get_network_devices
    get_install_mode
    load_software
    while [[ 1 ]]; do
        print_title "https://wiki.archlinux.org/index.php/Network_Debugging"
        print_info $"Network Debugging"
        print_info $"Networkmanager: install and start, this is always the best way to start troubleshooting."
        print_info $"Disk Resolv: Edit/Review namerservers.txt on disk, then copy it to local disk."
        print_info $"Local Resolv:Edit/Review local /etc/resolv.conf"
        print_info $"Identify which network interfaces"
        print_info $"Link status: "
        print_info $"IP Address: "
        print_info $"Ping: "
        print_info $"Devices: Show all ethx that are active"
        print_info $"Show Users: "
        print_info $"Static IP: "
        print_info $"Gateway: "
        print_info $""
        print_info $""
        print_info $"Quit"
        #                   1              2              3             4          5         6         7          8         9         10           11        12
        NETWORK_TROUBLE=("Networkmanager" "Disk Resolv" "Local Resolv" "Identify" "Link" "IP address" "Ping"  "Devices" "Show Users" "Static IP" "Gateway" "Quit");
        PS3="$prompt1"
        echo -e "Select an Option:\n"
        select OPT in "${NETWORK_TROUBLE[@]}"; do
            case "$REPLY" in
                1)
                    fix_network
                    pause_function "$LINENO"
                    break
                    ;;
                2)
                    # Disk Resolv
                    custom_nameservers   
                    cat /etc/resolv.conf      
                    pause_function "$LINENO"
                    break
                    ;;
                3)
                    # Local Resolv
                    $EDITOR /etc/resolv.conf     
                    break
                    ;;
                4)
                    # Indentify
                    print_info $"Indentify: ip a "
                    ip a
                    pause_function "$LINENO"
                    break
                    ;;
                5)
                    # Link
                    print_info $"Link status: ip link show dev eth0"
                    if [[ "$ETH0_ACTIVE" -eq 1 ]]; then
                        ip link show dev eth0
                    fi
                    if [[ "$ETH1_ACTIVE" -eq 1 ]]; then
                        ip link show dev eth1
                    fi
                    if [[ "$ETH2_ACTIVE" -eq 1 ]]; then
                        ip link show dev eth2
                    fi
                    pause_function "$LINENO"
                    break
                    ;;
                6)
                    # IP address
                    print_info $"Link status: ip addr show dev eth0"
                    if [[ "$ETH0_ACTIVE" -eq 1 ]]; then
                        ip addr show dev eth0
                    fi
                    if [[ "$ETH1_ACTIVE" -eq 1 ]]; then
                        ip addr show dev eth1
                    fi
                    if [[ "$ETH2_ACTIVE" -eq 1 ]]; then
                        ip addr show dev eth2
                    fi
                    pause_function "$LINENO"
                    break
                    ;;
                7)
                    # Ping
                    ping -c 3 www.google.com
                    pause_function "$LINENO"
                    break
                    ;;
                8)
                    # Devices
                    get_network_devices
                    pause_function "$LINENO"
                    break
                    ;;
                9)
                    # Show Users
                    show_users
                    pause_function "$LINENO"
                    break
                    ;;
               10)
                    print_title "https://wiki.archlinux.org/index.php/Network_Debugging"
                    print_info $"Network Debugging"
                    # Add Static IP address
                    PS3="$prompt1"
                    echo -e "Select a NIC:\n"
                    select OPT in "${NIC[@]}"; do
                        case "$REPLY" in
                            1)
                                NIC_DEV="eth0"
                                break
                                ;;
                            2)
                                NIC_DEV="eth1"
                                break
                                ;;
                            3)
                                NIC_DEV="eth2"
                                break
                                ;;
                            *)
                                invalid_option "$REPLY"
                                ;;
                        esac
                    done
                    read_input_data "Enter IP address [192.168.1.2] "
                    IP_ADDRESS="$OPTION"
                    read_input_data "Enter IP Mask [255.255.255.0 = 24] "
                    IP_MASK="$OPTION"
                    ip addr add "${IP_ADDRESS}/${IP_MASK}" dev "$NIC_DEV"
                    pause_function "$LINENO"
                    break
                    ;;
                    
               11)
                    # Add Static Gateway
                    read_input_data "Enter IP address for Gateway [192.168.1.1] "
                    IP_ADDRESS="$OPTION"
                    ip route add default via "$IP_ADDRESS"
                    pause_function "$LINENO"
                    break
                    ;;
               12)
                    # Quit
                    exit 1
                    ;;
              'q')
                    break
                    ;;
                *)
                    invalid_option "$REPLY"
                    ;;
            esac
       done
       is_breakable "$REPLY" "q"
   done            
}
# *******************************************************************************************************************************
#CONFIGURE KEYMAP {{{
# USAGE      : configure_keymap
# DESCRIPTION: Allows user to decide if they wish to change the Default Keymap
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
configure_keymap()
{
    setkeymap()
    {
        local keymaps=(`ls /usr/share/kbd/keymaps/i386/qwerty | sed 's/.map.gz//g'`)
        PS3="(shift+pgup/pgdown) $prompt1"
        echo "Select keymap:"
        select KEYMAP in "${keymaps[@]}" "more"; do
            if contains_element "$KEYMAP" ${keymaps[@]}; then
                loadkeys $KEYMAP
                break
            elif [[ $KEYMAP == more ]]; then
                read -p "Type your Keyboard Layout [ex: us-acentos]: " KEYMAP
                loadkeys $KEYMAP
                break
            else
                invalid_option "$KEYMAP"
            fi
        done
    }
    print_title "KEYMAP - https://wiki.archlinux.org/index.php/KEYMAP"
    print_this $"The KEYMAP variable is specified in the /etc/rc.conf file. It defines what keymap the keyboard is in the virtual consoles. Keytable files are provided by the kbd package."
    print_line
    print_this $"Belgian                = be-latin1    | Brazilian Portuguese = br-abnt2     | Canadian-French = cf"
    print_line
    print_this $"Canadian Multilingual  = ca_multi     | Colemak (US)         = colemak      | Croatian        = croat"
    print_line
    print_this $"Czech                  = cz-lat2      | Dvorak               = dvorak       | French          = fr-latin1"
    print_line
    print_this $"German                 = de-latin1 or de-latin1-nodeadkeys                  | Italian         = it"
    print_line
    print_this $"Lithuanian             = lt.baltic    | Norwegian            = no-latin1    | Polish          = pl"
    print_line
    print_this $"Portuguese             = pt-latin9    | Romanian             = ro_win       | Russian         = ru4"
    print_line
    print_this $"Singapore              = sg-latin1    | Slovene              = slovene      | Swedish         = sv-latin1"
    print_line
    print_this $"Swiss-French           = fr_CH-latin1 | Swiss-German         = de_CH-latin1 | Spanish         = es"
    print_line
    print_this $"Spanish Latinoamerican = la-latin1    | Turkish              = tr_q-latin5  | Ukrainian       = ua"
    print_line
    print_this $"United States          = us or us-acentos                                   | United Kingdom  = uk"
    print_line
    #print_this $"find /usr/share/kbd/keymaps/"
    print_this $"If Default is [$KEYMAP] then no changes needed."
    read_input_default "Keymap" "$KEYMAP"
    read_input_yn "Load Keymap" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        while [[ $YN_OPTION -ne 1 ]]; do
            setkeymap
            read_input_yn "Confirm keymap: $KEYMAP" 1
        done
    else
        KEYMAP="us"
    fi
}
#}}}
# -----------------------------------------------------------------------------
#DEFAULT EDITOR {{{
# USAGE      : get_editor
# DESCRIPTION: This gets called from Boot mode and Live mode; it does not add software, only ask if you wish to change the default editor, called from the create_config function.
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_editor()
{
    print_title "DEFAULT EDITOR"
    if [[ -f /usr/bin/vim ]]; then
        print_info $"emacs has to be installed."
    else
        print_info $"emacs and vim have to be installed."
    fi
    print_this "Editors: ${EDITORS[*]}"
    read_input_yn "Default Editor is $EDITOR, do wish to change this" 0
    if [[ "$YN_OPTION" -eq 1 ]]; then
        PS3="$prompt1"
        echo -e "Select default editor:"
        select OPT in "${EDITORS[@]}"; do
            case "$REPLY" in
                1)
                    EDITOR=nano
                    break
                    ;;
                2)
                    EDITOR=emacs
                    break
                    ;;
                3)
                    EDITOR=vi
                    break
                    ;;
                4)
                    EDITOR=vim
                    break
                    ;;
                5)
                    EDITOR=joe
                    break
                    ;;
                *)
                    invalid_option "$OPT"
                    ;;
            esac
        done
    fi
}
#}}}
# -----------------------------------------------------------------------------
#DEFAULT EDITOR {{{
# USAGE      : select_editor
# DESCRIPTION: This gets called from Boot mode only; it installs on the Boot OS, and schedules an install on the Live OS.
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
select_editor()
{
    get_editor
    if [[ "$EDITOR" == "emacs" ]]; then
        add_packagemanager "package_install 'emacs' 'INSTALL-EMACS'" "INSTALL-EMACS" 
        package_install "emacs" "INSTALL-EMACS"
    elif [[ "$EDITOR" == "vim" ]]; then
        if [[ ! -f /usr/bin/vim ]]; then
            add_packagemanager "package_install 'vim' 'INSTALL-VIM'" "INSTALL-VIM" 
            package_install "vim" "INSTALL-VIM" 
        fi
    elif [[ "$EDITOR" == "joe" ]]; then
        add_packagemanager "aur_package_install 'joe' 'AUR-INSTALL-JOE'" "AUR-INSTALL-JOE"
        aur_package_install "joe" "AUR-INSTALL-JOE"
    fi
}
#}}}
# -----------------------------------------------------------------------------
#INSTALL BASE SYSTEM {{{
# USAGE      : install_base_system
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_base_system()
{
    print_title 'INSTALL BASE SYSTEM - https://wiki.archlinux.org/index.php/Beginners%27_Guide#Install_the_base_system'
    print_info $"Using the pacstrap script we install the base system. The base-devel package group will be installed also."
    if [[ $BOOT_SYSTEM_TYPE -eq 1 ]]; then # Grub2
        if [[ $UEFI -eq 1 ]]; then
           if [[ "$ARCHI" != "x86_64" ]]; then
              extras="os-prober grub-efi-i386 efibootmgr"
           else
              extras="os-prober grub2-efi-x86_64 efibootmgr"
           fi
        elif [[ $UEFI -eq 2 ]]; then
            extras="os-prober grub grub-bios"
        fi
    else
        extras="os-prober syslinux"
    fi
    #
    # @FIX Install Languages for each Locale
    #total=${#LOCALE_ARRAY1[@]}
    #for (( index=0; index<${total}; index++ )); do
    #    LOCALE_ARRAY1[$index];
    #done
    # Once pacstrap has run, arch-chroot can run
    # yajl namcap git jshon expac used for AUR installs
    if [[ "$AUR_HELPER" == 'yaourt' ]]; then
        extras="$extras yajl namcap"
    elif [[ "$AUR_HELPER" == 'packer' ]]; then
        extras="$extras git jshon"
    elif [[ "$AUR_HELPER" == 'pacaur' ]]; then
        extras="$extras yajl expac"
    fi
    pacstrap $MOUNTPOINT base base-devel sudo wget dbus git systemd haveged btrfs-progs xorg-xauth pkgfile aria2 $NETWORK_MANAGER $extras
    # ADD KEYMAP TO THE NEW SETUP
    # $KM_FONT="lat9w-16"
    # $KM_FONT_MAP="8859-1_to_uni"
    # Note: As of systemd version 194, it uses the kernel font and keymap by default. 
    #       It is no longer necessary to leave KEYMAP= and FONT= empty.
    # Now files can be copied to MOUNTPOINT
    echo "KEYMAP=$KEYMAP" > $MOUNTPOINT/etc/vconsole.conf
    echo "FONT=\"\"" >> $MOUNTPOINT/etc/vconsole.conf
    echo "FONT_MAP=\"\"" >> $MOUNTPOINT/etc/vconsole.conf
    copy_file $MOUNTPOINT"/etc/vconsole.conf" "$SCRIPT_DIR/etc/vconsole.conf" "$LINENO"
    echo "pacstrap completed..."
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# GET FSTAB CONFIG  {{{
# USAGE      : get_fstab_config
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_fstab_config()
{
    print_title "FSTAB - https://wiki.archlinux.org/index.php/Fstab"
    print_info $"The /etc/fstab file contains static filesystem information. It defines how storage devices and partitions are to be mounted and integrated into the overall system. It is read by the mount command to determine which options to use when mounting a specific device or partition."
    print_info $"UUID is the perfered way to create fstab."
    PS3="$prompt1"
    echo -e "Configure fstab based on:"
    select OPT in "${FSTAB[@]}"; do
        case "$REPLY" in
            1)
                FSTAB_CONFIG=1
                break
                ;;
            2)
                FSTAB_CONFIG=2
                break
                ;;
            3)
                FSTAB_CONFIG=3
                break
                ;;
            *)
                invalid_option "$REPLY"
                ;;
        esac
    done
    read_input_yn "Edit fstab file" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        FSTAB_EDIT=1
    fi
}
#}}}
# -----------------------------------------------------------------------------
# CONFIGURE FSTAB {{{
# USAGE      : configure_fstab
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
configure_fstab()
{
    if [[ ! -f $MOUNTPOINT/etc/fstab.aui ]]; then
        if [[ -f $MOUNTPOINT/etc/fstab ]]; then
            copy_file $MOUNTPOINT"/etc/fstab" $MOUNTPOINT"/etc/fstab.aui" "$LINENO"
        fi
    fi
    if [[ "$FSTAB_CONFIG" -eq 1 ]]; then
        genfstab -U $MOUNTPOINT > $MOUNTPOINT/etc/fstab
    elif [[ "$FSTAB_CONFIG" -eq 2 ]]; then
        genfstab -p $MOUNTPOINT > $MOUNTPOINT/etc/fstab
    elif [[ "$FSTAB_CONFIG" -eq 3 ]]; then
        genfstab -L $MOUNTPOINT > $MOUNTPOINT/etc/fstab
    fi
    if [[ $IS_HOME_DRIVE -eq 1 ]]; then
        # @FIX get more info so you can add it here; popup list of drives maybe
        echo "#UUID=(Your UUID)       /home  (FS type)    rw,errors=remount-ro,nofail    0       1" >> $MOUNTPOINT/etc/fstab
    fi
    if [[ $IS_VAR_DRIVE -eq 1 ]]; then
        # @FIX get more info so you can add it here
        echo "#UUID=(Your UUID)       /var   (FS type)    rw,errors=remount-ro,nofail    0       1" >> $MOUNTPOINT/etc/fstab
    fi
    echo "# You might want to add this to home to have it automount by systemd, delay for fsck: noauto,x-systemd.automount" >> $MOUNTPOINT/etc/fstab
    if [[ "$FSTAB_EDIT" -eq 1 ]]; then
        print_title "FSTAB - https://wiki.archlinux.org/index.php/Fstab"
        print_info $"The /etc/fstab file contains static filesystem information. It defines how storage devices and partitions are to be mounted and integrated into the overall system. It is read by the mount command to determine which options to use when mounting a specific device or partition."
        #
        echo "Review your fstab."
        pause_function "$LINENO"
        $EDITOR $MOUNTPOINT/etc/fstab
    fi
    # pacstrap will overwrite fstab so copy it to temp 
    copy_file $MOUNTPOINT"/etc/fstab" "$SCRIPT_DIR/etc/fstab" "$LINENO"
    echo "fstab configure..."
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# CONFIGURE HOSTNAME {{{
# USAGE      : configure_hostname
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
configure_hostname()
{
    echo "$CONFIG_HOSTNAME" > $MOUNTPOINT/etc/hostname
    #
    echo "#" > $MOUNTPOINT/etc/hosts
    echo "# /etc/hosts: static lookup table for host names" >> $MOUNTPOINT/etc/hosts
    echo "#" >> $MOUNTPOINT/etc/hosts
    echo "#<ip-address>	<hostname.domain.org>	<hostname>" >> $MOUNTPOINT/etc/hosts
    echo "127.0.0.1	    localhost.localdomain	localhost $CONFIG_HOSTNAME" >> $MOUNTPOINT/etc/hosts
    echo "::1		    localhost.localdomain	localhost $CONFIG_HOSTNAME" >> $MOUNTPOINT/etc/hosts
    echo "#192.168.1.100 $CONFIG_HOSTNAME.domain.com $CONFIG_HOSTNAME   # Uncomment if you use a static IP and remove this comment." >> $MOUNTPOINT/etc/hosts
    echo "# End of file" >> $MOUNTPOINT/etc/hosts
    # 
    # pacstrap will overwrite hosts so copy it to temp 
    copy_file $MOUNTPOINT"/etc/hostname" "$SCRIPT_DIR/etc/hostname" "$LINENO"
    copy_file $MOUNTPOINT"/etc/hosts"    "$SCRIPT_DIR/etc/hosts" "$LINENO"
    echo "Configured Hostname..."
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# GET HOSTNAME {{{
# USAGE      : get_hostname
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_hostname()
{
    print_title "HOSTNAME - https://wiki.archlinux.org/index.php/HOSTNAME"
    print_this $"A host name is a unique name created to identify a machine on a network.Host names are restricted to alphanumeric characters."
    print_this $"The hyphen (-) can be used, but a host name cannot start or end with it. Length is restricted to 63 characters."
    print_this $"Do not add any comments or empty lines."
    print_this $"Do not use a domain name."
    read_input_default "Hostname [ex: archlinux]" "$CONFIG_HOSTNAME"
    CONFIG_HOSTNAME="$OPTION"
}
# REMOVE FILE }}}
# USAGE      : remove_file
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
remove_file()
{
    if [[ "$MOUNTPOINT" == " " ]]; then
        [[ -f "$1" ]] && rm "$1";
    else
        [[ -f "${MOUNTPOINT}/$1" ]] && rm "${MOUNTPOINT}/$1";
    fi
}
#CONFIGURE TIMEZONE {{{
# USAGE      : configure_timezone
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
configure_timezone()
{
    settimezone()
    {
        remove_file "/etc/localtime" "$LINENO"
        local zone=("Africa" "America" "Antarctica" "Arctic" "Asia" "Atlantic" "Australia" "Brazil" "Canada" "Chile" "Europe" "Indian" "Mexico" "Midest" "Pacific" "US");
        PS3="$prompt1"
        echo "Select zone:"
        select ZONE in "${zone[@]}"; do
            if contains_element "$ZONE" ${zone[@]}; then
                local subzone=(`ls /usr/share/zoneinfo/$ZONE/`)
                PS3="$prompt1"
                echo "Select subzone:"
                select SUBZONE in "${subzone[@]}"; do
                if contains_element "$SUBZONE" ${subzone[@]}; then
                    add_packagemanager "ln -s /usr/share/zoneinfo/$ZONE/$SUBZONE /etc/localtime" "RUN-TIMEZONE"
                    break
                else
                    invalid_option "$SUBZONE"
                fi
                done
                break
            else
                invalid_option "$ZONE"
            fi
        done
    }
    print_title "TIMEZONE - https://wiki.archlinux.org/index.php/Timezone"
    print_info $"In an operating system the time (clock) is determined by four parts: Time value, Time standard, Time Zone, and DST (Daylight Saving Time if applicable)."
    read_input_yn "Default Timezone is $ZONE/$SUBZONE, is this correct" 1
    while [[ $YN_OPTION -ne 1 ]]; do
        settimezone
        read_input_yn "Confirm timezone ($ZONE/$SUBZONE)" 1
    done
    if [[ "$MOUNTPOINT" != " " ]]; then
        if [[ "$DRIVE_FORMATED" -eq 1 ]]; then
            touch $MOUNTPOINT/etc/timezone
            echo "$ZONE/$SUBZONE" > $MOUNTPOINT/etc/timezone
            copy_file $MOUNTPOINT"/etc/timezone" "$SCRIPT_DIR/etc/timezone" "$LINENO"
        else
            echo "$ZONE/$SUBZONE" > "$SCRIPT_DIR/etc/timezone" 
        fi
    else
        echo "$ZONE/$SUBZONE" > /etc/timezone
        copy_file "/etc/timezone" "$SCRIPT_DIR/etc/timezone" "$LINENO"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# FINISH {{{
# USAGE      : finish
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
finish()
{
    print_title 'https://wiki.archlinux.org/index.php/Beginners%27_Guide#Boot_Arch_Linux_Installation_Media'
    print_info $"INSTALL COMPLETED"
    print_info $"If all went right you should be able to reboot into a fully functioning Desktop."
    print_info $"Make sure to check the root for install files like install_scripts, $SCRIPT_LOG, install_scripts_root_secrets, install_scripts_user_secrets, you can also delete /boot/grub_uefi.log."
    # COPY SCRIPT TO ROOT FOLDER IN THE NEW SYSTEM
    if [[ "$1" -eq 1 ]]; then
        print_info $"I made a back copy of the profile in /root; you can delete these files."
        print_warning "\n\tDrive is now ready to install Software, reboot, and remount Flash Drive with Script, cd /Path2Profile, run ./$SCRIPT_NAME -l to load saved profile, or -i to create a new one."
        copy_dir "$SCRIPT_DIR/etc"          $MOUNTPOINT"/root/" "$LINENO"
    else
        print_info $"You should now have a full system install, just reboot and you are ready to go."
    fi
    # @FIX, where to save it to
    copy_file "$SCRIPT_DIR/${SCRIPT_NAME}"${SCRIPT_EXT}  $MOUNTPOINT"/root/" "$LINENO"
    copy_files "$CONFIG_PATH/" "db"                      $MOUNTPOINT"/root/CONFIG/" "$LINENO"
    copy_files "$LOG_PATH/"    "log"                     $MOUNTPOINT"/root/LOG/" "$LINENO"
    save_install
    if [[ "$MOUNTPOINT" == " " ]]; then
        chown -R $USERNAME:$USERNAME "$CONFIG_PATH/"
        chown -R $USERNAME:$USERNAME "$LOG_PATH/"
        chown -R $USERNAME:$USERNAME "$SCRIPT_DIR/etc/"
        chown -R $USERNAME:$USERNAME "$MENU_PATH/"
    else
        touch $MOUNTPOINT/finish_script
        chmod a+x $MOUNTPOINT/finish_script
        echo "#!/bin/bash" > $MOUNTPOINT/finish_script
        echo "# install_scripts $SCRIPT_NAME Version: $SCRIPT_VERSION on $DATE_TIME This script will run from arch-chroot." >> $MOUNTPOINT/finish_script
        echo "chown -R $USERNAME:$USERNAME $CONFIG_PATH/" >> $MOUNTPOINT/finish_script
        echo "chown -R $USERNAME:$USERNAME $LOG_PATH/" >> $MOUNTPOINT/finish_script
        echo "chown -R $USERNAME:$USERNAME $SCRIPT_DIR/etc/" >> $MOUNTPOINT/finish_script
        echo "chown -R $USERNAME:$USERNAME $MENU_PATH/" >> $MOUNTPOINT/finish_script
        echo "# End Of File." >> $MOUNTPOINT/finish_script
        if [[ "$DEBUGGING" -eq 1 ]]; then
            echo "pause_function \"finish_script has executed and permissions changed at line \$LINENO\"" >> $MOUNTPOINT/finish_script
        fi
        arch-chroot $MOUNTPOINT /finish_script
    fi
    #
    read_input_yn "Reboot system" 1
    if [[ $YN_OPTION -eq 1 ]]; then
        reboot
    fi
    exit 0
}
#}}}
# *******************************************************************************************************************************
# IS UEFI MODE {{{
# USAGE      : is_uefi_mode
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
is_uefi_mode()
{
    if [[ "$(cat /sys/class/dmi/id/sys_vendor)" == 'Apple Inc.' ]] || [[ "$(cat /sys/class/dmi/id/sys_vendor)" == 'Apple Computer, Inc.' ]]; then 
        modprobe -r -q efivars || true  # if MAC
    else
        modprobe -q efivars             # all others    
    fi
    if [[ -d "/sys/firmware/efi/vars/" ]]; then
        UEFI=1
        print_info $"UEFI Mode Test Passed."
    else
        UEFI=2
        print_warning "UEFI Mode Test Failed! UEFI Installation will not work correctly, switching to BIOS mode."
        modprobe dm-mod
   fi
}
#}}}
# ************************************************************* Install Software ******
# GET INSTALL SOFTWARE {{{
# USAGE      : get_install_software [1=Boot Mode, 2=Live Mode] 
# DESCRIPTION:
# NOTES      : 
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_install_software()
{
    if [[ "$1" -eq 1 ]]; then        
        print_title "Installation Types:"
        print_info $"Full Install: Boot and Create Software List at the same time, this list can then be installed after boot up with argument -l."
        print_info $"Boot Only: Make disk bootable. The Software list can be imported using the -l or via the Software Menu 'Load Software'."
        print_info $"Software Configuration: Create Software List and Save configuration files for later use with -l option. This is useful to create a list of Software to install, the list can the be loaded at a later time, so this option can be ran during the Boot mode processes, and after the Boot Mode to install the Software Selected here."
        INSTALL_SYSTEM_TYPES=("Full Install" "Boot Only" "Software Configuration");
        PS3="$prompt1"
        echo -e "Select an Option:\n"
        select OPT in "${INSTALL_SYSTEM_TYPES[@]}"; do
            case "$REPLY" in
                1)
                    INSTALL_TYPE=1 # Full Install: Boot and Create Software List at the same time.
                    break
                    ;;
                2)
                    INSTALL_TYPE=2 # Boot Only: Make disk bootable.
                    break
                    ;;
                3)
                    INSTALL_TYPE=3 # Software Configuration.
                    break
                    ;;
                *)
                    invalid_option "$REPLY"
                    ;;
            esac
        done
        unset INSTALL_SYSTEM_TYPES
    else
        INSTALL_TYPE=3 # Software Configuration.
    fi
    if [[ "$INSTALL_TYPE" -eq 1 || "$INSTALL_TYPE" -eq 3 ]]; then
        # Main Software Install Screen
        if [[ -f "$CONFIG_PATH/$SCRIPT_NAME-last-config.db" ]]; then        
            print_title "Desktop Environment - https://wiki.archlinux.org/index.php/Desktop_Environment"
            print_info $"Installing Software from menu will add applications to allow you to install a Desktop Enviroment, like Mate, KDE, or Others, then save them to Disk to be loaded next time., this only creates a List of software and configuration options that are saved to disk for later use with -l option, or allow you to install at menu."
            print_info $"Pick no to load software from disk."
            read_input_yn "Install Desktop Environment and Software from Menu?" 1
            if [[ $YN_OPTION -eq 1 ]]; then
                IS_INSTALL_SOFTWARE=1
                install_menu
                add_packagemanager "package_install 'mesa mesa-demos sudo gksu xorg-fonts-{100,75}dpi ttf-freefont ttf-dejavu' 'INSTALL-DESKTOP'" "INSTALL-DESKTOP"
            else
                if [[ "$MOUNTPOINT" == " " ]]; then
                    install_loaded_software
                else
                    write_secret 'user_user'
                    write_secret 'root_user'
                    create_install_scripts 2
                fi
            fi
        else
            IS_INSTALL_SOFTWARE=1
            install_menu
            add_packagemanager "package_install 'mesa mesa-demos sudo gksu xorg-fonts-{100,75}dpi ttf-freefont ttf-dejavu' 'INSTALL-DESKTOP'" "INSTALL-DESKTOP"
        fi
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL BASIC {{{
# USAGE      : install_basic
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_basic()
{
    install_basic_setup
    install_xorg
    install_reflector
    install_nfs
    install_samba
    install_lmt
    install_preload
    install_zram
    install_cups
    install_additional_firmwares
    install_git_tor
    install_usb_modem
    install_network_manager
    install_video_cards
    choose_aurhelper
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL MENU {{{
# USAGE      : install_menu
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_menu()
{
    install_basic
    load_menu
    checklist=( "${Menu[@]}" )
    while [[ 1 ]]; do
        print_title "ARCHLINUX ULTIMATE INSTALL (AUI) Main Menu - https://github.com/helmuthdu/aui"
        print_info $"Basic Setup: Required: SYSTEMD, Video Card, DBUS, AVAHI, ACPI, ALSA, (UN)COMPRESS TOOLS, NFS, SAMBA, XORG, CUPS, SSH and more."
        print_info $"Desktop Environment: Mate, KDE, XFCE, Awesome, Cinnamon, E17, LXDE, OpenBox, GNOME and Unity"
        print_info $"Display Manager: GDM, Elsa, LightDM, LXDM and Slim"
        print_info $"Accessories Apps: cairo-dock-bzr, Conky, deepin-scrot, dockbarx, speedcrunch, galculator, gnome-pie, guake, kupfer, pyrenamer, shutter, synapse, terminator, zim, Revelation"
        print_info $"Development Apps: aptana-studio, bluefish, eclipse, emacs, gvim, geany, IntelliJ IDEA, kdevelop, Oracle Java, Qt and Creator, Sublime Text 2, Debugger Tools, MySQL Workbench, meld, RabbitVCS, Wt, astyle and putty"
        print_info $"Office Apps: Libre Office, Caligra or Abiword + Gnumeric, latex, calibre, gcstar, homebank, impressive, nitrotasks, ocrfeeder, xmind and zathura."
        print_info $"System Apps: "
        print_info $"Graphics Apps: "
        print_info $"Internet Apps: "
        print_info $"Audio Apps: "
        print_info $"Video Apps: "
        print_info $"Games: "
        print_info $"Science and Education: $INSTALL_SCIENCE_EDUCATION"
        print_info $"Web server: "
        print_info $"Fonts: "
        print_info $"Extra: "
        print_info $"Clean Orphan Packages: "
        print_info $"Load Custom Software: Save a list of software that is not in this Script to a file called custom-software-list.txt in same folder as this script, it will install it as well."
        print_info $"Load Software: Loads Saved Software"
        print_info $"Save Software: Run though all the options and save them to disk, next time just Load Software, so you do not have to go though Menu's again"
        print_info $"Edit Configuration: Allows you to review and edit configuration variables before installing software."
        print_info $"Install Software: Saves and Installs list and configurations creates with this menu."
        print_info $"Quit Menu: If in Boot mode will run pacstrap, if in software mode will install Software."
        clear_mainmenu
        mainmenu_item 1  $"Desktop Environment"   "" ""
        mainmenu_item 2  $"Display Manager"       "" ""
        mainmenu_item 3  $"Accessories Apps"      "" ""
        mainmenu_item 4  $"Development Apps"      "" ""
        mainmenu_item 5  $"Office Apps"           "" ""
        mainmenu_item 6  $"System Apps"           "" ""
        mainmenu_item 7  $"Graphics Apps"         "" ""
        mainmenu_item 8  $"Internet Apps"         "" ""
        mainmenu_item 9  $"Audio Apps"            "" ""
        mainmenu_item 10 $"Video Apps"            "" ""
        mainmenu_item 11 $"Games"                 "" ""
        mainmenu_item 12 $"Science"               "" ""
        mainmenu_item 13 $"Web server"            "" ""
        mainmenu_item 14 $"Fonts"                 "" ""
        mainmenu_item 15 $"Extra"                 "" ""
        mainmenu_item 16 $"Kernel"                "" ""
        mainmenu_item 17 $"Clean Orphan Packages" "" ""
        mainmenu_item 18 $"Edit Configuration"    "" ""
        mainmenu_item 19 $"Load Custom Software"  "" ""
        mainmenu_item 20 $"Load Software"         "" ""
        mainmenu_item 21 $"Save Software"         "" ""
        mainmenu_item 22 $"Install Software"      "" ""
        print_mm "Q"
        MAINMENU+=" q"
        read_input_options "$MAINMENU"
        for OPT in ${OPTIONS[@]}; do
            case "$OPT" in
                1)
                    checklist["$OPT"]=1
                    install_desktop_environment # Desktop Environment
                    ;;
                2)
                    checklist["$OPT"]=1
                    install_display_manager     # Display Manager
                    ;;
                3)
                    checklist["$OPT"]=1
                    install_accessories_apps    # Accessories Apps
                    ;;
                4)
                    checklist["$OPT"]=1
                    install_development_apps    # Development Apps
                    ;;
                5)
                    checklist["$OPT"]=1
                    install_office_apps         # Office Apps
                    ;;
                6)
                    checklist["$OPT"]=1
                    install_system_apps
                    ;;
                7)
                    checklist["$OPT"]=1
                    install_graphics_apps
                    ;;
                8)
                    checklist["$OPT"]=1
                    install_internet_apps
                    ;;
                9)
                    checklist["$OPT"]=1
                    install_audio_apps
                    ;;
               10)
                    checklist["$OPT"]=1
                    install_video_apps
                    ;;
               11)
                    checklist["$OPT"]=1
                    install_games
                    ;;
               12)
                    checklist["$OPT"]=1
                    install_science
                    ;;
                    
               13)
                    checklist["$OPT"]=1
                    install_web_server
                    ;;
               14)
                    checklist["$OPT"]=1
                    install_fonts
                    ;;
               15)
                    checklist["$OPT"]=1
                    install_extra
                    ;;
               16)
                    checklist["$OPT"]=1
                    install_kernel
                    ;;
               17)
                    checklist["$OPT"]=1
                    clean_orphan_packages
                    ;;
               18)
                    checklist["$OPT"]=1
                    get_hostname
                    configure_timezone
                    get_user_name
                    add_custom_repositories
                    ;;
               19)
                    checklist["$OPT"]=1
                    load_custom_software
                    ;;
               20)
                    checklist["$OPT"]=1
                    load_software # @FIX
                    ;;
               21)
                    checklist["$OPT"]=1
                    save_software
                    SAVED_SOFTWARE=1
                    ;;
               22)
                    checklist["$OPT"]=1
                    save_software
                    SAVED_SOFTWARE=1
                    if [[ "$MOUNTPOINT" == " " ]]; then
                        install_software_live
                    fi
                    OPT="q"
                    Menu=( "${checklist[@]}" ) # Save Menu Checklist
                    save_menu
                    break;
                    ;;
              "q")
                    Menu=( "${checklist[@]}" ) # Save Menu Checklist
                    save_menu
                    if [[ "$SAVED_SOFTWARE" -eq 0 ]]; then
                        read_input_yn "Save Software Configuratoin for later use" 1
                        if [[ "$YN_OPTION" -eq 1 ]]; then
                            save_software
                            SAVED_SOFTWARE=1
                        fi
                    fi
                    break
                    ;;
                *)
                    invalid_option "$OPT"
                    ;;
            esac
        done
        is_breakable "$OPT" "q"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL DESKTOP ENVIRONMENT {{{
# USAGE      : install_desktop_environment
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_desktop_environment() 
{ 
    # 1
    clear_sub
    checklistsub=( "${DESKTOP_ENVIRONMENT[@]}" )
    while [[ 1 ]]; do
        print_title "DESKTOP ENVIRONMENT - https://wiki.archlinux.org/index.php/Desktop_Environment"
        print_info $"A Desktop environments (DE) provide a complete graphical user interface (GUI) for a system by bundling together a variety of X clients written using a common widget toolkit and set of libraries."
        print_info $"Mate, KDE, XFCE, Awesome, Cinnamon, E17, LXDE, OpenBox, GNOME, and Unity"
        clear_smenu
        submenu_item 1  "Mate"     "The Way Gnome should be..." ""
        submenu_item 2  "KDE"      "" ""
        submenu_item 3  "XFCE"     "" ""
        submenu_item 4  "Awesome"  "" ""
        submenu_item 5  "Cinnamon" "" "$AUR"
        submenu_item 6  "E17"      "" ""
        submenu_item 7  "LXDE"     "" ""
        submenu_item 8  "OpenBox"  "" ""
        submenu_item 9  "GNOME"    "" ""
        submenu_item 10 "Unity"    "" " $AUR"
        submenu_item 11 "DE Extras" "" ""
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    install_mate
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    install_kde
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    install_xfce
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    install_awesome
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    install_cinnamon
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    install_e17
                    ;;
                7)
                    checklistsub["$S_OPT"]=1
                    install_lxde
                    ;;
                8)
                    checklistsub["$S_OPT"]=1
                    install_openbox
                    ;;
                9)
                    checklistsub["$S_OPT"]=1
                    install_gnome
                    ;;
                10)
                    checklistsub["$S_OPT"]=1
                    install_unity
                    ;;
                11)
                    checklistsub["$S_OPT"]=1
                    install_de_extras
                    ;;
               "d")
                    DESKTOP_ENVIRONMENT=( "${checklistsub[@]}" ) # Save Sub Menu Checklist
                    break;
                    ;;
                 *) 
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL MATE {{{
# USAGE      : install_mate
# DESCRIPTION: Installs Mate Desktop.
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_mate()
{
    # 1
    print_title "Mate - https://wiki.archlinux.org/index.php/MATE"
    print_info $"Install Mate Desktop - Recommended over Gnome, its like Gnome 2, without the Crazy Gnome 3 stuff."
    print_info $"Full List: $INSTALL_MATE" 
    MATE_INSTALLED=1
    GNOME_INSTALL=1
    if [[ "$MOUNTPOINT" == " " ]]; then
        if ! grep -Fxq "[mate]" /etc/pacman.conf; then
            echo "[mate]" >> /etc/pacman.conf
            echo "Server = http://repo.mate-desktop.org/archlinux/\$arch" >> /etc/pacman.conf
        fi
    else
        if ! grep -Fxq "[mate]" $MOUNTPOINT/etc/pacman.conf; then
            echo "[mate]" >> $MOUNTPOINT/etc/pacman.conf
            echo "Server = http://repo.mate-desktop.org/archlinux/\$arch" >> $MOUNTPOINT/etc/pacman.conf
        fi
    fi
    add_packagemanager "package_remove 'zenity'" "REMOVE-MATE" # mate replacement
    add_packagemanager "package_install \"$INSTALL_MATE\" 'INSTALL-MATE'" "INSTALL-MATE" 
    add_packagemanager "systemctl enable accounts-daemon.service polkitd.service upower.service console-kit-daemon.service" "SYSTEMD-ENABLE-MATE"
    # pacstrap will overwrite pacman.conf so copy it to temp 
    copy_file ${MOUNTPOINT}"/etc/pacman.conf" "$SCRIPT_DIR/etc/pacman.conf" "$LINENO"
    pause_function "$LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL KDE {{{
# USAGE      : install_kde
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_kde()
{
    # 2
    clear_sub
    print_title "KDE - https://wiki.archlinux.org/index.php/KDE"
    print_info $"KDE is an international free software community producing an integrated set of cross-platform applications designed to run on Linux, FreeBSD, Microsoft Windows, Solaris and Mac OS X systems. It is known for its Plasma Desktop, a desktop environment provided as the default working environment on many Linux distributions."
    add_packagemanager "package_install 'kde-meta kde-l10n-$LANGUAGE_KDE kipi-plugins kdeadmin-system-config-printer-kde xdg-user-dirs phonon-vlc' 'INSTALL-KDE'" "INSTALL-KDE" # "kde-telepathy telepathy"
    add_packagemanager "package_remove 'kdemultimedia-kscd kdemultimedia-juk'" "REMOVE-KDE"
    add_packagemanager "aur_package_install 'kde-gtk-config-git oxygen-gtk2 oxygen-gtk3 qtcurve-gtk2 qtcurve-kde4 bespin-svn' 'AUR-INSTALL-KDE'" "AUR-INSTALL-KDE"
    CONFIG_KDE=1
    #KDE CUSTOMIZATION {{{
    while [[ 1 ]]; do
        print_title "KDE CUSTOMIZATION"
        clear_smenu
        submenu_item 1 "apper" "" ""
        submenu_item 2 "bangarang" "" "$AUR"
        submenu_item 3 "choqok" "" ""
        submenu_item 4 "digikam" "" ""
        submenu_item 5 "k3b" "" ""
        submenu_item 6 "rosa-icons" "" "$AUR"
        submenu_item 7 "Plasma Themes" "" ""
        submenu_item 8 "yakuake" "" ""
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'apper' 'INSTALL-APPER'" "INSTALL-APPER"
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'bangarang' 'AUR-INSTALL-BANGARANG'" "AUR-INSTALL-BANGARANG"
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'choqok' 'INSTALL-CHOQOK'" "INSTALL-CHOQOK"
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'digikam' 'INSTALL-DIGIKAM'" "INSTALL-DIGIKAM"
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'k3b cdrdao dvd+rw-tools' 'INSTALL-K3B'" "INSTALL-K3B"
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'rosa-icons' 'AUR-INSTALL-ROSA-ICONS'" "AUR-INSTALL-ROSA-ICONS"
                    ;;
                7)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'caledonia-bundle plasma-theme-rosa plasma-theme-produkt ronak-plasmatheme' 'AUR-INSTALL-PLASMA-THEMES'" "AUR-INSTALL-PLASMA-THEMES"
                    ;;
                8)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'yakuake' 'INSTALL-YAKUAKE'" "INSTALL-YAKUAKE"
                    add_packagemanager "aur_package_install 'yakuake-skin-plasma-oxygen-panel' 'AUR-INSTALL-YAKUAKE'" "AUR-INSTALL-YAKUAKE"
                    ;;
              "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
    # Application development toolkit for controlling system-wide privileges
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    add_packagemanager "systemctl enable kdm.service polkitd.service upower.service console-kit-daemon.service" "SYSTEMD-ENABLE-KDE"
    KDE_INSTALLED=1
}
# INSTALL GNOME {{{
# USAGE      : install_gnome
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_gnome()
{
    GNOME_INSTALLED=1
    CONFIG_GNOME=1
    # 9
    clear_sub
    print_title "GNOME - https://wiki.archlinux.org/index.php/GNOME"
    print_info $"GNOME is a desktop environment and graphical user interface that runs on top of a computer operating system. It is composed entirely of free and open source software. It is an international project that includes creating software development frameworks, selecting application software for the desktop, and working on the programs that manage application launching, file handling, and window and task management."
    print_info $"GNOME Shell Extensions: disper gpaste gnome-shell-extension-gtile-git gnome-shell-extension-mediaplayer-git gnome-shell-extension-noa11y-git gnome-shell-extension-pomodoro-git gnome-shell-extension-user-theme-git gnome-shell-extension-weather-git gnome-shell-system-monitor-applet-git"
    print_info $"GNOME Shell Themes: gnome-shell-theme-default-mod gnome-shell-theme-dark-shine gnome-shell-theme-elegance gnome-shell-theme-eos gnome-shell-theme-frieze gnome-shell-theme-google+"
    add_packagemanager "package_install 'gnome gucharmap gksu nautilus-open-terminal gnome-search-tool gedit-plugins gnome-tweak-tool gvfs-smb gvfs-afc zeitgeist deja-dup pulseaudio system-config-printer-gnome ttf-bitstream-vera ttf-dejavu ttf-freefont empathy-theme-candybars empathy-theme-adium-matte gnome-defaults-list' 'INSTALL-GNOME'" "INSTALL-GNOME"
    # telepathy
    while [[ 1 ]]; do
        print_title "GNOME CUSTOMIZATION"
        clear_smenu
        submenu_item 1 "GNOME Shell Extensions" "" "$AUR"
        submenu_item 2 "GNOME Shell Themes" "" ""
        submenu_item 3 "GNOME Packagekit" "" ""
        submenu_item 4 "activity-journal" "" "$AUR"
        submenu_item 5 "activity-log-manager" "" "$AUR"
        submenu_item 6 "gloobus-sushi-bzr" "" "$AUR"
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    # GNOMESHELL EXTENSIONS {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "GNOMESHELL EXTENSIONS"
                        subsubmenu_item 1  "disper" "" ""
                        subsubmenu_item 2  "gpaste" "" ""
                        subsubmenu_item 3  "mediaplayer" "" ""
                        subsubmenu_item 4  "noa11y" "" ""
                        subsubmenu_item 5  "pomodoro" "" ""
                        subsubmenu_item 6  "System-monitor-applet" "" ""
                        subsubmenu_item 7  "user-theme" "" ""
                        subsubmenu_item 8  "weather" "" ""
                        subsubmenu_item 9  "gtile" "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'disper' 'AUR-INSTALL-GSHELL-DISPER'" "AUR-INSTALL-GSHELL-DISPER"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gpaste' 'AUR-INSTALL-GSHELL-GPASTE'" "AUR-INSTALL-GSHELL-GPASTE"
                                    ;;
                                 3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gnome-shell-extension-mediaplayer-git' 'AUR-INSTALL-GSHELL-MEDIAPLAYER'" "AUR-INSTALL-GSHELL-MEDIAPLAYER"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gnome-shell-extension-noa11y-git' 'AUR-INSTALL-GSHELL-NOA11Y'" "AUR-INSTALL-GSHELL-NOA11Y"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'libkeybinder3 gnome-shell-extension-pomodoro-git' 'AUR-INSTALL-GSHELL-POMODORO'" "AUR-INSTALL-GSHELL-POMODORO"
                                    ;;
                                6)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gnome-shell-system-monitor-applet-git' 'AUR-INSTALL-GSHELL-SYSTEM-MONITOR'" "AUR-INSTALL-GSHELL-SYSTEM-MONITOR"
                                    ;;
                                7)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gnome-shell-extension-user-theme-git' 'AUR-INSTALL-GSHELL-USER-THEME'" "AUR-INSTALL-GSHELL-USER-THEME"
                                    ;;
                                8)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gnome-shell-extension-weather-git' 'AUR-INSTALL-GSHELL-WEATHER'" "AUR-INSTALL-GSHELL-WEATHER"
                                    ;;
                                9)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gnome-shell-extension-gtile-git' 'AUR-INSTALL-GSHELL-GTILE'" "AUR-INSTALL-GSHELL-GTILE"
                                    ;;
                              "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                           esac
                        done
                        is_breakable "$SS_OPT" "b"
                    done
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #GNOMESHELL THEMES {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "GNOMESHELL THEMES"
                        subsubmenu_item 1  "default-mod" "" ""
                        subsubmenu_item 2  "dark-shine"  "" ""
                        subsubmenu_item 3  "elegance"    "" ""
                        subsubmenu_item 4  "eos"         "" ""
                        subsubmenu_item 5  "frieze"      "" ""
                        subsubmenu_item 6  "google+"     "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gnome-shell-theme-default-mod' 'AUR-INSTALL-GSHELL-THEMES-DEFAULT'" "AUR-INSTALL-GSHELL-THEMES-DEFAULT"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gnome-shell-theme-dark-shine' 'AUR-INSTALL-GSHELL-THEMES-DARK-SHINE'" "AUR-INSTALL-GSHELL-THEMES-DARK-SHINE"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gnome-shell-theme-elegance' 'AUR-INSTALL-GSHELL-THEMES-ELEGANCE'" "AUR-INSTALL-GSHELL-THEMES-ELEGANCE"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gnome-shell-theme-eos' 'AUR-INSTALL-GSHELL-THEMES-EOS'" "AUR-INSTALL-GSHELL-THEMES-EOS"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gnome-shell-theme-frieze' 'AUR-INSTALL-GSHELL-THEMES-FRIEZE'" "AUR-INSTALL-GSHELL-THEMES-FRIEZE"
                                    ;;
                                6)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gnome-shell-theme-google+' 'AUR-INSTALL-GSHELL-THEMES-GOOGLE'" "AUR-INSTALL-GSHELL-THEMES-GOOGLE"
                                    ;;
                              "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                        is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'gnome-packagekit gnome-settings-daemon-updates' 'INSTALL-GNOME-PACKAGEKIT'" "INSTALL-GNOME-PACKAGEKIT"
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    # activity-journal
                    add_packagemanager "aur_package_install 'libzeitgeist python2-rdflib zeitgeist-datahub gnome-activity-journal' 'AUR-INSTALL-GNOME-CUSTOMIZATION-ACTIVITY-JOURNAL'" "AUR-INSTALL-GNOME-CUSTOMIZATION-ACTIVITY-JOURNAL"
                    ;;
                5)
                    # activity-log-manager
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'activity-log-manager' 'AUR-INSTALL-GNOME-CUSTOMIZATION-ACTIVITY-LOG-MANAGER'" "AUR-INSTALL-GNOME-CUSTOMIZATION-ACTIVITY-LOG-MANAGER"
                    ;;
                6)
                    # gloobus-sushi-bzr
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'gloobus-sushi-bzr' 'AUR-INSTALL-GNOME-CUSTOMIZATION-GLOOBUS'" "AUR-INSTALL-GNOME-CUSTOMIZATION-GLOOBUS"
                    ;;
              "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
    #}}}
    #Gnome Display Manager (a reimplementation of xdm)
    #D-Bus interface for user account query and manipulation
    #Application development toolkit for controlling system-wide privileges
    #Abstraction for enumerating power devices, listening to device events and querying history and statistics
    #A framework for defining and tracking users, login sessions, and seats
    add_packagemanager "systemctl enable accounts-daemon.service polkitd.service upower.service console-kit-daemon.service" "SYSTEMD-ENABLE-GNOME"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL AWESOME {{{
# USAGE      : install_awesome
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_awesome()
{
    # 4
    clear_sub
    AWESOME_INSTALLED=1
    add_packagemanager "package_install 'awesome lxappearance consolekit leafpad epdfview nitrogen ttf-bitstream-vera ttf-dejavu ttf-freefont' 'INSTALL-AWESOME'" "INSTALL-AWESOME"
    add_packagemanager "aur_package_install 'gnome-defaults-list' 'AUR-INSTALL-AWESOME'" "AUR-INSTALL-AWESOME"
    TEMP=$(config_xinitrc 'awesome')
    add_packagemanager "$TEMP" "CONFIG-XINITRC-AWESOME"
    add_packagemanager "make_dir \"/home/$USERNAME/.config/awesome/\" \"$LINENO\"; copy_file '/etc/xdg/awesome/rc.lua' \"/home/$USERNAME/.config/awesome/\" \"$LINENO\"; chown -R $USERNAME:$USERNAME /home/$USERNAME/.config" "CONFIG-AWESOME"   
    while [[ 1 ]];  do
        print_title "AWESOME - https://wiki.archlinux.org/index.php/Awesome"
        print_info $"awesome is a highly configurable, next generation framework window manager for X. It is very fast, extensible and licensed under the GNU GPLv2 license."
        print_info $"AWESOME CUSTOMIZATION"
        clear_smenu
        submenu_item 1  "xcompmgr"     "" ""
        submenu_item 2  "viewnior"     "" ""
        submenu_item 3  "gmrun"        "" ""
        submenu_item 4  "PCManFM"      "" ""
        submenu_item 5  "rxvt-unicode" "" ""
        submenu_item 6  "scrot"        "[Print Screen]" ""
        submenu_item 7  "thunar"       "[File Browser]" ""
        submenu_item 8  "tint2"        "" ""
        submenu_item 9  "volwheel"     "" ""
        submenu_item 10 "xfburn"       "" ""
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'xcompmgr transset-df' 'INSTALL-XCOMPMGR'" "INSTALL-XCOMPMGR"
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'viewnior' 'INSTALL-VIEWNIOR'" "INSTALL-VIEWNIOR"
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'gmrun' 'INSTALL-GMRUN'" "INSTALL-GMRUN"
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'pcmanfm' 'INSTALL-PCMANFM'" "INSTALL-PCMANFM"
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'rxvt-unicode' 'INSTALL-RXVT-UNICODE'" "INSTALL-RXVT-UNICODE"
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'scrot' 'INSTALL-SCROT'" "INSTALL-SCROT"
                    ;;
                7)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'thunar tumbler' 'INSTALL-THUNAR'" "INSTALL-THUNAR"
                    ;;
                8)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'tint2' 'INSTALL-TINT2'" "INSTALL-TINT2"
                    ;;
                9)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'volwheel' 'INSTALL-VOLWHEEL'" "INSTALL-VOLWHEEL"
                    ;;
               10)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'xfburn' 'INSTALL-XFBURN'" "INSTALL-XFBURN"
                    ;;
              "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    add_packagemanager "systemctl enable upower.service console-kit-daemon.service" "SYSTEMD-ENABLE-AWESOME"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL CINNAMON {{{
# USAGE      : install_cinnamon
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_cinnamon()
{
    # 5
    clear_sub
    CINNAMON_INSTALLED=1
    add_packagemanager "package_install 'gedit-plugins gksu nautilus-open-terminal gnome-tweak-tool xdg-user-dirs-gtk gvfs-smb gvfs-afc pulseaudio deja-dup system-config-printer-gnome ttf-bitstream-vera ttf-dejavu ttf-freefont accountsservice caribou empathy dbus-glib folks gjs gnome-bluetooth gnome-control-center gnome-desktop gnome-menus gnome-menus2 gnome-panel gnome-session gnome-settings-daemon gnome-themes-standard libcroco libgnomekbd libpulse muffin-wm notification-daemon python2 python2-gconf python2-imaging python2-lxml telepathy-logger python2-distutils-extra' 'INSTALL-CINNAMON'" "INSTALL-CINNAMON"
    add_packagemanager "aur_package_install 'cinnamon empathy-theme-ubuntu-adium-bzr gnome-defaults-list gnome-extra-meta' 'AUR-INSTALL-CINNAMON'" "AUR-INSTALL-CINNAMON"
    # @FIX gnome-extra gnome-extra-meta telepathy
    # 
    TEMP=$(config_xinitrc 'gnome-session-cinnamon')
    add_packagemanager "$TEMP" "CONFIG-XINITRC-CINNAMON"
    # not sure how to run these commands; seems like they need to run after GUI is up and running; so adding them as a start up script may be what is needed
    # add_packagemanager "cinnamon-settings; cinnamon-settings panel; cinnamon-settings calendar; cinnamon-settings themes; cinnamon-settings applets; cinnamon-settings windows; cinnamon-settings fonts; cinnamon-settings hotcorner" "AUR-INSTALL-CINNAMON-SETTINGS"
    while [[ 1 ]]; do
        print_title "CINNAMON - https://wiki.archlinux.org/index.php/Cinnamon"
        print_info $"Cinnamon is a fork of GNOME Shell, initially developed by Linux Mint. It attempts to provide a more traditional user environment based on the desktop metaphor, like GNOME 2. Cinnamon uses Muffin, a fork of the GNOME 3 window manager Mutter, as its window manager."
        print_info $"CINNAMON CUSTOMIZATION"
        clear_smenu
        submenu_item 1 "Applets" "" "$AUR"
        submenu_item 2 "Themes" "" "$AUR" 
        submenu_item 3 "GNOME Packagekit" "" ""
        submenu_item 4 "GNOME Activity Journal" "" "$AUR"
        submenu_item 5 "gloobus-sushi-bzr" "" "$AUR"
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'cinnamon-applets' 'AUR-INSTALL-CINNAMON-APPLETS'" "AUR-INSTALL-CINNAMON-APPLETS"
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'cinnamon-themes' 'AUR-INSTALL-CINNAMON-THEMES'" "AUR-INSTALL-CINNAMON-THEMES"
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'gnome-packagekit gnome-settings-daemon-updates' 'INSTALL-GNOME-Packagekit'" "INSTALL-GNOME-Packagekit"
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'zeitgeist libzeitgeist python2-rdflib zeitgeist-datahub' 'INSTALL-ZEITGEIST'" "INSTALL-ZEITGEIST"
                    add_packagemanager "aur_package_install 'gnome-activity-journal' 'AUR-INSTALL-GNOME-ACTIVITY-JOURNAL'" "AUR-INSTALL-GNOME-ACTIVITY-JOURNAL"
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'gloobus-sushi-bzr' 'AUR-INSTALL-GLOOBUS'" "AUR-INSTALL-GLOOBUS"
                    ;;
              "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
    # Gnome Display Manager (a reimplementation of xdm)
    # D-Bus interface for user account query and manipulation
    # Application development toolkit for controlling system-wide privileges
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    add_packagemanager "systemctl enable accounts-daemon.service polkitd.service upower.service console-kit-daemon.service" "SYSTEMD-ENABLE-CINNAMON"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL E17 {{{
# USAGE      : install_e17
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_e17()
{
    # 6
    clear_sub
    E17_INSTALLED=1
    add_packagemanager "package_install 'e-svn e17-extra-svn consolekit xdg-user-dirs gvfs-smb gvfs-afc leafpad epdfview lxappearance consolekit ttf-bitstream-vera ttf-dejavu ttf-freefont' 'INSTALL-E17'" "INSTALL-E17"
    add_packagemanager "aur_package_install 'file-roller2-nn gnome-defaults-list' 'AUR-INSTALL-E17'" "AUR-INSTALL-E17"
    TEMP=$(config_xinitrc 'enlightenment_start')
    add_packagemanager "$TEMP" "CONFIG-XINITRC-E17"
    add_packagemanager "chown -R $USERNAME:$USERNAME /home/$USERNAME/.config" "CONFIG-XFCE"
    while [[ 1 ]]; do
        print_title "E17 - https://wiki.archlinux.org/index.php/E17"
        print_info $"Enlightenment, also known simply as E, is a stacking window manager for the X Window System which can be used alone or in conjunction with a desktop environment such as GNOME or KDE. Enlightenment is often used as a substitute for a full desktop environment."
        print_info $"E17 CUSTOMIZATION"
        clear_smenu
        submenu_item 1  "e17-icons"    "" "$AUR"
        submenu_item 2  "e17-themes"   "" "$AUR" 
        submenu_item 3  "viewnior"     "" ""
        submenu_item 4  "gmrun"        "" ""
        submenu_item 5  "PCManFM"      "" ""
        submenu_item 6  "rxvt-unicode" "" ""
        submenu_item 7  "scrot"        "Print Screen" ""
        submenu_item 8  "thunar"       "File Browser" ""
        submenu_item 9  "xfburn"       "" ""
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'e17-icons' 'AUR-INSTALL-E17-ICONS'" "AUR-INSTALL-E17-ICONS"
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'e17-themes' 'AUR-INSTALL-E17-THEMES'" "AUR-INSTALL-E17-THEMES"
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'viewnior' 'INSTALL-VIEWNIOR'" "INSTALL-VIEWNIOR"
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'gmrun' 'INSTALL-GMRUN'" "INSTALL-GMRUN"
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'pcmanfm' 'INSTALL-PCMANFM'" "INSTALL-PCMANFM"
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'rxvt-unicode' 'INSTALL-RXVT-UNICODE'" "INSTALL-RXVT-UNICODE"
                    ;;
                7)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'scrot' 'INSTALL-SCROT'" "INSTALL-SCROT"
                    ;;
                8)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'thunar tumbler' 'INSTALL-THUNAR'" "INSTALL-THUNAR"
                    ;;
                9)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'xfburn' 'INSTALL-XFBURN'" "INSTALL-XFBURN"
                    ;;
              "d")
                    break
                    ;;
               *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    add_packagemanager "systemctl enable upower.service console-kit-daemon.service" "SYSTEMD-ENABLE-E17"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL LXDE {{{
# USAGE      : install_lxde
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_lxde()
{
    # 7
    clear_sub
    LXDE_INSTALLED=1
    add_packagemanager "package_install 'lxde obconf consolekit pm-utils upower polkit-gnome xdg-user-dirs gvfs-smb gvfs-afc leafpad epdfview ttf-bitstream-vera ttf-dejavu ttf-freefont' 'INSTALL-LXDE'" "INSTALL-LXDE"
    add_packagemanager "aur_package_install 'file-roller2-nn gnome-defaults-list' 'AUR-INSTALL-LXDE'" "AUR-INSTALL-LXDE"
    while [[ 1 ]]; do
        print_title "LXDE - https://wiki.archlinux.org/index.php/lxde"
        print_info $"LXDE is a free and open source desktop environment for Unix and other POSIX compliant platforms, such as Linux or BSD. The goal of the project is to provide a desktop environment that is fast and energy efficient."
        print_info $"LXDE CUSTOMIZATION"
        clear_smenu
        submenu_item 1 "viewnior" "" ""
        submenu_item 2 "xfburn"   "" ""
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'viewnior' 'INSTALL-VIEWNIOR '" "INSTALL-VIEWNIOR"
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'xfburn' 'INSTALL-XFBURN'" "INSTALL-XFBURN"
                    ;;
              "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    add_packagemanager "systemctl enable upower.service console-kit-daemon.service" "SYSTEMD-ENABLE-LXDE"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL OPENBOX {{{
# USAGE      : install_openbox
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_openbox() 
{ 
    # 8
    clear_sub
    OPENBOX_INSTALLED=1
    add_packagemanager "package_install 'openbox obconf obmenu menumaker lxappearance consolekit xdg-user-dirs leafpad epdfview nitrogen gvfs-smb gvfs-afc ttf-bitstream-vera ttf-dejavu ttf-freefont' 'INSTALL-OPENBOX'" "INSTALL-OPENBOX"
    add_packagemanager "aur_package_install 'file-roller2-nn gnome-defaults-list' 'AUR-INSTALL-OPENBOX'" "AUR-INSTALL-OPENBOX"
    TEMP=$(config_xinitrc 'openbox-session')
    add_packagemanager "$TEMP" "CONFIG-XINITRC-OPENBOX"
    add_packagemanager "make_dir \"/home/$USERNAME/.config/openbox/\" \"$LINENO\"; copy_file '/etc/xdg/openbox/rc.xml' \"/home/$USERNAME/.config/openbox/\" \"$LINENO\"; copy_file '/etc/xdg/openbox/menu.xml' \"/home/$USERNAME/.config/openbox/\" \"$LINENO\"; copy_file '/etc/xdg/openbox/autostart' \"/home/$USERNAME/.config/openbox/\" \"$LINENO\"; chown -R $USERNAME:$USERNAME /home/$USERNAME/.config" "CONFIG-OPENBOX"  
    while [[ 1 ]]; do
        print_title "OPENBOX - https://wiki.archlinux.org/index.php/Openbox"
        print_info $"Openbox is a lightweight and highly configurable window manager with extensive standards support."
        print_info $"OPENBOX CUSTOMIZATION"
        clear_smenu
        submenu_item 1  "xcompmgr" "" ""
        submenu_item 2  "viewnior" "" ""
        submenu_item 3  "gmrun" "" ""
        submenu_item 4  "PCManFM"  "" ""
        submenu_item 5  "rxvt-unicode" "" ""
        submenu_item 6  "scrot"    "Print Screen" ""
        submenu_item 7  "thunar"   "File Browser" "" 
        submenu_item 8  "tint2"    "" ""
        submenu_item 9  "volwheel" "" ""
        submenu_item 10 "xfburn"   "" ""
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'xcompmgr transset-df' 'INSTALL-XCOMPMGR'" "INSTALL-XCOMPMGR"
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'viewnior' 'INSTALL-VIEWNIOR'" "INSTALL-VIEWNIOR"
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'gmrun' 'INSTALL-GMRUN'" "INSTALL-GMRUN"
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'pcmanfm' 'INSTALL-PCMANFM'" "INSTALL-PCMANFM"
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'rxvt-unicode' 'INSTALL-RXVT-UNICODE'" "INSTALL-RXVT-UNICODE"
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'scrot' 'INSTALL-SCROT'" "INSTALL-SCROT"
                    ;;
                7)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'thunar tumbler' 'INSTALL-THUNAR'" "INSTALL-THUNAR"
                    ;;
                8)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'tint2' 'INSTALL-TINT2'" "INSTALL-TINT2"
                    ;;
                9)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'volwheel' 'INSTALL-VOLWHEEL'" "INSTALL-VOLWHEEL"
                    ;;
               10)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'xfburn' 'INSTALL-XFBURN'" "INSTALL-XFBURN"
                    ;;
              "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    add_packagemanager "systemctl enable upower.service console-kit-daemon.service" "SYSTEMD-ENABLE-OPENBOX"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL XFCE {{{
# USAGE      : install_xfce
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_xfce() 
{ 
    # 3
    clear_sub
    XFCE_INSTALLED=1
    TEMP=$(config_xinitrc 'startxfce4')
    add_packagemanager "$TEMP" "CONFIG-XINITRC-XFCE"
    print_title "XFCE - https://wiki.archlinux.org/index.php/Xfce"
    print_info $"Xfce is a free software desktop environment for Unix and Unix-like platforms, such as Linux, Solaris, and BSD. It aims to be fast and lightweight, while still being visually appealing and easy to use."
    add_packagemanager "package_install 'xfce4 xfce4-goodies gvfs-smb gvfs-afc polkit-gnome xdg-user-dirs ttf-bitstream-vera ttf-dejavu ttf-freefont' 'INSTALL-XFCE'" "INSTALL-XFCE"
    add_packagemanager "aur_package_install 'file-roller2-nn gnome-defaults-list' 'AUR-INSTALL-XFCE'" "AUR-INSTALL-XFCE"
    while [[ 1 ]]; do
        clear_smenu
        submenu_item 1 "xfce4-volumed" "" "$AUR"
        print_title "XFCE CUSTOMIZATION"
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    add_packagemanager "aur_package_install 'xfce4-volumed' 'AUR-INSTALL-XFCE-CUSTOMIZATION'" "AUR-INSTALL-XFCE-CUSTOMIZATION"
                    ;;
              "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
       done
       is_breakable "$S_OPT" "d"
    done
    # Application development toolkit for controlling system-wide privileges
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    add_packagemanager "systemctl enable polkitd.service upower.service console-kit-daemon.service" "SYSTEMD-ENABLE-XFCE"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL UNITY {{{
# USAGE      : install_unity
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_unity() 
{ 
    # 10
    UNITY_INSTALLED=1
    print_warning "\nWARNING: EXPERIMENTAL OPTION, USE AT YOUR OWN RISK\nDo not install this if already have a DE or WM installed."
    read_input_yn "Are you sure you wish to continue?" 1
    [[ $YN_OPTION -eq 1 ]] && continue
    print_title "UNITY - https://wiki.archlinux.org/index.php/Unity"
    print_info $"Unity is an alternative shell for the GNOME desktop environment, developed by Canonical in its Ayatana project. It consists of several components including the Launcher, Dash, lenses, Panel, indicators, Notify OSD and Overlay Scrollbar."
    echo -e '\n[unity]\nServer = http://unity.xe-xe.org/$arch' >> $MOUNTPOINT/etc/pacman.conf
    echo -e '\n[unity-extra]\nServer = http://unity.xe-xe.org/extra/$arch' >> $MOUNTPOINT/etc/pacman.conf
    add_packagemanager "package_install 'unity gnome-terminal baobab eog eog-plugins evince file-roller gcalctool gedit gedit-plugins gnome-disk-utility gnome-font-viewer gnome-screenshot totem gksu nautilus-open-terminal gnome-search-tool gvfs-smb gvfs-afc zeitgeist deja-dup pulseaudio ttf-bitstream-vera ttf-dejavu ttf-freefont' 'INSTALL-UNITY'" "INSTALL-UNITY"
    # telepathy
    # Gnome Display Manager (a reimplementation of xdm)
    # D-Bus interface for user account query and manipulation
    # Application development toolkit for controlling system-wide privileges
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    # Network Management daemon
    add_packagemanager "systemctl enable lightdm.service accounts-daemon.service polkitd.service upower.service console-kit-daemon.service NetworkManager.service" "SYSTEMD-ENABLE-UNITY"
    # pacstrap will overwrite pacman.conf so copy it to temp 
    copy_file $MOUNTPOINT"/etc/pacman.conf" "$SCRIPT_DIR/etc/pacman.conf" "$LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL DISPLAY MANAGER {{{
# USAGE      : install_display_manager
# DESCRIPTION: Install Display Manager
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_display_manager() 
{
    # 2
    checklistsub=( "${DISPLAY_MANAGER[@]}" )
    while [[ 1 ]];  do
        print_title "DISPLAY MANAGER - https://wiki.archlinux.org/index.php/Display_Manager"
        print_info "A display manager, or login manager, is a graphical interface screen that is displayed at the end of the boot process in place of the default shell."
        clear_smenu
        submenu_item 1 $"GDM" "gdm" "Works with Mate"
        submenu_item 2 $"KDM" "kdm" ""
        submenu_item 3 $"Elsa" "" "$AUR"
        submenu_item 4 $"LightDM" "" ""
        submenu_item 5 $"LXDM" "" "$AUR"
        submenu_item 6 $"Slim" "Simple Login Manager" ""
        submenu_item 7 $"Qingy" "" ""
        submenu_item 8 $"XDM" "" ""
        print_sm "D"
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # GDM
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'gdm' 'INSTALL-GDM'" "INSTALL-GDM"
                    # dbus-launch
                    #add_packagemanager "package_install 'gdm gnome-control-center gconf-editor' 'INSTALL-GDM-CONTROL'" "INSTALL-GDM-CONTROL" # One only
                    #add_packagemanager "aur_package_install 'gdm3setup' 'AUR-INSTALL-GDM'" "AUR-INSTALL-GDM"
                    add_packagemanager "systemctl enable gdm.service" "SYSTEMD-ENABLE-GDM"
                    if [[ "$MATE_INSTALLED" -eq 1 ]]; then
                        TEMP=$(config_xinitrc 'mate-session')
                        add_packagemanager "$TEMP" "CONFIG-XINITRC-MATE"
                    elif [[ "$CINNAMON_INSTALLED" -eq 1 ]]; then
                        TEMP=$(config_xinitrc 'gnome-session-cinnamon')
                        add_packagemanager "$TEMP" "CONFIG-XINITRC-CINNAMON"
                    else
                        TEMP=$(config_xinitrc 'gnome-session')
                        add_packagemanager "$TEMP" "CONFIG-XINITRC-GNOME"
                    fi
                    break
                    ;;
                2)  # KDM
                    checklistsub["$S_OPT"]=1
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'kdm kdebase-workspace archlinux-themes-kdm' 'INSTALL-KDM'" "INSTALL-KDM"
                    add_packagemanager "systemctl enable kdm.service" "SYSTEMD-ENABLE-KDM"
                    TEMP=$(config_xinitrc 'startkde')
                    add_packagemanager "$TEMP" "CONFIG-XINITRC-KDE"
                    break
                    ;;
                3)  # Elsa 
                    add_packagemanager "aur_package_install 'elsa-svn-arch' 'AUR-INSTALL-ELSA'" "AUR-INSTALL-ELSA"
                    add_packagemanager "systemctl enable elsa.service" "SYSTEMD-ENABLE-ELSA"
                    break
                    ;;
                4)  # LightDM
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'dbus-glib libxklavier' 'INSTALL-LIGHTDM'" "INSTALL-LIGHTDM"
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        add_packagemanager "aur_package_install 'lightdm-kde' 'AUR-INSTALL-LIGHTDM'" "AUR-INSTALL-LIGHTDM-KDE"
                    fi
                    add_packagemanager "aur_package_install 'lightdm lightdm-gtk-greeter lightdm-webkit-greeter lightdm-crowd-greeter' 'AUR-INSTALL-LIGHTDM'" "AUR-INSTALL-LIGHTDM"
                    add_packagemanager "sed -i 's/#greeter-session=.*\$/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf" "RUN-LIGHTDM"
                    add_packagemanager "systemctl enable lightdm.service" "SYSTEMD-ENABLE-LIGHTDM"
                    break
                    ;;
                5)  # LXDM
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'lxdm' 'INSTALL-LXDM'" "INSTALL-LXDM"
                    add_packagemanager "systemctl enable lxdm.service" "SYSTEMD-ENABLE-LXDM"
                    TEMP=$(config_xinitrc 'startlxde')
                    add_packagemanager "$TEMP" "CONFIG-XINITRC-GNOME"
                    break
                    ;;
                6)  # Slim
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'slim slim-themes archlinux-themes-slim' 'INSTALL-SLIM'" "INSTALL-SLIM"
                    add_packagemanager "systemctl enable slim.service" "SYSTEMD-ENABLE-SLIM"
                    break
                    ;;
                7)  # Qingy
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'qingy qingy-theme-arch' 'INSTALL-QINGY'" "INSTALL-QINGY"
                    add_packagemanager "systemctl enable qingy@ttyX" "SYSTEMD-ENABLE-QINGY"
                    break
                    ;;
                8)  # XDM
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'xorg-xdm qiv' 'INSTALL-XDM'" "INSTALL-XDM"
                    add_packagemanager "systemctl enable qingy@ttyX" "SYSTEMD-ENABLE-XDM"
                    break
                    ;;
              "b")
                    DISPLAY_MANAGER=( "${checklistsub[@]}" ) # Save Sub Menu Checklist
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        break
    done
} 
#}}}
# -----------------------------------------------------------------------------
# INSTALL EXTRA {{{
# USAGE      : install_extra
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_extra()
{
    # 13
    clear_sub
    clear_subsub
    while [[ 1 ]]; do
        print_title "EXTRAs"
        print_info "ELEMENTARY PROJECT: Media Player, Sharing service, Screencasting, Contacts manager, RSS feeds Reader, File Manager, Note Taking, Compositing Manager, Email client, Dictionary, Maya Calendar, Web Browser, Audio Player, Text Editor, Dock, App Launcher, Desktop Settings Hub, Indicators Topbar, Elementary Icons, and Elementary Theme"
        print_info "https://aur.archlinux.org/packages/yapan/ and https://bbs.archlinux.org/viewtopic.php?id=113078"
        print_info "Yapan (Yet Another Package mAnager Notifier) — written in C++ and Qt. It shows an icon in the system tray and popup notifications for new packages and supports AUR helpers."
        clear_smenu
        submenu_item 1 $"Elementary Project" "" "$AUR"
        submenu_item 2 $"Yapan" "" "$AUR"
        print_sm "D"
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #ELEMENTARY PROJECT {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "ELEMENTARY PROJECT"
                        print_warning "\tsome of these programs still in alpha stage and may not work"
                        subsubmenu_item 1  "Media Player"         "audience-bzr" ""
                        subsubmenu_item 2  "Sharing service"      "contractor-bzr" ""
                        subsubmenu_item 3  "Screencasting"        "eidete-bzr" ""
                        subsubmenu_item 4  "Contacts manager"     "dexter-contacts-bzr" ""
                        subsubmenu_item 5  "RSS feeds Reader"     "feedler-bzr" ""
                        subsubmenu_item 6  "File Manager"         "files-bzr" ""
                        subsubmenu_item 7  "Note Taking"          "footnote-bzr" ""
                        subsubmenu_item 8  "Compositing Manager"  "gala-bzr" ""
                        subsubmenu_item 9  "Email client"         "geary-git" ""
                        subsubmenu_item 10 "Dictionary"           "lingo-dictionary-bzr" ""
                        subsubmenu_item 11 "Calendar"             "maya-bzr" ""
                        subsubmenu_item 12 "Web Browser"          "midori" ""
                        subsubmenu_item 13 "Audio Player"         "noise-bzr" ""
                        subsubmenu_item 14 "Text Editor"          "scratch-bzr" ""
                        subsubmenu_item 15 "Dock"                 "plank-bzr" ""
                        subsubmenu_item 16 "Terminal"             "pantheon-terminal-bzr" ""  
                        subsubmenu_item 17 "App Launcher"         "slingshot-bzr" ""
                        subsubmenu_item 18 "Desktop Settings Hub" "switchboard-bzr" ""
                        subsubmenu_item 19 "Indicators Topbar"    "wingpanel-bzr" ""
                        subsubmenu_item 20 "Elementary Icons"     "elementary-icons-bzr" ""
                        subsubmenu_item 21 "Elementary Theme"     "egtk-bzr" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'audience-bzr' 'AUR-INSTALL-EP-AUDIENCE'" "AUR-INSTALL-EP-AUDIENCE"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'contractor-bzr' 'AUR-INSTALL-EP-CONTRACTOR'" "AUR-INSTALL-EP-CONTRACTOR"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'eidete-bzr' 'AUR-INSTALL-EP-EIDETE'" "AUR-INSTALL-EP-EIDETE"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'dexter-contacts-bzr' 'AUR-INSTALL-EP-DEXTER'" "AUR-INSTALL-EP-DEXTER"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'feedler-bzr' 'AUR-INSTALL-EP-FEEDLER'" "AUR-INSTALL-EP-FEEDLER"
                                    ;;
                                6)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'files-bzr tumbler' 'AUR-INSTALL-EP-FILES'" "AUR-INSTALL-EP-FILES"
                                    ;;
                                7)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'footnote-bzr' 'AUR-INSTALL-EP-FOOTNOTE'" "AUR-INSTALL-EP-FOOTNOTE"
                                    ;;
                                8)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'gala-bzr' 'AUR-INSTALL-EP-GALA'" "AUR-INSTALL-EP-GALA"
                                    ;;
                                9)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'geary-git' 'AUR-INSTALL-EP-GEARY'" "AUR-INSTALL-EP-GEARY"
                                    ;;
                                10)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'lingo-dictionary-bzr' 'AUR-INSTALL-EP-LINGO'" "AUR-INSTALL-EP-LINGO"
                                    ;;
                                11)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'maya-bzr' 'AUR-INSTALL-EP-MAYA'" "AUR-INSTALL-EP-MAYA"
                                    ;;
                                12)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'midori' 'AUR-INSTALL-EP-MIDORI'" "AUR-INSTALL-EP-MIDORI"
                                    ;;
                                13)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'noise-bzr' 'AUR-INSTALL-EP-NOISE'" "AUR-INSTALL-EP-NOISE"
                                    ;;
                                14)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'scratch-bzr' 'AUR-INSTALL-EP-SCRATCH'" "AUR-INSTALL-EP-SCRATCH"
                                    ;;
                                15)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'plank-bzr' 'AUR-INSTALL-EP-PLANK'" "AUR-INSTALL-EP-PLANK"
                                    ;;
                                16)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'pantheon-terminal-bzr' 'AUR-INSTALL-EP-PANTHEON'" "AUR-INSTALL-EP-PANTHEON"
                                    ;;
                                17)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'slingshot-bzr' 'AUR-INSTALL-EP-SLINGSHOT'" "AUR-INSTALL-EP-SLINGSHOT"
                                    ;;
                                18)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'switchboard-bzr' 'AUR-INSTALL-EP-SWITCHBOARD" "AUR-INSTALL-EP-SWITCHBOARD"
                                    ;;
                                19)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'wingpanel-bzr' 'AUR-INSTALL-EP-WINGPANEL'" "AUR-INSTALL-EP-WINGPANEL"
                                    ;;
                                20)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'elementary-icons-bzr' 'AUR-INSTALL-EP-ICONS'" "AUR-INSTALL-EP-ICONS"
                                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary" "RUN-GTK_UPDATE"
                                    ;;
                                21)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'egtk-bzr' 'AUR-INSTALL-EP-EGTK'" "AUR-INSTALL-EP-EGTK"
                                    ;;
                               "b")
                                    break
                                    ;;
                                 *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                        is_breakable "$SS_OPT" "b"
                    done
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'yapan' 'INSTALL-YAPAN'" "INSTALL-YAPAN"
                    break; 
                    ;;
              "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL AUDIO APPS {{{
# USAGE      : install_audio_apps
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_audio_apps()
{
    # 8
    clear_sub
    clear_subsub
    while [[ 1 ]]; do
        print_title "AUDIO APPS"
        clear_smenu
        submenu_item 1 "Players"       "" ""
        submenu_item 2 "Editors|Tools" "" "" 
        submenu_item 3 "Codecs"        "" ""
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #PLAYERS {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "AUDIO PLAYERS"
                        subsubmenu_item 1  "Amarok"        "" ""
                        subsubmenu_item 2  "Audacious"     "" ""
                        subsubmenu_item 3  "Banshee"       "" ""
                        subsubmenu_item 4  "Clementine"    "" ""
                        subsubmenu_item 5  "Dead beef"     "" ""
                        subsubmenu_item 6  "Exaile"        "" "$AUR" 
                        subsubmenu_item 7  "Musique"       "" "$AUR" 
                        subsubmenu_item 8  "Nuvola Player" "" "$AUR" 
                        subsubmenu_item 9  "Rhythmbox"     "" ""
                        subsubmenu_item 10 "Radio tray"    "" "$AUR" 
                        subsubmenu_item 11 "Spotify"       "" "$AUR" 
                        subsubmenu_item 12 "Tomahawk"      "" "$AUR" 
                        subsubmenu_item 13 "Timidity++"    "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'amarok' 'INSTALL-AMAROK'" "INSTALL-AMAROK"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'audacious audacious-plugins' 'INSTALL-AUDACIOUS'" "INSTALL-AUDACIOUS"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'banshee' 'INSTALL-BANSHEE'" "INSTALL-BANSHEE"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'clementine' 'INSTALL-CLEMENTINE'" "INSTALL-CLEMENTINE"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'deadbeef' 'INSTALL-DEADBEEF'" "INSTALL-DEADBEEF"
                                    ;;
                                6)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'exaile' 'AUR-INSTALL-EXAILE'" "AUR-INSTALL-EXAILE"
                                    ;;
                                7)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'musique' 'AUR-INSTALL-MUSIQUE'" "AUR-INSTALL-MUSIQUE"
                                    ;;
                                8)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'nuvolaplayer' 'AUR-INSTALL-NUVOLAPLAYER" "AUR-INSTALL-NUVOLAPLAYER"
                                    ;;
                                9)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'rhythmbox' 'INSTALL-RHYTHMBOX'" "INSTALL-RHYTHMBOX"
                                    ;;
                               10)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'radiotray' 'AUR-INSTALL-RADIOTRAY'" "AUR-INSTALL-RADIOTRAY"
                                    ;;
                               11)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'spotify' 'AUR-INSTALL-SPOTIFY'" "AUR-INSTALL-SPOTIFY"
                                    ;;
                               12)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'tomahawk' 'AUR-INSTALL-TOMAHAWK'" "AUR-INSTALL-TOMAHAWK"
                                    ;;
                               13)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'timidity++ fluidr3' 'AUR-INSTALL-TIMIDITY'" "AUR-INSTALL-TIMIDITY"
                                    add_packagemanager"echo -e 'soundfont /usr/share/soundfonts/fluidr3/FluidR3GM.SF2' >> /etc/timidity++/timidity.cfg" "RUN-TIMIDITY"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #EDITORS {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "AUDIO EDITORS|TOOLS"
                        subsubmenu_item 1  "soundconverter" "or soundkonverter Depending on DE" ""
                        subsubmenu_item 2  "puddletag"      "" ""
                        subsubmenu_item 3  "Audacity"       "" ""
                        subsubmenu_item 4  "Ocenaudio"      "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    if [[ $KDE_INSTALLED -eq 1 ]]; then
                                        if [[ $MATE_INSTALLED -eq 1 ]]; then
                                            add_packagemanager "package_install 'soundconverter' 'INSTALL-SOUNDCONVERTER'" "INSTALL-SOUNDCONVERTER"
                                        fi
                                        add_packagemanager "package_install 'soundkonverter' 'INSTALL-SOUNDKONVERTER'" "INSTALL-SOUNDKONVERTER"
                                    else
                                        add_packagemanager "package_install 'soundconverter' 'INSTALL-SOUNDCONVERTER'" "INSTALL-SOUNDCONVERTER"
                                    fi
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'puddletag' 'AUR-INSTALL-PUDDLETAG'" "AUR-INSTALL-PUDDLETAG"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'audacity' 'INSTALL-AUDACITY'" "INSTALL-AUDACITY"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'ocenaudio' 'AUR-INSTALL-OCENAUDIO'" "AUR-INSTALL-OCENAUDIO"
                                    ;;
                              "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'gstreamer0.10-plugins mpg123 flac' 'INSTALL-AUDIO-CODECS'" "INSTALL-AUDIO-CODECS"
                    ;;
                "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
    is_breakable "$S_OPT" "d"
    done
}
#}}}
# -----------------------------------------------------------------------------
#OFFICE {{{
# USAGE      : install_office_apps
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_office_apps()
{
    # 4
    checklistsub=( "${OFFICE_APPS[@]}" )
    while [[ 1 ]]; do
        print_title "OFFICE APPS"
        clear_smenu
        submenu_item 1  "LibreOffice" "" ""
        submenu_item 2  "Caligra or Abiword + Gnumeric" "Depending on DE" ""
        submenu_item 3  "latex" "" ""
        submenu_item 4  "calibre" "" ""
        submenu_item 5  "gcstar" "" ""
        submenu_item 6  "homebank" "" ""
        submenu_item 7  "impressive" "" ""
        submenu_item 8  "nitrotasks" "" "$AUR"
        submenu_item 9  "ocrfeeder" "" ""
        submenu_item 10 "xmind" "" "$AUR" 
        submenu_item 11 "zathura" "" ""
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    print_title "LIBREOFFICE - https://wiki.archlinux.org/index.php/LibreOffice"
                    print_title "Libre Office - https://wiki.archlinux.org/index.php/LibreOffice"
                    add_packagemanager "package_install \"ttf-dejavu artwiz-fonts libreoffice-{${LANGUAGE_LO},common,base,calc,draw,impress,math,writer,gnome,kde4,sdk,sdk-doc} libreoffice-extension-presenter-screen libreoffice-extension-pdfimport hunspell hunspell-$LANGUAGE_HS hyphen hyphen-$LANGUAGE_HS libmythes mythes-$LANGUAGE_HS aspell-$LANGUAGE_AS\" 'INSTALL-LIBRE_OFFICE'" "INSTALL-LIBRE_OFFICE"
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1   ]]; then
                            add_packagemanager "package_install 'libreoffice-gnome' 'INSTALL-LIBRE-OFFICE-GNOME'" "INSTALL-LIBRE-OFFICE-GNOME"
                        fi
                        add_packagemanager "package_install 'libreoffice-kde4' 'INSTALL-LIBRE-OFFICE-KDE'" "INSTALL-LIBRE-OFFICE-KDE"
                    else
                        add_packagemanager "package_install 'libreoffice-gnome' 'INSTALL-LIBRE-OFFICE-GNOME'" "INSTALL-LIBRE-OFFICE-GNOME"
                    fi
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    if [[ $KDE_INSTALLED -eq 1 ]]; then
                        if [[ $MATE_INSTALLED -eq 1 || $GNOME_INSTALLED -eq 1 ]]; then
                            add_packagemanager "package_install 'gnumeric abiword abiword-plugins' 'INSTALL-GNUMERIC'" "INSTALL-GNUMERIC"
                        fi
                        add_packagemanager "package_install 'calligra' 'INSTALL-CALLIGRA'" "INSTALL-CALLIGRA"
                    else
                        add_packagemanager "package_install 'gnumeric abiword abiword-plugins' 'INSTALL-GNUMERIC'" "INSTALL-GNUMERIC"
                    fi
                    add_packagemanager "aur_package_install \"hunspell-$LANGUAGE_HS\" 'AUR-INSTALL-HUNSPELL'" "AUR-INSTALL-HUNSPELL"
                    add_packagemanager "aur_package_install \"aspell-$LANGUAGE_AS\" \"AUR-INSTALL-ASPELL-$LANGUAGE_AS\"" "AUR-INSTALL-ASPELL-$LANGUAGE_AS"
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    print_title "LATEX - https://wiki.archlinux.org/index.php/LaTeX"
                    add_packagemanager "package_install 'texlive-most' 'INSTALL-LATEX'" "INSTALL-LATEX"
                    add_packagemanager "aur_package_install 'texmaker' 'AUR-INSTALL-TEXMAKER'" "AUR-INSTALL-TEXMAKER"
                    if [[ $LANGUAGE == pt_BR ]]; then
                        add_packagemanager "aur_package_install 'abntex' 'AUR-INSTALL-ABNTEX'" "AUR-INSTALL-ABNTEX"
                    fi
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'calibre' 'INSTALL-CALIBRE'" "INSTALL-CALIBRE"
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'gcstar' 'INSTALL-GCSTAR'" "INSTALL-GCSTAR"
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'homebank' 'INSTALL-HOMEBANK'" "INSTALL-HOMEBANK"
                    ;;
                7)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'impressive' 'INSTALL-IMPRESSIVE'" "INSTALL-IMPRESSIVE"
                    ;;
                8)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'nitrotasks' 'AUR-INSTALL-NITROTASKS'" "AUR-INSTALL-NITROTASKS"
                    ;;
                9)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'ocrfeeder tesseract gocr' 'INSTALL-OCRFEEDER'" "INSTALL-OCRFEEDER"
                    add_packagemanager "aur_package_install \"aspell-$LANGUAGE_AS\" \"AUR-INSTALL-ASPELL-$LANGUAGE_AS\"" "AUR-INSTALL-ASPELL-$LANGUAGE_AS"
                    ;;
                10)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'xmind' 'AUR-INSTALL-XMIND'" "AUR-INSTALL-XMIND"
                    ;;
                11)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'zathura' 'INSTALL-ZATHURA'" "INSTALL-ZATHURA"
                    ;;
                "d")
                    OFFICE_APPS=( "${checklistsub[@]}" ) # Save Sub Menu Checklist
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
    is_breakable "$S_OPT" "d"
    done
}
#}}}
# -----------------------------------------------------------------------------
#SYSTEM TOOLS {{{
# USAGE      : install_system_apps
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_system_apps()
{
    # 5
    clear_sub
    while [[ 1 ]]; do
        print_title "SYSTEM TOOLS APPS"
        print_info "https://wiki.archlinux.org/index.php/GParted"
        print_info "Grsync: GTK GUI for rsync"
        print_info "Htop: Interactive process viewer"
        print_info "https://wiki.archlinux.org/index.php/VirtualBox"
        print_info "VirtualBox is a virtual PC emulator like VMware"
        print_info "https://wiki.archlinux.org/index.php/Webmin"
        print_info "Webmin runs as a service. Using webmin, you can administer other services and server configuration using a web browser, either from the server or remotely. "
        print_info "https://wiki.archlinux.org/index.php/Wine"
        print_info "Wine (originally an acronym for 'Wine Is Not an Emulator') is a compatibility layer capable of running Windows applications on several POSIX-compliant operating systems, such as Linux, Mac OSX, & BSD."
        clear_smenu
        submenu_item 1 "Gparted"    "" ""
        submenu_item 2 "Grsync"     "" ""
        submenu_item 3 "Htop"       "" ""
        submenu_item 4 "Virtualbox" "" ""
        submenu_item 5 "Webmin"     "" ""
        submenu_item 6 "WINE"       "" ""
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'gparted' 'INSTALL-GPARTED'" "INSTALL-GPARTED"
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'grsync' 'INSTALL-GRSYNC'" "INSTALL-GRSYNC"
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'htop' 'INSTALL-HTOP'" "INSTALL-HTOP"
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'virtualbox virtualbox-host-modules virtualbox-guest-iso' 'INSTALL-VIRTUALBOX'" "INSTALL-VIRTUALBOX"
                    add_packagemanager "aur_package_install 'virtualbox-ext-oracle' 'AUR-INSTALL-VIRTUALBOX-EXT-ORACLE'" "AUR-INSTALL-VIRTUALBOX-EXT-ORACLE"
                    add_module "vboxdrv" "MODULE-VIRTUALBOX"
                    add_packagemanager "systemctl enable vboxservice.service" "SYSTEMD-ENABLE-VIRTUALBOX"
                    add_packagemanager "add_user_2_group 'vboxusers'" "GROUPADD-VBOXUSERS"
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'webmin perl-net-ssleay' 'INSTALL-WEBMIN'" "INSTALL-WEBMIN"
                    add_packagemanager "systemctl enable webmin.service" "SYSTEMD-ENABLE-WEBMIN"
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'wine wine_gecko winetricks' 'INSTALL-WINE'" "INSTALL-WINE"
                    if [[ "$ARCHI" == "x86_64" ]]; then
                        if [[ "$VIDEO_CARD" -eq 1 ]]; then    # nVidia
                            add_packagemanager "package_install 'lib32-nvidia-utils' 'INSTALL-WINE-NVIDIA'" "INSTALL-WINE-NVIDIA"
                        elif [[ "$VIDEO_CARD" -eq 2 ]]; then  # Nouveau
                            add_packagemanager "package_install 'lib32-nouveau-dri' 'INSTALL-WINE-NOUVEAU'" "INSTALL-WINE-NOUVEAU"
                        elif [[ "$VIDEO_CARD" -eq 3 ]]; then  # Intel
                            add_packagemanager "package_install 'lib32-intel-dri' 'INSTALL-WINE-INTEL'" "INSTALL-WINE-INTEL"
                        elif [[ "$VIDEO_CARD" -eq 4 ]]; then  # ATI
                            add_packagemanager "package_install 'lib32-ati-dri' 'INSTALL-WINE-ATI'" "INSTALL-WINE-ATI"
                        fi
                        add_packagemanager "package_install 'lib32-alsa-lib lib32-openal lib32-mpg123 lib32-giflib lib32-libpng q4wine' 'INSTALL-WINE-ALSA'" "INSTALL-WINE-ALSA"
                    fi
                    ;;
                "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
    is_breakable "$S_OPT" "d"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL DE EXTRAS {{{
install_de_extras()
{
    # 11
    clear_sub
    while [[ 1 ]]; do
        print_title "Desktop Environments Extras"
        print_info $"GNOME Icons: awoken-icons faenza-icon-theme faenza-cupertino-icon-theme faience-icon-theme elementary-icons-bzr"
        print_info $"GTK Themes: gtk-theme-adwaita-cupertino gtk-theme-boomerang xfce-theme-blackbird xfce-theme-bluebird egtk-bzr xfce-theme-greybird light-themes orion-gtk-theme zukini-theme zukitwo-themes"
        clear_smenu
        submenu_item 1 "GNOME Icons" "" "$AUR"
        submenu_item 2 "GTK Themes"  "" "$AUR"
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    install_icons
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    install_gtk_themes
                    ;;
              "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL GTK THEMES {{{
# USAGE      : install_gtk_themes
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_gtk_themes() 
{ 
    # 11 sub 2
    clear_sub
    while [[ 1 ]]; do
        print_title "GTK2/GTK3 THEMES"
        clear_smenu
        submenu_item 1  "Adwaita Cupertino" "" ""
        submenu_item 2  "Boomerang" "" ""
        submenu_item 3  "Blackbird" "" ""
        submenu_item 4  "Bluebird" "" ""
        submenu_item 5  "eGTK" "" ""
        submenu_item 6  "Greybird" "" ""
        submenu_item 7  "Light" "aka Ambiance/Radiance" ""
        submenu_item 8  "Orion" "" ""
        submenu_item 9  "Zukini" "" ""
        submenu_item 10 "Zukitwo" "" ""
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'gtk-theme-adwaita-cupertino' 'AUR-INSTALL-GTK-THEMES-ADWAITA'" "AUR-INSTALL-GTK-THEMES-ADWAITA"
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'gtk-theme-boomerang' 'AUR-INSTALL-GTK-THEMES-BOOMERANG'" "AUR-INSTALL-GTK-THEMES-BOOMERANG"
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'xfce-theme-blackbird' 'AUR-INSTALL-GTK-THEMES-BLACKBIRD'" "AUR-INSTALL-GTK-THEMES-BLACKBIRD"
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'xfce-theme-bluebird' 'AUR-INSTALL-GTK-THEMES-BLUEBIRD'" "AUR-INSTALL-GTK-THEMES-BLUEBIRD"
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'egtk-bzr' 'AUR-INSTALL-GTK-THEMES-EGTK'" "AUR-INSTALL-GTK-THEMES-EGTK"
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'xfce-theme-greybird' 'AUR-INSTALL-GTK-THEMES-XFCE-GREYBIRD'" "AUR-INSTALL-GTK-THEMES-XFCE-GREYBIRD"
                    ;;
                7)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'light-themes' 'AUR-INSTALL-GTK-THEMES-LIGHT-THEMES'" "AUR-INSTALL-GTK-THEMES-LIGHT-THEMES"
                    ;;
                8)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'orion-gtk-theme' 'AUR-INSTALL-GTK-THEMES-ORION'" "AUR-INSTALL-GTK-THEMES-ORION"
                    ;;
                9)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'zukini-theme' 'AUR-INSTALL-GTK-THEMES-ZUKINI'" "AUR-INSTALL-GTK-THEMES-ZUKINI"
                    ;;
               10)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'zukitwo-themes' 'AUR-INSTALL-GTK-THEMES-ZUKITWO'" "AUR-INSTALL-GTK-THEMES-ZUKITWO"
                    ;;
              "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
} 
#}}}
# -----------------------------------------------------------------------------
# INSTALL ICONS {{{
# USAGE      : install_icons
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_icons() 
{ 
    # 11 sub 1
    clear_sub
    add_packagemanager "package_install 'gtk-update-icon-cache' 'INSTALL-GTK-ICONS'" "INSTALL-GTK-ICONS"
    while [[ 1 ]]; do
        print_title "GNOME ICONS"
        clear_smenu
        submenu_item 1 "Awoken" "" ""
        submenu_item 2 "Faenza" "" ""
        submenu_item 3 "Faenza-Cupertino" "" ""
        submenu_item 4 "Faience" "" ""
        submenu_item 5 "Elementary" "" ""
        submenu_item 6 "Nitrux" "" ""
        print_sm "D" 
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'awoken-icons' 'AUR-INSTALL-GNOME-ICONS-AWOKEN'" "AUR-INSTALL-GNOME-ICONS-AWOKEN"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/AwOken" "RUN-GTK-ICONS-1"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/AwOken-Dark" "RUN-GTK-ICONS-2"
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'faenza-icon-theme' 'AUR-INSTALL-GNOME-ICONS-FAENZA'" "AUR-INSTALL-GNOME-ICONS-FAENZA"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza" "RUN-GTK-ICONS-3"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Dark" "RUN-GTK-ICONS-4"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Darker" "RUN-GTK-ICONS-5"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Darkest" "RUN-GTK-ICONS-6"
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'faenza-cupertino-icon-theme' 'AUR-INSTALL-GNOME-ICONS-FEANZA-CUPERTINO'" "AUR-INSTALL-GNOME-ICONS-FEANZA-CUPERTINO"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino" "RUN-GTK-ICONS-7"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino-Dark" "RUN-GTK-ICONS-8"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino-Darker" "RUN-GTK-ICONS-9"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino-Darkest" "RUN-GTK-ICONS-10"
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'faience-icon-theme' 'AUR-INSTALL-GNOME-ICONS-FAIENCE'" "AUR-INSTALL-GNOME-ICONS-FAIENCE"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience" "RUN-GTK-ICONS-11"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience-Azur" "RUN-GTK-ICONS-12"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience-Claire" "RUN-GTK-ICONS-13"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience-Ocre" "RUN-GTK-ICONS-14"
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'elementary-icons-bzr' 'AUR-INSTALL-GNOME-ICONS-ELEMENTARY'" "AUR-INSTALL-GNOME-ICONS-ELEMENTARY"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary" "RUN-GTK-ICONS-15"
                    read_input_yn "Install also the elementary XFCE icons" 1
                    if [[ $YN_OPTION -eq 1 ]]; then
                        add_packagemanager "aur_package_install 'elementary-xfce-icons' 'AUR-INSTALL-GNOME-ICONS-ELEMENTARY-XFCE'" "AUR-INSTALL-GNOME-ICONS-ELEMENTARY-XFCE"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary-xfce" "RUN-GTK-ICONS-16"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary-xfce-dark" "RUN-GTK-ICONS-17"
                    fi
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'nitrux-icon-theme' 'AUR-INSTALL-GNOME-ICONS-NITRUX'" "AUR-INSTALL-GNOME-ICONS-NITRUX"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX" "RUN-GTK-ICONS-18"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-BTN" "RUN-GTK-ICONS-19"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-BTN-blufold" "RUN-GTK-ICONS-20"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-C" "RUN-GTK-ICONS-21"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-DRK" "RUN-GTK-ICONS-22"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-G" "RUN-GTK-ICONS-23"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-G-lightpnl" "RUN-GTK-ICONS-24"
                    ;;
              "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
} 
#}}}
# -----------------------------------------------------------------------------
# INSTALL GAMES {{{
# USAGE      : install_games 
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_games()
{
    # 10
    clear_sub
    clear_subsub
    while [[ 1 ]]; do
        print_title "GAMES - https://wiki.archlinux.org/index.php/Games"
        clear_smenu
        submenu_item 1  "Action|Adventure" "" ""
        submenu_item 2  "Arcade|Platformer" "" ""
        submenu_item 3  "Dungeon" "" ""
        submenu_item 4  "Emulators" "" ""
        submenu_item 5  "FPS" "" ""
        submenu_item 6  "MMO" "" ""
        submenu_item 7  "Puzzle" "" ""
        submenu_item 8  "RPG" "" ""
        submenu_item 9  "Racing" "" ""
        submenu_item 10 "Simulation" "" ""
        submenu_item 11 "Strategy" "" ""
        submenu_item 12 "Gnome" "" ""
        submenu_item 13 "KDE" "" ""
        submenu_item 14 "Misc" "" ""
        print_sm "D"
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #ACTION/ADVENTURE {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "ACTION AND ADVENTURE"
                        subsubmenu_item 1  "astromenace" "" ""
                        subsubmenu_item 2  "Counter-Strike 2D" "" "$AUR" 
                        subsubmenu_item 3  "Dead Cyborg Episode 1" "" "$AUR" 
                        subsubmenu_item 4  "M.A.R.S. Shooter" "" "$AUR" 
                        subsubmenu_item 5  "nikki" "" "$AUR" 
                        subsubmenu_item 6  "opentyrian-hg" "" "$AUR" 
                        subsubmenu_item 7  "Sonic Robot Blast 2" "" "$AUR" 
                        subsubmenu_item 8  "steelstorm" "" "$AUR" 
                        subsubmenu_item 9  "Yo Frankie!" "" "$AUR" 
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'astromenace' 'INSTALL-ASTROMENANCE'" "INSTALL-ASTROMENANCE"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'counter-strike-2d' 'AUR-INSTALL-COUNTER-STRIKE-2D'" "AUR-INSTALL-COUNTER-STRIKE-2D"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'dead-cyborg-episode1' 'AUR-INSTALL-DEAD-CYBORG-EP-1'" "AUR-INSTALL-DEAD-CYBORG-EP-1"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'mars-shooter' 'AUR-INSTALL-MARS-SHOOTER'" "AUR-INSTALL-MARS-SHOOTER"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'nikki' 'AUR-INSTALL-NIKKI'" "AUR-INSTALL-NIKKI"
                                    ;;
                                6)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'opentyrian-hg' 'AUR-INSTALL-OPENTYRIAN'" "AUR-INSTALL-OPENTYRIAN"
                                    ;;
                                7)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'srb2' 'AUR-INSTALL-SRB2" "AUR-INSTALL-SRB2"
                                    ;;
                                8)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'steelstorm' 'AUR-INSTALL-STEELSTORM'" "AUR-INSTALL-STEELSTORM"
                                    ;;
                                9)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'yofrankie' 'AUR-INSTALL-YOFRANKIE'" "AUR-INSTALL-YOFRANKIE"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #ARCADE/PLATFORMER {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "ARCADE AND PLATFORMER"
                        subsubmenu_item 1  "abuse" "" ""
                        subsubmenu_item 2  "Battle Tanks" "" ""
                        subsubmenu_item 3  "bomberclone" "" ""
                        subsubmenu_item 4  "Those Funny Funguloids" "" "$AUR" 
                        subsubmenu_item 5  "frogatto" "" ""
                        subsubmenu_item 6  "goonies" "" "$AUR" 
                        subsubmenu_item 7  "mari0" "" "$AUR" 
                        subsubmenu_item 8  "neverball" "" ""
                        subsubmenu_item 9  "opensonic" "" "$AUR" 
                        subsubmenu_item 10 "Robombs" "" "$AUR" 
                        subsubmenu_item 11 "Super Mario Chronicles" "" ""
                        subsubmenu_item 12 "xmoto" "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'abuse' 'INSTALL-ABUSE'" "INSTALL-ABUSE"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'btanks' 'INSTALL-BTANKS'" "INSTALL-BTANKS"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'bomberclone' 'INSTALL-BOMBERCLONE'" "INSTALL-BOMBERCLONE"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'funguloids' 'AUR-INSTALL-FUNGULOIDS'" "AUR-INSTALL-FUNGULOIDS"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'frogatto' 'INSTALL-FROGATTO'" "INSTALL-FROGATTO"
                                    ;;
                                6)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'goonies' 'AUR-INSTALL-GOONIES'" "AUR-INSTALL-GOONIES"
                                    ;;
                                7)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'mari0' 'AUR-INSTALL-MARI0'" "AUR-INSTALL-MARI0"
                                    ;;
                                8)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'neverball' 'INSTALL-NEVERBALL'" "INSTALL-NEVERBALL"
                                    ;;
                                9)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'opensonic' 'AUR-INSTALL-OPENSONIC'" "AUR-INSTALL-OPENSONIC"
                                    ;;
                                10)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'robombs_bin' 'AUR-INSTALL-ROBOMBS-BIN'" "AUR-INSTALL-ROBOMBS-BIN"
                                    ;;
                                11)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'smc' 'INSTALL-SMC'" "INSTALL-SMC"
                                    ;;
                                12)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'xmoto' 'INSTALL-XMOTO'" "INSTALL-XMOTO"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #DUNGEON {{{
                    while [[ 1 ]]
                    do
                        clear_ssmenu
                        print_title "DUNGEON"
                        subsubmenu_item 1  "adom" "" "$AUR"
                        subsubmenu_item 2  "Tales of MajEyal" "" "$AUR"
                        subsubmenu_item 3  "Lost Labyrinth" "" "$AUR"
                        subsubmenu_item 4  "S.C.O.U.R.G.E." "" "$AUR"
                        subsubmenu_item 5  "Stone-Soupe" "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'adom' 'AUR-INSTALL-ADOM'" "AUR-INSTALL-ADOM"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'tome4' 'AUR-INSTALL-TOME4'" "AUR-INSTALL-TOME4"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'lostlabyrinth' 'AUR-INSTALL-LOST-LABYRINTH'" "AUR-INSTALL-LOST-LABYRINTH"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'scourge' 'AUR-INSTALL-SCOURGE'" "AUR-INSTALL-SCOURGE"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'stone-soup' 'AUR-INSTALL-STONE-SOUP'" "AUR-INSTALL-STONE-SOUP"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #EMULATORS {{{
                    while [[ 1 ]]
                    do
                        clear_ssmenu
                        print_title "EMULATORS"
                        subsubmenu_item 1  "BSNES" "" "$AUR"
                        subsubmenu_item 2  "Desmume-svn" "" "$AUR"
                        subsubmenu_item 3  "Dolphin" "" "$AUR"
                        subsubmenu_item 4  "Epsxe" "" "$AUR"
                        subsubmenu_item 5  "Project 64" "" "$AUR"
                        subsubmenu_item 6  "Visual Boy Advanced" "" "$AUR"
                        subsubmenu_item 7  "wxmupen64plus" "" "$AUR"
                        subsubmenu_item 8  "zsnes" "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'bsnes' 'AUR-INSTALL-BSMES'" "AUR-INSTALL-BSMES"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'desmume-svn' 'AUR-INSTALL-DESMUME'" "AUR-INSTALL-DESMUME"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'dolphin-emu' 'AUR-INSTALL-DOLPHIN'" "AUR-INSTALL-DOLPHIN"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'epsxe' 'AUR-INSTALL-EPSXE'" "AUR-INSTALL-EPSXE"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'project64' 'AUR-INSTALL-PROJECT-64'" "AUR-INSTALL-PROJECT-64"
                                    ;;
                                6)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'vba-m-gtk-svn' 'AUR-INSTALL-VBA'" "AUR-INSTALL-VBA"
                                    ;;
                                7)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'wxmupen64plus' 'AUR-INSTALL-WXMUPEN64PLUS'" "AUR-INSTALL-WXMUPEN64PLUS"
                                    ;;
                                8)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'zsnes' 'INSTALL-ZSNES'" "INSTALL-ZSNES"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #FPS {{{
                    while [[ 1 ]]
                    do
                        clear_ssmenu
                        print_title "FPS"
                        subsubmenu_item 1  "alienarena" "" ""
                        subsubmenu_item 2  "warsow" "" ""
                        subsubmenu_item 3  "Wolfenstein: Enemy Territory" "" "$AUR" 
                        subsubmenu_item 4  "World of Padman" "" "$AUR" 
                        subsubmenu_item 5  "xonotic" "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'alienarena' 'INSTALL-ALIENARENA'" "INSTALL-ALIENARENA"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'warsow' 'INSTALL-WARSOW'" "INSTALL-WARSOW"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'enemy-territory' 'AUR-INSTALL-ENEMY-TERRITORY'" "AUR-INSTALL-ENEMY-TERRITORY"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'worldofpadman' 'AUR-INSTALL-WORLD-OF-PADMAN'" "AUR-INSTALL-WORLD-OF-PADMAN"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'xonotic' 'INSTALL-XONOTIC'" "INSTALL-XONOTIC"
                                    ;;

                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #MMO {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "MMO"
                        subsubmenu_item 1  "Heroes of Newerth" "" "$AUR" 
                        subsubmenu_item 2  "Manaplus" "" "$AUR" 
                        subsubmenu_item 3  "Runescape" "" "$AUR" 
                        subsubmenu_item 4  "Savage 2" "" "$AUR" 
                        subsubmenu_item 5  "Spiral Knights" "" "$AUR" 
                        subsubmenu_item 6  "Wakfu" "" "$AUR" 
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'hon' 'AUR-INSTALL-HON'" "AUR-INSTALL-HON"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'manaplus' 'AUR-INSTALL-MANAPLUS'" "AUR-INSTALL-MANAPLUS"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'unix-runescape-client' 'AUR-INSTALL-RUNESCAPE'" "AUR-INSTALL-RUNESCAPE"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'savage2' 'AUR-INSTALL-SAVAGE-2'" "AUR-INSTALL-SAVAGE-2"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'spiral-knights' 'AUR-INSTALL-SPIRAL-KNIGHTS'" "AUR-INSTALL-SPIRAL-KNIGHTS"
                                    ;;
                                6)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'wakfu' 'AUR-INSTALL-WAKFU'" "AUR-INSTALL-WAKFU"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                7)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #PUZZLE {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "PUZZLE"
                        subsubmenu_item 1  "frozen-bubble" "" ""
                        subsubmenu_item 2  "Numptyphysics" "" "$AUR" 
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'frozen-bubble' 'INSTALL-FROZEN-BUBBLE'" "INSTALL-FROZEN-BUBBLE"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'numptyphysics-svn' 'AUR-INSTALL-NUMPTYPHYSICS'" "AUR-INSTALL-NUMPTYPHYSICS"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                8)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #RPG {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "RPG"
                        subsubmenu_item 1  "Ardentryst" "" "$AUR" 
                        subsubmenu_item 2  "Flare RPG" "" "$AUR" 
                        subsubmenu_item 3  "Freedroid RPG" "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'ardentryst' 'AUR-INSTALL-ARDENTRYST'" "AUR-INSTALL-ARDENTRYST"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'flare-rpg' 'AUR-INSTALL-FLARE-RPG'" "AUR-INSTALL-FLARE-RPG"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'freedroidrpg' 'INSTALL-FREEDROUDRPG'" "INSTALL-FREEDROUDRPG"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                9)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #RACING {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "RACING"
                        subsubmenu_item 1  "Maniadrive" "" "$AUR" 
                        subsubmenu_item 2  "Death Rally" "" "$AUR" 
                        subsubmenu_item 3  "Stun Trally" "" "$AUR" 
                        subsubmenu_item 4  "Supertuxkart" "" ""
                        subsubmenu_item 5  "Speed Dreams" "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'maniadrive' 'AUR-INSTALL-MANIADRIVE'" "AUR-INSTALL-MANIADRIVE"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'death-rally' 'AUR-INSTALL-DEATH-RALLY'" "AUR-INSTALL-DEATH-RALLY"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'stuntrally' 'AUR-INSTALL-STUNTRALLY'" "AUR-INSTALL-STUNTRALLY"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'supertuxkart' 'INSTALL-SUPTERTUXKART'" "INSTALL-SUPTERTUXKART"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'speed-dreams' 'INSTALL-SPEED-DREAMS'" "INSTALL-SPEED-DREAMS"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                10)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #SIMULATION {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "SIMULATION"
                        subsubmenu_item 1  "simutrans" "" ""
                        subsubmenu_item 2  "Theme Hospital" "" "$AUR" 
                        subsubmenu_item 3  "openttd" "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'simutrans' 'INSTALL-SIMUTRANS'" "INSTALL-SIMUTRANS"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'corsix-th' 'AUR-INSTALL-CORSIX-TH'" "AUR-INSTALL-CORSIX-TH"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'openttd' 'INSTALL-OPENTTD'" "INSTALL-OPENTTD"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                11)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #STRATEGY {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "STRATEGY"
                        subsubmenu_item 1  "0ad" "" ""
                        subsubmenu_item 2  "hedgewars" "" ""
                        subsubmenu_item 3  "megaglest" "" ""
                        subsubmenu_item 4  "unknown-horizons" "" "$AUR" 
                        subsubmenu_item 5  "warzone2100" "" ""
                        subsubmenu_item 6  "wesnoth" "" ""
                        subsubmenu_item 7  "zod" "" "$AUR" 
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install '0ad' 'INSTALL-0AD'" "INSTALL-0AD"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'hedgewars' 'INSTALL-HEDGEWARS'" "INSTALL-HEDGEWARS"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'megaglest' 'INSTALL-MEGAGLEST'" "INSTALL-MEGAGLEST"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'unknow-horizons' 'INSTALL-UNKNOW-HORIZONS'" "INSTALL-UNKNOW-HORIZONS"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'warzone2100' 'INSTALL-WARZONE2100'" "INSTALL-WARZONE2100"
                                    ;;
                                6)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'wesnoth' 'INSTALL-WESNOTH'" "INSTALL-WESNOTH"
                                    ;;
                                7)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'commander-zod' 'AUR-INSTALL-COMMANDER-ZOD'" "AUR-INSTALL-COMMANDER-ZOD"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                12)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'gnome-games' 'INSTALL-GNOME-GAMES'" "INSTALL-GNOME-GAMES"
                    ;;
                13)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'kdegames' 'INSTALL-KDE-GAMES'" "INSTALL-KDE-GAMES"
                    ;;
                14)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'torcs pingus scorched3d aisleriot' 'INSTALL-MISC-GAMES'" "INSTALL-MISC-GAMES"
                    ;;
               "d")
                    break
                    ;;
                 *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
    is_breakable "$S_OPT" "d"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL WEB SERVER {{{
# USAGE      : install_web_server
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_web_server()
{
    # 11
    #@FIX
    
        create_sites_folder()
        {
           # copy_file "from" "to" "$LINENO"
           # copy_dir "from" "to" "$LINENO"
        
            [[ ! -f  /etc/httpd/conf/extra/httpd-userdir.conf.aui ]] && cp -v /etc/httpd/conf/extra/httpd-userdir.conf /etc/httpd/conf/extra/httpd-userdir.conf.aui
            sed -i 's/public_html/Sites/g' /etc/httpd/conf/extra/httpd-userdir.conf
            if [[ "$RUN_AUR_ROOT" -eq 1 ]]; then
                make_dir "/home/$USERNAME/Sites" "$LINENO"  
                chmod o+x /home/$USERNAME/ && chmod -R o+x /home/$USERNAME/Sites
            else
                su - $USERNAME -c "mkdir -p ~/Sites"
                su - $USERNAME -c "chmod o+x ~/ && chmod -R o+x ~/Sites"
            fi
            print_line
            echo "The folder \"Sites\" has been created in your home"
            echo "You can access your projects at \"http://localhost/~username\""
            pause_function "$LINENO"
        }
        print_title "WEB SERVER - https://wiki.archlinux.org/index.php/LAMP|LAPP"
        echo "1) LAMP - APACHE, MYSQL & PHP + ADMINER"
        echo "2) LAPP - APACHE, POSTGRESQL & PHP + ADMINER"
        echo ""
        echo "S) Skip"
        echo ""

    MY_OPTIONS+=" s"
    read_input_options "$MY_OPTIONS"
    for M_OPT in ${OPTIONS[@]}; do
        case "$M_OPT" in
            1)
                WEBSERVER=1
                add_packagemanager "package_install 'apache mysql php php-apache php-mcrypt php-gd' 'INSTALL-WEB-SERVER-1'" "INSTALL-WEB-SERVER-1"
                add_packagemanager "aur_package_install 'adminer' 'AUR-INSTALL-ADMINER'" "AUR-INSTALL-ADMINER" # if you add something, change this name
                add_packagemanager "systemctl enable httpd.service mysqld.service" "SYSTEMD-ENABLE-WEBSERVER-1"
                add_packagemanager "systemctl start mysqld.service" "SYSTEMD-START-MYSQL"
                #echo "Enter your new mysql root account password"
                #/usr/bin/mysqladmin -u root password
                /usr/bin/mysql_secure_installation
                #CONFIGURE HTTPD.CONF {{{
                if [[ ! -f  /etc/httpd/conf/httpd.conf.aui ]]; then
                    cp -v /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.aui
                    echo -e '\n# adminer configuration\nInclude conf/extra/httpd-adminer.conf' >> /etc/httpd/conf/httpd.conf
                    echo -e 'application/x-httpd-php5		php php5' >> /etc/httpd/conf/mime.types
                    sed -i '/LoadModule dir_module modules\/mod_dir.so/a\LoadModule php5_module modules\/libphp5.so' /etc/httpd/conf/httpd.conf
                    echo -e '\n# Use for PHP 5.x:\nInclude conf/extra/php5_module.conf\n\nAddHandler php5-script php' >> /etc/httpd/conf/httpd.conf
                    sed -i 's/DirectoryIndex\ index.html/DirectoryIndex\ index.html\ index.php/g' /etc/httpd/conf/httpd.conf
                fi
                #}}}
                #CONFIGURE PHP.INI {{{
                if [[ -f  /etc/php/php.ini.pacnew ]]; then
                    mv -v /etc/php/php.ini /etc/php/php.ini.pacold
                    mv -v /etc/php/php.ini.pacnew /etc/php/php.ini
                    rm -v /etc/php/php.ini.aui
                fi
                [[ -f /etc/php/php.ini.aui ]] && echo "/etc/php/php.ini.aui || cp -v /etc/php/php.ini /etc/php/php.ini.aui";
                sed -i '/mysqli.so/s/^;//' /etc/php/php.ini
                sed -i '/mysql.so/s/^;//' /etc/php/php.ini
                sed -i '/mcrypt.so/s/^;//' /etc/php/php.ini
                sed -i '/gd.so/s/^;//' /etc/php/php.ini
                sed -i '/display_errors=/s/off/on/' /etc/php/php.ini
                sed -i '/skip-networking/s/^/#/' /etc/mysql/my.cnf
                #}}}
                CURRENT_STATUS=1
                create_sites_folder
                ;;
            2)
                WEBSERVER=2
                add_packagemanager "package_install 'apache postgresql php php-apache php-pgsql php-gd' 'INSTALL-WEB-SERVER-2'" "INSTALL-WEB-SERVER-2"
                add_packagemanager "aur_package_install 'adminer' 'AUR-INSTALL-ADMINER'" "AUR-INSTALL-ADMINER" # if you add something, change this name
                chown -R postgres:postgres /var/lib/postgres/
                echo "Enter your new postgres account password:"
                passwd postgres
                if [[ ! -d /var/lib/postgres/data ]]; then
                    echo "Enter your postgres account password:"
                    # @FIX Do we want to do this as Root?
                    if [[ "$RUN_AUR_ROOT" -eq 1 ]]; then
                        initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'
                    else
                        su - postgres -c "initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'"
                    fi
                fi
                sed -i '/PGROOT/s/^#//' /etc/conf.d/postgresql
                add_packagemanager "systemctl enable httpd.service postgresql.service" "SYSTEMD-ENABLE-WEBSERVER-2"
                add_packagemanager "systemctl start postgresql.service" "SYSTEMD-START-POSTGRESQL"
                #CONFIGURE HTTPD.CONF {{{
                if [[ ! -f  /etc/httpd/conf/httpd.conf.aui ]]; then
                    cp -v /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.aui
                    echo -e '\n# adminer configuration\nInclude conf/extra/httpd-adminer.conf' >> /etc/httpd/conf/httpd.conf
                    echo -e 'application/x-httpd-php5		php php5' >> /etc/httpd/conf/mime.types
                    sed -i '/LoadModule dir_module modules\/mod_dir.so/a\LoadModule php5_module modules\/libphp5.so' /etc/httpd/conf/httpd.conf
                    echo -e '\n# Use for PHP 5.x:\nInclude conf/extra/php5_module.conf\n\nAddHandler php5-script php' >> /etc/httpd/conf/httpd.conf
                    sed -i 's/DirectoryIndex\ index.html/DirectoryIndex\ index.html\ index.php/g' /etc/httpd/conf/httpd.conf
                fi
                #}}}
                #CONFIGURE PHP.INI {{{
                if [[ -f  /etc/php/php.ini.pacnew ]]; then
                    mv -v /etc/php/php.ini /etc/php/php.ini.pacold
                    mv -v /etc/php/php.ini.pacnew /etc/php/php.ini
                    rm -v /etc/php/php.ini.aui
                fi
                [[ -f /etc/php/php.ini.aui ]] && echo "/etc/php/php.ini.aui || cp -v /etc/php/php.ini /etc/php/php.ini.aui";
                sed -i '/pgsql.so/s/^;//' /etc/php/php.ini
                sed -i '/mcrypt.so/s/^;//' /etc/php/php.ini
                sed -i '/gd.so/s/^;//' /etc/php/php.ini
                sed -i '/display_errors=/s/off/on/' /etc/php/php.ini
                #}}}
                CURRENT_STATUS=1
                create_sites_folder
                ;;
        esac
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL FONTS {{{
# USAGE      : install_fonts
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_fonts()
{
    # 12
    clear_sub
    while [[ 1 ]]; do
        print_title "FONTS - https://wiki.archlinux.org/index.php/Fonts"
        clear_smenu
        submenu_item 1 "ttf-dejavu" "" ""
        submenu_item 2 "ttf-google-webfonts" "Note: Removes: ttf-droid ttf-roboto ttf-ubuntu-font-family" "$AUR"
        submenu_item 3 "ttf-funfonts" "" ""
        submenu_item 4 "ttf-kochi-substitute" "" "$AUR"
        submenu_item 5 "ttf-liberation" "" ""
        submenu_item 6 "ttf-ms-fonts" "" ""
        submenu_item 7 "ttf-vista-fonts" "" ""
        submenu_item 8 "wqy-microhei" "Chinese/Japanese/Korean Support" "$AUR"
        print_sm "D"
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'ttf-dejavu' 'INSTALL-TTF-DEJAVU'" "INSTALL-TTF-DEJAVU"
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_remove 'ttf-droid ttf-roboto ttf-ubuntu-font-family'" "REMOVE-GOOGLE-WEBFONTS"
                    add_packagemanager "aur_package_install 'ttf-google-webfonts' 'AUR-INSTALL-GOOGLE-WEBFONTS'" "AUR-INSTALL-GOOGLE-WEBFONTS"
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'ttf-funfonts' 'AUR-INSTALL-FUN-FONTS'" "AUR-INSTALL-FUN-FONTS"
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'ttf-kochi-substitute' 'AUR-INSTALL-KOCHI-FONTS'" "AUR-INSTALL-KOCHI-FONTS"
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'ttf-liberation' 'INSTALL-TTF-LIBERATION'" "INSTALL-TTF-LIBERATION"
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'ttf-ms-fonts' 'AUR-INSTALL-MS-FONTS'" "AUR-INSTALL-MS-FONTS"
                    ;;
                7)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'ttf-vista-fonts' 'AUR-INSTALL-VISTA-FONTS'" "AUR-INSTALL-VISTA-FONTS"
                    ;;
                8)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'wqy-microhei' 'AUR-INSTALL-WQY-FONTS'" "AUR-INSTALL-WQY-FONTS"
                    ;;
                "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
    is_breakable "$S_OPT" "d"
    done
}
#}}}
# -----------------------------------------------------------------------------
#CLEAN ORPHAN PACKAGES {{{
# USAGE      : clean_orphan_packages
# DESCRIPTION:
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
clean_orphan_packages()
{
    # 14
    print_title "CLEAN ORPHAN PACKAGES"
    CONFIG_ORPHAN=1
}
#}}}
# -----------------------------------------------------------------------------
# GET NETWORKMANAGER/WICD {{{
# USAGE      : get_network_manager
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_network_manager()
{
    print_title "NETWORK MANAGER"
    print_info $"NETWORKMANAGER - https://wiki.archlinux.org/index.php/Networkmanager"
    print_info $"NetworkManager is a program for providing detection and configuration for systems to automatically connect to network. NetworkManager's functionality can be useful for both wireless and wired networks."
    print_info $"WICD - https://wiki.archlinux.org/index.php/Wicd"
    print_info $"Wicd is a network connection manager that can manage wireless and wired interfaces, similar and an alternative to NetworkManager."
    SYSTEM_TYPES=("Networkmanager" "Wicd" "NONE");
    PS3="$prompt1"
    echo -e "Select a Boot BIOS System Type:\n"
    select OPT in "${SYSTEM_TYPES[@]}"; do
        case "$REPLY" in
            1)
                NETWORK_MANAGER="networkmanager"
                break
                ;;
            2)
                NETWORK_MANAGER="wicd"
                break
                ;;
            3)
                break
                ;;
           *)
                invalid_option "$REPLY"
                ;;
        esac
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL NETWORKMANAGER/WICD {{{
# USAGE      : install_network_manager
# DESCRIPTION: Install Network Manager
# NOTES      :
# AUTHOR     : helmuthdu and Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_network_manager()
{
    # 1
    # @FIX use 
    get_network_manager
    if [[ "$NETWORK_MANAGER" == "networkmanager" ]]; then
        if [[ $KDE_INSTALLED -eq 1 ]]; then
            add_packagemanager "package_install 'networkmanager kdeplasma-applets-networkmanagement' 'INSTALL-NETWORKMANAGER-KDE'" "INSTALL-NETWORKMANAGER-KDE"
            if [[ $MATE_INSTALLED -eq 1 ]]; then
                add_packagemanager "package_install 'network-manager-applet' 'INSTALL-NETWORKMANAGER-APPLET'" "INSTALL-NETWORKMANAGER-APPLET"
            fi
        else
            add_packagemanager "package_install 'networkmanager network-manager-applet' 'INSTALL-NETWORKMANAGER'" "INSTALL-NETWORKMANAGER"
        fi
        add_packagemanager "package_install 'networkmanager-dispatcher-ntpd' 'INSTALL-NETWORKMANAGER-CORE'" "INSTALL-NETWORKMANAGER-CORE"
        add_user_group "networkmanager"
        # Network Management daemon
        # Application development toolkit for controlling system-wide privileges
        add_packagemanager "systemctl enable NetworkManager.service polkitd.service" "SYSTEMD-ENABLE-NETWORKMANAGER"
        add_packagemanager "add_user_2_group 'networkmanager'" "GROUPADD-NETWORKMANAGER"
    elif [[ "$NETWORK_MANAGER" == "wicd" ]]; then
        if [[ $KDE_INSTALLED -eq 1 ]]; then
            add_packagemanager "aur_package_install 'wicd wicd-kde' 'AUR-INSTALL-WICD-KDE'" "AUR-INSTALL-WICD-KDE"
            if [[ $MATE_INSTALLED -eq 1 ]]; then
                add_packagemanager "package_install 'wicd wicd-gtk' 'INSTALL-WICD-GTK'" "INSTALL-WICD-GTK"
            fi
        else
            add_packagemanager "package_install 'wicd wicd-gtk' 'INSTALL-GTK'" "INSTALL-GTK"
        fi
        # Network Management daemon
        add_packagemanager "systemctl enable wicd.service" "SYSTEMD-ENABLE-WICD"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL USB 3G MODEM {{{
# USAGE      : install_usb_modem
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_usb_modem()
{
    # 1
    print_title "USB 3G MODEM - https://wiki.archlinux.org/index.php/USB_3G_Modem"
    print_info $"A number of mobile telephone networks around the world offer mobile internet connections over UMTS (or EDGE or GSM) using a portable USB modem device."
    read_input_yn "Install usb 3G modem support" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        add_packagemanager "package_install 'usbutils usb_modeswitch modemmanager' 'INSTALL-USB-3G-MODEM'" "INSTALL-USB-3G-MODEM"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL ACCESSORIES APPS {{{
# USAGE      : install_accessories_apps
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_accessories_apps()
{
    # 2
    checklistsub=( "${ACCESSORIES_APPS[@]}" )
    while [[ 1 ]]; do
        print_title "ACCESSORIES APPS"
        clear_smenu
        submenu_item 1  "Cairo" "" "$AUR"
        submenu_item 2  "Conky + CONKY-colors" "" "$AUR"
        submenu_item 3  "Deepin Scrot" "" "$AUR"
        submenu_item 4  "Dockbarx" "" "$AUR"
        submenu_item 5  "Docky" "" "$AUR"
        submenu_item 6  "Speedcrunch or galculator" "Depending on DE" "$AUR"
        submenu_item 7  "Gnome Pie" "" "$AUR"
        submenu_item 8  "Guake" "Nice Terminal Popup F12" ""
        submenu_item 9  "Kupfer" "" "$AUR"
        submenu_item 10 "Pyrenamer" "" "$AUR"
        submenu_item 11 "Shutter" "" "$AUR"
        submenu_item 12 "Synapse" "" "$AUR"
        submenu_item 13 "Terminator" "" ""
        submenu_item 14 "Zim" "" ""
        submenu_item 15 "Revelation" "" ""
        print_sm "D"
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'cairo-dock-bzr cairo-dock-plugins-bzr' 'AUR-INSTALL-CAIRO'" "AUR-INSTALL-CAIRO"
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'conky-lua conky-colors' 'AUR-INSTALL-CONKY'" "AUR-INSTALL-CONKY"
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'deepin-scrot-git' 'AUR-INSTALL-DEEPIN-SCROT'" "AUR-INSTALL-DEEPIN-SCROT"
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'dockbarx dockbarx-shinybar-theme' 'AUR-INSTALL-DOCKY'" "AUR-INSTALL-DOCKY"
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'docky' 'INSTALL-DOCKY'" "INSTALL-DOCKY"
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    if [[ $KDE_INSTALLED -eq 1 ]]; then
                        if [[ $MATE_INSTALLED -eq 1 ]]; then
                            add_packagemanager "aur_package_install 'galculator' 'AUR-INSTALL-GALCULATOR'" "AUR-INSTALL-GALCULATOR"
                        fi
                        add_packagemanager "aur_package_install 'speedcrunch' 'AUR-INSTALL-SPEEDCRUNCH'" "AUR-INSTALL-SPEEDCRUNCH"
                    else
                        add_packagemanager "aur_package_install 'galculator' 'AUR-INSTALL-GALGULATOR'" "AUR-INSTALL-GALGULATOR"
                    fi
                    ;;
                7)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'gnome-pie' 'AUR-INSTALL-GNOME-PIE'" "AUR-INSTALL-GNOME-PIE"
                    ;;
                8)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'guake' 'INSTALL-GUAKE'" "INSTALL-GUAKE"
                    ;;
                9)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'kupfer' 'AUR-INSTALL-KUPFER'" "AUR-INSTALL-KUPFER"
                    ;;
                10)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'pyrenamer' 'AUR-INSTALL-PYRENAMER'" "AUR-INSTALL-PYRENAMER"
                    ;;
                11)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'shutter' 'AUR-INSTALL-SHUTTER'" "AUR-INSTALL-SHUTTER"
                    ;;
                12)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'zeitgeist' 'INSTALL-ZEITGEIST'" "INSTALL-ZEITGEIST"
                    add_packagemanager "aur_package_install 'libzeitgeist zeitgeist-datahub synapse' 'AUR-INSTALL-ZEITGEIST'" "AUR-INSTALL-ZEITGEIST"
                    ;;
                13)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'terminator' 'INSTALL-TERMINATOR'" "INSTALL-TERMINATOR"
                    add_packagemanager "aur_package_install 'python-keybinder' 'AUR-INSTALL-TERMINATOR'" "AUR-INSTALL-TERMINATOR"
                    ;;
                14)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'zim' 'INSTALL-ZIM'" "INSTALL-ZIM"
                    ;;
                15)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'revelation' 'AUR-INSTALL-REVELATION'" "AUR-INSTALL-REVELATION"
                    ;;
                "d")
                    ACCESSORIES_APPS=( "${checklistsub[@]}" ) # Save Sub Menu Checklist
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL DEVELOPEMENT APPS {{{
# USAGE      : install_development_apps
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_development_apps()
{
    # 3
    clear_subsub
    checklistsub=( "${DEVELOPMENT_APPS[@]}" )
    while [[ 1 ]]; do
        print_title "DEVELOPMENT APPS"
        clear_smenu
        submenu_item 1  "Qt and Creator" "" ""
        submenu_item 2  "Wt" "[Witty]" ""
        submenu_item 3  "MySQL and Workbench" "" "$AUR"
        submenu_item 4  "aptana-studio" "" "$AUR"
        submenu_item 5  "bluefish" "" ""
        submenu_item 6  "eclipse" "" ""
        submenu_item 7  "emacs" "" ""
        submenu_item 8  "gvim" "" ""
        submenu_item 9  "geany" "" ""
        submenu_item 10 "IntelliJ IDEA" "" ""
        submenu_item 11 "kdevelop" "" ""
        submenu_item 12 "netbeans" "" ""
        submenu_item 13 "Oracle Java" "" "$AUR"
        submenu_item 14 "Sublime Text 2" "" "$AUR"
        submenu_item 15 "Debugger Tools" "" ""
        submenu_item 16 "meld" "" ""
        submenu_item 17 "RabbitVCS" "" "$AUR"
        submenu_item 18 "astyle" "" ""
        submenu_item 19 "putty" "" ""
        submenu_item 20 "Utilities" "" ""
        print_sm "D"
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                 1)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'qt qtcreator qt-doc' 'INSTALL-QT'" "INSTALL-QT"
                    add_packagemanager "mkdir -p /home/\$USERNAME/.config/Nokia/qtcreator/styles" "RUN-QT-1"
                    add_packagemanager "curl -o monokai.xml http://angrycoding.googlecode.com/svn/branches/qt-creator-monokai-theme/monokai.xml" "RUN-QT-2"
                    add_packagemanager "mv monokai.xml /home/\$USERNAME/.config/Nokia/qtcreator/styles/" "RUN-QT-3"
                    add_packagemanager "chown -R \$USERNAME:\$USERNAME /home/\$USERNAME/.config" "RUN-QT-4"
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'wt boost boost-build sqlite libharu graphicsmagick git-core mercurial' 'INSTALL-WT'" "INSTALL-WT"
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'mysql mysql-workbench' 'AUR-INSTALL-MYSQL-WORKBENCH'" "AUR-INSTALL-MYSQL-WORKBENCH"
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'aptana-studio' 'AUR-INSTALL-APTANA-STUDIO'" "AUR-INSTALL-APTANA-STUDIO"
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'bluefish' 'INSTALL-BLUEFISH'" "INSTALL-BLUEFISH"
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #ECLIPSE {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "ECLIPSE - https://wiki.archlinux.org/index.php/Eclipse"
                        print_info $"Eclipse is an open source community project, which aims to provide a universal development platform."
                        # @FIX
                        echo ""
                        subsubmenu_item 1  "Eclipse IDE" "" ""
                        subsubmenu_item 2  "Eclipse IDE for C/C++ Developers" "" ""
                        subsubmenu_item 3  "Android Development Tools for Eclipse" "" "$AUR" 
                        subsubmenu_item 4  "Web Development Tools for Eclipse" "" "$AUR" 
                        subsubmenu_item 5  "PHP Development Tools for Eclipse" "" "$AUR" 
                        subsubmenu_item 6  "Python Development Tools for Eclipse" "" "$AUR" 
                        subsubmenu_item 7  "Aptana Studio plugin for Eclipse" "" "$AUR" 
                        subsubmenu_item 8  "Vim-like editing plugin for Eclipse" "" "$AUR" 
                        subsubmenu_item 9  "Git support plugin for Eclipse" "" "$AUR" 
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'eclipse' 'INSTALL-ECLIPSE'" "INSTALL-ECLIPSE"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'eclipse-cdt' 'INSTALL-ECLIPSE-CDT'" "INSTALL-ECLIPSE-CDT"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'eclipse-android android-apktool android-sdk android-sdk-platform-tools android-udev' 'AUR-INSTALL-ECLIPSE-ANDROID'" "AUR-INSTALL-ECLIPSE-ANDROID"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'eclipse-wtp-wst' 'AUR-INSTALL-ECLIPSE-WTP'" "AUR-INSTALL-ECLIPSE-WTP"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'eclipse-pdt' 'AUR-INSTALL-ECLIPSE-PDT'" "AUR-INSTALL-ECLIPSE-PDT"
                                    ;;
                                6)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'eclipse-pydev' 'AUR-INSTALL-ECLIPSE-PYDEV'" "AUR-INSTALL-ECLIPSE-PYDEV"
                                    ;;
                                7)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'eclipse-aptana' 'AUR-INSTALL-ECLIPSE-APTANA'" "AUR-INSTALL-ECLIPSE-APTANA"
                                    ;;
                                8)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'eclipse-vrapper' 'AUR-INSTALL-ECLIPSE-VRAPPER'" "AUR-INSTALL-ECLIPSE-VRAPPER"
                                    ;;
                                9)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'eclipse-egit' 'AUR-INSTALL-ECLIPSE-EGIT'" "AUR-INSTALL-ECLIPSE-EGIT"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                7)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'emacs' 'INSTALL-EMACS'" "INSTALL-EMACS"
                    ;;
                8)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_remove 'vim'" "REMOVE-GVIM"
                    add_packagemanager "package_install 'gvim ctags ack ttf-liberation' 'INSTALL-VIM'" "INSTALL-VIM"
                    add_packagemanager "aur_package_install 'discount' 'AUR-INSTALL-DISCOUNT'" "AUR-INSTALL-DISCOUNT"
                    ;;
                9)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'geany' 'INSTALL-GEANY'" "INSTALL-GEANY"
                    ;;
               10)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'intellij-idea-community-edition' 'INSTALL-INTELLIJ'" "INSTALL-INTELLIJ"
                    ;;
               11)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'kdevelop' 'INSTALL-KDEVELOP'" "INSTALL-KDEVELOP"
                    ;;
               12)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'netbeans' 'INSTALL-NETBEANS'" "INSTALL-NETBEANS"
                    ;;
               13)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_remove 'jre7-openjdk jdk7-openjdk'" "REMOVE-JDK"
                    add_packagemanager "aur_package_install 'jdk' 'AUR-INSTALL-JDK'" "AUR-INSTALL-JDK"
                    ;;
               14)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'sublime-text' 'AUR-INSTALL-SUBLIME'" "AUR-INSTALL-SUBLIME"
                    ;;
               15)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'valgrind gdb splint tidyhtml python2-pyflakes jslint' 'AUR-INSTALL-DEBUGGER-TOOLS'" "AUR-INSTALL-DEBUGGER-TOOLS"
                    ;;
               16)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'meld' 'INSTALL-MELD'" "INSTALL-MELD"
                    ;;
               17)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'rabbitvcs' 'AUR-INSTALL-RABBITVCS'" "AUR-INSTALL-RABBITVCS"
                    # @FIX check what is to be installed
                    if check_package "nautilus" ; then
                        add_packagemanager "aur_package_install 'rabbitvcs-nautilus' 'AUR-INSTALL-RABBITVCS-NAUTILUS'" "AUR-INSTALL-RABBITVCS-NAUTILUS"
                    elif check_package "thunar" ; then
                        add_packagemanager "aur_package_install 'rabbitvcs-thunar' 'AUR-INSTALL-RABBITVCS-THUNAR'" "AUR-INSTALL-RABBITVCS-THUNAR"
                    else
                        add_packagemanager "aur_package_install 'rabbitvcs-cli' 'AUR-INSTALL-RABBITVCS-CLI'" "AUR-INSTALL-RABBITVCS-CLI"
                    fi
                    ;;
               18)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'astyle' 'INSTALL-ASTYLE'" "INSTALL-ASTYLE"
                    ;;
               19)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'putty' 'INSTALL-PUTTY'" "INSTALL-PUTTY"
                    ;;
               20)
                    checklistsub["$S_OPT"]=1
                    install_utilities
                    ;;
                "d")
                    DEVELOPMENT_APPS=( "${checklistsub[@]}" ) # Save Sub Menu Checklist
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
        is_breakable "$S_OPT" "d"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL UTILITES {{{
# USAGE      : install_utilities
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_utilities()
{
    # 3 sub 20
    print_title "Utilites"
    print_info $"faac gpac espeak faac antiword unrtf odt2txt txt2tags nrg2iso bchunk gnome-disk-utility"
    print_info $"Full List: $INSTALL_UTILITES" 
    read_input_yn "Install Utilities?" 1
    if [[ $YN_OPTION -eq 1 ]]; then
        add_packagemanager "package_install \"$INSTALL_UTILITES\" 'INSTALL-UTITILTIES'" "INSTALL-UTITILTIES"
    fi
}
#}}}
# -----------------------------------------------------------------------------
#INTERNET {{{
# USAGE      : install_internet_apps
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_internet_apps()
{
    # 7
    clear_sub
    clear_subsub
    while [[ 1 ]]; do
        print_title "INTERNET APPS"
        clear_smenu
        submenu_item 1 "Browser" "" ""
        submenu_item 2 "Download|Fileshare" "" ""
        submenu_item 3 "Email|RSS" "" ""
        submenu_item 4 "Instant Messaging" "IM" ""
        submenu_item 5 "IRC" "" ""
        submenu_item 6 "Mapping Tools" "" ""
        submenu_item 7 "VNC|Desktop Share" "" ""
        print_sm "D"
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #BROWSER {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "BROWSER"
                        subsubmenu_item 1  "Firefox" "" ""
                        subsubmenu_item 2  "Chromium" "" ""
                        subsubmenu_item 3  "Google Chrome" "" "$AUR" 
                        subsubmenu_item 4  "Opera" "" ""
                        subsubmenu_item 5  "Rekonq or Midori" "Depending on DE" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'firefox firefox-i18n-$LANGUAGE_FF flashplugin' 'INSTALL-FIREFOX'" "INSTALL-FIREFOX"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'chromium flashplugin' 'INSTALL-CHROMIUM'" "INSTALL-CHROMIUM"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'google-chrome openssl098 flashplugin' 'AUR-INSTALL-GOOGLE-CHROME'" "AUR-INSTALL-GOOGLE-CHROME"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'opera flashplugin' 'INSTALL-OPERA'" "INSTALL-OPERA"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    if [[ $KDE_INSTALLED -eq 1 ]]; then
                                        add_packagemanager "package_install 'rekonq' 'INSTALL-REKONQ'" "INSTALL-REKONQ"
                                    else
                                        add_packagemanager "package_install 'midori' 'INSTALL-MIDORI'" "INSTALL-MIDORI"
                                    fi
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #DOWNLOAD|FILESHARE {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "DOWNLOAD|FILESHARE"
                        subsubmenu_item 1  "deluge" "" "$AUR" 
                        subsubmenu_item 2  "dropbox" "" "$AUR" 
                        subsubmenu_item 3  "insync" "" "$AUR" 
                        subsubmenu_item 4  "jdownloader" "" "$AUR" 
                        subsubmenu_item 5  "nitroshare" "" "$AUR" 
                        subsubmenu_item 6  "sparkleshare" "" ""
                        subsubmenu_item 7  "steadyflow-bzr" "" "$AUR" 
                        subsubmenu_item 8  "Transmission" "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'deluge' 'INSTALL-DELUGE'" "INSTALL-DELUGE"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'dropbox' 'AUR-INSTALL-DROPBOX'" "AUR-INSTALL-DROPBOX"
                                    if check_package "nautilus" ; then
                                        add_packagemanager "aur_package_install 'nautilus-dropbox dropbox-tango-emblems' 'AUR-INSTALL-DROPBOX-NAUTILUS'" "AUR-INSTALL-DROPBOX-NAUTILUS"
                                    elif check_package "thunar" ; then
                                        add_packagemanager "aur_package_install 'thunar-dropbox' 'AUR-INSTALL-DROPBOX-THUNAR'" "AUR-INSTALL-DROPBOX-THUNAR"
                                    elif check_package "kdebase-dolphin" ; then
                                        add_packagemanager "aur_package_install 'kfilebox' 'AUR-INSTALL-DROPBOX-KFILEBOX'" "AUR-INSTALL-DROPBOX-KFILEBOX"
                                    else
                                        add_packagemanager "aur_package_install 'dropbox-cli' 'AUR-INSTALL-DROPBOX-CLI'" "AUR-INSTALL-DROPBOX-CLI"
                                    fi
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'insync' 'AUR-INSTALL-INSYNC'" "AUR-INSTALL-INSYNC"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'jdownloader' 'AUR-INSTALL-JDOWNLOADER'" "AUR-INSTALL-JDOWNLOADER"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'nitroshare' 'AUR-INSTALL-NITROSHARE" "AUR-INSTALL-NITROSHARE"
                                    ;;
                                6)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'sparkleshare' 'INSTALL-SPARKLESHARE'" "INSTALL-SPARKLESHARE"
                                    ;;
                                7)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'steadyflow-bzr' 'AUR-INSTALL-STEADYFLOW'" "AUR-INSTALL-STEADYFLOW"
                                    ;;
                                8)
                                    checklistsubsub["$SS_OPT"]=1
                                    if [[ $KDE_INSTALLED -eq 1 ]]; then
                                        if [[ $MATE_INSTALLED -eq 1 ]]; then
                                            add_packagemanager "package_install 'transmission-gtk' 'INSTALL-TRANSMISSION-GTK'" "INSTALL-TRANSMISSION-GTK"
                                        fi
                                        add_packagemanager "package_install 'transmission-qt' 'INSTALL-TRANSMISSION-QT'" "INSTALL-TRANSMISSION-QT"
                                    else
                                        add_packagemanager "package_install 'transmission-gtk' 'INSTALL-TRANSMISSION-GTK'" "INSTALL-TRANSMISSION-GTK"
                                    fi
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #EMAIL {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "EMAIL|RSS"
                        subsubmenu_item 1  "Evolution"   "" ""
                        subsubmenu_item 2  "thunderbird" "" ""
                        subsubmenu_item 3  "liferea"     "" ""
                        subsubmenu_item 4  "lightread"   "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'evolution' 'INSTALL-EVOLUTION'" "INSTALL-EVOLUTION"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'thunderbird thunderbird-i18n-$LANGUAGE_FF' 'INSTALL-THUNDERBIRD'" "INSTALL-THUNDERBIRD"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'liferea' 'INSTALL-LIFEREA'" "INSTALL-LIFEREA"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'lightread' 'AUR-INSTALL-LIGHTREAD'" "AUR-INSTALL-LIGHTREAD"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #IM {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "IM - INSTANT MESSAGING"
                        subsubmenu_item 1  "Emesene"           "" ""
                        subsubmenu_item 2  "Google Talkplugin" "" "$AUR" 
                        subsubmenu_item 3  "Pidgin"            "" ""
                        subsubmenu_item 4  "Skype"             "" ""
                        subsubmenu_item 5  "Teamspeak3"        "" "$AUR" 
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'emesene' 'INSTALL-EMESENE'" "INSTALL-EMESENE"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'google-talkplugin' 'AUR-INSTALL-GOOGLE-TALKPLUGIN'" "AUR-INSTALL-GOOGLE-TALKPLUGIN"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'pidgin' 'INSTALL-PIDGIN'" "INSTALL-PIDGIN"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'skype' 'INSTALL-SKYPE'" "INSTALL-SKYPE"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'teamspeak3' 'AUR-INSTALL-TEAMSPEAK3'" "AUR-INSTALL-TEAMSPEAK3"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #IRC {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "IRC"
                        subsubmenu_item 1 "irssi"            "" ""
                        subsubmenu_item 2 "quassel or xchat" "Depending on DE" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'irssi' 'INSTALL-IRSSI'" "INSTALL-IRSSI"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    if [[ $KDE_INSTALLED -eq 1 ]]; then
                                        if [[ $KDE_INSTALLED -eq 1 ]]; then
                                            add_packagemanager "package_install 'xchat' 'INSTALL-XCHAT'" "INSTALL-XCHAT"
                                        fi
                                        add_packagemanager "package_install 'quassel' 'INSTALL-QUASSEL'" "INSTALL-QUASSEL"
                                    else
                                        add_packagemanager "package_install 'xchat' 'INSTALL-XCHAT'" "INSTALL-XCHAT"
                                    fi
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #MAPPING {{{
                    while [[ 1 ]];  do
                        clear_ssmenu
                        print_title "MAPPING TOOLS"
                        subsubmenu_item 1 "Google Earth"    "" "$AUR" 
                        subsubmenu_item 2 "NASA World Wind" "" "$AUR" 
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'desktop-file-utils fontconfig hicolor-icon-theme ld-lsb libsm libxrender mesa lib32-mesa shared-mime-info' 'INSTALL-GOOGLE-EARTH'" "INSTALL-GOOGLE-EARTH"
                                    add_packagemanager "aur_package_install 'google-earth' 'AUR-INSTALL-GOOGLE-EARTH'" "AUR-INSTALL-GOOGLE-EARTH"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'jogl' 'INSTALL-WORLDWIND'" "INSTALL-WORLDWIND"
                                    add_packagemanager "aur_package_install 'worldwind' 'AUR-INSTALL-WORLDWIND'" "AUR-INSTALL-WORLDWIND"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                7)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #DESKTOP SHARE {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "DESKTOP SHARE"
                        subsubmenu_item 1  "Remmina"    "" ""
                        subsubmenu_item 2  "Teamviewer" "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'remmina' 'INSTALL-REMMINA'" "INSTALL-REMMINA"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'teamviewer' 'AUR-INSTALL-TEAMVIEWER'" "AUR-INSTALL-TEAMVIEWER"
                                    ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
    is_breakable "$S_OPT" "d"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL GRAPHICS APPS {{{
# USAGE      : install_graphics_apps
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_graphics_apps()
{
    # 6
    clear_sub
    while [[ 1 ]]; do
        print_title "GRAPHICS APPS"
        print_info "AV Studio: $AV_STUDIO and from AUR $AV_STUDIO_AUR"
        clear_smenu
        submenu_item 1  "AV Studio"      "Installs all Below and more Audio and Video Apps" "$AUR"
        submenu_item 2  "Blender"        "" ""
        submenu_item 3  "Handbrake"      "" ""
        submenu_item 4  "CD/DVD Burners" "" ""
        submenu_item 5  "Gimp"           "" ""
        submenu_item 6  "Gimp-plugins"   "" "$AUR"
        submenu_item 7  "Gthumb"         "" ""
        submenu_item 8  "Inkscape"       "" ""
        submenu_item 9  "Mcomix"         "" ""
        submenu_item 10 "MyPaint"        "" ""
        submenu_item 11 "Scribus"        "" ""
        submenu_item 12 "Shotwell"       "" ""
        submenu_item 13 "Simple-scan"    "" ""
        submenu_item 14 "Xnviewmp"       "" "$AUR"
        print_sm "D"
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    install_av_studio
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'blender' 'INSTALL-BLENDER'" "INSTALL-BLENDER"
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'handbrake handbrake-cli' 'INSTALL-HANDBRAKE'" "INSTALL-HANDBRAKE"
                    ;;
                4)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'brasero dvd+rw-tools dvdauthor' 'INSTALL-BRASERO'" "INSTALL-BRASERO"
                    ;;
                5)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'gimp gcolor2' 'INSTALL-GIMP'" "INSTALL-GIMP"
                    ;;
                6)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'gimp-paint-studio gimphelp-scriptfu gimp-resynth gimpfx-foundry gimp-plugin-pandora gimp-plugin-saveforweb' 'AUR-INSTALL-GIMP-PLUGINS'" "AUR-INSTALL-GIMP-PLUGINS"
                    ;;
                7)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'gthumb' 'INSTALL-GTHUMB'" "INSTALL-GTHUMB"
                    ;;
                8)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'inkscape uniconvertor python2-numpy python-lxml' 'INSTALL-INKSCAPE'" "INSTALL-INKSCAPE"
                    add_packagemanager "aur_package_install 'sozi' 'AUR-INSTALL-SOZI'" "AUR-INSTALL-SOZI"
                    ;;
                9)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'mcomix' 'INSTALL-MCOMIX'" "INSTALL-MCOMIX"
                    ;;
               10)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'mypaint' 'INSTALL-MYPAINT'" "INSTALL-MYPAINT"
                    ;;
               11)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'scribus' 'INSTALL-SCRIBUS'" "INSTALL-SCRIBUS"
                    ;;
               12)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'shotwell' 'INSTALL-SHOTWELL'" "INSTALL-SHOTWELL"
                    ;;
               13)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'simple-scan' 'INSTALL-SIMPLE-SCAN'" "INSTALL-SIMPLE-SCAN"
                    ;;
               14)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "aur_package_install 'xnviewmp' 'AUR-INSTALL-XNVIEWMP'" "AUR-INSTALL-XNVIEWMP"
                    ;;
                "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
    is_breakable "$S_OPT" "d"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL AV STUDIO {{{
# USAGE      : install_av_studio
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_av_studio()
{
    # 6 sub 14
    print_title "Audio Video Studeo"
    print_info $"Audacity, Ardour, Blender, Openshot, ffmpeg, mencoder, and more"
    print_info $"Full List: $AV_STUDIO" 
    add_packagemanager "package_install \"$AV_STUDIO\" 'INSTALL-AUDIO-VIDEO-STUDEO'" "INSTALL-AUDIO-VIDEO-STUDEO" 
    add_packagemanager "aur_package_install \"$AV_STUDIO_AUR\" 'AUR-INSTALL-AUDIO-VIDEO-STUDEO'" "AUR-INSTALL-AUDIO-VIDEO-STUDEO"
    pause_function "$LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL VIDEO APPS {{{
# USAGE      : install_video_apps
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_video_apps()
{
    # 9
    clear_sub
    while [[ 1 ]]; do
        print_title "VIDEO APPS"
        clear_smenu
        submenu_item 1 "Players"       "" ""
        submenu_item 2 "Editors|Tools" "" ""
        submenu_item 3 "Codecs"        "" ""
        print_sm "D"
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #PLAYERS {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "VIDEO PLAYERS"
                        subsubmenu_item 1 "Audience-bzr"      "" "$AUR" 
                        subsubmenu_item 2 "Gnome-mplayer"     "" ""
                        subsubmenu_item 3 "Parole"            "" ""
                        subsubmenu_item 4 "MiniTube"          "" "$AUR" 
                        subsubmenu_item 5 "Miro"              "" ""
                        subsubmenu_item 6 "Rosa Media Player" "" "$AUR" 
                        subsubmenu_item 7 "SM Player"         "" ""
                        subsubmenu_item 8 "VLC"               "" ""
                        subsubmenu_item 9 "XBMC"              "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                     add_packagemanager "aur_package_install 'audience-bzr' 'AUR-INSTALL-AUDIENCE'" "AUR-INSTALL-AUDIENCE"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'gnome-mplayer' 'INSTALL-GNOME-MPLAYER'" "INSTALL-GNOME-MPLAYER"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'parole' 'INSTALL-PAROLE'" "INSTALL-PAROLE"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                     add_packagemanager "aur_package_install 'minitube' 'AUR-INSTALL-MINITUBE'" "AUR-INSTALL-MINITUBE"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'miro' 'INSTALL-MIRO'" "INSTALL-MIRO"
                                    ;;
                                6)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'rosa-media-player' 'AUR-INSTALL-ROSA-MEDIA-PLAYER'" "AUR-INSTALL-ROSA-MEDIA-PLAYER"
                                    ;;
                                7)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'smplayer smplayer-themes' 'INSTALL-SMPLAYER'" "INSTALL-SMPLAYER"
                                    ;;
                                8)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'vlc' 'INSTALL-VLC'" "INSTALL-VLC"
                                    if [[ $KDE_INSTALLED -eq 1 ]]; then
                                        add_packagemanager "package_install 'phonon-vlc' 'INSTALL-VLC-KDE'" "INSTALL-VLC-KDE"
                                    fi
                                    ;;
                                9)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'xbmc' 'INSTALL-XBNC'" "INSTALL-XBNC"
                                    ;;
                              "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                2)
                    checklistsub["$S_OPT"]=1
                    clear_subsub
                    #EDITORS {{{
                    while [[ 1 ]]; do
                        clear_ssmenu
                        print_title "VIDEO EDITORS|TOOLS"
                        subsubmenu_item 1  "Arista-transcoder" "" ""
                        subsubmenu_item 2  "Transmageddon"     "" ""
                        subsubmenu_item 3  "KDEenlive"         "" ""
                        subsubmenu_item 4  "Openshot"          "" ""
                        subsubmenu_item 5  "Pitivi"            "" ""
                        subsubmenu_item 6  "Kazam-bzr"         "" ""
                        print_ssm "B"
                        S_SUB_OPTIONS+=" b"
                        read_input_options "$S_SUB_OPTIONS"
                        for SS_OPT in ${OPTIONS[@]}; do
                            case "$SS_OPT" in
                                1)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'arista-transcoder' 'INSTALL-ARISTA-TRANSCODER'" "INSTALL-ARISTA-TRANSCODER"
                                    ;;
                                2)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'transmageddon' 'INSTALL-TRAMSMAGEDDON'" "INSTALL-TRAMSMAGEDDON"
                                    ;;
                                3)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'kdenlive' 'INSTALL-KDENLIVE'" "INSTALL-KDENLIVE"
                                    ;;
                                4)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'openshot' 'INSTALL-OPENSHOT'" "INSTALL-OPENSHOT"
                                    ;;
                                5)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "package_install 'pitivi' 'INSTALL-PITIVI'" "INSTALL-PITIVI"
                                    ;;
                                6)
                                    checklistsubsub["$SS_OPT"]=1
                                    add_packagemanager "aur_package_install 'python-rsvg kazam-bzr' 'AUR-INSTALL-KAZAM-BZR'" "AUR-INSTALL-KAZAM-BZR"
                                   ;;
                                "b")
                                    break
                                    ;;
                                *)
                                    invalid_option "$SS_OPT"
                                    ;;
                            esac
                        done
                    is_breakable "$SS_OPT" "b"
                    done
                    #}}}
                    ;;
                3)
                    checklistsub["$S_OPT"]=1
                    add_packagemanager "package_install 'libquicktime libdvdread libdvdnav libdvdcss cdrdao' 'INSTALL-VIDEO-CODECS'" "INSTALL-VIDEO-CODECS"
                    if [[ "$ARCHI" != "x86_64" ]]; then
                         add_packagemanager "aur_package_install 'codecs' 'AUR-INSTALL-CODECS'" "AUR-INSTALL-CODECS"
                    else
                         add_packagemanager "aur_package_install 'codecs64' 'AUR-INSTALL-CODECS-64'" "AUR-INSTALL-CODECS-64"
                    fi
                    ;;
                "d")
                    break
                    ;;
                *)
                    invalid_option "$S_OPT"
                    ;;
            esac
        done
    is_breakable "$S_OPT" "d"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL SCIENCE {{{
# USAGE      : install_science
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_science()
{
    print_title "Science and Education"
    print_info $""
    print_info $"Full List: $INSTALL_SCIENCE_EDUCATION" 
    add_packagemanager "package_install '$INSTALL_SCIENCE_EDUCATION' 'INSTALL-SCIENCE'" "INSTALL-SCIENCE"
    pause_function "$LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL VIDEO CARDS {{{
# USAGE      : install_video_cards
# DESCRIPTION: Install Video Card
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_video_cards()
{
    print_title "VIDEO CARD - https://wiki.archlinux.org/index.php/HCL/Video_Cards"
    print_info $"NVIDIA - https://wiki.archlinux.org/index.php/NVIDIA"
    PS3="$prompt1"
    echo -e "Select a Boot BIOS System Type:\n"
    select OPT in "${VIDEO_CARDS[@]}"; do
        case "$REPLY" in
            1)
                VIDEO_CARD=1 # 1 NVIDIA
                #refresh_pacman
                #TEMP=$(pacman -Qe | grep xf86-video | awk '{print $1}')
                #if [[ -n "$TEMP" ]]; then
                #    add_packagemanager "package_remove \"$TEMP\"" "REMOVE-NVIDIA-XF86-VIDEO" # 
                #fi
                #
                add_packagemanager "TEMP=\$(pacman -Qe | grep xf86-video | awk '{print \$1}'); if [[ -n \"\$TEMP\" ]]; then package_remove \"\$TEMP\" \"REMOVE-NVIDIA-XF86-VIDEO-LIVE\"; fi" "REMOVE-NVIDIA-XF86-VIDEO"
                #
                add_packagemanager "package_remove 'libgl'" "REMOVE-NVIDIA"
                add_packagemanager "package_install 'nvidia nvidia-utils abs mesa mesa-demos' 'INSTALL-NVIDIA'" "INSTALL-NVIDIA"
                add_packagemanager "nvidia-xconfig" "RUN-NVIDIA-XCONFIG"
                break
                ;;
            2)
                VIDEO_CARD=2 # 2 NOUVEAU
                add_packagemanager "package_install 'libgl xf86-video-nouveau nouveau-dri' 'INSTALL-NOUVEAU'" "INSTALL-NOUVEAU"
                add_module "nouveau" "MODULE-NOUVEAU"
                break
                ;;
            3)
                VIDEO_CARD=3 # 3 INTEL
                add_packagemanager "package_install 'libgl xf86-video-intel' 'INSTALL-INTEL'" "INSTALL-INTEL"
                break
                ;;
            4)
                VIDEO_CARD=4 # 4 ATI
                add_packagemanager "package_install 'libgl xf86-video-ati' 'INSTALL-ATI'" "INSTALL-ATI"
                add_module "radeon" "MODULE-RADEON"
                break
                ;;
            5)
                VIDEO_CARD=5 # 5 VESA
                add_packagemanager "package_install 'xf86-video-vesa' 'INSTALL-VESA'" "INSTALL-VESA"
                break
                ;;
            6)
                VIDEO_CARD=6 # 6 VIRTUALBOX
                add_packagemanager "package_install 'virtualbox-guest-utils' 'INSTALL-VIRTUALBOX'" "INSTALL-VIRTUALBOX"
                add_module "vboxguest" "MODULE-VIRUALBOX-GUEST"
                add_module "vboxsf"    "MODULE-VITRUALBOX-SF"
                add_module "vboxvideo" "MODULE-VIRTUALBOX-VIDEO"
                add_user_group "vboxsf"
                break
                ;;
            7)
                VIDEO_CARD=7 # 7 SKIP
                break
                ;;
           *)
                invalid_option "$REPLY"
                ;;
        esac
    done    
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL CUPS {{{
# USAGE      : install_cups
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_cups()
{
    # Install Software 
    print_title "CUPS - https://wiki.archlinux.org/index.php/Cups"
    print_info $"CUPS is the standards-based, open source printing system developed by Apple Inc. for Mac OS® X and other UNIX®-like operating systems."
    read_input_yn "Install CUPS - AKA Common Unix Printing System" 1
    if [[ $YN_OPTION -eq 1 ]]; then
        add_packagemanager "package_install 'cups cups-filters ghostscript gsfonts gutenprint foomatic-db foomatic-db-engine foomatic-db-nonfree foomatic-filters hplip splix cups-pdf' 'INSTALL-CUPS'" "INSTALL-CUPS"
        add_packagemanager "systemctl enable cups.service" "SYSTEMD-ENABLE-CUPS"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL ADDITIONAL FIRMWARE {{{
# USAGE      : install_additional_firmwares
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_additional_firmwares()
{
    # Install Software 
    clear_sub
    print_title "INSTALL ADDITIONAL FIRMWARES"
    print_info $"alsa-firmware, ipw2100-fw, ipw2200-fw, b43-firmware, b43-firmware-legacy, broadcom-wl, zd1211-firmware, bluez-firmware, libffado, libraw1394, sane-gt68xx-firmware"
    read_input_yn "Install additional firmwares [Audio,Bluetooth,Scanner,Wireless]" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        while [[ 1 ]]; do
            print_title "INSTALL ADDITIONAL FIRMWARES"
            clear_smenu
            submenu_item 1  "alsa-firmware"        "" ""
            submenu_item 2  "ipw2100-fw"           "" ""
            submenu_item 3  "ipw2200-fw"           "" ""
            submenu_item 4  "b43-firmware"         "" "$AUR"
            submenu_item 5  "b43-firmware-legacy"  "" "$AUR"
            submenu_item 6  "broadcom-wl"          "" "$AUR"
            submenu_item 7  "zd1211-firmware"      "" ""
            submenu_item 8  "bluez-firmware"       "" ""
            submenu_item 9  "libffado"             "[Fireware Audio Devices]" ""
            submenu_item 10 "libraw1394"           "[IEEE1394 Driver]" ""
            submenu_item 11 "sane-gt68xx-firmware" "" ""
            print_sm "D"
            SUB_OPTIONS+=" d"
            read_input_options "$SUB_OPTIONS"
            for S_OPT in ${OPTIONS[@]}; do
                case "$S_OPT" in
                    1)
                        checklistsub["$S_OPT"]=1
                        add_packagemanager "package_install 'alsa-firmware' 'INSTALL-ALSA-FIRMWARE'" "INSTALL-ALSA-FIRMWARE"
                        ;;
                    2)
                        checklistsub["$S_OPT"]=1
                        add_packagemanager "package_install 'ipw2100-fw' 'INSTALL-IPW2100-FW'" "INSTALL-IPW2100-FW"
                        ;;
                    3)
                        checklistsub["$S_OPT"]=1
                        add_packagemanager "package_install 'ipw2200-fw' 'INSTALL-IPW2200-FW'" "INSTALL-IPW2200-FW"
                        ;;
                    4)
                        checklistsub["$S_OPT"]=1
                        add_packagemanager "aur_package_install 'b43-firmware' 'AUR-INSTALL-B43-FIRMWARE'" "AUR-INSTALL-B43-FIRMWARE"
                        ;;
                    5)
                        checklistsub["$S_OPT"]=1
                        add_packagemanager "aur_package_install 'b43-firmware-legacy' 'AUR-INSTALL-B43-FIRMWARE-LEGACY'" "AUR-INSTALL-B43-FIRMWARE-LEGACY"
                        ;;
                    6)
                        checklistsub["$S_OPT"]=1
                        add_packagemanager "aur_package_install 'broadcom-wl' 'AUR-INSTALL-BROADCOM-WL'" "AUR-INSTALL-BROADCOM-WL"
                        ;;
                    7)
                        checklistsub["$S_OPT"]=1
                        add_packagemanager "package_install 'zd1211-firmware' 'INSTALL-ZD1211-FIRMWARE'" "INSTALL-ZD1211-FIRMWARE"
                        ;;
                    8)
                        checklistsub["$S_OPT"]=1
                        add_packagemanager "package_install 'bluez-firmware' 'INSTALL-BLUEZ-FIREWARE'" "INSTALL-BLUEZ-FIREWARE"
                        ;;
                    9)
                        checklistsub["$S_OPT"]=1
                        add_packagemanager "package_install 'libffado' 'INSTALL-LIBFFADO'" "INSTALL-LIBFFADO"
                        ;;
                   10)
                        checklistsub["$S_OPT"]=1
                        add_packagemanager "package_install 'libraw1394' 'INSTALL-LIBRAW1394'" "INSTALL-LIBRAW1394"
                        ;;
                   11)
                        checklistsub["$S_OPT"]=1
                        add_packagemanager "package_install 'sane-gt68xx-firmware' 'INSTALL-SANE-GT68XX-FIRMWARE'" "INSTALL-SANE-GT68XX-FIRMWARE"
                        ;;
                  "d")
                        break
                        ;;
                    *)
                        invalid_option "$S_OPT"
                        ;;
                esac
            done
            is_breakable "$S_OPT" "d"
        done
    fi
}
#}}}
# -----------------------------------------------------------------------------
# CHOOSE AUR HELPER {{{
# USAGE      : choose_aurhelper
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
choose_aurhelper()
{
    print_title "AUR HELPER - https://wiki.archlinux.org/index.php/AUR_Helpers"
    print_info "AUR Helpers are written to make using the Arch User Repository more comfortable."
    print_info "YAOURT - https://wiki.archlinux.org/index.php/Yaourt"
    print_info "Yaourt (Yet AnOther User Repository Tool) is a community-contributed wrapper for pacman which adds seamless access to the AUR, allowing and automating package compilation and installation from your choice of the thousands of PKGBUILDs in the AUR, in addition to the many thousands of available Arch Linux binary packages."
    print_info "Yaourt is Recommended."
    print_info "List of AUR Helpers: ${AUR_HELPERS[*]}"
    print_warning "\tNone of these tools are officially supported by Arch devs."
    read_input_yn "$AUR_HELPER is default, do you wish to change it" 0
    if [[ "$YN_OPTION" -eq 1 ]]; then
        PS3="$prompt1"
        echo -e "Choose your default AUR helper to install\n"
        select OPT in "${AUR_HELPERS[@]}"; do
            case "$REPLY" in
                1)
                    AUR_HELPER="yaourt"
                    break
                    ;;
                2)
                    AUR_HELPER="packer"
                    break
                    ;;
                3)
                    AUR_HELPER="pacaur"
                    break
                    ;;
                *)
                    invalid_option "$REPLY"
                    ;;
            esac
        done
    fi
    get_run_aur_root # RUN_AUR_ROOT
}
#}}}
# -----------------------------------------------------------------------------
# GET RUN AUR ROOT {{{
# USAGE      : get_run_aur_root
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_run_aur_root()
{
    print_info "AUR is not Offical Software, so be warned, trust in AUR packages is on a per package deal, the list we provide is what we trust, but we could be wrong."
    print_info "Since makepkg uses fakeroot (and should never be run as root), there is some level of protection but you should never count on it. If in doubt, do not build the package and seek advice on the forums or mailing list."
    print_info "So running AUR as Root, is putting a lot of trust into that Package, it requires root to install it, so personally I do not see the Differance, so I make it an Option."
    print_warning "\tThe Evils of running AUR as Root, no password prompts, faster, but not recommended for Security reasons, but for testing an for unattended install, its an option, just know this before deciding."
    read_input_yn "Run AUR installs as Root" 0
    if [[ "$YN_OPTION" -eq 1 ]]; then
        RUN_AUR_ROOT=1
    else
        RUN_AUR_ROOT=2
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL GIT ACCESS THRU A FIREWALL {{{
# USAGE      : install_git_tor
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_git_tor()
{
    print_title "GIT-TOR - https://wiki.archlinux.org/index.php/Tor"
    print_info $"Tor is an open source implementation of 2nd generation onion routing that provides free access to an anonymous proxy network. Its primary goal is to enable online anonymity by protecting against traffic analysis attacks."
    read_input_yn "Ensuring access to GIT through a firewall (bypass college/work firewall)" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        add_packagemanager "package_install 'openbsd-netcat vidalia privoxy git tor' 'INSTALL-TOR'" "INSTALL-TOR"
        add_packagemanager "systemctl enable tor.service privoxy.service" "SYSTEMD-ENABLE-TOR"
        # @FIX
        make_dir "/etc/privoxy" "$LINENO"
        copy_file "/etc/privoxy/config" $MOUNTPOINT"/etc/privoxy/config" "$LINENO"
        make_dir "$SCRIPT_DIR/etc/privoxy" "$LINENO"
        copy_file "/etc/privoxy/config" "$SCRIPT_DIR/etc/privoxy/config" "$LINENO"
        CONFIG_TOR=1
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL REFLECTOR {{{
# USAGE      : install_reflector
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_reflector()
{
    print_title "REFLECTOR - https://wiki.archlinux.org/index.php/Reflector"
    print_info $"Reflector is a script which can retrieve the latest mirror list from the MirrorStatus page, filter the most up-to-date mirrors, sort them by speed and overwrite the file /etc/pacman.d/mirrorlist."
    read_input_yn "Install reflector" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        add_packagemanager "package_install 'reflector' 'INSTALL-REFLECTOR'" "INSTALL-REFLECTOR"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL BASIC SETUP {{{
# USAGE      : install_basic_setup
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_basic_setup()
{
    print_title "The Following will be installed by Default."
    print_info $"SYSTEMD - https://wiki.archlinux.org/index.php/Systemd and https://aur.archlinux.org/packages/systemd-user-session-units-git/ and https://github.com/sofar/user-session-units"
    print_info $"systemd is a replacement for the init daemon for Linux (either System V or BSD-style). It is intended to provide a better framework for expressing services' dependencies, allow more work to be done in parallel at system startup, and to reduce shell overhead."
    add_packagemanager "package_install 'coreutils expat filesystem shadow' 'INSTALL-SYSTEMD'" "INSTALL-SYSTEMD" # systemd Installed by default
    #add_packagemanager "package_remove 'dbus-core'" "REMOVE-SYSTEMD"
    add_packagemanager "aur_package_install 'dbus-core-systemd-user-sessions systemd-user-session-units-git systemd-xorg-launch-helper-git' 'AUR-INSTALL-SYSTEMD'" "AUR-INSTALL-SYSTEMD"
    add_packagemanager "systemctl enable syslog-ng.service cronie.service" "SYSTEMD-ENABLE-SYSTEMD"
    print_info $"BASH TOOLS - https://wiki.archlinux.org/index.php/Bash"
    add_packagemanager "package_install 'bc rsync mlocate bash-completion ntp pkgstats' 'INSTALL-BASH-TOOLS'" "INSTALL-BASH-TOOLS"
    add_packagemanager "systemctl enable ntpd.service" "SYSTEMD-ENABLE-BASH-TOOLS"
    add_packagemanager "timedatectl set-timezone $ZONE/$SUBZONE" "SYSTEMD-SET-TIMEZONE"
    print_info $"DBUS - https://wiki.archlinux.org/index.php/D-Bus"
    print_info $"D-Bus is a message bus system that provides an easy way for inter-process communication. It consists of a daemon, which can be run both system-wide and for each user session, and a set of libraries to allow applications to use D-Bus."
    # add_packagemanager "package_install 'dbus' 'INSTALL-DBUS'"  "INSTALL-DBUS" # Installed by default
    print_info $"(UN)COMPRESS TOOLS - https://wiki.archlinux.org/index.php/P7zip"
    add_packagemanager "package_install 'arj cabextract p7zip sharutils unace unrar unzip uudeview zip' 'INSTALL-UN-COMMPRESS-TOOLS'" "INSTALL-UN-COMMPRESS-TOOLS"
    add_packagemanager "aur_package_install 'rar' 'AUR-INSTALL-RAR'" "AUR-INSTALL-RAR"
    print_info $"AVAHI - https://wiki.archlinux.org/index.php/Avahi"
    print_info $"Avahi is a free Zero Configuration Networking (Zeroconf) implementation, including a system for multicast DNS/DNS-SD service discovery. It allows programs to publish and discover services and hosts running on a local network with no specific configuration."
    add_packagemanager "package_install 'avahi nss-mdns' 'INSTALL-AVAHI'" "INSTALL-AVAHI"
    add_packagemanager "systemctl enable avahi-daemon.service avahi-dnsconfd.service" "SYSTEMD-ENABLE-AVAHI"
    print_info $"ACPI - https://wiki.archlinux.org/index.php/ACPI_modules"
    print_info $"acpid is a flexible and extensible daemon for delivering ACPI events."
    add_packagemanager "package_install 'acpi acpid' 'INSTALL-ACPI'" "INSTALL-ACPI"
    add_packagemanager "systemctl enable acpid.service" "SYSTEMD-ENABLE-ACPI"
    print_info $"ALSA - https://wiki.archlinux.org/index.php/Alsa"
    print_info $"The Advanced Linux Sound Architecture (ALSA) is a Linux kernel component intended to replace the original Open Sound System (OSSv3) for providing device drivers for sound cards."
    add_packagemanager "package_install 'alsa-utils alsa-plugins' 'INSTALL-ALSA'" "INSTALL-ALSA"
    add_module "snd-usb-audio" "MODULE-ALSA"
    add_packagemanager "systemctl enable alsa-store.service alsa-restore.service" "SYSTEMD-ENABLE-ALSA"
    print_info $"NTFS/FAT/exFAT - https://wiki.archlinux.org/index.php/File_Systems"
    print_info $"A file system (or filesystem) is a means to organize data expected to be retained after a program terminates by providing procedures to store, retrieve and update data, as well as manage the available space on the device(s) which contain it. A file system organizes data in an efficient manner and is tuned to the specific characteristics of the device."
    add_packagemanager "package_install 'ntfs-3g ntfsprogs dosfstools exfat-utils fuse fuse-exfat' 'INSTALL-NTFS'" "INSTALL-NTFS"
    add_module "fuse" "MODULE-NTFS"
    print_info $"SSH - https://wiki.archlinux.org/index.php/Ssh"
    print_info $"Secure Shell (SSH) is a network protocol that allows data to be exchanged over a secure channel between two computers."
    add_packagemanager "package_install 'openssh' 'INSTALL-SSH'" "INSTALL-SSH"
    add_packagemanager "aur_package_install 'rssh' 'AUR-INSTALL-RSSH'" "AUR-INSTALL-RSSH"
    add_packagemanager "systemctl enable sshd.service" "SYSTEMD-ENABLE-SSH"
    CONFIG_SSH=1
    pause_function "$LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL NFS {{{
# USAGE      : install_nfs
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_nfs()
{
    print_title "NFS - https://wiki.archlinux.org/index.php/Nfs"
    print_info $"NFS allowing a user on a client computer to access files over a network in a manner similar to how local storage is accessed."
    read_input_yn "Install NFS" 1
    if [[ $YN_OPTION -eq 1 ]]; then
        add_packagemanager "package_install 'nfs-utils' 'INSTALL-NFS'" "INSTALL-NFS"
        add_packagemanager "systemctl enable rpc-statd.service" "SYSTEMD-ENABLE-NFS"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL SAMBA {{{
# USAGE      : install_samba
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_samba()
{
    print_title "SAMBA - https://wiki.archlinux.org/index.php/Samba"
    print_info $"Samba is a re-implementation of the SMB/CIFS networking protocol, it facilitates file and printer sharing among Linux and Windows systems as an alternative to NFS."
    read_input_yn "Install Samba" 1
    if [[ $YN_OPTION -eq 1 ]]; then
        add_packagemanager "package_install 'samba' 'INSTALL-SAMBA'" "INSTALL-SAMBA"
        run_this_command "cp -f /etc/samba/smb.conf.default \$MOUNTPOINT/etc/samba/smb.conf" # @FIX do I need to overwrite it? Write a function to copy if not exist
        add_packagemanager "systemctl enable smbd.service nmbd.service winbindd.service" "SYSTEMD-ENABLE-SAMBA"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL PRELOAD {{{
# USAGE      : install_preload
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_preload()
{
    print_title "PRELOAD - https://wiki.archlinux.org/index.php/Preload"
    print_info $"Preload is a program which runs as a daemon and records statistics about usage of programs using Markov chains; files of more frequently-used programs are, during a computer's spare time, loaded into memory. This results in faster startup times as less data needs to be fetched from disk. preload is often paired with prelink."
    read_input_yn "Install Preload" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        add_packagemanager "package_install 'preload' 'INSTALL-PRELOAD'" "INSTALL-PRELOAD"
        add_packagemanager "systemctl enable preload.service" "SYSTEMD-ENABLE-PRELOAD"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL ZRAM {{{
# USAGE      : install_zram
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_zram()
{
    print_title "ZRAM - https://wiki.archlinux.org/index.php/Maximizing_Performance"
    print_info $"Zram creates a device in RAM and compresses it. If you use for swap means that part of the RAM can hold much more information but uses more CPU. Still, it is much quicker than swapping to a hard drive. If a system often falls back to swap, this could improve responsiveness. Zram is in mainline staging (therefore its not stable yet, use with caution)."
    read_input_yn "Install Zram" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        add_packagemanager "aur_package_install 'zramswap' 'AUR-INSTALL-ZRAMSWAP'" "AUR-INSTALL-ZRAMSWAP"
        add_packagemanager "systemctl enable zram.service" "SYSTEMD-ENABLE-ZRAMSWAP"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL LAPTOP MODE TOOLS {{{
# USAGE      : install_lmt
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_lmt()
{
    print_title "LAPTOP MODE TOOLS- https://wiki.archlinux.org/index.php/Laptop_Mode_Tools"
    print_info $"Laptop Mode Tools is a laptop power saving package for Linux systems. It is the primary way to enable the Laptop Mode feature of the Linux kernel, which lets your hard drive spin down. In addition, it allows you to tweak a number of other power-related settings using a simple configuration file."
    read_input_yn "Install Laptop Mode Tools" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        add_packagemanager "package_install 'laptop-mode-tools' 'INSTALL-LAPTOP-TOOLS'" "INSTALL-LAPTOP-TOOLS"
        add_packagemanager "systemctl enable laptop-mode-tools.service" "SYSTEMD-ENABLE-LAPTOP-TOOLS"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL XORG {{{
# USAGE      : install_xorg
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_xorg()
{
    print_title "XORG - https://wiki.archlinux.org/index.php/Xorg"
    print_info $"Xorg is the public, open-source implementation of the X window system version 11."
    echo "Installing X-Server (req. for Desktopenvironment, GPU Drivers, Keyboardlayout,...)"
    add_packagemanager "package_install 'xorg-server xorg-xinit xorg-xkill xorg-setxkbmap xf86-input-synaptics xf86-input-mouse xf86-input-keyboard mesa gamin' 'INSTALL-XORG'" "INSTALL-XORG"
    CONFIG_XORG=1
    get_keyboard_layout
    pause_function "$LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# GET KEYBOARD LAYOUT {{{
# USAGE      : get_keyboard_layout
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_keyboard_layout()
{
    if [[ "$LANGUAGE" == 'es_ES' ]]; then
        print_title "https://wiki.archlinux.org/index.php/KEYMAP"
        KBLAYOUT=("es" "latam");
        PS3="$prompt1"
        echo -e "Select keyboard layout:"
        select KBRD in "${KBLAYOUT[@]}"; do
            KEYBOARD="$KBRD"
        done
    fi    
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL KERNEL {{{
# USAGE      : install_kernel
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_kernel()
{
    print_title "Kernels - https://wiki.archlinux.org/index.php/Kernels"
    print_info $"Liquorix - http://liquorix.net/"
    print_info $""
    aurhelper=("Liquorix" "Skip")
    PS3="$prompt1"
    echo -e "Choose your Kernel\n"
    select OPT in "${aurhelper[@]}"; do
        case "$REPLY" in
            1)
                add_packagemanager "aur_package_install 'linux-lqx' 'AUR-INSTALL-LIQUORIX'" "AUR-INSTALL-LIQUORIX"
                if [[ "$VIDEO_CARD" -eq 1 ]]; then
                    add_packagemanager "aur_package_install 'nvidia-lqx nvidia-lqx' 'AUR-INSTALL-LIQUORIX-NVIDIA'" "AUR-INSTALL-LIQUORIX-NVIDIA"
                fi
                add_packagemanager "grub-mkconfig -o /boot/grub/grub.cfg" "CONFIG-LIQUORIX"
                break
                ;;
            2)
                break
                ;;
            *)
                invalid_option "$REPLY"
                ;;
        esac
    done
}
#}}}
# -----------------------------------------------------------------------------
# *****************************************************************************
# -----------------------------------------------------------------------------
# GET MIRRORLIST {{{
# USAGE      : get_mirrorlist
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_mirrorlist() 
{
    if [[ "$CUSTOM_MIRRORLIST" -eq 1 && -f "$SCRIPT_DIR/mirrorlist" ]]; then
        copy_file "$SCRIPT_DIR/mirrorlist" "/etc/pacman.d/mirrorlist" "$LINENO"
    else
        url="https://www.archlinux.org/mirrorlist/?country=$1&protocol=http&ip_version=4&use_mirror_status=on"
        print_info $"Downloading $url..."
        # Backup and replace current mirrorlist file on running OS
        mv -if /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig
        # Get latest mirror list and save to tmpfile
        wget -qO- "$url" | sed 's/^#Server/Server/g' > /etc/pacman.d/mirrorlist 
    fi
}
#}}}
# -----------------------------------------------------------------------------
# GET COUNTRY CODES {{{
# USAGE      : get_country_codes
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_country_codes() 
{
    # I pull the code from Locale, so it should always be right, so no need for a menu; default should work.
    print_title "Country Code for Mirror List - https://www.archlinux.org/mirrorlist/"
    print_this $"Australia     = AU | Belarus       = BY | Belgium       = BE"
    print_line
    print_this $"Brazil        = BR | Bulgaria      = BG | Canada        = CA"
    print_line
    print_this $"Chile         = CL | China         = CN | Colombia      = CO"
    print_line
    print_this $"Czech Repub   = CZ | Denmark       = DK | Estonia       = EE"
    print_line
    print_this $"Finland       = FI | France        = FR | Germany       = DE"
    print_line
    print_this $"Greece        = GR | Hungary       = HU | India         = IN"
    print_line
    print_this $"Ireland       = IE | Israel        = IL | Italy         = IT"
    print_line
    print_this $"Japan         = JP | Kazakhstan    = KZ | Korea         = KR"
    print_line
    print_this $"Latvia        = LV | Macedonia     = MK | Netherlands   = NL"
    print_line
    print_this $"New Caledonia = NC | New Zealand   = NZ | Norway        = NO"
    print_line
    print_this $"Poland        = PL | Portugal      = PT | Romania       = RO"
    print_line
    print_this $"Russian Fed   = RU | Serbia        = RS | Singapore     = SG"
    print_line
    print_this $"Slovakia      = SK | South Africa  = ZA | Spain         = ES"
    print_line
    print_this $"Sri Lanka     = LK | Sweden        = SE | Switzerland   = CH"
    print_line
    print_this $"Taiwan        = TW | Turkey        = TR | Ukraine       = UA"
    print_line
    print_this $"United King   = GB | United States = US | Uzbekistan    = UZ | Viet Nam = VN"
    print_line
    print_warning "You must enter your Country corectly, no validation is done!"
    #
    read_input_default "Country Code for Mirror List: [US] " "${LOCALE#*_}"
    COUNTRY_CODE=`echo "$OPTION" | tr '[:lower:]' '[:upper:]'`  # Upper case only
}   
#}}}
# -----------------------------------------------------------------------------
# GET COUNTRY CODE {{{
# USAGE      : get_country_code
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_country_code() 
{
    YN_OPTION=0 
    while [[ $YN_OPTION -ne 1 ]]; do
        get_country_codes
        read_input_yn "Confirm Country Code: $COUNTRY_CODE" 1
    done
    OPTION="$COUNTRY_CODE"
}   
#}}}
# -----------------------------------------------------------------------------
# CONFIGURE MIRRORLIST {{{
# USAGE      : configure_mirrorlist
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
configure_mirrorlist()
{
    if [ -f "${SCRIPT_DIR}/mirrorlist" ]; then
        print_info $"Mirrorlist found on ${SCRIPT_DIR}"
        read_input_yn "Do you wish to use ${SCRIPT_DIR}/mirrorlist" 1
        if [[ "YN_OPTION" -eq 1 ]]; then
            CUSTOM_MIRRORLIST=1
        fi
    fi
    if [[ "$CUSTOM_MIRRORLIST" -eq 0 ]]; then
        get_country_code
        get_mirrorlist $OPTION
        #
        print_title "MIRRORS - https://wiki.archlinux.org/index.php/Mirrors"
        print_info $"https://www.archlinux.org/mirrorlist/?country=${OPTION}&protocol=http&ip_version=4&use_mirror_status=on"
        echo "Edit or Review your mirrorlist and exit to continue."
        pause_function "$LINENO"
        $EDITOR /etc/pacman.d/mirrorlist
    fi
    # Lets copy all config files to Device where this script ran from
    # pacstrap will overwrite mirror list so create temp files on media script ran from
    make_dir "$SCRIPT_DIR/etc/pacman.d" "$LINENO"
    copy_file "/etc/pacman.d/mirrorlist" "$SCRIPT_DIR/etc/pacman.d/mirrorlist" "$LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# GET ROOT PASSWORD {{{
# USAGE      : get_root_password
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_root_password()
{
    # @FIX Special Characters: How to embed ! $ into a variable, then to disk so a pipe can echo it; tried single tic '!' and escape \!, get error ! processes not found
    print_title "root - https://wiki.archlinux.org/index.php/Users_and_Groups"
    print_info $"No Special Characters, until I figure out how to do this."
    print_info $"Enter Root Password."
    verify_input_data "root Password" 1
    ROOTPASSWD="$OPTION"
    print_title "https://wiki.archlinux.org/index.php/Users_and_Groups"
    print_info $"Root Password is Set."
    # @FIX check for empty name
}
#}}}
# -----------------------------------------------------------------------------
# GET USER NAME {{{
# USAGE      : get_user_name
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_user_name()
{
    # @FIX Special Characters: How to embed ! $ into a variable, then to disk so a pipe can echo it; tried single tic '!' and escape \!, get error ! processes not found
    print_title "User - https://wiki.archlinux.org/index.php/Users_and_Groups"
    print_info $"No Special Characters, until I figure out how to do this."
    print_info $"Enter User Name."
    verify_input_default_data "User Name" "$USERNAME" 1
    USERNAME="$OPTION"
}
#}}}
# -----------------------------------------------------------------------------
# GET USER PASSWORD {{{
# USAGE      : get_user_password
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_user_password()
{
    print_title "User - https://wiki.archlinux.org/index.php/Users_and_Groups"
    print_info $"No Special Characters, until I figure out how to do this."
    print_info $"Enter User Password."
    verify_input_data "User Password" 1
    USERPASSWD="$OPTION"
    print_title "https://wiki.archlinux.org/index.php/Users_and_Groups"
    print_info $"User Name and Password is Set."
    # @FIX check for empty name
}
#}}}
# -----------------------------------------------------------------------------
# SET LANGUAGE {{{
# USAGE      : set_language
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
set_language()
{
    LANGUAGE="$1"
    #KDE #{{{
    if [[ $LANGUAGE == pt_BR || $LANGUAGE == en_GB || $LANGUAGE == zh_CN ]]; then
        LANGUAGE_KDE=`echo $LANGUAGE | tr '[:upper:]' '[:lower:]'`
    elif [[ $LANGUAGE == en_US ]]; then
        LANGUAGE_KDE="en_gb"
    else
        LANGUAGE_KDE=`echo $LANGUAGE | cut -d\_ -f1`
    fi
    #}}}
    #FIREFOX #{{{
    if [[ $LANGUAGE == pt_BR || $LANGUAGE == pt_PT || $LANGUAGE == en_GB || $LANGUAGE == es_AR || $LANGUAGE == es_ES || $LANGUAGE == zh_CN ]]; then
        LANGUAGE_FF=`echo $LANGUAGE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
    elif [[ $LANGUAGE == en_US ]]; then
        LANGUAGE_FF="en-gb"
    else
        LANGUAGE_FF=`echo $LANGUAGE | cut -d\_ -f1`
    fi
    #}}}
    #HUNSPELL #{{{
    if [[ $LANGUAGE == pt_BR ]]; then
        LANGUAGE_HS=`echo $LANGUAGE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
    elif [[ $LANGUAGE == pt_PT ]]; then
        LANGUAGE_HS="pt_pt"
    else
        LANGUAGE_HS=`echo $LANGUAGE | cut -d\_ -f1`
    fi
    #}}}
    #ASPELL #{{{
    LANGUAGE_AS=`echo $LANGUAGE | cut -d\_ -f1`
    #}}}
    #LIBREOFFICE #{{{ 
    if [[ $LANGUAGE == pt_BR || $LANGUAGE == en_GB || $LANGUAGE == en_US || $LANGUAGE == zh_CN ]]; then
        LANGUAGE_LO=`echo $LANGUAGE | sed 's/_/-/'`
    else
        LANGUAGE_LO=`echo $LANGUAGE | cut -d\_ -f1`
    fi
    #}}}
}
#}}}
# -----------------------------------------------------------------------------
# GET LOCALE {{{
# USAGE      : get_locale
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_locale()
{
    # GET LOCALES LIST {{{
    get_locales_list()
    {
        print_title "LOCALE - https://wiki.archlinux.org/index.php/Locale"
        print_info $"Locales are used in Linux to define which language the user uses."
        print_info $"As the locales define the character sets being used as well, setting up the correct locale is especially important if the language contains non-ASCII characters."
        print_info $"We can only initize those Locales that are Available, if not in list, Install Language and rerun script."
        # Another way to show all available, lots of work
        # @FIX create Localized po files for Localization
        # mkdir {af,sq,ar,eu,be,bs,bg,ca,hr,zh_CN,zh_TW,cs,da,en,et,fa,ph,fi,fr_FR,fr_CH,fr_BE,fr_CA,ga,gl,ka,de,el,gu,he,hi,hu,is,id,it,ja,kn,km,ko,lo,lt,lv,ml,ms,mi,mn,no,pl,pt_PT,pt_BR,ro,ru,mi,sr,sk,sl,so,es,sv,tl,ta,th,mi_NZ,tr,uk,vi}
        LOCALE_LANG=("Afrikaans" "Albanian" "Arabic" "Basque" "Belarusian" "Bosnian" "Bulgarian" "Catalan" "Croatian" "Chinese (Simplified)" "Chinese (Traditional)" "Czech" "Danish" "Dutch" "English" "Estonian" "Farsi" "Filipino" "Finnish" "French(FR)" "French (CH)" "French (BE)" "French (CA)" "Gaelic" "Gallego" "Georgian" "German" "Greek" "Gujarati" "Hebrew" "Hindi" "Hungarian" "Icelandic" "Indonesian" "Italian" "Japanese" "Kannada" "Khmer" "Korean" "Lao" "Lithuanian" "Latvian" "Malayalam" "Malaysian" "Maori" "Mongolian" "Norwegian" "Polish" "Portuguese" "Portuguese (Brazil)" "Romanian" "Russian" "Samoan" "Serbian" "Slovak" "Slovenian" "Somali" "Spanish" "Swedish" "Tagalog" "Tamil" "Thai" "Tongan" "Turkish" "Ukrainian" "Vietnamese");
        LOCALE_CODES=("af_ZA" "sq_AL" "ar_SA" "eu_ES" "be_BY" "bs_BA" "bg_BG" "ca_ES" "hr_HR" "zh_CN" "zh_TW" "cs_CZ" "da_DK" "nl_NL" "en_US" "et_EE" "fa_IR" "ph_PH" "fi_FI" "fr_FR" "fr_CH" "fr_BE" "fr_CA" "ga" "gl_ES" "ka_GE" "de_DE" "el_GR" "gu" "he_IL" "hi_IN" "hu" "is_IS" "id_ID" "it_IT" "ja_JP" "kn_IN" "km_KH" "ko_KR" "lo_LA" "lt_LT" "lv" "ml_IN" "ms_MY" "mi_NZ" "no_NO" "pl" "pt_PT." "pt_BR" "ro_RO" "ru_RU" "mi_NZ" "sr_CS" "sk_SK" "sl_SI" "so_SO" "es_ES" "sv_SE" "tl" "ta_IN" "th_TH" "mi_NZ" "tr_TR" "uk_UA" "vi_VN");
        LOCALE_LANG[$[${#LOCALE_LANG[@]}]]="Not-in-List" # No Spaces
        PS3="$prompt1"
        echo "Select your Language Locale:"
        select LOCALE in "${LOCALE_LANG[@]}"; do
            if contains_element "$LOCALE" ${LOCALE_LANG[@]}; then
                is_last_item "LOCALE_LANG[@]" "$LOCALE"
                if [[ $? -ne 1 ]]; then
                    get_index "LOCALE_LANG[@]" "$LOCALE"
                    LOCALE=${LOCALE_CODES[$(($?))]}
                    return 0
                else
                    return 1
                fi
                break
            else
                invalid_option "$LOCALE"
            fi
        done
    }
    #}}}    
    #LANGUAGE SELECTOR {{{
    language_selector()
    {
        #       
        print_title "LANGUAGE/LOCALE - https://wiki.archlinux.org/index.php/Locale"
        print_info $"Locales are used in Linux to define which language the user uses."
        print_info $"As the locales define the character sets being used as well, setting up the correct locale is especially important if the language contains non-ASCII characters."
        print_info $"We can only initize those Locales that are Available, if not in list, Install Language and rerun script."
        print_info $"First list shows all Available Languages, if yours is not in list choose No, then a full list will appear."
        print_info $"Pick your Primary Language first, then you have an option to select as many languages as you wish."
        #
        read_input_yn "Use Default System Language: ${LANGUAGE}" 1
        if [[ $YN_OPTION -eq 1 ]]; then
            LOCALE="$LANGUAGE"
            set_language "$LOCALE"
        else
            get_locales_list
            read_input_default "Edit System Language [ex: en_US]: " "$LOCALE"
            set_language "$LOCALE"
        fi
    }
    #}}}
    #
    language_selector
    #
    YN_OPTION=0 
    while [[ $YN_OPTION -ne 1 ]]; do
        if [ "${#LOCALE_ARRAY}" -eq 0 ]; then
            LOCALE_ARRAY=( "$LOCALE" )
        else
            LOCALE_ARRAY=( "${LOCALE_ARRAY[@]}" "$LOCALE" )
        fi
        read_input_yn "Add more Locales" 0
        if [[ $YN_OPTION -eq 1 ]]; then
            get_locales_list
            read_input_default "Edit system language [ex: en_US]: " "$LOCALE"
            read_input_yn "Confirm Language Locale: $LOCALE" 1
            if [[ $YN_OPTION -eq 0 ]]; then
               LOCALE="NONE"
            fi
            YN_OPTION=0
        else
            YN_OPTION=1
            break;
        fi
    done
}    
#}}}
# -----------------------------------------------------------------------------
# GET FORMAT TYPE {{{
# USAGE      : get_format_type
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_format_type()
{
   case "$1" in
       ext4)
           OPTION="8300" # Linux System
           ;;
       ext3)
           OPTION="8300"
           ;;
       ext2)
           OPTION="8300"
           ;;
       Btrfs)
           OPTION="8300"
           ;;
       vfat)
           OPTION="0700" # Windoze System
           ;;
       NTFS)
           OPTION="0700"
           ;;
       *)
           echo "format not recognized."
           OPTION="8300"
           ;;
   esac 
}
#}}}
# -----------------------------------------------------------------------------
# GET FORMAT SYSTEM {{{
# USAGE      : get_format_system
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_format_system()
{
    print_info $"https://wiki.archlinux.org/index.php/File_Systems"
    print_info $"ext2  Second Extended Filesystem is an established, mature GNU/Linux filesystem that is very stable."
    print_info $"      A drawback is that it does not have journaling support or barriers."
    print_info $"      Lack of journaling can result in data loss in the event of a power failure or system crash."
    print_info $"      It may also be inconvenient for root (/) and /home partitions because file-system checks can take a long time."
    print_info $"      An ext2 filesystem can be converted to ext3."
    print_info $"ext3  Third Extended Filesystem is essentially the ext2 system with journaling support and write barriers."
    print_info $"      It is backward compatible with ext2, well tested, and extremely stable."
    print_info $"ext4  Fourth Extended Filesystem is a newer filesystem that is also compatible with ext2 and ext3."
    print_info $"      It provides support for volumes with sizes up to 1 exabyte (i.e. 1,048,576 terabytes) and files sizes up to 16 terabytes."
    print_info $"      It increases the 32,000 subdirectory limit in ext3 to 64,000. It also offers online defragmentation capability."
    print_info $"Btrfs Also known as 'Better FS', Btrfs is a new filesystem with powerful features similar to Sun/Oracle's excellent ZFS."
    print_info $"      These include snapshots, multi-disk striping and mirroring (software RAID without mdadm), checksums, incremental backup,"
    print_info $"      and on-the-fly compression that can give a significant performance boost as well as save space."
    print_info $"      As of January 2011, Btrfs is considered unstable although it has been merged into the mainline kernel with an experimental status."
    print_info $"      Btrfs appears to be the future of GNU/Linux filesystems and is offered as a root filesystem option in all major distribution installers."
    print_info $"vfat  or Virtual File Allocation Table is technically simple and supported by virtually all existing operating systems."
    print_info $"      This makes it a useful format for solid-state memory cards and a convenient way to share data between operating systems."
    print_info $"      VFAT supports long file names."
    print_info $"NTFS  File system used by windows. Mountable with many utilities (e.g. NTFS-3G)."
    echo ""
    PS3="$prompt1"
    echo "Select Format Type:"
    declare -a FILE_SYSTEMS=("ext4" "ext3" "ext2" "btrfs" "vfat" "ntfs");
    select FILE_SYSTEM in "${FILE_SYSTEMS[@]}"; do
        if contains_element "$FILE_SYSTEM" ${FILE_SYSTEMS[@]}; then
            OPTION="$FILE_SYSTEM"
            break
        else
            invalid_option "$FILE_SYSTEM"
        fi
    done
}
#}}}
# -----------------------------------------------------------------------------
# GET BOOT type {{{
# USAGE      : get_boot_type
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_boot_type()
{
    # GET BIOS SIZE {{{
    get_bios_size()
    {
        print_info $"https://wiki.archlinux.org/index.php/GRUB2#GPT_specific_instructions"
        print_info $"GRUB2 in BIOS-GPT configuration requires a BIOS Boot Partition to embed its core.img in the absence of post-MBR gap in GPT partitioned systems (which is taken over by the GPT Primary Header and Primary Partition table)."
        print_info $"This partition is used by GRUB2 only in BIOS-GPT setups."
        print_info $"No such partition type exists in case of MBR partitioning (at least not for GRUB2)."
        print_info $"This partition is also not required if the system is UEFI based, as no embedding of bootsectors takes place in that case."
        print_info $"Syslinux does not require this partition."
        print_info $"You can boot using BIOS or UEFI if you have a UEFI BIOS, setup depends on type of Boot System."
        BOOT_SYSTEM_TYPES=("Grub2" "Syslinux" "Skip");
        PS3="$prompt1"
        echo -e "Select a Boot BIOS System Type:\n"
        select OPT in "${BOOT_SYSTEM_TYPES[@]}"; do
            case "$REPLY" in
                1)
                    BOOT_SYSTEM_TYPE=0
                    print_info $"Specify BIOS Partition size as such: 1M or 1G"
                    read_input_default "BIOS Recommened Size: [2M] " "2M"
                    BIOS_SIZE="$OPTION"
                    break
                    ;;
                2)
                    BOOT_SYSTEM_TYPE=1
                    break
                    ;;
                3)
                    BOOT_SYSTEM_TYPE=2
                    break
                    ;;
                *)
                    invalid_option "$REPLY"
                    ;;
                    esac
        done
        unset BOOT_SYSTEM_TYPES
    }
    #}}}
    # GET UEFI SIZE {{{
    get_uefi_size()
    {
        print_info $"The UEFISYS partition can be of any size supported by FAT32 filesystem."
        print_info $"According to Microsoft Documentation, the minimum partition/volume size for FAT32 is 512 MiB."
        print_info $"Therefore it is recommended for UEFISYS partition to be atleast 512 MiB."
        print_info $"Higher partition sizes are fine, especially if you use multiple UEFI bootloaders, or multiple OSes booting via UEFI, so that there is enough space to hold all the related files."
        print_info $"If you are using Linux EFISTUB booting, then you need to make sure there is adequate space available for keeping the Kernel and Initramfs files in the UEFISYS partition."   
        print_info $"Specify UEFI Partition size as such: 512M or 1G"
        read_input_default "UEFI Minimal Size: [512M] " "512M"
        UEFI_SIZE="$OPTION"
    }
    #}}}
    # GET UEFI SIZE {{{
    get_boot_menu()
    {
        BIOS_SYSTEM_TYPES=("UEFI" "BIOS" "NONE");
        PS3="$prompt1"
        echo -e "Select a Boot BIOS System Type:\n"
        select OPT in "${BIOS_SYSTEM_TYPES[@]}"; do
            case "$REPLY" in
                1)
                    UEFI=1
                    break
                    ;;
                2)
                    UEFI=2
                    break
                    ;;
                3)
                    UEFI=0
                    break
                    ;;
               *)
                    invalid_option "$REPLY"
                    ;;
                    esac
        done
        unset BIOS_SYSTEM_TYPES
    }
    #}}}
    print_title "https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface and https://wiki.archlinux.org/index.php/UEFI_Bootloaders"
    print_info $"Unified Extensible Firmware Interface (or UEFI for short) is a new type of firmware that was initially designed by Intel (known as EFI then) mainly for its Itanium based systems."
    print_info $"It introduces new ways of booting an OS that is distinct from the commonly used 'MBR boot code' method followed for BIOS systems."
    print_info $"It started as Intel's EFI in versions 1.x and then a group of companies called the UEFI Forum took over its development from which it was called Unified EFI starting with version 2.0 ."
    print_info $"As of 23 May 2012, UEFI Specification 2.3.1 is the most recent version."
    echo ""
    print_info $"The NONE Option will not create a Boot Partition, it will install a Bootloader on the root partition."
    print_info $"You have 3 Options for Boot Mode: UEFI (if you have a UEFI BIOS, Recommended), BIOS, or None (Installing to root, not recommended)."
    echo ""
    if [[ "$UEFI" -eq 1 ]]; then # set before it gets here
        read_input_yn "Default is UEFI, do you wish to change Boot Mode" 0
        if [[ "$YN_OPTION" -eq 1 ]]; then
            get_boot_menu
        fi
    elif [[ "$UEFI" -eq 2 ]]; then 
        print_warning "Your Motherboard failed to register in UEFI Mode, so this script will only be able to use BIOS Mode or None."
        print_warning "\tYou do not have a UEFI Bios, switching to BIOS Mode."
        print_warning "\tYou have an Option have no partition for Boot, this will force it to load to the Root, this is not recommended, but an option."
        read_input_yn "Default is BIOS mode, do you wish to change Boot to NONE? " 0
        if [[ "$YN_OPTION" -eq 1 ]]; then
            UEFI=0
        fi
    fi
    if [[ "$UEFI" -eq 1 ]]; then 
        get_uefi_size    # BOOT_SYSTEM_TYPE and BIOS_SIZE
    elif [[ "$UEFI" -eq 2 ]]; then 
        get_bios_size    # BOOT_SYSTEM_TYPE and BIOS_SIZE
    fi
}
#}}}
# -----------------------------------------------------------------------------
# GET BOOT PARTITION {{{
# USAGE      : get_boot_partition
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_boot_partition()
{
    print_title "https://wiki.archlinux.org/index.php/Partitioning#.2Fboot"
    print_info $"The /boot directory contains the kernel and ramdisk images as well as the bootloader configuration file and bootloader stages."
    print_info $"It also stores data that is used before the kernel begins executing user-space programs."
    print_info $"/boot is not required for normal system operation, but only during boot and kernel upgrades (when regenerating the initial ramdisk)."
    print_info $"If kept on a separate partition, /boot does not require a journaled file system."
    print_info $"A separate /boot partition is needed if installing a software RAID0 (stripe) system."
    print_info $"Do not confuse BOOT with UEFI or BIOS Boot strap, where as BOOT contains the Kernels, UEFI and BIOS contain Grub only."
    IS_BOOT_PARTITION=0
    read_input_yn "Use boot on a separate Partition?" 1
    if [[ $YN_OPTION -eq 1 ]]; then
        IS_BOOT_PARTITION=1
        # Ask for Boot Size
        print_info $"Specify BOOT Partition size as such: 100M or 1G"
        read_input_default "BOOT Size: [100M] " "100M"
        BOOT_SIZE="$OPTION"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# GET SWAP PARTITION {{{ 
# USAGE      : get_swap_partition
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_swap_partition()
{
    print_title "https://wiki.archlinux.org/index.php/Partitioning#Swap"
    print_info $"The swap partition provides memory that can be used as virtual RAM. It is recommended for PCs with 1GB or less of physical RAM."
    print_info $"Historically, the general rule for swap partition size was to allocate twice the amount of physical RAM."
    print_info $"As computers have gained ever larger memory capacities, this rule has become deprecated."
    print_info $"On machines with up to 512MB RAM, the 2x rule is usually adequate."
    print_info $"If a sufficient amount of RAM (more than 1024MB) is available, it may be possible to have a smaller swap partition or even eliminate it."
    print_info $"With more than 2 GB of physical RAM, one can generally expect good performance without a swap partition."
    print_info $"There is always an option to create a swap file after the system is setup."
    IS_SWAP_PARTITION=0
    read_input_yn "Use SWAP?" 1
    if [[ $YN_OPTION -eq 1 ]]; then
        IS_SWAP_PARTITION=1
        RAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        # 16434612 kb
        if [[ "$RAM" -le 1048576 ]]; then  # 1 GB
            SWAP_SIZE_MIN="512M"
            SWAP_SIZE="1G"
        elif [[ "$RAM" -le 2097152 ]]; then  # 2 GB
            SWAP_SIZE_MIN="1G"
            SWAP_SIZE="2G"
        elif [[ "$RAM" -le 4194304 ]]; then  # 4 GB
            SWAP_SIZE_MIN="2G"
            SWAP_SIZE="4G"
        elif [[ "$RAM" -le 8388608 ]]; then  # 8 GB
            SWAP_SIZE_MIN="4G"
            SWAP_SIZE="8G"
        elif [[ "$RAM" -le 16434612 ]]; then  # 16 GB
            SWAP_SIZE_MIN="8G"
            SWAP_SIZE="16G"
        elif [[ "$RAM" -le 33554432 ]]; then  # 32 GB
            SWAP_SIZE_MIN="16G"
            SWAP_SIZE="32G"
        elif [[ "$RAM" -le 67108864 ]]; then  # 64 GB
            SWAP_SIZE_MIN="32G"
            SWAP_SIZE="64G"
        fi
        
        echo ""
        print_info $"RAM size is $RAM"
        print_info $"Recommended [$SWAP_SIZE] Recommended Minimum [$SWAP_SIZE_MIN]"
        print_info $"Specify SWAP size as such: 512M or 16G"
        read_input_default "SWAP Size: " "$SWAP_SIZE"
        SWAP_SIZE="$OPTION"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# get HOME PARTITION {{{
# USAGE      : get_home_partition
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_home_partition()
{
    # GET HOME SIZE {{{
    get_home_size()
    {
        print_title "HOME - https://wiki.archlinux.org/index.php/Partitioning"
        print_info $"Specify HOME Partition size as such: 512M or 50G"
        print_info $"Specify 0 for all remaining space on drive, if no more partitions, use 0."
        read_input_default "HOME Size: [50G] " "50G"
        HOME_SIZE="$OPTION"
    }
    #}}}
    print_title "https://wiki.archlinux.org/index.php/Partitioning#.2Fhome"
    print_info $"The /home directory stores personal files in different folders."
    print_info $"It holds miscellaneous personal data as well as user-specific configuration files for applications."
    print_info $"Keeping it in a separate partition can be very useful for backup: it often requires the most disk space (for desktop users) and may need to be expanded at a later date."
    print_info $"You can also use HOME on a Separate Drive, in this case pick N, and  choose Y for home on a separate Drive and the below will be commented in your fstab for later editing."
    print_info $"UUID=(Your UUID)       /home   (FS type)    rw,errors=remount-ro    0       1"
    print_info $"UUID=(Your UUID)       /home   ext4         defaults,noatime        0       2"
    IS_HOME_PARTITION=0
    IS_HOME_DRIVE=0
    read_input_yn "Use home on a separate Partition?" 0
    if [[ $YN_OPTION -eq 0 ]]; then
        read_input_yn "Use home on a separate Drive?" 0
        [[ $YN_OPTION -eq 1 ]] && IS_HOME_DRIVE=1 
    else
        IS_HOME_PARTITION=1
        get_home_size     # Ask for HOME Size return HOME_SIZE
        get_format_system # Ask for Format Type
        HOME_FORMAT="$OPTION"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# GET VAR PARTITION {{{
# USAGE      : get_var_partition
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_var_partition()
{
    # GET VAR SIZE {{{
    get_var_size()
    {
        print_title "https://wiki.archlinux.org/index.php/Partitioning#.2Fvar"
        print_info $"Specify VAR Partition size as such: Minimum: 8-12 GB"
        read_input_default "VAR Size: [13G] " "13G"
        VAR_SIZE="$OPTION"
    }
    #}}}
    print_title "https://wiki.archlinux.org/index.php/Partitioning#.2Fvar"
    print_info $"The /var directory stores Contains variable data such as spool directories and files, administrative and logging data, pacman's cache, the ABS tree, etc."
    print_info $"It is used for example for caching and logging, and hence frequently read or written."
    print_info $"Keeping it in a separate partition avoids running out of disk space due to flunky logs, etc."
    print_info $"It exists to make it possible to mount /usr as read-only. Everything that historically went into /usr that is written to during system operation (as opposed to installation and software maintenance) must reside under /var."
    print_info $"You can also use VAR on a Separate Drive, good for Webservers, in this case pick N, and  choose Y for VAR on a separate Drive and the below will be commented in your fstab for later editing."
    print_info $"UUID=(Your UUID)       /var   (FS type)    rw,errors=remount-ro    0       1"
    print_info $"UUID=(Your UUID)       /var   ext4         defaults,noatime        0       2"
    IS_VAR_PARTITION=0
    IS_VAR_DRIVE=0
    read_input_yn "Use var on a separate Partition?" 0
    if [[ $YN_OPTION -eq 0 ]]; then
        read_input_yn "Use var on a separate Drive?" 0
        [[ $YN_OPTION -eq 1 ]] && IS_VAR_DRIVE=1 
    else
        IS_VAR_PARTITION=1
        get_var_size     # Ask for VAR Size return VAR_SIZE
        get_format_system # Ask for Format Type
        VAR_FORMAT="$OPTION"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# GET TMP PARTITION {{{
# USAGE      : get_tmp_partition
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_tmp_partition()
{
    # GET TMP SIZE {{{
    get_tmp_size()
    {
        RAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        let HALF_RAM=RAM/2
        print_title "https://wiki.archlinux.org/index.php/Fstab#tmpfs"
        print_info $"By default, a tmpfs partition has its maximum size set to half your total RAM, but this can be customized."
        print_info $"Note that the actual memory/swap consumption depends on how much you fill it up, as tmpfs partitions do not consume any memory until it is actually needed."
        print_info $"Specify TMP Partition size as such: Current RAM size is $RAM, half of that is $HALF_RAM"
        read_input_default "TMP Size: [${HALF_RAM}] " "${HALF_RAM}"
        TMP_SIZE="$OPTION"
    }
    #}}}
    print_title "https://wiki.archlinux.org/index.php/Partitioning#.2Ftmp"
    print_info $"Directory for programs that require temporary storage of files such as .lck , which can be used to prevent multiple instances of their respective program until a task is completed. Upon completion, the .lck file will be automatically removed."
    print_info $"Programs must not assume that any files or directories in /tmp are preserved between invocations of the program and files and directories located under /tmp will typically be deleted whenever the system is booted."
    print_info $"tmpfs:"
    print_info $"https://wiki.archlinux.org/index.php/Fstab#tmpfs"
    print_info $"tmpfs is a temporary filesystem that resides in memory and/or your swap partition(s), depending on how much you fill it up."
    print_info $"Mounting directories as tmpfs can be an effective way of speeding up accesses to their files, or to ensure that their contents are automatically cleared upon reboot."
    print_info $"Some directories where tmpfs is commonly used are /tmp, /var/lock and /var/run."
    print_info $"Do NOT use it on /var/tmp, because that folder is meant for temporary files that are preserved across reboots."
    print_info $"Arch uses a tmpfs /run directory, with /var/run and /var/lock simply existing as symlinks for compatibility."
    print_info $"It is also used for /tmp in the default /etc/fstab."
    print_info $"By default, a tmpfs partition has its maximum size set to half your total RAM, but this can be customized."
    print_info $"Note that the actual memory/swap consumption depends on how much you fill it up, as tmpfs partitions do not consume any memory until it is actually needed."
    print_info $"To use tmpfs for /tmp, add this line to /etc/fstab:"
    print_info $"tmpfs                  /tmp     tmpfs      nodev,nosuid            0       0"
    print_info $"You may or may not wish to specify the size here, but you should leave the mode option alone in these cases to ensure that they have the correct permissions (1777)."
    print_info $"In the example above, /tmp will be set to use up to half of your total RAM. To explicitly set a maximum size, use the size mount option:"
    print_info $"tmpfs   /tmp         tmpfs   nodev,nosuid,size=2G          0  0"
    print_info $"Here is a more advanced example showing how to add tmpfs mounts for users. This is useful for websites, mysql tmp files, ~/.vim/, and more."
    print_info $"It's important to try and get the ideal mount options for what you are trying to accomplish."
    print_info $"The goal is to have as secure settings as possible to prevent abuse. Limiting the size, and specifying uid and gid + mode is very secure."
    print_info $"tmpfs   /www/cache    tmpfs  rw,size=1G,nr_inodes=5k,noexec,nodev,nosuid,uid=648,gid=648,mode=1700   0  0"
    print_info $""
    print_info $"The Default is to use tmpfs."
    IS_TMP_PARTITION=0
    IS_TMP_SIZE=0
    read_input_yn "Use tmp as tmpfs?" 1
    if [[ $YN_OPTION -eq 1 ]]; then
        read_input_yn "Set size of tmpfs?" 0
        if [[ $YN_OPTION -eq 1 ]]; then
            get_TMP_size     # Ask for TMP Size return TMP_SIZE
            IS_TMP_SIZE=1
        fi
    else
        # @FIX now what
        IS_TMP_PARTITION=1
        get_TMP_size     # Ask for TMP Size return TMP_SIZE
        get_format_system # Ask for Format Type
        TMP_FORMAT="$OPTION"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# GET ROOT SIZE {{{
# USAGE      : get_root_size
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_root_size()
{
    print_title "https://wiki.archlinux.org/index.php/Partitioning#.2F_.28root.29"
    print_info $"The root directory is the top of the hierarchy, the point where the primary filesystem is mounted and from which all other filesystems stem."
    print_info $"All files and directories appear under the root directory /, even if they are stored on different physical devices."
    print_info $"The contents of the root filesystem must be adequate to boot, restore, recover, and/or repair the system."
    print_info $"Therefore, certain directories under / are not candidates for separate partitions."
    print_info $"The / partition or root partition is necessary and it is the most important."
    print_info $"The other partitions can be replaced by it, even though having different partitions is recommended."
    print_info $"Specify ROOT Partition size as such: 512M or 50G"
    print_info $"Specify 0 for all remaining space on drive, if no more partitions, use 0."
    #
    read_input_default "ROOT Size: Default is remaining space [0] " "0"
    ROOT_SIZE="$OPTION"
    get_format_system # Ask for Format Type
    ROOT_FORMAT="$OPTION"
}
#}}}
# -----------------------------------------------------------------------------
# STATIC IP {{{
# USAGE      : static_ip
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
static_ip()
{
    while [[ 1 ]]; do
        print_title "https://wiki.archlinux.org/index.php/Configuring_Network#Static_IP_address"
        print_info $"Available NIC's"
        if [[ -n $check_eth0  ]]; then
            echo "device eth0 active $check_eth0"
        fi
        if [[ -n $check_eth1  ]]; then
            echo "device eth1 active $check_eth1"
        fi
        if [[ -n $check_eth2  ]]; then
            echo "device eth2 active $check_eth2"
        fi
        read_input_default "Enter NAMESERVER 1 [123.123.123.123]: " "$CUSTOM_NS1"
        CUSTOM_NS1="$OPTION"
        read_input_default "Enter NAMESERVER 2 [123.123.123.123]: " "$CUSTOM_NS2"
        CUSTOM_NS2="$OPTION"

        read_input_yn "Is this correct" 1
        if [[ $YN_OPTION -eq 1 ]]; then
            break
        fi
    done    
}
#}}}
# -----------------------------------------------------------------------------
# READ NAMESERVERS {{{
# USAGE      : read_nameserver
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
read_nameserver()
{
    CUSTOM_NS1=" "; CUSTOM_NS2=" "; CUSTOM_NS_SEARCH=" "
    if [[ -f "$SCRIPT_DIR/nameservers.txt" ]]; then
        N=1
        while read line; do 
            case "$N" in
                1)
                    CUSTOM_NS1="$line"
                    ;;
                2)
                    CUSTOM_NS2="$line"
                    ;;
                3)
                    CUSTOM_NS_SEARCH="$line"
                    break;
                    ;;
               *)
                    break;
                    ;;
            esac                                        
            N=$((N+1))
        done < "$SCRIPT_DIR/nameservers.txt"
    else
        CUSTOM_NS1=" "
        CUSTOM_NS2=" "
        CUSTOM_NS_SEARCH=" "
    fi
}
#}}}
# -----------------------------------------------------------------------------
# CUSTOM NAMESERVERS {{{
# USAGE      : custom_nameservers
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
custom_nameservers()
{
    write_nameserver()
    {
        touch "$SCRIPT_DIR/nameservers.txt" # Create if not exist, then update it
        if [[ "$DRIVE_FORMATED" -eq 1 ]]; then
            chattr -i /etc/resolv.conf
            echo "# Created: $DATE_TIME" > "/etc/resolv.conf"
            echo "# /etc/resolv.conf" >> "/etc/resolv.conf"
            echo "#" >> "/etc/resolv.conf"
            echo "# search <yourdomain.tld>" >> "/etc/resolv.conf"
            echo "# nameserver <ip>" >> "/etc/resolv.conf"
        else
            chattr -i $SCRIPT_DIR/etc/resolv.conf
            echo "# Created: $DATE_TIME" > "$SCRIPT_DIR/etc/resolv.conf"
            echo "# /etc/resolv.conf" >> "$SCRIPT_DIR/etc/resolv.conf"
            echo "#" >> "$SCRIPT_DIR/etc/resolv.conf"
            echo "# search <yourdomain.tld>" >> "$SCRIPT_DIR/etc/resolv.conf"
            echo "# nameserver <ip>" >> "$SCRIPT_DIR/etc/resolv.conf"
        fi
        # Write settings
        if [[ -n "$CUSTOM_NS1" ]]; then
            echo "$CUSTOM_NS1" > "$SCRIPT_DIR/nameservers.txt"
            echo "nameserver $CUSTOM_NS1" >> "$SCRIPT_DIR/etc/resolv.conf"
            if [[ "$DRIVE_FORMATED" -eq 1 ]]; then
                echo "nameserver $CUSTOM_NS1" >> "/etc/resolv.conf"
            fi
        fi
        if [[ -n "$CUSTOM_NS2" ]]; then
            echo "$CUSTOM_NS2" >> "$SCRIPT_DIR/nameservers.txt"
            echo "nameserver $CUSTOM_NS2" >> "$SCRIPT_DIR/etc/resolv.conf"
            if [[ "$DRIVE_FORMATED" -eq 1 ]]; then
                echo "nameserver $CUSTOM_NS2" >> "/etc/resolv.conf"
            fi
        fi
        if [[ -n "$CUSTOM_NS_SEARCH" ]]; then
            echo "$CUSTOM_NS_SEARCH" >> "$SCRIPT_DIR/nameservers.txt"
            echo "nameserver $CUSTOM_NS_SEARCH" >> "$SCRIPT_DIR/etc/resolv.conf"
            if [[ "$DRIVE_FORMATED" -eq 1 ]]; then
                echo "search $CUSTOM_NS_SEARCH" >> "/etc/resolv.conf"
            fi
        fi
        # 
        echo "# End of file" >> "$SCRIPT_DIR/etc/resolv.conf"
        if [[ "$DRIVE_FORMATED" -eq 1 ]]; then
            echo "# End of file" >> /etc/resolv.conf
            chattr +i /etc/resolv.conf
        else
            chattr +i $SCRIPT_DIR/etc/resolv.conf
        fi
    }
    while [[ 1 ]]; do
        print_title "https://wiki.archlinux.org/index.php/Resolv.conf"
        print_info $"The resolver is a set of routines in the C library that provide access to the Internet Domain Name System (DNS)."
        print_info $"The resolver configuration file contains information that is read by the resolver routines the first time they are invoked by a process."
        print_info $"The file is designed to be human readable and contains a list of keywords with values that provide various types of resolver information."
        print_info $"On a normally configured system this file should not be necessary."
        print_info $"The only name server to be queried will be on the local machine; the domain name is determined from the host name and the domain search path is constructed from the domain name."
        print_info $"OpenDNS servers 208.67.222.222 and 208.67.220.220"
        print_info $"Google nameservers 8.8.8.8 and 8.8.4.4"
        print_info $"Or use the ones form your Local ISP, or own DNS Servers."
        print_warning "You must enter two nameservers corectly, no validation is done!"
        read_input_yn "Use custom nameserers?" 1
        if [[ $YN_OPTION -eq 1 ]]; then
            IS_CUSTOM_NAMESERVER=1
            read_nameserver
            read_input_default "Enter NAMESERVER 1 [123.123.123.123]: " "$CUSTOM_NS1"
            CUSTOM_NS1=$(trim "$OPTION")
            read_input_default "Enter NAMESERVER 2 [123.123.123.123]: " "$CUSTOM_NS2"
            CUSTOM_NS2=$(trim "$OPTION")
            read_input_default "Enter Search [ex: (sub-domain.)url.tdl or Blank (enter) for none]: " "$CUSTOM_NS_SEARCH"
            CUSTOM_NS_SEARCH=$(trim "$OPTION")
            read_input_yn "Is this correct" 1
            if [[ $YN_OPTION -eq 1 ]]; then
                write_nameserver
                if [[ "$DRIVE_FORMATED" -eq 1 ]]; then
                    cat /etc/resolv.conf
                else
                    cat ${SCRIPT_DIR}/etc/resolv.conf
                fi
                break
            fi
        else
            if [[ "$MOUNTPOINT" != " " ]]; then
                copy_file "/etc/resolv.conf" ${MOUNTPOINT}"/etc/resolv.conf" "$LINENO"
            fi
            break
        fi
    done
}
#}}}
# -----------------------------------------------------------------------------
# GET FLESH {{{
# USAGE      : get_flesh
# DESCRIPTION: Set FLESH, so Custom User Settings can be Created, add some Flesh to this Bare Bones Skeleton
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_flesh()
{
    print_title "https://wiki.archlinux.org/index.php/Pacman_Tips"
    print_info $"The Basic Bare Bones Skeleton install is good, but its best to add some Flesh to it, by Customizing the user folder with some extra Configuration from helmuthdu, and Flesher."
    read_input_yn "Install Flesh" 1
    if [[ "$YN_OPTION" -eq 1 ]]; then
        FLESH=1    
    fi
}
#}}}
# -----------------------------------------------------------------------------
# CUSTOM REPOSITORIES {{{
# USAGE      : add_custom_repositories
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
add_custom_repositories()
{
    # ENABLE MULTILIB REPOSITORY {{{
    # this option will avoid any problem with packages install
    if [[ $ARCHI == x86_64 ]]; then
        multilib=`grep -n "\[multilib\]" $MOUNTPOINT/etc/pacman.conf | cut -f1 -d:`
        if $multilib &> /dev/null; then
            echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> $MOUNTPOINT/etc/pacman.conf
            echo -e '\nMultilib repository added into pacman.conf file'
        else
            sed -i "${multilib}s/^#//" $MOUNTPOINT/etc/pacman.conf
            multilib=$(( $multilib + 2 ))
            sed -i "${multilib}s/^#//" $MOUNTPOINT/etc/pacman.conf
        fi
    fi
    #}}}
    print_title "CUSTOM REPOSITORIES - https://wiki.archlinux.org/index.php/Unofficial_User_Repositories"
    read_input_yn "Add custom repositories" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        while [[ 1 ]]; do
            print_title "CUSTOM REPOSITORIES - https://wiki.archlinux.org/index.php/Unofficial_User_Repositories"
            print_info $"Do not add /\$arch to the end, the script will do that for you." 
            echo "Add new repository"
            echo ""
            echo " D. DONE"
            echo ""
            read -p "$prompt1" OPTION
            case $OPTION in
                1)
                    # @FIX add error handling and exit without changes
                    read -p "Repository Name [ex: custom]: " REPONAME
                    read -p "Repository Address [ex: http://domain.url.tdl/archlinux]: " REPOADDRESS
                    echo -e '\n['"$REPONAME"']\nServer = '"$REPOADDRESS"/'$arch' >> $MOUNTPOINT/etc/pacman.conf
                    echo -e '\nCustom repository added into pacman.conf file'
                    pause_function "$LINENO"
                    ;;
              "d")
                    break
                    ;;
                *)
                    invalid_option "$OPTION"
                    ;;
            esac
        done
    fi
    # pacstrap will overwrite pacman.conf so copy it to temp 
    copy_file $MOUNTPOINT"/etc/pacman.conf" "$SCRIPT_DIR/etc/pacman.conf" "$LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# BACKUP FILES {{{
# USAGE      : backup_files
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
backup_files()
{
    # backup old configs
    [[ ! -f /etc/pacman.conf.aui ]] && copy_file "/etc/pacman.conf" "/etc/pacman.conf.aui" "$LINENO" || echo "/etc/pacman.conf.aui";
    [[ -f /etc/ssh/sshd_config.aui ]] && echo "/etc/ssh/sshd_conf.aui";
    [[ -f /etc/X11/xorg.conf.d/10-evdev.conf.aui ]] && echo "/etc/X11/xorg.conf.d/10-evdev.conf.aui";
}
#}}}
# -----------------------------------------------------------------------------
# DEVICE LIST {{{
# USAGE      : device_list
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
device_list()
{
    # Get all SD devices
    LIST_ALL_DEVICES=`ls /dev/sd*`
    # List: /dev/sda /dev/sda1 /dev/sda2 /dev/sdb /dev/sdb1
    LIST_DEVICES=( "" )
    arr=$(echo $LIST_ALL_DEVICES | tr " " "\n")
    for x in $arr; do
        if [[ "${#x}" -eq 8 ]]; then
            if [ -z "$LIST_DEVICES" ]; then
                if [[ `cat /sys/block/${x: -3}/removable` == "1" ]]; then
                    if [[ "$SCRIPT_DEVICE" == "${x: -3}" ]]; then
                        LIST_DEVICES[0]="${x: -3} Removable Device Script is Exexcuting."
                    else
                        LIST_DEVICES[0]="${x: -3} Removable"
                    fi
                else
                    if [[ "$SCRIPT_DEVICE" == "${x: -3}" ]]; then
                        LIST_DEVICES[0]="${x: -3} Device Script is Exexcuting."
                    else
                        LIST_DEVICES[0]="${x: -3}"
                    fi
                fi
            else
                if [[ `cat /sys/block/${x: -3}/removable` == "1" ]]; then
                    if [[ "$SCRIPT_DEVICE" == "${x: -3}" ]]; then
                        LIST_DEVICES[$[${#LIST_DEVICES[@]}]]="${x: -3} Removable Device Script is Exexcuting."
                    else
                        LIST_DEVICES[$[${#LIST_DEVICES[@]}]]="${x: -3} Removable"
                    fi
                else
                    if [[ "$SCRIPT_DEVICE" == "${x: -3}" ]]; then
                        LIST_DEVICES[$[${#LIST_DEVICES[@]}]]="${x: -3} Device Script is Exexcuting."
                    else
                        LIST_DEVICES[$[${#LIST_DEVICES[@]}]]="${x: -3}"
                    fi
                fi
            fi
        fi
    done    
}
#}}}
# -----------------------------------------------------------------------------
# ESCAPE SED {{{
# USAGE      : escape_sed
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
escape_sed() 
{
    sed -e 's/\//\\\//g' -e 's/\&/\\\&/g'
}
# ESCAPE SPECIAL CHARACTERS  {{{
# USAGE      : escape_special_characters
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
escape_special_characters()
{
    # Pass in string, iterate it and replace all special characters with escape
    total=${#1}
    for (( index=0; index<${total}; index++ )); do
        case \"$LANGUAGE\" in
            de_DE)
            ;;
        esac
        
    done
}
#}}}
# -----------------------------------------------------------------------------
# WRITE SECRET  {{{
# USAGE      : write_secret
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
write_secret()
{
    # @FIX Add encryption and escape_special_characters
    if [[ "$1" == "root_user" ]]; then
        # ROOTPASSWD=`echo "$ROOTPASSWD" | openssl enc -base64` # encryption
        touch "${MOUNTPOINT}/install_scripts_root_secrets"
        #echo "ROOTPASSWD=`echo \"\$ROOTPASSWD\" | tr \"!\" \"\!\"`" > "${MOUNTPOINT}/install_scripts_root_secrets"
        echo "echo -e \"$ROOTPASSWD\n$ROOTPASSWD\" | passwd root" > "${MOUNTPOINT}/install_scripts_root_secrets"
    elif [[ "$1" == "user_user" ]]; then
        # USERPASSWD=`echo "$USERPASSWD" | openssl enc -base64` # encryption
        touch "${MOUNTPOINT}/install_scripts_user_secrets"
        #echo "USERPASSWD=`echo \"\$USERPASSWD\" | tr \"!\" \"\!\"`" > "${MOUNTPOINT}/install_scripts_root_secrets"
        echo "echo -e \"$USERPASSWD\n$USERPASSWD\" | passwd $USERNAME" > "${MOUNTPOINT}/install_scripts_user_secrets"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# GET SECRET {{{
# USAGE      : get_secret
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_secret()
{
    # @FIX Add decryption escape special characters
    if [[ "$1" == "root_user" ]]; then
        # ROOTPASSWD=`echo "$ROOTPASSWD" | openssl enc -base64 -d` # decrypt
        source install_scripts_root_secrets
    elif [[ "$1" == "user_user" ]]; then
        # USERPASSWD=`echo "$USERPASSWD" | openssl enc -base64 -d` # decrypt
        source install_scripts_user_secrets
    fi
}
#}}}
# -----------------------------------------------------------------------------
# DELETE SECRET  {{{
# USAGE      : delete_secret
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
delete_secret()
{
    if [[ "$1" == "root_user" ]]; then
        rm "${MOUNTPOINT}/install_scripts_root_secrets"
    elif [[ "$1" == "user_user" ]]; then
        rm "${MOUNTPOINT}/install_scripts_user_secrets"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# CREATE SCRIPT LIB {{{
# USAGE      : create_script_lib
# DESCRIPTION: Create Script to run in arch-chroot
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
create_script_lib()
{
    touch $MOUNTPOINT/install_scripts
    chmod a+x $MOUNTPOINT/install_scripts
    echo "#!/bin/bash" > $MOUNTPOINT/install_scripts
    echo "# install_scripts $SCRIPT_NAME Version: $SCRIPT_VERSION on $DATE_TIME This script will run from arch-chroot." >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    echo "declare -i REFRESH_REPO=1" >> $MOUNTPOINT/install_scripts
    echo "USERNAME=\"$USERNAME\"" >> $MOUNTPOINT/install_scripts
    echo "AUR_PACKAGE_FOLDER=\"$AUR_PACKAGE_FOLDER\"" >> $MOUNTPOINT/install_scripts
    # ------------------------- Library ------------------------------------------------ 
    echo "# *************** Library *****************************" >> $MOUNTPOINT/install_scripts
    echo "BWhite='\\e[1;37m'       # White" >> $MOUNTPOINT/install_scripts
    echo "White='\\e[0;37m'        # White" >> $MOUNTPOINT/install_scripts
    echo "BRed='\\e[1;31m'         # Red" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "pause_function()" >> $MOUNTPOINT/install_scripts
    echo "{ #{{{" >> $MOUNTPOINT/install_scripts
    echo "    print_line" >> $MOUNTPOINT/install_scripts
    echo "    read -e -sn 1 -p \"Press any key to continue (\$1)...\"" >> $MOUNTPOINT/install_scripts
    echo "} #}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #    
    echo "# READ INPUT YN {{{" >> $MOUNTPOINT/install_scripts
    echo "read_input_yn()" >> $MOUNTPOINT/install_scripts
    echo "{ " >> $MOUNTPOINT/install_scripts
    echo "    YN_OPTION=\"\$2\" # Set Default value" >> $MOUNTPOINT/install_scripts
    echo "    # GET INPUT YN {{{" >> $MOUNTPOINT/install_scripts
    echo "    get_input_yn()" >> $MOUNTPOINT/install_scripts
    echo "    {" >> $MOUNTPOINT/install_scripts
    echo "        echo ''" >> $MOUNTPOINT/install_scripts
    echo "        if [[ \"\$2\" == "1" ]]; then" >> $MOUNTPOINT/install_scripts
    echo "            read  -n 1 -p \"\$1 [Y/n]: \"" >> $MOUNTPOINT/install_scripts
    echo "        else" >> $MOUNTPOINT/install_scripts
    echo "            read  -n 1 -p \"\$1 [y/N]: \"" >> $MOUNTPOINT/install_scripts
    echo "        fi" >> $MOUNTPOINT/install_scripts
    echo "        YN_OPTION=`echo \"$REPLY\" | tr '[:upper:]' '[:lower:]'`" >> $MOUNTPOINT/install_scripts
    echo "        echo ''" >> $MOUNTPOINT/install_scripts
    echo "    }" >> $MOUNTPOINT/install_scripts
    echo "    #}}}" >> $MOUNTPOINT/install_scripts
    echo "    local R_OPTION=0" >> $MOUNTPOINT/install_scripts
    echo "    while [[ \"\$R_OPTION\" -ne 1 ]]; do" >> $MOUNTPOINT/install_scripts
    echo "        get_input_yn \"\$1\" \"\$2\"" >> $MOUNTPOINT/install_scripts
    echo "        if [ -z \"\$YN_OPTION\" ]; then" >> $MOUNTPOINT/install_scripts
    echo "            R_OPTION=1" >> $MOUNTPOINT/install_scripts
    echo "            YN_OPTION=\"\$2\"" >> $MOUNTPOINT/install_scripts
    echo "        elif [[ \"\$YN_OPTION\" == 'y' ]]; then" >> $MOUNTPOINT/install_scripts
    echo "            R_OPTION=1" >> $MOUNTPOINT/install_scripts
    echo "            YN_OPTION=1" >> $MOUNTPOINT/install_scripts
    echo "        elif [[ \"\$YN_OPTION\" == 'n' ]]; then" >> $MOUNTPOINT/install_scripts
    echo "            R_OPTION=1" >> $MOUNTPOINT/install_scripts
    echo "            YN_OPTION=0" >> $MOUNTPOINT/install_scripts
    echo "        else " >> $MOUNTPOINT/install_scripts
    echo "            R_OPTION=0" >> $MOUNTPOINT/install_scripts
    echo "            if [[ \"\$2\" -eq 1 ]]; then" >> $MOUNTPOINT/install_scripts
    echo "                print_warning \"Wrong Key, [Y]es or [n]o required.\"" >> $MOUNTPOINT/install_scripts
    echo "            else" >> $MOUNTPOINT/install_scripts
    echo "                print_warning \"Wrong Key, [y]es or [N]o required.\"" >> $MOUNTPOINT/install_scripts
    echo "            fi" >> $MOUNTPOINT/install_scripts
    echo "            pause_function \"\$LINENO\"" >> $MOUNTPOINT/install_scripts
    echo "        fi" >> $MOUNTPOINT/install_scripts
    echo "    done" >> $MOUNTPOINT/install_scripts
    echo "} " >> $MOUNTPOINT/install_scripts
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "# TRIM {{{" >> $MOUNTPOINT/install_scripts
    echo "trim()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    echo \$(rtrim \"\$(ltrim \"\$1\")\")" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    echo "# LEFT TRIM {{{" >> $MOUNTPOINT/install_scripts
    echo "ltrim()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    echo \"\$1\" | sed 's/^ *//g'" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    echo "# RIGHT TRIM {{{" >> $MOUNTPOINT/install_scripts
    echo "rtrim()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    echo \"\$1\" | sed 's/ *$//g'" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "# CHECK PACKAGE {{{" >> $MOUNTPOINT/install_scripts
    echo "check_package()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    # check if a package is already installed" >> $MOUNTPOINT/install_scripts
    echo "    for PACKAGE in \$1; do" >> $MOUNTPOINT/install_scripts
    echo "        pacman -Q \"\$PACKAGE\" &> /dev/null && return 0;" >> $MOUNTPOINT/install_scripts
    echo "    done" >> $MOUNTPOINT/install_scripts
    echo "    return 1" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts
    echo "#}}}" >> $MOUNTPOINT/install_scripts    
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "# PACKAGE REMOVE {{{" >> $MOUNTPOINT/install_scripts
    echo "package_remove()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts 
    echo "    REMOVE_PACKAGES=\" \"" >> $MOUNTPOINT/install_scripts
    echo "    for PACKAGE in \$1; do" >> $MOUNTPOINT/install_scripts
    echo "        if check_package \"\$PACKAGE\" ; then" >> $MOUNTPOINT/install_scripts
    echo "            REMOVE_PACKAGES=\"\$REMOVE_PACKAGES \$PACKAGE\"" >> $MOUNTPOINT/install_scripts
    echo "        fi" >> $MOUNTPOINT/install_scripts
    echo "    done" >> $MOUNTPOINT/install_scripts
    echo "    REMOVE_PACKAGES=\$(trim \"\$REMOVE_PACKAGES\")" >> $MOUNTPOINT/install_scripts
    echo "    for PACKAGE in \$REMOVE_PACKAGES; do" >> $MOUNTPOINT/install_scripts
    echo "        pacman -Rcsn --noconfirm \"\$PACKAGE\"" >> $MOUNTPOINT/install_scripts
    echo "    done" >> $MOUNTPOINT/install_scripts
    echo "} #}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "# PRINT LINE {{{" >> $MOUNTPOINT/install_scripts
    echo "print_line()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    printf \"%\$(tput cols)s\\n\"|tr ' ' '-'" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts 
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "# PRINT TITLE {{{" >> $MOUNTPOINT/install_scripts
    echo "print_title()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    clear" >> $MOUNTPOINT/install_scripts
    echo "    print_line" >> $MOUNTPOINT/install_scripts
    echo "    echo -e \"# \${BWhite}\$1\${White}\"" >> $MOUNTPOINT/install_scripts
    echo "    print_line" >> $MOUNTPOINT/install_scripts
    echo "    echo ''" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts 
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "# PRINT INFO {{{" >> $MOUNTPOINT/install_scripts
    echo "print_info()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    # Console width number" >> $MOUNTPOINT/install_scripts
    echo "    T_COLS=\`tput cols\`" >> $MOUNTPOINT/install_scripts
    echo "    echo -e \"\${BWhite}\$1\${White}\\n\" | fold -sw \$(( \$T_COLS - 18 )) | sed 's/^/\\t/'" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts 
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "# PRINT WARNING {{{" >> $MOUNTPOINT/install_scripts
    echo "print_warning()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts 
    echo "    # Console width number" >> $MOUNTPOINT/install_scripts
    echo "    T_COLS=\`tput cols\`" >> $MOUNTPOINT/install_scripts
    echo "    echo -e \"\${BRed}\$1\${White}\\n\" | fold -sw \$(( \$T_COLS - 1 ))" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts 
    echo "#}}}" >> $MOUNTPOINT/install_scripts   
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "#PACKMAN PACKAGE SIGNING {{{" >> $MOUNTPOINT/install_scripts
    echo "configure_pacman_package_signing()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    if [[ ! -d /etc/pacman.d/gnupg ]]; then" >> $MOUNTPOINT/install_scripts
    echo "        print_title \"PACMAN PACKAGE SIGNING - https://wiki.archlinux.org/index.php/Pacman-key\"" >> $MOUNTPOINT/install_scripts
    echo "        print_info \$\"Pacman-key is a new tool available with pacman 4. It allows the user to manage pacmans list of trusted keys in the new package signing implementation.\"" >> $MOUNTPOINT/install_scripts
    echo "        haveged -w 1024" >> $MOUNTPOINT/install_scripts
    echo "        pacman-key --init --keyserver pgp.mit.edu" >> $MOUNTPOINT/install_scripts
    echo "        pacman-key --populate archlinux" >> $MOUNTPOINT/install_scripts
    echo "        killall haveged" >> $MOUNTPOINT/install_scripts
    echo "        package_remove \"haveged\"" >> $MOUNTPOINT/install_scripts
    echo "    fi" >> $MOUNTPOINT/install_scripts
    echo "    echo \$\"Pacman Package Signing Configured\"" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "#SYSTEM UPDATE {{{" >> $MOUNTPOINT/install_scripts
    echo "system_upgrade()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    print_title \"UPDATING YOUR SYSTEM\"" >> $MOUNTPOINT/install_scripts
    echo "    pacman -Syu --noconfirm" >> $MOUNTPOINT/install_scripts
    echo "    REFRESH_REPO=0" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "# CONFIGURE AUR HELPER {{{" >> $MOUNTPOINT/install_scripts
    echo "configure_aur_helper()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    #
    if [[ "$AUR_HELPER" == 'yaourt' ]]; then
        echo "    if ! check_package \"yaourt\" ; then" >> $MOUNTPOINT/install_scripts
        # Run internal Command
        #echo "        package_install \"yajl namcap\"" >> $MOUNTPOINT/install_scripts
        echo "        pacman -D --asdeps yajl namcap" >> $MOUNTPOINT/install_scripts
        echo "        aur_download_packages \"package-query yaourt\"" >> $MOUNTPOINT/install_scripts
        echo "        pacman -D --asdeps package-query" >> $MOUNTPOINT/install_scripts
        echo "        if ! check_package \"yaourt\" ; then" >> $MOUNTPOINT/install_scripts
        echo "            echo \"Yaourt not installed. EXIT now\"" >> $MOUNTPOINT/install_scripts
        echo "            pause_function \"\$LINENO\"" >> $MOUNTPOINT/install_scripts
        echo "            return 1" >> $MOUNTPOINT/install_scripts
        echo "        fi" >> $MOUNTPOINT/install_scripts
        echo "    fi" >> $MOUNTPOINT/install_scripts
    elif [[ "$AUR_HELPER" == 'packer' ]]; then
        echo "    if ! check_package \"packer\" ; then" >> $MOUNTPOINT/install_scripts
        # Run internal Command
        #echo "        package_install \"git jshon\"" >> $MOUNTPOINT/install_scripts
        echo "        pacman -D --asdeps jshon" >> $MOUNTPOINT/install_scripts
        echo "        aur_download_packages \"packer\"" >> $MOUNTPOINT/install_scripts
        echo "        if ! check_package \"packer\" ; then" >> $MOUNTPOINT/install_scripts
        echo "            echo \"Packer not installed. EXIT now\"" >> $MOUNTPOINT/install_scripts
        echo "            pause_function \"\$LINENO\"" >> $MOUNTPOINT/install_scripts
        echo "            return 1" >> $MOUNTPOINT/install_scripts
        echo "        fi" >> $MOUNTPOINT/install_scripts
        echo "    fi" >> $MOUNTPOINT/install_scripts
    elif [[ "$AUR_HELPER" == 'pacaur' ]]; then
        echo "    if ! check_package \"pacaur\" ; then" >> $MOUNTPOINT/install_scripts
        #echo "        package_install \"yajl expac\"" >> $MOUNTPOINT/install_scripts
        echo "        pacman -D --asdeps yajl expac" >> $MOUNTPOINT/install_scripts
        echo "        # fix pod2man path" >> $MOUNTPOINT/install_scripts
        echo "        ln -s /usr/bin/core_perl/pod2man /usr/bin/" >> $MOUNTPOINT/install_scripts
        echo "        aur_download_packages \"cower pacaur\"" >> $MOUNTPOINT/install_scripts
        echo "        pacman -D --asdeps cower" >> $MOUNTPOINT/install_scripts
        echo "        if ! check_package \"pacaur\" ; then" >> $MOUNTPOINT/install_scripts
        echo "            echo \"Pacaur not installed. EXIT now\"" >> $MOUNTPOINT/install_scripts
        echo "            pause_function \"\$LINENO\"" >> $MOUNTPOINT/install_scripts
        echo "            return 1" >> $MOUNTPOINT/install_scripts
        echo "        fi" >> $MOUNTPOINT/install_scripts
        echo "    fi" >> $MOUNTPOINT/install_scripts
    fi
    echo "    return 0" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "# GET AUR PACKAGES {{{" >> $MOUNTPOINT/install_scripts
    echo "get_aur_packages()" >> $MOUNTPOINT/install_scripts
    echo "{ #{{{" >> $MOUNTPOINT/install_scripts
    echo "    #" >> $MOUNTPOINT/install_scripts
    echo "    echo \"Downloading: \$1.tar.gz from https://aur.archlinux.org/packages/\${1:0:2}/\$1/\$1.tar.gz\"" >> $MOUNTPOINT/install_scripts
    echo "    curl -o \$1.tar.gz https://aur.archlinux.org/packages/\${1:0:2}/\$1/\$1.tar.gz" >> $MOUNTPOINT/install_scripts
    echo "    if [ -f \"\$1.tar.gz\" ]; then" >> $MOUNTPOINT/install_scripts
    echo "        if tar zxvf \$1.tar.gz ; then" >> $MOUNTPOINT/install_scripts
    echo "            rm \$1.tar.gz" >> $MOUNTPOINT/install_scripts
    echo "            cd \$1" >> $MOUNTPOINT/install_scripts
    if [[ "$RUN_AUR_ROOT" -eq 1 ]]; then
        echo "            makepkg -si --noconfirm --asroot" >> $MOUNTPOINT/install_scripts
    else
        echo "            makepkg -si --noconfirm" >> $MOUNTPOINT/install_scripts
    fi    
    echo "         else" >> $MOUNTPOINT/install_scripts
    echo "             echo \"File Currupted: curl -o \$1.tar.gz https://aur.archlinux.org/packages/\${1:0:2}/\$1/\$1.tar.gz\"" >> $MOUNTPOINT/install_scripts
    echo "         fi" >> $MOUNTPOINT/install_scripts
    echo "    else" >> $MOUNTPOINT/install_scripts
    echo "        echo \"File Not Found: curl -o \$1.tar.gz https://aur.archlinux.org/packages/\${1:0:2}/\$1/\$1.tar.gz\"" >> $MOUNTPOINT/install_scripts
    echo "    fi" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    echo "export -f get_aur_packages" >> $MOUNTPOINT/install_scripts
    #    
    echo "# AUR PACKAGE INSTALL {{{" >> $MOUNTPOINT/install_scripts
    echo "aur_download_packages()" >> $MOUNTPOINT/install_scripts
    echo "{ #{{{" >> $MOUNTPOINT/install_scripts
    echo "    print_info 'AUR Package Install.'" >> $MOUNTPOINT/install_scripts
    echo "    for PACKAGE in \$1; do" >> $MOUNTPOINT/install_scripts
    echo "        if [ ! -d \$AUR_PACKAGE_FOLDER ]; then" >> $MOUNTPOINT/install_scripts
    echo "            mkdir \$AUR_PACKAGE_FOLDER" >> $MOUNTPOINT/install_scripts
    if [[ "$RUN_AUR_ROOT" -eq 0 ]]; then
        echo "            chown -R \$USERNAME:\$USERNAME \$AUR_PACKAGE_FOLDER" >> $MOUNTPOINT/install_scripts
    fi    
    echo "        fi" >> $MOUNTPOINT/install_scripts
    if [[ "$RUN_AUR_ROOT" -eq 1 ]]; then
        echo "        # exec command as root - Only way to make it unattended, and the Evils of this are fine on a new install." >> $MOUNTPOINT/install_scripts
        echo "        get_aur_packages \$PACKAGE \$AUR_PACKAGE_FOLDER" >> $MOUNTPOINT/install_scripts # Run as Root, Evil but fast
    else
        echo "        # exec command as user instead of root" >> $MOUNTPOINT/install_scripts
        echo "        su \$USERNAME -c \"get_aur_packages \$PACKAGE \$AUR_PACKAGE_FOLDER\"" >> $MOUNTPOINT/install_scripts # Run as User
    fi    
    echo "    done" >> $MOUNTPOINT/install_scripts
    echo "} #}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "#CONFIGURE SUDO {{{" >> $MOUNTPOINT/install_scripts
    echo "configure_sudo()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    if ! check_package \"sudo\" ; then" >> $MOUNTPOINT/install_scripts
    echo "        print_title 'SUDO - https://wiki.archlinux.org/index.php/Sudo'" >> $MOUNTPOINT/install_scripts
    echo "        package_install \"sudo\"" >> $MOUNTPOINT/install_scripts
    echo "    fi" >> $MOUNTPOINT/install_scripts
    echo "    # CONFIGURE SUDOERS {{{" >> $MOUNTPOINT/install_scripts
    echo "    if [[ ! -f  /etc/sudoers.aui ]]; then" >> $MOUNTPOINT/install_scripts
    echo "        cp -v /etc/sudoers /etc/sudoers.aui" >> $MOUNTPOINT/install_scripts
    echo "        ## Uncomment to allow members of group wheel to execute any command" >> $MOUNTPOINT/install_scripts
    echo "        sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers" >> $MOUNTPOINT/install_scripts
    echo "        ## Same thing without a password (not secure)" >> $MOUNTPOINT/install_scripts
    echo "        #sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//' /etc/sudoers" >> $MOUNTPOINT/install_scripts
    echo "        # This config is especially helpful for those using terminal multiplexers like screen, tmux, or ratpoison, and those using sudo from scripts/cronjobs:" >> $MOUNTPOINT/install_scripts
    echo "        echo '' >> /etc/sudoers" >> $MOUNTPOINT/install_scripts
    echo "        echo 'Defaults !requiretty, !tty_tickets, !umask' >> /etc/sudoers" >> $MOUNTPOINT/install_scripts
    echo "        echo 'Defaults visiblepw, path_info, insults, lecture=always' >> /etc/sudoers" >> $MOUNTPOINT/install_scripts
    echo "        echo 'Defaults loglinelen = 0, logfile =/var/log/sudo.log, log_year, log_host, syslog=auth' >> /etc/sudoers" >> $MOUNTPOINT/install_scripts
    echo "        echo 'Defaults passwd_tries = 8, passwd_timeout = 1' >> /etc/sudoers" >> $MOUNTPOINT/install_scripts
    echo "        echo 'Defaults env_reset, always_set_home, set_home, set_logname' >> /etc/sudoers" >> $MOUNTPOINT/install_scripts
    echo "        echo 'Defaults !env_editor, editor="/usr/bin/vim:/usr/bin/vi:/usr/bin/nano"' >> /etc/sudoers" >> $MOUNTPOINT/install_scripts
    echo "        echo 'Defaults timestamp_timeout=300' >> /etc/sudoers" >> $MOUNTPOINT/install_scripts
    echo "        echo 'Defaults passprompt=\"[sudo] password for %u: \"' >> /etc/sudoers" >> $MOUNTPOINT/install_scripts
    echo "    fi" >> $MOUNTPOINT/install_scripts
    echo "    echo \$\"Sudo Configured\"" >> $MOUNTPOINT/install_scripts
    echo "    #}}}" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    # Run internal command
    echo "package_install()" >> $MOUNTPOINT/install_scripts
    echo "{ #{{{" >> $MOUNTPOINT/install_scripts
    echo "    if [[ \$REFRESH_REPO -eq 1 ]]; then" >> $MOUNTPOINT/install_scripts
    echo "        echo \"Update Pacman Database.\"" >> $MOUNTPOINT/install_scripts
    echo "        pacman -Syy" >> $MOUNTPOINT/install_scripts
    echo "        REFRESH_REPO=0" >> $MOUNTPOINT/install_scripts
    echo "    fi" >> $MOUNTPOINT/install_scripts
    echo "    # install packages using pacman" >> $MOUNTPOINT/install_scripts
    echo "    for PACKAGE in \$1; do" >> $MOUNTPOINT/install_scripts
    echo "        if ! check_package \"\$PACKAGE\" ; then" >> $MOUNTPOINT/install_scripts
    echo "            pacman -S --noconfirm --needed \"\$PACKAGE\"" >> $MOUNTPOINT/install_scripts 
    echo "        fi" >> $MOUNTPOINT/install_scripts
    echo "    done" >> $MOUNTPOINT/install_scripts
    echo "} #}}}" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    # Run internal command
    echo "aur_package_install()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    # install package from aur" >> $MOUNTPOINT/install_scripts
    echo "    for PACKAGE in \$1; do" >> $MOUNTPOINT/install_scripts
    echo "        if ! check_package \"\$PACKAGE\" ; then" >> $MOUNTPOINT/install_scripts
    if [[ "$RUN_AUR_ROOT" -eq 1 ]]; then
        echo "            $AUR_HELPER --noconfirm -S \$PACKAGE" >> $MOUNTPOINT/install_scripts # Run as Root, no so Evil here but fast
    else
        echo "            su - \$USERNAME -c \"$AUR_HELPER --noconfirm -S \$PACKAGE\"" >> $MOUNTPOINT/install_scripts # Run as User, not really needed
    fi
    echo "            # RECHECK #{{{" >> $MOUNTPOINT/install_scripts
    echo "            # check if the package wasnt installed" >> $MOUNTPOINT/install_scripts
    echo "            if ! check_package \"\$PACKAGE\" ; then" >> $MOUNTPOINT/install_scripts
    echo "                read_input_yn \"Package \$PACKAGE not installed, try install again?\"" >> $MOUNTPOINT/install_scripts
    if [[ "$RUN_AUR_ROOT" -eq 1 ]]; then
        echo "                [[ \"\$YN_OPTION\" -eq 1 ]] && \"$AUR_HELPER -S \$PACKAGE\"" >> $MOUNTPOINT/install_scripts # Run as Root
    else
        echo "                [[ \"\$YN_OPTION\" -eq 1 ]] && su - \$USERNAME -c \"$AUR_HELPER -S \$PACKAGE\"" >> $MOUNTPOINT/install_scripts # Run as User
    fi
    echo "            fi" >> $MOUNTPOINT/install_scripts
    echo "            #}}}" >> $MOUNTPOINT/install_scripts
    echo "        else" >> $MOUNTPOINT/install_scripts
    echo "            echo -e \"Warning: \$PACKAGE is up to date --skipping\"" >> $MOUNTPOINT/install_scripts
    echo "        fi" >> $MOUNTPOINT/install_scripts
    echo "    done" >> $MOUNTPOINT/install_scripts
    echo "} " >> $MOUNTPOINT/install_scripts
    echo "#}}}    " >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    #
    echo "# GET SECRET {{{" >> $MOUNTPOINT/install_scripts
    echo "get_secret()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    # @FIX Add decryption escape special characters" >> $MOUNTPOINT/install_scripts
    echo "    if [[ \"\$1\" == \"root_user\" ]]; then" >> $MOUNTPOINT/install_scripts
    echo "        source install_scripts_root_secrets" >> $MOUNTPOINT/install_scripts
    echo "    elif [[ \"\$1\" == \"user_user\" ]]; then" >> $MOUNTPOINT/install_scripts
    echo "        source install_scripts_user_secrets" >> $MOUNTPOINT/install_scripts
    echo "    fi" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    echo "# MAKE DIR {{{" >> $MOUNTPOINT/install_scripts
    echo "make_dir()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    # @FIX update function
    echo "    [[ ! -d \"\$1\" ]] && mkdir -p \"\$1\"" >> $MOUNTPOINT/install_scripts 
    echo "}" >> $MOUNTPOINT/install_scripts
    echo "#}}}" >> $MOUNTPOINT/install_scripts
    #
    echo "is_user_in_group()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    groups \"\$USERNAME\" | grep \"\$1\"" >> $MOUNTPOINT/install_scripts
    echo "    return \$?" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts
    #
    echo "add_user_2_group()" >> $MOUNTPOINT/install_scripts
    echo "{" >> $MOUNTPOINT/install_scripts
    echo "    if ! is_user_in_group \"\$1\" ; then" >> $MOUNTPOINT/install_scripts
    echo "        passwd -a \$USERNAME \"\$1\"" >> $MOUNTPOINT/install_scripts
    #echo "        write_log \"add_user_2_group \$1" >> $MOUNTPOINT/install_scripts    # @FIX add command
    echo "    fi" >> $MOUNTPOINT/install_scripts
    echo "}" >> $MOUNTPOINT/install_scripts
    # ------------------------- End Library ------------------------------------------------ 
}
#}}}
# -----------------------------------------------------------------------------
# CREATE INSTALL SCRIPTS {{{
# USAGE      : create_script_boot
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
create_script_boot()
{
    echo "print_title \$\"Installing Arch Linux\"" >> $MOUNTPOINT/install_scripts
    # Install all software need to do this task; i.e. hostnamectl requires systemd, also it seems systemd will not work till reboot
    # echo "pacman -S " >> $MOUNTPOINT/install_scripts
    #
    if [[ $UEFI -ne 0 ]]; then # Not installing Boot, option = NONE
        echo "print_info \$\"Mount boot partitions...\"" >> $MOUNTPOINT/install_scripts
        # remount here or grub gets confused
        # Always on the Second Partition, but lets keep track
        # echo "mkdir -p /boot" > $MOUNTPOINT/install_scripts
        echo "mount -t ext2 /dev/${INSTALL_DEVICE}${BOOT_PARTITION_NO} /boot" >> $MOUNTPOINT/install_scripts
        if [[ $UEFI -eq 1 ]]; then
            # Always on the first Partition
            # echo "mkdir -p /boot/efi" > $MOUNTPOINT/install_scripts
            echo "mount -t vfat /dev/${INSTALL_DEVICE}1 /boot/efi" >> $MOUNTPOINT/install_scripts        
        fi
        if [[ "$DEBUGGING" -eq 1 ]]; then echo "pause_function \"\$LINENO\"" >> $MOUNTPOINT/install_scripts; fi
    fi
    #        
    # Resolv Nameservers
    if [[ $IS_CUSTOM_NAMESERVER -eq 1 ]]; then
        echo "print_info \$\"Resolv...\"" >> $MOUNTPOINT/install_scripts
        #echo "mkdir -p /etc" >> $MOUNTPOINT/install_scripts
        echo "if [[ -f /etc/resolv.conf ]]; then" >> $MOUNTPOINT/install_scripts
        echo "   chattr -i /etc/resolv.conf" >> $MOUNTPOINT/install_scripts # Un Write Protect it
        echo "fi" >> $MOUNTPOINT/install_scripts
        echo "touch /etc/resolv.conf" >> $MOUNTPOINT/install_scripts
        echo "echo \"# Created: $DATE_TIME\" > /etc/resolv.conf" >> $MOUNTPOINT/install_scripts
        echo "echo '# /etc/resolv.conf' >> /etc/resolv.conf" >> $MOUNTPOINT/install_scripts
        echo "echo '#' >> /etc/resolv.conf" >> $MOUNTPOINT/install_scripts
        echo "echo '# search <yourdomain.tld>' >> /etc/resolv.conf" >> $MOUNTPOINT/install_scripts
        echo "echo '# nameserver <ip>' >> /etc/resolv.conf" >> $MOUNTPOINT/install_scripts
        if [[ -n "$CUSTOM_NS1" ]]; then
            echo "echo \"nameserver $CUSTOM_NS1\" > /etc/resolv.conf" >> $MOUNTPOINT/install_scripts
        fi
        if [[ -n "$CUSTOM_NS2" ]]; then
            echo "echo \"nameserver $CUSTOM_NS2\" >> /etc/resolv.conf" >> $MOUNTPOINT/install_scripts
        fi
        echo "echo 'nameserver 127.0.1.1' >> /etc/resolv.conf" >> $MOUNTPOINT/install_scripts
        if [[ -n $CUSTOM_NS_SEARCH ]]; then
            echo "echo 'search $CUSTOM_NS_SEARCH' >> /etc/resolv.conf" >> $MOUNTPOINT/install_scripts
        fi
        echo "chattr +i /etc/resolv.conf" >> $MOUNTPOINT/install_scripts # Write Protect it
        # https://wiki.archlinux.org/index.php/Resolv.conf
        echo "mkdir -p /etc/conf.d" >> $MOUNTPOINT/install_scripts
        echo "touch /etc/conf.d/dhcpd" >> $MOUNTPOINT/install_scripts
        echo "echo 'DHCPD_ARGS=\"-R -t 30 -h \$HOSTNAME\"' > /etc/conf.d/dhcpd" >> $MOUNTPOINT/install_scripts # DHCP will overwrite this file each reboot if you don not do this
        echo "touch /etc/dhcpcd.conf" >> $MOUNTPOINT/install_scripts
        echo "echo 'nohook resolv.conf' >> /etc/dhcpcd.conf" >> $MOUNTPOINT/install_scripts # DHCP will overwrite this file each reboot if you don not do this
        if [[ "$DEBUGGING" -eq 1 ]]; then 
            echo "cat /etc/resolv.conf" >> $MOUNTPOINT/install_scripts; 
            echo "pause_function \"cat /etc/resolv.conf \$LINENO\"" >> $MOUNTPOINT/install_scripts; 
        fi
    fi
    echo "touch /etc/locale.conf" >> $MOUNTPOINT/install_scripts
    if [[ -n "$LOCALE_ARRAY" ]]; then
        echo "print_info \$\"Locale...\"" >> $MOUNTPOINT/install_scripts
        total=${#LOCALE_ARRAY[@]}
        for (( index=0; index<${total}; index++ )); do
            if [[ "$index" -eq 0 ]]; then
                echo "echo 'LANG=\"${LOCALE_ARRAY[$index]}.UTF-8\"' > /etc/locale.conf" >> $MOUNTPOINT/install_scripts
            else
                echo "echo 'LANG=\"${LOCALE_ARRAY[$index]}.UTF-8\"' >> /etc/locale.conf" >> $MOUNTPOINT/install_scripts
            fi
            echo "sed -i '/'${LOCALE_ARRAY[$index]}'/s/^#//' /etc/locale.gen" >> $MOUNTPOINT/install_scripts
        done
    fi
    if [[ "$DEBUGGING" -eq 1 ]]; then 
        echo "cat /etc/locale.conf" >> $MOUNTPOINT/install_scripts
        echo "pause_function \"\$LINENO\"" >> $MOUNTPOINT/install_scripts
    fi
    # echo "echo 'LANG=\"${LOCALE}.UTF-8\"' > /etc/locale.conf" >> $MOUNTPOINT/install_scripts
    # or   sed -i '/'$LOCALE'/s/^#//' /etc/locale.gen
    # echo "sed -i \"s/#(${LOCALE}\.UTF-8.*$)/\1/\" /etc/locale.gen" >> $MOUNTPOINT/install_scripts
    echo "print_info \$\"Locale-gen...\"" >> $MOUNTPOINT/install_scripts
    echo "locale-gen" >> $MOUNTPOINT/install_scripts 
    if [[ "$DEBUGGING" -eq 1 ]]; then 
        echo "pause_function \"\$LINENO\"" >> $MOUNTPOINT/install_scripts; 
    fi
    # hwclock
    echo "print_info \$\"hwclock...\"" >> $MOUNTPOINT/install_scripts
    echo "hwclock --systohc --utc" >> $MOUNTPOINT/install_scripts
    # mkinitcpio
    echo "print_info \$\"mkinitcpio...\"" >> $MOUNTPOINT/install_scripts
    echo "mkinitcpio -p linux" >> $MOUNTPOINT/install_scripts # disable configure_mkinitcpio
    if [[ "$DEBUGGING" -eq 1 ]]; then 
        echo "pause_function \"\$LINENO\"" >> $MOUNTPOINT/install_scripts; 
    fi
    # Add passwords and Users
    echo "echo ''" >> $MOUNTPOINT/install_scripts
    echo "echo ''" >> $MOUNTPOINT/install_scripts
    echo "print_info \$\"Setup Root Password\"" >> $MOUNTPOINT/install_scripts
    echo "get_secret 'root_user'" >> $MOUNTPOINT/install_scripts
    echo "" >> $MOUNTPOINT/install_scripts
    echo "echo ''" >> $MOUNTPOINT/install_scripts
    echo "echo ''" >> $MOUNTPOINT/install_scripts
    echo "print_info \$\"Setup Group...\"" >> $MOUNTPOINT/install_scripts
    echo "groupadd \$USERNAME" >> $MOUNTPOINT/install_scripts
    echo "echo ''" >> $MOUNTPOINT/install_scripts
    echo "print_info \$\"Setup User...\"" >> $MOUNTPOINT/install_scripts
    # if ! grep $USERNAME /etc/passwd
    # optical,video,audio,scanner,games,lp,power,storage
    echo "useradd -m -g \$USERNAME -G \$USERNAME,wheel,users -s /bin/bash \$USERNAME" >> $MOUNTPOINT/install_scripts
    if [[ "$DEBUGGING" -eq 1 ]]; then 
        echo "pause_function \"useradd \$LINENO\"" >> $MOUNTPOINT/install_scripts
    fi
    # User Groups
    if [ -n "$USER_GROUPS" ]; then
        total=${#USER_GROUPS[@]} 
        for (( index=0; index<${total}; index++ )); do
            echo "groupadd ${USER_GROUPS[$index]}" >> $MOUNTPOINT/install_scripts
            echo "add_user_2_group \"${USER_GROUPS[$index]}\"" >> $MOUNTPOINT/install_scripts
        done
    fi
    if [[ "$DEBUGGING" -eq 1 ]]; then 
        echo "pause_function \"\$LINENO\"" >> $MOUNTPOINT/install_scripts
    fi
    #echo "print_info \$\"Setup User Information...\"" >> $MOUNTPOINT/install_scripts
    #echo "echo 'To enter user information for the GECOS field (e.g. the full user name)'" >> $MOUNTPOINT/install_scripts
    #echo "chfn \$USERNAME" >> $MOUNTPOINT/install_scripts
    #echo "echo ''" >> $MOUNTPOINT/install_scripts
    #echo "echo ''" >> $MOUNTPOINT/install_scripts
    echo "print_info \$\"Setup User Password...\"" >> $MOUNTPOINT/install_scripts
    echo "get_secret 'user_user'" >> $MOUNTPOINT/install_scripts
    if [[ "$DEBUGGING" -eq 1 ]]; then 
        echo "pause_function \"\$LINENO\"" >> $MOUNTPOINT/install_scripts
    fi
    # Pause, so we can see if its good so far; maybe pass in a debug switch: -d 
    #echo "read -e -sn 1 -p 'Review then Press any key to continue...'" >> $MOUNTPOINT/install_scripts
    #
    #
    echo "# ****** Grub Install *************************** " >> $MOUNTPOINT/install_scripts
    #
    echo "modprobe dm-mod" >> $MOUNTPOINT/install_scripts
    if [[ $UEFI -eq 1 ]]; then
        # installed grub in pacstrap install_base_system
        echo "if [[ \"\$(cat /sys/class/dmi/id/sys_vendor)\" == 'Apple Inc.' ]] || [[ \"\$(cat /sys/class/dmi/id/sys_vendor)\" == 'Apple Computer, Inc.' ]]; then" >> $MOUNTPOINT/install_scripts # If MAC
        echo "    modprobe -r -q efivars || true" >> $MOUNTPOINT/install_scripts
        echo "else" >> $MOUNTPOINT/install_scripts
        echo "    modprobe -q efivars" >> $MOUNTPOINT/install_scripts
        echo "fi" >> $MOUNTPOINT/install_scripts
        if [[ "$DEBUGGING" -eq 1 ]]; then
            echo "echo 'modprobe efivars'" >> $MOUNTPOINT/install_scripts 
            echo "pause_function \"\$LINENO\"" >> $MOUNTPOINT/install_scripts
        fi
    fi
    echo "#" >> $MOUNTPOINT/install_scripts
    if [[ $BOOT_SYSTEM_TYPE -eq 1 ]]; then # Grub2
        if [[ $UEFI -eq 1 ]]; then
            echo "mkdir -p /boot/efi/EFI" >> $MOUNTPOINT/install_scripts
            echo "grub-install --directory=/usr/lib/grub/x86_64-efi --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --boot-directory=/boot --recheck --debug &>/boot/grub_uefi.log" >> $MOUNTPOINT/install_scripts
            echo "cat /boot/grub_uefi.log" >> $MOUNTPOINT/install_scripts
            echo "#" >> $MOUNTPOINT/install_scripts
            echo "if [[ \"\$(cat /sys/class/dmi/id/sys_vendor)\" != 'Apple Inc.' ]] && [[ \"\$(cat /sys/class/dmi/id/sys_vendor)\" != 'Apple Computer, Inc.' ]]; then" >> $MOUNTPOINT/install_scripts # if MAC
            echo "  for _bootnum in \$(efibootmgr | grep '^Boot[0-9]' | fgrep -i 'ARCH LINUX (GRUB2)' | cut -b5-8) ; do" >> $MOUNTPOINT/install_scripts
            echo "      efibootmgr --bootnum \"\${_bootnum}\" --delete-bootnum" >> $MOUNTPOINT/install_scripts
            echo "  done" >> $MOUNTPOINT/install_scripts
            echo "  efibootmgr --verbose --create --gpt --disk /dev/$INSTALL_DEVICE --part 1 --write-signature --label 'ARCH LINUX (GRUB2)' --loader '\\EFI\\arch_grub\\grubx64.efi'" >> $MOUNTPOINT/install_scripts
            echo "fi" >> $MOUNTPOINT/install_scripts
        elif [[ $UEFI -eq 2 ]]; then
            # @FIX test, what is mount point? Install to root?
            echo "grub-install --target=i386-pc --recheck --debug /dev/${INSTALL_DEVICE}" >> $MOUNTPOINT/install_scripts
            #echo "grub-install --target=i386-pc --recheck $INSTALL_DEVICE" >> $MOUNTPOINT/install_scripts
            echo "grub-mkconfig -o /boot/grub/grub.cfg" >> $MOUNTPOINT/install_scripts
            echo "#" >> $MOUNTPOINT/install_scripts
        fi
        echo "mkdir -p /boot/grub/locale" >> $MOUNTPOINT/install_scripts
        echo "cp /usr/share/locale/en\\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo" >> $MOUNTPOINT/install_scripts
        echo "grub-mkconfig -o /boot/grub/grub.cfg" >> $MOUNTPOINT/install_scripts
    elif [[ $BOOT_SYSTEM_TYPE -eq 2 ]]; then # Syslinux
        echo "syslinux-install_update -iam" >> $MOUNTPOINT/install_scripts
        echo "${EDITOR} /boot/syslinux/syslinux.cfg" >> $MOUNTPOINT/install_scripts
        echo "#" >> $MOUNTPOINT/install_scripts
    fi       
    #
    if [[ "$DEBUGGING" -eq 1 ]]; then
        echo "pause_function \"\$LINENO\"" >> $MOUNTPOINT/install_scripts
    fi
}
#}}}
# -----------------------------------------------------------------------------
# CREATE SCRIPT LOG {{{
# USAGE      : create_script_log
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
create_script_log()
{
    # -------------------------------------------------------------------------
    # 
    #
    # Log file
    #
    echo "print_info \$\"Writing log files...\"" >> $MOUNTPOINT/install_scripts
    echo "make_dir \"$SCRIPT_LOG\" \"$LINENO\"" >> $MOUNTPOINT/install_scripts
    echo "echo '# $TEXT_SCRIPT_ID' > $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    # locale
    echo "echo '## /etc/locale.conf ###########################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    echo "cat /etc/locale.conf >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    echo "echo '## /etc/locale.gen ############################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    echo "cat /etc/locale.gen >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    if [[ $BOOT_SYSTEM_TYPE -eq 1 ]]; then # Grub2
        if [[ $UEFI -eq 1 ]]; then
            echo "echo '## /boot/grub/grub.cfg ########################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
            echo "cat /boot/grub/grub.cfg >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
            echo "echo '## /boot/grub_uefi.log ########################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
            echo "cat /boot/grub_uefi.log >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
        fi
    elif [[ $BOOT_SYSTEM_TYPE -eq 2 ]]; then # Syslinux
        echo "echo '## /boot/syslinux/syslinux.cfg ################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
        echo "cat /boot/syslinux/syslinux.cfg" >> $MOUNTPOINT/install_scripts
    fi
    # loadkeys
    echo "echo '## /etc/vconsole.conf #########################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    echo "cat /etc/vconsole.conf >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    # hostname
    echo "echo '## /etc/hostname ##############################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    echo "cat /etc/hostname >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    # hosts
    echo "echo '## /etc/hosts #################################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    echo "cat /etc/hosts >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    # pacman.conf
    echo "echo '## /etc/pacman.conf ###########################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    echo "cat /etc/pacman.conf >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    # resolv.conf
    echo "echo '## /etc/resolv.conf ###########################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    echo "cat /etc/resolv.conf >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    # fstab
    echo "echo '## /etc/fstab #################################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    echo "cat /etc/fstab >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    # /etc/dhcpcd.conf
    echo "echo '## /etc/dhcpcd.conf ###########################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    echo "cat /etc/dhcpcd.conf >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    # /etc/conf.d/dhcpd
    echo "echo '## /etc/conf.d/dhcpd ##########################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    echo "cat /etc/conf.d/dhcpd >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    # install_scripts
    echo "echo '## /etc/install_scripts #######################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    echo "cat install_scripts >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    #    
    echo "echo '## END OF LOG #################################################################' >> $SCRIPT_LOG" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    echo "#" >> $MOUNTPOINT/install_scripts
    if [[ "$DEBUGGING" -eq 1 ]]; then
        echo "pause_function \"install_scripts has executed and logs written at line \$LINENO\"" >> $MOUNTPOINT/install_scripts
    fi
}
#}}}
# *******************************************************************************************************************************
# INSTALL SOFTWARE LIVE }}}
# USAGE      : install_software_live
# DESCRIPTION: Install Software on Live OS
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_software_live()
{
    if [[ "$MOUNTPOINT" == "/mnt" ]]; then
        print_warning $"You must run this in Live Mode!"
        exit 1
    fi
    verify_config
    if [[ "$IS_LAST_CONFIG_LOADED" -eq 0 ]]; then
        print_warning $"Configuration did not get Loaded, make sure to run load_software or load_last_config"
        exit 1
    fi
    print_title 'https://wiki.archlinux.org/index.php/Beginners%27_Guide#Boot_Arch_Linux_Installation_Media'
    print_info $"Configure sudo..."
    configure_sudo
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
    print_info $"Configure Pacman Package Signing..."
    configure_pacman_package_signing
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
    print_info $"System Upgrade..."
    system_upgrade
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
    print_info $"Configure AUR Helper..."
    configure_aur_helper
    # MAKE SURE these are set: $CONFIG_HOSTNAME $USERNAME
    print_info $"Set host name..."
    hostnamectl set-hostname "$CONFIG_HOSTNAME"
    if [[ "$CONFIG_HOSTNAME" == `hostname` ]]; then
        HN=`hostname`
        echo "Hostname ${HN} is set"
    else
        echo "Hostname is not set!"
    fi
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
    #
    #
    # Install PACKMANAGER
    if [[ "${#PACKMANAGER}" -ne 0 ]]; then
        print_info $"Install PACKAGEMANAGER..."
        total=${#PACKMANAGER[@]}
        for (( index=0; index<${total}; index++ )); do
            # @FIX test return logic; 0 = success; 
            eval "${PACKMANAGER[$index]}"
            if [ "$?" -eq 0 ]; then
                write_log "$PACKMANAGER_NAME - ${PACKMANAGER[$index]}" "$LINENO"
            else
                write_error "$PACKMANAGER_NAME - ${PACKMANAGER[$index]}" "$LINENO"
                if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "eval PACKMANAGER at line $LINENO (line by line errors)"; fi
            fi
        done
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "eval PACKMANAGER at line $LINENO"; fi
    fi
    #
    # FLESH
    if [[ "$FLESH" -eq 1 ]]; then
        configure_user_account
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "configure_user_account $LINENO"; fi
    fi
    # TOR
    if [[ $CONFIG_TOR -eq 1 ]]; then
        print_info $"Configure TOR..."
        if [[ ! -f /usr/bin/proxy-wrapper ]]; then
            echo 'forward-socks5   /               127.0.0.1:9050 .' >> /etc/privoxy/config
            echo -e '#!/bin/bash\nnc.openbsd -xlocalhost:9050 -X5 $*' > /usr/bin/proxy-wrapper
            chmod +x /usr/bin/proxy-wrapper
            echo -e '\nexport GIT_PROXY_COMMAND="/usr/bin/proxy-wrapper"' >> /etc/bash.bashrc
            export GIT_PROXY_COMMAND="/usr/bin/proxy-wrapper"
            if [[ "$RUN_AUR_ROOT" -eq 0 ]]; then
                su - $USERNAME -c 'export GIT_PROXY_COMMAND="/usr/bin/proxy-wrapper"'
            fi
        fi
        groupadd -g 42 privoxy
        useradd -u 42 -g privoxy -s /bin/false -d /etc/privoxy privoxy
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
    fi
    # KDE
    if [[ $CONFIG_KDE -eq 1 ]]; then
        print_info $"Configure KDE..."
        # @FIX function to do curl to log it
        curl -o Sweet.tar.gz http://kde-look.org/CONTENT/content-files/144205-Sweet.tar.gz
        curl -o Kawai.tar.gz http://kde-look.org/CONTENT/content-files/141920-Kawai.tar.gz
        tar zxvf Sweet.tar.gz
        tar zxvf Kawai.tar.gz
        rm Sweet.tar.gz
        rm Kawai.tar.gz
        make_dir "/home/$USERNAME/.kde4/share/apps/color-schemes" "$LINENO"
        mv Sweet/Sweet.colors /home/$USERNAME/.kde4/share/apps/color-schemes
        mv Kawai/Kawai.colors /home/$USERNAME/.kde4/share/apps/color-schemes
        make_dir "/home/$USERNAME/.kde4/share/apps/QtCurve" "$LINENO"
        mv Sweet/Sweet.qtcurve /home/$USERNAME/.kde4/share/apps/QtCurve
        mv Kawai/Kawai.qtcurve /home/$USERNAME/.kde4/share/apps/QtCurve
        chown -R $USERNAME:$USERNAME /home/$USERNAME/.kde4
        rm -fr Kawai Sweet
        #
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
    fi
    # SSH
    if [[ $CONFIG_SSH -eq 1 ]]; then
        print_info $"Configure SSH..."
        [[ ! -f /etc/ssh/sshd_config.aui ]] && copy_file "/etc/ssh/sshd_config" "/etc/ssh/sshd_config.aui" "$LINENO";
        sed -i '/Port 22/s/^#//' /etc/ssh/sshd_config
        sed -i '/Protocol 2/s/^#//' /etc/ssh/sshd_config
        sed -i '/HostKey \/etc\/ssh\/ssh_host_rsa_key/s/^#//' /etc/ssh/sshd_config
        sed -i '/HostKey \/etc\/ssh\/ssh_host_dsa_key/s/^#//' /etc/ssh/sshd_config
        sed -i '/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/s/^#//' /etc/ssh/sshd_config
        sed -i '/KeyRegenerationInterval/s/^#//' /etc/ssh/sshd_config
        sed -i '/ServerKeyBits/s/^#//' /etc/ssh/sshd_config
        sed -i '/SyslogFacility/s/^#//' /etc/ssh/sshd_config
        sed -i '/LogLevel/s/^#//' /etc/ssh/sshd_config
        sed -i '/LoginGraceTime/s/^#//' /etc/ssh/sshd_config
        sed -i '/PermitRootLogin/s/^#//' /etc/ssh/sshd_config
        sed -i '/HostbasedAuthentication/s/^#//' /etc/ssh/sshd_config
        sed -i '/StrictModes/s/^#//' /etc/ssh/sshd_config
        sed -i '/RSAAuthentication/s/^#//' /etc/ssh/sshd_config
        sed -i '/PubkeyAuthentication/s/^#//' /etc/ssh/sshd_config
        sed -i '/IgnoreRhosts/s/^#//' /etc/ssh/sshd_config
        sed -i '/PermitEmptyPasswords/s/^#//' /etc/ssh/sshd_config
        sed -i '/AllowTcpForwarding/s/^#//' /etc/ssh/sshd_config
        sed -i '/AllowTcpForwarding no/d' /etc/ssh/sshd_config
        sed -i '/X11Forwarding/s/^#//' /etc/ssh/sshd_config
        sed -i '/X11Forwarding/s/no/yes/' /etc/ssh/sshd_config
        sed -i -e '/\tX11Forwarding yes/d' /etc/ssh/sshd_config
        sed -i '/X11DisplayOffset/s/^#//' /etc/ssh/sshd_config
        sed -i '/X11UseLocalhost/s/^#//' /etc/ssh/sshd_config
        sed -i '/PrintMotd/s/^#//' /etc/ssh/sshd_config
        sed -i '/PrintMotd/s/yes/no/' /etc/ssh/sshd_config
        sed -i '/PrintLastLog/s/^#//' /etc/ssh/sshd_config
        sed -i '/TCPKeepAlive/s/^#//' /etc/ssh/sshd_config
        sed -i '/the setting of/s/^/#/' /etc/ssh/sshd_config
        sed -i '/RhostsRSAAuthentication and HostbasedAuthentication/s/^/#/' /etc/ssh/sshd_config
        #
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
    fi
    # Configure XORG
    if [[ $CONFIG_XORG -eq 1 ]]; then
        print_info $"Configure XORG..."
        if [[ "$LANGUAGE" == "de_DE" || "$LANGUAGE" == "es_ES" || "$LANGUAGE" == "es_CL" || "$LANGUAGE" == "it_IT" || "$LANGUAGE" == "fr_FR" || "$LANGUAGE" == "pt_BR" || "$LANGUAGE" == "pt_PT" ]]; then
            [[ ! -f /etc/X11/xorg.conf.d/10-evdev.conf.aui ]] && copy_file "/etc/X11/xorg.conf.d/10-evdev.conf" "/etc/X11/xorg.conf.d/10-evdev.conf.aui" "$LINENO";
            # CONFIGURE QWERTY KEYBOARD IN XORG {{{
            file="/etc/X11/xorg.conf.d/10-evdev.conf"
            # get the line number that has "keyboard" in 10-evdev.conf
            line=`grep -n "keyboard" $file | cut -f1 -d:`
            # sum that line with more 2, it will insert the patch there
            line=$(( $line + 2 ))
            # variable to check if the file wasnt already patched
            patch=`cat $file | sed ''$(( $line + 1 ))'!d'`
            # get the keymap from rc.conf
            keymap=`cat /etc/vconsole.conf | sed -n '/KEYMAP[=]/p' | sed 's/KEYMAP=//'`
            # check if the file wasnt already patched
            if [[ $patch != *"XkbLayout"* ]]; then
                if [[ $keymap == us-acentos ]]; then
                    kblayout="\\\tOption \"XkbLayout\" \"us_intl\""
                else
                    case "$LANGUAGE" in
                        de_DE)
                            kblayout="\\\tOption \"XkbLayout\" \"de\""
                            ;;
                        es_ES)
                            if [[ "$KEYBOARD" == 'es' ]]; then                    
                                kblayout="\\\tOption \"XkbLayout\" \"es\""
                            else
                                kblayout="\\\tOption \"XkbLayout\" \"latam\""
                            fi                        
                            ;;
                        it_IT)
                            kblayout="\\\tOption \"XkbLayout\" \"it\""
                            kblayout+="\n\\tOption \"XkbOptions\" \"terminate:ctrl_alt_bksp\""
                            ;;
                        fr_FR)
                            kblayout="\\\tOption \"XkbLayout\" \"fr\""
                            ;;
                        pt_BR)
                            kblayout="\\\tOption \"XkbLayout\" \"br\""
                            kblayout+="\n\\tOption \"XkbVariant\" \"abnt2\""
                            ;;
                        pt_PT)
                            kblayout="\\\tOption \"XkbLayout\" \"pt-latin9\""
                            ;;
                    esac
                fi
                # patch file
                sed -i "${line}a $kblayout" $file
            fi
        fi
        # enable global fonts configs
        # print_title "FONT CONFIGURATION - https://wiki.archlinux.org/index.php/Font_Configuration"
        print_info "Fontconfig is a library designed to provide a list of available fonts to applications, and also for configuration for how fonts get rendered."
        cd /etc/fonts/conf.d
        ln -sv ../conf.avail/10-sub-pixel-rgb.conf
        #ln -sv ../conf.avail/10-autohint.conf
        ln -sv ../conf.avail/11-lcdfilter-default.conf
        ln -s ../conf.avail/70-no-bitmaps.conf
        cd "$SCRIPT_DIR"
        #
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
    fi
    #   
    # Clean Orphan Packages
    if [[ $CONFIG_ORPHAN -eq 1 ]]; then
        print_info $"Clean Orphan Packages..."
        pacman -Rsc --noconfirm $(pacman -Qqdt)
        #pacman -Sc --noconfirm
        pacman-optimize
        #
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
    fi
    test_install
    #
    finish 2
}
#}}}
# -----------------------------------------------------------------------------
# TEST INSTALL {{{
# USAGE      : test_install
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
test_install()
{
    # @FIX how to test now?
    print_info "Test Install"    
    
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL LOAD SOFTWARE }}}
# USAGE      : install_loaded_software
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
install_loaded_software()
{
    print_title "Install Software from Configuration files, Assumes you are in Live Mode, meaning you booted into your Live OS, not an installatoin disk."
    print_info "$TEXT_SCRIPT_ID"
    # Live mode only
    if [[ "$MOUNTPOINT" == "/mnt" ]]; then
        print_warning "Live mode only!"
        exit 1
    fi
    #
    verify_config
    #
    if [[ "$IS_SOFTWARE_CONFIG_LOADED" -eq 0 ]]; then            
        print_warning "No Software Configuration files found!, run option -i and Save Configuration."
        pause_function "$LINENO"
        exit 0
    fi
    print_info "$TEXT_SCRIPT_ID"
    print_info "$MENU_OPTION_L"
    print_title "Install Software from Configuration files, Assumes you are in Live Mode, meaning you booted into your Live OS, not an installatoin disk."
    print_info $"This option Assumes that you have a bootable OS and and have gone through the Application Software Menu and Saved it, now we are going to load it and install it."
    print_info $"Normally you will use the user name ($USERNAME) in the file, but its possible that you may wish to use another User Name to install this with, make sure User Name Exist in this OS before doing this."
    print_info $"You will have to abort (Ctrl-C) if you wish to change Software Installation Setting, and run -i."
    echo "Copying over all Configuration files to Live OS."
    copy_dir "$SCRIPT_DIR/etc/" "/" "$LINENO"
    print_title "Load Last Install."
    INSTALL_TYPE=3 # Currently not an option from bootup due to systemd not being started by current arch iso, may change in the future
    install_software_live
    finish 2
}
#{{{
# RUN SCRIPT {{{
# USAGE      : run_script
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
run_script()
{
    #
    # Set vars so script doesn't bomb
    # Note: you will have to do the following, with your USER_NAME to run this script without ROOT permissions:
    # sudo chown USER_NAME:USER_NAME /mnt/install_scripts
    if [[ 0 ]]; then
        # load_software # Only do this for testing
        get_user_name                   # $USERNAME
        get_user_password               # $USERPASSWD
        get_root_password               # $ROOTPASSWD
        add_user_group "networkmanager" # $USER_GROUPS
        UEFI=1
        LOCALE_ARRAY[0]="en_US"
        LOCALE_ARRAY[1]="en_GB"
        AUR_HELPER="yaourt"
        add_module "snd-usb-audio" "MODULE-TEST-ALSA"
        add_module "fuse" "MODULE-TEST-FUSE"
        add_packagemanager "package_remove 'kdemultimedia-kscd kdemultimedia-juk'" "REMOVE-TEST"
        add_packagemanager "aur_package_install 'exaile spotify' 'AUR-INSTALL-TEST'" "AUR-INSTALL-TEST"
        add_packagemanager "package_install 'networkmanager network-manager-applet mate mate-session-manager mate-extras mate-screensaver gnome-icon-theme trayer gvfs-smb gvfs-afc gdm gnome-control-center gconf-editor' 'INSTALL-TEST'" "INSTALL-TEST"
        add_packagemanager "cp -f /etc/skel/.xinitrc /home/\$USERNAME/" "RUN-TEST_1"
        add_packagemanager "echo -e 'exec ck-launch-session mate-session' >> /home/\$USERNAME/.xinitrc" "RUN-TEST_2"
        add_packagemanager "chown -R \$USERNAME:\$USERNAME /home/\$USERNAME/.xinitrc" "RUN-TEST_3"
        add_packagemanager "systemctl enable gdm.service" "SYSTEMD-ENABLE-TEST"
        #CONFIG_TOR=1
        #CONFIG_KDE=1
        #CONFIG_SSH=1
        #CONFIG_XORG=1
        #CONFIG_ORPHAN=1
        # save_software # Only do this for testing
    else
        get_user_name               # Get $USERNAME
        if [[ "$SAFE_MODE" -eq 0 ]]; then
            get_root_password       # $ROOTPASSWD
            get_root_password       # $ROOTPASSWD
        fi
        load_software
    fi
    CREATE_SCRIPT=1
    write_secret 'user_user'
    write_secret 'root_user'
    create_install_scripts 1
    # We can not delete them for testing only
    #delete_secret 'user_user'
    #delete_secret 'root_user'
}
#}}}
# -----------------------------------------------------------------------------
# FIX REPO {{{
# USAGE      : fix_repo
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
fix_repo()
{
    print_info $"Edit /etc/pacman.conf."
    print_info $"Put Mate into /etc/pacman.conf."
    print_info $"Copy $SCRIPT_DIR/etc/* to /etc/*."
    print_info $"Quit."
    SYSTEM_TYPES=("Edit" "MATE" "Copy" "Quit");
    PS3="$prompt1"
    echo -e "Select a Boot BIOS System Type:\n"
    select OPT in "${SYSTEM_TYPES[@]}"; do
        case "$REPLY" in
            1)
                $EDITOR /ect/pacman.conf
                break
                ;;
            2)
                echo "[mate]" >> /etc/pacman.conf
                echo "Server = http://repo.mate-desktop.org/archlinux/\$arch" >> /etc/pacman.conf
                break
                ;;
            3)
                copy_dir "$SCRIPT_DIR/etc/" "/" "$LINENO"
                pause_function "$LINENO"
                break
                ;;
            4)
                break
                ;;
           *)
                invalid_option "$REPLY"
                ;;
                esac
    done
}
#}}}
# -----------------------------------------------------------------------------
# CREATE INSTALL SCRIPTS {{{
# USAGE      : create_install_scripts
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
create_install_scripts()
{
    # NOTE: /boot and /boot/efi (if UEFI) should exist and be mounted, this is done during Drive Preperation so when modprobe efivars will create folders
    # Create Script to run as arch-chroot
    create_script_lib
    if [[ "$1" -eq 1 ]]; then
        create_script_boot
        # create_script_software # left here in case Arch Linux ISO boots with systemd running
    elif [[ "$1" -eq 2 ]]; then
        create_script_boot
    # elif [[ "$1" -eq 3 ]]; then create_script_software # left here in case Arch Linux ISO boots with systemd running
    fi
    create_script_log
    #
    #
    echo "echo 'You are in arch-chroot, you can make any changes to the OS here.'" >> $MOUNTPOINT/install_scripts
    echo "echo 'Type exit and hit enter when complete.'" >> $MOUNTPOINT/install_scripts
}
#}}}
# -----------------------------------------------------------------------------
# RUN INSTALL SCRIPTS {{{
# USAGE      : run_install_scripts
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
run_install_scripts()
{
    if [[ "$INSTALL_TYPE" -eq 3 ]]; then
        return 0
    fi
    write_secret 'user_user'
    write_secret 'root_user'
    print_title "https://wiki.archlinux.org/index.php/Installation_Chroot"
    #echo -e $prompt3
    #print_info $"Type:"
    #print_warning "./install_scripts"
    #print_info $"and hit enter."
    if [[ "$INSTALL_TYPE" -eq 1 ]]; then # Full Install: Boot and Create Software List at the same time.
       print_info $"Installing in arch-chroot"
       print_info $"This may take a few minutes."
       create_install_scripts 1
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Boot only
       print_info $"Installing in arch-chroot"
       print_info $"This may take a few minutes."
       create_install_scripts 2
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Software option does not work, due to systemd not running in current boot disk profile, this may change in the future.
       #print_info $"Installing in arch-chroot"
       #print_info $"This may take a few minutes."
       #create_install_scripts 3
       # Software config only
       # this left here incase Arch Linux ISO switches to having systemd running at boot up
       return 0
    fi
    # 
    # Run in chroot
    arch-chroot $MOUNTPOINT /install_scripts
    #
    copy_file $MOUNTPOINT"/boot/grub_uefi.log" "$LOG_PATH/" "$LINENO"
    copy_file $MOUNTPOINT"/install_scripts"    "$SCRIPT_DIR" "$LINENO"
    # Copy all files to root
    copy_file "$SCRIPT_DIR/$SCRIPT_NAME"${SCRIPT_EXT}  $MOUNTPOINT"/root/"        "$LINENO"
    copy_files "$CONFIG_PATH/" "db"                    $MOUNTPOINT"/root/CONFIG/" "$LINENO"
    copy_files "$LOG_PATH/"    "log"                   $MOUNTPOINT"/root/LOG/"    "$LINENO"
    copy_file "$MOUNTPOINT/install_scripts"            $MOUNTPOINT"/root/"        "$LINENO"
    rm ${MOUNTPOINT}"/install_scripts"
    # Overwrite all Config files 
    copy_dir "$SCRIPT_DIR/etc/" $MOUNTPOINT"/" "$LINENO"
    # copy_file "$SCRIPT_DIR/etc/hosts" "/etc/hosts" "$LINENO"
    # Make sure to delete these files, they have passwords in them
    delete_secret 'user_user'
    delete_secret 'root_user'
    print_title 'https://wiki.archlinux.org/index.php/Beginners%27_Guide#Boot_Arch_Linux_Installation_Media'
    print_info $"If all went right you should be able to reboot into a fully functioning Desktop."
    print_info $"Make sure to check the root for install files like install_scripts, $SCRIPT_LOG, install_scripts_root_secrets, install_scripts_user_secrets, you can also delete /boot/grub_uefi.log."
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# GDISK PARTITION {{{
# USAGE      : gdisk_partition
# DESCRIPTION: Format Hard Drive
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
gdisk_partition()
{
    print_title "Partition Setup..."
    #
    # Disk prep
    print_info $"Erasing disk..." 
    sgdisk -og /dev/"$INSTALL_DEVICE"        # Clear out all partition data and Convert an MBR or BSD disklabel disk to a GPT disk
    sgdisk -Z /dev/"$INSTALL_DEVICE"         # Zap all on disk
    sgdisk -a 2048 -o /dev/"$INSTALL_DEVICE" # new gpt disk 2048 alignment
    #
    # Create partitions
    # in case script gets called twice, you will need to reboot if device is busy
    umount_partition /dev/"${INSTALL_DEVICE}"1
    umount_partition /dev/"${INSTALL_DEVICE}"2
    umount_partition /dev/"${INSTALL_DEVICE}"3
    umount_partition /dev/"${INSTALL_DEVICE}"4
    #
    umount_partition $MOUNTPOINT/proc
    umount_partition $MOUNTPOINT/sys
    umount_partition $MOUNTPOINT/dev
    umount_partition $MOUNTPOINT/tmp
    #
    #
    PARTITION_NO=1
    # Partition BIOS (UEFI SYS or BIOS), default start block, user defined size
    if [[ $UEFI -eq 1 ]]; then
        print_info $"Creating UEFI disk..." 
        echo "1"
        CREATE_PARTITION="sgdisk -n 1:0:+${UEFI_SIZE} -c 1:\"UEFISYS\" -t 1:ef00 /dev/$INSTALL_DEVICE"  
        $CREATE_PARTITION
    elif [[ $UEFI -eq 2 ]]; then
        if [[ $BOOT_SYSTEM_TYPE -eq 0 ]]; then # Grub2
           print_info $"Creating BIOS disk..." 
           echo "1"
           CREATE_PARTITION="sgdisk -n 1:0:+${BIOS_SIZE} -c 1:\"BIOS\" -t 1:ef02 /dev/$INSTALL_DEVICE"     
           $CREATE_PARTITION
        fi
    fi
    #
    # Partition (BOOT), default start block, user defined size
    if [[ $IS_BOOT_PARTITION -eq 1 ]]; then
        print_info $"Creating BOOT disk Partition ..." 
        echo $((++PARTITION_NO)) # NOTE: This will increament PARTITION_NO
        CREATE_PARTITION="sgdisk -n ${PARTITION_NO}:0:+${BOOT_SIZE} -c ${PARTITION_NO}:\"BOOT\" -t ${PARTITION_NO}:8300 /dev/$INSTALL_DEVICE"
        echo "$CREATE_PARTITION"
        $CREATE_PARTITION
        BOOT_PARTITION_NO="$PARTITION_NO"
    fi
    #
    # Partition (SWAP), default start block, user defined size
    if [[ $IS_SWAP_PARTITION -eq 1 ]]; then
        echo $((++PARTITION_NO)) # NOTE: This will increament PARTITION_NO
        print_info $"Creating SWAP Partition ..." 
        CREATE_PARTITION="sgdisk -n ${PARTITION_NO}:0:+${SWAP_SIZE} -c ${PARTITION_NO}:\"SWAP\" -t ${PARTITION_NO}:8200 /dev/$INSTALL_DEVICE" 
        echo "$CREATE_PARTITION"
        $CREATE_PARTITION 
        SWAP_PARTITION_NO="$PARTITION_NO"
    fi
    #        
    # Partition (ROOT), default start, user defined size
    print_info $"Creating ROOT Partition ..." 
    echo $((++PARTITION_NO)) # NOTE: This will increament PARTITION_NO
    if [[ $ROOT_SIZE != "0" ]]; then
        SIZE_PREFIX="+"
    else
        SIZE_PREFIX=""
    fi
    get_format_type "$ROOT_FORMAT"
    FORMAT_TYPE="$OPTION"
    CREATE_PARTITION="sgdisk -n ${PARTITION_NO}:0:${SIZE_PREFIX}${ROOT_SIZE} -c ${PARTITION_NO}:\"ROOT\" -t ${PARTITION_NO}:${FORMAT_TYPE} /dev/$INSTALL_DEVICE" 
    echo "$CREATE_PARTITION"
    $CREATE_PARTITION 
    ROOT_PARTITION_NO="$PARTITION_NO"
    #
    # Partition (HOME), default start block, user defined size
    if [[ $IS_HOME_PARTITION -eq 1 ]]; then
        print_info $"Creating HOME disk Partition ..." 
        echo $((++PARTITION_NO)) # NOTE: This will increament PARTITION_NO
        if [[ $HOME_SIZE != "0" ]]; then
            SIZE_PREFIX="+"
        else
            SIZE_PREFIX=""
        fi
        get_format_type "$HOME_FORMAT"
        FORMAT_TYPE="$OPTION"
        CREATE_PARTITION="sgdisk -n ${PARTITION_NO}:0:${SIZE_PREFIX}${HOME_SIZE} -c ${PARTITION_NO}:\"HOME\" -t ${PARTITION_NO}:${FORMAT_TYPE} /dev/$INSTALL_DEVICE" # Size     
        echo "$CREATE_PARTITION"
        $CREATE_PARTITION
        HOME_PARTITION_NO="$PARTITION_NO"
    fi
    #
    # Partition (VAR), default start block, user defined size
    if [[ $IS_VAR_PARTITION -eq 1 ]]; then
        print_info $"Creating VAR disk Partition ..." 
        echo $((++PARTITION_NO)) # NOTE: This will increament PARTITION_NO
        if [[ $VAR_SIZE != "0" ]]; then
            SIZE_PREFIX="+"
        else
            SIZE_PREFIX=""
        fi
        get_format_type "$VAR_FORMAT"
        FORMAT_TYPE="$OPTION"
        CREATE_PARTITION="sgdisk -n ${PARTITION_NO}:0:${SIZE_PREFIX}${VAR_SIZE} -c ${PARTITION_NO}:\"VAR\" -t ${PARTITION_NO}:${FORMAT_TYPE} /dev/$INSTALL_DEVICE" # Size     
        echo "$CREATE_PARTITION"
        $CREATE_PARTITION
        VAR_PARTITION_NO="$PARTITION_NO"
    fi
    #
    # Formating, Checking file System and Mounting
    #        
    # Partition ROOT mount first
    print_info $"Formating ROOT Partition..."
    mkfs -t "$ROOT_FORMAT" -L "ROOT" "/dev/${INSTALL_DEVICE}${ROOT_PARTITION_NO}"      # Format with user specified format type
    fsck "/dev/${INSTALL_DEVICE}${ROOT_PARTITION_NO}"                                  # Check File System
    make_dir "$MOUNTPOINT" "$LINENO"                                                   # Create Folder /mnt
    mount -t "$ROOT_FORMAT" "/dev/$INSTALL_DEVICE$ROOT_PARTITION_NO" "$MOUNTPOINT"     # Mount at /mnt
    #
    # Partition HOME
    if [[ $IS_HOME_PARTITION -eq 1 ]]; then
        print_info $"Formating HOME disk Partition..."
        mkfs -t "$HOME_FORMAT" -L "HOME" "/dev/${INSTALL_DEVICE}${HOME_PARTITION_NO}"           # Format with user specified format type
        fsck "/dev/${INSTALL_DEVICE}${HOME_PARTITION_NO}"                                       # Check File System
        make_dir "$MOUNTPOINT/home" "$LINENO"                                                   # Make Folder /mnt/home
        mount -t "$HOME_FORMAT" "/dev/${INSTALL_DEVICE}${HOME_PARTITION_NO}" "$MOUNTPOINT/home" # Mount at /mnt/home
    fi
    #
    # Partition VAR
    if [[ $IS_VAR_PARTITION -eq 1 ]]; then
        print_info $"Formating VAR disk Partition..."
        mkfs -t "$VAR_FORMAT" -L "VAR" "/dev/${INSTALL_DEVICE}${VAR_PARTITION_NO}"            # Format with user specified format type
        fsck "/dev/${INSTALL_DEVICE}${VAR_PARTITION_NO}"                                      # Check File System
        make_dir "$MOUNTPOINT/var" "$LINENO"                                                  # Make Folder /mnt/var
        mount -t "$VAR_FORMAT" "/dev/${INSTALL_DEVICE}${VAR_PARTITION_NO}" "$MOUNTPOINT/var"  # Mount at /mnt/var
    fi
    #
    # Partition BOOT, mount after root
    if [[ $IS_BOOT_PARTITION -eq 1 ]]; then
        print_info $"Formating BOOT disk Partition..."
        mkfs.ext2 -L "BOOT" "/dev/${INSTALL_DEVICE}${BOOT_PARTITION_NO}"              # Format ext2
        fsck "/dev/${INSTALL_DEVICE}${BOOT_PARTITION_NO}"                             # Check File System
        make_dir "$MOUNTPOINT/boot" "$LINENO"                                         # Make Folder /mnt/boot in case its not created above
        mount -t ext2 "/dev/${INSTALL_DEVICE}${BOOT_PARTITION_NO}" "$MOUNTPOINT/boot" # Mount Drive /mnt/boot; lets also unmount and re-mount this in install_script
    fi
    #        
    # Partition UEFI SYS, mount after root and boot
    if [[ $UEFI -eq 1 ]]; then
        print_info $"Formating UEFI disk..." 
        mkfs.vfat -F32 -n "UEFISYS" "/dev/${INSTALL_DEVICE}1"          # Format vfat 32
        fsck "/dev/${INSTALL_DEVICE}1"                                 # Check File System   
        make_dir "$MOUNTPOINT/boot" "$LINENO"                          # Create Folder /mnt/boot
        make_dir "$MOUNTPOINT/boot/efi" "$LINENO"                      # Create Folder /mnt/boot/efi  
        mount -t vfat "/dev/${INSTALL_DEVICE}1" "$MOUNTPOINT/boot/efi" # Mount Drive to /mnt/boot/efi; lets also mount this in install_script
    elif [[ $UEFI -eq 2 ]]; then
        if [[ $BOOT_SYSTEM_TYPE -eq 0 ]]; then # Grub2
            print_info $"Formating BIOS disk..." 
            mkfs.vfat -F32 -n "BIOS" "/dev/${INSTALL_DEVICE}1"              # Format vfat 32
            fsck "/dev/${INSTALL_DEVICE}1"                                  # Check File System    
            make_dir "$MOUNTPOINT/boot/bios" "$LINENO"                      # Create Folder /mnt/boot/bios
            mount -t vfat "/dev/${INSTALL_DEVICE}1" "$MOUNTPOINT/boot/bios" # Mount Drive to /mnt/boot/bios @FIX This can not be right, research did not find answer
        fi
    fi
    #
    # Partition SWAP
    if [[ $IS_SWAP_PARTITION -eq 1 ]]; then
        print_info $"Creating SWAP Partition..."
        mkswap -L "SWAP" "/dev/${INSTALL_DEVICE}${SWAP_PARTITION_NO}"  # make swap
        swapon "/dev/${INSTALL_DEVICE}${SWAP_PARTITION_NO}"            # set swap on
    fi
    #
    # ------------------------------------------------------------------------
    # mount proc, sys, dev in install root
    # ------------------------------------------------------------------------
    make_dir "${MOUNTPOINT}/proc" "$LINENO"
    make_dir "${MOUNTPOINT}/sys" "$LINENO"
    make_dir "${MOUNTPOINT}/dev" "$LINENO"
    make_dir "${MOUNTPOINT}/tmp" "$LINENO"
    # do not mount
    #mount -o bind /proc $MOUNTPOINT/proc
    #mount -o bind /sys $MOUNTPOINT/sys
    #mount -o bind /dev $MOUNTPOINT/dev
    #mount -o bind /tmp $MOUNTPOINT/tmp
    #
    make_dir "${MOUNTPOINT}/etc" "$LINENO"
    #
    # Print Table
    if [[ "$EDIT_GDISK" -eq 1 ]]; then
        sgdisk -p "/dev/$INSTALL_DEVICE"
        gdisk "/dev/$INSTALL_DEVICE"
    fi
    # Copy over default files to MOUNTPOINT
    copy_file "/etc/pacman.conf" ${MOUNTPOINT}"/etc/pacman.conf" "$LINENO"
    make_dir $MOUNTPOINT"/etc/pacman.d" "$LINENO"
    copy_file "/etc/pacman.d/mirrorlist" ${MOUNTPOINT}"/etc/pacman.d/mirrorlist" "$LINENO"
    #
    DRIVE_FORMATED=1
}
#}}}
# -----------------------------------------------------------------------------
# EDIT DISK {{{
# USAGE      : edit_disk
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
edit_disk()
{
    get_boot_type      # $UEFI and $UEFI_SIZE 
    get_boot_partition # $IS_BOOT_PARTITION, $BOOT_SYSTEM_TYPE and $BOOT_SIZE
    get_swap_partition # $IS_SWAP_PARTITION and $SWAP_SIZE
    get_root_size      # $ROOT_SIZE and ROOT_FORMAT
    get_home_partition # $IS_HOME_PARTITION, $HOME_SIZE, $HOME_FORMAT and $IS_HOME_DRIVE
    get_var_partition  # $IS_VAR_PARTITION, $VAR_SIZE, $VAR_FORMAT and $IS_VAR_DRIVE
    get_tmp_partition  # IS_TMP_PARTITION IS_TMP_SIZE TMP_SIZE TMP_FORMAT
    #
    print_info $"After Drive is formated, you can edit it using gdisk."
    read_input_yn $"Edit Drive with gdisk" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        EDIT_GDISK=1
    else
        EDIT_GDISK=0
    fi
    # @FIX add SSD optimization
    print_info $"Special Settings can help with SSD Drives."
    read_input_yn $"Is this an SSD Disk" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        IS_SSD=1
    else
        IS_SSD=0
    fi
    save_disk_config
}
#}}}
# -----------------------------------------------------------------------------
# SETUP OS {{{
# USAGE      : setup_os
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
setup_os()
{
    print_title "https://wiki.archlinux.org/index.php/Partitioning and https://wiki.archlinux.org/index.php/GUID_Partition_Table"
    print_info $"This Script uses GPT.GUID Partition Table (GPT) is a new style of partitioning which is part of the Unified Extensible Firmware Interface Specification, using the globally unique identifier for devices. It is different from the Master Boot Record (the more commonly used partitioning style) in many aspects and has many advantages."
    print_info $"Partitioning a hard drive allows one to logically divide the available space into sections that can be accessed independently of one another. Partition information is stored within a hard drive's Master Boot Record."
    print_warning "Running gdisk options will DESTROY all DATA on installation disk!"
    print_info $"This function sets up a Standard Partition of 4 Primary Types: UEFI - BOOT - SWAP and ROOT; you can also specify to create HOME and VAR Partitions."
    echo "UEFI"
    print_info $"https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface: Unified Extensible Firmware Interface (or UEFI for short) is a new type of firmware that was initially designed by Intel (known as EFI then) mainly for its Itanium based systems. It introduces new ways of booting an OS that is distinct from the commonly used 'MBR boot code' method followed for BIOS systems. It started as Intel's EFI in versions 1.x and then a group of companies called the UEFI Forum took over its development from which it was called Unified EFI starting with version 2.0."
    print_info $"UEFI is formated as FAT32"
    echo "BIOS"
    print_info $"https://wiki.archlinux.org/index.php/GRUB2#BIOS_systems_2: If your motherboard supports UEFI Mode, then use it, otherwise use BIOS mode; both use GPT for this Script."
    print_info $"BIOS is formated as FAT32"
    is_uefi_mode
    echo "BOOT"
    print_info "https://wiki.archlinux.org/index.php/Partitioning#.2Fboot: The /boot directory contains the kernel and ramdisk images as well as the bootloader configuration file and bootloader stages."
    print_info $"BOOT is not required to be a separate Partition, its recommended, BOOT is formated as Ext2"
    echo "ROOT"
    print_info "https://wiki.archlinux.org/index.php/Partitioning#.2F_.28root.29: ROOT is required, and is fromated as Ext4."
    echo "SWAP"
    print_info "https://wiki.archlinux.org/index.php/Partitioning#Swap: The swap partition provides memory that can be used as virtual RAM. It is recommended for PCs with 1GB or less of physical RAM."
    print_info $"A SWAP partition is not required, but recommened."
    echo "HOME"
    print_info "https://wiki.archlinux.org/index.php/Partitioning#.2Fhome: The /home directory contains user-specific configuration files (the so-called 'dot files'). Optionally, it can also hold any type of media (videos, music, etc), and if you use Wine, the games/programs will be installed in ~/.wine/ by default. So please take this into account if you chose to create a separate home partition. While keeping it on a separate partition can be useful in case you reinstall, some prefer to start fresh (because that's usually the reason for a reinstall), instead of reusing old, and possibly deprecated or problematic, configuration files. The main advantage is that, in very rare cases, if the root partition becomes too full, it will not impact your web browser, media player, torrent client, etc. They will keep working uninhibited, and will keep saving new changes to their setting files or to their cache. A home partition can also be shared with other installed Linux distributions, but this is not recommended because of possible incompatibilities between user-specific configuration files. The only exception is if each distribution has its own user dir on the shared home partition."
    echo "VAR"
    print_info "https://wiki.archlinux.org/index.php/Partitioning#.2Fvar: The /var directory stores Contains variable data such as spool directories and files, administrative and logging data, pacman's cache, the ABS tree, etc. It is used for example for caching and logging, and hence frequently read or written. Keeping it in a separate partition avoids running out of disk space due to flunky logs, etc. It exists to make it possible to mount /usr as read-only. Everything that historically went into /usr that is written to during system operation (as opposed to installation and software maintenance) must reside under /var."
    # Duplicate code for var and tmp, note usr is too much work, it dumps to gdisk and users can manually add anything they wish at that point
    #
    echo ""
    print_info $"A series of question will guild us to setting up the Partition Table."
    print_info $"The Order the Partitions are made are: UEFI - BOOT - SWAP - ROOT - HOME - VAR"
    echo ""
    print_info $"You can hit Shift-Page Up or Down to scroll screens, Ctrl-C to exit script at any time."
    #
    print_info $"You must choose a Drive to install OS on, make sure you wish to Format this Whole Drive."
    device_list
    get_input_option "LIST_DEVICES[@]" 1
    INSTALL_DEVICE=${LIST_DEVICES[$((OPTION-1))]:0:3}
    read_input_yn "Install Arch Linux on Drive $INSTALL_DEVICE" 0
    if [[ "$YN_OPTION" -eq 0 ]]; then
        print_warning "Figure out what drive you wish to install to, then re-run this Script."
        exit 0
    fi
    if [[ "$SCRIPT_DEVICE" == "$INSTALL_DEVICE" ]]; then
        print_warning "You can not install to same drive Script is Executing from."
        exit 0
    fi
    INSTALL_DEVICE=`echo $INSTALL_DEVICE | sed 's/[0-9]//'`  # i.e. sda; make sure no partition number is assigned
    if [[ -b "/dev/$INSTALL_DEVICE" ]]; then
        print_info $"Installing on Device /dev/$INSTALL_DEVICE"
        write_log "Installing on Device /dev/$INSTALL_DEVICE" "$LINENO"
    else
        print_warning "Device /dev/$INSTALL_DEVICE does not exist! Try running script again using correct device name, run fdisk -l for a list of Device names."
        lsblk
        exit # @FIX test before passing it in; make a list and have them pick from it
    fi
    #
    # set_log_drive # just run it from mounted drive
    #
    print_warning $"\tAbout to Format Drive $INSTALL_DEVICE, be very sure you wish to continue! Hit Ctrl-C to Cancel, any key to Contiune."
    pause_function "Last Chance at line $LINENO"
    #
    get_user_name           # $USERNAME
    get_user_password       # $USERPASSWD
    get_root_password       # $ROOTPASSWD
    #
    backup_files            # Backup config files
    if [[ "$FAST_INSTALL" -eq 0 ]]; then
        custom_nameservers  # $IS_CUSTOM_NAMESERVER, $CUSTOM_NS1 and $CUSTOM_NS2
        configure_keymap    # $KEYMAP
        select_editor       # $EDITOR
    else
        if [[ "$IS_CUSTOM_NAMESERVER" -eq 1 ]]; then
            read_nameserver
        fi
    fi
    if [[ "$DISK_PROFILE" -eq 0 ]]; then edit_disk; fi # should never get here
    #
    if [[ "$FAST_INSTALL" -eq 0 ]]; then
        get_locale          # $LOCALE and $LOCALE_UTF8
    fi
    #
    gdisk_partition         # Create, Format and Mount 
    #   
    if [[ "$FAST_INSTALL" -eq 0 ]]; then
        get_flesh               # $FLESH
        configure_mirrorlist    # $COUNTRY_CODE Create Mirror List Write it to $MOUNTPOINT/etc/pacman.d/mirrorlist
        get_hostname            # $CONFIG_HOSTNAME Write to $MOUNTPOINT/etc/hosts
        configure_timezone      # add_packagemanager - Write to $MOUNTPOINT/etc/timezone and add run command for ln 
        add_custom_repositories #
    else
        get_mirrorlist "$COUNTRY_CODE"
    fi
    #
    if [[ "$FAST_INSTALL" -eq 0 ]]; then
        get_fstab_config        # $FSTAB_CONFIG and $FSTAB_EDIT
        #
        get_install_software 1  # $INSTALL_TYPE
    fi
    #
    install_base_system     # Must install Base System before editing fstab
    #
    configure_hostname      # Write to $MOUNTPOINT/etc/hosts and $MOUNTPOINT/etc/hostname
    #
    # umount or things get confused. yes, really, we will remount them in the install_scripts arch-chroot.
    umount_partition $MOUNTPOINT/boot/efi
    umount_partition $MOUNTPOINT/boot
    configure_fstab         # Write to $MOUNTPOINT/etc/fstab
    #
    run_install_scripts     # create install_scripts file and do arch-chroot
    #
    pause_function "$LINENO"
    #
    #
    finish 1
}
#}}}
# -----------------------------------------------------------------------------
# START SCREEN {{{
# USAGE      : start_screen
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
start_screen()
{
    # Run this script after your first boot with archlinux (as root)
    if [[ "$EUID" -ne 0 ]]; then
        echo "This script must be run with root privileges" 
        exit 0
    fi
    #ARCHLINUX INSTALL SCRIPTS MODE {{{
    print_title "https://wiki.archlinux.org/index.php/Arch_Install_Scripts"
    print_info "$TEXT_SCRIPT_ID"
    print_info $"The Arch Install Script are a set of Bash scripts that simplify Arch installation."
    print_info $"This program was Originally Created by helmuthdu mailto: helmuthdu[at]gmail[dot]com called Archlinux Ultimate Install or AUI"
    print_info $"And refactored by and new functionally written by Jeffrey Scott Flesher, so its more like a Wizard, and its called Arch Wizzard ($SCRIPT_NAME), it allows the user to chose to install from a menu driven selection, then save it so you can load it next time, making this a one stop custom installer, you can edit all your configuration files, save changes to flash drive, and reuse them to install on someone elses machine."
    print_info $"This Script will write configuratoin files on $SCRIPT_DEVICE mounted on $SCRIPT_DIR, its up to the user to remove them after Script finishes, so you must have enough space on device to hold files."
    print_info $"This Script will also write a log file on $SCRIPT_DEVICE mounted on $SCRIPT_DIR."
    print_info $""
    print_warning $"\tThis script is still in Alpha* stage"
    print_warning $"\tWarning: This script will completly format the Target Drive, its not designed to preserve partitions, it ERASES THE WHOLE HARD DRIVE!. so you have been warned."
    print_info $"If you are installing this to a dual boot Windows System (or any other OS) on the same drive, it will be lost, which in the case of Windoze, will not be all that much of a lost, but in future version of this script, we will work on converting to GPT Disk and preserving Partitions, and mounting them in the fstab and grub."
    pause_function "$LINENO"
    setup_os
}
#}}}
# -----------------------------------------------------------------------------
# GET INSTALL MODE {{{
# USAGE      : get_install_mode
# DESCRIPTION: Change MOUNTPOINT
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
get_install_mode()
{
    print_info $"Istall mode has two options: Boot and Live:"
    print_info $"Boot mode is when you Boot from an Arch ISO to install OS for first time, not to be confused with LIVE CD."
    print_info $"Live mode is after you install Boot, and then reboot into Live mode, i.e. Active Installed OS."    
    read_input_yn "Is install mode Live" 1
    if [[ "$YN_OPTION" -eq 1 ]]; then
        MOUNTPOINT=" "
        DRIVE_FORMATED=1
    fi
}
#}}}
# -----------------------------------------------------------------------------
# SET DEBUGGING MODE {{{
# USAGE      : set_debugging_mode
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
set_debugging_mode()
{
    print_title "Starting setup..."
    print_info "$TEXT_SCRIPT_ID"
    if is_internet ; then
        echo -e $"\tInternet is Up!"
    else
        fix_network
        print_warning "I tried to fix Network,I will test it again, if it fails, first try to re-run this script over, if that fails, try -n."
        print_this "trying again in 13 seconds..."
        sleep 13
        if ! is_internet ; then
            write_error "Internet is Down" "$LINENO"
            print_warning $"\tInternet is Down, this script requires an Internet Connection, fix and retry; try -n to help with Network Troubleshooting; first try to rerun this script, I did try to fix this." # @FIX Print some trouble shooting techiques
            exit 0
        fi
    fi
    if [[ "$DEBUGGING" -eq 1 ]]; then
        #set -u
        set -o nounset 
        print_info "Debug Mode will insert a Pause Function at critical functions and give you some information about how the script is running, it also may set other variables and run more test."
        echo "Debugging is set on, if set -o nounset or set -u, you may get unbound errors that need to be fixed."
        pause_function "$1"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# SET LOG DRIVE {{{
# USAGE      : set_log_drive
# DESCRIPTION:
# NOTES      :
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
set_log_drive()
{
    print_info $"Copy Profile (Logs, Configuration and Database files) to Drive, this is normally the Flash Drive you use to run this Script from."
    device_list
    get_input_option "LIST_DEVICES[@]" 1
    COPY_DEVICE=${LIST_DEVICES[$((OPTION-1))]:0:3}
    
    read_input_yn "Copy Profile to Drive $COPY_DEVICE" 0
    if [[ "$YN_OPTION" -eq 0 ]]; then
        print_warning "Figure out what drive you wish to Copy to, then re-run this Script."
        exit 0
    fi
    if [[ "$COPY_DEVICE" == "$INSTALL_DEVICE" ]]; then
        print_warning "You can not Copy to same drive that OS is being installed to; pick the Drive the Script is executing from."
        exit 0
    fi
    COPY_DEVICE=`echo $COPY_DEVICE | sed 's/[0-9]//'`  # i.e. sda; make sure no partition number is assigned
    if [[ -b "/dev/$COPY_DEVICE" ]]; then
        print_info $"Copying to Device /dev/$INSTALL_DEVICE"
        write_log "Coping to Device /dev/$INSTALL_DEVICE" "$LINENO"
    else
        print_warning "Device /dev/$COPY_DEVICE does not exist! Try running script again using correct device name, run fdisk -l for a list of Device names."
        lsblk
        exit # @FIX test before passing it in; make a list and have them pick from it
    fi
    
}
#}}}
# ********************* Menu **************************************************
MENU_OPTION_A="Create a Bootable OS with option to Configure Software list."
MENU_OPTION_I="Instal Software: Create Software List and save settings; load last Configuration files."
MENU_OPTION_L="Load Last install configuration files and install software, assume -a has already been done."
# USAGE      : show_usage
# DESCRIPTION: Display Usage Menu
# NOTES      : script-name [-options] with no or invalid flag will display this screen
# AUTHOR     : Flesher
# VERSION    : 1.0
# CREATED    : 1 OCT 2012
# REVISION   : 1 NOV 2012
show_usage()
{
    echo "Usage: "  1>&2
    echo " $SCRIPT_NAME${SCRIPT_EXT}      - prints this screen"  1>&2
    echo " $SCRIPT_NAME${SCRIPT_EXT} -d   - install with debugging help, must be first argument: ex: -dn"  1>&2
    echo " $SCRIPT_NAME${SCRIPT_EXT} -a   - $MENU_OPTION_A"  1>&2
    echo " $SCRIPT_NAME${SCRIPT_EXT} -f   - Fast: Create a Bootable OS and option to install software list; using saved Configuration."  1>&2
    echo " $SCRIPT_NAME${SCRIPT_EXT} -i   - $MENU_OPTION_I"  1>&2
    echo " $SCRIPT_NAME${SCRIPT_EXT} -l   - $MENU_OPTION_L"  1>&2
    echo " $SCRIPT_NAME${SCRIPT_EXT} -s   - create install_scripts for reviewing."  1>&2
    echo " $SCRIPT_NAME${SCRIPT_EXT} -n   - Network Troubleshooting."  1>&2
    echo " $SCRIPT_NAME${SCRIPT_EXT} -t   - Test Install: will check what packages it did not install, other checks, and create an error.log file."  1>&2
    echo " $SCRIPT_NAME${SCRIPT_EXT} -r   - Fix Pacman Repository"  1>&2
    echo "Options: "  1>&2
    echo " --help            - print this help text"  1>&2
    echo ""
    exit 1
}
# Check Parameters
if [[ -z "$1" || "$1" = @(-h|--help|\?) ]]; then
    show_usage
    exit $(( $# ? 0 : 1 ))
fi
#
# Clear Log and add heading
make_dir "$LOG_PATH" "$LINENO"
make_dir "$MENU_PATH" "$LINENO"
make_dir "$CONFIG_PATH" "$LINENO"
copy_file "$ERROR_LOG" "$ERROR_LOG.last.log"
copy_file "$ACTIVITY_LOG" "$ACTIVITY_LOG.last.log"
echo "# Error Log: $SCRIPT_NAME Version: $SCRIPT_VERSION on $DATE_TIME." > "$ERROR_LOG"
echo "# Log: $SCRIPT_NAME Version: $SCRIPT_VERSION on $DATE_TIME."  > "$ACTIVITY_LOG"
#
# @FIX add a menu item for Software install on a Live OS
while getopts ":daflnstriu" M_OPTION; do
    case $M_OPTION in
        d)
            DEBUGGING=1
            ;;
        a)
            # Assume Boot install mode
            #
            set_debugging_mode "$LINENO"
            BOOT_MODE=1
            print_title "$MENU_OPTION_A"
            print_info "This option assumes you wish to Format the Drive and install a fresh copy of Arch Linux OS. A Configure file will be created each time you run this Script, you have the option to restore those Configuration Files."
            verify_config
            start_screen
            break;
            ;;
        f)
            #
            set_debugging_mode "$LINENO"
            FAST_INSTALL=1
            BOOT_MODE=1
            # Assume Boot mode
            verify_config    
            start_screen
            break;
            ;;
        l)
            #
            set_debugging_mode "$LINENO"
            MOUNTPOINT=" " # Live mode only
            DRIVE_FORMATED=1
            install_loaded_software
            break;
            ;;
        n)
            #
            set_debugging_mode "$LINENO"
            network_troubleshooting
            break;
            ;;
        s)
            #
            set_debugging_mode "$LINENO"
            SAFE_MODE=1
            verify_config    
            run_script
            break;
            ;;
        t) 
            #
            set_debugging_mode "$LINENO"
            # Assume Boot install mode
            #test_install
            load_software
            configure_user_account
            break;
            ;;
        r)
            #
            set_debugging_mode "$LINENO"
            # Assume Boot install mode
            fix_repo
            break;
            ;;
        i)  # Install Software Mode
            set_debugging_mode "$LINENO"
            print_title "Install Software"
            print_info "$TEXT_SCRIPT_ID"
            print_info $"$MENU_OPTION_A"
            get_install_mode # Ask for install mode
            verify_config
            if [[ "$MOUNTPOINT" == " " ]]; then
                print_warning "Only use this Option if you just used -a to install a new OS, it assues this, use mode -x to load eXtra Software on a Live OS that is already setup."
                print_this "Copy over all Configuration files to Live OS if you are using this from Boot Mode."
                read_input_yn "Overwrite etc with custom saved files" 1
                if [[ "$YN_OPTION" -eq 1 ]]; then
                    copy_dir "$SCRIPT_DIR/etc/" "/" "$LINENO"
                fi
            fi
            get_install_software 2
            break;
            ;;
        u)  # Upgrade all
            update_system
            break;
            ;;
    esac
done
# ****** END OF SCRIPT ******

