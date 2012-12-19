#!/bin/bash
#
# LAST_UPDATE="18 Dec 2012 16:33"
#
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
# 2. Re-factored and Added Functionality by Jeffrey Scott Flesher to make it a Wizard.
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
# Free License is not covered by any Law, all programmers writing under the Free License,
# take an oath that the Software Contains No Malice: Viruses, Malware, or Spybots...
# and only does what it was intended to do, notifying End Users before doing it.
# All Programmers and End Users are Free to Distribute or Modify this script,
# as long as they list themselves as Programmers and Document Changes.
# Free License is also Free of any Liability or Legal Actions, Freedom starts with Free.
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
# *****************************************************************************
# Menu System
# *****************************************************************************
# -----------------------------------------------------------------------------
# INSTALL MENU {{{
NAME="install_menu"
USAGE="install_menu"
DESCRIPTION=$(localize "INSTALL-MENU-DESC")
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-MENU-DESC"  "Install Menu"
localize_info "INSTALL-MENU-NOTES" "NONE"
#
localize_info "Save-Software-Configuration" "Save Software Configuration for later use" 
localize_info "INSTALL-MENU-ITEM-1"  "Basic Setup"
localize_info "INSTALL-MENU-ITEM-2"  "Desktop Environment"
localize_info "INSTALL-MENU-ITEM-3"  "Display Manager"
localize_info "INSTALL-MENU-ITEM-4"  "Accessories Apps"
localize_info "INSTALL-MENU-ITEM-5"  "Development Apps"
localize_info "INSTALL-MENU-ITEM-6"  "Office Apps"
localize_info "INSTALL-MENU-ITEM-7"  "System Apps"
localize_info "INSTALL-MENU-ITEM-8"  "Graphics Apps"
localize_info "INSTALL-MENU-ITEM-9"  "Internet Apps"
localize_info "INSTALL-MENU-ITEM-10" "Audio Apps"
localize_info "INSTALL-MENU-ITEM-11" "Video Apps"
localize_info "INSTALL-MENU-ITEM-12" "Games"
localize_info "INSTALL-MENU-ITEM-13" "Science"
localize_info "INSTALL-MENU-ITEM-14" "Web server"
localize_info "INSTALL-MENU-ITEM-15" "Fonts"
localize_info "INSTALL-MENU-ITEM-16" "Extra"
localize_info "INSTALL-MENU-ITEM-17" "Kernel"
localize_info "INSTALL-MENU-ITEM-18" "Clean Orphan Packages"
localize_info "INSTALL-MENU-ITEM-19" "Edit Configuration"
localize_info "INSTALL-MENU-ITEM-20" "Load Custom Software"
localize_info "INSTALL-MENU-ITEM-21" "Load Software"
localize_info "INSTALL-MENU-ITEM-22" "Save Software"
localize_info "INSTALL-MENU-ITEM-23" "Quit"
localize_info "INSTALL-MENU-INFO-1"  "Basic Setup: Required: SYSTEMD, Video Card, DBUS, AVAHI, ACPI, ALSA, (UN)COMPRESS TOOLS, NFS, SAMBA, XORG, CUPS, SSH and more."
localize_info "INSTALL-MENU-INFO-2"  "Desktop Environment: Mate, KDE, XFCE, Awesome, Cinnamon, E17, LXDE, OpenBox, GNOME and Unity."
localize_info "INSTALL-MENU-INFO-3"  "Display Manager: GDM, Elsa, LightDM, LXDM and Slim."
localize_info "INSTALL-MENU-INFO-4"  "Accessories Apps: cairo-dock-bzr, Conky, deepin-scrot, dockbarx, speedcrunch, galculator, gnome-pie, guake, kupfer, pyrenamer, shutter, synapse, terminator, zim, Revelation."
localize_info "INSTALL-MENU-INFO-5"  "Development Apps: aptana-studio, bluefish, eclipse, emacs, gvim, geany, IntelliJ IDEA, kdevelop, Oracle Java, Qt and Creator, Sublime Text 2, Debugger Tools, MySQL Workbench, meld, RabbitVCS, Wt, astyle and putty."
localize_info "INSTALL-MENU-INFO-6"  "Office Apps: Libre Office, Caligra or Abiword + Gnumeric, latex, calibre, gcstar, homebank, impressive, nitrotasks, ocrfeeder, xmind and zathura."
localize_info "INSTALL-MENU-INFO-7"  "System Apps:"
localize_info "INSTALL-MENU-INFO-8"  "Graphics Apps:"
localize_info "INSTALL-MENU-INFO-9"  "Internet Apps:"
localize_info "INSTALL-MENU-INFO-10" "Audio Apps:"
localize_info "INSTALL-MENU-INFO-11" "Video Apps:"
localize_info "INSTALL-MENU-INFO-12" "Games:"
localize_info "INSTALL-MENU-INFO-13" "Science and Education: ${INSTALL_SCIENCE_EDUCATION}."
localize_info "INSTALL-MENU-INFO-14" "Web server:"
localize_info "INSTALL-MENU-INFO-15" "Fonts:"
localize_info "INSTALL-MENU-INFO-16" "Extra:"
localize_info "INSTALL-MENU-INFO-17" "Install optional Kernals: "
localize_info "INSTALL-MENU-INFO-18" "Clean Orphan Packages:"
localize_info "INSTALL-MENU-INFO-19" "Edit Configuration: Loads Saved Software."
localize_info "INSTALL-MENU-INFO-20" "Load Custom Software; Not yet written."
localize_info "INSTALL-MENU-INFO-21" "Allows you to review and edit configuration variables before installing software."
localize_info "INSTALL-MENU-INFO-22" "Save Software: Saves and Installs list and configurations creates with this menu."
localize_info "INSTALL-MENU-INFO-23" "Quit Menu: If in Boot mode will run pacstrap, if in software mode will install Software."
localize_info "INSTALL-MENU-STATUS-1" ""
localize_info "INSTALL-MENU-STATUS-2" ""
localize_info "INSTALL-MENU-STATUS-3" ""
localize_info "INSTALL-MENU-STATUS-4" ""
localize_info "INSTALL-MENU-STATUS-5" ""
localize_info "INSTALL-MENU-STATUS-6" ""
localize_info "INSTALL-MENU-STATUS-7" ""
localize_info "INSTALL-MENU-STATUS-8" ""
localize_info "INSTALL-MENU-STATUS-9" ""
localize_info "INSTALL-MENU-STATUS-10" ""
localize_info "INSTALL-MENU-STATUS-11" ""
localize_info "INSTALL-MENU-STATUS-12" ""
localize_info "INSTALL-MENU-STATUS-13" ""
localize_info "INSTALL-MENU-STATUS-14" ""
localize_info "INSTALL-MENU-STATUS-15" ""
localize_info "INSTALL-MENU-STATUS-16" ""
localize_info "INSTALL-MENU-STATUS-17" ""
localize_info "INSTALL-MENU-STATUS-18" ""
localize_info "INSTALL-MENU-STATUS-19" ""
localize_info "INSTALL-MENU-STATUS-20" ""
localize_info "INSTALL-MENU-STATUS-21" ""
localize_info "INSTALL-MENU-STATUS-22" ""
localize_info "INSTALL-MENU-STATUS-23" ""
localize_info "INSTALL-MENU-STATUS-X" ""
localize_info "INSTALL-MENU-INSTALLED" "Installed"
localize_info "INSTALL-MENU-REMOVED" "Removed"
# -------------------------------------
install_menu()
{
    local -r menu_name="Install-Menu"  # You must define Menu Name here
    local BreakableKey="Q"
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "ARCHLINUX ULTIMATE INSTALL (AUI) Main Menu - https://github.com/helmuthdu/aui"
        print_caution "${StatusBar}" "${StatusBar2}"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-1"  "" "" "INSTALL-MENU-INFO-1"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-2"  "" "" "INSTALL-MENU-INFO-2"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-3"  "" "" "INSTALL-MENU-INFO-3"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-4"  "" "" "INSTALL-MENU-INFO-4"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-5"  "" "" "INSTALL-MENU-INFO-5"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-6"  "" "" "INSTALL-MENU-INFO-6"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-7"  "" "" "INSTALL-MENU-INFO-7"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-8"  "" "" "INSTALL-MENU-INFO-8"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-9"  "" "" "INSTALL-MENU-INFO-9"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-10" "" "" "INSTALL-MENU-INFO-10" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-11" "" "" "INSTALL-MENU-INFO-11" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-12" "" "" "INSTALL-MENU-INFO-12" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-13" "" "" "INSTALL-MENU-INFO-13" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-14" "" "" "INSTALL-MENU-INFO-14" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-15" "" "" "INSTALL-MENU-INFO-15" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-16" "" "" "INSTALL-MENU-INFO-16" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-17" "" "" "INSTALL-MENU-INFO-17" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-18" "" "" "INSTALL-MENU-INFO-18" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-19" "" "" "INSTALL-MENU-INFO-19" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-20" "" "" "INSTALL-MENU-INFO-20" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-21" "" "" "INSTALL-MENU-INFO-21" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-22" "" "" "INSTALL-MENU-INFO-22" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-23" "" "" "INSTALL-MENU-INFO-23" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        MAINMENU+=" "
        read_input_options "$MAINMENU"
        for OPT in ${OPTIONS[@]}; do
            case "$OPT" in
                1)  # Basic Setup with Add and Remove
                    if [[ "${MenuChecks[$(($OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$(($OPT - 1))]=1
                        install_basic 1
                        StatusBar="INSTALL-MENU-ITEM-1"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    else
                        MenuChecks[$(($OPT - 1))]=0
                        install_basic 2
                        StatusBar="INSTALL-MENU-ITEM-1"
                        StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    fi
                    ;;
                2)  # Desktop Environment
                    MenuChecks[$(($OPT - 1))]=1
                    install_desktop_environment 
                    StatusBar=" Completed."
                    ;;
                3)  # Display Manager
                    MenuChecks[$(($OPT - 1))]=1
                    install_display_manager
                    StatusBar="Desktop Environment Completed."
                    ;;
                4)  # Accessories Apps
                    MenuChecks[$(($OPT - 1))]=1
                    install_accessories_apps    
                    StatusBar=" Completed."
                    ;;
                5)  # Development Apps
                    MenuChecks[$(($OPT - 1))]=1
                    install_development_apps    
                    StatusBar="Accessories Apps Completed."
                    ;;
                6)  # Office Apps
                    MenuChecks[$(($OPT - 1))]=1
                    install_office_apps         
                    StatusBar="Office Apps Completed."
                    ;;
                7)  # System Apps
                    MenuChecks[$(($OPT - 1))]=1
                    install_system_apps
                    StatusBar="System Apps Completed."
                    ;;
                8)  # Graphics Apps
                    MenuChecks[$(($OPT - 1))]=1
                    install_graphics_apps
                    StatusBar="Graphics Apps Completed."
                    ;;
                9)  # Internet Apps
                    MenuChecks[$(($OPT - 1))]=1
                    install_internet_apps
                    StatusBar="Internet Apps Completed."
                    ;;
               10)  # Audio Apps
                    MenuChecks[$(($OPT - 1))]=1
                    install_audio_apps
                    StatusBar="Audio Apps Completed."
                    ;;
               11)  # Video Apps
                    MenuChecks[$(($OPT - 1))]=1
                    install_video_apps
                    StatusBar="Video Apps Completed."
                    ;;
               12)  # Games
                    MenuChecks[$(($OPT - 1))]=1
                    install_games
                    StatusBar="Games Completed."
                    ;;
               13)  # Science
                    MenuChecks[$(($OPT - 1))]=1
                    install_science
                    StatusBar="Science Completed."
                    ;;
               14)  # Web server
                    MenuChecks[$(($OPT - 1))]=1
                    install_web_server
                    StatusBar="Web server Completed."
                    ;;
               15)  # Fonts
                    MenuChecks[$(($OPT - 1))]=1
                    install_fonts
                    StatusBar="Fonts Completed."
                    ;;
               16)  # Extra
                    MenuChecks[$(($OPT - 1))]=1
                    install_extra
                    StatusBar="Extra Completed."
                    ;;
               17)  # Kernel
                    MenuChecks[$(($OPT - 1))]=1
                    install_kernel
                    StatusBar="Kernel Completed."
                    ;;
               18)  # Clean Orphan Packages
                    MenuChecks[$(($OPT - 1))]=1
                    clean_orphan_packages
                    StatusBar="Clean Orphan Packages Completed."
                    ;;
               19)  # Edit Configuration
                    MenuChecks[$(($OPT - 1))]=1
                    get_hostname
                    configure_timezone
                    get_user_name
                    add_custom_repositories
                    StatusBar="Edit Configuration Completed."
                    ;;
               20)  # Load Custom Software
                    MenuChecks[$(($OPT - 1))]=1
                    # load_custom_software
                    StatusBar="Load Custom Software Completed."
                    ;;
               21)  # Load Software
                    MenuChecks[$(($OPT - 1))]=1
                    load_software # @FIX
                    StatusBar="Load Software Completed."
                    ;;
               22)  # Save Software
                    MenuChecks[$(($OPT - 1))]=1
                    save_software
                    SAVED_SOFTWARE=1
                    StatusBar="Save Software Completed."
                    ;;
               23)  # Install Software
                    MenuChecks[$(($OPT - 1))]=1
                    save_software
                    SAVED_SOFTWARE=1
                    if [[ "$MOUNTPOINT" == " " ]]; then
                        install_software_live
                    fi
                    OPT="q"
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                    fi
                    break;
                    StatusBar="Install Software Completed."
                    ;;
              "q")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                    fi
                    if [[ "$SAVED_SOFTWARE" -eq 0 ]]; then
                        read_input_yn "Save-Software-Configuration" " " 1
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
# INSTALL BASIC {{{
NAME="install_basic"
USAGE=$(localize "INSTALL-BASIC-USAGE")
DESCRIPTION=$(localize "INSTALL-BASIC-DESC")
NOTES=$(localize "INSTALL-BASIC-NOTES")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-BASIC-USAGE" "install_basic 1->[1=Install, 2=Remove]"
localize_info "INSTALL-BASIC-DESC"  "Install Basic Packages"
localize_info "INSTALL-BASIC-NOTES" "NONE"
# -------------------------------------
install_basic()
{
    # 1
    install_basic_setup "$1"
    install_xorg "$1"
    install_nfs_pack "$1"
    install_samba_pack "$1"
    install_laptop_mode_tools_pack "$1"
    install_preload_pack "$1"
    install_zram "$1"
    install_git_tor_pack "$1"
    #
    install_additional_firmwares "$1"
    install_network_manager "$1"
    #
    install_cups "$1"
    install_usb_modem "$1"
    choose_aurhelper "$1"
    install_video_cards "$1"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL GIT TOR {{{
NAME="install_git_tor_pack"
USAGE=$(localize "INSTALL-GIT-TOR-USAGE")
DESCRIPTION=$(localize "INSTALL-GIT-TOR-DESC")
NOTES=$(localize "INSTALL-GIT-TOR-NOTES")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-GIT-TOR-USAGE" "install_git_tor_pack 1->[1=Install, 2=Remove]"
localize_info "INSTALL-GIT-TOR-DESC"  "Install GIT TOR Packages"
localize_info "INSTALL-GIT-TOR-NOTES" "NONE"
#
localize_info "INSTALL-GIT-TOR-TITLE" "GIT-TOR"
localize_info "INSTALL-GIT-TOR-INFO"  "Tor is an open source implementation of 2nd generation onion routing that provides free access to an anonymous proxy network. Its primary goal is to enable online anonymity by protecting against traffic analysis attacks."
localize_info "INSTALL-GIT-TOR-YN"    "Ensuring access to GIT through a firewall (bypass college/work firewall)"
# -------------------------------------
install_git_tor_pack()
{
    if [[ "$1" -eq 2 ]]; then
        remove_package "$INSTALL_GIT_TOR"
        remove_packagemanager "INSTALL-GIT-TOR"
        CONFIG_TOR=0
        return 0
    fi
    print_title "INSTALL-GIT-TOR-TITLE" " - https://wiki.archlinux.org/index.php/Tor"
    print_info  "INSTALL-GIT-TOR-INFO"
    read_input_yn "INSTALL-GIT-TOR-YN" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        
        add_package "$INSTALL_GIT_TOR"
        add_packagemanager "package_install \"$INSTALL_GIT_TOR\" 'INSTALL-GIT-TOR'" "INSTALL-GIT-TOR"
        add_packagemanager "systemctl enable tor.service privoxy.service" "SYSTEMD-ENABLE-GIT-TOR"
        CONFIG_TOR=1
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL BASIC SETUP {{{
NAME="install_basic_setup"
USAGE=$(localize "INSTALL-BASIC-SETUP-USAGE")
DESCRIPTION=$(localize "INSTALL-BASIC-SETUP-DESC")
NOTES=$(localize "INSTALL-BASIC-SETUP-NOTES")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-BASIC-SETUP-USAGE" "install_basic_setup 1->[1=Install, 2=Remove]"
localize_info "INSTALL-BASIC-SETUP-DESC"  "Install Basic Packages"
localize_info "INSTALL-BASIC-SETUP-NOTES" "NONE"
#
localize_info "INSTALL-BASIC-SETUP-TITLE"           "The Following will be installed by Default."
localize_info "INSTALL-BASIC-SETUP-INFO-SYSTEMD"    "SYSTEMD"
localize_info "INSTALL-BASIC-SETUP-INFO-SYSTEMD-1"  "systemd is a replacement for the init daemon for Linux (either System V or BSD-style). It is intended to provide a better framework for expressing services' dependencies, allow more work to be done in parallel at system startup, and to reduce shell overhead."
localize_info "INSTALL-BASIC-SETUP-INFO-BASH-TOOLS" "BASH TOOLS"
localize_info "INSTALL-BASIC-SETUP-ARCHIVE-TOOLS"   "(UN)COMPRESS TOOLS - https://wiki.archlinux.org/index.php/P7zip"
localize_info "INSTALL-BASIC-SETUP-INFO-AVAHI"      "AVAHI"
localize_info "INSTALL-BASIC-SETUP-INFO-AVAHI-1"    "Avahi is a free Zero Configuration Networking (Zeroconf) implementation, including a system for multicast DNS/DNS-SD service discovery. It allows programs to publish and discover services and hosts running on a local network with no specific configuration."
localize_info "INSTALL-BASIC-SETUP-INFO-ACPI"       "ACPI"
localize_info "INSTALL-BASIC-SETUP-ACPI-1"          "acpid is a flexible and extensible daemon for delivering ACPI events."
localize_info "INSTALL-BASIC-SETUP-ALSA"            "ALSA"
localize_info "INSTALL-BASIC-SETUP-ALSA-1"          "The Advanced Linux Sound Architecture (ALSA) is a Linux kernel component intended to replace the original Open Sound System (OSSv3) for providing device drivers for sound cards."
localize_info "INSTALL-BASIC-SETUP-NTFS-1"          "NTFS/FAT/exFAT"
localize_info "INSTALL-BASIC-SETUP-NTFS-2"          "A file system (or filesystem) is a means to organize data expected to be retained after a program terminates by providing procedures to store, retrieve and update data, as well as manage the available space on the device(s) which contain it. A file system organizes data in an efficient manner and is tuned to the specific characteristics of the device."
localize_info "INSTALL-BASIC-SETUP-SSH-1"           "SSH"
localize_info "INSTALL-BASIC-SETUP-SSH-2"           "Secure Shell (SSH) is a network protocol that allows data to be exchanged over a secure channel between two computers."
# -------------------------------------
install_basic_setup()
{
    if [[ "$1" -eq 2 ]]; then
        # SYSTEMD
        remove_package        "$INSTALL_SYSTEMD"
        remove_packagemanager "INSTALL-SYSTEMD"
        remove_packagemanager "SYSTEMD-ENABLE-SYSTEMD"
        # BASH-TOOLS
        remove_package        "$INSTALL_BASH_TOOLS"
        remove_packagemanager "INSTALL-BASH-TOOLS"
        remove_packagemanager "SYSTEMD-ENABLE-BASH-TOOLS"
        # ARCHIVE-TOOLS AUR
        remove_aur_package    "$AUR_INSTALL_ARCHIVE_TOOLS"
        remove_packagemanager "AUR-INSTALL-ARCHIVE-TOOLS"
        # AVAHI
        remove_package "$INSTALL_AVAHI"
        remove_packagemanager "INSTALL-AVAHI"
        remove_packagemanager "SYSTEMD-ENABLE-AVAHI"
        # ACPI
        remove_package "$INSTALL_ACPI"
        remove_packagemanager "INSTALL-ACPI"
        remove_packagemanager "SYSTEMD-ENABLE-ACPI"
        # ALSA
        remove_module "INSTALL-ALSA"
        remove_package "$INSTALL_ALSA"
        remove_packagemanager "INSTALL-ALSA"
        remove_packagemanager "SYSTEMD-ENABLE-ALSA"
        # NTFS
        remove_module "INSTALL-NTFS"
        remove_package "$INSTALL_NTFS"
        remove_packagemanager "INSTALL-NTFS"
        # SSH
        remove_package "$INSTALL_SSH"
        remove_packagemanager "INSTALL-SSH"
        remove_packagemanager "AUR-INSTALL-SSH"
        remove_packagemanager "SYSTEMD-ENABLE-SSH"
        CONFIG_SSH=0
        return 0
    fi
    # SYSTEMD
    print_title "INSTALL-BASIC-SETUP-TITLE"
    print_info  "INSTALL-BASIC-SETUP-INFO-SYSTEMD" " - https://wiki.archlinux.org/index.php/Systemd"
    print_info  "INSTALL-BASIC-SETUP-INFO-SYSTEMD-1"
    add_package        "$INSTALL_SYSTEMD"
    add_packagemanager "package_install \"$INSTALL_SYSTEMD\" 'INSTALL-SYSTEMD'" "INSTALL-SYSTEMD"
    add_packagemanager "systemctl enable syslog-ng.service cronie.service" "SYSTEMD-ENABLE-SYSTEMD"
    # BASH-TOOLS
    print_info "INSTALL-BASIC-SETUP-INFO-BASH-TOOLS" " - https://wiki.archlinux.org/index.php/Bash"
    add_package        "$INSTALL_BASH_TOOLS"
    add_packagemanager "package_install \"$INSTALL_BASH_TOOLS\" 'INSTALL-BASH-TOOLS'" "INSTALL-BASH-TOOLS"
    add_packagemanager "systemctl enable ntpd.service" "SYSTEMD-ENABLE-BASH-TOOLS"
    # ARCHIVE-TOOLS
    print_info "INSTALL-BASIC-SETUP-ARCHIVE-TOOLS"
    add_aur_package    "$AUR_INSTALL_ARCHIVE_TOOLS"
    add_packagemanager "aur_package_install \"$AUR_INSTALL_ARCHIVE_TOOLS\" 'AUR-INSTALL-ARCHIVE-TOOLS'" "AUR-INSTALL-ARCHIVE-TOOLS"
    # AVAHI   
    print_info "INSTALL-BASIC-SETUP-INFO-AVAHI" " - https://wiki.archlinux.org/index.php/Avahi"
    print_info "INSTALL-BASIC-SETUP-INFO-AVAHI-1"
    add_package "$INSTALL_AVAHI"
    add_packagemanager "package_install \"$INSTALL_AVAHI\" 'INSTALL-AVAHI'" "INSTALL-AVAHI"
    add_packagemanager "systemctl enable avahi-daemon.service avahi-dnsconfd.service" "SYSTEMD-ENABLE-AVAHI"
    # ACPI
    print_info "INSTALL-BASIC-SETUP-INFO-ACPI" " - https://wiki.archlinux.org/index.php/ACPI_modules"
    print_info "INSTALL-BASIC-SETUP-ACPI-1"
    add_package "$INSTALL_ACPI"
    add_packagemanager "package_install \"$INSTALL_ACPI\" 'INSTALL-ACPI'" "INSTALL-ACPI"
    add_packagemanager "systemctl enable acpid.service" "SYSTEMD-ENABLE-ACPI"
    # ALSA
    print_info "INSTALL-BASIC-SETUP-ALSA" " - https://wiki.archlinux.org/index.php/Alsa"
    print_info "INSTALL-BASIC-SETUP-ALSA-1"
    add_package        "$INSTALL_ALSA"
    add_packagemanager "package_install \"$INSTALL_ALSA\" 'INSTALL-ALSA'" "INSTALL-ALSA"
    add_module         "snd-usb-audio" "INSTALL-ALSA"
    add_packagemanager "systemctl enable alsa-store.service alsa-restore.service" "SYSTEMD-ENABLE-ALSA"
    # NTFS   
    print_info "INSTALL-BASIC-SETUP-NTFS-1" " - https://wiki.archlinux.org/index.php/File_Systems"
    print_info "INSTALL-BASIC-SETUP-NTFS-2"
    add_package        "$INSTALL_NTFS"
    add_packagemanager "package_install \"$INSTALL_NTFS\" 'INSTALL-NTFS'" "INSTALL-NTFS"
    add_module         "fuse" "INSTALL-NTFS"
    # SSH
    print_info "INSTALL-BASIC-SETUP-SSH-1" " - https://wiki.archlinux.org/index.php/Ssh"
    print_info "INSTALL-BASIC-SETUP-SSH-2"
    add_package "$INSTALL_SSH"
    add_packagemanager "package_install \"$INSTALL_SSH\" 'INSTALL-SSH'" "INSTALL-SSH"
    add_aur_package    "$AUR_INSTALL_SSH"
    add_packagemanager "aur_package_install \"$AUR_INSTALL_SSH\" 'AUR-INSTALL-SSH'" "AUR-INSTALL-SSH"
    add_packagemanager "systemctl enable sshd.service" "SYSTEMD-ENABLE-SSH"
    CONFIG_SSH=1
    pause_function "$LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL NFS {{{
NAME="install_nfs_pack"
USAGE=$(localize "INSTALL-NFS-USAGE")
DESCRIPTION=$(localize "INSTALL-NFS-DESC")
NOTES=$(localize "INSTALL-NFS-NOTES")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-NFS-USAGE" "install_nfs_pack 1->[1=Install, 2=Remove]"
localize_info "INSTALL-NFS-DESC"  "Install NFS Packages"
localize_info "INSTALL-NFS-NOTES" "NONE"
#
localize_info "INSTALL-NFS-TITLE" "NFS"
localize_info "INSTALL-NFS-INFO"  "NFS allowing a user on a client computer to access files over a network in a manner similar to how local storage is accessed."
localize_info "INSTALL-NFS-YN"    "Install NFS"
# -------------------------------------
install_nfs_pack()
{
    if [[ "$1" -eq 2 ]]; then
        remove_package "$INSTALL_NFS"
        remove_packagemanager "INSTALL-NFS"
        remove_packagemanager "SYSTEMD-ENABLE-NFS"
        return 0
    fi
    print_title "INSTALL-NFS-TITLE" " - https://wiki.archlinux.org/index.php/Nfs"
    print_info  "INSTALL-NFS-INFO"
    read_input_yn "INSTALL-NFS-YN" 1
    if [[ $YN_OPTION -eq 1 ]]; then
        add_package "$INSTALL_NFS"
        add_packagemanager "package_install \"$INSTALL_NFS\" 'INSTALL-NFS'" "INSTALL-NFS"
        add_packagemanager "systemctl enable rpc-statd.service" "SYSTEMD-ENABLE-NFS"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL SAMBA {{{
NAME="install_samba_pack"
USAGE=$(localize "INSTALL-SAMBA-USAGE")
DESCRIPTION=$(localize "INSTALL-SAMBA-DESC")
NOTES=$(localize "INSTALL-SAMBA-NOTES")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-SAMBA-USAGE" "install_samba_pack 1->[1=Install, 2=Remove]"
localize_info "INSTALL-SAMBA-DESC"  "Install samba Packages"
localize_info "INSTALL-SAMBA-NOTES" "NONE"
#
localize_info "INSTALL-SAMBA-TITLE" "SAMBA"
localize_info "INSTALL-SAMBA-INFO"  "Samba is a re-implementation of the SMB/CIFS networking protocol, it facilitates file and printer sharing among Linux and Windows systems as an alternative to NFS."
localize_info "INSTALL-SAMBA-YN"    "Install Samba"
# -------------------------------------
install_samba_pack()
{
    if [[ "$1" -eq 2 ]]; then
        # @FIX this is just a TEMPLATE
        remove_package "$INSTALL_SAMBA"
        remove_packagemanager "INSTALL-SAMBA"
        remove_packagemanager "COPY-CONFIG-SAMBA"
        remove_packagemanager "SYSTEMD-ENABLE-SAMBA"
        return 0
    fi
    print_title "INSTALL-SAMBA-TITLE" " - https://wiki.archlinux.org/index.php/Samba"
    print_info  "INSTALL-SAMBA-INFO"
    read_input_yn "INSTALL-SAMBA-YN" 1
    if [[ $YN_OPTION -eq 1 ]]; then
        add_package "$INSTALL_SAMBA"
        add_packagemanager "package_install \"$INSTALL_SAMBA\" 'INSTALL-SAMBA'" "INSTALL-SAMBA"
        add_packagemanager "cp /etc/samba/smb.conf.default /etc/samba/smb.conf" "COPY-CONFIG-SAMBA"
        add_packagemanager "systemctl enable smbd.service enable nmbd.service winbindd.service" "SYSTEMD-ENABLE-SAMBA"
        # installing samba will overwrite /etc/samba/smb.conf so copy it to temp 
        copy_file "/etc/samba/smb.conf" "${SCRIPT_DIR}/etc/samba/smb.conf" "$LINENO"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL PRELOAD {{{
NAME="install_preload_pack"
USAGE=$(localize "INSTALL-PRELOAD-USAGE")
DESCRIPTION=$(localize "INSTALL-PRELOAD-DESC")
NOTES=$(localize "INSTALL-PRELOAD-NOTES")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-PRELOAD-USAGE" "install_preload_pack 1->[1=Install, 2=Remove]"
localize_info "INSTALL-PRELOAD-DESC"  "Install preload Packages"
localize_info "INSTALL-PRELOAD-NOTES" "NONE"
#
localize_info "INSTALL-PRELOAD-TITLE" "PRELOAD"
localize_info "INSTALL-PRELOAD-INFO"  "Preload is a program which runs as a daemon and records statistics about usage of programs using Markov chains; files of more frequently-used programs are, during a computer's spare time, loaded into memory. This results in faster startup times as less data needs to be fetched from disk. preload is often paired with prelink."
localize_info "INSTALL-PRELOAD-YN"    "Install Preload"
# -------------------------------------
install_preload_pack()
{
    if [[ "$1" -eq 2 ]]; then
        remove_package "$INSTALL_PRELOAD"
        remove_packagemanager "INSTALL-PRELOAD"
        remove_packagemanager "SYSTEMD-ENABLE-PRELOAD"
        return 0
    fi
    print_title "INSTALL-PRELOAD-TITLE" " - https://wiki.archlinux.org/index.php/Preload"
    print_info  "INSTALL-PRELOAD-INFO"
    read_input_yn "INSTALL-PRELOAD-YN" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        add_package "$INSTALL_PRELOAD"
        add_packagemanager "package_install \"$INSTALL_PRELOAD\" 'INSTALL-PRELOAD'" "INSTALL-PRELOAD"
        add_packagemanager "systemctl enable preload.service" "SYSTEMD-ENABLE-PRELOAD"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL ZRAM {{{
NAME="install_zram"
USAGE=$(localize "INSTALL-ZRAM-USAGE")
DESCRIPTION=$(localize "INSTALL-ZRAM-DESC")
NOTES=$(localize "INSTALL-ZRAM-NOTES")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-ZRAM-USAGE" "install_zram 1->[1=Install, 2=Remove]"
localize_info "INSTALL-ZRAM-DESC"  "Install zram Packages"
localize_info "INSTALL-ZRAM-NOTES" "NONE"
#
localize_info "INSTALL-ZRAM-TITLE" "ZRAM"
localize_info "INSTALL-ZRAM-INFO"  "Zram creates a device in RAM and compresses it. If you use for swap means that part of the RAM can hold much more information but uses more CPU. Still, it is much quicker than swapping to a hard drive. If a system often falls back to swap, this could improve responsiveness. Zram is in mainline staging (therefore its not stable yet, use with caution)."
localize_info "INSTALL-ZRAM-YN"    "Install Zram"
# -------------------------------------
install_zram()
{
    if [[ "$1" -eq 2 ]]; then
        # @FIX this is just a TEMPLATE
        remove_aur_package    "$AUR_INSTALL_ZRAM"
        remove_packagemanager "AUR-INSTALL-ZRAM"
        remove_packagemanager "SYSTEMD-ENABLE-ZRAM"
        return 0
    fi
    print_title "INSTALL-ZRAM-TITLE" " - https://wiki.archlinux.org/index.php/Maximizing_Performance"
    print_info  "INSTALL-ZRAM-INFO" 
    read_input_yn "INSTALL-ZRAM-YN" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        add_aur_package "$AUR_INSTALL_ZRAM"
        add_packagemanager "aur_package_install \"$AUR_INSTALL_ZRAM\" 'AUR-INSTALL-ZRAM'" "AUR-INSTALL-ZRAM"
        add_packagemanager "systemctl enable zram.service" "SYSTEMD-ENABLE-ZRAM"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL INSTALL LAPTOP MODE TOOLS {{{
NAME="install_laptop_mode_tools_pack"
USAGE=$(localize "INSTALL-LAPTOP-MODE-TOOLS-USAGE")
DESCRIPTION=$(localize "INSTALL-LAPTOP-MODE-TOOLS-DESC")
NOTES=$(localize "INSTALL-LAPTOP-MODE-TOOLS-NOTES")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-LAPTOP-MODE-TOOLS-USAGE" "install_laptop_mode_tools_pack 1->[1=Install, 2=Remove]"
localize_info "INSTALL-LAPTOP-MODE-TOOLS-DESC"  "Install LAPTOP-MODE-TOOLS Packages"
localize_info "INSTALL-LAPTOP-MODE-TOOLS-NOTES" "NONE"
#
localize_info "INSTALL-LAPTOP-MODE-TOOLS-TITLE" "LAPTOP MODE TOOLS"
localize_info "INSTALL-LAPTOP-MODE-TOOLS-INFO"  "Laptop Mode Tools is a laptop power saving package for Linux systems. It is the primary way to enable the Laptop Mode feature of the Linux kernel, which lets your hard drive spin down. In addition, it allows you to tweak a number of other power-related settings using a simple configuration file."
localize_info "INSTALL-LAPTOP-MODE-TOOLS-YN"    "Install Laptop Mode Tools"
# -------------------------------------
install_laptop_mode_tools_pack()
{
    if [[ "$1" -eq 2 ]]; then
        # @FIX this is just a TEMPLATE
        remove_package "$INSTALL_LAPTOP_MODE_TOOLS"
        remove_packagemanager "INSTALL-LAPTOP-MODE-TOOLS"
        remove_packagemanager "SYSTEMD-ENABLE-LAPTOP-MODE-TOOLS"
        return 0
    fi
    print_title "INSTALL-LAPTOP-MODE-TOOLS-TITLE" "- https://wiki.archlinux.org/index.php/Laptop_Mode_Tools"
    print_info  "INSTALL-LAPTOP-MODE-TOOLS-INFO"
    read_input_yn "INSTALL-LAPTOP-MODE-TOOLS-YN" 0
    if [[ $YN_OPTION -eq 1 ]]; then
        add_package        "$INSTALL_LAPTOP_MODE_TOOLS"
        add_packagemanager "package_install \"$INSTALL_LAPTOP_MODE_TOOLS\" 'INSTALL-LAPTOP-MODE-TOOLS'" "INSTALL-LAPTOP-MODE-TOOLS"
        add_packagemanager "systemctl enable laptop-mode-tools.service" "SYSTEMD-ENABLE-LAPTOP-MODE-TOOLS"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL XORG {{{
NAME="install_xorg"
USAGE=$(localize "INSTALL-XORG-USAGE")
DESCRIPTION=$(localize "INSTALL-XORG-DESC")
NOTES=$(localize "INSTALL-XORG-NOTES")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-XORG-USAGE" "install_xorg 1->[1=Install, 2=Remove]"
localize_info "INSTALL-XORG-DESC"  "Install Basic Packages"
localize_info "INSTALL-XORG-NOTES" "NONE"
#
localize_info "INSTALL-XORG-TITLE"   "XORG"
localize_info "INSTALL-XORG-INFO-1"  "Xorg is the public, open-source implementation of the X window system version 11."
localize_info "INSTALL-XORG-INFO-2"  "Installing X-Server (req. for Desktopenvironment, GPU Drivers, Keyboardlayout,...)"
localize_info "INSTALL-XORG-SELECT"  "Select keyboard layout:"
# -------------------------------------
install_xorg()
{
    if [[ "$1" -eq 2 ]]; then
        remove_package        "$INSTALL_XORG"
        remove_packagemanager "INSTALL-XORG"
        return 0
    fi
    print_title "INSTALL-XORG-TITLE" " - https://wiki.archlinux.org/index.php/Xorg"
    print_info  "INSTALL-XORG-INFO-1"
    print_this  "INSTALL-XORG-INFO-2"
    add_package        "$INSTALL_XORG"
    add_packagemanager "package_install \"$INSTALL_XORG\" 'INSTALL-XORG'" "INSTALL-XORG"
    CONFIG_XORG=1
    # @FIX point to function
    if [[ "$LANGUAGE" == 'es_ES' ]]; then
        KBLAYOUT=("es" "latam");
        PS3="$prompt1"
        print_info "INSTALL-XORG-SELECT"
        select KBRD in "${KBLAYOUT[@]}"; do
            KEYBOARD="$KBRD"
        done
    fi    
    pause_function "$LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL DESKTOP ENVIRONMENT {{{
NAME="install_desktop_environment"
USAGE="install_desktop_environment"
DESCRIPTION="Install Desktop Environment"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_desktop_environment() 
{ 
    # 2
    local -r menu_name="DESKTOP-ENVIRONMENT"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "DESKTOP ENVIRONMENT - https://wiki.archlinux.org/index.php/Desktop_Environment"
        print_this "A Desktop environments (DE) provide a complete graphical user interface (GUI) for a system by bundling together a variety of X clients written using a common widget toolkit and set of libraries."
        print_this "Mate, KDE, XFCE, Awesome, Cinnamon, E17, LXDE, OpenBox, GNOME, and Unity"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Mate"      "The Way Gnome should be..." "Installs from repo.mate-desktop.org" "Mate: Fork of Gnome 2.x" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "KDE"       "" ""      "KDE:" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "XFCE"      "" ""      "XFCE:" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Awesome"   "" ""      "Awesome:" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Cinnamon"  "" "$AUR"  "Cinnamon" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "E17"       "" ""      "E17"              "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "LXDE"      "" ""      "LXDE"             "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "OpenBox"   "" ""      "OpenBox"          "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GNOME"     "" "$AUR"  "Gnome:"           "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Unity"     "" ""      "Unity: "          "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "DE Extras" "" ""      "Desktop Extras: " "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_mate
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_kde
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_xfce
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_awesome
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_cinnamon
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_e17
                    ;;
                7)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_lxde
                    ;;
                8)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_openbox
                    ;;
                9)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_gnome
                    ;;
                10)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_unity
                    ;;
                11)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_de_extras
                    ;;
               "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_mate"
USAGE="install_mate"
DESCRIPTION="Installs Mate Desktop."
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_mate()
{
    # 1
    print_title "Mate - https://wiki.archlinux.org/index.php/MATE"
    print_info "Install Mate Desktop - Recommended over Gnome, its like Gnome 2, without the Crazy Gnome 3 stuff."
    print_info "Full List: $INSTALL_MATE" 
    MATE_INSTALLED=1
    GNOME_INSTALL=1
    add_taskmanager "add_repo \"mate\" \"http://repo.mate-desktop.org/archlinux/\" \"Optional TrustedOnly\" 1" "ADD-REPO-MATE"
    add_packagemanager "package_remove 'zenity'" "REMOVE-MATE" # mate replacement
    add_package "$INSTALL_MATE"
    add_packagemanager "package_install \"$INSTALL_MATE\" 'INSTALL-MATE'" "INSTALL-MATE"
    add_packagemanager "systemctl enable accounts-daemon.service polkitd.service upower.service console-kit-daemon.service" "SYSTEMD-ENABLE-MATE"
    # pacstrap will overwrite pacman.conf so copy it to temp 
    # copy_file ${MOUNTPOINT}/etc/pacman.conf "${SCRIPT_DIR}"/etc/pacman.conf "$(basename $BASH_SOURCE) : $LINENO"
    pause_function "$(basename $BASH_SOURCE) : $LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL KDE {{{
NAME="install_kde"
USAGE="install_kde"
DESCRIPTION="Install KDE"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_kde()
{
    # 2
    local -i total_menu_items=8    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-KDE"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    print_title "KDE - https://wiki.archlinux.org/index.php/KDE"
    print_info "KDE is an international free software community producing an integrated set of cross-platform applications designed to run on Linux, FreeBSD, Microsoft Windows, Solaris and Mac OS X systems. It is known for its Plasma Desktop, a desktop environment provided as the default working environment on many Linux distributions."
    add_package "$INSTALL_KDE"
    add_packagemanager "package_install \"$INSTALL_KDE\" 'INSTALL-KDE'" "INSTALL-KDE" # "kde-telepathy telepathy"
    add_packagemanager "package_remove 'kdemultimedia-kscd kdemultimedia-juk'" "REMOVE-KDE"
    add_aur_package "$AUR_INSTALL_KDE" # 
    add_packagemanager "aur_package_install \"$AUR_INSTALL_KDE\" 'AUR-INSTALL-KDE'" "AUR-INSTALL-KDE"
    CONFIG_KDE=1
    while [[ 1 ]]; do
        print_title "KDE CUSTOMIZATION"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "apper"         "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "bangarang"     "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "choqok"        "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "digikam"       "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "k3b"           "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "rosa-icons"    "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Plasma Themes" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "yakuake"       "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_APPER"
                    add_packagemanager "package_install \"$INSTALL_APPER\" 'INSTALL-APPER'" "INSTALL-APPER"
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_BANGARANG" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_BANGARANG\" 'AUR-INSTALL-BANGARANG'" "AUR-INSTALL-BANGARANG"
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_CHOQOK" #  
                    add_packagemanager "package_install \"$INSTALL_CHOQOK\" 'INSTALL-CHOQOK'" "INSTALL-CHOQOK"
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_DIGIKAM" #  
                    add_packagemanager "package_install \"$INSTALL_DIGIKAM\" 'INSTALL-DIGIKAM'" "INSTALL-DIGIKAM"
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_K3B" #  
                    add_packagemanager "package_install \"$INSTALL_K3B\" 'INSTALL-K3B'" "INSTALL-K3B"
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ROSA_ICONS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ROSA_ICONS\" 'AUR-INSTALL-ROSA-ICONS'" "AUR-INSTALL-ROSA-ICONS"
                    ;;
                7)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_PLASMA_THEMES" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_PLASMA_THEMES\" 'AUR-INSTALL-PLASMA-THEMES'" "AUR-INSTALL-PLASMA-THEMES"
                    ;;
                8)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_YAKUAKE" #  
                    add_packagemanager "package_install \"$INSTALL_YAKUAKE\" 'INSTALL-YAKUAKE'" "INSTALL-YAKUAKE"
                    add_aur_package "$AUR_INSTALL_YAKUAKE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_YAKUAKE\" 'AUR-INSTALL-YAKUAKE'" "AUR-INSTALL-YAKUAKE"
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# -----------------------------------------------------------------------------
# INSTALL GNOME {{{
NAME="install_gnome"
USAGE="install_gnome"
DESCRIPTION=$(localize "CONFIGURE-GNOME-DESC")
NOTES=$(localize "CONFIGURE-GNOME-NOTES")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "CONFIGURE-GNOME-DESC"    "Install Gnome"
localize_info "CONFIGURE-GNOME-NOTES"   "None."
#
localize_info "CONFIGURE-GNOME-TITLE" "GNOME"
localize_info "CONFIGURE-GNOME-INFO-1" "GNOME is a desktop environment and graphical user interface that runs on top of a computer operating system. It is composed entirely of free and open source software. It is an international project that includes creating software development frameworks, selecting application software for the desktop, and working on the programs that manage application launching, file handling, and window and task management."
localize_info "CONFIGURE-GNOME-INFO-2" "GNOME Shell Extensions: disper gpaste gnome-shell-extension-gtile-git gnome-shell-extension-mediaplayer-git gnome-shell-extension-noa11y-git gnome-shell-extension-pomodoro-git gnome-shell-extension-user-theme-git gnome-shell-extension-weather-git gnome-shell-system-monitor-applet-git"
localize_info "CONFIGURE-GNOME-INFO-3" "GNOME Shell Themes: gnome-shell-theme-default-mod gnome-shell-theme-dark-shine gnome-shell-theme-elegance gnome-shell-theme-eos gnome-shell-theme-frieze gnome-shell-theme-google+"
# -------------------------------------

install_gnome()
{
    # 9
    GNOME_INSTALLED=1
    CONFIG_GNOME=1
    local -i total_menu_items=6    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-GNOME"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    print_title "CONFIGURE-GNOME-TITLE" " - https://wiki.archlinux.org/index.php/GNOME"
    print_info  "CONFIGURE-GNOME-INFO-1"
    print_info  "CONFIGURE-GNOME-INFO-2"
    print_info  "CONFIGURE-GNOME-INFO-3"
    add_package "$INSTALL_GNOME" #  
    add_packagemanager "package_install \"$INSTALL_GNOME\" 'INSTALL-GNOME'" "INSTALL-GNOME"
    # telepathy
    while [[ 1 ]]; do
        print_title "GNOME CUSTOMIZATION"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GNOME Shell Extensions" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GNOME Shell Themes" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GNOME Packagekit" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "activity-journal" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "activity-log-manager" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gloobus-sushi-bzr" "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_gnomeshell_extensions
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_gnomeshell_themes
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GNOME_PACKAGEKIT" #  
                    add_packagemanager "package_install \"$INSTALL_GNOME_PACKAGEKIT\" 'INSTALL-GNOME-PACKAGEKIT'" "INSTALL-GNOME-PACKAGEKIT"
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    # activity-journal
                    add_aur_package "$AUR_INSTALL_GNOME_CUSTOM_ACT_JOURNAL" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_CUSTOM_ACT_JOURNAL\" 'AUR-INSTALL-GNOME-CUSTOM-ACT-JOURNAL'" "AUR-INSTALL-GNOME-CUSTOM-ACT-JOURNAL"
                    ;;
                5)
                    # activity-log-manager
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_CUSTOM_ACT_LOG_MANAGER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_CUSTOM_ACT_LOG_MANAGER\" 'AUR-INSTALL-GNOME-CUSTOM-ACT-LOG-MANAGER'" "AUR-INSTALL-GNOME-CUSTOM-ACT-LOG-MANAGER"
                    ;;
                6)
                    # gloobus-sushi-bzr
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_CUSTOM_GLOOBUS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_CUSTOM_GLOOBUS\" 'AUR-INSTALL-GNOME-CUSTOM-GLOOBUS'" "AUR-INSTALL-GNOME-CUSTOM-GLOOBUS"
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# INSTALL GNOMESHELL EXTENSIONS  {{{
NAME="install_gnomeshell_extensions"
USAGE="install_gnomeshell_extensions"
DESCRIPTION="install_gnomeshell_extensions"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_gnomeshell_extensions()
{
    local -i total_menu_items=9    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-GNOMESHELL-EXTENSIONS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "GNOMESHELL EXTENSIONS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "disper" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gpaste" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "mediaplayer" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "noa11y" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "pomodoro" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "System-monitor-applet" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "user-theme" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "weather" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gtile" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_DISPER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_DISPER\" 'AUR-INSTALL-GSHELL-DISPER'" "AUR-INSTALL-GSHELL-DISPER"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_GPASTE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_GPASTE\" 'AUR-INSTALL-GSHELL-GPASTE'" "AUR-INSTALL-GSHELL-GPASTE"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_MEDIAPLAYER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_MEDIAPLAYER\" 'AUR-INSTALL-GSHELL-MEDIAPLAYER'" "AUR-INSTALL-GSHELL-MEDIAPLAYER"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_NOA11Y" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_NOA11Y\" 'AUR-INSTALL-GSHELL-NOA11Y'" "AUR-INSTALL-GSHELL-NOA11Y"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_POMODORO" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_POMODORO\" 'AUR-INSTALL-GSHELL-POMODORO'" "AUR-INSTALL-GSHELL-POMODORO"
                    ;;
                6)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_SYSTEM_MONITOR" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_SYSTEM_MONITOR\" 'AUR-INSTALL-GSHELL-SYSTEM-MONITOR'" "AUR-INSTALL-GSHELL-SYSTEM-MONITOR"
                    ;;
                7)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_USER_THEME" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_USER_THEME\" 'AUR-INSTALL-GSHELL-USER-THEME'" "AUR-INSTALL-GSHELL-USER-THEME"
                    ;;
                8)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_WEATHER" # \"$AUR_INSTALL_GSHELL_WEATHER\"
                    add_packagemanager "aur_package_install '' 'AUR-INSTALL-GSHELL-WEATHER'" "AUR-INSTALL-GSHELL-WEATHER"
                    ;;
                9)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_GTILE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_GTILE\" 'AUR-INSTALL-GSHELL-GTILE'" "AUR-INSTALL-GSHELL-GTILE"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
               *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL GNOMESHELL THEMES {{{
NAME="install_gnomeshell_themes"
USAGE="install_gnomeshell_themes"
DESCRIPTION="Install Gnomeshell Themes"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_gnomeshell_themes()
{
    local -i total_menu_items=6    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-GNOMESHELL-THEMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "GNOMESHELL THEMES"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "default-mod" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "dark-shine" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "elegance" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "eos" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "frieze" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "google+" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_THEMES_DEFAULT" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_DEFAULT\" 'AUR-INSTALL-GSHELL-THEMES-DEFAULT'" "AUR-INSTALL-GSHELL-THEMES-DEFAULT"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_THEMES_DARK_SHINE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_DARK_SHINE\" 'AUR-INSTALL-GSHELL-THEMES-DARK-SHINE'" "AUR-INSTALL-GSHELL-THEMES-DARK-SHINE"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_THEMES_ELEGANCE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_ELEGANCE\" 'AUR-INSTALL-GSHELL-THEMES-ELEGANCE'" "AUR-INSTALL-GSHELL-THEMES-ELEGANCE"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_THEMES_EOS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_EOS\" 'AUR-INSTALL-GSHELL-THEMES-EOS'" "AUR-INSTALL-GSHELL-THEMES-EOS"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_THEMES_FRIEZE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_FRIEZE\" 'AUR-INSTALL-GSHELL-THEMES-FRIEZE'" "AUR-INSTALL-GSHELL-THEMES-FRIEZE"
                    ;;
                6)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_THEMES_GOOGLE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_GOOGLE\" 'AUR-INSTALL-GSHELL-THEMES-GOOGLE'" "AUR-INSTALL-GSHELL-THEMES-GOOGLE"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
                *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL AWESOME {{{
NAME="install_awesome"
USAGE="install_awesome"
DESCRIPTION="Install Awesome"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_awesome()
{
    # 4
    local -i total_menu_items=10    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-AWESOME"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    AWESOME_INSTALLED=1
    add_package "$INSTALL_AWESOME" #  
    add_packagemanager "package_install \"$INSTALL_AWESOME\" 'INSTALL-AWESOME'" "INSTALL-AWESOME"
    add_aur_package "$AUR_INSTALL_AWESOME" # 
    add_packagemanager "aur_package_install \"$AUR_INSTALL_AWESOME\" 'AUR-INSTALL-AWESOME'" "AUR-INSTALL-AWESOME"
    TEMP=$(config_xinitrc 'awesome')
    add_packagemanager "$TEMP" "CONFIG-XINITRC-AWESOME"
    add_packagemanager "make_dir \"/home/$USERNAME/.config/awesome/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/awesome/rc.lua' \"/home/$USERNAME/.config/awesome/\" \"$(basename $BASH_SOURCE) : $LINENO\"; chown -R $USERNAME:$USERNAME /home/$USERNAME/.config" "CONFIG-AWESOME"   
    while [[ 1 ]];  do
        print_title "AWESOME - https://wiki.archlinux.org/index.php/Awesome"
        print_info "awesome is a highly configurable, next generation framework window manager for X. It is very fast, extensible and licensed under the GNU GPLv2 license."
        print_info "AWESOME CUSTOMIZATION"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xcompmgr" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "viewnior" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gmrun" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "PCManFM" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "rxvt-unicode" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "scrot" "" "" "scrot : [Print Screen]" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "thunar" "" "" "thunar: [File Browser]" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "tint2" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "volwheel" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xfburn" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_XCOMPMGR" #  
                    add_packagemanager "package_install \"$INSTALL_XCOMPMGR\" 'INSTALL-XCOMPMGR'" "INSTALL-XCOMPMGR"
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_VIEWNIOR" #  
                    add_packagemanager "package_install \"$INSTALL_VIEWNIOR\" 'INSTALL-VIEWNIOR'" "INSTALL-VIEWNIOR"
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GMRUN" #  
                    add_packagemanager "package_install \"$INSTALL_GMRUN\" 'INSTALL-GMRUN'" "INSTALL-GMRUN"
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_PCMANFM" #  
                    add_packagemanager "package_install \"$INSTALL_PCMANFM\" 'INSTALL-PCMANFM'" "INSTALL-PCMANFM"
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_RXVT_UNICODE" #  
                    add_packagemanager "package_install \"$INSTALL_RXVT_UNICODE\" 'INSTALL-RXVT-UNICODE'" "INSTALL-RXVT-UNICODE"
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_SCROT" #  
                    add_packagemanager "package_install \"$INSTALL_SCROT\" 'INSTALL-SCROT'" "INSTALL-SCROT"
                    ;;
                7)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_THUNAR" #  
                    add_packagemanager "package_install \"$INSTALL_THUNAR\" 'INSTALL-THUNAR'" "INSTALL-THUNAR"
                    ;;
                8)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_TINT2" #  
                    add_packagemanager "package_install \"$INSTALL_TINT2\" 'INSTALL-TINT2'" "INSTALL-TINT2"
                    ;;
                9)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_VOLWHEEL" #  
                    add_packagemanager "package_install \"$INSTALL_VOLWHEEL\" 'INSTALL-VOLWHEEL'" "INSTALL-VOLWHEEL"
                    ;;
               10)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_XFBURN" #  
                    add_packagemanager "package_install \"$INSTALL_XFBURN\" 'INSTALL-XFBURN'" "INSTALL-XFBURN"
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_cinnamon"
USAGE="install_cinnamon"
DESCRIPTION="Install Cinnamon"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_cinnamon()
{
    # 5
    local -i total_menu_items=5    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-CINNAMON"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    CINNAMON_INSTALLED=1
    add_package "$INSTALL_CINNAMON" #  
    add_packagemanager "package_install \"$INSTALL_CINNAMON\" 'INSTALL-CINNAMON'" "INSTALL-CINNAMON"
    add_aur_package "$AUR_INSTALL_CINNAMON" # 
    add_packagemanager "aur_package_install \"$AUR_INSTALL_CINNAMON\" 'AUR-INSTALL-CINNAMON'" "AUR-INSTALL-CINNAMON"
    # @FIX gnome-extra gnome-extra-meta telepathy
    # 
    TEMP=$(config_xinitrc 'gnome-session-cinnamon')
    add_packagemanager "$TEMP" "CONFIG-XINITRC-CINNAMON"
    # not sure how to run these commands; seems like they need to run after GUI is up and running; so adding them as a start up script may be what is needed
    # add_packagemanager "cinnamon-settings; cinnamon-settings panel; cinnamon-settings calendar; cinnamon-settings themes; cinnamon-settings applets; cinnamon-settings windows; cinnamon-settings fonts; cinnamon-settings hotcorner" "AUR-INSTALL-CINNAMON-SETTINGS"
    while [[ 1 ]]; do
        print_title "CINNAMON - https://wiki.archlinux.org/index.php/Cinnamon"
        print_info "Cinnamon is a fork of GNOME Shell, initially developed by Linux Mint. It attempts to provide a more traditional user environment based on the desktop metaphor, like GNOME 2. Cinnamon uses Muffin, a fork of the GNOME 3 window manager Mutter, as its window manager."
        print_info "CINNAMON CUSTOMIZATION"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Applets" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Themes" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GNOME Packagekit" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GNOME Activity Journal" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gloobus-sushi-bzr" "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_CINNAMON_APPLETS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_CINNAMON_APPLETS\" 'AUR-INSTALL-CINNAMON-APPLETS'" "AUR-INSTALL-CINNAMON-APPLETS"
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_CINNAMON_THEMES" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_CINNAMON_THEMES\" 'AUR-INSTALL-CINNAMON-THEMES'" "AUR-INSTALL-CINNAMON-THEMES"
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GNOME_PACKAGEKIT" #  
                    add_packagemanager "package_install \"$INSTALL_GNOME_PACKAGEKIT\" 'INSTALL-GNOME-PACKAGEKIT'" "INSTALL-GNOME-PACKAGEKIT"
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_ZEITGEIST" #  
                    add_packagemanager "package_install \"$INSTALL_ZEITGEIST\" 'INSTALL-ZEITGEIST'" "INSTALL-ZEITGEIST"
                    add_aur_package "$AUR_INSTALL_GNOME_ACTIVITY_JOURNAL" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ACTIVITY_JOURNAL\" 'AUR-INSTALL-GNOME-ACTIVITY-JOURNAL'" "AUR-INSTALL-GNOME-ACTIVITY-JOURNAL"
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GLOOBUS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GLOOBUS\" 'AUR-INSTALL-GLOOBUS'" "AUR-INSTALL-GLOOBUS"
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_e17"
USAGE="install_e17"
DESCRIPTION="Install E17"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_e17()
{
    # 6
    local -i total_menu_items=9    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-E17"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    E17_INSTALLED=1
    add_package "$INSTALL_E17" #  
    add_packagemanager "package_install \"$INSTALL_E17\" 'INSTALL-E17'" "INSTALL-E17"
    add_aur_package "$AUR_INSTALL_E17" # 
    add_packagemanager "aur_package_install \"$AUR_INSTALL_E17\" 'AUR-INSTALL-E17'" "AUR-INSTALL-E17"
    TEMP=$(config_xinitrc 'enlightenment_start')
    add_packagemanager "$TEMP" "CONFIG-XINITRC-E17"
    add_packagemanager "chown -R $USERNAME:$USERNAME /home/$USERNAME/.config" "CONFIG-XFCE"
    while [[ 1 ]]; do
        print_title "E17 - https://wiki.archlinux.org/index.php/E17"
        print_info "Enlightenment, also known simply as E, is a stacking window manager for the X Window System which can be used alone or in conjunction with a desktop environment such as GNOME or KDE. Enlightenment is often used as a substitute for a full desktop environment."
        print_info "E17 CUSTOMIZATION"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "e17-icons" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "e17-themes" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "viewnior" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gmrun" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "PCManFM" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "rxvt-unicode" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "scrot" "" "" "scrot: Print Screen" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "thunar" "" "" "thunar: File Browser" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xfburn" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_E17_ICONS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_E17_ICONS\" 'AUR-INSTALL-E17-ICONS'" "AUR-INSTALL-E17-ICONS"
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_E17_THEMES" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_E17_THEMES\" 'AUR-INSTALL-E17-THEMES'" "AUR-INSTALL-E17-THEMES"
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_VIEWNIOR" #  
                    add_packagemanager "package_install \"$INSTALL_VIEWNIOR\" 'INSTALL-VIEWNIOR'" "INSTALL-VIEWNIOR"
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GMRUN" #  
                    add_packagemanager "package_install \"$INSTALL_GMRUN\" 'INSTALL-GMRUN'" "INSTALL-GMRUN"
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_PCMANFM" #  
                    add_packagemanager "package_install \"$INSTALL_PCMANFM\" 'INSTALL-PCMANFM'" "INSTALL-PCMANFM"
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_RXVT_UNICODE" #  
                    add_packagemanager "package_install \"$INSTALL_RXVT_UNICODE\" 'INSTALL-RXVT-UNICODE'" "INSTALL-RXVT-UNICODE"
                    ;;
                7)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_SCROT" #  
                    add_packagemanager "package_install \"$INSTALL_SCROT\" 'INSTALL-SCROT'" "INSTALL-SCROT"
                    ;;
                8)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_THUNAR" #  
                    add_packagemanager "package_install \"$INSTALL_THUNAR\" 'INSTALL-THUNAR'" "INSTALL-THUNAR"
                    ;;
                9)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_XFBURN" #  
                    add_packagemanager "package_install \"$INSTALL_XFBURN\" 'INSTALL-XFBURN'" "INSTALL-XFBURN"
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_lxde"
USAGE="install_lxde"
DESCRIPTION="Install LXDE"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_lxde()
{
    # 7
    local -i total_menu_items=2    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-LXDE"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    LXDE_INSTALLED=1
    add_package "$INSTALL_LXDE" #  
    add_packagemanager "package_install \"$INSTALL_LXDE\" 'INSTALL-LXDE'" "INSTALL-LXDE"
    add_aur_package "$AUR_INSTALL_LXDE" # 
    add_packagemanager "aur_package_install \"$AUR_INSTALL_LXDE\" 'AUR-INSTALL-LXDE'" "AUR-INSTALL-LXDE"
    while [[ 1 ]]; do
        print_title "LXDE - https://wiki.archlinux.org/index.php/lxde"
        print_info "LXDE is a free and open source desktop environment for Unix and other POSIX compliant platforms, such as Linux or BSD. The goal of the project is to provide a desktop environment that is fast and energy efficient."
        print_info "LXDE CUSTOMIZATION"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "viewnior" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xfburn" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_VIEWNIOR" #  
                    add_packagemanager "package_install \"$INSTALL_VIEWNIOR\" 'INSTALL-VIEWNIOR '" "INSTALL-VIEWNIOR"
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_XFBURN" #  
                    add_packagemanager "package_install \"$INSTALL_XFBURN\" 'INSTALL-XFBURN'" "INSTALL-XFBURN"
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_openbox"
USAGE="install_openbox"
DESCRIPTION="Install Openbox"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_openbox() 
{ 
    # 8
    local -i total_menu_items=10    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-OPENBOX"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    OPENBOX_INSTALLED=1
    add_package "$INSTALL_OPENBOX" #  
    add_packagemanager "package_install \"$INSTALL_OPENBOX\" 'INSTALL-OPENBOX'" "INSTALL-OPENBOX"
    add_aur_package "$AUR_INSTALL_OPENBOX" # 
    add_packagemanager "aur_package_install \"$AUR_INSTALL_OPENBOX\" 'AUR-INSTALL-OPENBOX'" "AUR-INSTALL-OPENBOX"
    TEMP=$(config_xinitrc 'openbox-session')
    add_packagemanager "$TEMP" "CONFIG-XINITRC-OPENBOX"
    add_packagemanager "make_dir \"/home/$USERNAME/.config/openbox/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/openbox/rc.xml' \"/home/$USERNAME/.config/openbox/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/openbox/menu.xml' \"/home/$USERNAME/.config/openbox/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/openbox/autostart' \"/home/$USERNAME/.config/openbox/\" \"$(basename $BASH_SOURCE) : $LINENO\"; chown -R $USERNAME:$USERNAME /home/$USERNAME/.config" "CONFIG-OPENBOX"  
    while [[ 1 ]]; do
        print_title "OPENBOX - https://wiki.archlinux.org/index.php/Openbox"
        print_info "Openbox is a lightweight and highly configurable window manager with extensive standards support."
        print_info "OPENBOX CUSTOMIZATION"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xcompmgr" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "viewnior" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gmrun" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "PCManFM" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "rxvt-unicode" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "scrot" "" "" "scrot: Print Screen" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "thunar" "" "" "thunar: File Browser" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "tint2" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "volwheel" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xfburn" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_XCOMPMGR" #  
                    add_packagemanager "package_install \"$INSTALL_XCOMPMGR\" 'INSTALL-XCOMPMGR'" "INSTALL-XCOMPMGR"
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_VIEWNIOR" #  
                    add_packagemanager "package_install \"$INSTALL_VIEWNIOR\" 'INSTALL-VIEWNIOR'" "INSTALL-VIEWNIOR"
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GMRUN" #  
                    add_packagemanager "package_install \"$INSTALL_GMRUN\" 'INSTALL-GMRUN'" "INSTALL-GMRUN"
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_PCMANFM" #  
                    add_packagemanager "package_install \"$INSTALL_PCMANFM\" 'INSTALL-PCMANFM'" "INSTALL-PCMANFM"
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_RXVT_UNICODE" #  
                    add_packagemanager "package_install \"$INSTALL_RXVT_UNICODE\" 'INSTALL-RXVT-UNICODE'" "INSTALL-RXVT-UNICODE"
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_SCROT" #  
                    add_packagemanager "package_install \"$INSTALL_SCROT\" 'INSTALL-SCROT'" "INSTALL-SCROT"
                    ;;
                7)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_THUNAR" #  
                    add_packagemanager "package_install \"$INSTALL_THUNAR\" 'INSTALL-THUNAR'" "INSTALL-THUNAR"
                    ;;
                8)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_TINT2" #  
                    add_packagemanager "package_install \"$INSTALL_TINT2\" 'INSTALL-TINT2'" "INSTALL-TINT2"
                    ;;
                9)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_VOLWHEEL" #  
                    add_packagemanager "package_install \"$INSTALL_VOLWHEEL\" 'INSTALL-VOLWHEEL'" "INSTALL-VOLWHEEL"
                    ;;
               10)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_XFBURN" #  
                    add_packagemanager "package_install \"$INSTALL_XFBURN\" 'INSTALL-XFBURN'" "INSTALL-XFBURN"
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_xfce"
USAGE="install_xfce"
DESCRIPTION="Install XFCE"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_xfce() 
{ 
    # 3
    local -i total_menu_items=1    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-XFCE"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    XFCE_INSTALLED=1
    TEMP=$(config_xinitrc 'startxfce4')
    add_packagemanager "$TEMP" "CONFIG-XINITRC-XFCE"
    print_title "XFCE - https://wiki.archlinux.org/index.php/Xfce"
    print_info "Xfce is a free software desktop environment for Unix and Unix-like platforms, such as Linux, Solaris, and BSD. It aims to be fast and lightweight, while still being visually appealing and easy to use."
    add_package "$INSTALL_XFCE" #  
    add_packagemanager "package_install \"$INSTALL_XFCE\" 'INSTALL-XFCE'" "INSTALL-XFCE"
    add_aur_package "$AUR_INSTALL_XFCE" # \"$AUR_INSTALL_XFCE\"
    add_packagemanager "aur_package_install '' 'AUR-INSTALL-XFCE'" "AUR-INSTALL-XFCE"
    while [[ 1 ]]; do
        print_title "XFCE CUSTOMIZATION"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xfce4-volumed" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_XFCE_CUSTOM" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_XFCE_CUSTOM\" 'AUR-INSTALL-XFCE-CUSTOM'" "AUR-INSTALL-XFCE-CUSTOM"
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_unity"
USAGE="install_unity"
DESCRIPTION="Install Unity"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
localize_info "Are you sure you wish to continue" "Are you sure you wish to continue" 
install_unity() 
{ 
    # 10
    UNITY_INSTALLED=1
    print_warning "\nWARNING: EXPERIMENTAL OPTION, USE AT YOUR OWN RISK\nDo not install this if already have a DE or WM installed."
    read_input_yn "Are you sure you wish to continue" " " 1
    [[ $YN_OPTION -eq 1 ]] && continue
    print_title "UNITY - https://wiki.archlinux.org/index.php/Unity"
    print_info "Unity is an alternative shell for the GNOME desktop environment, developed by Canonical in its Ayatana project. It consists of several components including the Launcher, Dash, lenses, Panel, indicators, Notify OSD and Overlay Scrollbar."
    echo -e '\n[unity]\nServer = http://unity.xe-xe.org/$arch' >> $MOUNTPOINT/etc/pacman.conf
    echo -e '\n[unity-extra]\nServer = http://unity.xe-xe.org/extra/$arch' >> $MOUNTPOINT/etc/pacman.conf
    add_package "$INSTALL_UNITY" #  
    add_packagemanager "package_install \"$INSTALL_UNITY\" 'INSTALL-UNITY'" "INSTALL-UNITY"
    # telepathy
    # Gnome Display Manager (a reimplementation of xdm)
    # D-Bus interface for user account query and manipulation
    # Application development toolkit for controlling system-wide privileges
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    # Network Management daemon
    add_packagemanager "systemctl enable lightdm.service accounts-daemon.service polkitd.service upower.service console-kit-daemon.service NetworkManager.service" "SYSTEMD-ENABLE-UNITY"
    # pacstrap will overwrite pacman.conf so copy it to temp 
    copy_file $MOUNTPOINT"/etc/pacman.conf" "$SCRIPT_DIR/etc/pacman.conf" "$(basename $BASH_SOURCE) : $LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL DISPLAY MANAGER {{{
NAME="install_display_manager"
USAGE="install_display_manager"
DESCRIPTION="Install Display Manager"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_display_manager() 
{
    # 3
    local -i total_menu_items=8    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="DISPLAY_MANAGER"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    while [[ 1 ]];  do
        print_title "DISPLAY MANAGER - https://wiki.archlinux.org/index.php/Display_Manager"
        print_info "A display manager, or login manager, is a graphical interface screen that is displayed at the end of the boot process in place of the default shell."
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GDM"     "gdm"  ""     "Works with Mate" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "KDM"     "kdm"  "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Elsa"    ""     ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "LightDM" ""     "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "LXDM"    ""     ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Slim"    ""     ""     "Slim: Simple Login Manager" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Qingy"   ""     ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "XDM"     ""     ""     "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # GDM
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GDM" #  
                    add_packagemanager "package_install \"$INSTALL_GDM\" 'INSTALL-GDM'" "INSTALL-GDM"
                    # dbus-launch
                    add_package "$INSTALL_GDM_CONTROL" #  
                    #add_packagemanager "package_install \"$INSTALL_GDM_CONTROL\" 'INSTALL-GDM-CONTROL'" "INSTALL-GDM-CONTROL" # One only
                    #add_aur_package "$AUR_INSTALL_GDM" # \"$AUR_INSTALL_GDM\"
                    #add_packagemanager "aur_package_install '' 'AUR-INSTALL-GDM'" "AUR-INSTALL-GDM"
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
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_KDM" #  
                    add_packagemanager "package_install \"$INSTALL_KDM\" 'INSTALL-KDM'" "INSTALL-KDM"
                    add_packagemanager "systemctl enable kdm.service" "SYSTEMD-ENABLE-KDM"
                    TEMP=$(config_xinitrc 'startkde')
                    add_packagemanager "$TEMP" "CONFIG-XINITRC-KDE"
                    break
                    ;;
                3)  # Elsa 
                    add_aur_package "$AUR_INSTALL_ELSA" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ELSA\" 'AUR-INSTALL-ELSA'" "AUR-INSTALL-ELSA"
                    add_packagemanager "systemctl enable elsa.service" "SYSTEMD-ENABLE-ELSA"
                    break
                    ;;
                4)  # LightDM
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_LIGHTDM" #  
                    add_packagemanager "package_install \"$INSTALL_LIGHTDM\" 'INSTALL-LIGHTDM'" "INSTALL-LIGHTDM"
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        add_aur_package "$AUR_INSTALL_LIGHTDM_KDE" # 
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_LIGHTDM_KDE\" 'AUR-INSTALL-LIGHTDM-KDE'" "AUR-INSTALL-LIGHTDM-KDE"
                    fi
                    add_aur_package "$AUR_INSTALL_LIGHTDM" # \"$AUR_INSTALL_LIGHTDM\"
                    add_packagemanager "aur_package_install '' 'AUR-INSTALL-LIGHTDM'" "AUR-INSTALL-LIGHTDM"
                    add_packagemanager "sed -i 's/#greeter-session=.*\$/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf" "RUN-LIGHTDM"
                    add_packagemanager "systemctl enable lightdm.service" "SYSTEMD-ENABLE-LIGHTDM"
                    break
                    ;;
                5)  # LXDM
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_LXDM" #  
                    add_packagemanager "package_install \"$INSTALL_LXDM\" 'INSTALL-LXDM'" "INSTALL-LXDM"
                    add_packagemanager "systemctl enable lxdm.service" "SYSTEMD-ENABLE-LXDM"
                    TEMP=$(config_xinitrc 'startlxde')
                    add_packagemanager "$TEMP" "CONFIG-XINITRC-GNOME"
                    break
                    ;;
                6)  # Slim
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_SLIM" #  
                    add_packagemanager "package_install \"$INSTALL_SLIM\" 'INSTALL-SLIM'" "INSTALL-SLIM"
                    add_packagemanager "systemctl enable slim.service" "SYSTEMD-ENABLE-SLIM"
                    break
                    ;;
                7)  # Qingy
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_QINGY" #  
                    add_packagemanager "package_install \"$INSTALL_QINGY\" 'INSTALL-QINGY'" "INSTALL-QINGY"
                    add_packagemanager "systemctl enable qingy@ttyX" "SYSTEMD-ENABLE-QINGY"
                    break
                    ;;
                8)  # XDM
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_XDM" #  
                    add_packagemanager "package_install \"$INSTALL_XDM\" 'INSTALL-XDM'" "INSTALL-XDM"
                    add_packagemanager "systemctl enable qingy@ttyX" "SYSTEMD-ENABLE-XDM"
                    break
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_extra"
USAGE="install_extra"
DESCRIPTION="Install Extra"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_extra()
{
    # 13
    local -i total_menu_items=2    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-EXTRA"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "EXTRAs"
        print_info "ELEMENTARY PROJECT: Media Player, Sharing service, Screencasting, Contacts manager, RSS feeds Reader, File Manager, Note Taking, Compositing Manager, Email client, Dictionary, Maya Calendar, Web Browser, Audio Player, Text Editor, Dock, App Launcher, Desktop Settings Hub, Indicators Topbar, Elementary Icons, and Elementary Theme"
        print_info "https://aur.archlinux.org/packages/yapan/ and https://bbs.archlinux.org/viewtopic.php?id=113078"
        print_info "Yapan (Yet Another Package mAnager Notifier) — written in C++ and Qt. It shows an icon in the system tray and popup notifications for new packages and supports AUR helpers."
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Elementary Project" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Yapan" "" "$AUR" "Yapan: pacman Update Monitor" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_extras
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_YAPAN" #  
                    add_packagemanager "package_install \"$INSTALL_YAPAN\" 'INSTALL-YAPAN'" "INSTALL-YAPAN"
                    add_aur_package "$AUR_INSTALL_YAPAN" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_YAPAN\" 'AUR-INSTALL-YAPAN'" "AUR-INSTALL-YAPAN"
                    break; 
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# ELEMENTARY PROJECT {{{
NAME="install_extras"
USAGE="install_extras"
DESCRIPTION="Install Extras"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_extras()
{
    local -i total_menu_items=21    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="ELEMENTARY-PROJECT"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "ELEMENTARY PROJECT"
        print_warning "\tsome of these programs still in alpha stage and may not work"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Media Player" "audience-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Sharing service" "contractor-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Screencasting" "eidete-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Contacts manager" "dexter-contacts-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "RSS feeds Reader" "feedler-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "File Manager" "files-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Note Taking" "footnote-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Compositing Manager" "gala-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Email client" "geary-git" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dictionary" "lingo-dictionary-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Calendar" "maya-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Web Browser" "midori" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Audio Player" "noise-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Text Editor" "scratch-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dock" "plank-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Terminal" "pantheon-terminal-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "App Launcher" "slingshot-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Desktop Settings Hub" "switchboard-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Indicators Topbar" "wingpanel-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Elementary Icons" "elementary-icons-bzr" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Elementary Theme" "egtk-bzr" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_AUDIENCE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_AUDIENCE\" 'AUR-INSTALL-EP-AUDIENCE'" "AUR-INSTALL-EP-AUDIENCE"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_CONTRACTOR" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_CONTRACTOR\" 'AUR-INSTALL-EP-CONTRACTOR'" "AUR-INSTALL-EP-CONTRACTOR"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_EIDETE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_EIDETE\" 'AUR-INSTALL-EP-EIDETE'" "AUR-INSTALL-EP-EIDETE"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_DEXTER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_DEXTER\" 'AUR-INSTALL-EP-DEXTER'" "AUR-INSTALL-EP-DEXTER"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_FEEDLER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_FEEDLER\" 'AUR-INSTALL-EP-FEEDLER'" "AUR-INSTALL-EP-FEEDLER"
                    ;;
                6)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_FILES" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_FILES\" 'AUR-INSTALL-EP-FILES'" "AUR-INSTALL-EP-FILES"
                    ;;
                7)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_FOOTNOTE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_FOOTNOTE\" 'AUR-INSTALL-EP-FOOTNOTE'" "AUR-INSTALL-EP-FOOTNOTE"
                    ;;
                8)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_GALA" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_GALA\" 'AUR-INSTALL-EP-GALA'" "AUR-INSTALL-EP-GALA"
                    ;;
                9)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_GEARY" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_GEARY\" 'AUR-INSTALL-EP-GEARY'" "AUR-INSTALL-EP-GEARY"
                    ;;
               10)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_LINGO" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_LINGO\" 'AUR-INSTALL-EP-LINGO'" "AUR-INSTALL-EP-LINGO"
                    ;;
               11)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_MAYA" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_MAYA\" 'AUR-INSTALL-EP-MAYA'" "AUR-INSTALL-EP-MAYA"
                    ;;
               12)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_MIDORI" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_MIDORI\" 'AUR-INSTALL-EP-MIDORI'" "AUR-INSTALL-EP-MIDORI"
                    ;;
               13)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_NOISE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_NOISE\" 'AUR-INSTALL-EP-NOISE'" "AUR-INSTALL-EP-NOISE"
                    ;;
               14)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_SCRATCH" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_SCRATCH\" 'AUR-INSTALL-EP-SCRATCH'" "AUR-INSTALL-EP-SCRATCH"
                    ;;
               15)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_PLANK" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_PLANK\" 'AUR-INSTALL-EP-PLANK'" "AUR-INSTALL-EP-PLANK"
                    ;;
               16)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_PANTHEON" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_PANTHEON\" 'AUR-INSTALL-EP-PANTHEON'" "AUR-INSTALL-EP-PANTHEON"
                    ;;
               17)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_SLINGSHOT" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_SLINGSHOT\" 'AUR-INSTALL-EP-SLINGSHOT'" "AUR-INSTALL-EP-SLINGSHOT"
                    ;;
               18)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_SWITCHBOARD" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_SWITCHBOARD\" 'AUR-INSTALL-EP-SWITCHBOARD" "AUR-INSTALL-EP-SWITCHBOARD"
                    ;;
               19)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_WINGPANEL" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_WINGPANEL\" 'AUR-INSTALL-EP-WINGPANEL'" "AUR-INSTALL-EP-WINGPANEL"
                    ;;
               20)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_ICONS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_ICONS\" 'AUR-INSTALL-EP-ICONS'" "AUR-INSTALL-EP-ICONS"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary" "RUN-GTK_UPDATE"
                    ;;
               21)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_EGTK" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_EGTK\" 'AUR-INSTALL-EP-EGTK'" "AUR-INSTALL-EP-EGTK"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
                *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL AUDIO APPS {{{
NAME="install_audio_apps"
USAGE="install_audio_apps"
DESCRIPTION="Install Audio Apps"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_audio_apps()
{
    # 8
    local -i total_menu_items=3    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="AUDIO-APPS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "AUDIO APPS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Players" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Editors|Tools" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Codecs" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_players
                    #}}}
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_audio_editors
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_AUDIO_CODECS" #  
                    add_packagemanager "package_install \"$INSTALL_AUDIO_CODECS\" 'INSTALL-AUDIO-CODECS'" "INSTALL-AUDIO-CODECS"
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# INSTALL AUDIO EDITORS {{{
NAME="install_audio_editors"
USAGE="install_audio_editors"
DESCRIPTION="Install Audio Editors"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_audio_editors()
{
    local -i total_menu_items=4    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-AUDIO-EDITORS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "soundconverter" "" "" "soundconverter: or soundkonverter Depending on DE" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "puddletag" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Audacity" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Ocenaudio" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                           add_package "$INSTALL_SOUNDCONVERTER" #  
                           add_packagemanager "package_install \"$INSTALL_SOUNDCONVERTER\" 'INSTALL-SOUNDCONVERTER'" "INSTALL-SOUNDCONVERTER"
                        fi
                        add_package "$INSTALL_SOUNDKONVERTER" #  
                        add_packagemanager "package_install \"$INSTALL_SOUNDKONVERTER\" 'INSTALL-SOUNDKONVERTER'" "INSTALL-SOUNDKONVERTER"
                    else
                        add_package "$INSTALL_SOUNDCONVERTER" #  
                        add_packagemanager "package_install \"$INSTALL_SOUNDCONVERTER\" 'INSTALL-SOUNDCONVERTER'" "INSTALL-SOUNDCONVERTER"
                     fi
                     ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_PUDDLETAG" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_PUDDLETAG\" 'AUR-INSTALL-PUDDLETAG'" "AUR-INSTALL-PUDDLETAG"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_AUDACITY" #  
                    add_packagemanager "package_install \"$INSTALL_AUDACITY\" 'INSTALL-AUDACITY'" "INSTALL-AUDACITY"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_OCENAUDIO" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_OCENAUDIO\" 'AUR-INSTALL-OCENAUDIO'" "AUR-INSTALL-OCENAUDIO"
                    ;;
                "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
                *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL PLAYERS {{{
NAME="install_players"
USAGE="install_players"
DESCRIPTION="Install Players"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_players()
{
    local -i total_menu_items=13    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-PLAYERS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        #
        print_title "AUDIO PLAYERS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Amarok"        "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Audacious"     "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Banshee"       "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Clementine"    "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dead beef"     "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Exaile"        "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Musique"       "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Nuvola Player" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Rhythmbox"     "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Radio tray"    "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Spotify"       "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Tomahawk"      "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Timidity++"    "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_AMAROK" #  
                    add_packagemanager "package_install \"$INSTALL_AMAROK\" 'INSTALL-AMAROK'" "INSTALL-AMAROK"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_AUDACIOUS" #  
                    add_packagemanager "package_install \"$INSTALL_AUDACIOUS\" 'INSTALL-AUDACIOUS'" "INSTALL-AUDACIOUS"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_BANSHEE" #  
                    add_packagemanager "package_install \"$INSTALL_BANSHEE\" 'INSTALL-BANSHEE'" "INSTALL-BANSHEE"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_CLEMENTINE" #  
                    add_packagemanager "package_install \"$INSTALL_CLEMENTINE\" 'INSTALL-CLEMENTINE'" "INSTALL-CLEMENTINE"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_DEADBEEF" #  
                    add_packagemanager "package_install \"$INSTALL_DEADBEEF\" 'INSTALL-DEADBEEF'" "INSTALL-DEADBEEF"
                    ;;
                6)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EXAILE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EXAILE\" 'AUR-INSTALL-EXAILE'" "AUR-INSTALL-EXAILE"
                    ;;
                7)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MUSIQUE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MUSIQUE\" 'AUR-INSTALL-MUSIQUE'" "AUR-INSTALL-MUSIQUE"
                    ;;
                8)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_NUVOLAPLAYER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_NUVOLAPLAYER\" 'AUR-INSTALL-NUVOLAPLAYER" "AUR-INSTALL-NUVOLAPLAYER"
                    ;;
                9)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_RHYTHMBOX" #  
                    add_packagemanager "package_install \"$INSTALL_RHYTHMBOX\" 'INSTALL-RHYTHMBOX'" "INSTALL-RHYTHMBOX"
                   ;;
               10)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_RADIOTRAY" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_RADIOTRAY\" 'AUR-INSTALL-RADIOTRAY'" "AUR-INSTALL-RADIOTRAY"
                    ;;
               11)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SPOTIFY" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SPOTIFY\" 'AUR-INSTALL-SPOTIFY'" "AUR-INSTALL-SPOTIFY"
                    ;;
               12)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_TOMAHAWK" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_TOMAHAWK\" 'AUR-INSTALL-TOMAHAWK'" "AUR-INSTALL-TOMAHAWK"
                    ;;
               13)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_TIMIDITY" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_TIMIDITY\" 'AUR-INSTALL-TIMIDITY'" "AUR-INSTALL-TIMIDITY"
                    add_packagemanager"echo -e 'soundfont /usr/share/soundfonts/fluidr3/FluidR3GM.SF2' >> /etc/timidity++/timidity.cfg" "RUN-TIMIDITY"
                    ;;
             "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
               *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL OFFICE APPS {{{
NAME="install_office_apps"
USAGE="install_office_apps"
DESCRIPTION="Install Office Apps"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_office_apps()
{
    # 4
    local -r menu_name="OFFICE-APPS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "OFFICE APPS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "LibreOffice"                   "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Caligra or Abiword + Gnumeric" "Depending on DE" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "latex"                         "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "calibre"                       "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gcstar"                        "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "homebank"                      "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "impressive"                    "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "nitrotasks"                    "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ocrfeeder"                     "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xmind"                         "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "zathura"                       "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    print_title "LIBREOFFICE - https://wiki.archlinux.org/index.php/LibreOffice"
                    print_title "Libre Office - https://wiki.archlinux.org/index.php/LibreOffice"
                    add_package "$INSTALL_LIBRE_OFFICE" # 
                    add_packagemanager "package_install \"$INSTALL_LIBRE_OFFICE\" 'INSTALL-LIBRE_OFFICE'" "INSTALL-LIBRE_OFFICE"
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1   ]]; then
                            add_package "$INSTALL_LIBRE_OFFICE_GNOME" #  
                            add_packagemanager "package_install \"$INSTALL_LIBRE_OFFICE_GNOME\" 'INSTALL-LIBRE-OFFICE-GNOME'" "INSTALL-LIBRE-OFFICE-GNOME"
                        fi
                        add_package "$INSTALL_LIBRE_OFFICE_KDE" # 
                        add_packagemanager "package_install \"$INSTALL_LIBRE_OFFICE_KDE\" 'INSTALL-LIBRE-OFFICE-KDE'" "INSTALL-LIBRE-OFFICE-KDE"
                    else
                        add_package "$INSTALL_LIBRE_OFFICE_GNOME" #  
                        add_packagemanager "package_install \"$INSTALL_LIBRE_OFFICE_GNOME\" 'INSTALL-LIBRE-OFFICE-GNOME'" "INSTALL-LIBRE-OFFICE-GNOME"
                    fi
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                            add_package "$INSTALL_GNUMERIC" #  
                            add_packagemanager "package_install \"$INSTALL_GNUMERIC\" 'INSTALL-GNUMERIC'" "INSTALL-GNUMERIC"
                        fi
                        add_package "$INSTALL_CALLIGRA" #  
                        add_packagemanager "package_install \"$INSTALL_CALLIGRA\" 'INSTALL-CALLIGRA'" "INSTALL-CALLIGRA"
                    else
                        add_package "$INSTALL_GNUMERIC" #  
                        add_packagemanager "package_install \"$INSTALL_GNUMERIC\" 'INSTALL-GNUMERIC'" "INSTALL-GNUMERIC"
                    fi
                    add_aur_package "$AUR_INSTALL_HUNSPELL" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_HUNSPELL\" 'AUR-INSTALL-HUNSPELL'" "AUR-INSTALL-HUNSPELL"
                    add_aur_package "$AUR_INSTALL_ASPELL_LANGUAGE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ASPELL_LANGUAGE\" \"AUR-INSTALL-ASPELL-LANGUAGE\"" "AUR-INSTALL-ASPELL-LANGUAGE"
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    print_title "LATEX - https://wiki.archlinux.org/index.php/LaTeX"
                    add_package "$INSTALL_LATEX" #  
                    add_packagemanager "package_install \"$INSTALL_LATEX\" 'INSTALL-LATEX'" "INSTALL-LATEX"
                    add_aur_package "$AUR_INSTALL_" # \"$AUR_INSTALL_\"
                    add_packagemanager "aur_package_install '' 'AUR-INSTALL-TEXMAKER'" "AUR-INSTALL-TEXMAKER"
                    if [[ "$LANGUAGE" == "pt_BR" ]]; then
                        add_aur_package "$AUR_INSTALL_ABNTEX" # 
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_ABNTEX\" 'AUR-INSTALL-ABNTEX'" "AUR-INSTALL-ABNTEX"
                    fi
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_CALIBRE" #  
                    add_packagemanager "package_install \"$INSTALL_CALIBRE\" 'INSTALL-CALIBRE'" "INSTALL-CALIBRE"
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GCSTAR" #  
                    add_packagemanager "package_install \"$INSTALL_GCSTAR\" 'INSTALL-GCSTAR'" "INSTALL-GCSTAR"
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_HOMEBANK" #  
                    add_packagemanager "package_install \"$INSTALL_HOMEBANK\" 'INSTALL-HOMEBANK'" "INSTALL-HOMEBANK"
                    ;;
                7)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_IMPRESSIVE" #  
                    add_packagemanager "package_install \"$INSTALL_IMPRESSIVE\" 'INSTALL-IMPRESSIVE'" "INSTALL-IMPRESSIVE"
                    ;;
                8)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_NITROTASKS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_NITROTASKS\" 'AUR-INSTALL-NITROTASKS'" "AUR-INSTALL-NITROTASKS"
                    ;;
                9)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_OCRFEEDER" #  
                    add_packagemanager "package_install \"$INSTALL_OCRFEEDER\" 'INSTALL-OCRFEEDER'" "INSTALL-OCRFEEDER"
                    add_aur_package "$AUR_INSTALL_ASPELL_$LANGUAGE_AS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ASPELL_$LANGUAGE_AS\" \"AUR-INSTALL-ASPELL-$LANGUAGE_AS\"" "AUR-INSTALL-ASPELL-$LANGUAGE_AS"
                    ;;
                10)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_XMIND" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_XMIND\" 'AUR-INSTALL-XMIND'" "AUR-INSTALL-XMIND"
                    ;;
                11)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_ZATHURA" #  
                    add_packagemanager "package_install \"$INSTALL_ZATHURA\" 'INSTALL-ZATHURA'" "INSTALL-ZATHURA"
                    ;;
                "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# SYSTEM TOOLS APPS {{{
NAME="install_system_apps"
USAGE="install_system_apps"
DESCRIPTION="Install System Apps"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_system_apps()
{
    # 5
    local -i total_menu_items=6    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="SYSTEM-TOOLS-APPS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "SYSTEM TOOLS APPS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Gparted"    "" "" "Gparted: https://wiki.archlinux.org/index.php/GParted" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Grsync"     "" "" "Grsync: GTK GUI for rsync" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Htop"       "" "" "Htop: Interactive process viewer" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Virtualbox" "" "" "VirtualBox is a virtual PC emulator like VMware - https://wiki.archlinux.org/index.php/VirtualBox" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Webmin"     "" "" "Webmin runs as a service. Using webmin, you can administer other services and server configuration using a web browser, either from the server or remotely. https://wiki.archlinux.org/index.php/Webmin" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "WINE"       "" "" "Wine (originally an acronym for 'Wine Is Not an Emulator') is a compatibility layer capable of running Windows applications on several POSIX-compliant operating systems, such as Linux, Mac OSX, & BSD. https://wiki.archlinux.org/index.php/Wine" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GPARTED" #  
                    add_packagemanager "package_install \"$INSTALL_GPARTED\" 'INSTALL-GPARTED'" "INSTALL-GPARTED"
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GRSYNC" #  
                    add_packagemanager "package_install \"$INSTALL_GRSYNC\" 'INSTALL-GRSYNC'" "INSTALL-GRSYNC"
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_HTOP" #  
                    add_packagemanager "package_install \"$INSTALL_HTOP\" 'INSTALL-HTOP'" "INSTALL-HTOP"
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_VIRTUALBOX" #  
                    add_packagemanager "package_install \"$INSTALL_VIRTUALBOX\" 'INSTALL-VIRTUALBOX'" "INSTALL-VIRTUALBOX"
                    add_aur_package "$AUR_INSTALL_VIRTUALBOX_EXT_ORACLE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_VIRTUALBOX_EXT_ORACLE\" 'AUR-INSTALL-VIRTUALBOX-EXT-ORACLE'" "AUR-INSTALL-VIRTUALBOX-EXT-ORACLE"
                    add_module "vboxdrv" "MODULE-VIRTUALBOX"
                    add_packagemanager "systemctl enable vboxservice.service" "SYSTEMD-ENABLE-VIRTUALBOX"
                    add_packagemanager "add_user_2_group 'vboxusers'" "GROUPADD-VBOXUSERS"
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_WEBMIN" #  
                    add_packagemanager "package_install \"$INSTALL_WEBMIN\" 'INSTALL-WEBMIN'" "INSTALL-WEBMIN"
                    add_packagemanager "systemctl enable webmin.service" "SYSTEMD-ENABLE-WEBMIN"
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_WINE" #  
                    add_packagemanager "package_install \"$INSTALL_WINE\" 'INSTALL-WINE'" "INSTALL-WINE"
                    if [[ "$ARCHI" == "x86_64" ]]; then
                        if [[ "$VIDEO_CARD" -eq 1 ]]; then    # nVidia for WINE
                            add_package "$INSTALL_WINE_NVIDIA" #  
                            add_packagemanager "package_install \"$INSTALL_WINE_NVIDIA\" 'INSTALL-WINE-NVIDIA'" "INSTALL-WINE-NVIDIA"
                        elif [[ "$VIDEO_CARD" -eq 2 ]]; then  # Nouveau
                            add_package "$INSTALL_WINE_NOUVEAU" # 
                            add_packagemanager "package_install  \"$INSTALL_WINE_NOUVEAU\" 'INSTALL-WINE-NOUVEAU'" "INSTALL-WINE-NOUVEAU"
                        elif [[ "$VIDEO_CARD" -eq 3 ]]; then  # Intel
                            add_package "$INSTALL_WINE_INTEL" #  
                            add_packagemanager "package_install \"$INSTALL_WINE_INTEL\" 'INSTALL-WINE-INTEL'" "INSTALL-WINE-INTEL"
                        elif [[ "$VIDEO_CARD" -eq 4 ]]; then  # ATI
                            add_package "$INSTALL_WINE_ATI" #  
                            add_packagemanager "package_install \"$INSTALL_WINE_ATI\" 'INSTALL-WINE-ATI'" "INSTALL-WINE-ATI"
                        fi
                        add_package "$INSTALL_WINE_ALSA" #  
                        add_packagemanager "package_install \"$INSTALL_WINE_ALSA\" 'INSTALL-WINE-ALSA'" "INSTALL-WINE-ALSA"
                    fi
                    ;;
                "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_de_extras"
USAGE="install_system_apps"
DESCRIPTION="Install DE Extras"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_de_extras()
{
    # 11
    local -i total_menu_items=2    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-DE-EXTRAS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "Desktop Environments Extras"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GNOME Icons" "" "$AUR" "GNOME Icons: awoken-icons faenza-icon-theme faenza-cupertino-icon-theme faience-icon-theme elementary-icons-bzr" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GTK Themes"  "" "$AUR" "GTK Themes: gtk-theme-adwaita-cupertino gtk-theme-boomerang xfce-theme-blackbird xfce-theme-bluebird egtk-bzr xfce-theme-greybird light-themes orion-gtk-theme zukini-theme zukitwo-themes" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_icons
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_gtk_themes
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_gtk_themes"
USAGE="install_gtk_themes"
DESCRIPTION="Install GTK Themes"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_gtk_themes() 
{ 
    # 11 sub 2
    local -i total_menu_items=10   # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-GTK-THEMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "GTK2/GTK3 THEMES"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Adwaita Cupertino" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Boomerang"         "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Blackbird"         "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Bluebird"          "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "eGTK"              "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Greybird"          "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Light"             "" "" "Light: aka Ambiance/Radiance" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Orion"             "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Zukini"            "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Zukitwo"           "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_ADWAITA" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_ADWAITA\" 'AUR-INSTALL-GTK-THEMES-ADWAITA'" "AUR-INSTALL-GTK-THEMES-ADWAITA"
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_BOOMERANG" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_BOOMERANG\" 'AUR-INSTALL-GTK-THEMES-BOOMERANG'" "AUR-INSTALL-GTK-THEMES-BOOMERANG"
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_BLACKBIRD" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_BLACKBIRD\" 'AUR-INSTALL-GTK-THEMES-BLACKBIRD'" "AUR-INSTALL-GTK-THEMES-BLACKBIRD"
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_BLUEBIRD" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_BLUEBIRD\" 'AUR-INSTALL-GTK-THEMES-BLUEBIRD'" "AUR-INSTALL-GTK-THEMES-BLUEBIRD"
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_EGTK" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_EGTK\" 'AUR-INSTALL-GTK-THEMES-EGTK'" "AUR-INSTALL-GTK-THEMES-EGTK"
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_XFCE_GREYBIRD" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_XFCE_GREYBIRD\" 'AUR-INSTALL-GTK-THEMES-XFCE-GREYBIRD'" "AUR-INSTALL-GTK-THEMES-XFCE-GREYBIRD"
                    ;;
                7)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_LIGHT_THEMES" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_LIGHT_THEMES\" 'AUR-INSTALL-GTK-THEMES-LIGHT-THEMES'" "AUR-INSTALL-GTK-THEMES-LIGHT-THEMES"
                    ;;
                8)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_ORION" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_ORION\" 'AUR-INSTALL-GTK-THEMES-ORION'" "AUR-INSTALL-GTK-THEMES-ORION"
                    ;;
                9)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_ZUKINI" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_ZUKINI\" 'AUR-INSTALL-GTK-THEMES-ZUKINI'" "AUR-INSTALL-GTK-THEMES-ZUKINI"
                    ;;
               10)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_ZUKITWO" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_ZUKITWO\" 'AUR-INSTALL-GTK-THEMES-ZUKITWO'" "AUR-INSTALL-GTK-THEMES-ZUKITWO"
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_icons"
USAGE="install_icons"
DESCRIPTION="Install ICONS"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
localize_info "Install also the elementary XFCE icons" "Install also the elementary XFCE icons" 
install_icons() 
{ 
    # 11 sub 1
    local -i total_menu_items=6    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-ICONS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    add_package "$INSTALL_GTK_ICONS" #  
    add_packagemanager "package_install \"$INSTALL_GTK_ICONS\" 'INSTALL-GTK-ICONS'" "INSTALL-GTK-ICONS"
    while [[ 1 ]]; do
        print_title "GNOME ICONS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Awoken"           "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Faenza"           "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Faenza-Cupertino" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Faience"          "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Elementary"       "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Nitrux"           "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_ICONS_AWOKEN" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_AWOKEN\" 'AUR-INSTALL-GNOME-ICONS-AWOKEN'" "AUR-INSTALL-GNOME-ICONS-AWOKEN"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/AwOken" "RUN-GTK-ICONS-1"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/AwOken-Dark" "RUN-GTK-ICONS-2"
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_ICONS_FAENZA" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_FAENZA\" 'AUR-INSTALL-GNOME-ICONS-FAENZA'" "AUR-INSTALL-GNOME-ICONS-FAENZA"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza" "RUN-GTK-ICONS-3"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Dark" "RUN-GTK-ICONS-4"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Darker" "RUN-GTK-ICONS-5"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Darkest" "RUN-GTK-ICONS-6"
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_ICONS_FEANZA_CUPERTINO" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_FEANZA_CUPERTINO\" 'AUR-INSTALL-GNOME-ICONS-FEANZA-CUPERTINO'" "AUR-INSTALL-GNOME-ICONS-FEANZA-CUPERTINO"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino" "RUN-GTK-ICONS-7"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino-Dark" "RUN-GTK-ICONS-8"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino-Darker" "RUN-GTK-ICONS-9"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino-Darkest" "RUN-GTK-ICONS-10"
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_ICONS_FAIENCE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_FAIENCE\" 'AUR-INSTALL-GNOME-ICONS-FAIENCE'" "AUR-INSTALL-GNOME-ICONS-FAIENCE"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience" "RUN-GTK-ICONS-11"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience-Azur" "RUN-GTK-ICONS-12"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience-Claire" "RUN-GTK-ICONS-13"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience-Ocre" "RUN-GTK-ICONS-14"
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_ICONS_ELEMENTARY" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_ELEMENTARY\" 'AUR-INSTALL-GNOME-ICONS-ELEMENTARY'" "AUR-INSTALL-GNOME-ICONS-ELEMENTARY"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary" "RUN-GTK-ICONS-15"
                    read_input_yn "Install also the elementary XFCE icons" " " 1
                    if [[ "$YN_OPTION" -eq 1 ]]; then
                        add_aur_package "$AUR_INSTALL_GNOME_ICONS_ELEMENTARY_XFCE" # 
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_ELEMENTARY_XFCE\" 'AUR-INSTALL-GNOME-ICONS-ELEMENTARY-XFCE'" "AUR-INSTALL-GNOME-ICONS-ELEMENTARY-XFCE"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary-xfce" "RUN-GTK-ICONS-16"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary-xfce-dark" "RUN-GTK-ICONS-17"
                    fi
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_ICONS_NITRUX" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_NITRUX\" 'AUR-INSTALL-GNOME-ICONS-NITRUX'" "AUR-INSTALL-GNOME-ICONS-NITRUX"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX" "RUN-GTK-ICONS-18"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-BTN" "RUN-GTK-ICONS-19"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-BTN-blufold" "RUN-GTK-ICONS-20"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-C" "RUN-GTK-ICONS-21"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-DRK" "RUN-GTK-ICONS-22"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-G" "RUN-GTK-ICONS-23"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-G-lightpnl" "RUN-GTK-ICONS-24"
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_games"
USAGE="install_games"
DESCRIPTION="Install Games"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_games()
{
    # 10
    local -i total_menu_items=14    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-GAMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "GAMES - https://wiki.archlinux.org/index.php/Games"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Action|Adventure"  "" "" "Action|Adventure" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Arcade|Platformer" "" "" "Arcade|Platformer" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dungeon"           "" "" "Dungeon" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Emulators"         "" "" "Emulators" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "FPS"               "" "" "FPS: First Person Shooter" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "MMO"               "" "" "MMO" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Puzzle"            "" "" "Puzzle" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "RPG"               "" "" "RPG" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Racing"            "" "" "Racing" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Simulation"        "" "" "Simulation" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Strategy"          "" "" "Strategy" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Gnome"             "" "" "Gnome: $INSTALL_GNOME_GAMES" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "KDE"               "" "" "KDE: $INSTALL_KDE_GAMES" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Misc"              "" "" "Misc: $INSTALL_MISC_GAMES" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_action_games
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_arade_games
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_dungon_games
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_emulator_games
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_fps_games
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_mmo_games
                    ;;
                7)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_puzzle_games
                    ;;
                8)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_rpg_games
                    ;;
                9)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_racing_games
                    ;;
                10)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_simulation_games
                    ;;
                11)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_strategy_games
                    ;;
                12)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GNOME_GAMES" #  
                    add_packagemanager "package_install \"$INSTALL_GNOME_GAMES\" 'INSTALL-GNOME-GAMES'" "INSTALL-GNOME-GAMES"
                    ;;
                13)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_KDE_GAMES" #  
                    add_packagemanager "package_install \"$INSTALL_KDE_GAMES\" 'INSTALL-KDE-GAMES'" "INSTALL-KDE-GAMES"
                    ;;
                14)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_MISC_GAMES" #  
                    add_packagemanager "package_install \"$INSTALL_MISC_GAMES\" 'INSTALL-MISC-GAMES'" "INSTALL-MISC-GAMES"
                    ;;
               "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# INSTALL ACTION/ADVENTURE GAMES {{{
NAME="install_action_games"
USAGE="install_action_games"
DESCRIPTION="Install Action/Adventure Games"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_action_games()
{
    local -i total_menu_items=9    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="ACTION-ADVENTURE-GAMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "ACTION AND ADVENTURE"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "astromenace"           "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Counter-Strike 2D"     "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dead Cyborg Episode 1" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "M.A.R.S. Shooter"      "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Nikki"                 "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "opentyrian-hg" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Sonic Robot Blast 2" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "steelstorm" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Yo Frankie!" "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_ASTROMENANCE" #  
                    add_packagemanager "package_install \"$INSTALL_ASTROMENANCE\" 'INSTALL-ASTROMENANCE'" "INSTALL-ASTROMENANCE"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_COUNTER_STRIKE_2D" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_COUNTER_STRIKE_2D\" 'AUR-INSTALL-COUNTER-STRIKE-2D'" "AUR-INSTALL-COUNTER-STRIKE-2D"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DEAD_CYBORG_EP_1" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DEAD_CYBORG_EP_1\" 'AUR-INSTALL-DEAD-CYBORG-EP-1'" "AUR-INSTALL-DEAD-CYBORG-EP-1"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MARS_SHOOTER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MARS_SHOOTER\" 'AUR-INSTALL-MARS-SHOOTER'" "AUR-INSTALL-MARS-SHOOTER"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_NIKKI" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_NIKKI\" 'AUR-INSTALL-NIKKI'" "AUR-INSTALL-NIKKI"
                    ;;
                6)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_OPENTYRIAN" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_OPENTYRIAN\" 'AUR-INSTALL-OPENTYRIAN'" "AUR-INSTALL-OPENTYRIAN"
                    ;;
                7)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SRB2" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SRB2\" 'AUR-INSTALL-SRB2" "AUR-INSTALL-SRB2"
                    ;;
                8)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_STEELSTORM" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_STEELSTORM\" 'AUR-INSTALL-STEELSTORM'" "AUR-INSTALL-STEELSTORM"
                    ;;
                9)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_YOFRANKIE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_YOFRANKIE\" 'AUR-INSTALL-YOFRANKIE'" "AUR-INSTALL-YOFRANKIE"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                        break
                        ;;
                    *)
                        invalid_option "$SS_OPT"
                        ;;
                esac
            done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL ARCADE/PLATFORMER GAMES {{{
NAME="install_arade_games"
USAGE="install_arade_games"
DESCRIPTION="Install Arcade Plateformer Games"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_arade_games()
{
    local -r menu_name="INSTALL-ARCADE-PLATFORMER-GAMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "ARCADE AND PLATFORMER"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "abuse"                  "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Battle Tanks"           "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "bomberclone"            "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Those Funny Funguloids" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "frogatto"               "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "goonies"                "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "mari0"                  "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "neverball"              "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "opensonic"              "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Robombs"                "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Super Mario Chronicles" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xmoto"                  "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_ABUSE" #  
                    add_packagemanager "package_install \"$INSTALL_ABUSE\" 'INSTALL-ABUSE'" "INSTALL-ABUSE"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_BTANKS" #  
                    add_packagemanager "package_install \"$INSTALL_BTANKS\" 'INSTALL-BTANKS'" "INSTALL-BTANKS"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_BOMBERCLONE" #  
                    add_packagemanager "package_install \"$INSTALL_BOMBERCLONE\" 'INSTALL-BOMBERCLONE'" "INSTALL-BOMBERCLONE"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_FUNGULOIDS" # \"$AUR_INSTALL_FUNGULOIDS\"
                    add_packagemanager "aur_package_install '' 'AUR-INSTALL-FUNGULOIDS'" "AUR-INSTALL-FUNGULOIDS"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_FROGATTO" #  
                    add_packagemanager "package_install \"$INSTALL_FROGATTO\" 'INSTALL-FROGATTO'" "INSTALL-FROGATTO"
                    ;;
                6)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GOONIES" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GOONIES\" 'AUR-INSTALL-GOONIES'" "AUR-INSTALL-GOONIES"
                    ;;
                7)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MARI0" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MARI0\" 'AUR-INSTALL-MARI0'" "AUR-INSTALL-MARI0"
                    ;;
                8)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_NEVERBALL" #  
                    add_packagemanager "package_install \"$INSTALL_NEVERBALL\" 'INSTALL-NEVERBALL'" "INSTALL-NEVERBALL"
                    ;;
                9)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_OPENSONIC" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_OPENSONIC\" 'AUR-INSTALL-OPENSONIC'" "AUR-INSTALL-OPENSONIC"
                    ;;
               10)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ROBOMBS_BIN" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ROBOMBS_BIN\" 'AUR-INSTALL-ROBOMBS-BIN'" "AUR-INSTALL-ROBOMBS-BIN"
                    ;;
               11)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_SMC" #  
                    add_packagemanager "package_install \"$INSTALL_SMC\" 'INSTALL-SMC'" "INSTALL-SMC"
                    ;;
               12)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_XMOTO" #  
                    add_packagemanager "package_install \"$INSTALL_XMOTO\" 'INSTALL-XMOTO'" "INSTALL-XMOTO"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
               *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL DUNGEON GAMES {{{
NAME="install_dungon_games"
USAGE="install_dungon_games"
DESCRIPTION="Install Dungon Games"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_dungon_games()
{
    local -i total_menu_items=5    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-DUNGEON-GAMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "DUNGEON"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "adom"             "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Tales of MajEyal" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Lost Labyrinth"   "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "S.C.O.U.R.G.E."   "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Stone-Soupe"      "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ADOM" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ADOM\" 'AUR-INSTALL-ADOM'" "AUR-INSTALL-ADOM"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_TOME4" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_TOME4\" 'AUR-INSTALL-TOME4'" "AUR-INSTALL-TOME4"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_LOST_LABYRINTH" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_LOST_LABYRINTH\" 'AUR-INSTALL-LOST-LABYRINTH'" "AUR-INSTALL-LOST-LABYRINTH"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SCOURGE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SCOURGE\" 'AUR-INSTALL-SCOURGE'" "AUR-INSTALL-SCOURGE"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_STONE_SOUP" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_STONE_SOUP\" 'AUR-INSTALL-STONE-SOUP'" "AUR-INSTALL-STONE-SOUP"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
                *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL EMULATORS GAMES {{{
NAME="install_emulator_games"
USAGE="install_emulator_games"
DESCRIPTION="Install Emulator Games"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_emulator_games()
{
    local -i total_menu_items=8    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-EMULATORS-GAMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "EMULATORS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "BSNES"               "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Desmume-svn"         "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dolphin"             "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Epsxe"               "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Project 64"          "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Visual Boy Advanced" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "wxmupen64plus"       "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "zsnes"               "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_BSMES" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_BSMES\" 'AUR-INSTALL-BSMES'" "AUR-INSTALL-BSMES"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DESMUME" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DESMUME\" 'AUR-INSTALL-DESMUME'" "AUR-INSTALL-DESMUME"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DOLPHIN" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DOLPHIN\" 'AUR-INSTALL-DOLPHIN'" "AUR-INSTALL-DOLPHIN"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EPSXE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EPSXE\" 'AUR-INSTALL-EPSXE'" "AUR-INSTALL-EPSXE"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_PROJECT_64" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_PROJECT_64\" 'AUR-INSTALL-PROJECT-64'" "AUR-INSTALL-PROJECT-64"
                    ;;
                6)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_VBA" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_VBA\" 'AUR-INSTALL-VBA'" "AUR-INSTALL-VBA"
                    ;;
                7)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_WXMUPEN64PLUS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_WXMUPEN64PLUS\" 'AUR-INSTALL-WXMUPEN64PLUS'" "AUR-INSTALL-WXMUPEN64PLUS"
                    ;;
                8)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_ZSNES" #  
                    add_packagemanager "package_install \"$INSTALL_ZSNES\" 'INSTALL-ZSNES'" "INSTALL-ZSNES"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
               *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL FPS GAMES {{{
NAME="install_fps_games"
USAGE="install_fps_games"
DESCRIPTION="Install FPS Games"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_fps_games()
{
    local -i total_menu_items=5    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-FPS-GAMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "FPS Games"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "alienarena"      "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "warsow"          "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Wolfenstein"     "" "$AUR" "Wolfenstein: Enemy Territory" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "World of Padman" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xonotic"         "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_ALIENARENA" #  
                    add_packagemanager "package_install \"$INSTALL_ALIENARENA\" 'INSTALL-ALIENARENA'" "INSTALL-ALIENARENA"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_WARSOW" #  
                    add_packagemanager "package_install \"$INSTALL_WARSOW\" 'INSTALL-WARSOW'" "INSTALL-WARSOW"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ENEMY_TERRITORY" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ENEMY_TERRITORY\" 'AUR-INSTALL-ENEMY-TERRITORY'" "AUR-INSTALL-ENEMY-TERRITORY"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_WORLD_OF_PADMAN" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_WORLD_OF_PADMAN\" 'AUR-INSTALL-WORLD-OF-PADMAN'" "AUR-INSTALL-WORLD-OF-PADMAN"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_XONOTIC" #  
                    add_packagemanager "package_install \"$INSTALL_XONOTIC\" 'INSTALL-XONOTIC'" "INSTALL-XONOTIC"
                    ;;

              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
                *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL MMO GAMES {{{
NAME="install_mmo_games"
USAGE="install_mmo_games"
DESCRIPTION="Install MMO Games"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_mmo_games()
{
    local -i total_menu_items=6    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-MMO-GAMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "MMO"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Heroes of Newerth" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Manaplus"          "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Runescape"         "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Savage 2"          "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Spiral Knights"    "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Wakfu"             "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_HON" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_HON\" 'AUR-INSTALL-HON'" "AUR-INSTALL-HON"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MANAPLUS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MANAPLUS\" 'AUR-INSTALL-MANAPLUS'" "AUR-INSTALL-MANAPLUS"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_RUNESCAPE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_RUNESCAPE\" 'AUR-INSTALL-RUNESCAPE'" "AUR-INSTALL-RUNESCAPE"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SAVAGE_2" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SAVAGE_2\" 'AUR-INSTALL-SAVAGE-2'" "AUR-INSTALL-SAVAGE-2"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SPIRAL_KNIGHTS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_\" 'AUR-INSTALL-SPIRAL-KNIGHTS'" "AUR-INSTALL-SPIRAL-KNIGHTS"
                    ;;
                6)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_WAKFU" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_WAKFU\" 'AUR-INSTALL-WAKFU'" "AUR-INSTALL-WAKFU"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
                *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL PUZZLE GAMES {{{
NAME="install_puzzle_games"
USAGE="install_puzzle_games"
DESCRIPTION="Install Puzzle Games"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_puzzle_games()
{
    local -i total_menu_items=2    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-PUZZLE-GAMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    print_title "PUZZLE"
    while [[ 1 ]]; do
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "frozen-bubble" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Numptyphysics" "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_FROZEN_BUBBLE" #  
                    add_packagemanager "package_install \"$INSTALL_FROZEN_BUBBLE\" 'INSTALL-FROZEN-BUBBLE'" "INSTALL-FROZEN-BUBBLE"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_NUMPTYPHYSICS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_NUMPTYPHYSICS\" 'AUR-INSTALL-NUMPTYPHYSICS'" "AUR-INSTALL-NUMPTYPHYSICS"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
                *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL RPG GAMES {{{
NAME="install_rpg_games"
USAGE="install_rpg_games"
DESCRIPTION="Install RPG GAMES"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_rpg_games()
{
    local -i total_menu_items=3    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-RPG-GAMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "RPG"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Ardentryst"    "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Flare RPG"     "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Freedroid RPG" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ARDENTRYST" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ARDENTRYST\" 'AUR-INSTALL-ARDENTRYST'" "AUR-INSTALL-ARDENTRYST"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_FLARE_RPG" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_FLARE_RPG\" 'AUR-INSTALL-FLARE-RPG'" "AUR-INSTALL-FLARE-RPG"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_FREEDROUDRPG" #  
                    add_packagemanager "package_install \"$INSTALL_FREEDROUDRPG\" 'INSTALL-FREEDROUDRPG'" "INSTALL-FREEDROUDRPG"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
                *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL RACING GAMES {{{
NAME="install_racing_games"
USAGE="install_racing_games"
DESCRIPTION="Install Racing Games"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_racing_games()
{
    local -i total_menu_items=5    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-RACING-GAMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "RACING"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Maniadrive"   "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Death Rally"  "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Stun Trally"  "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Supertuxkart" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Speed Dreams" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MANIADRIVE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MANIADRIVE\" 'AUR-INSTALL-MANIADRIVE'" "AUR-INSTALL-MANIADRIVE"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DEATH_RALLY" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DEATH_RALLY\" 'AUR-INSTALL-DEATH-RALLY'" "AUR-INSTALL-DEATH-RALLY"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_STUNTRALLY" # \"$AUR_INSTALL_STUNTRALLY\"
                    add_packagemanager "aur_package_install '' 'AUR-INSTALL-STUNTRALLY'" "AUR-INSTALL-STUNTRALLY"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_SUPTERTUXKART" #  
                    add_packagemanager "package_install \"$INSTALL_SUPTERTUXKART\" 'INSTALL-SUPTERTUXKART'" "INSTALL-SUPTERTUXKART"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_SPEED_DREAMS" #  
                    add_packagemanager "package_install \"$INSTALL_SPEED_DREAMS\" 'INSTALL-SPEED-DREAMS'" "INSTALL-SPEED-DREAMS"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
                *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL SIMULATION GAMES {{{
NAME="install_simulation_games"
USAGE="install_simulation_games"
DESCRIPTION="Install Simulation Games"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_simulation_games()
{
    local -i total_menu_items=3    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-SIMULATION-GAMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "SIMULATION"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Simutrans"      "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Theme Hospital" "$AUR" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Openttd"        "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_SIMUTRANS" #  
                    add_packagemanager "package_install \"$INSTALL_SIMUTRANS\" 'INSTALL-SIMUTRANS'" "INSTALL-SIMUTRANS"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_CORSIX_TH" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_CORSIX_TH\" 'AUR-INSTALL-CORSIX-TH'" "AUR-INSTALL-CORSIX-TH"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_OPENTTD" #  
                    add_packagemanager "package_install \"$INSTALL_OPENTTD\" 'INSTALL-OPENTTD'" "INSTALL-OPENTTD"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
                *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL STRATEGY GAMES {{{
NAME="install_strategy_games"
USAGE="install_strategy_games"
DESCRIPTION="Install Strategy Games"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_strategy_games()
{
    local -i total_menu_items=3    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-STRATEGY-GAMES"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "STRATEGY"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "0ad"              "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dedgewars"        "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Megaglest"        "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Unknown-horizons" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Warzone2100"      "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Wesnoth"          "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Zod"              "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_0AD" #  
                    add_packagemanager "package_install \"$INSTALL_0AD\" 'INSTALL-0AD'" "INSTALL-0AD"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_HEDGEWARS" #  
                    add_packagemanager "package_install \"$INSTALL_HEDGEWARS\" 'INSTALL-HEDGEWARS'" "INSTALL-HEDGEWARS"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_MEGAGLEST" #  
                    add_packagemanager "package_install \"$INSTALL_MEGAGLEST\" 'INSTALL-MEGAGLEST'" "INSTALL-MEGAGLEST"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_UNKNOW_HORIZONS" #  
                    add_packagemanager "package_install \"$INSTALL_UNKNOW_HORIZONS\" 'INSTALL-UNKNOW-HORIZONS'" "INSTALL-UNKNOW-HORIZONS"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_WARZONE2100" #  
                    add_packagemanager "package_install \"$INSTALL_WARZONE2100\" 'INSTALL-WARZONE2100'" "INSTALL-WARZONE2100"
                    ;;
                6)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_WESNOTH" # 
                    add_packagemanager "package_install \"$INSTALL_WESNOTH\"  'INSTALL-WESNOTH'" "INSTALL-WESNOTH"
                    ;;
                7)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_COMMANDER_ZOD" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_COMMANDER_ZOD\" 'AUR-INSTALL-COMMANDER-ZOD'" "AUR-INSTALL-COMMANDER-ZOD"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
                *)
                    invalid_option "$SS_OPT"
                    ;;
                esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# CREATE SITES FOLDER {{{
NAME="create_sites_folder"
USAGE="create_sites_folder"
DESCRIPTION="create sites folder"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
create_sites_folder()
{
    # copy_file "from" "to" "$(basename $BASH_SOURCE) : $LINENO"
    # copy_dir "from" "to" "$(basename $BASH_SOURCE) : $LINENO"
    [[ ! -f  /etc/httpd/conf/extra/httpd-userdir.conf.aui ]] && cp -v /etc/httpd/conf/extra/httpd-userdir.conf /etc/httpd/conf/extra/httpd-userdir.conf.aui
    sed -i 's/public_html/Sites/g' /etc/httpd/conf/extra/httpd-userdir.conf
    su - "$USERNAME" -c "mkdir -p ~/Sites"
    su - "$USERNAME" -c "chmod o+x ~/ && chmod -R o+x ~/Sites"
    print_line
    echo "The folder \"Sites\" has been created in your home"
    echo "You can access your projects at \"http://localhost/~username\""
    pause_function "$(basename $BASH_SOURCE) : $LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL WEB SERVER {{{
NAME="install_web_server"
USAGE="install_web_server"
DESCRIPTION="Install Web Server"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_web_server()
{
    # 11
    #@FIX
    
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
                add_package "$INSTALL_WEB_SERVER_1" #  
                add_packagemanager "package_install \"$INSTALL_WEB_SERVER_1\" 'INSTALL-WEB-SERVER-1'" "INSTALL-WEB-SERVER-1"
                add_aur_package "$AUR_INSTALL_ADMINER" # 
                add_packagemanager "aur_package_install \"$AUR_INSTALL_ADMINER\" 'AUR-INSTALL-ADMINER'" "AUR-INSTALL-ADMINER" # if you add something, change this name
                add_packagemanager "systemctl enable httpd.service mysqld.service" "SYSTEMD-ENABLE-WEBSERVER-1"
                add_packagemanager "systemctl start mysqld.service" "SYSTEMD-START-MYSQL"
                ;;
            2)
                WEBSERVER=2
                add_package "$INSTALL_WEB_SERVER_2" #  
                add_packagemanager "package_install \"$INSTALL_WEB_SERVER_2\" 'INSTALL-WEB-SERVER-2'" "INSTALL-WEB-SERVER-2"
                add_aur_package "$AUR_INSTALL_ADMINER" # 
                add_packagemanager "aur_package_install \"$AUR_INSTALL_ADMINER\" 'AUR-INSTALL-ADMINER'" "AUR-INSTALL-ADMINER" # if you add something, change this name
                ;;
        esac
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL FONTS {{{
NAME="install_fonts"
USAGE="install_fonts"
DESCRIPTION="Install Fonts"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_fonts()
{
    # 12
    local -i total_menu_items=8    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-FONTS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "FONTS - https://wiki.archlinux.org/index.php/Fonts"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-dejavu"           "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-google-webfonts"  "$AUR" "" "ttf-google-webfonts Note: Removes: ttf-droid ttf-roboto ttf-ubuntu-font-family" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-funfonts"         "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-kochi-substitute" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-liberation"       "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-ms-fonts"         "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-vista-fonts"      "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "wqy-microhei"         "" "" "wqy-microhei: Chinese/Japanese/Korean Support" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_TTF_DEJAVU" #  
                    add_packagemanager "package_install \"$INSTALL_TTF_DEJAVU\" 'INSTALL-TTF-DEJAVU'" "INSTALL-TTF-DEJAVU"
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_packagemanager "package_remove 'ttf-droid ttf-roboto ttf-ubuntu-font-family'" "REMOVE-GOOGLE-WEBFONTS"
                    add_aur_package "$AUR_INSTALL_GOOGLE_WEBFONTS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GOOGLE_WEBFONTS\" 'AUR-INSTALL-GOOGLE-WEBFONTS'" "AUR-INSTALL-GOOGLE-WEBFONTS"
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_FUN_FONTS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_FUN_FONTS\" 'AUR-INSTALL-FUN-FONTS'" "AUR-INSTALL-FUN-FONTS"
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_KOCHI_FONTS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_KOCHI_FONTS\" 'AUR-INSTALL-KOCHI-FONTS'" "AUR-INSTALL-KOCHI-FONTS"
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_TTF_LIBERATION" #  
                    add_packagemanager "package_install \"$INSTALL_TTF_LIBERATION\" 'INSTALL-TTF-LIBERATION'" "INSTALL-TTF-LIBERATION"
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MS_FONTS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MS_FONTS\" 'AUR-INSTALL-MS-FONTS'" "AUR-INSTALL-MS-FONTS"
                    ;;
                7)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_VISTA_FONTS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_VISTA_FONTS\" 'AUR-INSTALL-VISTA-FONTS'" "AUR-INSTALL-VISTA-FONTS"
                    ;;
                8)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_WQY_FONTS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_WQY_FONTS\" 'AUR-INSTALL-WQY-FONTS'" "AUR-INSTALL-WQY-FONTS"
                    ;;
                "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# CLEAN ORPHAN PACKAGES {{{
NAME="clean_orphan_packages"
USAGE="clean_orphan_packages"
DESCRIPTION="Clean Orphan Packages"
NOTES=$(localize "NONE")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
clean_orphan_packages()
{
    # 14
    print_title "CLEAN ORPHAN PACKAGES"
    CONFIG_ORPHAN=1
}
#}}}
# -----------------------------------------------------------------------------
# GET NETWORK MANAGER {{{
NAME="get_network_manager"
USAGE=$(localize "GET-NETWORK-MANAGER-USAGE")
DESCRIPTION=$(localize "GET-NETWORK-MANAGER-DESC")
NOTES=$(localize "GET-NETWORK-MANAGER-NOTES")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "GET-NETWORK-MANAGER-USAGE" "get_network_manager"
localize_info "GET-NETWORK-MANAGER-DESC"  "Get Network Manager"
localize_info "GET-NETWORK-MANAGER-NOTES" "None."
#
localize_info "GET-NETWORK-MANAGER-TITLE"  "Network Manager"
localize_info "GET-NETWORK-MANAGER-INFO-1" "NetworkManager is a program for providing detection and configuration for systems to automatically connect to network. NetworkManager's functionality can be useful for both wireless and wired networks."
localize_info "GET-NETWORK-MANAGER-INFO-2" "WICD"
localize_info "GET-NETWORK-MANAGER-INFO-3" "Wicd is a network connection manager that can manage wireless and wired interfaces, similar and an alternative to NetworkManager."
localize_info "GET-NETWORK-MANAGER-SELECT" "Select a Newwork Manager:"
# -------------------------------------
get_network_manager()
{
    print_title "GET-NETWORK-MANAGER-TITLE"
    print_info  "GET-NETWORK-MANAGER-TITLE" " - https://wiki.archlinux.org/index.php/Networkmanager"
    print_this  "GET-NETWORK-MANAGER-INFO-1"
    print_info  "GET-NETWORK-MANAGER-INFO-2" " - https://wiki.archlinux.org/index.php/Wicd"
    print_this  "GET-NETWORK-MANAGER-INFO-3"
    SYSTEM_TYPES=("Networkmanager" "Wicd" "NONE");
    PS3="$prompt1"
    echo -e "GET-NETWORK-MANAGER-SELECT"
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
                NETWORK_MANAGER=""
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
# INSTALL NETWORK MANAGER {{{
NAME="install_network_manager"
USAGE=$(localize "INSTALL-NETWORK-MANAGER-USAGE")
DESCRIPTION=$(localize "INSTALL-NETWORK-MANAGER-DESC")
NOTES=$(localize "INSTALL-NETWORK-MANAGER-NOTES")
AUTHOR="helmuthdu and Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-NETWORK-MANAGER-USAGE" "install_network_manager"
localize_info "INSTALL-NETWORK-MANAGER-DESC"  "Install Network Manager"
localize_info "INSTALL-NETWORK-MANAGER-NOTES" "None."
# -------------------------------------
install_network_manager()
{
    # 1
    # @FIX use 
    get_network_manager
    if [[ "$NETWORK_MANAGER" == "networkmanager" ]]; then
        if [[ "$KDE_INSTALLED" -eq 1 ]]; then
            add_package "$INSTALL_NETWORKMANAGER_KDE" #  
            add_packagemanager "package_install \"$INSTALL_NETWORKMANAGER_KDE\" 'INSTALL-NETWORKMANAGER-KDE'" "INSTALL-NETWORKMANAGER-KDE"
            if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                add_package "$INSTALL_NETWORKMANAGER_APPLET" #  
                add_packagemanager "package_install \"$INSTALL_NETWORKMANAGER_APPLET\" 'INSTALL-NETWORKMANAGER-APPLET'" "INSTALL-NETWORKMANAGER-APPLET"
            fi
        else
            add_package "$INSTALL_NETWORKMANAGER" #  
            add_packagemanager "package_install \"$INSTALL_NETWORKMANAGER\" 'INSTALL-NETWORKMANAGER'" "INSTALL-NETWORKMANAGER"
        fi
        add_package "$INSTALL_NETWORKMANAGER_CORE" #  
        add_packagemanager "package_install \"$INSTALL_NETWORKMANAGER_CORE\" 'INSTALL-NETWORKMANAGER-CORE'" "INSTALL-NETWORKMANAGER-CORE"
        add_user_group "networkmanager"
        # Network Management daemon
        # Application development toolkit for controlling system-wide privileges
        add_packagemanager "systemctl enable NetworkManager.service polkitd.service" "SYSTEMD-ENABLE-NETWORKMANAGER"
        add_packagemanager "add_user_2_group 'networkmanager'" "GROUPADD-NETWORKMANAGER"
    elif [[ "$NETWORK_MANAGER" == "wicd" ]]; then
        if [[ "$KDE_INSTALLED" -eq 1 ]]; then
            add_aur_package "$AUR_INSTALL_WICD_KDE" # 
            add_packagemanager "aur_package_install \"$AUR_INSTALL_WICD_KDE\" 'AUR-INSTALL-WICD-KDE'" "AUR-INSTALL-WICD-KDE"
            if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                add_package "$INSTALL_WICD_GTK" #  
                add_packagemanager "package_install \"$INSTALL_WICD_GTK\" 'INSTALL-WICD-GTK'" "INSTALL-WICD-GTK"
            fi
        else
            add_package "$INSTALL_WICD_GTK" #  
            add_packagemanager "package_install \"$INSTALL_WICD_GTK\" 'INSTALL-WICD-GTK'" "INSTALL-WICD-GTK"
        fi
        # Network Management daemon
        add_packagemanager "systemctl enable wicd.service" "SYSTEMD-ENABLE-WICD"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL USB 3G MODEM {{{
NAME="install_usb_modem"
USAGE=$(localize "INSTALL-USB-3G-MODEM-USAGE")
DESCRIPTION=$(localize "INSTALL-USB-3G-MODEM-DESC")
NOTES=$(localize "INSTALL-USB-3G-MODEM-NOTES")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-USB-3G-MODEM-USAGE"   "install_usb_modem 1->[1=Install, 2=Remove]"
localize_info "INSTALL-USB-3G-MODEM-DESC"    "Install USB Modem"
localize_info "INSTALL-USB-3G-MODEM-NOTES"   "None."
#
localize_info "INSTALL-USB-3G-MODEM-SUPPORT" "Install usb 3G modem support" 
localize_info "INSTALL-USB-3G-MODEM-TITLE"   "USB 3G MODEM" 
localize_info "INSTALL-USB-3G-MODEM-INFO"    "A number of mobile telephone networks around the world offer mobile internet connections over UMTS (or EDGE or GSM) using a portable USB modem device." 
# -------------------------------------
install_usb_modem()
{
    # 1
    if [[ "$1" -eq "2" ]]; then
        remove_package "$INSTALL_USB_3G_MODEM" 
        remove_packagemanager "INSTALL-USB-3G-MODEM"
        return 0
    fi
    print_title "INSTALL-USB-3G-MODEM-TITLE" " - https://wiki.archlinux.org/index.php/USB_3G_Modem"
    print_info  "INSTALL-USB-3G-MODEM-INFO"
    read_input_yn "INSTALL-USB-3G-MODEM-SUPPORT" " " 0
    if [[ "$YN_OPTION" -eq 1 ]]; then
        add_package "$INSTALL_USB_3G_MODEM" #  
        add_packagemanager "package_install \"$INSTALL_USB_3G_MODEM\" 'INSTALL-USB-3G-MODEM'" "INSTALL-USB-3G-MODEM"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL ACCESSORIES APPS {{{
NAME="install_accessories_apps"
USAGE="install_accessories_apps"
DESCRIPTION="Install Accessory Apps"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_accessories_apps()
{
    # 4
    local -i total_menu_items=15    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="ACCESSORIES-APPS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "ACCESSORIES APPS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Cairo"                     "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Conky + CONKY-colors"      "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Deepin Scrot"              "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dockbarx"                  "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Docky"                     "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Speedcrunch or galculator" "" "$AUR" "Depending on DE" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Gnome Pie"                 "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Guake"                     "" ""     "Nice Terminal Popup F12" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Kupfer"                    "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Pyrenamer"                 "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Shutter"                   "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Synapse"                   "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Terminator"                "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Zim"                       "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Revelation"                "" "$AUR" "Password Safe." "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_CAIRO" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_CAIRO\" 'AUR-INSTALL-CAIRO'" "AUR-INSTALL-CAIRO"
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_" # \"$AUR_INSTALL_\"
                    add_packagemanager "aur_package_install '' 'AUR-INSTALL-CONKY'" "AUR-INSTALL-CONKY"
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_" # \"$AUR_INSTALL_\"
                    add_packagemanager "aur_package_install '' 'AUR-INSTALL-DEEPIN-SCROT'" "AUR-INSTALL-DEEPIN-SCROT"
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_" # \"$AUR_INSTALL_\"
                    add_packagemanager "aur_package_install '' 'AUR-INSTALL-DOCKY'" "AUR-INSTALL-DOCKY"
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_DOCKY" #  
                    add_packagemanager "package_install \"$INSTALL_DOCKY\" 'INSTALL-DOCKY'" "INSTALL-DOCKY"
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                            add_aur_package "$AUR_INSTALL_GALGULATOR" # 
                            add_packagemanager "aur_package_install \"$AUR_INSTALL_GALGULATOR\" 'AUR-INSTALL-GALCULATOR'" "AUR-INSTALL-GALCULATOR"
                        fi
                        add_aur_package "$AUR_INSTALL_" # \"$AUR_INSTALL_\"
                        add_packagemanager "aur_package_install '' 'AUR-INSTALL-SPEEDCRUNCH'" "AUR-INSTALL-SPEEDCRUNCH"
                    else
                        add_aur_package "$AUR_INSTALL_GALGULATOR" # 
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_GALGULATOR\" 'AUR-INSTALL-GALGULATOR'" "AUR-INSTALL-GALGULATOR"
                    fi
                    ;;
                7)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_PIE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_PIE\" 'AUR-INSTALL-GNOME-PIE'" "AUR-INSTALL-GNOME-PIE"
                    ;;
                8)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GUAKE" #  
                    add_packagemanager "package_install \"$INSTALL_GUAKE\" 'INSTALL-GUAKE'" "INSTALL-GUAKE"
                    ;;
                9)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_KUPFER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_KUPFER\" 'AUR-INSTALL-KUPFER'" "AUR-INSTALL-KUPFER"
                    ;;
                10)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_PYRENAMER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_PYRENAMER\" 'AUR-INSTALL-PYRENAMER'" "AUR-INSTALL-PYRENAMER"
                    ;;
                11)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SHUTTER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SHUTTER\" 'AUR-INSTALL-SHUTTER'" "AUR-INSTALL-SHUTTER"
                    ;;
                12)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_ZEITGEIST" #  
                    add_packagemanager "package_install \"$INSTALL_ZEITGEIST\" 'INSTALL-ZEITGEIST'" "INSTALL-ZEITGEIST"
                    add_aur_package "$AUR_INSTALL_ZEITGEIST" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ZEITGEIST\" 'AUR-INSTALL-ZEITGEIST'" "AUR-INSTALL-ZEITGEIST"
                    ;;
                13)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_TERMINATOR" #  
                    add_packagemanager "package_install \"$INSTALL_TERMINATOR\" 'INSTALL-TERMINATOR'" "INSTALL-TERMINATOR"
                    add_aur_package "$AUR_INSTALL_TERMINATOR" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_TERMINATOR\" 'AUR-INSTALL-TERMINATOR'" "AUR-INSTALL-TERMINATOR"
                    ;;
                14)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_ZIM" #  
                    add_packagemanager "package_install \"$INSTALL_ZIM\" 'INSTALL-ZIM'" "INSTALL-ZIM"
                    ;;
                15)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_REVELATION" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_REVELATION\" 'AUR-INSTALL-REVELATION'" "AUR-INSTALL-REVELATION"
                    add_packagemanager "make_dir '/etc/gconf/schemas/' \"$(basename $BASH_SOURCE) : $LINENO\";cd /etc/gconf/schemas/;ln -s /usr/share/gconf/schemas/revelation.schemas; cd \$(pwd)" "AUR-INSTALL-REVELATION-SETUP"
                    ;;
               "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_development_apps"
USAGE="install_development_apps"
DESCRIPTION="Install Development Apps"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_development_apps()
{
    # 3
    local -i total_menu_items=20    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="DEVELOPMENT-APPS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "DEVELOPMENT APPS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Qt and Creator"      "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Wt" "[Witty]"        ""        "C++ Web Applications Frame work based on Wigets." "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "MySQL and Workbench" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Aptana-Studio"       "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Bluefish"            "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Eclipse"             "" ""     "Sub menu for Customizing." "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "emacs"               "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gvim"                "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "geany"               "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "IntelliJ IDEA"       "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "kdevelop"            "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Netbeans"            "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Oracle Java"         "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Sublime Text 2"      "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Debugger Tools"      "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "meld"                "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "RabbitVCS"           "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "astyle"              "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "putty"               "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Utilities"           "" ""     "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                 1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_QT" #  
                    add_packagemanager "package_install \"$INSTALL_QT\" 'INSTALL-QT'" "INSTALL-QT"
                    add_packagemanager "mkdir -p /home/\$USERNAME/.config/Nokia/qtcreator/styles" "RUN-QT-1"
                    add_packagemanager "curl -o monokai.xml http://angrycoding.googlecode.com/svn/branches/qt-creator-monokai-theme/monokai.xml" "RUN-QT-2"
                    add_packagemanager "mv monokai.xml /home/\$USERNAME/.config/Nokia/qtcreator/styles/" "RUN-QT-3"
                    add_packagemanager "chown -R \$USERNAME:\$USERNAME /home/\$USERNAME/.config" "RUN-QT-4"
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_WT" #  
                    add_packagemanager "package_install \"$INSTALL_WT\" 'INSTALL-WT'" "INSTALL-WT"
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MYSQL_WORKBENCH" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MYSQL_WORKBENCH\" 'AUR-INSTALL-MYSQL-WORKBENCH'" "AUR-INSTALL-MYSQL-WORKBENCH"
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_APTANA_STUDIO" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_APTANA_STUDIO\" 'AUR-INSTALL-APTANA-STUDIO'" "AUR-INSTALL-APTANA-STUDIO"
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_BLUEFISH" #  
                    add_packagemanager "package_install \"$INSTALL_BLUEFISH\" 'INSTALL-BLUEFISH'" "INSTALL-BLUEFISH"
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_eclipse_dev
                    ;;
                7)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_EMACS" #  
                    add_packagemanager "package_install \"$INSTALL_EMACS\" 'INSTALL-EMACS'" "INSTALL-EMACS"
                    ;;
                8)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_packagemanager "package_remove 'vim'" "REMOVE-GVIM"
                    add_package "$INSTALL_VIM" #  
                    add_packagemanager "package_install \"$INSTALL_VIM\" 'INSTALL-VIM'" "INSTALL-VIM"
                    add_aur_package "$AUR_INSTALL_DISCOUNT" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DISCOUNT\" 'AUR-INSTALL-DISCOUNT'" "AUR-INSTALL-DISCOUNT"
                    ;;
                9)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GEANY" #  
                    add_packagemanager "package_install \"$INSTALL_GEANY\" 'INSTALL-GEANY'" "INSTALL-GEANY"
                    ;;
               10)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_INTELLIJ" #  
                    add_packagemanager "package_install \"$INSTALL_INTELLIJ\" 'INSTALL-INTELLIJ'" "INSTALL-INTELLIJ"
                    ;;
               11)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_KDEVELOP" #  
                    add_packagemanager "package_install \"$INSTALL_KDEVELOP\" 'INSTALL-KDEVELOP'" "INSTALL-KDEVELOP"
                    ;;
               12)
                    MenuChecks[$(($OPT - 1))]=1
                    add_package "$INSTALL_NETBEANS" #  
                    add_packagemanager "package_install \"$INSTALL_NETBEANS\" 'INSTALL-NETBEANS'" "INSTALL-NETBEANS"
                    ;;
               13)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_packagemanager "package_remove 'jre7-openjdk jdk7-openjdk'" "REMOVE-JDK"
                    add_aur_package "$AUR_INSTALL_JDK" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_JDK\" 'AUR-INSTALL-JDK'" "AUR-INSTALL-JDK"
                    ;;
               14)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SUBLIME" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SUBLIME\" 'AUR-INSTALL-SUBLIME'" "AUR-INSTALL-SUBLIME"
                    ;;
               15)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DEBUGGER_TOOLS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DEBUGGER_TOOLS\" 'AUR-INSTALL-DEBUGGER-TOOLS'" "AUR-INSTALL-DEBUGGER-TOOLS"
                    ;;
               16)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_MELD" #  
                    add_packagemanager "package_install \"$INSTALL_MELD\" 'INSTALL-MELD'" "INSTALL-MELD"
                    ;;
               17)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_RABBITVCS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_RABBITVCS\" 'AUR-INSTALL-RABBITVCS'" "AUR-INSTALL-RABBITVCS"
                    # @FIX check what is to be installed
                    if check_package "nautilus" ; then
                        add_aur_package "$AUR_INSTALL_RABBITVCS_NAUTILUS" # 
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_RABBITVCS_NAUTILUS\" 'AUR-INSTALL-RABBITVCS-NAUTILUS'" "AUR-INSTALL-RABBITVCS-NAUTILUS"
                    elif check_package "thunar" ; then
                        add_aur_package "$AUR_INSTALL_" # \"$AUR_INSTALL_\"
                        add_packagemanager "aur_package_install '' 'AUR-INSTALL-RABBITVCS-THUNAR'" "AUR-INSTALL-RABBITVCS-THUNAR"
                    else
                        add_aur_package "$AUR_INSTALL_RABBITVCS_CLI" # 
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_RABBITVCS_CLI\" 'AUR-INSTALL-RABBITVCS-CLI'" "AUR-INSTALL-RABBITVCS-CLI"
                    fi
                    ;;
               18)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_ASTYLE" # 
                    add_packagemanager "package_install \"$INSTALL_ASTYLE\"  'INSTALL-ASTYLE'" "INSTALL-ASTYLE"
                    ;;
               19)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_PUTTY" #  
                    add_packagemanager "package_install \"$INSTALL_PUTTY\" 'INSTALL-PUTTY'" "INSTALL-PUTTY"
                    ;;
               20)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_utilities
                    ;;
                "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# INSTALL ECLIPSE DEV {{{
NAME="install_eclipse_dev"
USAGE="install_eclipse_dev"
DESCRIPTION="Install Eclipse Dev"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_eclipse_dev()
{
    local -i total_menu_items=9    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-ECLIPSE-DEV"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "ECLIPSE - https://wiki.archlinux.org/index.php/Eclipse"
        print_info "Eclipse is an open source community project, which aims to provide a universal development platform."
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Eclipse IDE" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Eclipse IDE for C/C++ Developers" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Android Development Tools for Eclipse" "$AUR" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Web Development Tools for Eclipse"     "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "PHP Development Tools for Eclipse" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Python Development Tools for Eclipse" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Aptana Studio plugin for Eclipse" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Vim-like editing plugin for Eclipse" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Git support plugin for Eclipse" "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_ECLIPSE" #  
                    add_packagemanager "package_install \"$INSTALL_ECLIPSE\" 'INSTALL-ECLIPSE'" "INSTALL-ECLIPSE"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_ECLIPSE_CDT" #  
                    add_packagemanager "package_install \"$INSTALL_ECLIPSE_CDT\" 'INSTALL-ECLIPSE-CDT'" "INSTALL-ECLIPSE-CDT"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_ANDROID" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_ANDROID\" 'AUR-INSTALL-ECLIPSE-ANDROID'" "AUR-INSTALL-ECLIPSE-ANDROID"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_WTP" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_WTP\" 'AUR-INSTALL-ECLIPSE-WTP'" "AUR-INSTALL-ECLIPSE-WTP"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_PDT" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_PDT\" 'AUR-INSTALL-ECLIPSE-PDT'" "AUR-INSTALL-ECLIPSE-PDT"
                    ;;
                6)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_PYDEV" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_PYDEV\" 'AUR-INSTALL-ECLIPSE-PYDEV'" "AUR-INSTALL-ECLIPSE-PYDEV"
                    ;;
                7)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_APTANA" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_APTANA\" 'AUR-INSTALL-ECLIPSE-APTANA'" "AUR-INSTALL-ECLIPSE-APTANA"
                    ;;
                8)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_VRAPPER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_VRAPPER\" 'AUR-INSTALL-ECLIPSE-VRAPPER'" "AUR-INSTALL-ECLIPSE-VRAPPER"
                    ;;
                9)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_EGIT" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_EGIT\" 'AUR-INSTALL-ECLIPSE-EGIT'" "AUR-INSTALL-ECLIPSE-EGIT"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
               *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL UTILITES {{{
NAME="install_utilities"
USAGE="install_utilities"
DESCRIPTION="Install Utilities"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
localize_info "Install Utilities" "Install Utilities" 
install_utilities()
{
    # 3 sub 20
    print_title "Utilites"
    print_info "faac gpac espeak faac antiword unrtf odt2txt txt2tags nrg2iso bchunk gnome-disk-utility"
    print_info "Full List: $INSTALL_UTILITES" 
    read_input_yn "Install Utilities" " " 1
    if [[ "$YN_OPTION" -eq 1 ]]; then
        add_package "$INSTALL_UTILITES" # 
        add_packagemanager "package_install \"$INSTALL_UTILITES\" 'INSTALL-UTITILTIES'" "INSTALL-UTITILTIES"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL INTERNET APPS {{{
NAME="install_internet_apps"
USAGE="install_internet_apps"
DESCRIPTION="Install Internet Apps"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_internet_apps()
{
    # 7
    local -i total_menu_items=7    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INTERNET-APPS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "INTERNET APPS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Browser"            "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Download|Fileshare" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Email|RSS"          "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Instant Messaging"  "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "IRC"                "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Mapping Tools"      "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "VNC|Desktop Share"  "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_browsers
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_download_fileshare
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_email
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_im
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_irc
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_mapping
                    ;;
                7)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_desktop_share
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# INSTALL BROWSER APPS {{{
NAME="install_browsers"
USAGE="install_internet_apps"
DESCRIPTION="Install Internet Apps"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_browsers()
{
    local -i total_menu_items=5    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-BROWSER-APPS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "BROWSER"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Firefox" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Chromium" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Google Chrome" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Opera" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Rekonq or Midori" "" "" "Rekonq or Midori: Depending on DE" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_FIREFOX" #  
                    add_packagemanager "package_install \"$INSTALL_FIREFOX\" 'INSTALL-FIREFOX'" "INSTALL-FIREFOX"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_CHROMIUM" #  
                    add_packagemanager "package_install \"$INSTALL_CHROMIUM\" 'INSTALL-CHROMIUM'" "INSTALL-CHROMIUM"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GOOGLE_CHROME" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GOOGLE_CHROME\" 'AUR-INSTALL-GOOGLE-CHROME'" "AUR-INSTALL-GOOGLE-CHROME"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_OPERA" #  
                    add_packagemanager "package_install \"$INSTALL_OPERA\" 'INSTALL-OPERA'" "INSTALL-OPERA"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        add_package "$INSTALL_REKONQ" #  
                        add_packagemanager "package_install \"$INSTALL_REKONQ\" 'INSTALL-REKONQ'" "INSTALL-REKONQ"
                    else
                        add_package "$INSTALL_MIDORI" #  
                        add_packagemanager "package_install \"$INSTALL_MIDORI\" 'INSTALL-MIDORI'" "INSTALL-MIDORI"
                    fi
                    ;;
             "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# INSTALL DOWNLOAD FILESHARE {{{
NAME="install_download_fileshare"
USAGE="install_download_fileshare"
DESCRIPTION="Install Download / Fileshare"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_download_fileshare()
{
    local -i total_menu_items=8    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-DOWNLOAD-FILESHARE"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    # 
    while [[ 1 ]]; do
        print_title "DOWNLOAD|FILESHARE"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "deluge" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "dropbox" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "insync" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "jdownloader" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "nitroshare" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "sparkleshare" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "steadyflow-bzr" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Transmission" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_DELUGE" #  
                    add_packagemanager "package_install \"$INSTALL_DELUGE\" 'INSTALL-DELUGE'" "INSTALL-DELUGE"
                    ;;
                2)
                    # @FIX
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DROPBOX" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DROPBOX\" 'AUR-INSTALL-DROPBOX'" "AUR-INSTALL-DROPBOX"
                    if check_package "nautilus" ; then
                        add_aur_package "$AUR_INSTALL_DROPBOX_NAUTILUS" # 
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_DROPBOX_NAUTILUS\" 'AUR-INSTALL-DROPBOX-NAUTILUS'" "AUR-INSTALL-DROPBOX-NAUTILUS"
                    elif check_package "thunar" ; then
                        add_aur_package "$AUR_INSTALL_DROPBOX_THUNAR" # 
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_DROPBOX_THUNAR\" 'AUR-INSTALL-DROPBOX-THUNAR'" "AUR-INSTALL-DROPBOX-THUNAR"
                    elif check_package "kdebase-dolphin" ; then
                        add_aur_package "$AUR_INSTALL_DROPBOX_KFILEBOX" # 
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_DROPBOX_KFILEBOX\" 'AUR-INSTALL-DROPBOX-KFILEBOX'" "AUR-INSTALL-DROPBOX-KFILEBOX"
                    else
                        add_aur_package "$AUR_INSTALL_DROPBOX_CLI" # 
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_DROPBOX_CLI\" 'AUR-INSTALL-DROPBOX-CLI'" "AUR-INSTALL-DROPBOX-CLI"
                    fi
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_INSYNC" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_INSYNC\" 'AUR-INSTALL-INSYNC'" "AUR-INSTALL-INSYNC"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_JDOWNLOADER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_JDOWNLOADER\" 'AUR-INSTALL-JDOWNLOADER'" "AUR-INSTALL-JDOWNLOADER"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_NITROSHARE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_NITROSHARE\" 'AUR-INSTALL-NITROSHARE" "AUR-INSTALL-NITROSHARE"
                    ;;
                6)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_SPARKLESHARE" #  
                    add_packagemanager "package_install \"$INSTALL_SPARKLESHARE\" 'INSTALL-SPARKLESHARE'" "INSTALL-SPARKLESHARE"
                    ;;
                7)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_STEADYFLOW" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_STEADYFLOW\" 'AUR-INSTALL-STEADYFLOW'" "AUR-INSTALL-STEADYFLOW"
                    ;;
                8)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                            add_package "$INSTALL_TRANSMISSION_GTK" #  
                            add_packagemanager "package_install \"$INSTALL_TRANSMISSION_GTK\" 'INSTALL-TRANSMISSION-GTK'" "INSTALL-TRANSMISSION-GTK"
                        fi
                        add_package "$INSTALL_TRANSMISSION_QT" #  
                        add_packagemanager "package_install \"$INSTALL_TRANSMISSION_QT\" 'INSTALL-TRANSMISSION-QT'" "INSTALL-TRANSMISSION-QT"
                    else
                        add_package "$INSTALL_TRANSMISSION_GTK" #  
                        add_packagemanager "package_install \"$INSTALL_TRANSMISSION_GTK\" 'INSTALL-TRANSMISSION-GTK'" "INSTALL-TRANSMISSION-GTK"
                    fi
                    ;;
             "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# INSTALL EMAIL {{{
NAME="install_email"
USAGE="install_email"
DESCRIPTION="Install Email"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_email()
{
    local -i total_menu_items=4    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-EMAIL"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "EMAIL|RSS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Evolution" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Thunderbird" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Liferea" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Lightread" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_EVOLUTION" #  
                    add_packagemanager "package_install \"$INSTALL_EVOLUTION\" 'INSTALL-EVOLUTION'" "INSTALL-EVOLUTION"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_THUNDERBIRD" #  
                    add_packagemanager "package_install \"$INSTALL_THUNDERBIRD\" 'INSTALL-THUNDERBIRD'" "INSTALL-THUNDERBIRD"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_LIFEREA" #  
                    add_packagemanager "package_install \"$INSTALL_LIFEREA\" 'INSTALL-LIFEREA'" "INSTALL-LIFEREA"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_LIGHTREAD" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_LIGHTREAD\" 'AUR-INSTALL-LIGHTREAD'" "AUR-INSTALL-LIGHTREAD"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# INSTALL IM {{{
NAME="install_im"
USAGE="install_im"
DESCRIPTION="Install IM"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_im()
{
    local -i total_menu_items=5    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-IM"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "IM - INSTANT MESSAGING"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Emesene"           "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Google Talkplugin" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Pidgin"            "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Skype"             "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Teamspeak3"        "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_EMESENE" # 
                    add_packagemanager "package_install \"$INSTALL_EMESENE\"  'INSTALL-EMESENE'" "INSTALL-EMESENE"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GOOGLE_TALKPLUGIN" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GOOGLE_TALKPLUGIN\" 'AUR-INSTALL-GOOGLE-TALKPLUGIN'" "AUR-INSTALL-GOOGLE-TALKPLUGIN"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_PIDGIN" #  
                    add_packagemanager "package_install \"$INSTALL_PIDGIN\" 'INSTALL-PIDGIN'" "INSTALL-PIDGIN"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_taskmanager "required_repo 'multilib'" "REQUIRED-REPO-MULTILIB"                    
                    add_package "$INSTALL_SKYPE" #  
                    add_packagemanager "package_install \"$INSTALL_SKYPE\" 'INSTALL-SKYPE'" "INSTALL-SKYPE"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_TEAMSPEAK3" # \"$AUR_INSTALL_TEAMSPEAK3\"
                    add_packagemanager "aur_package_install '' 'AUR-INSTALL-TEAMSPEAK3'" "AUR-INSTALL-TEAMSPEAK3"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# INSTALL IRC {{{
NAME="install_irc"
USAGE="install_irc"
DESCRIPTION="Install IRC"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_irc()
{
    local -i total_menu_items=2    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-IRC"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "IRC"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "irssi" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "quassel or xchat" "Depending on DE" "" "quassel or xchat: Depending on DE" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_IRSSI" #  
                    add_packagemanager "package_install \"$INSTALL_IRSSI\" 'INSTALL-IRSSI'" "INSTALL-IRSSI"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                            add_package "$INSTALL_XCHAT" #  
                            add_packagemanager "package_install \"$INSTALL_XCHAT\" 'INSTALL-XCHAT'" "INSTALL-XCHAT"
                        fi
                        add_package "$INSTALL_QUASSEL" #  
                        add_packagemanager "package_install \"$INSTALL_QUASSEL\" 'INSTALL-QUASSEL'" "INSTALL-QUASSEL"
                    else
                        add_package "$INSTALL_XCHAT" #  
                        add_packagemanager "package_install \"$INSTALL_XCHAT\" 'INSTALL-XCHAT'" "INSTALL-XCHAT"
                    fi
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# INSTALL MAPPING {{{
NAME="install_mapping"
USAGE="install_mapping"
DESCRIPTION="Install Mapping"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_mapping()
{
    local -i total_menu_items=2    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-MAPPING"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #                    
    while [[ 1 ]];  do
        print_title "MAPPING TOOLS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Google Earth"    "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "NASA World Wind" "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_taskmanager "required_repo 'multilib'" "REQUIRED-REPO-MULTILIB"
                    add_package "$INSTALL_GOOGLE_EARTH" #  
                    add_packagemanager "package_install \"$INSTALL_GOOGLE_EARTH\" 'INSTALL-GOOGLE-EARTH'" "INSTALL-GOOGLE-EARTH"
                    add_aur_package "$AUR_INSTALL_GOOGLE_EARTH" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GOOGLE_EARTH\" 'AUR-INSTALL-GOOGLE-EARTH'" "AUR-INSTALL-GOOGLE-EARTH"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_WORLDWIND" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_WORLDWIND\" 'AUR-INSTALL-WORLDWIND'" "AUR-INSTALL-WORLDWIND"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# INSTALL DESKTOP SHARE {{{
NAME="install_desktop_share"
USAGE="install_desktop_share"
DESCRIPTION="Install Desktop Share"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_desktop_share()
{
    local -i total_menu_items=2    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-DESKTOP-SHARE"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "DESKTOP SHARE"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Remmina" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Teamviewer" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_REMMINA" # 
                    add_packagemanager "package_install \"$INSTALL_REMMINA\" 'INSTALL-REMMINA'" "INSTALL-REMMINA"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_TEAMVIEWER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_TEAMVIEWER\" 'AUR-INSTALL-TEAMVIEWER'" "AUR-INSTALL-TEAMVIEWER"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_graphics_apps"
USAGE="install_graphics_apps"
DESCRIPTION="Install Graphic Apps"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_graphics_apps()
{
    # 6
    local -i total_menu_items=14    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-GRAPHICS-APPS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "GRAPHICS APPS"
        print_info "AV Studio: $AV_STUDIO and from AUR $AV_STUDIO_AUR"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "AV Studio"      "" "Some $AUR" "AV Studio: Installs all Below and more Audio and Video Apps" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Blender"        "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Handbrake"      "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "CD/DVD Burners" "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Gimp"           "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Gimp-plugins"   "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Gthumb"         "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Inkscape"       "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Mcomix"         "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "MyPaint"        "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Scribus"        "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Shotwell"       "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Simple-scan"    "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Xnviewmp"       "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_av_studio
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_BLENDER" #  
                    add_packagemanager "package_install \"$INSTALL_BLENDER\" 'INSTALL-BLENDER'" "INSTALL-BLENDER"
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_HANDBRAKE" #  
                    add_packagemanager "package_install \"$INSTALL_HANDBRAKE\" 'INSTALL-HANDBRAKE'" "INSTALL-HANDBRAKE"
                    ;;
                4)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_BRASERO" #  
                    add_packagemanager "package_install \"$INSTALL_BRASERO\" 'INSTALL-BRASERO'" "INSTALL-BRASERO"
                    ;;
                5)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GIMP" # 
                    add_packagemanager "package_install \"$INSTALL_GIMP\"  'INSTALL-GIMP'" "INSTALL-GIMP"
                    ;;
                6)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GIMP_PLUGINS" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GIMP_PLUGINS\" 'AUR-INSTALL-GIMP-PLUGINS'" "AUR-INSTALL-GIMP-PLUGINS"
                    ;;
                7)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_GTHUMB" #  
                    add_packagemanager "package_install \"$INSTALL_GTHUMB\" 'INSTALL-GTHUMB'" "INSTALL-GTHUMB"
                    ;;
                8)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_INKSCAPE" #  
                    add_packagemanager "package_install \"$INSTALL_INKSCAPE\" 'INSTALL-INKSCAPE'" "INSTALL-INKSCAPE"
                    add_aur_package "$AUR_INSTALL_SOZI" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SOZI\" 'AUR-INSTALL-SOZI'" "AUR-INSTALL-SOZI"
                    ;;
                9)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_MCOMIX" #  
                    add_packagemanager "package_install \"$INSTALL_MCOMIX\" 'INSTALL-MCOMIX'" "INSTALL-MCOMIX"
                    ;;
               10)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_MYPAINT" # 
                    add_packagemanager "package_install \"$INSTALL_MYPAINT\"  'INSTALL-MYPAINT'" "INSTALL-MYPAINT"
                    ;;
               11)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_SCRIBUS" #  
                    add_packagemanager "package_install \"$INSTALL_SCRIBUS\" 'INSTALL-SCRIBUS'" "INSTALL-SCRIBUS"
                    ;;
               12)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_SHOTWELL" #  
                    add_packagemanager "package_install \"$INSTALL_SHOTWELL\" 'INSTALL-SHOTWELL'" "INSTALL-SHOTWELL"
                    ;;
               13)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_SIMPLE_SCAN" #  
                    add_packagemanager "package_install \"$INSTALL_SIMPLE_SCAN\" 'INSTALL-SIMPLE-SCAN'" "INSTALL-SIMPLE-SCAN"
                    ;;
               14)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_XNVIEWMP" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_XNVIEWMP\" 'AUR-INSTALL-XNVIEWMP'" "AUR-INSTALL-XNVIEWMP"
                    ;;
                "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
NAME="install_av_studio"
USAGE="install_av_studio"
DESCRIPTION="Install AV Studio"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_av_studio()
{
    # 6 sub 14
    print_title "Audio Video Studeo"
    print_info "Audacity, Ardour, Blender, Openshot, ffmpeg, mencoder, and more"
    print_info "Full List: $AV_STUDIO" 
    add_package "$AV_STUDIO" # 
    add_packagemanager "package_install \"$AV_STUDIO\" 'INSTALL-AUDIO-VIDEO-STUDEO'" "INSTALL-AUDIO-VIDEO-STUDEO" 
    add_aur_package "$AV_STUDIO_AUR" # 
    add_packagemanager "aur_package_install \"$AV_STUDIO_AUR\" 'AUR-INSTALL-AUDIO-VIDEO-STUDEO'" "AUR-INSTALL-AUDIO-VIDEO-STUDEO"
    pause_function "$(basename $BASH_SOURCE) : $LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL VIDEO APPS {{{
NAME="install_video_apps"
USAGE="install_video_apps"
DESCRIPTION="Install Video Apps"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_video_apps()
{
    # 9
    local -i total_menu_items=3    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-VIDEO-APPS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "VIDEO APPS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Players" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Editors|Tools" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Codecs" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "D"
        #
        SUB_OPTIONS+=" d"
        read_input_options "$SUB_OPTIONS"
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_video_players
                    ;;
                2)
                    MenuChecks[$(($S_OPT - 1))]=1
                    install_video_editors_tools
                    ;;
                3)
                    MenuChecks[$(($S_OPT - 1))]=1
                    add_package "$INSTALL_VIDEO_CODECS" # 
                    add_packagemanager "package_install \"$INSTALL_VIDEO_CODECS\"  'INSTALL-VIDEO-CODECS'" "INSTALL-VIDEO-CODECS"
                    if [[ "$ARCHI" != "x86_64" ]]; then
                        add_aur_package "$AUR_INSTALL_CODECS" # 
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_CODECS\" 'AUR-INSTALL-CODECS'" "AUR-INSTALL-CODECS"
                    else
                        add_aur_package "$AUR_INSTALL_CODECS_64" # 
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_CODECS_64\" 'AUR-INSTALL-CODECS-64'" "AUR-INSTALL-CODECS-64"
                    fi
                    ;;
              "d")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
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
# INSTALL VIDEO PLAYERS {{{
NAME="install_video_players"
USAGE="install_video_players"
DESCRIPTION="Install Video Players"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_video_players()
{
    local -i total_menu_items=9    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-VIDEO-PLAYERS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "VIDEO PLAYERS"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Audience-bzr"      "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Gnome-mplayer"     "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Parole"            "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "MiniTube"          "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Miro"              "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Rosa Media Player" "$AUR" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "SM Player" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "VLC" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "XBMC" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_AUDIENCE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_AUDIENCE\" 'AUR-INSTALL-AUDIENCE'" "AUR-INSTALL-AUDIENCE"
                    ;;
                2)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_GNOME_MPLAYER" # 
                    add_packagemanager "package_install \"$INSTALL_GNOME_MPLAYER\"  'INSTALL-GNOME-MPLAYER'" "INSTALL-GNOME-MPLAYER"
                    ;;
                3)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_PAROLE" #  
                    add_packagemanager "package_install \"$INSTALL_PAROLE\" 'INSTALL-PAROLE'" "INSTALL-PAROLE"
                    ;;
                4)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MINITUBE" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MINITUBE\" 'AUR-INSTALL-MINITUBE'" "AUR-INSTALL-MINITUBE"
                    ;;
                5)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_MIRO" #  
                    add_packagemanager "package_install \"$INSTALL_MIRO\" 'INSTALL-MIRO'" "INSTALL-MIRO"
                    ;;
                6)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ROSA_MEDIA_PLAYER" # 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ROSA_MEDIA_PLAYER\" 'AUR-INSTALL-ROSA-MEDIA-PLAYER'" "AUR-INSTALL-ROSA-MEDIA-PLAYER"
                    ;;
                7)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_SMPLAYER" #  
                    add_packagemanager "package_install \"$INSTALL_SMPLAYER\" 'INSTALL-SMPLAYER'" "INSTALL-SMPLAYER"
                    ;;
                8)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_VLC" #  
                    add_packagemanager "package_install \"$INSTALL_VLC\" 'INSTALL-VLC'" "INSTALL-VLC"
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        add_package "$INSTALL_VLC_KDE" #  
                        add_packagemanager "package_install \"$INSTALL_VLC_KDE\" 'INSTALL-VLC-KDE'" "INSTALL-VLC-KDE"
                    fi
                    ;;
                9)
                    MenuChecks[$(($SS_OPT - 1))]=1
                    add_package "$INSTALL_XBNC" #  
                    add_packagemanager "package_install \"$INSTALL_XBNC\" 'INSTALL-XBNC'" "INSTALL-XBNC"
                    ;;
              "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
                *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL VIDEO EDITORS TOOLS {{{
NAME="install_video_editors_tools"
USAGE="install_video_editors_tools"
DESCRIPTION=$(localize "INSTALL-VIDEO-EDITORS-TOOLS-DESC")
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-VIDEO-EDITORS-TOOLS-DESC"  "Install Video Editors Tools"
#
localize_info "INSTALL-VIDEO-EDITORS-TOOLS-TITLE" "VIDEO EDITORS|TOOLS"
install_video_editors_tools()
{
    local -i total_menu_items=6    # You must define this first; since first run array doesn't exist, so its built using this number.
    local -r menu_name="INSTALL-VIDEO-EDITORS-TOOLS"  # You must define Menu Name here
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    while [[ 1 ]]; do
        print_title "INSTALL-VIDEO-EDITORS-TOOLS-TITLE"
        local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Arista-transcoder" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Transmageddon"     "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "KDEenlive"         "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Openshot"          "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Pitivi"            "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Kazam-bzr"         "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "B"
        #
        S_SUB_OPTIONS+=" b"
        read_input_options "$S_SUB_OPTIONS"
        for SS_OPT in ${OPTIONS[@]}; do
           case "$SS_OPT" in
               1)
                   MenuChecks[$(($SS_OPT - 1))]=1
                   add_package "$AUR_INSTALL_ARISTA_TRANSCODER" #  
                   add_packagemanager "aur_package_install \"$AUR_INSTALL_ARISTA_TRANSCODER\" 'AUR-INSTALL-ARISTA-TRANSCODER'" "AUR-INSTALL-ARISTA-TRANSCODER"
                   ;;
               2)
                   MenuChecks[$(($SS_OPT - 1))]=1
                   add_package "$INSTALL_TRAMSMAGEDDON" #  
                   add_packagemanager "package_install \"$INSTALL_TRAMSMAGEDDON\" 'INSTALL-TRAMSMAGEDDON'" "INSTALL-TRAMSMAGEDDON"
                   ;;
               3)
                   MenuChecks[$(($SS_OPT - 1))]=1
                   add_package "$INSTALL_KDENLIVE" #  
                   add_packagemanager "package_install \"$INSTALL_KDENLIVE\" 'INSTALL-KDENLIVE'" "INSTALL-KDENLIVE"
                   ;;
               4)
                   MenuChecks[$(($SS_OPT - 1))]=1
                   add_package "$INSTALL_OPENSHOT" #  
                   add_packagemanager "package_install \"$INSTALL_OPENSHOT\" 'INSTALL-OPENSHOT'" "INSTALL-OPENSHOT"
                   ;;
               5)
                   MenuChecks[$(($SS_OPT - 1))]=1
                   add_package "$INSTALL_PITIVI" #  
                   add_packagemanager "package_install \"$INSTALL_PITIVI\" 'INSTALL-PITIVI'" "INSTALL-PITIVI"
                   ;;
               6)
                   MenuChecks[$(($SS_OPT - 1))]=1
                   add_aur_package "$AUR_INSTALL_KAZAM_BZR" # 
                   add_packagemanager "aur_package_install \"$AUR_INSTALL_KAZAM_BZR\" 'AUR-INSTALL-KAZAM-BZR'" "AUR-INSTALL-KAZAM-BZR"
                   ;;
             "b")
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                        return 1
                    fi
                    break
                    ;;
               *)
                    invalid_option "$SS_OPT"
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "b"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL SCIENCE {{{
NAME="install_science"
USAGE="install_science"
DESCRIPTION="Install Science"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
install_science()
{
    print_title "Science and Education"
    print_info ""
    print_info "Full List: $INSTALL_SCIENCE_EDUCATION" 
    add_package "$INSTALL_SCIENCE_EDUCATION" #  
    add_packagemanager "package_install \"$INSTALL_SCIENCE_EDUCATION\" 'INSTALL-SCIENCE'" "INSTALL-SCIENCE"
    pause_function "$(basename $BASH_SOURCE) : $LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL VIDEO CARDS {{{
NAME="install_video_cards"
USAGE=$(localize "INSTALL-VIDEO-CARDS-USAGE")
DESCRIPTION=$(localize "INSTALL-VIDEO-CARDS-DESC")
NOTES=$(localize "INSTALL-VIDEO-CARDS-NOTES")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-VIDEO-CARDS-USAGE" "install_video_cards 1->[1=Install, 2=Remove]"
localize_info "INSTALL-VIDEO-CARDS-DESC"  "Install Video Card"
localize_info "INSTALL-VIDEO-CARDS-NOTES" "None."
#
localize_info "INSTALL-VIDEO-CARDS-TITLE"  "VIDEO CARD"
localize_info "INSTALL-VIDEO-CARDS-INFO"   "NVIDIA"
localize_info "INSTALL-VIDEO-CARDS-SELECT" "Select a Video Card:"
# -------------------------------------
install_video_cards()
{
    print_title "INSTALL-VIDEO-CARDS-TITLE" " - https://wiki.archlinux.org/index.php/HCL/Video_Cards"
    print_info  "INSTALL-VIDEO-CARDS-INFO"  " - https://wiki.archlinux.org/index.php/NVIDIA"
    PS3="$prompt1"
    print_this "INSTALL-VIDEO-CARDS-SELECT"
    select OPT in "${VIDEO_CARDS[@]}"; do
        case "$REPLY" in
            1)
                if [[ "$1" -eq 1 ]]; then
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
                    add_package "$INSTALL_NVIDIA"   
                    add_packagemanager "package_install \"$INSTALL_NVIDIA\" 'INSTALL-NVIDIA'" "INSTALL-NVIDIA"
                    add_packagemanager "nvidia-xconfig" "RUN-NVIDIA-XCONFIG"
                else
                    remove_package "$INSTALL_NVIDIA"
                    remove_packagemanager "REMOVE-NVIDIA"
                    remove_packagemanager "INSTALL-NVIDIA"
                    remove_packagemanager "RUN-NVIDIA-XCONFIG"
                fi
                break
                ;;
            2)
                if [[ "$1" -eq 1 ]]; then
                    VIDEO_CARD=2 # 2 NOUVEAU
                    add_package "$INSTALL_NOUVEAU" #  
                    add_packagemanager "package_install \"$INSTALL_NOUVEAU\" 'INSTALL-NOUVEAU'" "INSTALL-NOUVEAU"
                    add_module "nouveau" "MODULE-NOUVEAU"
                else
                    remove_module "MODULE-NOUVEAU"
                    remove_package "$INSTALL_NOUVEAU"
                    remove_packagemanager "INSTALL-NOUVEAU"
                fi
                break
                ;;
            3)
                if [[ "$1" -eq 1 ]]; then
                    VIDEO_CARD=3 # 3 INTEL
                    add_package "$INSTALL_INTEL" #  
                    add_packagemanager "package_install \"$INSTALL_INTEL\" 'INSTALL-INTEL'" "INSTALL-INTEL"
                else
                    remove_package "$INSTALL_INTEL"
                    remove_packagemanager "INSTALL-INTEL"
                fi
                break
                ;;
            4)
                if [[ "$1" -eq 1 ]]; then
                    VIDEO_CARD=4 # 4 ATI
                    add_package "$INSTALL_ATI" #  
                    add_packagemanager "package_install \"$INSTALL_ATI\" 'INSTALL-ATI'" "INSTALL-ATI"
                    add_module "radeon" "MODULE-RADEON"
                else
                    remove_module "MODULE-RADEON"
                    remove_package "$INSTALL_ATI"
                    remove_packagemanager "INSTALL-ATI"
                fi
                break
                ;;
            5)
                if [[ "$1" -eq 1 ]]; then
                    VIDEO_CARD=5 # 5 VESA
                    add_package "$INSTALL_VESA" #  
                    add_packagemanager "package_install \"$INSTALL_VESA\" 'INSTALL-VESA'" "INSTALL-VESA"
                else
                    remove_package "$INSTALL_VESA"
                    remove_packagemanager "INSTALL-VESA"
                fi
                break
                ;;
            6)
                if [[ "$1" -eq 1 ]]; then
                    VIDEO_CARD=6 # 6 VIRTUALBOX
                    add_package "$INSTALL_VIRTUALBOX" #  
                    add_packagemanager "package_install \"$INSTALL_VIRTUALBOX\" 'INSTALL-VIRTUALBOX'" "INSTALL-VIRTUALBOX"
                    add_module "vboxguest" "MODULE-VIRUALBOX-GUEST"
                    add_module "vboxsf"    "MODULE-VITRUALBOX-SF"
                    add_module "vboxvideo" "MODULE-VIRTUALBOX-VIDEO"
                    add_user_group "vboxsf"
                else
                    remove_user_group "vboxsf"
                    remove_module "MODULE-VIRUALBOX-GUEST"
                    remove_module "MODULE-VITRUALBOX-SF"
                    remove_module "MODULE-VIRTUALBOX-VIDEO"
                    remove_package "$INSTALL_VIRTUALBOX"
                    remove_packagemanager "INSTALL-VIRTUALBOX"
                fi
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
NAME="install_cups"
USAGE=$(localize "INSTALL-CUPS-USAGE")
DESCRIPTION=$(localize "INSTALL-CUPS-DESC")
NOTES=$(localize "INSTALL-CUPS-NOTES")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-CUPS-USAGE" "install_cups 1->[1=Install, 2=Remove]"
localize_info "INSTALL-CUPS-DESC"  "Install Cups."
localize_info "INSTALL-CUPS-NOTES" "None."
#
localize_info "INSTALL-CUPS-YN" "Install CUPS - AKA Common Unix Printing System" 
localize_info "INSTALL-CUPS-TITLE" "CUPS - AKA Common Unix Printing System" 
localize_info "INSTALL-CUPS-INFO" "CUPS is the standards-based, open source printing system developed by Apple Inc. for Mac OS® X and other UNIX®-like operating systems." 
install_cups()
{
    if [[ "$1" -eq 2 ]]; then
        remove_packagemanager "INSTALL-CUPS"
        remove_packagemanager "SYSTEMD-ENABLE-CUPS"
        remove_package "$INSTALL_CUPS_PACK"
        return 0
    fi
    # Install Software 
    print_title "INSTALL-CUPS-TITLE" " - https://wiki.archlinux.org/index.php/Cups"
    print_info  "INSTALL-CUPS-INFO"
    read_input_yn "INSTALL-CUPS-YN" " " 1
    if [[ "$YN_OPTION" -eq 1 ]]; then
        add_package "$INSTALL_CUPS_PACK" #  
        add_packagemanager "package_install \"$INSTALL_CUPS_PACK\" 'INSTALL-CUPS'" "INSTALL-CUPS"
        add_packagemanager "systemctl enable cups.service" "SYSTEMD-ENABLE-CUPS"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL ADDITIONAL FIRMWARE {{{
NAME="install_additional_firmwares"
USAGE="INSTALL-ADDITIONAL-FIRMWARE-USAGE"
DESCRIPTION="INSTALL-ADDITIONAL-FIRMWARE-DESC"
NOTES=$(localize "INSTALL-ADDITIONAL-FIRMWARE-NOTES")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-ADDITIONAL-FIRMWARE-USAGE"   "install_additional_firmwares 1->[1=Install, 2=Remove]"
localize_info "INSTALL-ADDITIONAL-FIRMWARE-DESC"    "Install Addition Firmwares"
localize_info "INSTALL-ADDITIONAL-FIRMWARE-NOTES"   "None."
#
localize_info "INSTALL-ADDITIONAL-FIRMWARE-TITLE"   "INSTALL ADDITIONAL FIRMWARES"
localize_info "INSTALL-ADDITIONAL-FIRMWARE-INFO"    "alsa-firmware, ipw2100-fw, ipw2200-fw, b43-firmware, b43-firmware-legacy, broadcom-wl, zd1211-firmware, bluez-firmware, libffado, libraw1394, sane-gt68xx-firmware"
localize_info "Install-firmwares"                   "Install additional firmwares [Audio,Bluetooth,Scanner,Wireless]" 
localize_info "INSTALL-ADDITIONAL-FIRMWARE-INFO-9"  "libffado: [Fireware Audio Devices]"
localize_info "INSTALL-ADDITIONAL-FIRMWARE-INFO-10" "libraw1394: [IEEE1394 Driver]"
# -------------------------------------
install_additional_firmwares()
{
    # Install Software 
    local -r menu_name="INSTALL-ADDITIONAL-FIRMWARE"  # You must define Menu Name here
    local BreakableKey="D" 
    #
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    #
    print_title "INSTALL-ADDITIONAL-FIRMWARE-TITLE"
    print_info  "INSTALL-ADDITIONAL-FIRMWARE-INFO"
    read_input_yn "Install-firmwares" " " 0
    if [[ "$YN_OPTION" -eq 1 ]]; then
        while [[ 1 ]]; do
            print_title "INSTALL-ADDITIONAL-FIRMWARE-TITLE"
            local -a MenuItems=( "" ); local -a MenuInfo=( "" ) # Reset
            #
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "alsa-firmware"        "" ""     "" "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ipw2100-fw"           "" ""     "" "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ipw2200-fw"           "" ""     "" "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "b43-firmware"         "" "$AUR" "" "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "b43-firmware-legacy"  "" "$AUR" "" "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "broadcom-wl"          "" "$AUR" "" "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "zd1211-firmware"      "" ""     "" "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "bluez-firmware"       "" ""     "" "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "libffado"             "" ""     "INSTALL-ADDITIONAL-FIRMWARE-INFO-9"  "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "libraw1394"           "" ""     "INSTALL-ADDITIONAL-FIRMWARE-INFO-10" "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "sane-gt68xx-firmware" "" ""     "" "MenuTheme[@]"
            #
            print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
            #
            SUB_OPTIONS+=" d"
            read_input_options "$SUB_OPTIONS"
            for S_OPT in ${OPTIONS[@]}; do
                case "$S_OPT" in
                    1)
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$(($S_OPT - 1))]=1
                            add_package "$INSTALL_ALSA_FIRMWARE" #  
                            add_packagemanager "package_install \"$INSTALL_ALSA_FIRMWARE\" 'INSTALL-ALSA-FIRMWARE'" "INSTALL-ALSA-FIRMWARE"
                        else
                            MenuChecks[$(($S_OPT - 1))]=0
                            remove_package "$INSTALL_ALSA_FIRMWARE"
                            remove_packagemanager "INSTALL-ALSA_FIRMWARE"
                            return 0
                        fi                    
                        ;;
                    2)
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$(($S_OPT - 1))]=1
                            add_package "$INSTALL_IPW2100_FW" #  
                            add_packagemanager "package_install \"$INSTALL_IPW2100_FW\" 'INSTALL-IPW2100-FW'" "INSTALL-IPW2100-FW"
                        else
                            MenuChecks[$(($S_OPT - 1))]=0
                            remove_package "$INSTALL_IPW2100_FW"
                            remove_packagemanager "INSTALL-IPW2100-FW"
                            return 0
                        fi                    
                        ;;
                    3)  
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$(($S_OPT - 1))]=1
                            add_package "$INSTALL_IPW2200_FW" #  
                            add_packagemanager "package_install \"$INSTALL_IPW2200_FW\" 'INSTALL-IPW2200-FW'" "INSTALL-IPW2200-FW"
                        else
                            MenuChecks[$(($S_OPT - 1))]=0
                            remove_package "$INSTALL_IPW2200_FW"
                            remove_packagemanager "INSTALL-IPW2200-FW"
                            return 0
                        fi                    
                        ;;
                    4)
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$(($S_OPT - 1))]=1
                            add_aur_package "$AUR_INSTALL_B43_FIRMWARE" # 
                            add_packagemanager "aur_package_install \"$AUR_INSTALL_B43_FIRMWARE\" 'AUR-INSTALL-B43-FIRMWARE'" "AUR-INSTALL-B43-FIRMWARE"
                        else
                            MenuChecks[$(($S_OPT - 1))]=0
                            remove_package "$AUR_INSTALL_B43_FIRMWARE"
                            remove_packagemanager "AUR-INSTALL-B43-FIRMWARE"
                            return 0
                        fi                    
                        ;;
                    5)
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$(($S_OPT - 1))]=1
                            add_aur_package "$AUR_INSTALL_B43_FIRMWARE_LEGACY" # 
                            add_packagemanager "aur_package_install \"$AUR_INSTALL_B43_FIRMWARE_LEGACY\" 'AUR-INSTALL-B43-FIRMWARE-LEGACY'" "AUR-INSTALL-B43-FIRMWARE-LEGACY"
                        else
                            MenuChecks[$(($S_OPT - 1))]=0
                            remove_package "$AUR_INSTALL_B43_FIRMWARE_LEGACY"
                            remove_packagemanager "AUR-INSTALL-B43-FIRMWARE-LEGACY"
                            return 0
                        fi                    
                        ;;
                    6)
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$(($S_OPT - 1))]=1
                            add_aur_package "$AUR_INSTALL_BROADCOM_WL" # 
                            add_packagemanager "aur_package_install \"$AUR_INSTALL_BROADCOM_WL\" 'AUR-INSTALL-BROADCOM-WL'" "AUR-INSTALL-BROADCOM-WL"
                        else
                            MenuChecks[$(($S_OPT - 1))]=0
                            remove_package "$AUR_INSTALL_BROADCOM_WL"
                            remove_packagemanager "AUR-INSTALL-BROADCOM-WL"
                            return 0
                        fi                    
                        ;;
                    7)
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$(($S_OPT - 1))]=1
                            add_package "$INSTALL_ZD1211_FIRMWARE" #  
                            add_packagemanager "package_install \"$INSTALL_ZD1211_FIRMWARE\" 'INSTALL-ZD1211-FIRMWARE'" "INSTALL-ZD1211-FIRMWARE"
                        else
                            remove_package "$INSTALL_ZD1211_FIRMWARE"
                            MenuChecks[$(($S_OPT - 1))]=0
                            remove_packagemanager "INSTALL-ZD1211-FIRMWARE"
                            return 0
                        fi                    
                        ;;
                    8)
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$(($S_OPT - 1))]=1
                            add_package "$INSTALL_BLUEZ_FIREWARE" #  
                            add_packagemanager "package_install \"$INSTALL_BLUEZ_FIREWARE\" 'INSTALL-BLUEZ-FIREWARE'" "INSTALL-BLUEZ-FIREWARE"
                        else
                            MenuChecks[$(($S_OPT - 1))]=0
                            remove_package "$INSTALL_BLUEZ_FIREWARE"
                            remove_packagemanager "INSTALL-BLUEZ-FIREWARE"
                            return 0
                        fi                    
                        ;;
                    9)
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$(($S_OPT - 1))]=1
                            add_package "$INSTALL_LIBFFADO" #  
                            add_packagemanager "package_install \"$INSTALL_LIBFFADO\" 'INSTALL-LIBFFADO'" "INSTALL-LIBFFADO"
                        else
                            remove_package "$INSTALL_LIBFFADO"
                            MenuChecks[$(($S_OPT - 1))]=0
                            remove_packagemanager "INSTALL-LIBFFADO"
                            return 0
                        fi                    
                        ;;
                   10)
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$(($S_OPT - 1))]=1
                            add_package "$INSTALL_LIBRAW1394" #  
                            add_packagemanager "package_install \"$INSTALL_LIBRAW1394\" 'INSTALL-LIBRAW1394'" "INSTALL-LIBRAW1394"
                        else
                            MenuChecks[$(($S_OPT - 1))]=0
                            remove_package "$INSTALL_LIBRAW1394"
                            remove_packagemanager "INSTALL-LIBRAW1394"
                            return 0
                        fi                    
                        ;;
                   11)
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$(($S_OPT - 1))]=1
                            add_package "$INSTALL_SANE_GT68XX_FIRMWARE" #  
                            add_packagemanager "package_install \"$INSTALL_SANE_GT68XX_FIRMWARE\" 'INSTALL-SANE-GT68XX-FIRMWARE'" "INSTALL-SANE-GT68XX-FIRMWARE"
                        else
                            MenuChecks[$(($S_OPT - 1))]=0
                            remove_package "$INSTALL_SANE_GT68XX_FIRMWARE"
                            remove_packagemanager "INSTALL-SANE-GT68XX-FIRMWARE"
                            return 0
                        fi                    
                        ;;
                  "d")
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                           SAVED_MAIN_MENU=1
                           return 1
                        fi
                        break
                        ;;
                    *)
                        if [[ $(to_lower_case "$S_OPT") == $(to_lower_case "$BreakableKey") ]]; then
                            S_OPT="$BreakableKey"
                            break;
                        fi
                        invalid_option "$S_OPT"
                        ;;
                esac
            done
            is_breakable "$S_OPT" "$BreakableKey"
        done
    fi
}
#}}}
# -----------------------------------------------------------------------------
# TEST INSTALL {{{
NAME="test_install"
USAGE="test_install"
DESCRIPTION=$(localize "TEST-INSTALL-DESC")
NOTES=$(localize "TEST-INSTALL-NOTES")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "TEST-INSTALL-DESC"  "Test Install"
localize_info "TEST-INSTALL-NOTES" "None."
#
localize_info "TEST-INSTALL-INFO" "Test Install"
localize_info "TEST-INSTALL-INFO-1" "Testing Core Packages."
localize_info "TEST-INSTALL-INFO-2" "Testing AUR Packages."
localize_info "TEST-INSTALL-WARN-1" "pacman Did Not find Package:"
localize_info "TEST-INSTALL-WARN-2" "pacman Did Not find AUR Package:"
# -------------------------------------
test_install()
{
    # @FIX how to test now?
    print_info "TEST-INSTALL-INFO"    
    #
    print_info "TEST-INSTALL-INFO-1"    
    local -i total="${#PACKAGES[@]}"
    for (( i=0; i<${total}; i++ )); do
        if ! check_package "${PACKAGE[$i]}" ; then
            print_warning "TEST-INSTALL-WARN-1" "${PACKAGE[$i]}"
        fi
    done
    print_info "TEST-INSTALL-INFO-2"    
    local -i total="${#AUR_PACKAGES[@]}"
    for (( i=0; i<${total}; i++ )); do
        if ! check_package "${AUR_PACKAGE[$i]}" ; then
            print_warning "TEST-INSTALL-WARN-2" "${AUR_PACKAGE[$i]}"
        fi
    done
    pause_function "test_install @ $(basename $BASH_SOURCE) : $LINENO"
}
#}}}
# *******************************************************************************************************************************
# INSTALL SOFTWARE LIVE }}}
NAME="install_software_live"
USAGE="install_software_live"
DESCRIPTION="Install Software on Live OS"
NOTES=$(localize "NONE")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-SOFTWARE-LIVE-DESC"  "Test functions out for Developers"
localize_info "INSTALL-SOFTWARE-LIVE-NOTES" "Put what ever code in there you want to Test."
#
localize_info "INSTALL-SOFTWARE-LIVE-TITLE"  "Arch Linux Software Installation"
localize_info "INSTALL-SOFTWARE-LIVE-INFO-1" "Configure Pacman Package Signing..."
localize_info "INSTALL-SOFTWARE-LIVE-INFO-2" "System Upgrade..."
localize_info "INSTALL-SOFTWARE-LIVE-INFO-3" "Configure AUR Helper..."
localize_info "INSTALL-SOFTWARE-LIVE-INFO-4" "Set host name..."
localize_info "INSTALL-SOFTWARE-LIVE-INFO-5" "Hostname is set: "
localize_info "INSTALL-SOFTWARE-LIVE-INFO-6" "Hostname is not set!"
localize_info "INSTALL-SOFTWARE-LIVE-INFO-7" "Configure TOR..."
localize_info "INSTALL-SOFTWARE-LIVE-INFO-8" "Configure KDE..."
localize_info "INSTALL-SOFTWARE-LIVE-INFO-9" "Configure SSH..."
localize_info "INSTALL-SOFTWARE-LIVE-INFO-10" "Configure XORG..."
localize_info "INSTALL-SOFTWARE-LIVE-INFO-11" "Fontconfig is a library designed to provide a list of available fonts to applications, and also for configuration for how fonts get rendered."
localize_info "INSTALL-SOFTWARE-LIVE-INFO-12" "Enter your new postgres account password:"
localize_info "INSTALL-SOFTWARE-LIVE-INFO-13" "Enter your postgres account password:"
localize_info "INSTALL-SOFTWARE-LIVE-INFO-14" "Clean Orphan Packages..."
localize_info "INSTALL-SOFTWARE-WARN"         "You must run this in Live Mode!"
localize_info "INSTALL-SOFTWARE-WARN-2"       "Configuration did not get Loaded, make sure to run load_software or load_last_config"
# -------------------------------------
install_software_live()
{
    verify_config 2
    if [[ "$MOUNTPOINT" == "/mnt" ]]; then
        print_warning "INSTALL-SOFTWARE-WARN"
        exit 1
    fi
    if [[ "$IS_LAST_CONFIG_LOADED" -eq 0 ]]; then
        print_warning "INSTALL-SOFTWARE-WARN-2"
        exit 1
    fi
    print_title "INSTALL-SOFTWARE-LIVE-TITLE" ' - https://wiki.archlinux.org/index.php/Beginners%27_Guide#Boot_Arch_Linux_Installation_Media'
    print_info "INSTALL-SOFTWARE-LIVE-INFO-1"
    configure_pacman_package_signing
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "install_software_live: configure_pacman_package_signing @ $(basename $BASH_SOURCE) : $LINENO"; fi
    print_info "INSTALL-SOFTWARE-LIVE-INFO-2"
    system_upgrade
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "install_software_live: system_upgrade @ $(basename $BASH_SOURCE) : $LINENO"; fi
    print_info "INSTALL-SOFTWARE-LIVE-INFO-3"
    configure_aur_helper
    # MAKE SURE these are set: $CONFIG_HOSTNAME $USERNAME
    print_info "INSTALL-SOFTWARE-LIVE-INFO-4"
    hostnamectl set-hostname "$CONFIG_HOSTNAME"
    if [[ "$CONFIG_HOSTNAME" == `hostname` ]]; then
        HN=`hostname`
        print_info "INSTALL-SOFTWARE-LIVE-INFO-5" " ${HN}"
    else
        print_info "INSTALL-SOFTWARE-LIVE-INFO-6"
    fi
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "install_software_live: CONFIG_HOSTNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    #
    # Install PACKMANAGER
    if [[ "${#PACKMANAGER}" -ne 0 ]]; then
        print_info "Install PACKAGEMANAGER..."
        total="${#PACKMANAGER[@]}"
        for (( index=0; index<${total}; index++ )); do
            # @FIX test return logic; 0 = success; 
            eval "${PACKMANAGER[$index]}"
            if [ "$?" -eq 0 ]; then
                write_log "${PACKMANAGER_NAME[$index]} - ${PACKMANAGER[$index]}" "$(basename $BASH_SOURCE) : $LINENO"
            else
                write_error "${PACKMANAGER_NAME[$index]} - ${PACKMANAGER[$index]}" "$(basename $BASH_SOURCE) : $LINENO"
                if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "install_software_live: eval PACKMANAGER at line $(basename $BASH_SOURCE) : $LINENO (line by line errors)"; fi
            fi
        done
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "install_software_live: eval PACKMANAGER at line @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    #
    # FLESH
    if [[ "$FLESH" -eq 1 ]]; then
        configure_user_account
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "install_software_live: configure_user_account @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    # TOR
    if [[ "$CONFIG_TOR" -eq 1 ]]; then
        print_info "INSTALL-SOFTWARE-LIVE-INFO-7"
        if [ ! -f /usr/bin/proxy-wrapper ]; then
            echo 'forward-socks5   /               127.0.0.1:9050 .' >> /etc/privoxy/config
            echo -e '#!/bin/bash\nnc.openbsd -xlocalhost:9050 -X5 $*' > /usr/bin/proxy-wrapper
            chmod +x /usr/bin/proxy-wrapper
            echo -e '\nexport GIT_PROXY_COMMAND="/usr/bin/proxy-wrapper"' >> /etc/bash.bashrc
            export GIT_PROXY_COMMAND="/usr/bin/proxy-wrapper"
            su - "$USERNAME" -c 'export GIT_PROXY_COMMAND="/usr/bin/proxy-wrapper"'
        fi
        groupadd -g 42 privoxy
        useradd -u 42 -g privoxy -s /bin/false -d /etc/privoxy privoxy
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "install_software_live: CONFIG_TOR @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    # KDE
    if [[ "$CONFIG_KDE" -eq 1 ]]; then
        print_info "INSTALL-SOFTWARE-LIVE-INFO-8"
        # @FIX function to do curl to log it
        curl -o Sweet.tar.gz http://kde-look.org/CONTENT/content-files/144205-Sweet.tar.gz
        curl -o Kawai.tar.gz http://kde-look.org/CONTENT/content-files/141920-Kawai.tar.gz
        tar zxvf Sweet.tar.gz
        tar zxvf Kawai.tar.gz
        rm Sweet.tar.gz
        rm Kawai.tar.gz
        make_dir "/home/$USERNAME/.kde4/share/apps/color-schemes" "$(basename $BASH_SOURCE) : $LINENO"
        mv Sweet/Sweet.colors "/home/$USERNAME/.kde4/share/apps/color-schemes"
        mv Kawai/Kawai.colors "/home/$USERNAME/.kde4/share/apps/color-schemes"
        make_dir "/home/$USERNAME/.kde4/share/apps/QtCurve" "$(basename $BASH_SOURCE) : $LINENO"
        mv Sweet/Sweet.qtcurve "/home/$USERNAME/.kde4/share/apps/QtCurve"
        mv Kawai/Kawai.qtcurve "/home/$USERNAME/.kde4/share/apps/QtCurve"
        chown -R "${USERNAME}:$USERNAME" "/home/$USERNAME/.kde4"
        rm -fr Kawai Sweet
        #
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "install_software_live: CONFIG_KDE @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    # SSH
    if [[ "$CONFIG_SSH" -eq 1 ]]; then
        print_info "INSTALL-SOFTWARE-LIVE-INFO-9"
        [[ ! -f /etc/ssh/sshd_config.aui ]] && copy_file "/etc/ssh/sshd_config" "/etc/ssh/sshd_config.aui" "$(basename $BASH_SOURCE) : $LINENO";
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
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "install_software_live: CONFIG_SSH @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    #
    # Configure XORG
    if [[ "$CONFIG_XORG" -eq 1 ]]; then
        print_info "INSTALL-SOFTWARE-LIVE-INFO-10"
        if [[ "$LANGUAGE" == "de_DE" || "$LANGUAGE" == "es_ES" || "$LANGUAGE" == "es_CL" || "$LANGUAGE" == "it_IT" || "$LANGUAGE" == "fr_FR" || "$LANGUAGE" == "pt_BR" || "$LANGUAGE" == "pt_PT" ]]; then
            [[ ! -f /etc/X11/xorg.conf.d/10-evdev.conf.aui ]] && copy_file "/etc/X11/xorg.conf.d/10-evdev.conf" "/etc/X11/xorg.conf.d/10-evdev.conf.aui" "$(basename $BASH_SOURCE) : $LINENO";
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
            if [[ "$patch" != *"XkbLayout"* ]]; then
                if [[ "$keymap" == "us-acentos" ]]; then
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
        print_info "INSTALL-SOFTWARE-LIVE-INFO-11"
        cd /etc/fonts/conf.d
        ln -sv ../conf.avail/10-sub-pixel-rgb.conf
        #ln -sv ../conf.avail/10-autohint.conf
        ln -sv ../conf.avail/11-lcdfilter-default.conf
        ln -s ../conf.avail/70-no-bitmaps.conf
        cd "$SCRIPT_DIR"
        #
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "install_software_live: CONFIG_XORG @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    # @FIX
    if [[ "$WEBSERVER" -eq 1 ]]; then    
        #echo "Enter your new mysql root account password"
        #/usr/bin/mysqladmin -u root password
        /usr/bin/mysql_secure_installation
        # CONFIGURE HTTPD.CONF {{{
        if [ ! -f  /etc/httpd/conf/httpd.conf.aui ]; then
            cp -v /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.aui
            echo -e '\n# adminer configuration\nInclude conf/extra/httpd-adminer.conf' >> /etc/httpd/conf/httpd.conf
            echo -e 'application/x-httpd-php5		php php5' >> /etc/httpd/conf/mime.types
            sed -i '/LoadModule dir_module modules\/mod_dir.so/a\LoadModule php5_module modules\/libphp5.so' /etc/httpd/conf/httpd.conf
            echo -e '\n# Use for PHP 5.x:\nInclude conf/extra/php5_module.conf\n\nAddHandler php5-script php' >> /etc/httpd/conf/httpd.conf
            sed -i 's/DirectoryIndex\ index.html/DirectoryIndex\ index.html\ index.php/g' /etc/httpd/conf/httpd.conf
        fi
        #}}}
        # CONFIGURE PHP.INI {{{
        if [ -f  /etc/php/php.ini.pacnew ]; then
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
    fi
    # @FIX
    if [[ "$WEBSERVER" -eq 2 ]]; then    
        chown -R postgres:postgres /var/lib/postgres/
        print_info "INSTALL-SOFTWARE-LIVE-INFO-12"
        passwd postgres
        if [ ! -d /var/lib/postgres/data ]; then
            print_info "INSTALL-SOFTWARE-LIVE-INFO-13"
            su - postgres -c "initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'"
        fi
        sed -i '/PGROOT/s/^#//' /etc/conf.d/postgresql
        add_packagemanager "systemctl enable httpd.service postgresql.service" "SYSTEMD-ENABLE-WEBSERVER-2"
        add_packagemanager "systemctl start postgresql.service" "SYSTEMD-START-POSTGRESQL"
        # CONFIGURE HTTPD.CONF {{{
        if [ ! -f  /etc/httpd/conf/httpd.conf.aui ]; then
            cp -v /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.aui
            echo -e '\n# adminer configuration\nInclude conf/extra/httpd-adminer.conf' >> /etc/httpd/conf/httpd.conf
            echo -e 'application/x-httpd-php5		php php5' >> /etc/httpd/conf/mime.types
            sed -i '/LoadModule dir_module modules\/mod_dir.so/a\LoadModule php5_module modules\/libphp5.so' /etc/httpd/conf/httpd.conf
            echo -e '\n# Use for PHP 5.x:\nInclude conf/extra/php5_module.conf\n\nAddHandler php5-script php' >> /etc/httpd/conf/httpd.conf
            sed -i 's/DirectoryIndex\ index.html/DirectoryIndex\ index.html\ index.php/g' /etc/httpd/conf/httpd.conf
        fi
        #}}}
        # CONFIGURE PHP.INI {{{
        if [ -f  /etc/php/php.ini.pacnew ]; then
            mv -v /etc/php/php.ini /etc/php/php.ini.pacold
            mv -v /etc/php/php.ini.pacnew /etc/php/php.ini
            rm -v /etc/php/php.ini.aui
        fi
        [[ -f /etc/php/php.ini.aui ]] && echo "/etc/php/php.ini.aui || cp -v /etc/php/php.ini /etc/php/php.ini.aui";
        sed -i '/pgsql.so/s/^;//' /etc/php/php.ini
        sed -i '/mcrypt.so/s/^;//' /etc/php/php.ini
        sed -i '/gd.so/s/^;//' /etc/php/php.ini
        sed -i '/display_errors=/s/off/on/' /etc/php/php.ini
        # }}}
        CURRENT_STATUS=1
        create_sites_folder
    fi
    #   
    # Clean Orphan Packages
    if [[ "$CONFIG_ORPHAN" -eq 1 ]]; then
        print_info "INSTALL-SOFTWARE-LIVE-INFO-14"
        pacman -Rsc --noconfirm $(pacman -Qqdt)
        #pacman -Sc --noconfirm
        pacman-optimize
        #
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "install_software_live: CONFIG_ORPHAN @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    test_install
    #
    finish 2
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL LOAD SOFTWARE }}}
NAME="install_loaded_software"
USAGE="install_loaded_software"
DESCRIPTION=$(localize "INSTALL-LOAD-SOFTWARE-DESC")
NOTES=$(localize "INSTALL-LOAD-SOFTWARE-NOTES")
AUTHOR="Flesher"
VERSION="1.0"
CREATED="11 SEP 2012"
REVISION="5 Dec 2012"
create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
# Help file Localization
localize_info "INSTALL-LOAD-SOFTWARE-DESC"  "Install loaded Software"
localize_info "INSTALL-LOAD-SOFTWARE-NOTES" "None."
#
localize_info "INSTALL-LOAD-SOFTWARE-TITLE-1" "Install Software from Configuration files, Assumes you are in Live Mode, meaning you booted into your Live OS, not an installatoin disk."
localize_info "INSTALL-LOAD-SOFTWARE-INFO-1" "Install Software from Configuration files, Assumes you are in Live Mode, meaning you booted into your Live OS, not an installatoin disk."
localize_info "INSTALL-LOAD-SOFTWARE-INFO-2" "This option Assumes that you have a bootable OS and and have gone through the Application Software Menu and Saved it, now we are going to load it and install it."
localize_info "INSTALL-LOAD-SOFTWARE-INFO-3" "Normally you will use the user name (&#36;USERNAME) in the file, but its possible that you may wish to use another User Name to install this with, make sure User Name Exist in this OS before doing this."
localize_info "INSTALL-LOAD-SOFTWARE-INFO-4" "You will have to abort (Ctrl-C) if you wish to change Software Installation Setting, pick New Software Configuration."
localize_info "INSTALL-LOAD-SOFTWARE-INFO-5" "Load Last Install."
# -------------------------------------
install_loaded_software()
{
    print_title "INSTALL-LOAD-SOFTWARE-TITLE-1"
    print_info "$TEXT_SCRIPT_ID"
    #
    verify_config 2
    # Live mode only
    if [[ "$MOUNTPOINT" == "/mnt" ]]; then
        print_warning "Live mode only!"
        exit 1
    fi
    #
    if [[ "$IS_SOFTWARE_CONFIG_LOADED" -eq 0 ]]; then            
        print_warning "No Software Configuration files found!, run option -i and Save Configuration."
        pause_function "$(basename $BASH_SOURCE) : $LINENO"
        exit 0
    fi
    print_info "$TEXT_SCRIPT_ID"
    print_info "INSTALL-LOAD-SOFTWARE-INFO-1"
    print_info "INSTALL-LOAD-SOFTWARE-INFO-2"
    print_info "INSTALL-LOAD-SOFTWARE-INFO-3"
    print_info "INSTALL-LOAD-SOFTWARE-INFO-4"
    #echo "Copying over all Configuration files to Live OS."
    #copy_dir "$SCRIPT_DIR/etc/" "/" "$(basename $BASH_SOURCE) : $LINENO"
    
    #print_info "Create Custom AUR Repository..."
    #create_custom_aur_repo # @FIX still can not get this to work
    
    print_info "INSTALL-LOAD-SOFTWARE-INFO-5"
    install_software_live
    finish 2
}
#{{{
# ****** END OF SCRIPT ******

