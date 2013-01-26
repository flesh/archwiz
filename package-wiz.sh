#!/bin/bash
#
# LAST_UPDATE="25 Jan 2013 16:33"
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
# INSTALL MAIN {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_main_menu"
    USAGE="install_main_menu"
    DESCRIPTION=$(localize "INSTALL-MAIN-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-MAIN-DESC"  "Install Menu"
    localize_info "INSTALL-MAIN-NOTES" "NONE"
    #
    localize_info "INSTALL-MAIN-TITLE" "Arch Wizard Main Menu"
    #
    localize_info "INSTALL-MAIN-MENU-SAVE" "Save Software Configuration for later use" 
    localize_info "INSTALL-MAIN-COMPLETED" "Completed"
    localize_info "INSTALL-MAIN-INSTALLED" "Installed"
    localize_info "INSTALL-MAIN-REMOVED"   "Removed"
    localize_info "INSTALL-MAIN-REC"       "Recommended Options"
    #
    localize_info "INSTALL-MAIN-MENU-1"    "Wizard"
    localize_info "INSTALL-MAIN-MENU-I-1"        "Wizard: Install packages via a Wizard."
    localize_info "INSTALL-MAIN-MENU-2"    "Basic Setup"
    localize_info "INSTALL-MAIN-MENU-I-2"        "Basic Setup: Required: SYSTEMD, Video Card, Network, DBUS, AVAHI, ACPI, ALSA, (UN)COMPRESS TOOLS, NFS, SAMBA, XORG, CUPS, SSH and more."
    localize_info "INSTALL-MAIN-MENU-3"    "Desktop Environment"
    localize_info "INSTALL-MAIN-MENU-I-3"        "Desktop Environment: Mate, Razor-Qt, KDE, XFCE, Awesome, Cinnamon, E17, LXDE, OpenBox, GNOME and even Unity."
    localize_info "INSTALL-MAIN-MENU-4"    "Display Manager"
    localize_info "INSTALL-MAIN-MENU-I-4"        "Display Manager: GDM, Elsa, LightDM, LXDM and Slim."
    localize_info "INSTALL-MAIN-MENU-5"    "Accessories Apps"
    localize_info "INSTALL-MAIN-MENU-I-5"       "Accessories Apps: cairo-dock-bzr, Conky, deepin-scrot, dockbarx, speedcrunch, galculator, gnome-pie, guake, kupfer, pyrenamer, shutter, synapse, terminator, zim, Revelation."
    localize_info "INSTALL-MAIN-MENU-6"    "Development Apps"
    localize_info "INSTALL-MAIN-MENU-I-6"       "Development Apps: Qt and Creator, Wt, Aptana-Studio, Bluefish, Eclipse, Emacs, Gvim, Geany, IntelliJ IDEA, DDevelop, Oracle Java, Sublime Text 2, Debugger Tools, PostgreSQL, MySQL Workbench, Meld, RabbitVCS, Astyle and Putty."
    localize_info "INSTALL-MAIN-MENU-7"    "Office Apps"
    localize_info "INSTALL-MAIN-MENU-I-7"       "Office Apps: Libre Office, Calligra (KOffice Suite Replacement) or Abiword + Gnumeric, latex, calibre, gcstar, homebank, impressive, nitrotasks, ocrfeeder, xmind and zathura."
    localize_info "INSTALL-MAIN-MENU-8"    "System Apps"
    localize_info "INSTALL-MAIN-MENU-I-8"       "System Apps: Gparted, Grsync, Htop, Virtualbox, Webmin, WINE"
    localize_info "INSTALL-MAIN-MENU-9"    "Internet Apps"
    localize_info "INSTALL-MAIN-MENU-I-9"       "Internet Apps: Browsers, Download / Fileshare, Email / RSS, Instant Messaging, Internet Relay Chat, Mapping Tools, VNC / Desktop Share"
    localize_info "INSTALL-MAIN-MENU-10"   "Graphics Apps"
    localize_info "INSTALL-MAIN-MENU-I-10"      "Graphics Apps: Blender, Handbrake, CD/DVD Burners, Gimp, Gthumb, Inkscape, Mcomix, MyPaint, Scribus, Shotwell, Simple-scan, Xnviewmp, Qt Image Viewers, Qt Image Editors"
    localize_info "INSTALL-MAIN-MENU-11"   "Audio Apps"
    localize_info "INSTALL-MAIN-MENU-I-11"      "Audio Apps: Players, Editors / Tools, Codecs"
    localize_info "INSTALL-MAIN-MENU-12"   "Video Apps"
    localize_info "INSTALL-MAIN-MENU-I-12"      "Video Apps: Players, Editors / Tools, Codecs"
    localize_info "INSTALL-MAIN-MENU-13"   "Games"
    localize_info "INSTALL-MAIN-MENU-I-13"      "Games: Sub Menu... too many Games to Mention."
    localize_info "INSTALL-MAIN-MENU-14"   "Science"
    localize_info "INSTALL-MAIN-MENU-I-14"      "Science and Education: ${INSTALL_SCIENCE_EDUCATION}."
    localize_info "INSTALL-MAIN-MENU-15"   "Web Server"
    localize_info "INSTALL-MAIN-MENU-I-15"      "Web Server: Apache, Tools, Databases: PostgreSQL or MySQL."
    localize_info "INSTALL-MAIN-MENU-16"   "Fonts"
    localize_info "INSTALL-MAIN-MENU-I-16"      "Fonts: Sub Menu of many Fonts Available."
    localize_info "INSTALL-MAIN-MENU-17"   "Extra"
    localize_info "INSTALL-MAIN-MENU-I-17"      "Extra: Elementary Project, Yapan"
    localize_info "INSTALL-MAIN-MENU-18"   "Kernel"
    localize_info "INSTALL-MAIN-MENU-I-18"      "Install Optional Kernals: Liquorix, LTS, ZEN."
    localize_info "INSTALL-MAIN-MENU-19"   "Clean Orphan Packages"
    localize_info "INSTALL-MAIN-MENU-I-19"      "Clean Orphan Packages:"
    localize_info "INSTALL-MAIN-MENU-20"   "Edit Configuration"
    localize_info "INSTALL-MAIN-MENU-I-20"      "Edit Configuration: Loads Saved Software."
    localize_info "INSTALL-MAIN-MENU-21"   "Load Custom Software"
    localize_info "INSTALL-MAIN-MENU-I-21"      "Load Custom Software; Not yet written."
    localize_info "INSTALL-MAIN-MENU-22"   "Load Software"
    localize_info "INSTALL-MAIN-MENU-I-22"      "Allows you to review and edit configuration variables before installing software."
    localize_info "INSTALL-MAIN-MENU-23"   "Save Software"
    localize_info "INSTALL-MAIN-MENU-I-23"      "Save Software: Saves and Installs list and configurations creates with this menu."
    localize_info "INSTALL-MAIN-MENU-24"   "Quit"
    localize_info "INSTALL-MAIN-MENU-I-24"      "Quit Menu: If in Boot mode will run pacstrap, if in software mode will install Software."
    localize_info "INSTALL-MAIN-MENU-24-L" "Save and Install Software"
    localize_info "INSTALL-MAIN-MENU-I-24-L"    "Save and Install Software."
fi
# -------------------------------------
install_main_menu()
{
    local -r menu_name="Install-Menu"  # You must define Menu Name here
    local BreakableKey="Q"             # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MAIN-REC"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-MAIN-TITLE" " - https://github.com/flesh/archwiz"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-1"  "" "" "INSTALL-MAIN-MENU-I-1"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-2"  "" "" "INSTALL-MAIN-MENU-I-2"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-3"  "" "" "INSTALL-MAIN-MENU-I-3"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-4"  "" "" "INSTALL-MAIN-MENU-I-4"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-5"  "" "" "INSTALL-MAIN-MENU-I-5"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-6"  "" "" "INSTALL-MAIN-MENU-I-6"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-7"  "" "" "INSTALL-MAIN-MENU-I-7"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-8"  "" "" "INSTALL-MAIN-MENU-I-8"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-9"  "" "" "INSTALL-MAIN-MENU-I-9"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-10" "" "" "INSTALL-MAIN-MENU-I-10" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-11" "" "" "INSTALL-MAIN-MENU-I-11" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-12" "" "" "INSTALL-MAIN-MENU-I-12" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-13" "" "" "INSTALL-MAIN-MENU-I-13" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-14" "" "" "INSTALL-MAIN-MENU-I-14" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-15" "" "" "INSTALL-MAIN-MENU-I-15" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-16" "" "" "INSTALL-MAIN-MENU-I-16" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-17" "" "" "INSTALL-MAIN-MENU-I-17" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-18" "" "" "INSTALL-MAIN-MENU-I-18" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-19" "" "" "INSTALL-MAIN-MENU-I-19" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-20" "" "" "INSTALL-MAIN-MENU-I-20" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-21" "" "" "INSTALL-MAIN-MENU-I-21" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-22" "" "" "INSTALL-MAIN-MENU-I-22" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-23" "" "" "INSTALL-MAIN-MENU-I-23" "MenuTheme[@]"
        if [[ "$MOUNTPOINT" == " " ]]; then
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-24-L" "" "" "INSTALL-MAIN-MENU-I-24-L" "MenuTheme[@]"
        else
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAIN-MENU-24"   "" "" "INSTALL-MAIN-MENU-I-24"   "MenuTheme[@]"
        fi
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        BYPASS="$Old_BYPASS" # Restore Bypass
        #
        local OPT
        for OPT in ${OPTIONS[@]}; do
            case "$OPT" in
                1)  # Wizard
                    run_install_wizzard
                    StatusBar1="INSTALL-MAIN-MENU-1"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "INSTALL-MAIN-COMPLETED"
                    exit 0
                    ;;
                2)  # Basic Setup with Add and Remove
                    if [[ "${MenuChecks[$((OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((OPT - 1))]=1
                        install_basic 1
                        StatusBar1="INSTALL-MAIN-MENU-2"
                        StatusBar2=$(localize "INSTALL-MAIN-INSTALLED")
                    else
                        MenuChecks[$((OPT - 1))]=2
                        install_basic 2
                        StatusBar1="INSTALL-MAIN-MENU-2"
                        StatusBar2=$(localize "INSTALL-MAIN-REMOVED")
                    fi
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Desktop Environment
                    MenuChecks[$((OPT - 1))]=1
                    install_desktop_environment_menu 0
                    StatusBar1="INSTALL-MAIN-MENU-3"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Display Manager
                    MenuChecks[$((OPT - 1))]=1
                    install_display_manager_menu
                    StatusBar1="INSTALL-MAIN-MENU-4"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Accessories Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_accessories_apps_menu    
                    StatusBar1="INSTALL-MAIN-MENU-5"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Development Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_development_apps_menu    
                    StatusBar1="INSTALL-MAIN-MENU-6"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # Office Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_office_apps_menu         
                    StatusBar1="INSTALL-MAIN-MENU-7"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # System Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_system_apps_menu
                    StatusBar1="INSTALL-MAIN-MENU-8"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # Internet Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_internet_apps_menu
                    StatusBar1="INSTALL-MAIN-MENU-10"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               10)  # Graphics Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_graphics_apps_menu
                    StatusBar1="INSTALL-MAIN-MENU-9"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               11)  # Audio Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_audio_apps_menu
                    StatusBar1="INSTALL-MAIN-MENU-11"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               12)  # Video Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_video_apps_menu
                    StatusBar1="INSTALL-MAIN-MENU-12"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               13)  # Games
                    MenuChecks[$((OPT - 1))]=1
                    install_games_menu
                    StatusBar1="INSTALL-MAIN-MENU-13"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               14)  # Science
                    MenuChecks[$((OPT - 1))]=1
                    install_science
                    StatusBar1="INSTALL-MAIN-MENU-14"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               15)  # Web server
                    MenuChecks[$((OPT - 1))]=1
                    install_web_server_menu
                    StatusBar1="INSTALL-MAIN-MENU-15"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               16)  # Fonts
                    MenuChecks[$((OPT - 1))]=1
                    install_fonts_menu
                    StatusBar1="INSTALL-MAIN-MENU-16"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               17)  # Extra
                    MenuChecks[$((OPT - 1))]=1
                    install_extra_menu
                    StatusBar1="INSTALL-MAIN-MENU-17"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               18)  # Kernel
                    MenuChecks[$((OPT - 1))]=1
                    install_kernel_menu
                    StatusBar1="INSTALL-MAIN-MENU-18"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               19)  # Clean Orphan Packages
                    MenuChecks[$((OPT - 1))]=1
                    clean_orphan_packages
                    StatusBar1="INSTALL-MAIN-MENU-19"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               20)  # Edit Configuration
                    MenuChecks[$((OPT - 1))]=1
                    get_hostname
                    configure_timezone
                    get_user_name
                    add_custom_repositories
                    StatusBar1="INSTALL-MAIN-MENU-20"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               21)  # Load Custom Software
                    MenuChecks[$((OPT - 1))]=1
                    # load_custom_software
                    StatusBar1="INSTALL-MAIN-MENU-21"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               22)  # Load Software
                    MenuChecks[$((OPT - 1))]=1
                    load_software # @FIX
                    StatusBar1="INSTALL-MAIN-MENU-22"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               23)  # Save Software
                    MenuChecks[$((OPT - 1))]=1
                    save_software
                    SAVED_SOFTWARE=1
                    StatusBar1="INSTALL-MAIN-MENU-23"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               24)  # Quit or Save and Install Software
                    MenuChecks[$((OPT - 1))]=1
                    OPT="$BreakableKey"
                    if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                        SAVED_MAIN_MENU=1
                    fi
                    save_software
                    SAVED_SOFTWARE=1
                    if [[ "$MOUNTPOINT" == " " ]]; then
                        install_software_live; exit 0; # Calls finish 2, call exit 0
                    fi
                    StatusBar1="INSTALL-MAIN-MENU-24"
                    StatusBar2=$(localize "INSTALL-MAIN-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                *)  # Catch ALL 
                    if [[ "$OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        save_software
                        SAVED_SOFTWARE=1
                        if [[ "$MOUNTPOINT" == " " ]]; then
                            install_software_live; exit 0; # Calls finish 2, call exit 0
                        fi
                    else
                        invalid_option "$OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL WIZARD MENU {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="run_install_wizzard"
    USAGE=$(localize "INSTALL-WIZARD-MENU-USAGE")
    DESCRIPTION=$(localize "INSTALL-WIZARD-MENU-DESC")
    NOTES=$(localize "INSTALL-WIZARD-MENU-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="15 Jan 2013"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-WIZARD-MENU-USAGE" "run_install_wizzard"
    localize_info "INSTALL-WIZARD-MENU-DESC"  "Install Wizard Now will Launch the Script in Wizard Mode."
    localize_info "INSTALL-WIZARD-MENU-NOTES" "NONE"
    #
    localize_info "INSTALL-WIZARD-MENU-BASIC" "Reconfigure Basic Setup"
fi
# -------------------------------------
run_install_wizzard()
{
    install_type_menu
    local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
    read_input_yn "INSTALL-WIZARD-MENU-BASIC" " " 1 # 
    BYPASS="$Old_BYPASS" # Restore Bypass
    if [[ "$YN_OPTION" -eq 1 ]]; then
        INSTALL_NFS=0
        INSTALL_SAMBA=0
        INSTALL_LMT=0
        INSTALL_PRELOAD=0
        INSTALL_ZRAM=0
        INSTALL_TOR=0
        INSTALL_CUPS=0
        INSTALL_USB_MODEM=0
        INSTALL_FIRMWARE=0
        INSTALLED_VIDEO_CARD=0 # Same as VIDEO_CARD=7
        install_basics_menu
    fi
    install_custom_de_menu
    SHOW_PAUSE=0
    INSTALL_WIZARD=1
    install_basic 1 # make sure INSTALL_WIZARD=1
    INSTALL_WIZARD=0
    install_desktop_environment_menu 1
    INSTALL_WIZARD=0
    install_display_manager_menu
    INSTALL_WIZARD=1
    # 0=Normal, 1=Gamer, 2=Professional and 3=Programmer
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then # Normal
        install_accessories_apps_menu    
        install_office_apps_menu         
        install_system_apps_menu
        install_internet_apps_menu
        install_graphics_apps_menu
        install_audio_apps_menu
        install_video_apps_menu
        install_science
        install_fonts_menu
        install_extra_menu
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        install_accessories_apps_menu    
        install_office_apps_menu         
        install_system_apps_menu
        install_internet_apps_menu
        install_graphics_apps_menu
        install_audio_apps_menu
        install_video_apps_menu
        install_science
        install_fonts_menu
        install_extra_menu
        install_kernel_menu
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        install_accessories_apps_menu    
        install_office_apps_menu         
        install_system_apps_menu
        install_internet_apps_menu
        install_graphics_apps_menu
        install_audio_apps_menu
        install_video_apps_menu
        install_science
        install_fonts_menu
        install_extra_menu
        install_kernel_menu
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        install_accessories_apps_menu    
        install_development_apps_menu    
        install_office_apps_menu         
        install_system_apps_menu
        install_internet_apps_menu
        install_graphics_apps_menu
        install_audio_apps_menu
        install_video_apps_menu
        install_science
        install_web_server_menu
        install_fonts_menu
        install_extra_menu
        install_kernel_menu
    fi
    save_software    
    SAVED_SOFTWARE=1
    if [[ "$DETECTED_RUN_MODE" -eq 1 ]]; then
        FAST_INSTALL=1
        BOOT_MODE=1
        # Assume Boot mode
        verify_config "$DETECTED_RUN_MODE"
        start_screen # Calls setup_os which calls finish 1
        exit 0
    else
        install_software_live # Calls finish 2, call exit 0
        exit 0 
    fi
    exit 0
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL TYPE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_type_menu"
    USAGE="install_type_menu"
    DESCRIPTION=$(localize "INSTALL-TYPE-DESC")
    NOTES=$(localize "INSTALL-TYPE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-TYPE-DESC"   "Install Type Menu: "
    localize_info "INSTALL-TYPE-NOTES"  "NONE"
    localize_info "INSTALL-TYPE-TITLE"  "Type of Installation:"
    #
    localize_info "INSTALL-TYPE-MENU-1"   "Normal"
    localize_info "INSTALL-TYPE-MENU-I-1"       "Normal: Minimal well rounded Applications."
    localize_info "INSTALL-TYPE-MENU-2"   "Gamer"
    localize_info "INSTALL-TYPE-MENU-I-2"       "Gamer: Normal plus a lot of Games."
    localize_info "INSTALL-TYPE-MENU-3"   "Professional"
    localize_info "INSTALL-TYPE-MENU-I-3"       "Professional: Normal plus Video and Audio Applications."
    localize_info "INSTALL-TYPE-MENU-4"   "Programmer"
    localize_info "INSTALL-TYPE-MENU-I-4"       "Programmer: Professional plus some important Programming Applications."
    # 0=Normal, 1=Gamer, 2=Professional and 3=Programmer
fi
# -------------------------------------
install_type_menu()
{
    local -r menu_name="INSTALL-TYPE"  # You must define Menu Name here
    local BreakableKey="D"             # Q=Quit, D=Done, B=Back
    local RecommendedOptions="3"       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-TYPE-TITLE" 
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-1" "" "" "INSTALL-TYPE-MENU-I-1" "MenuTheme[@]" # Normal
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-2" "" "" "INSTALL-TYPE-MENU-I-2" "MenuTheme[@]" # Gamer
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-3" "" "" "INSTALL-TYPE-MENU-I-3" "MenuTheme[@]" # Professional
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-4" "" "" "INSTALL-TYPE-MENU-I-4" "MenuTheme[@]" # Programmer
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        BYPASS="$Old_BYPASS" # Restore Bypass
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Normal
                    MenuChecks[$((S_OPT - 1))]=1
                    INSTALL_TYPE=0
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-TYPE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                2)  # Gamer
                    MenuChecks[$((S_OPT - 1))]=1
                    INSTALL_TYPE=1
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-TYPE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                3)  # Professional 
                    MenuChecks[$((S_OPT - 1))]=1
                    S_OPT="$BreakableKey"
                    INSTALL_TYPE=2
                    # Progress Status
                    StatusBar1="INSTALL-TYPE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                4)  # Programmer
                    MenuChecks[$((S_OPT - 1))]=1
                    INSTALL_TYPE=3
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-TYPE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                *)  # Catch ALL 
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL CUSTOM DE MENU {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_custom_de_menu"
    USAGE="install_custom_de_menu"
    DESCRIPTION=$(localize "INSTALL-CUSTOM-DE-DESC")
    NOTES=$(localize "INSTALL-CUSTOM-DE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="19 Jan 2013"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-CUSTOM-DE-DESC"   "Install Custom Desktop Menu: "
    localize_info "INSTALL-CUSTOM-DE-NOTES"  "NONE"
    localize_info "INSTALL-CUSTOM-DE-TITLE"  "Custom Desktop Menu:"
    #
    localize_info "INSTALL-CUSTOM-DE-MENU-1"   "Mate"
    localize_info "INSTALL-CUSTOM-DE-MENU-I-1"      "Mate: The MATE Desktop Environment is a fork of GNOME 2 that aims to provide an attractive and intuitive desktop to Linux users using traditional metaphors"
    localize_info "INSTALL-CUSTOM-DE-MENU-2"   "KDE"
    localize_info "INSTALL-CUSTOM-DE-MENU-I-2"      "KDE: The KDE Software Compilation is the set of libraries, workspaces, and applications produced by KDE that share this common heritage, and continue to use the synchronized release cycle."
    localize_info "INSTALL-CUSTOM-DE-MENU-3"   "XFCE"
    localize_info "INSTALL-CUSTOM-DE-MENU-I-3"      "XFCE: Xfce embodies the traditional UNIX philosophy of modularity and re-usability."
    localize_info "INSTALL-CUSTOM-DE-MENU-4"   "Razor-QT & Openbox"
    localize_info "INSTALL-CUSTOM-DE-MENU-I-4"      "Razor-QT & Openbox: Razor-qt is an advanced, easy-to-use, and fast toolbox-like desktop environment, which is, like KDE, based on Qt technologies. Openbox is a lightweight and highly configurable window manager with extensive standards support."
    localize_info "INSTALL-CUSTOM-DE-MENU-5"   "Cinnamon"
    localize_info "INSTALL-CUSTOM-DE-MENU-I-5"      "Cinnamon: Cinnamon is a Linux desktop which provides advanced innovative features and a traditional user experience."
    localize_info "INSTALL-CUSTOM-DE-MENU-6"   "Awesome"
    localize_info "INSTALL-CUSTOM-DE-MENU-I-6"      "Awesome: awesome is a highly configurable, next generation framework window manager for X."
fi
# -------------------------------------
install_custom_de_menu()
{
    local -r menu_name="INSTALL-CUSTOM-DE"  # You must define Menu Name here
    local BreakableKey="D"                  # Q=Quit, D=Done, B=Back
    local RecommendedOptions="4"            # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-CUSTOM-DE-TITLE" 
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CUSTOM-DE-MENU-1" "" "" "INSTALL-CUSTOM-DE-MENU-I-1" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CUSTOM-DE-MENU-2" "" "" "INSTALL-CUSTOM-DE-MENU-I-2" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CUSTOM-DE-MENU-3" "" "" "INSTALL-CUSTOM-DE-MENU-I-3" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CUSTOM-DE-MENU-4" "" "" "INSTALL-CUSTOM-DE-MENU-I-4" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CUSTOM-DE-MENU-5" "" "" "INSTALL-CUSTOM-DE-MENU-I-5" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CUSTOM-DE-MENU-6" "" "" "INSTALL-CUSTOM-DE-MENU-I-6" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        BYPASS="$Old_BYPASS" # Restore Bypass
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Mate
                    MenuChecks[$((S_OPT - 1))]=1
                    CUSTOM_DE=1
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-CUSTOM-DE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                2)  # KDE
                    MenuChecks[$((S_OPT - 1))]=1
                    CUSTOM_DE=2
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-CUSTOM-DE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                3)  # XFCE 
                    MenuChecks[$((S_OPT - 1))]=1
                    S_OPT="$BreakableKey"
                    CUSTOM_DE=3
                    # Progress Status
                    StatusBar1="INSTALL-CUSTOM-DE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                4)  # Razor-QT & Openbox
                    MenuChecks[$((S_OPT - 1))]=1
                    S_OPT="$BreakableKey"
                    CUSTOM_DE=4
                    # Progress Status
                    StatusBar1="INSTALL-CUSTOM-DE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                5)  # Cinnamon 
                    MenuChecks[$((S_OPT - 1))]=1
                    S_OPT="$BreakableKey"
                    CUSTOM_DE=5
                    # Progress Status
                    StatusBar1="INSTALL-CUSTOM-DE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                6)  # Awesome
                    MenuChecks[$((S_OPT - 1))]=1
                    CUSTOM_DE=6
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-CUSTOM-DE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                *)  # Catch ALL 
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL BASICS MENU {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_basics_menu"
    USAGE="install_basics_menu"
    DESCRIPTION=$(localize "INSTALL-BASICS-MENU-DESC")
    NOTES=$(localize "INSTALL-BASICS-MENU-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="16 Jan 2013"
    REVISION="16 Jan 2013"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-BASICS-MENU-DESC"    "Install Basics Menu: Default Base Settings."
    localize_info "INSTALL-BASICS-MENU-NOTES"   "NONE"
    localize_info "INSTALL-BASICS-MENU-TITLE"   "Basic Installation"
    localize_info "INSTALL-BASICS-MENU-REC"     "Recommended Settings"
    localize_info "INSTALL-BASICS-MENU-DEFAULT" "Default"
    #
    localize_info "INSTALL-BASICS-MENU-1"    "NFS"
    localize_info "INSTALL-BASICS-MENU-I-1"      "NFS allowing a user on a client computer to access files over a network in a manner similar to how local storage is accessed."
    localize_info "INSTALL-BASICS-MENU-2"    "SAMBA"
    localize_info "INSTALL-BASICS-MENU-I-2"      "SAMBA: SAMBA is a re-implementation of the SMB/CIFS networking protocol, it facilitates file and printer sharing among Linux and Windows systems as an alternative to NFS. https://wiki.archlinux.org/index.php/Samba"
    localize_info "INSTALL-BASICS-MENU-3"    "Laptop Mode Tools"
    localize_info "INSTALL-BASICS-MENU-I-3"      "Laptop Mode Tools is a laptop power saving package for Linux systems. It is the primary way to enable the Laptop Mode feature of the Linux kernel, which lets your hard drive spin down. In addition, it allows you to tweak a number of other power-related settings using a simple configuration file. - https://wiki.archlinux.org/index.php/Laptop_Mode_Tools"
    localize_info "INSTALL-BASICS-MENU-4"    "Preload"
    localize_info "INSTALL-BASICS-MENU-I-4"      "Preload is a program which runs as a daemon and records statistics about usage of programs using Markov chains; files of more frequently-used programs are, during a computer's spare time, loaded into memory. This results in faster startup times as less data needs to be fetched from disk. preload is often paired with prelink. - https://wiki.archlinux.org/index.php/Preload"
    localize_info "INSTALL-BASICS-MENU-5"    "Zram"
    localize_info "INSTALL-BASICS-MENU-I-5"      "Zram creates a device in RAM and compresses it. If you use for swap means that part of the RAM can hold much more information but uses more CPU. Still, it is much quicker than swapping to a hard drive. If a system often falls back to swap, this could improve responsiveness. Zram is in mainline staging (therefore its not stable yet, use with caution). As a side note, check to see if you are even using the swap disk, more memory is a better option, but this is a good alternative if you keep hitting the swap disk. - https://wiki.archlinux.org/index.php/Maximizing_Performance"
    localize_info "INSTALL-BASICS-MENU-6"    "Tor"
    localize_info "INSTALL-BASICS-MENU-I-6"      "Tor is an open source implementation of 2nd generation onion routing that provides free access to an anonymous proxy network. Its primary goal is to enable online anonymity by protecting against traffic analysis attacks."
    localize_info "INSTALL-BASICS-MENU-7"    "CUPS"
    localize_info "INSTALL-BASICS-MENU-I-7"      "CUPS is the standards-based, open source printing system developed by Apple Inc. for Mac OS® X and other UNIX®-like operating systems."
    localize_info "INSTALL-BASICS-MENU-8"    "USB 3G MODEM"
    localize_info "INSTALL-BASICS-MENU-I-8"      "A number of mobile telephone networks around the world offer mobile internet connections over UMTS (or EDGE or GSM) using a portable USB modem device."
    localize_info "INSTALL-BASICS-MENU-9"    "Addition Firmwares"
    localize_info "INSTALL-BASICS-MENU-I-9"      "Install additional firmwares (Audio,Bluetooth,Scanner,Wireless) - alsa-firmware, ipw2100-fw, ipw2200-fw, b43-firmware, b43-firmware-legacy, broadcom-wl, zd1211-firmware, bluez-firmware, libffado, libraw1394, sane-gt68xx-firmware"
    localize_info "INSTALL-BASICS-MENU-10"   "AUR Helper"
    localize_info "INSTALL-BASICS-MENU-I-10"     "Change AUR Helper: yaourt, packer or pacaur"
    localize_info "INSTALL-BASICS-MENU-11"   "Network Managers"
    localize_info "INSTALL-BASICS-MENU-I-11"     "Network Managers: NetworkManager or WICD"
    localize_info "INSTALL-BASICS-MENU-12"   "Video Card"
    localize_info "INSTALL-BASICS-MENU-I-12"     "Select Video Card: nVidia, Nouveau, Intel, ATI, Vesa, Virtualbox"
fi
# -------------------------------------
install_basics_menu()
{
    local -r menu_name="INSTALL-BASICS-MENU"  # You must define Menu Name here
    local BreakableKey="D"                    # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 2 7 11 12"    # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    BASIC_INSTALL_VER=1  # Set in common-wiz.sh to 0; used to run this function; change if you need to run it agian
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 12 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    local -a MenuThemeWarn=( "${BRed}" "${White}" ")" )
    #
    if [[ "$INSTALL_NFS" -eq 1 ]]; then
        MenuChecks[0]=1                             # Check these, it means they are allready Installed
    fi
    if [[ "$INSTALL_SAMBA" -eq 1 ]]; then
        MenuChecks[1]=1
    fi
    if [[ "$INSTALL_LMT" -eq 1 ]]; then
        MenuChecks[2]=1
    fi
    if [[ "$INSTALL_PRELOAD" -eq 1 ]]; then
        MenuChecks[3]=1
    fi
    if [[ "$INSTALL_ZRAM" -eq 1 ]]; then
        MenuChecks[4]=1
    fi
    if [[ "$INSTALL_TOR" -eq 1 ]]; then
        MenuChecks[5]=1
    fi
    if [[ "$INSTALL_CUPS" -eq 1 ]]; then
        MenuChecks[6]=1
    fi
    if [[ "$INSTALL_USB_MODEM" -eq 1 ]]; then
        MenuChecks[7]=1
    fi
    if [[ "$INSTALL_FIRMWARE" -eq 1 ]]; then
        MenuChecks[8]=1
    fi
    if [[ "$INSTALLED_VIDEO_CARD" -eq 1 ]]; then
        MenuChecks[10]=1                             # Check these, it means they are allready Installed
        MenuChecks[11]=1                             # Check these, it means they are allready Installed
    fi
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    StatusBar1="INSTALL-BASICS-MENU-REC"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-BASICS-MENU-TITLE" 
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BASICS-MENU-1"  "" "" "INSTALL-BASICS-MENU-I-1"  "MenuTheme[@]" # NFS
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BASICS-MENU-2"  "" "" "INSTALL-BASICS-MENU-I-2"  "MenuTheme[@]" # SAMBA
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BASICS-MENU-3"  "" "" "INSTALL-BASICS-MENU-I-3"  "MenuTheme[@]" # Laptop Mode Tools
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BASICS-MENU-4"  "" "" "INSTALL-BASICS-MENU-I-4"  "MenuTheme[@]" # Preload
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BASICS-MENU-5"  "" "" "INSTALL-BASICS-MENU-I-5"  "MenuTheme[@]" # Zram
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BASICS-MENU-6"  "" "" "INSTALL-BASICS-MENU-I-6"  "MenuTheme[@]" # Tor
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BASICS-MENU-7"  "" "" "INSTALL-BASICS-MENU-I-7"  "MenuTheme[@]" # CUPS
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BASICS-MENU-8"  "" "" "INSTALL-BASICS-MENU-I-8"  "MenuTheme[@]" # USB 3G MODEM
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BASICS-MENU-9"  "" "" "INSTALL-BASICS-MENU-I-9"  "MenuTheme[@]" # Addition Firmwares
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BASICS-MENU-10" "$(localize "INSTALL-BASICS-MENU-DEFAULT"): $AUR_HELPER" "" "INSTALL-BASICS-MENU-I-10" "MenuTheme[@]" # AUR Helper
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BASICS-MENU-11" "" "" "INSTALL-BASICS-MENU-I-11" "MenuTheme[@]" # Network Managers
        if [[ "$VIDEO_CARD" -eq 7 ]]; then
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BASICS-MENU-12" "" "" "INSTALL-BASICS-MENU-I-12" "MenuThemeWarn[@]" # Video Card
        else
            echo
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BASICS-MENU-12" "$(localize "INSTALL-BASICS-MENU-DEFAULT"): ${VIDEO_CARDS[$(( $VIDEO_CARD - 1 ))]}" "" "INSTALL-BASICS-MENU-I-12" "MenuTheme[@]" # Video Card
        fi        
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        BYPASS="$Old_BYPASS" # Restore Bypass
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # NFS
                    #if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_NFS=1
                        StatusBar1="INSTALL-BASICS-MENU-1"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    #else
                    #    MenuChecks[$((S_OPT - 1))]=2
                    #    INSTALL_NFS=0
                    #    StatusBar1="INSTALL-BASICS-MENU-1"
                    #    StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    #fi
                    # Progress Status
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # SAMBA
                    #if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_SAMBA=1
                        StatusBar1="INSTALL-BASICS-MENU-2"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    #else
                    #    MenuChecks[$((S_OPT - 1))]=2
                    #    INSTALL_SAMBA=0
                    #    StatusBar1="INSTALL-BASICS-MENU-2"
                    #    StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    #fi
                    # Progress Status
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Laptop Mode Tools
                    #if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_LMT=1
                        StatusBar1="INSTALL-BASICS-MENU-3"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    #else
                    #    MenuChecks[$((S_OPT - 1))]=2
                    #    INSTALL_LMT=0
                    #    StatusBar1="INSTALL-BASICS-MENU-3"
                    #    StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    #fi
                    # Progress Status
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Preload
                    #if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_PRELOAD=1
                        StatusBar1="INSTALL-BASICS-MENU-4"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    #else
                    #    MenuChecks[$((S_OPT - 1))]=2
                    #    INSTALL_PRELOAD=0
                    #    StatusBar1="INSTALL-BASICS-MENU-4"
                    #    StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    #fi
                    # Progress Status
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Zram
                    #if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_ZRAM=1
                        StatusBar1="INSTALL-BASICS-MENU-5"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    #else
                    #    MenuChecks[$((S_OPT - 1))]=2
                    #    INSTALL_ZRAM=0
                    #    StatusBar1="INSTALL-BASICS-MENU-5"
                    #    StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    #fi
                    # Progress Status
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Tor
                    #if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_TOR=1
                        StatusBar1="INSTALL-BASICS-MENU-6"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    #else
                    #    MenuChecks[$((S_OPT - 1))]=2
                    #    INSTALL_TOR=0
                    #    StatusBar1="INSTALL-BASICS-MENU-6"
                    #    StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    #fi
                    # Progress Status
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # CUPS
                    #if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_CUPS=1
                        StatusBar1="INSTALL-BASICS-MENU-7"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    #else
                    #    MenuChecks[$((S_OPT - 1))]=2
                    #    INSTALL_CUPS=0
                    #    StatusBar1="INSTALL-BASICS-MENU-7"
                    #    StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    #fi
                    # Progress Status
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # USB 3G MODEM
                    #if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_USB_MODEM=1
                        StatusBar1="INSTALL-BASICS-MENU-8"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    #else
                    #    MenuChecks[$((S_OPT - 1))]=2
                    #    INSTALL_USB_MODEM=0
                    #    StatusBar1="INSTALL-BASICS-MENU-8"
                    #    StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    #fi
                    # Progress Status
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # Addition Firmwares
                    install_additional_firmwares_menu 1
                    if [[ "$INSTALL_FIRMWARE" -eq 1 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                    else
                        MenuChecks[$((S_OPT - 1))]=2
                    fi
                    # Progress Status
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               10)  # Choose AUR Helper 
                    MenuChecks[$((S_OPT - 1))]=1
                    choose_aurhelper
                    # Progress Status
                    StatusBar1="INSTALL-BASICS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               11)  # Network Managers
                    MenuChecks[$((S_OPT - 1))]=1                     
                    get_network_manager_menu
                    # Progress Status
                    StatusBar1="INSTALL-BASICS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               12)  # Install Video Cards 
                    install_video_cards_menu 1
                    if [[ "$VIDEO_CARD" -eq 7 ]]; then
                        MenuChecks[$((S_OPT - 1))]=2
                        INSTALLED_VIDEO_CARD=0         # Same as VIDEO_CARD=7
                    else
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALLED_VIDEO_CARD=1         # Same as VIDEO_CARD != 7 
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-BASICS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL 
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        save_last_config
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL BASIC {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_basic"
    USAGE=$(localize "INSTALL-BASIC-USAGE")
    DESCRIPTION=$(localize "INSTALL-BASIC-DESC")
    NOTES=$(localize "INSTALL-BASIC-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-BASIC-USAGE" "install_basic 1->(1=Install, 2=Remove)"
    localize_info "INSTALL-BASIC-DESC"  "Install Basic Packages"
    localize_info "INSTALL-BASIC-NOTES" "NONE"
fi
# -------------------------------------
install_basic()
{
    # 1
    if [[ "$INSTALL_WIZARD" -eq 0 ]]; then
        install_basics_menu
    fi
    install_basic_setup "$1"            # Automan if keyboard is ES
    install_nfs_now "$1"                # 
    install_samba_now "$1"
    install_laptop_mode_tools_now "$1"
    install_preload_now "$1"
    install_zram_now "$1"
    install_git_tor_now "$1"
    #
    install_cups_now "$1"
    install_usb_modem_now "$1"
    #
    install_network_manager_now # @FIX Uninstall
    install_video_card_now "$1"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL BASIC SETUP {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_basic_setup"
    USAGE=$(localize "INSTALL-BASIC-SETUP-USAGE")
    DESCRIPTION=$(localize "INSTALL-BASIC-SETUP-DESC")
    NOTES=$(localize "INSTALL-BASIC-SETUP-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-BASIC-SETUP-USAGE"           "install_basic_setup 1->(1=Install, 2=Remove)"
    localize_info "INSTALL-BASIC-SETUP-DESC"            "Install Basic Packages"
    localize_info "INSTALL-BASIC-SETUP-NOTES"           "NONE"
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
    #
    localize_info "INSTALL-BASIC-SETUP-XORG-TITLE"      "XORG"
    localize_info "INSTALL-BASIC-SETUP-XORG-INFO-1"     "Xorg is the public, open-source implementation of the X window system version 11."
    localize_info "INSTALL-BASIC-SETUP-XORG-INFO-2"     "Installing X-Server (req. for Desktop Environment, GPU Drivers, Keyboardlayout,...)"
    localize_info "INSTALL-BASIC-SETUP-XORG-SELECT"     "Select keyboard layout:"
fi
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
        # XORG
        remove_package        "$INSTALL_XORG"
        remove_packagemanager "INSTALL-XORG"
        #
        return 0
    fi
    # SYSTEMD
    print_title "INSTALL-BASIC-SETUP-TITLE"
    print_info  "INSTALL-BASIC-SETUP-INFO-SYSTEMD" " - https://wiki.archlinux.org/index.php/Systemd"
    print_info  "INSTALL-BASIC-SETUP-INFO-SYSTEMD-1"
    if add_packagemanager "package_install \"$INSTALL_SYSTEMD\" 'INSTALL-SYSTEMD'" "INSTALL-SYSTEMD" ; then
        add_package        "$INSTALL_SYSTEMD"
    fi
    if add_packagemanager "aur_package_install \"$AUR_INSTALL_SYSTEMD\" 'AUR-INSTALL-SYSTEMD'" "AUR-INSTALL-SYSTEMD" ; then
        add_aur_package    "$AUR_INSTALL_SYSTEMD"
        add_packagemanager "systemctl enable cronie.service" "SYSTEMD-ENABLE-SYSTEMD"
    fi
    # BASH-TOOLS
    print_info "INSTALL-BASIC-SETUP-INFO-BASH-TOOLS" " - https://wiki.archlinux.org/index.php/Bash"
    if add_packagemanager "package_install \"$INSTALL_BASH_TOOLS\" 'INSTALL-BASH-TOOLS'" "INSTALL-BASH-TOOLS" ; then
        add_package        "$INSTALL_BASH_TOOLS"
        add_packagemanager "systemctl enable ntpd.service" "SYSTEMD-ENABLE-BASH-TOOLS"
    fi
    # ARCHIVE-TOOLS
    print_info "INSTALL-BASIC-SETUP-ARCHIVE-TOOLS"
    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ARCHIVE_TOOLS\" 'AUR-INSTALL-ARCHIVE-TOOLS'" "AUR-INSTALL-ARCHIVE-TOOLS" ; then
        add_aur_package    "$AUR_INSTALL_ARCHIVE_TOOLS"
    fi
    # AVAHI   
    print_info "INSTALL-BASIC-SETUP-INFO-AVAHI" " - https://wiki.archlinux.org/index.php/Avahi"
    print_info "INSTALL-BASIC-SETUP-INFO-AVAHI-1"
    if add_packagemanager "package_install \"$INSTALL_AVAHI\" 'INSTALL-AVAHI'" "INSTALL-AVAHI" ; then
        add_package "$INSTALL_AVAHI"
        add_packagemanager "systemctl enable avahi-daemon.service avahi-dnsconfd.service" "SYSTEMD-ENABLE-AVAHI"
    fi
    # ACPI
    print_info "INSTALL-BASIC-SETUP-INFO-ACPI" " - https://wiki.archlinux.org/index.php/ACPI_modules"
    print_info "INSTALL-BASIC-SETUP-ACPI-1"
    if add_packagemanager "package_install \"$INSTALL_ACPI\" 'INSTALL-ACPI'" "INSTALL-ACPI" ; then
        add_package "$INSTALL_ACPI"
        add_packagemanager "systemctl enable acpid.service" "SYSTEMD-ENABLE-ACPI"
    fi
    # ALSA
    print_info "INSTALL-BASIC-SETUP-ALSA" " - https://wiki.archlinux.org/index.php/Alsa"
    print_info "INSTALL-BASIC-SETUP-ALSA-1"
    if add_packagemanager "package_install \"$INSTALL_ALSA\" 'INSTALL-ALSA'" "INSTALL-ALSA" ; then
        add_package        "$INSTALL_ALSA"
        add_module         "snd-usb-audio" "INSTALL-ALSA"
        add_packagemanager "systemctl enable alsa-store.service alsa-restore.service" "SYSTEMD-ENABLE-ALSA" # @FIX does this need to be called?
    fi
    # NTFS   
    print_info "INSTALL-BASIC-SETUP-NTFS-1" " - https://wiki.archlinux.org/index.php/File_Systems"
    print_info "INSTALL-BASIC-SETUP-NTFS-2"
    if add_packagemanager "package_install \"$INSTALL_NTFS\" 'INSTALL-NTFS'" "INSTALL-NTFS" ; then
        add_package        "$INSTALL_NTFS"
        add_module         "fuse" "INSTALL-NTFS"
    fi
    # SSH
    print_info "INSTALL-BASIC-SETUP-SSH-1" " - https://wiki.archlinux.org/index.php/Ssh"
    print_info "INSTALL-BASIC-SETUP-SSH-2"
    if add_packagemanager "package_install \"$INSTALL_SSH\" 'INSTALL-SSH'" "INSTALL-SSH" ; then
        add_package "$INSTALL_SSH"
        add_packagemanager "systemctl enable sshd.service" "SYSTEMD-ENABLE-SSH"
    fi
    if add_packagemanager "aur_package_install \"$AUR_INSTALL_SSH\" 'AUR-INSTALL-SSH'" "AUR-INSTALL-SSH" ; then
        add_aur_package    "$AUR_INSTALL_SSH"
    fi
    CONFIG_SSH=1
    # https://wiki.archlinux.org/index.php/Systemd
    add_packagemanager "systemctl enable systemd-readahead-collect systemd-readahead-replay" "SYSTEMD-ENABLE-READAHEAD"
    #
    print_info "INSTALL-BASIC-SETUP-XORG-TITLE" " - https://wiki.archlinux.org/index.php/Xorg"
    print_this "INSTALL-BASIC-SETUP-XORG-INFO-1"
    print_this "INSTALL-BASIC-SETUP-XORG-INFO-2"
    if add_packagemanager "package_install \"$INSTALL_XORG\" 'INSTALL-XORG'" "INSTALL-XORG"; then
        add_package        "$INSTALL_XORG"
        CONFIG_XORG=1
        # @FIX point to function or set var
        if [[ "$LANGUAGE" == 'es_ES' ]]; then
            local -a KBLAYOUT=("es" "latam");
            PS3="$prompt1"
            print_info "INSTALL-BASIC-SETUP-XORG-SELECT"
            select KBRD in "${KBLAYOUT[@]}"; do
                KEYBOARD="$KBRD"
            done
        fi    
    fi
    #
    if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL USB MODEM NOW {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_usb_modem_now"
    USAGE=$(localize "INSTALL-USB-MODEM-NOW-USAGE")
    DESCRIPTION=$(localize "INSTALL-USB-MODEM-NOW-DESC")
    NOTES=$(localize "INSTALL-USB-MODEM-NOW-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-USB-MODEM-NOW-USAGE"   "install_usb_modem_now 1->(1=Install, 2=Remove)"
    localize_info "INSTALL-USB-MODEM-NOW-DESC"    "Install USB Modem"
    localize_info "INSTALL-USB-MODEM-NOW-NOTES"   "None."
    #
    localize_info "INSTALL-USB-MODEM-NOW-TITLE"   "USB 3G MODEM" 
    localize_info "INSTALL-USB-MODEM-NOW-INFO"    "A number of mobile telephone networks around the world offer mobile internet connections over UMTS (or EDGE or GSM) using a portable USB modem device." 
fi
# -------------------------------------
install_usb_modem_now()
{
    # 1
    if [[ "$1" -eq "2" ]]; then
        remove_package "$INSTALL_USB_3G_MODEM" 
        remove_packagemanager "INSTALL-USB-3G-MODEM"
        return 0
    fi
    if [[ "$INSTALL_USB_MODEM" -eq 1 ]]; then
        print_title "INSTALL-USB-3G-MODEM-TITLE" " - https://wiki.archlinux.org/index.php/USB_3G_Modem"
        print_info  "INSTALL-USB-3G-MODEM-INFO"
        if add_packagemanager "package_install \"$INSTALL_USB_3G_MODEM\" 'INSTALL-USB-3G-MODEM'" "INSTALL-USB-3G-MODEM"; then
            add_package "$INSTALL_USB_3G_MODEM"
        fi        
        if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL GIT TOR NOW {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_git_tor_now"
    USAGE=$(localize "INSTALL-GIT-TOR-USAGE")
    DESCRIPTION=$(localize "INSTALL-GIT-TOR-DESC")
    NOTES=$(localize "INSTALL-GIT-TOR-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-GIT-TOR-USAGE" "install_git_tor_now 1->(1=Install, 2=Remove)"
    localize_info "INSTALL-GIT-TOR-DESC"  "Install GIT TOR Packages"
    localize_info "INSTALL-GIT-TOR-NOTES" "NONE"
    #
    localize_info "INSTALL-GIT-TOR-TITLE" "GIT-TOR"
    localize_info "INSTALL-GIT-TOR-INFO"  "Tor is an open source implementation of 2nd generation onion routing that provides free access to an anonymous proxy network. Its primary goal is to enable online anonymity by protecting against traffic analysis attacks."
fi
# -------------------------------------
install_git_tor_now()
{
    if [[ "$1" -eq 2 ]]; then
        remove_package "$INSTALL_GIT_TOR"
        remove_packagemanager "INSTALL-GIT-TOR"
        CONFIG_TOR=0
        return 0
    fi
    if [[ "$INSTALL_TOR" -eq 1 ]]; then
        print_title "INSTALL-GIT-TOR-TITLE" " - https://wiki.archlinux.org/index.php/Tor"
        print_info  "INSTALL-GIT-TOR-INFO"
        if add_packagemanager "package_install \"$INSTALL_GIT_TOR\" 'INSTALL-GIT-TOR'" "INSTALL-GIT-TOR"; then
            add_package "$INSTALL_GIT_TOR"
            add_packagemanager "systemctl enable tor.service privoxy.service" "SYSTEMD-ENABLE-GIT-TOR"
        fi
        CONFIG_TOR=1
        if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL NFS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_nfs_now"
    USAGE=$(localize "INSTALL-NFS-USAGE")
    DESCRIPTION=$(localize "INSTALL-NFS-DESC")
    NOTES=$(localize "INSTALL-NFS-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-NFS-USAGE" "install_nfs_now 1->(1=Install, 2=Remove)"
    localize_info "INSTALL-NFS-DESC"  "Install NFS Packages"
    localize_info "INSTALL-NFS-NOTES" "NONE"
    #
    localize_info "INSTALL-NFS-TITLE" "NFS"
    localize_info "INSTALL-NFS-INFO"  "NFS allowing a user on a client computer to access files over a network in a manner similar to how local storage is accessed."
fi
# -------------------------------------
install_nfs_now()
{
    if [[ "$1" -eq 2 ]]; then
        remove_package "$INSTALL_NFS"
        remove_packagemanager "INSTALL-NFS"
        remove_packagemanager "SYSTEMD-ENABLE-NFS"
        return 0
    fi
    if [[ "$INSTALL_NFS" -eq 1 ]]; then
        print_title "INSTALL-NFS-TITLE" " - https://wiki.archlinux.org/index.php/Nfs"
        print_info  "INSTALL-NFS-INFO"
        if add_packagemanager "package_install \"$INSTALL_NFS_PACKAGES\" 'INSTALL-NFS'" "INSTALL-NFS" ; then
            add_package "$INSTALL_NFS_PACKAGES"
            add_packagemanager "systemctl enable rpc-statd.service" "SYSTEMD-ENABLE-NFS"
        fi
        if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL SAMBA {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_samba_now"
    USAGE=$(localize "INSTALL-SAMBA-USAGE")
    DESCRIPTION=$(localize "INSTALL-SAMBA-DESC")
    NOTES=$(localize "INSTALL-SAMBA-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-SAMBA-USAGE" "install_samba_now 1->(1=Install, 2=Remove)"
    localize_info "INSTALL-SAMBA-DESC"  "Install samba Packages"
    localize_info "INSTALL-SAMBA-NOTES" "NONE"
    #
    localize_info "INSTALL-SAMBA-TITLE" "SAMBA"
    localize_info "INSTALL-SAMBA-INFO"  "Samba is a re-implementation of the SMB/CIFS networking protocol, it facilitates file and printer sharing among Linux and Windows systems as an alternative to NFS."
fi
# -------------------------------------
install_samba_now()
{
    if [[ "$1" -eq 2 ]]; then
        # @FIX this is just a TEMPLATE
        remove_package "$INSTALL_SAMBA"
        remove_packagemanager "INSTALL-SAMBA"
        remove_packagemanager "COPY-CONFIG-SAMBA"
        remove_packagemanager "SYSTEMD-ENABLE-SAMBA"
        return 0
    fi
    if [[ "$INSTALL_SAMBA" -eq 1 ]]; then
        print_title "INSTALL-SAMBA-TITLE" " - https://wiki.archlinux.org/index.php/Samba"
        print_info  "INSTALL-SAMBA-INFO"
        if add_packagemanager "package_install \"$INSTALL_SAMBA_PACKAGES\" 'INSTALL-SAMBA'" "INSTALL-SAMBA" ; then
            add_package "$INSTALL_SAMBA_PACKAGES"
            add_packagemanager "copy_file '/etc/samba/smb.conf.default' '/etc/samba/smb.conf' \"$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO\"" "COPY-CONFIG-SAMBA"
            add_packagemanager "systemctl enable smbd smbnetfs nmbd winbindd.service" "SYSTEMD-ENABLE-SAMBA"
        fi
        # installing samba will overwrite /etc/samba/smb.conf so copy it to temp 
        copy_file "/etc/samba/smb.conf" "${FULL_SCRIPT_PATH}/etc/samba/smb.conf" "$LINENO"
        if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL PRELOAD {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_preload_now"
    USAGE=$(localize "INSTALL-PRELOAD-USAGE")
    DESCRIPTION=$(localize "INSTALL-PRELOAD-DESC")
    NOTES=$(localize "INSTALL-PRELOAD-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-PRELOAD-USAGE" "install_preload_now 1->(1=Install, 2=Remove)"
    localize_info "INSTALL-PRELOAD-DESC"  "Install preload Packages"
    localize_info "INSTALL-PRELOAD-NOTES" "NONE"
    #
    localize_info "INSTALL-PRELOAD-TITLE" "PRELOAD"
    localize_info "INSTALL-PRELOAD-INFO"  "Preload is a program which runs as a daemon and records statistics about usage of programs using Markov chains; files of more frequently-used programs are, during a computer's spare time, loaded into memory. This results in faster startup times as less data needs to be fetched from disk. preload is often paired with prelink."
fi
# -------------------------------------
install_preload_now()
{
    if [[ "$1" -eq 2 ]]; then
        remove_package "$INSTALL_PRELOAD"
        remove_packagemanager "INSTALL-PRELOAD"
        remove_packagemanager "SYSTEMD-ENABLE-PRELOAD"
        return 0
    fi
    if [[ "$INSTALL_PRELOAD" -eq 1 ]]; then
        print_title "INSTALL-PRELOAD-TITLE" " - https://wiki.archlinux.org/index.php/Preload"
        print_info  "INSTALL-PRELOAD-INFO"
        if add_packagemanager "package_install \"$INSTALL_PRELOAD_PACKAGES\" 'INSTALL-PRELOAD'" "INSTALL-PRELOAD" ; then
            add_package "$INSTALL_PRELOAD_PACKAGES"
            add_packagemanager "systemctl enable preload.service" "SYSTEMD-ENABLE-PRELOAD"
        fi
        if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL ZRAM {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_zram_now"
    USAGE=$(localize "INSTALL-ZRAM-USAGE")
    DESCRIPTION=$(localize "INSTALL-ZRAM-DESC")
    NOTES=$(localize "INSTALL-ZRAM-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-ZRAM-USAGE" "install_zram_now 1->(1=Install, 2=Remove)"
    localize_info "INSTALL-ZRAM-DESC"  "Install zram Packages"
    localize_info "INSTALL-ZRAM-NOTES" "NONE"
    #
    localize_info "INSTALL-ZRAM-TITLE" "ZRAM"
    localize_info "INSTALL-ZRAM-INFO"  "Zram creates a device in RAM and compresses it. If you use for swap means that part of the RAM can hold much more information but uses more CPU. Still, it is much quicker than swapping to a hard drive. If a system often falls back to swap, this could improve responsiveness. Zram is in mainline staging (therefore its not stable yet, use with caution)."
fi
# -------------------------------------
install_zram_now()
{
    if [[ "$1" -eq 2 ]]; then
        # @FIX this is just a TEMPLATE
        remove_aur_package    "$AUR_INSTALL_ZRAM"
        remove_packagemanager "AUR-INSTALL-ZRAM"
        remove_packagemanager "SYSTEMD-ENABLE-ZRAM"
        return 0
    fi
    if [[ "$INSTALL_ZRAM" -eq 1 ]]; then
        print_title "INSTALL-ZRAM-TITLE" " - https://wiki.archlinux.org/index.php/Maximizing_Performance"
        print_info  "INSTALL-ZRAM-INFO" 
        if add_packagemanager "aur_package_install \"$AUR_INSTALL_ZRAM\" 'AUR-INSTALL-ZRAM'" "AUR-INSTALL-ZRAM" ; then
            add_aur_package "$AUR_INSTALL_ZRAM"
            add_packagemanager "systemctl enable zram.service" "SYSTEMD-ENABLE-ZRAM"
        fi
        if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL LAPTOP MODE TOOLS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_laptop_mode_tools_now"
    USAGE=$(localize "INSTALL-LAPTOP-MODE-TOOLS-USAGE")
    DESCRIPTION=$(localize "INSTALL-LAPTOP-MODE-TOOLS-DESC")
    NOTES=$(localize "INSTALL-LAPTOP-MODE-TOOLS-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-LAPTOP-MODE-TOOLS-USAGE" "install_laptop_mode_tools_now 1->(1=Install, 2=Remove)"
    localize_info "INSTALL-LAPTOP-MODE-TOOLS-DESC"  "Install LAPTOP-MODE-TOOLS Packages"
    localize_info "INSTALL-LAPTOP-MODE-TOOLS-NOTES" "NONE"
    #
    localize_info "INSTALL-LAPTOP-MODE-TOOLS-TITLE" "LAPTOP MODE TOOLS"
    localize_info "INSTALL-LAPTOP-MODE-TOOLS-INFO"  "Laptop Mode Tools is a laptop power saving package for Linux systems. It is the primary way to enable the Laptop Mode feature of the Linux kernel, which lets your hard drive spin down. In addition, it allows you to tweak a number of other power-related settings using a simple configuration file."
fi
# -------------------------------------
install_laptop_mode_tools_now()
{
    if [[ "$1" -eq 2 ]]; then
        # @FIX this is just a TEMPLATE
        remove_package "$INSTALL_LAPTOP_MODE_TOOLS"
        remove_packagemanager "INSTALL-LAPTOP-MODE-TOOLS"
        remove_packagemanager "SYSTEMD-ENABLE-LAPTOP-MODE-TOOLS"
        return 0
    fi
    if [[ "$INSTALL_LMT" -eq 1 ]]; then
        print_title "INSTALL-LAPTOP-MODE-TOOLS-TITLE" "- https://wiki.archlinux.org/index.php/Laptop_Mode_Tools"
        print_info  "INSTALL-LAPTOP-MODE-TOOLS-INFO"
        if add_packagemanager "package_install \"$INSTALL_LAPTOP_MODE_TOOLS\" 'INSTALL-LAPTOP-MODE-TOOLS'" "INSTALL-LAPTOP-MODE-TOOLS" ; then
            add_package        "$INSTALL_LAPTOP_MODE_TOOLS"
            add_packagemanager "systemctl enable laptop-mode-tools.service" "SYSTEMD-ENABLE-LAPTOP-MODE-TOOLS"
        fi
        if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL CUPS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_cups_now"
    USAGE=$(localize "INSTALL-CUPS-USAGE")
    DESCRIPTION=$(localize "INSTALL-CUPS-DESC")
    NOTES=$(localize "INSTALL-CUPS-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-CUPS-USAGE" "install_cups_now 1->(1=Install, 2=Remove)"
    localize_info "INSTALL-CUPS-DESC"  "Install Cups."
    localize_info "INSTALL-CUPS-NOTES" "None."
    #
    localize_info "INSTALL-CUPS-YN"    "Install CUPS - AKA Common Unix Printing System" 
    localize_info "INSTALL-CUPS-TITLE" "CUPS - AKA Common Unix Printing System" 
    localize_info "INSTALL-CUPS-INFO"  "CUPS is the standards-based, open source printing system developed by Apple Inc. for Mac OS® X and other UNIX®-like operating systems." 
fi
# -------------------------------------
install_cups_now()
{
    if [[ "$1" -eq 2 ]]; then
        remove_packagemanager "INSTALL-CUPS"
        remove_packagemanager "SYSTEMD-ENABLE-CUPS"
        remove_package "$INSTALL_CUPS_PACK"
        return 0
    fi
    if [[ "$INSTALL_CUPS" -eq 1 ]]; then
        # Install Software 
        print_title "INSTALL-CUPS-TITLE" " - https://wiki.archlinux.org/index.php/Cups"
        print_info  "INSTALL-CUPS-INFO"
        add_package "$INSTALL_CUPS_PACK"
        if add_packagemanager "package_install \"$INSTALL_CUPS_PACK\" 'INSTALL-CUPS'" "INSTALL-CUPS" ; then
            add_packagemanager "systemctl enable cups.service" "SYSTEMD-ENABLE-CUPS"
        fi
        if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL ADDITIONAL FIRMWARE MENU {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_additional_firmwares_menu"
    USAGE="INSTALL-ADDITIONAL-FIRMWARE-USAGE"
    DESCRIPTION=$(localize "INSTALL-ADDITIONAL-FIRMWARE-DESC")
    NOTES=$(localize "INSTALL-ADDITIONAL-FIRMWARE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-USAGE"   "install_additional_firmwares_menu 1->(1=Install, 2=Remove)"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-DESC"    "Install Addition Firmwares"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-NOTES"   "None."
    #
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-TITLE"   "INSTALL ADDITIONAL FIRMWARES"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-INFO"    "alsa-firmware, ipw2100-fw, ipw2200-fw, b43-firmware, b43-firmware-legacy, broadcom-wl, zd1211-firmware, bluez-firmware, libffado, libraw1394, sane-gt68xx-firmware"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-INSTALL" "Install additional firmwares (Audio,Bluetooth,Scanner,Wireless)"
    #
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-1"    "alsa-firmware"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-1"        "alsa-firmware: ALSA firmware package"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-2"    "ipw2100-fw"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-2"        "ipw2100-fw: Intel Centrino Drivers firmware for IPW2100"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-3"    "ipw2200-fw"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-3"        "ipw2200-fw: Firmware for the Intel PRO/Wireless 2200BG"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-4"    "b43-firmware"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-4"        "b43-firmware: Firmware for Broadcom B43 wireless networking chips"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-5"    "b43-firmware-legacy"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-5"        "b43-firmware-legacy: Firmware for legacy Broadcom B43 wireless networking chips"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-6"    "broadcom-wl"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-6"        "broadcom-wl: Broadcom 802.11abgn hybrid Linux networking device driver"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-7"    "zd1211-firmware"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-7"        "zd1211-firmware: Firmware for the in-kernel26 zd1211rw wireless driver"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-8"    "bluez-firmware"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-8"        "bluez-firmware: Firmwares for Broadcom BCM203x and STLC2300 Bluetooth chips"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-9"    "libffado"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-9"        "libffado: Driver for FireWire audio devices"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-10"   "libraw1394"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-10"       "libraw1394: Provides an API to the Linux IEEE1394 (FireWire) driver"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-11"   "sane-gt68xx-firmware"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-11"       "sane-gt68xx-firmware: gt68xx-based scanners firmwares"
fi
# -------------------------------------
install_additional_firmwares_menu()
{
    # Install Software 
    local -r menu_name="INSTALL-ADDITIONAL-FIRMWARE"  # You must define Menu Name here
    local BreakableKey="D"                            # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""                       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    print_title "INSTALL-ADDITIONAL-FIRMWARE-TITLE"
    print_info  "INSTALL-ADDITIONAL-FIRMWARE-INFO"
    local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
    read_input_yn "INSTALL-ADDITIONAL-FIRMWARE-INSTALL" " " 0
    BYPASS="$Old_BYPASS" # Restore Bypass
    if [[ "$YN_OPTION" -eq 1 ]]; then
        #
        StatusBar1="INSTALL-MENU-RECOMMENDED"
        StatusBar2=": $RecommendedOptions"
        while [[ 1 ]]; do
            print_title "INSTALL-ADDITIONAL-FIRMWARE-TITLE"
            print_caution "${StatusBar1}" "${StatusBar2}"
            local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
            #
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ADDITIONAL-FIRMWARE-MENU-1"  "" ""     "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-1"  "MenuTheme[@]" #  1 alsa-firmware
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ADDITIONAL-FIRMWARE-MENU-2"  "" ""     "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-2"  "MenuTheme[@]" #  2 ipw2100-fw
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ADDITIONAL-FIRMWARE-MENU-3"  "" ""     "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-3"  "MenuTheme[@]" #  3 ipw2200-fw
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ADDITIONAL-FIRMWARE-MENU-4"  "" "$AUR" "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-4"  "MenuTheme[@]" #  4 b43-firmware
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ADDITIONAL-FIRMWARE-MENU-5"  "" "$AUR" "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-5"  "MenuTheme[@]" #  5 b43-firmware-legacy
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ADDITIONAL-FIRMWARE-MENU-6"  "" "$AUR" "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-6"  "MenuTheme[@]" #  6 broadcom-wl
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ADDITIONAL-FIRMWARE-MENU-7"  "" ""     "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-7"  "MenuTheme[@]" #  7 zd1211-firmware
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ADDITIONAL-FIRMWARE-MENU-8"  "" ""     "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-8"  "MenuTheme[@]" #  8 bluez-firmware
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ADDITIONAL-FIRMWARE-MENU-9"  "" ""     "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-9"  "MenuTheme[@]" #  9 libffado
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ADDITIONAL-FIRMWARE-MENU-10" "" ""     "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-10" "MenuTheme[@]" # 10 libraw1394
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ADDITIONAL-FIRMWARE-MENU-11" "" ""     "INSTALL-ADDITIONAL-FIRMWARE-MENU-I-11" "MenuTheme[@]" # 11 sane-gt68xx-firmware
            #
            print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
            #
            local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
            read_input_options "$RecommendedOptions" "$BreakableKey"
            RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
            BYPASS="$Old_BYPASS" # Restore Bypass
            #
            local S_OPT
            for S_OPT in ${OPTIONS[@]}; do
                case "$S_OPT" in
                    1)  # alsa-firmware
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            if add_packagemanager "package_install \"$INSTALL_ALSA_FIRMWARE\" 'INSTALL-ALSA-FIRMWARE'" "INSTALL-ALSA-FIRMWARE" ; then
                                add_package "$INSTALL_ALSA_FIRMWARE"
                            fi                    
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$INSTALL_ALSA_FIRMWARE"
                            remove_packagemanager "INSTALL-ALSA_FIRMWARE"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        # Progress Status
                        StatusBar1="INSTALL-ADDITIONAL-FIRMWARE-MENU-$((S_OPT - 1))"
                        StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                        print_this "$StatusBar1 $StatusBar2"
                        ;;
                    2)  # ipw2100-fw
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            if add_packagemanager "package_install \"$INSTALL_IPW2100_FW\" 'INSTALL-IPW2100-FW'" "INSTALL-IPW2100-FW" ; then
                                add_package "$INSTALL_IPW2100_FW"
                            fi                    
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$INSTALL_IPW2100_FW"
                            remove_packagemanager "INSTALL-IPW2100-FW"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        # Progress Status
                        StatusBar1="INSTALL-ADDITIONAL-FIRMWARE-MENU-$((S_OPT - 1))"
                        StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                        print_this "$StatusBar1 $StatusBar2"
                        ;;
                    3)  # ipw2200-fw 
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            if add_packagemanager "package_install \"$INSTALL_IPW2200_FW\" 'INSTALL-IPW2200-FW'" "INSTALL-IPW2200-FW" ; then
                                add_package "$INSTALL_IPW2200_FW"
                            fi                    
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$INSTALL_IPW2200_FW"
                            remove_packagemanager "INSTALL-IPW2200-FW"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        # Progress Status
                        StatusBar1="INSTALL-ADDITIONAL-FIRMWARE-MENU-$((S_OPT - 1))"
                        StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                        print_this "$StatusBar1 $StatusBar2"
                        ;;
                    4)  # b43-firmware
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            if add_packagemanager "aur_package_install \"$AUR_INSTALL_B43_FIRMWARE\" 'AUR-INSTALL-B43-FIRMWARE'" "AUR-INSTALL-B43-FIRMWARE" ; then
                                add_aur_package "$AUR_INSTALL_B43_FIRMWARE"
                            fi                    
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$AUR_INSTALL_B43_FIRMWARE"
                            remove_packagemanager "AUR-INSTALL-B43-FIRMWARE"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        # Progress Status
                        StatusBar1="INSTALL-ADDITIONAL-FIRMWARE-MENU-$((S_OPT - 1))"
                        StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                        print_this "$StatusBar1 $StatusBar2"
                        ;;
                    5)  # b43-firmware-legacy
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            if add_packagemanager "aur_package_install \"$AUR_INSTALL_B43_FIRMWARE_LEGACY\" 'AUR-INSTALL-B43-FIRMWARE-LEGACY'" "AUR-INSTALL-B43-FIRMWARE-LEGACY" ; then
                                add_aur_package "$AUR_INSTALL_B43_FIRMWARE_LEGACY"
                            fi                    
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$AUR_INSTALL_B43_FIRMWARE_LEGACY"
                            remove_packagemanager "AUR-INSTALL-B43-FIRMWARE-LEGACY"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        # Progress Status
                        StatusBar1="INSTALL-ADDITIONAL-FIRMWARE-MENU-$((S_OPT - 1))"
                        StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                        print_this "$StatusBar1 $StatusBar2"
                        ;;
                    6)  # broadcom-wl
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            if add_packagemanager "aur_package_install \"$AUR_INSTALL_BROADCOM_WL\" 'AUR-INSTALL-BROADCOM-WL'" "AUR-INSTALL-BROADCOM-WL" ; then
                                add_aur_package "$AUR_INSTALL_BROADCOM_WL"
                            fi                    
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$AUR_INSTALL_BROADCOM_WL"
                            remove_packagemanager "AUR-INSTALL-BROADCOM-WL"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        # Progress Status
                        StatusBar1="INSTALL-ADDITIONAL-FIRMWARE-MENU-$((S_OPT - 1))"
                        StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                        print_this "$StatusBar1 $StatusBar2"
                        ;;
                    7)  # zd1211-firmware
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            if add_packagemanager "package_install \"$INSTALL_ZD1211_FIRMWARE\" 'INSTALL-ZD1211-FIRMWARE'" "INSTALL-ZD1211-FIRMWARE" ; then
                                add_package "$INSTALL_ZD1211_FIRMWARE"
                            fi                    
                        else
                            remove_package "$INSTALL_ZD1211_FIRMWARE"
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_packagemanager "INSTALL-ZD1211-FIRMWARE"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        # Progress Status
                        StatusBar1="INSTALL-ADDITIONAL-FIRMWARE-MENU-$((S_OPT - 1))"
                        StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                        print_this "$StatusBar1 $StatusBar2"
                        ;;
                    8)  # bluez-firmware
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            if add_packagemanager "package_install \"$INSTALL_BLUEZ_FIREWARE\" 'INSTALL-BLUEZ-FIREWARE'" "INSTALL-BLUEZ-FIREWARE" ; then
                                add_package "$INSTALL_BLUEZ_FIREWARE"
                            fi                    
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$INSTALL_BLUEZ_FIREWARE"
                            remove_packagemanager "INSTALL-BLUEZ-FIREWARE"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        # Progress Status
                        StatusBar1="INSTALL-ADDITIONAL-FIRMWARE-MENU-$((S_OPT - 1))"
                        StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                        print_this "$StatusBar1 $StatusBar2"
                        ;;
                    9)  # libffado
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            if add_packagemanager "package_install \"$INSTALL_LIBFFADO\" 'INSTALL-LIBFFADO'" "INSTALL-LIBFFADO" ; then
                                add_package "$INSTALL_LIBFFADO"
                            fi                    
                        else
                            remove_package "$INSTALL_LIBFFADO"
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_packagemanager "INSTALL-LIBFFADO"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        # Progress Status
                        StatusBar1="INSTALL-ADDITIONAL-FIRMWARE-MENU-$((S_OPT - 1))"
                        StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                        print_this "$StatusBar1 $StatusBar2"
                        ;;
                   10)  # libraw1394
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            if add_packagemanager "package_install \"$INSTALL_LIBRAW1394\" 'INSTALL-LIBRAW1394'" "INSTALL-LIBRAW1394" ; then
                                add_package "$INSTALL_LIBRAW1394"
                            fi                    
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$INSTALL_LIBRAW1394"
                            remove_packagemanager "INSTALL-LIBRAW1394"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        # Progress Status
                        StatusBar1="INSTALL-ADDITIONAL-FIRMWARE-MENU-$((S_OPT - 1))"
                        StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                        print_this "$StatusBar1 $StatusBar2"
                        ;;
                   11)  # sane-gt68xx-firmware
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            if add_packagemanager "package_install \"$INSTALL_SANE_GT68XX_FIRMWARE\" 'INSTALL-SANE-GT68XX-FIRMWARE'" "INSTALL-SANE-GT68XX-FIRMWARE" ; then
                                add_package "$INSTALL_SANE_GT68XX_FIRMWARE"
                            fi                    
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$INSTALL_SANE_GT68XX_FIRMWARE"
                            remove_packagemanager "INSTALL-SANE-GT68XX-FIRMWARE"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        # Progress Status
                        StatusBar1="INSTALL-ADDITIONAL-FIRMWARE-MENU-$((S_OPT - 1))"
                        StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                        print_this "$StatusBar1 $StatusBar2"
                        ;;
                    *)  # Catch ALL
                        if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                            if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                                SAVED_MAIN_MENU=1
                                return 0
                            else
                                return 1
                            fi
                        else
                            invalid_option "$S_OPT"
                        fi
                        ;;
                esac
            done
            is_breakable "$S_OPT" "$BreakableKey"
        done
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL KERNEL MENU {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_kernel_menu"
    USAGE="install_kernel_menu"
    DESCRIPTION=$(localize "INSTALL-KERNEL-DESC")
    NOTES=$(localize "INSTALL-KERNEL-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-KERNEL-DESC"   "Install Kernel Menu: "
    localize_info "INSTALL-KERNEL-NOTES"  "NONE"
    localize_info "INSTALL-KERNEL-TITLE"  "Kernel Installation:"
    # Liquorix, LTS, ZEN
    localize_info "INSTALL-KERNEL-MENU-0"   "Liquorix"
    localize_info "INSTALL-KERNEL-MENU-I-0"     "Liquorix is a distro kernel replacement built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads, often used as a Debian Linux performance replacement kernel. damentz, the maintainer of the Liquorix patchset, is a developer for the Zen patchset as well, so many of the improvements there are found in this patchset. http://liquorix.net/"
    localize_info "INSTALL-KERNEL-MENU-1"   "LTS"
    localize_info "INSTALL-KERNEL-MENU-I-1"     "Long term support (LTS) Linux kernel and modules from the [core] repository."
    localize_info "INSTALL-KERNEL-MENU-2"   "ZEN"
    localize_info "INSTALL-KERNEL-MENU-I-2"     "The Zen Kernel is a the result of a collaborative effort of kernel hackers to provide the best Linux kernel possible for every day systems. https://github.com/damentz/zen-kernel?"
    #localize_info "INSTALL-KERNEL-MENU-3"   ""
    #localize_info "INSTALL-KERNEL-MENU-I-3"     ""
fi
# -------------------------------------
install_kernel_menu()
{
    local -r menu_name="INSTALL-KERNEL"  # You must define Menu Name here
    local BreakableKey="D"               # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""          # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "CONFIGURE-KERNEL-TITLE" " - https://wiki.archlinux.org/index.php/Kernels"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-0" "" "" "INSTALL-TYPE-MENU-I-0" "MenuTheme[@]" # Liquorix
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-1" "" "" "INSTALL-TYPE-MENU-I-1" "MenuTheme[@]" # LTS
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-2" "" "" "INSTALL-TYPE-MENU-I-2" "MenuTheme[@]" # ZEN
        #add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-3" "" "" "INSTALL-TYPE-MENU-I-3" "MenuTheme[@]" # 
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Liquorix
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_LIQURIX\" 'INSTALL-LIQURIX'" "INSTALL-LIQURIX" ; then
                        add_package        "$INSTALL_LIQURIX"
                    fi
                    #
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_LIQURIX\" 'AUR-INSTALL-LIQURIX'" "AUR-INSTALL-LIQURIX" ; then
                        add_aur_package    "$AUR_INSTALL_LIQURIX"
                    fi
                    if [[ "$VIDEO_CARD" -eq 1 ]]; then    # nVidia for Liqurix
                        if add_packagemanager "aur_package_install \"$AUR_INSTALL_LIQURIX_NVIDIA\" 'AUR-INSTALL-LIQURIX-NVIDIA'" "AUR-INSTALL-LIQURIX-NVIDIA" ; then
                            add_aur_package    "$AUR_INSTALL_LIQURIX_NVIDIA"
                        fi
                    fi
                    # @FIX too many other things to do
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-TYPE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                2)  # linux-lts 
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_LTS\" 'INSTALL-LTS'" "INSTALL-LTS" ; then
                        add_package        "$INSTALL_LTS"
                    fi
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-TYPE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                3)  # linux-zen 
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ZEN\" 'AUR-INSTALL-ZEN'" "AUR-INSTALL-ZEN" ; then
                        add_aur_package    "$AUR_INSTALL_ZEN"
                    fi
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-TYPE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-TYPE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                *)  # Catch ALL 
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL DESKTOP ENVIRONMENT {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_desktop_environment_menu"
    USAGE="install_desktop_environment_menu"
    DESCRIPTION=$(localize "INSTALL-DESKTOP-ENVIRONMENT-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-DESC"    "Install Desktop Environment"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-TITLE"   "Desktop Environment"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-INFO-1"  "A Desktop environments (DE) provide a complete graphical user interface (GUI) for a system by bundling together a variety of X clients written using a common widget toolkit and set of libraries."
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-INFO-2"  "Mate, KDE, XFCE, Awesome, Cinnamon, E17, LXDE, OpenBox, GNOME, and Unity"
    #
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-1"    "Mate"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-1-D"      "The Way Gnome should be..."
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-1-W"        "Installs from repo.mate-desktop.org"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-1-I"            "Mate: Fork of Gnome 2.x"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-2"    "KDE"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-2-I"      "KDE: KDE software consists of a large number of individual applications and a desktop workspace as a shell to run these applications. https://wiki.archlinux.org/index.php/KDE"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-3"    "XFCE"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-3-I"      "XFCE: Xfce embodies the traditional UNIX philosophy of modularity and re-usability. It consists of a number of components that provide the full functionality one can expect of a modern desktop environment, while remaining relatively light. https://wiki.archlinux.org/index.php/Xfce"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-4"    "Razor-qt"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-4-I"      "Razor-qt [unsupported] is an advanced, easy-to-use, and fast desktop environment based on Qt technologies. It has been tailored for users who value simplicity, speed, and an intuitive interface. While still a new project, Razor-qt already contains all the key DE components. https://wiki.archlinux.org/index.php/Razor-qt"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-5"    "Cinnamon"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-5-I"      "Cinnamon: Cinnamon is a fork of Gnome 3. Cinnamon strives to provide a traditional user experienc, similar to Gnome 2. https://wiki.archlinux.org/index.php/Cinnamon"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-6"    "E17"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-6-I"      "E17: The Enlightenment desktop shell provides an efficient yet breathtaking window manager based on the Enlightenment Foundation Libraries along with other essential desktop components like a file manager, desktop icons and widgets. https://wiki.archlinux.org/index.php/E17"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-7"    "LXDE"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-7-I"      "LXDE: The 'Lightweight X11 Desktop Environment' is a fast and energy-saving desktop environment. Maintained by an international community of developers, it comes with a beautiful interface, multi-language support, standard keyboard short cuts and additional features like tabbed file browsing. Fundamentally designed to be lightweight, LXDE uses less CPU and RAM than other environments. https://wiki.archlinux.org/index.php/LXDE"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-8"    "GNOME"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-8-I"      "GNOME: The GNOME project provides two things: The GNOME desktop environment, an attractive and intuitive desktop for users, and the GNOME development platform, an extensive framework for building applications that integrate into the rest of the desktop. GNOME is free, usable, accessible, international, developer-friendly, organized, supported, and a community. https://wiki.archlinux.org/index.php/GNOME"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-9"    "GNOME DE Extras"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-9-I"      "Gnome Desktop Extras Sub Menu: GNOME Icons, GTK Themes and even Unity"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-10"   "Window Managers"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-10-I"     "Window Managers: A Window Manager (WM) [Awesome, Openbox] is one component of a system's graphical user interface (GUI). Users may prefer to install a full-fledged Desktop Environment, which provides a complete user interface, including icons, windows, toolbars, wallpapers, and desktop widgets. https://wiki.archlinux.org/index.php/Window_Manager"
    #
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-REC"       "Recommended Options"
fi
# -------------------------------------
install_desktop_environment_menu() 
{ 
    # 2
    local -r menu_name="DESKTOP-ENVIRONMENT"  # You must define Menu Name here
    local BreakableKey="D"                    # Q=Quit, D=Done, B=Back
    local RecommendedOptions="4 10"           # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    if [[ "$CUSTOM_DE" -eq 1 ]]; then         # Mate
        RecommendedOptions="1"
    elif [[ "$CUSTOM_DE" -eq 2 ]]; then       # KDE
        RecommendedOptions="2"
    elif [[ "$CUSTOM_DE" -eq 3 ]]; then       # XFCE
        RecommendedOptions="3"
    elif [[ "$CUSTOM_DE" -eq 4 ]]; then       # Razor-QT & Openbox
        RecommendedOptions="4 10"
    elif [[ "$CUSTOM_DE" -eq 5 ]]; then       # Cinnamon
        RecommendedOptions="5"
    elif [[ "$CUSTOM_DE" -eq 6 ]]; then       # Awesome
        RecommendedOptions="10"
    fi
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-DESKTOP-ENVIRONMENT-TITLE" " - https://wiki.archlinux.org/index.php/Desktop_Environment"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_this  "INSTALL-DESKTOP-ENVIRONMENT-INFO-1"
        print_this  "INSTALL-DESKTOP-ENVIRONMENT-INFO-2"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-ENVIRONMENT-MENU-1"  "INSTALL-DESKTOP-ENVIRONMENT-MENU-1-D" "INSTALL-DESKTOP-ENVIRONMENT-MENU-1-W" "INSTALL-DESKTOP-ENVIRONMENT-MENU-1-I"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-ENVIRONMENT-MENU-2"  ""                                     ""                                     "INSTALL-DESKTOP-ENVIRONMENT-MENU-2-I"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-ENVIRONMENT-MENU-3"  ""                                     ""                                     "INSTALL-DESKTOP-ENVIRONMENT-MENU-3-I"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-ENVIRONMENT-MENU-4"  ""                                     ""                                     "INSTALL-DESKTOP-ENVIRONMENT-MENU-4-I"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-ENVIRONMENT-MENU-5"  ""                                     "$AUR"                                 "INSTALL-DESKTOP-ENVIRONMENT-MENU-5-I"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-ENVIRONMENT-MENU-6"  ""                                     ""                                     "INSTALL-DESKTOP-ENVIRONMENT-MENU-6-I"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-ENVIRONMENT-MENU-7"  ""                                     ""                                     "INSTALL-DESKTOP-ENVIRONMENT-MENU-7-I"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-ENVIRONMENT-MENU-8"  ""                                     ""                                     "INSTALL-DESKTOP-ENVIRONMENT-MENU-8-I"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-ENVIRONMENT-MENU-9"  ""                                     "$AUR"                                 "INSTALL-DESKTOP-ENVIRONMENT-MENU-9-I"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-ENVIRONMENT-MENU-10" ""                                     ""                                     "INSTALL-DESKTOP-ENVIRONMENT-MENU-10-I" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        BYPASS="$Old_BYPASS" # Restore Bypass
        INSTALL_WIZARD="$1"
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Mate
                    MenuChecks[$((S_OPT - 1))]=1
                    install_mate_now
                    # Progress Status
                    StatusBar1="INSTALL-DESKTOP-ENVIRONMENT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # KDE
                    MenuChecks[$((S_OPT - 1))]=1
                    install_kde_menu
                    # Progress Status
                    StatusBar1="INSTALL-DESKTOP-ENVIRONMENT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # XFCE
                    MenuChecks[$((S_OPT - 1))]=1
                    install_xfce_menu
                    # Progress Status
                    StatusBar1="INSTALL-DESKTOP-ENVIRONMENT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Razor-qt
                    MenuChecks[$((S_OPT - 1))]=1
                    install_razor_qt_common
                    # Progress Status
                    StatusBar1="INSTALL-DESKTOP-ENVIRONMENT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Cinnamon
                    MenuChecks[$((S_OPT - 1))]=1
                    install_cinnamon_menu
                    # Progress Status
                    StatusBar1="INSTALL-DESKTOP-ENVIRONMENT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # E17
                    MenuChecks[$((S_OPT - 1))]=1
                    install_e17_menu
                    # Progress Status
                    StatusBar1="INSTALL-DESKTOP-ENVIRONMENT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # LXDE
                    MenuChecks[$((S_OPT - 1))]=1
                    install_lxde_common
                    # Progress Status
                    StatusBar1="INSTALL-DESKTOP-ENVIRONMENT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # GNOME
                    MenuChecks[$((S_OPT - 1))]=1
                    install_gnome_menu
                    # Progress Status
                    StatusBar1="INSTALL-DESKTOP-ENVIRONMENT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # GNOME DE Extras
                    MenuChecks[$((S_OPT - 1))]=1
                    install_gnome_de_extras_menu
                    # Progress Status
                    StatusBar1="INSTALL-DESKTOP-ENVIRONMENT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               10)  # Window Managers
                    MenuChecks[$((S_OPT - 1))]=1
                    install_window_manager_menu
                    # Progress Status
                    StatusBar1="INSTALL-DESKTOP-ENVIRONMENT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL 
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
    #
    # @FIX Things to do
    # Needs a WM: openbox 
    # Lots of work to get ROX to work
    # ROX is a fast, user friendly desktop which makes extensive use of drag-and-drop. The interface revolves around the file manager, following the traditional UNIX view that 'everything is a file' rather than trying to hide the filesystem beneath start menus, wizards, or druids. The aim is to make a system that is well designed and clearly presented. The ROX style favors using several small programs together instead of creating all-in-one mega-applications.  
    # https://wiki.archlinux.org/index.php/ROX
    # rox python gnupg pygtk
    # gpg --recv-key --keyserver www.keyserver.net 59A53CC1
    # wget http://osdn.dl.sourceforge.net/sourceforge/zero-install/zeroinstall-injector-0.26.tar.gz.gpg 
    # python setup.py install
    # rox -b Default -p default ; exec openbox
    #
    # Lots of work
    # The Sugar Learning Platform is a computer environment composed of Activities designed to help children from 5 to 12 years of age learn together through rich-media expression. Sugar is the core component of a worldwide effort to provide every child with the opportunity for a quality education — it is currently used by nearly one-million children worldwide speaking 25 languages in over 40 countries. Sugar provides the means to help people lead fulfilling lives through access to a quality education that is currently missed by so many.   
    # https://wiki.archlinux.org/index.php/Sugar
    # AUR: sugar
    #
    #
    #
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL WINDOW MANAGER {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_window_manager_menu"
    USAGE="install_window_manager_menu"
    DESCRIPTION=$(localize "INSTALL-WINDOW-MANAGER-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-WINDOW-MANAGER-DESC"    "Install Window Manager"
    localize_info "INSTALL-WINDOW-MANAGER-TITLE"   "Window Environment"
    localize_info "INSTALL-WINDOW-MANAGER-INFO-1"  "A Desktop environments (DE) provide a complete graphical user interface (GUI) for a system by bundling together a variety of X clients written using a common widget toolkit and set of libraries."
    localize_info "INSTALL-WINDOW-MANAGER-INFO-2"  "Mate, KDE, XFCE, Awesome, Cinnamon, E17, LXDE, OpenBox, GNOME, and Unity"
    #
    localize_info "INSTALL-WINDOW-MANAGER-MENU-1"    "Awesome"
    localize_info "INSTALL-WINDOW-MANAGER-MENU-1-I"      "Awesome: awesome is a highly configurable, next generation framework window manager for X. It is very fast, extensible and licensed under the GNU GPLv2 license. Configured in Lua, it has a system tray, information bar, and launcher built in. There are extensions available to it written in Lua. Awesome uses XCB as opposed to Xlib, which may result in a speed increase. Awesome has other features as well, such as an early replacement for notification-daemon, a right-click menu similar to that of the *box window managers, and many other things."
    localize_info "INSTALL-WINDOW-MANAGER-MENU-2"    "OpenBox"
    localize_info "INSTALL-WINDOW-MANAGER-MENU-2-I"      "OpenBox: Openbox is a lightweight and highly configurable window manager with extensive standards support. Its features are documented at the official website. This article pertains to installing Openbox under Arch Linux."
    #
    localize_info "INSTALL-WINDOW-MANAGER-REC"       "Recommended Options"
fi
# -------------------------------------
install_window_manager_menu() 
{ 
    # 2
    local -r menu_name="WINDOW-MANAGER"  # You must define Menu Name here
    local BreakableKey="D"                    # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"              # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    if [[ "$CUSTOM_DE" -eq 1 ]]; then         # Mate
        RecommendedOptions=""
    elif [[ "$CUSTOM_DE" -eq 2 ]]; then       # KDE
        RecommendedOptions=""
    elif [[ "$CUSTOM_DE" -eq 3 ]]; then       # XFCE
        RecommendedOptions=""
    elif [[ "$CUSTOM_DE" -eq 4 ]]; then       # Razor-QT & Openbox
        RecommendedOptions="2"
    elif [[ "$CUSTOM_DE" -eq 5 ]]; then       # Cinnamon
        RecommendedOptions=""
    elif [[ "$CUSTOM_DE" -eq 6 ]]; then       # Awesome
        RecommendedOptions="1"
    fi
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-WINDOW-MANAGER-TITLE" " - https://wiki.archlinux.org/index.php/Window_Manager"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_this  "INSTALL-WINDOW-MANAGER-INFO-1"
        print_this  "INSTALL-WINDOW-MANAGER-INFO-2"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-WINDOW-MANAGER-MENU-1"  "" ""     "INSTALL-WINDOW-MANAGER-MENU-1-I"  "MenuTheme[@]" # Awesome
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-WINDOW-MANAGER-MENU-2"  "" "$AUR" "INSTALL-WINDOW-MANAGER-MENU-2-I"  "MenuTheme[@]" # OpenBox
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Awesome
                    MenuChecks[$((S_OPT - 1))]=1
                    install_awesome_common
                    # Progress Status
                    StatusBar1="INSTALL-WINDOW-MANAGER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # OpenBox
                    MenuChecks[$((S_OPT - 1))]=1
                    install_openbox_common
                    # Progress Status
                    StatusBar1="INSTALL-WINDOW-MANAGER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL 
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
    # 
    # @FIX Things to do
    # Fluxbox 
    # Enlightenment
    # Metacity
    # Compiz 
    # twm
    # Window Maker
    # 
    #
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL MATE NOW {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_mate_now"
    USAGE="install_mate_now"
    DESCRIPTION=$(localize "INSTALL-MATE-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-MATE-DESC"    "Installs Mate Desktop."
    localize_info "INSTALL-MATE-TITLE"   "Mate"
    localize_info "INSTALL-MATE-INFO-1"  "Install Mate Desktop - Recommended over Gnome, its like Gnome 2, without the Crazy Gnome 3 stuff."
    localize_info "INSTALL-MATE-INFO-2"  "Full List"
fi
# -------------------------------------
install_mate_now()
{
    # 1
    # http://mate-desktop.org/ Perberos initially forked Gnome 2
    # https://www.archlinux.org/packages/extra/i686/gvfs/
    # gvfs-afc (optional) - AFC (mobile devices) support
    # gvfs-afp (optional) - Apple Filing Protocol (AFP) support
    # gvfs-gphoto2 (optional) - gphoto2 (PTP camera/MTP media player) support
    # gvfs-obexftp (optional) - ObexFTP (bluetooth) support
    # gvfs-smb (optional) - SMB/CIFS (Windows client) support    
    print_title "INSTALL-MATE-TITLE" " - https://wiki.archlinux.org/index.php/MATE"
    print_info  "INSTALL-MATE-INFO-1"
    print_info  "INSTALL-MATE-INFO-2" ": $INSTALL_MATE" 
    MATE_INSTALLED=1
    GNOME_INSTALL=1
    add_taskmanager "add_repo \"mate\" \"http://repo.mate-desktop.org/archlinux/\" \"Optional TrustedOnly\" 1" "ADD-REPO-MATE"
    add_packagemanager "package_remove 'zenity'" "REMOVE-MATE" # mate replacement
    if add_packagemanager "package_install \"$INSTALL_MATE\" 'INSTALL-MATE'" "INSTALL-MATE" ; then
        add_package        "$INSTALL_MATE"
        add_packagemanager "systemctl enable polkit.service"          "SYSTEMD-ENABLE-MATE-3"
        add_packagemanager "systemctl enable accounts-daemon.service" "SYSTEMD-ENABLE-MATE-1"
        add_packagemanager "systemctl enable upower.service"          "SYSTEMD-ENABLE-MATE-2"
    fi
    # polkit.service
    # systemd-logind replaced console-kit-daemon.service
    # pacstrap will overwrite pacman.conf so copy it to temp 
    # copy_file ${MOUNTPOINT}/etc/pacman.conf "${FULL_SCRIPT_PATH}"/etc/pacman.conf "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL KDE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_kde_menu"
    USAGE="install_kde_menu"
    DESCRIPTION=$(localize "INSTALL-KDE-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-KDE-DESC"    "Install KDE"
    localize_info "INSTALL-KDE-TITLE"   "KDE Customization"
    localize_info "INSTALL-KDE-INFO-1"  "KDE is an international free software community producing an integrated set of cross-platform applications designed to run on Linux, FreeBSD, Microsoft Windows, Solaris and Mac OS X systems. It is known for its Plasma Desktop, a desktop environment provided as the default working environment on many Linux distributions."
    #
    localize_info "INSTALL-KDE-MENU-1"   "apper"
    localize_info "INSTALL-KDE-MENU-I-1"        "apper: KDE tools for PackageKit"
    localize_info "INSTALL-KDE-MENU-2"   "bangarang"
    localize_info "INSTALL-KDE-MENU-I-2"        "bangarang: Simple KDE media player. AUR"
    localize_info "INSTALL-KDE-MENU-3"   "choqok"
    localize_info "INSTALL-KDE-MENU-I-3"        "choqok: A Twitter/identi.ca/laconica client for KDE"
    localize_info "INSTALL-KDE-MENU-4"   "digikam"
    localize_info "INSTALL-KDE-MENU-I-4"        "digikam: Digital photo management application for KDE"
    localize_info "INSTALL-KDE-MENU-5"   "k3b"
    localize_info "INSTALL-KDE-MENU-I-5"        "k3b: Feature-rich and easy to handle CD burning application"
    localize_info "INSTALL-KDE-MENU-6"   "rosa-icons"
    localize_info "INSTALL-KDE-MENU-I-6"        "rosa-icons: ROSA icons theme. AUR"
    localize_info "INSTALL-KDE-MENU-7"   "Plasma Themes"
    localize_info "INSTALL-KDE-MENU-I-7"        "Plasma Themes: caledonia-bundle, plasma-theme-rosa, ronak-plasmatheme"
    localize_info "INSTALL-KDE-MENU-8"   "yakuake"
    localize_info "INSTALL-KDE-MENU-I-8"        "yakuake: A drop-down terminal emulator based on KDE konsole technology"
fi
# -------------------------------------
install_kde_menu()
{
    # 2
    local -r menu_name="INSTALL-KDE"   # You must define Menu Name here
    local BreakableKey="D"             # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 4 5 7" # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions 3"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 3"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 3 8"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    if add_packagemanager "package_install \"$INSTALL_KDE\" 'INSTALL-KDE'" "INSTALL-KDE" ; then # "kde-telepathy telepathy"
        add_package "$INSTALL_KDE"
    fi
    if [[ "$PHONON" -eq 0 ]]; then
        if add_packagemanager "package_install \"$INSTALL_PHONON\" 'INSTALL-PHONON'" "INSTALL-PHONON"  ; then
            add_package "$INSTALL_PHONON"
        fi
    else
        if add_packagemanager "package_install \"$INSTALL_PHONON_VLC\" 'INSTALL-PHONON_VLC'" "INSTALL-PHONON_VLC" ; then
            add_package "$INSTALL_PHONON_VLC"
        fi
    fi
    #if add_packagemanager "package_remove 'kdemultimedia-kscd kdemultimedia-juk'" "REMOVE-KDE"
    if add_packagemanager "aur_package_install \"$AUR_INSTALL_KDE\" 'AUR-INSTALL-KDE'" "AUR-INSTALL-KDE" ; then
        add_aur_package "$AUR_INSTALL_KDE"
    fi
    #
    CONFIG_KDE=1
    KDE_INSTALLED=1
    QT_INSTALL=1
    # Application development toolkit for controlling system-wide privileges
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    # polkit.service
    # systemd-logind replaced console-kit-daemon.service
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-KDE-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info "INSTALL-KDE-INFO-1"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-KDE-MENU-1" "" ""     "INSTALL-KDE-MENU-I-1" "MenuTheme[@]" # 1 apper
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-KDE-MENU-2" "" "$AUR" "INSTALL-KDE-MENU-I-2" "MenuTheme[@]" # 2 bangarang
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-KDE-MENU-3" "" ""     "INSTALL-KDE-MENU-I-3" "MenuTheme[@]" # 3 choqok
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-KDE-MENU-4" "" ""     "INSTALL-KDE-MENU-I-4" "MenuTheme[@]" # 4 digikam
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-KDE-MENU-5" "" ""     "INSTALL-KDE-MENU-I-5" "MenuTheme[@]" # 5 k3b
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-KDE-MENU-6" "" "$AUR" "INSTALL-KDE-MENU-I-6" "MenuTheme[@]" # 6 rosa-icons
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-KDE-MENU-7" "" ""     "INSTALL-KDE-MENU-I-7" "MenuTheme[@]" # 7 Plasma Themes
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-KDE-MENU-8" "" ""     "INSTALL-KDE-MENU-I-8" "MenuTheme[@]" # 8 yakuake
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #        
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # apper
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_APPER\" 'INSTALL-APPER'" "INSTALL-APPER" ; then
                        add_package "$INSTALL_APPER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-KDE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # bangarang
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_BANGARANG\" 'AUR-INSTALL-BANGARANG'" "AUR-INSTALL-BANGARANG" ; then
                        add_aur_package "$AUR_INSTALL_BANGARANG"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-KDE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # choqok
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_CHOQOK\" 'INSTALL-CHOQOK'" "INSTALL-CHOQOK" ; then
                        add_package "$INSTALL_CHOQOK"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-KDE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # digikam
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_DIGIKAM\" 'INSTALL-DIGIKAM'" "INSTALL-DIGIKAM" ; then
                        add_package "$INSTALL_DIGIKAM"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-KDE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # k3b
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_K3B\" 'INSTALL-K3B'" "INSTALL-K3B" ; then
                        add_package "$INSTALL_K3B"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-KDE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # rosa-icons
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ROSA_ICONS\" 'AUR-INSTALL-ROSA-ICONS'" "AUR-INSTALL-ROSA-ICONS" ; then
                        add_aur_package "$AUR_INSTALL_ROSA_ICONS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-KDE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # Plasma Themes
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_PLASMA_THEMES\" 'AUR-INSTALL-PLASMA-THEMES'" "AUR-INSTALL-PLASMA-THEMES" ; then
                        add_aur_package "$AUR_INSTALL_PLASMA_THEMES"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-KDE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # yakuake
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_YAKUAKE\" 'INSTALL-YAKUAKE'" "INSTALL-YAKUAKE" ; then
                        add_package "$INSTALL_YAKUAKE"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_YAKUAKE\" 'AUR-INSTALL-YAKUAKE'" "AUR-INSTALL-YAKUAKE" ; then
                        add_aur_package "$AUR_INSTALL_YAKUAKE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-KDE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL 
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
# -----------------------------------------------------------------------------
# INSTALL GNOME {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_gnome_menu"
    USAGE="install_gnome_menu"
    DESCRIPTION=$(localize "INSTALL-GNOME-DESC")
    NOTES=$(localize "INSTALL-GNOME-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-GNOME-DESC"      "Install Gnome"
    localize_info "INSTALL-GNOME-NOTES"     "None."
    localize_info "INSTALL-GNOME-TITLE"     "GNOME Customization"
    #
    localize_info "INSTALL-GNOME-TITLE"     "GNOME"
    localize_info "INSTALL-GNOME-INFO-1"    "GNOME is a desktop environment and graphical user interface that runs on top of a computer operating system. It is composed entirely of free and open source software. It is an international project that includes creating software development frameworks, selecting application software for the desktop, and working on the programs that manage application launching, file handling, and window and task management."
    localize_info "INSTALL-GNOME-INFO-2"    "GNOME Shell Extensions: disper gpaste gnome-shell-extension-gtile-git gnome-shell-extension-mediaplayer-git gnome-shell-extension-noa11y-git gnome-shell-extension-pomodoro-git gnome-shell-extension-user-theme-git gnome-shell-extension-weather-git gnome-shell-system-monitor-applet-git"
    localize_info "INSTALL-GNOME-INFO-3"    "GNOME Shell Themes: gnome-shell-theme-default-mod gnome-shell-theme-dark-shine gnome-shell-theme-elegance gnome-shell-theme-eos gnome-shell-theme-frieze gnome-shell-theme-google+"
    #
    localize_info "INSTALL-GNOME-MENU-1"    "GNOME Shell Extensions"
    localize_info "INSTALL-GNOME-MENU-I-1"        "GNOME Shell Extensions: Sub Menu: User-created extensions for the GNOME Shell environment"
    localize_info "INSTALL-GNOME-MENU-2"    "GNOME Shell Themes"
    localize_info "INSTALL-GNOME-MENU-I-2"        "GNOME Shell Themes: Sub Menu"
    localize_info "INSTALL-GNOME-MENU-3"    "GNOME Packagekit"
    localize_info "INSTALL-GNOME-MENU-I-3"        "GNOME Packagekit: Collection of graphical tools for PackageKit to be used in the GNOME desktop"
    localize_info "INSTALL-GNOME-MENU-4"    "activity-journal"
    localize_info "INSTALL-GNOME-MENU-I-4"        "activity-journal: Tool for easily browsing and finding files on your computer using the Zeitgeist engine"
    localize_info "INSTALL-GNOME-MENU-5"    "activity-log-manager"
    localize_info "INSTALL-GNOME-MENU-I-5"        "activity-log-manager: A graphical user interface which lets you easily control what gets logged by Zeitgeist"
    localize_info "INSTALL-GNOME-MENU-6"    "gloobus-sushi-bzr"
    localize_info "INSTALL-GNOME-MENU-I-6"        "gloobus-sushi-bzr: GloobusPreview replacement for Gnome Sushi"
fi
# -------------------------------------
install_gnome_menu()
{
    # 9
    local -r menu_name="INSTALL-GNOME"  # You must define Menu Name here
    local BreakableKey="D"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-5"      # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    GNOME_INSTALLED=1
    CONFIG_GNOME=1
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    print_title "INSTALL-GNOME-TITLE" " - https://wiki.archlinux.org/index.php/GNOME"
    print_info  "INSTALL-GNOME-INFO-1"
    print_info  "INSTALL-GNOME-INFO-2"
    print_info  "INSTALL-GNOME-INFO-3"
    if add_packagemanager "package_install \"$INSTALL_GNOME\" 'INSTALL-GNOME'" "INSTALL-GNOME" ; then
        add_package "$INSTALL_GNOME" 
        #Gnome Display Manager (a reimplementation of xdm)
        #D-Bus interface for user account query and manipulation
        #Application development toolkit for controlling system-wide privileges
        #Abstraction for enumerating power devices, listening to device events and querying history and statistics
        #A framework for defining and tracking users, login sessions, and seats
        # polkit.service
        # systemd-logind replaced console-kit-daemon.service
        add_packagemanager "systemctl enable accounts-daemon.service" "SYSTEMD-ENABLE-GNOME-1"
        add_packagemanager "systemctl upower.service" "SYSTEMD-ENABLE-GNOME-2"
    fi
    # telepathy
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-GNOME-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOME-MENU-1" "" "$AUR" "INSTALL-GNOME-MENU-I-1" "MenuTheme[@]" # 1 GNOME Shell Extensions
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOME-MENU-2" "" ""     "INSTALL-GNOME-MENU-I-2" "MenuTheme[@]" # 2 GNOME Shell Themes
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOME-MENU-3" "" ""     "INSTALL-GNOME-MENU-I-3" "MenuTheme[@]" # 3 GNOME Packagekit
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOME-MENU-4" "" "$AUR" "INSTALL-GNOME-MENU-I-4" "MenuTheme[@]" # 4 activity-journal 
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOME-MENU-5" "" "$AUR" "INSTALL-GNOME-MENU-I-5" "MenuTheme[@]" # 5 activity-log-manager
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOME-MENU-6" "" "$AUR" "INSTALL-GNOME-MENU-I-6" "MenuTheme[@]" # 6 gloobus-sushi-bzr
        #
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # GNOME Shell Extensions
                    MenuChecks[$((S_OPT - 1))]=1
                    install_gnome_menushell_extensions_menu
                    # Progress Status
                    StatusBar1="INSTALL-GNOME-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # GNOME Shell Themes
                    MenuChecks[$((S_OPT - 1))]=1
                    install_gnome_menushell_themes_menu
                    # Progress Status
                    StatusBar1="INSTALL-GNOME-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # GNOME Packagekit
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GNOME_PACKAGEKIT\" 'INSTALL-GNOME-PACKAGEKIT'" "INSTALL-GNOME-PACKAGEKIT" ; then
                        add_package "$INSTALL_GNOME_PACKAGEKIT"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOME-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # activity-journal
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_CUSTOM_ACT_JOURNAL\" 'AUR-INSTALL-GNOME-CUSTOM-ACT-JOURNAL'" "AUR-INSTALL-GNOME-CUSTOM-ACT-JOURNAL" ; then
                        add_aur_package "$AUR_INSTALL_GNOME_CUSTOM_ACT_JOURNAL"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOME-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # activity-log-manager
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_CUSTOM_ACT_LOG_MANAGER\" 'AUR-INSTALL-GNOME-CUSTOM-ACT-LOG-MANAGER'" "AUR-INSTALL-GNOME-CUSTOM-ACT-LOG-MANAGER" ; then
                        add_aur_package "$AUR_INSTALL_GNOME_CUSTOM_ACT_LOG_MANAGER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOME-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # gloobus-sushi-bzr
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_CUSTOM_GLOOBUS\" 'AUR-INSTALL-GNOME-CUSTOM-GLOOBUS'" "AUR-INSTALL-GNOME-CUSTOM-GLOOBUS" ; then
                        add_aur_package "$AUR_INSTALL_GNOME_CUSTOM_GLOOBUS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOME-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL 
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        S_OPT="$BreakableKey"
                        break;
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
    #}}}
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL GNOMESHELL EXTENSIONS  {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_gnome_menushell_extensions_menu"
    USAGE="install_gnome_menushell_extensions_menu"
    DESCRIPTION=$(localize "INSTALL-GNOMESHELL-EXTENSIONS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-DESC"     "Install Gnomeshell Extensions"
    #
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-1"   "Disper"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-1"      "disper: An on-the-fly display switch utility, intended to be used on laptops, especially with nVidia cards."
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-2"   "Gpaste"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-2"      "gpaste: Clipboard management system with a gnome-shell extension"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-3"   "Mediaplayer"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-3"      "mediaplayer: A mediaplayer indicator for the Gnome Shell"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-4"   "Noa11y"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-4"      "noa11y: A gnome-shell extension to remove the accessibility icon from the panel"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-5"   "Pomodoro"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-5"      "pomodoro: GNOME Shell extension for pomodoro technique."
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-6"   "System-monitor-applet"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-6"      "System-monitor-applet: System monitor extension for Gnome-Shell (display mem swap cpu usage)"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-7"   "User-theme"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-7"      "user-theme: Allows a custom shell theme to be loaded."
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-8"   "Weather"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-8"      "weather: A GNOME Shell extension for displaying weather notifications"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-9"   "Gtile"
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-9"      "gtile: A GNOME Shell Extension to tile your windows as you like. It even supports multiscreen"
fi
# -------------------------------------
install_gnome_menushell_extensions_menu()
{
    local -r menu_name="INSTALL-GNOMESHELL-EXTENSIONS"  # You must define Menu Name here
    local BreakableKey="B"                              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-3 7 8"                  # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 9"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-GNOMESHELL-EXTENSIONS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-1" "" "$AUR" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-1" "MenuTheme[@]" # 1 disper
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-2" "" "$AUR" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-2" "MenuTheme[@]" # 2 gpaste
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-3" "" "$AUR" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-3" "MenuTheme[@]" # 3 mediaplayer
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-4" "" "$AUR" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-4" "MenuTheme[@]" # 4 noa11y
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-5" "" "$AUR" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-5" "MenuTheme[@]" # 5 pomodoro
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-6" "" "$AUR" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-6" "MenuTheme[@]" # 6 System-monitor-applet
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-7" "" "$AUR" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-7" "MenuTheme[@]" # 7 user-theme
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-8" "" "$AUR" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-8" "MenuTheme[@]" # 8 weather
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-9" "" "$AUR" "INSTALL-GNOMESHELL-EXTENSIONS-MENU-I-9" "MenuTheme[@]" # 9 gtile
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # disper
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_DISPER\" 'AUR-INSTALL-GSHELL-DISPER'" "AUR-INSTALL-GSHELL-DISPER" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_DISPER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-EXTENSIONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # gpaste
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_GPASTE\" 'AUR-INSTALL-GSHELL-GPASTE'" "AUR-INSTALL-GSHELL-GPASTE" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_GPASTE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-EXTENSIONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # mediaplayer
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_MEDIAPLAYER\" 'AUR-INSTALL-GSHELL-MEDIAPLAYER'" "AUR-INSTALL-GSHELL-MEDIAPLAYER" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_MEDIAPLAYER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-EXTENSIONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # noa11y
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_NOA11Y\" 'AUR-INSTALL-GSHELL-NOA11Y'" "AUR-INSTALL-GSHELL-NOA11Y" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_NOA11Y"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-EXTENSIONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # pomodoro
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_POMODORO\" 'AUR-INSTALL-GSHELL-POMODORO'" "AUR-INSTALL-GSHELL-POMODORO" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_POMODORO"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-EXTENSIONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # System-monitor-applet
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_SYSTEM_MONITOR\" 'AUR-INSTALL-GSHELL-SYSTEM-MONITOR'" "AUR-INSTALL-GSHELL-SYSTEM-MONITOR" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_SYSTEM_MONITOR"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-EXTENSIONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # user-theme
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_USER_THEME\" 'AUR-INSTALL-GSHELL-USER-THEME'" "AUR-INSTALL-GSHELL-USER-THEME" ; then
                        add_aur_package "$AUR_INSTALL_USER_THEME"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-EXTENSIONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # weather
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_WEATHER\" 'AUR-INSTALL-GSHELL-WEATHER'" "AUR-INSTALL-GSHELL-WEATHER" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_WEATHER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-EXTENSIONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # gtile
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_GTILE\" 'AUR-INSTALL-GSHELL-GTILE'" "AUR-INSTALL-GSHELL-GTILE" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_GTILE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-EXTENSIONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL 
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL GNOMESHELL THEMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_gnome_menushell_themes_menu"
    USAGE="install_gnome_menushell_themes_menu"
    DESCRIPTION=$(localize "INSTALL-GNOMESHELL-THEMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-GNOMESHELL-THEMES-DESC"   "Install Gnomeshell Themes"
    #
    localize_info "INSTALL-GNOMESHELL-THEMES-MENU-1"   "default-mod"
    localize_info "INSTALL-GNOMESHELL-THEMES-MENU-I-1"       "default-mod: A GNOME Shell theme based on the stock GTK theme. gnome-shell-theme-default-mod"
    localize_info "INSTALL-GNOMESHELL-THEMES-MENU-2"   "dark-shine"
    localize_info "INSTALL-GNOMESHELL-THEMES-MENU-I-2"       "dark-shine: Dark variant of the shine theme. gnome-shell-theme-dark-shine"
    localize_info "INSTALL-GNOMESHELL-THEMES-MENU-3"   "elegance"
    localize_info "INSTALL-GNOMESHELL-THEMES-MENU-I-3"       "elegance: A clean and elegant HUD theme for Gnome Shell 3.6. gnome-shell-theme-elegance"
    localize_info "INSTALL-GNOMESHELL-THEMES-MENU-4"   "eos"
    localize_info "INSTALL-GNOMESHELL-THEMES-MENU-I-4"       "eos: This is a GNOME Shell theme based on the Elementary GTK2 theme. gnome-shell-theme-eos"
    localize_info "INSTALL-GNOMESHELL-THEMES-MENU-5"   "frieze"
    localize_info "INSTALL-GNOMESHELL-THEMES-MENU-I-5"       "frieze: Gnome Shell + GDM Theme. gnome-shell-theme-frieze"
    localize_info "INSTALL-GNOMESHELL-THEMES-MENU-6"   "google"
    localize_info "INSTALL-GNOMESHELL-THEMES-MENU-I-6"       "google: A Gnome-Shell theme by plaidcounty, based on the Google color schema. gnome-shell-theme-google"
fi
# -------------------------------------
install_gnome_menushell_themes_menu()
{
    local -r menu_name="INSTALL-GNOMESHELL-THEMES"  # You must define Menu Name here
    local BreakableKey="B"                          # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-6"                  # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-GNOMESHELL-THEMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-THEMES-MENU-1" "" "$AUR" "INSTALL-GNOMESHELL-THEMES-MENU-I-1" "MenuTheme[@]" # 1 default-mod
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-THEMES-MENU-2" "" "$AUR" "INSTALL-GNOMESHELL-THEMES-MENU-I-2" "MenuTheme[@]" # 2 dark-shine
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-THEMES-MENU-3" "" "$AUR" "INSTALL-GNOMESHELL-THEMES-MENU-I-3" "MenuTheme[@]" # 3 elegance
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-THEMES-MENU-4" "" "$AUR" "INSTALL-GNOMESHELL-THEMES-MENU-I-4" "MenuTheme[@]" # 4 eos
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-THEMES-MENU-5" "" "$AUR" "INSTALL-GNOMESHELL-THEMES-MENU-I-5" "MenuTheme[@]" # 5 frieze
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOMESHELL-THEMES-MENU-6" "" "$AUR" "INSTALL-GNOMESHELL-THEMES-MENU-I-6" "MenuTheme[@]" # 6 google
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # default-mod
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_DEFAULT\" 'AUR-INSTALL-GSHELL-THEMES-DEFAULT'" "AUR-INSTALL-GSHELL-THEMES-DEFAULT" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_THEMES_DEFAULT"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # dark-shine
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_DARK_SHINE\" 'AUR-INSTALL-GSHELL-THEMES-DARK-SHINE'" "AUR-INSTALL-GSHELL-THEMES-DARK-SHINE" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_THEMES_DARK_SHINE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # elegance
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_ELEGANCE\" 'AUR-INSTALL-GSHELL-THEMES-ELEGANCE'" "AUR-INSTALL-GSHELL-THEMES-ELEGANCE" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_THEMES_ELEGANCE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # eos
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_EOS\" 'AUR-INSTALL-GSHELL-THEMES-EOS'" "AUR-INSTALL-GSHELL-THEMES-EOS" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_THEMES_EOS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # frieze
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_FRIEZE\" 'AUR-INSTALL-GSHELL-THEMES-FRIEZE'" "AUR-INSTALL-GSHELL-THEMES-FRIEZE" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_THEMES_FRIEZE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # gnome-shell-theme-google
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_GOOGLE\" 'AUR-INSTALL-GSHELL-THEMES-GOOGLE'" "AUR-INSTALL-GSHELL-THEMES-GOOGLE" ; then
                        add_aur_package "$AUR_INSTALL_GSHELL_THEMES_GOOGLE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GNOMESHELL-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL 
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL AWESOME {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_awesome_common"
    USAGE="install_awesome_common"
    DESCRIPTION=$(localize "INSTALL-AWESOME-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-AWESOME-DESC"   "Install Awesome"
    localize_info "INSTALL-AWESOME-TITLE"  "AWESOME"
    localize_info "INSTALL-AWESOME-INFO-1" "awesome is a highly configurable, next generation framework window manager for X. It is very fast, extensible and licensed under the GNU GPLv2 license."
    localize_info "INSTALL-AWESOME-INFO-2" "AWESOME CUSTOMIZATION"
    localize_info "INSTALL-AWESOME-REC"    "Recommended Options"
    #
fi
# -------------------------------------
install_awesome_common() # Where Common is Menu install_common_apps_menu
{
    # 4
    local RecommendedOptions="4 6"        # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 1-14"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 1-14"    
    fi
    # @FIX Make a function that creates the Menu System
    # https://github.com/terceiro/awesome-freedesktop
    # http://awesome.naquadah.org/wiki/Revelation
    # http://awesome.naquadah.org/wiki/Quickly_Setting_up_Awesome_with_Gnome
    # http://awesome.naquadah.org/wiki/Beautiful
    # http://awesome.naquadah.org/wiki/Beautiful_themes
    # https://www.archlinux.org/packages/community/x86_64/awesome/
    # https://aur.archlinux.org/packages/awesome-wm-themes-collection/ awesome-wm-themes-collection flaged out of date as of 12 Jan 2012
    # https://aur.archlinux.org/packages.php?ID=49949 awesome-themes-git
    # https://github.com/mikar/awesome-themes 2 years old
    #
    if add_packagemanager "package_install \"$INSTALL_AWESOME\" 'INSTALL-AWESOME'" "INSTALL-AWESOME" ; then
        AWESOME_INSTALLED=1
        add_package "$INSTALL_AWESOME"
        # Abstraction for enumerating power devices, listening to device events and querying history and statistics
        # A framework for defining and tracking users, login sessions, and seats
        # systemd-logind replaced console-kit-daemon.service
        "systemctl enable upower.service" "SYSTEMD-ENABLE-AWESOME"
        if add_packagemanager "aur_package_install \"$AUR_INSTALL_AWESOME\" 'AUR-INSTALL-AWESOME'" "AUR-INSTALL-AWESOME" ; then
            add_aur_package "$AUR_INSTALL_AWESOME"
            add_packagemanager "make_dir \"/home/$USERNAME/.config/awesome/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/awesome/rc.lua' \"/home/$USERNAME/.config/awesome/\" \"$(basename $BASH_SOURCE) : $LINENO\"; chown -R $USERNAME:$USERNAME /home/$USERNAME/.config" "CONFIG-AWESOME"   
        fi
        #
        install_common_apps_menu "$RecommendedOptions" "$(localize "INSTALL-AWESOME-DESC")"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL OPENBOX {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_openbox_common"
    USAGE="install_openbox_common"
    DESCRIPTION=$(localize "INSTALL-OPENBOX-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-OPENBOX-DESC"      "Install Openbox"
    localize_info "INSTALL-OPENBOX-TITLE"     "OPENBOX"
    localize_info "INSTALL-OPENBOX-INFO-1"    "Openbox is a lightweight and highly configurable window manager with extensive standards support."
    localize_info "INSTALL-OPENBOX-INFO-2"    "OPENBOX CUSTOMIZATION"
fi
# -------------------------------------
install_openbox_common() # Where Common is Menu install_common_apps_menu
{ 
    # 8
    local RecommendedOptions="4 6"        # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$CUSTOM_DE" -eq 1 ]]; then         # Mate
        RecommendedOptions=""
    elif [[ "$CUSTOM_DE" -eq 2 ]]; then       # KDE
        RecommendedOptions=""
    elif [[ "$CUSTOM_DE" -eq 3 ]]; then       # XFCE
        RecommendedOptions=""
    elif [[ "$CUSTOM_DE" -eq 4 ]]; then       # Razor-QT & Openbox
        RecommendedOptions="1-14"
    elif [[ "$CUSTOM_DE" -eq 5 ]]; then       # Cinnamon
        RecommendedOptions=""
    elif [[ "$CUSTOM_DE" -eq 6 ]]; then       # Awesome
        RecommendedOptions="1-14"
    fi
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 1-14"    
    fi
    #
    if add_packagemanager "package_install \"$INSTALL_OPENBOX\" 'INSTALL-OPENBOX'" "INSTALL-OPENBOX" ; then
        OPENBOX_INSTALLED=1
        add_package "$INSTALL_OPENBOX"
        if add_packagemanager "aur_package_install \"$AUR_INSTALL_OPENBOX\" 'AUR-INSTALL-OPENBOX'" "AUR-INSTALL-OPENBOX" ; then
            add_aur_package "$AUR_INSTALL_OPENBOX"
            add_packagemanager "make_dir \"/home/$USERNAME/.config/openbox/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/openbox/rc.xml' \"/home/$USERNAME/.config/openbox/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/openbox/menu.xml' \"/home/$USERNAME/.config/openbox/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/openbox/autostart' \"/home/$USERNAME/.config/openbox/\" \"$(basename $BASH_SOURCE) : $LINENO\"; chown -R $USERNAME:$USERNAME /home/$USERNAME/.config" "CONFIG-OPENBOX"  
        fi
        #
        install_common_apps_menu "$RecommendedOptions" "$(localize "INSTALL-OPENBOX-DESC")"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL COMMON APPS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_common_apps_menu"
    USAGE="install_common_apps_menu"
    DESCRIPTION=$(localize "INSTALL-COMMON-APPS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-COMMON-APPS-DESC"      "Install Common Applications"
    localize_info "INSTALL-COMMON-APPS-TITLE"     "Install Common Applications"
    #
    localize_info "INSTALL-COMMON-APPS-MENU-1"    "xcompmgr"
    localize_info "INSTALL-COMMON-APPS-MENU-I-1"        "xcompmgr: Composite Window-effects manager for X.org"
    localize_info "INSTALL-COMMON-APPS-MENU-2"    "viewnior"
    localize_info "INSTALL-COMMON-APPS-MENU-I-2"        "viewnior: A simple, fast and elegant image viewer program"
    localize_info "INSTALL-COMMON-APPS-MENU-3"    "gmrun"
    localize_info "INSTALL-COMMON-APPS-MENU-I-3"        "gmrun: A simple program which provides a run program window"
    localize_info "INSTALL-COMMON-APPS-MENU-4"    "PCManFM"
    localize_info "INSTALL-COMMON-APPS-MENU-I-4"        "PCManFM: An extremely fast and lightweight file manager"
    localize_info "INSTALL-COMMON-APPS-MENU-5"    "rxvt-unicode"
    localize_info "INSTALL-COMMON-APPS-MENU-I-5"        "rxvt-unicode: An unicode enabled rxvt-clone terminal emulator (urxvt)"
    localize_info "INSTALL-COMMON-APPS-MENU-6"    "scrot"
    localize_info "INSTALL-COMMON-APPS-MENU-I-6"        "scrot: Print Screen - A simple command-line screenshot utility for X"
    localize_info "INSTALL-COMMON-APPS-MENU-7"    "thunar"
    localize_info "INSTALL-COMMON-APPS-MENU-I-7"        "thunar: Modern file manager for Xfce"
    localize_info "INSTALL-COMMON-APPS-MENU-8"    "tint2"
    localize_info "INSTALL-COMMON-APPS-MENU-I-8"        "tint2: A basic, good-looking task manager for WMs"
    localize_info "INSTALL-COMMON-APPS-MENU-9"    "volwheel"
    localize_info "INSTALL-COMMON-APPS-MENU-I-9"        "volwheel: Tray icon to change volume with the mouse"
    localize_info "INSTALL-COMMON-APPS-MENU-10"   "xfburn"
    localize_info "INSTALL-COMMON-APPS-MENU-I-10"       "xfburn: A simple CD/DVD burning tool based on libburnia libraries"
    localize_info "INSTALL-COMMON-APPS-MENU-11"   "qasmixer"
    localize_info "INSTALL-COMMON-APPS-MENU-I-11"       "qasmixer: Volume Manager for ALSA in Qt."
    localize_info "INSTALL-COMMON-APPS-MENU-12"   "qtfm"
    localize_info "INSTALL-COMMON-APPS-MENU-I-12"       "qtfm: Qt File Manager."
    localize_info "INSTALL-COMMON-APPS-MENU-13"   "qterminal"
    localize_info "INSTALL-COMMON-APPS-MENU-I-13"       "qterminal: Qt Terminal"
    localize_info "INSTALL-COMMON-APPS-MENU-14"   "qpdfview"
    localize_info "INSTALL-COMMON-APPS-MENU-I-14"      "qpdfview: Qt PDF View"
fi
# -------------------------------------
install_common_apps_menu()
{
    local -r menu_name="INSTALL-COMMON-APPS"  # You must define Menu Name here
    local BreakableKey="D"                    # Q=Quit, D=Done, B=Back
    local RecommendedOptions="$1"             # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions 1-3"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions 1-3"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 1-14"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 1-10 12-14"    
    fi
    # Currently Fails: 11 qasmixer
    if [[ "$CUSTOM_DE" -eq 4 ]]; then
        RecommendedOptions="$RecommendedOptions"
    fi                    
    # @FIX remove BreakableKey and add it to the end
    if ! $(is_needle_in_haystack "$BreakableKey" "$RecommendedOptions" 5) ; then # 5=Anywhere
        RecommendedOptions="$RecommendedOptions $BreakableKey"
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions -> $2"
    #
    while [[ 1 ]];  do
        print_title "INSTALL-COMMON-APPS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-1"  "" ""     "INSTALL-COMMON-APPS-MENU-I-1"  "MenuTheme[@]" # 1  xcompmgr
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-2"  "" ""     "INSTALL-COMMON-APPS-MENU-I-2"  "MenuTheme[@]" # 2  viewnior
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-3"  "" ""     "INSTALL-COMMON-APPS-MENU-I-3"  "MenuTheme[@]" # 3  gmrun
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-4"  "" ""     "INSTALL-COMMON-APPS-MENU-I-4"  "MenuTheme[@]" # 4  PCManFM
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-5"  "" ""     "INSTALL-COMMON-APPS-MENU-I-5"  "MenuTheme[@]" # 5  rxvt-unicode
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-6"  "" ""     "INSTALL-COMMON-APPS-MENU-I-6"  "MenuTheme[@]" # 6  scrot
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-7"  "" ""     "INSTALL-COMMON-APPS-MENU-I-7"  "MenuTheme[@]" # 7  thunar
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-8"  "" ""     "INSTALL-COMMON-APPS-MENU-I-8"  "MenuTheme[@]" # 8  tint2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-9"  "" ""     "INSTALL-COMMON-APPS-MENU-I-9"  "MenuTheme[@]" # 9  volwheel
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-10" "" ""     "INSTALL-COMMON-APPS-MENU-I-10" "MenuTheme[@]" # 10 xfburn
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-11" "" "$AUR" "INSTALL-COMMON-APPS-MENU-I-11" "MenuTheme[@]" # 11 qasmixer
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-12" "" ""     "INSTALL-COMMON-APPS-MENU-I-12" "MenuTheme[@]" # 12 qtfm
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-13" "" "$AUR" "INSTALL-COMMON-APPS-MENU-I-13" "MenuTheme[@]" # 13 qterminal
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-COMMON-APPS-MENU-14" "" "$AUR" "INSTALL-COMMON-APPS-MENU-I-14" "MenuTheme[@]" # 14 qpdfview
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # xcompmgr
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_XCOMPMGR\" 'INSTALL-XCOMPMGR'" "INSTALL-XCOMPMGR" ; then
                        add_package "$INSTALL_XCOMPMGR"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # viewnior
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_VIEWNIOR\" 'INSTALL-VIEWNIOR'" "INSTALL-VIEWNIOR" ; then
                        add_package "$INSTALL_VIEWNIOR"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # gmrun
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GMRUN\" 'INSTALL-GMRUN'" "INSTALL-GMRUN" ; then
                        add_package "$INSTALL_GMRUN"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # PCManFM
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_PCMANFM\" 'INSTALL-PCMANFM'" "INSTALL-PCMANFM" ; then
                        add_package "$INSTALL_PCMANFM"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # rxvt-unicode
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_RXVT_UNICODE\" 'INSTALL-RXVT-UNICODE'" "INSTALL-RXVT-UNICODE" ; then
                        add_package "$INSTALL_RXVT_UNICODE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # scrot
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_SCROT\" 'INSTALL-SCROT'" "INSTALL-SCROT" ; then
                        add_package "$INSTALL_SCROT"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # thunar
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_THUNAR\" 'INSTALL-THUNAR'" "INSTALL-THUNAR" ; then
                        add_package "$INSTALL_THUNAR"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # tint2
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_TINT2\" 'INSTALL-TINT2'" "INSTALL-TINT2" ; then
                        add_package "$INSTALL_TINT2"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # volwheel
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_VOLWHEEL\" 'INSTALL-VOLWHEEL'" "INSTALL-VOLWHEEL" ; then
                        add_package "$INSTALL_VOLWHEEL"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               10)  # xfburn
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_XFBURN\" 'INSTALL-XFBURN'" "INSTALL-XFBURN" ; then
                        add_package "$INSTALL_XFBURN"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               11)  # qasmixer 
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_QASMIXER\" 'AUR-INSTALL-QASMIXER'" "AUR-INSTALL-QASMIXER" ; then
                        add_aur_package "$AUR_INSTALL_QASMIXER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               12)  # qtfm
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_QTFM\" 'INSTALL-QTFM'" "INSTALL-QTFM" ; then
                        add_package "$INSTALL_QTFM"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               13)  # qterminal
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_QTERMINAL\" 'AUR-INSTALL-QTERMINAL'" "AUR-INSTALL-QTERMINAL" ; then
                        add_aur_package "$AUR_INSTALL_QTERMINAL" 
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               14)  # qpdfview
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_QT_PDF\" 'AUR-INSTALL-QT-PDF'" "AUR-INSTALL-QT-PDF" ; then
                        add_aur_package "$AUR_QT_PDF"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-COMMON-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL 
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        S_OPT="$BreakableKey"
                        break;
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL RAZOR QT MENU {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_razor_qt_common"
    USAGE="install_razor_qt_common"
    DESCRIPTION=$(localize "INSTALL-RAZOR-QT-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="14 Jan 2013"
    REVISION="14 Jan 2013"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-RAZOR-QT-DESC"   "Install Razor-Qt"
fi
# -------------------------------------
install_razor_qt_common() # Where Common is install_common_apps_menu
{
    # 4
    local RecommendedOptions="1-14"        # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    if [[ "$CUSTOM_DE" -eq 4 ]]; then
        RecommendedOptions="$RecommendedOptions"
    fi                    
    #
    # Needs a WM: openbox, fwwm2, kwin, KDE without Plasma Desktop
    #
    #install_razor_qt_common=""
    #if add_packagemanager "package_install \"$install_razor_qt_common\" 'INSTALL-AWESOME'" "INSTALL-AWESOME" ; then add_package "$install_razor_qt_common"; fi
    #
    if add_packagemanager "aur_package_install \"$AUR_INSTALL_RAZOR_QT\" 'AUR-INSTALL-RAZOR-QT'" "AUR-INSTALL-RAZOR-QT" ; then
        RAZOR_QT_INSTALLED=1
        QT_INSTALL=1
        add_aur_package "$AUR_INSTALL_RAZOR_QT"
        add_packagemanager "make_dir \"/home/\$USERNAME/.config/razor/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/razor/session.conf' \"/home/\$USERNAME/.config/razor/\" \"\$(basename \$BASH_SOURCE) : \$LINENO\"; chown -R \$USERNAME:\$USERNAME /home/\$USERNAME/.config" "CONFIG-AWESOME"   
        add_packagemanager "$(config_xinitrc 'exec razor-session')" "CONFIG-XINITRC-RAZOR"
        #add_packagemanager "systemctl enable upower.service" "SYSTEMD-ENABLE-RAZOR-QT"
        #
        install_common_apps_menu "$RecommendedOptions" "$(localize "INSTALL-RAZOR-QT-DESC")"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL CINNAMON {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_cinnamon_menu"
    USAGE="install_cinnamon_menu"
    DESCRIPTION=$(localize "INSTALL-CINNAMON-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-CINNAMON-DESC"  "Install Cinnamon"
    #
    localize_info "INSTALL-CINNAMON-TITLE"  "CINNAMON"
    localize_info "INSTALL-CINNAMON-INFO-1" "Cinnamon is a fork of GNOME Shell, initially developed by Linux Mint. It attempts to provide a more traditional user environment based on the desktop metaphor, like GNOME 2. Cinnamon uses Muffin, a fork of the GNOME 3 window manager Mutter, as its window manager."
    localize_info "INSTALL-CINNAMON-INFO-2" "CINNAMON CUSTOMIZATION"
    localize_info "INSTALL-CINNAMON-INFO-3" "Installed Cinnamon"
    #
    localize_info "INSTALL-CINNAMON-MENU-1"   "Applets"
    localize_info "INSTALL-CINNAMON-MENU-I-1"       "Applets: Metapackage for Cinnamon Applets"
    localize_info "INSTALL-CINNAMON-MENU-2"   "Themes"
    localize_info "INSTALL-CINNAMON-MENU-I-2"        "Themes: Metapackage for Cinnamon Themes"
    localize_info "INSTALL-CINNAMON-MENU-3"   "GNOME Packagekit"
    localize_info "INSTALL-CINNAMON-MENU-I-3"        "GNOME Packagekit: Collection of graphical tools for PackageKit to be used in the GNOME desktop"
    localize_info "INSTALL-CINNAMON-MENU-4"   "GNOME Activity Journal"
    localize_info "INSTALL-CINNAMON-MENU-I-4"        "GNOME Activity Journal: A tool for easily browsing and finding files on your computer, developmental code."
    localize_info "INSTALL-CINNAMON-MENU-5"   "Gnome Sushi"
    localize_info "INSTALL-CINNAMON-MENU-I-5"        "gloobus-sushi-bzr: GloobusPreview replacement for Gnome Sushi"
fi
# -------------------------------------
install_cinnamon_menu()
{
    # 5
    local -r menu_name="INSTALL-CINNAMON"  # You must define Menu Name here
    local BreakableKey="D"                 # Q=Quit, D=Done, B=Back 
    local RecommendedOptions="1 2"         # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 3 4"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    CINNAMON_INSTALLED=1
    if add_packagemanager "package_install \"$INSTALL_CINNAMON_PACKAGE\" 'INSTALL-CINNAMON'" "INSTALL-CINNAMON" ; then
        add_package "$INSTALL_CINNAMON_PACKAGE"
        add_packagemanager "systemctl enable accounts-daemon.service" "SYSTEMD-ENABLE-CINNAMON-1"
        add_packagemanager "systemctl enable upower.service" "SYSTEMD-ENABLE-CINNAMON-2"
    fi
    if add_packagemanager "aur_package_install \"$AUR_INSTALL_CINNAMON_PACKAGE\" 'AUR-INSTALL-CINNAMON'" "AUR-INSTALL-CINNAMON" ; then
        add_aur_package "$AUR_INSTALL_CINNAMON_PACKAGE"
    fi
    # @FIX gnome-extra gnome-extra-meta telepathy
    # 
    # not sure how to run these commands; seems like they need to run after GUI is up and running; so adding them as a start up script may be what is needed
    # add_packagemanager "cinnamon-settings; cinnamon-settings panel; cinnamon-settings calendar; cinnamon-settings themes; cinnamon-settings applets; cinnamon-settings windows; cinnamon-settings fonts; cinnamon-settings hotcorner" "AUR-INSTALL-CINNAMON-SETTINGS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-CINNAMON-TITLE" " - https://wiki.archlinux.org/index.php/Cinnamon"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info  "INSTALL-CINNAMON-INFO-1"
        print_info  "INSTALL-CINNAMON-INFO-2"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CINNAMON-MENU-1" "" "$AUR" "INSTALL-CINNAMON-MENU-I-1" "MenuTheme[@]" # 1 Applets
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CINNAMON-MENU-2" "" ""     "INSTALL-CINNAMON-MENU-I-2" "MenuTheme[@]" # 2 Themes
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CINNAMON-MENU-3" "" ""     "INSTALL-CINNAMON-MENU-I-3" "MenuTheme[@]" # 3 GNOME Packagekit
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CINNAMON-MENU-4" "" "$AUR" "INSTALL-CINNAMON-MENU-I-4" "MenuTheme[@]" # 4 GNOME Activity Journal
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CINNAMON-MENU-5" "" "$AUR" "INSTALL-CINNAMON-MENU-I-5" "MenuTheme[@]" # 5 gloobus-sushi-bzr
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Applets
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_CINNAMON_APPLETS\" 'AUR-INSTALL-CINNAMON-APPLETS'" "AUR-INSTALL-CINNAMON-APPLETS" ; then
                        add_aur_package "$AUR_INSTALL_CINNAMON_APPLETS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-CINNAMON-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Themes
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_CINNAMON_THEMES\" 'AUR-INSTALL-CINNAMON-THEMES'" "AUR-INSTALL-CINNAMON-THEMES" ; then
                        add_aur_package "$AUR_INSTALL_CINNAMON_THEMES"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-CINNAMON-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # GNOME Packagekit
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GNOME_PACKAGEKIT\" 'INSTALL-GNOME-PACKAGEKIT'" "INSTALL-GNOME-PACKAGEKIT" ; then
                        add_package "$INSTALL_GNOME_PACKAGEKIT"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-CINNAMON-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # GNOME Activity Journal
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_ZEITGEIST\" 'INSTALL-ZEITGEIST'" "INSTALL-ZEITGEIST" ; then
                        add_package "$INSTALL_ZEITGEIST"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ACTIVITY_JOURNAL\" 'AUR-INSTALL-GNOME-ACTIVITY-JOURNAL'" "AUR-INSTALL-GNOME-ACTIVITY-JOURNAL" ; then
                        add_aur_package "$AUR_INSTALL_GNOME_ACTIVITY_JOURNAL"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-CINNAMON-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # gloobus-sushi-bzr
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GLOOBUS\" 'AUR-INSTALL-GLOOBUS'" "AUR-INSTALL-GLOOBUS" ; then
                        add_aur_package "$AUR_INSTALL_GLOOBUS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-CINNAMON-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        S_OPT="$BreakableKey"
                        break;
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
    write_log "INSTALL-CINNAMON-INFO-3" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL E17 {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_e17_menu"
    USAGE="install_e17_menu"
    DESCRIPTION=$(localize "INSTALL-E17-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-E17-DESC"   "Install E17"
    localize_info "INSTALL-E17-TITLE"  "E17 or Enlightenment"
    localize_info "INSTALL-E17-INFO-1" "Enlightenment, also known simply as E, is a stacking window manager for the X Window System which can be used alone or in conjunction with a desktop environment such as GNOME or KDE. Enlightenment is often used as a substitute for a full desktop environment."
    localize_info "INSTALL-E17-INFO-2" "E17 Customization"
    #
    localize_info "INSTALL-E17-MENU-1"   "e17-icons"
    localize_info "INSTALL-E17-MENU-I-1"     "e17-icons: Animated icons for E17 from exchange.enlightenment.org"
    localize_info "INSTALL-E17-MENU-2"   "e17-themes"
    localize_info "INSTALL-E17-MENU-I-2"     "e17-themes: Themes for E17 desklock from exchange.enlightenment.org"
fi
# -------------------------------------
install_e17_menu()
{
    # 6
    local -r menu_name="INSTALL-E17"  # You must define Menu Name here
    local BreakableKey="D"            # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 2"    # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    if add_packagemanager "package_install \"$INSTALL_E17\" 'INSTALL-E17'" "INSTALL-E17" ; then
        E17_INSTALLED=1
        add_package "$INSTALL_E17"
        # Abstraction for enumerating power devices, listening to device events and querying history and statistics
        # A framework for defining and tracking users, login sessions, and seats
        # systemd-logind replaced console-kit-daemon.service
        add_packagemanager "systemctl enable upower.service" "SYSTEMD-ENABLE-E17"
    fi
    if add_packagemanager "aur_package_install \"$AUR_INSTALL_E17\" 'AUR-INSTALL-E17'" "AUR-INSTALL-E17" ; then
        add_aur_package "$AUR_INSTALL_E17"
        add_packagemanager "chown -R $USERNAME:$USERNAME /home/$USERNAME/.config" "CONFIG-XFCE"
    fi
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-E17-TITLE" " - https://wiki.archlinux.org/index.php/E17"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info "INSTALL-E17-INFO-1"
        print_info "INSTALL-E17-INFO-2"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-E17-MENU-1" "" "$AUR" "INSTALL-E17-MENU-I-1" "MenuTheme[@]" # 1 e17-icons
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-E17-MENU-2" "" "$AUR" "INSTALL-E17-MENU-I-2" "MenuTheme[@]" # 2 e17-themes
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # e17-icons
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_E17_ICONS\" 'AUR-INSTALL-E17-ICONS'" "AUR-INSTALL-E17-ICONS" ; then
                        add_aur_package "$AUR_INSTALL_E17_ICONS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-E17-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # e17-themes
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_E17_THEMES\" 'AUR-INSTALL-E17-THEMES'" "AUR-INSTALL-E17-THEMES" ; then
                        add_aur_package "$AUR_INSTALL_E17_THEMES"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-E17-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        S_OPT="$BreakableKey"
                        break;
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
    RecommendedOptions="1-14"
    install_common_apps_menu "$RecommendedOptions" "$(localize "INSTALL-E17-DESC")"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL LXDE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_lxde_common"
    USAGE="install_lxde_common"
    DESCRIPTION=$(localize "INSTALL-LXDE-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-LXDE-DESC"   "Install LXDE"
    localize_info "INSTALL-LXDE-TITLE"  "LXDE"
    localize_info "INSTALL-LXDE-INFO-1" "LXDE is a free and open source desktop environment for Unix and other POSIX compliant platforms, such as Linux or BSD. The goal of the project is to provide a desktop environment that is fast and energy efficient."
    localize_info "INSTALL-LXDE-INFO-2" "LXDE CUSTOMIZATION"
fi
# -------------------------------------
install_lxde_common() # Where Common is install_common_apps_menu
{
    # 7
    local RecommendedOptions="1-14"    # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    if add_packagemanager "package_install \"$INSTALL_LXDE\" 'INSTALL-LXDE'" "INSTALL-LXDE" ; then
        LXDE_INSTALLED=1
        # Abstraction for enumerating power devices, listening to device events and querying history and statistics
        # A framework for defining and tracking users, login sessions, and seats
        # systemd-logind replaced console-kit-daemon.service
        add_packagemanager "systemctl enable upower.service" "SYSTEMD-ENABLE-LXDE"
        add_package "$INSTALL_LXDE"
        #
        if add_packagemanager "aur_package_install \"$AUR_INSTALL_LXDE\" 'AUR-INSTALL-LXDE'" "AUR-INSTALL-LXDE" ; then
            add_aur_package "$AUR_INSTALL_LXDE"
        fi
        #
        install_common_apps_menu "$RecommendedOptions" "$(localize "INSTALL-LXDE-DESC")"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL XFCE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_xfce_menu"
    USAGE="install_xfce_menu"
    DESCRIPTION=$(localize "INSTALL-XFCE-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-XFCE-DESC"      "Install XFCE"
    localize_info "INSTALL-XFCE-TITLE"     "XFCE"
    localize_info "INSTALL-XFCE-INFO-1"    "Xfce is a free software desktop environment for Unix and Unix-like platforms, such as Linux, Solaris, and BSD. It aims to be fast and lightweight, while still being visually appealing and easy to use."
    localize_info "INSTALL-XFCE-INFO-2"    "Install XFCE and Accessories."
    #
    localize_info "INSTALL-XFCE-MENU-1"    "xfce4-volumed"
    localize_info "INSTALL-XFCE-MENU-I-1"        "xfce4-volumed: A volume keys control daemon for Xfce"
fi
# -------------------------------------
install_xfce_menu() 
{ 
    # 3
    local -r menu_name="INSTALL-XFCE"  # You must define Menu Name here
    local BreakableKey="D"             # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    XFCE_INSTALLED=1
    if add_packagemanager "package_install \"$INSTALL_XFCE_PACKAGE\" 'INSTALL-XFCE'" "INSTALL-XFCE" ; then
        add_package "$INSTALL_XFCE_PACKAGE"
        # Application development toolkit for controlling system-wide privileges
        # Abstraction for enumerating power devices, listening to device events and querying history and statistics
        # A framework for defining and tracking users, login sessions, and seats
        # polkit.service
        # systemd-logind replaced console-kit-daemon.service
        add_packagemanager "systemctl enable upower.service" "SYSTEMD-ENABLE-XFCE"
    fi
    if add_packagemanager "aur_package_install \"$AUR_INSTALL_XFCE_PACKAGE\" 'AUR-INSTALL-XFCE'" "AUR-INSTALL-XFCE" ; then
        add_aur_package "$AUR_INSTALL_XFCE_PACKAGE"
    fi
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-XFCE-TITLE" " - https://wiki.archlinux.org/index.php/Xfce"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info "INSTALL-XFCE-INFO-1"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-XFCE-MENU-1" "" "" "INSTALL-XFCE-MENU-I-1" "MenuTheme[@]" # xfce4-volumed
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # xfce4-volumed
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_XFCE_CUSTOM\" 'AUR-INSTALL-XFCE-CUSTOM'" "AUR-INSTALL-XFCE-CUSTOM" ; then
                        add_aur_package "$AUR_INSTALL_XFCE_CUSTOM"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-XFCE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        S_OPT="$BreakableKey"
                        break;
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL UNITY {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_unity_now"
    USAGE="install_unity_now"
    DESCRIPTION=$(localize "INSTALL-UNITY-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-UNITY-DESC"  "Install Unity"
    localize_info "INSTALL-UNITY-TITLE" "Unity is an alternative shell for the GNOME desktop environment, developed by Canonical in its Ayatana project. It consists of several components including the Launcher, Dash, lenses, Panel, indicators, Notify OSD and Overlay Scrollbar."
    #
    localize_info "INSTALL-UNITY-CONTINUE" "Are you sure you wish to continue" 
fi
# -------------------------------------
install_unity_now() 
{ 
    # 10
    UNITY_INSTALLED=1
    print_title "INSTALL-UNITY-DESC" " - https://wiki.archlinux.org/index.php/Unity"
    print_info "INSTALL-UNITY-TITLE"
    print_error "\nWARNING: EXPERIMENTAL OPTION, USE AT YOUR OWN RISK\nDo not install this if already have a DE or WM installed."
    local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
    read_input_yn "INSTALL-UNITY-CONTINUE" " " 1
    BYPASS="$Old_BYPASS" # Restore Bypass
    [[ "$YN_OPTION" -eq 0 ]] && return 0
    # @FIX use Add Repo function
    echo -e '\n[unity]\nServer = http://unity.xe-xe.org/$arch'             >> $MOUNTPOINT/etc/pacman.conf
    echo -e '\n[unity-extra]\nServer = http://unity.xe-xe.org/extra/$arch' >> $MOUNTPOINT/etc/pacman.conf
    if add_packagemanager "package_install \"$INSTALL_UNITY\" 'INSTALL-UNITY'" "INSTALL-UNITY" ; then
        add_package "$INSTALL_UNITY"
        # telepathy
        # Gnome Display Manager (a reimplementation of xdm)
        # D-Bus interface for user account query and manipulation
        # Application development toolkit for controlling system-wide privileges
        # Abstraction for enumerating power devices, listening to device events and querying history and statistics
        # A framework for defining and tracking users, login sessions, and seats
        # Network Management daemon
        # polkit.service
        # systemd-logind replaced console-kit-daemon.service
        add_packagemanager "systemctl enable lightdm.service accounts-daemon.service upower.service" "SYSTEMD-ENABLE-UNITY"
        # pacstrap will overwrite pacman.conf so copy it to temp 
        copy_file $MOUNTPOINT"/etc/pacman.conf" "${FULL_SCRIPT_PATH}/etc/pacman.conf" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL DISPLAY MANAGER {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_display_manager_menu"
    USAGE="install_display_manager_menu"
    DESCRIPTION=$(localize "INSTALL-DISPLAY-MANAGER-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="15 Jan 2013"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-DISPLAY-MANAGER-DESC"   "Install Display Manager"
    localize_info "INSTALL-DISPLAY-MANAGER-TITLE"  "Display Manager"
    localize_info "INSTALL-DISPLAY-MANAGER-INFO-1" "A display manager, or login manager, is a graphical interface screen that is displayed at the end of the boot process in place of the default shell."
    #
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-1"   "GDM"
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-1-I"          "Gnome Desktop Manager: Works with Gnome, Mate, XFCE, KDE, Awesome...: https://wiki.archlinux.org/index.php/GDM"
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-2"   "KDM"
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-2-I"          "KDM Display Manager - QT Based, requires modification to work with xsessons: https://wiki.archlinux.org/index.php/KDM"
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-3"   "Slim"
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-3-I"          "SLIM: Simple Login Manager — lightweight and elegant graphical login solution: https://wiki.archlinux.org/index.php/SLiM"
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-4"   "LightDM"
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-4-I"          "LightDM: Ubuntu replacement for GDM using WebKit: https://wiki.archlinux.org/index.php/LightDM"
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-5"   "LXDM"
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-5-I"          "LXDM: Display Manager. Can be used independent of the LXDE desktop environment: https://wiki.archlinux.org/index.php/LXDM"
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-6"   "Qingy"
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-6-I"          "Qingy: ultralight and very configurable graphical login independent on X Windows (uses DirectFB): https://wiki.archlinux.org/index.php/Qingy "
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-7"   "XDM"
    localize_info "INSTALL-DISPLAY-MANAGER-MENU-7-I"          "XDM: X Display Manager with support for XDMCP, host chooser: https://wiki.archlinux.org/index.php/XDM"
    localize_info "INSTALL-DISPLAY-MANAGER-REC"      "Recommended Options"
fi
# -------------------------------------
install_display_manager_menu() 
{
    # 3
    local -r menu_name="DISPLAY_MANAGER"  # You must define Menu Name here
    local BreakableKey="D"                # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"          # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #    
    while [[ 1 ]];  do
        print_title "INSTALL-DISPLAY-MANAGER-TITLE" " - https://wiki.archlinux.org/index.php/Display_Manager"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info  "INSTALL-DISPLAY-MANAGER-INFO-1"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-1" ""  ""     "INSTALL-DISPLAY-MANAGER-MENU-1-I" "MenuTheme[@]" # 1 GDM
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-2" ""  ""     "INSTALL-DISPLAY-MANAGER-MENU-2-I" "MenuTheme[@]" # 2 KDM
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-3" ""  ""     "INSTALL-DISPLAY-MANAGER-MENU-3-I" "MenuTheme[@]" # 3 Slim
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-4" ""  "$AUR" "INSTALL-DISPLAY-MANAGER-MENU-4-I" "MenuTheme[@]" # 4 LightDM
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-5" ""  ""     "INSTALL-DISPLAY-MANAGER-MENU-5-I" "MenuTheme[@]" # 5 LXDM
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-6" ""  ""     "INSTALL-DISPLAY-MANAGER-MENU-1-I" "MenuTheme[@]" # 6 Qingy
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-7" ""  ""     "INSTALL-DISPLAY-MANAGER-MENU-7-I" "MenuTheme[@]" # 7 XDM
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # GDM
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GDM\" 'INSTALL-GDM'" "INSTALL-GDM" ; then
                        DE_MANAGER="$S_OPT"
                        add_package "$INSTALL_GDM"
                        # gdm3setup https://aur.archlinux.org/packages/gdm3setup/ 
                        #add_aur_package "$AUR_INSTALL_GDM"
                        #if add_packagemanager "aur_package_install \"$AUR_INSTALL_GDM\" 'AUR-INSTALL-GDM'" "AUR-INSTALL-GDM"
                        add_packagemanager "systemctl enable gdm.service" "SYSTEMD-ENABLE-GDM"
                        if [[ "$MATE_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'mate-session')" "CONFIG-XINITRC-MATE"
                        elif [[ "$AWESOME_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'awesome')" "CONFIG-XINITRC-AWESOME"                     
                        elif [[ "$CINNAMON_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'gnome-session-cinnamon')" "CONFIG-XINITRC-CINNAMON"
                        elif [[ "$E17_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'enlightenment_start')" "CONFIG-XINITRC-E17" 
                        elif [[ "$OPENBOX_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'openbox-session')" "CONFIG-XINITRC-OPENBOX"
                        elif [[ "$XFCE_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'startxfce4')" "CONFIG-XINITRC-XFCE"
                        else
                            add_packagemanager "$(config_xinitrc 'gnome-session')" "CONFIG-XINITRC-GNOME"
                        fi
                    fi
                    # dbus-launch
                    if add_packagemanager "package_install \"$INSTALL_GDM_CONTROL\" 'INSTALL-GDM-CONTROL'" "INSTALL-GDM-CONTROL" ; then # One only
                        add_package "$INSTALL_GDM_CONTROL"
                    fi
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-DISPLAY-MANAGER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                2)  # KDM
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_KDM\" 'INSTALL-KDM'" "INSTALL-KDM" ; then
                        DE_MANAGER="$S_OPT"
                        add_package "$INSTALL_KDM"
                        add_packagemanager "[[ -f \"\${FULL_SCRIPT_PATH}/etc/kdmrc\" ]] && copy_file \"\${FULL_SCRIPT_PATH}/etc/kdmrc\" '/usr/share/config/kdm/kdmrc' \"\$FUNCNAME @ \$(basename \$BASH_SOURCE) : \$LINENO\"" "COPY-KDM"
                        if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                            add_packagemanager "add_option '/usr/share/config/kdm/kdmrc' 'SessionsDirs=' ',/usr/share/xsessions' 'ADD-OPTION-1-KDM'" "ADD-OPTION-1-KDM"
                            # SessionsDirs=/usr/share/config/kdm/sessions,/usr/share/apps/kdm/sessions to SessionsDirs=/usr/share/config/kdm/sessions,/usr/share/apps/kdm/sessions,/usr/share/xsessions
                            add_packagemanager "replace_option '/usr/share/config/kdm/kdmrc' 'AllowClose=' 'true' 'ADD-OPTION-2-KDM'" "ADD-OPTION-2-KDM"
                            # AllowClose=false to AllowClose=true
                            add_packagemanager "add_option '/usr/share/config/kdm/kdmrc' 'Session=' '.custom' 'ADD-OPTION-3-KDM'" "ADD-OPTION-3-KDM"
                            # Session=/usr/share/config/kdm/Xsession to Session=/usr/share/config/kdm/Xsession.custom
                            add_packagemanager "copy_file '/usr/share/config/kdm/Xsession' '/usr/share/config/kdm/Xsession.custom' \"$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO\"" "COPY-2-KDM"
                        fi
                        if [[ "QT_INSTALL" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'startkde')" "CONFIG-XINITRC-KDE"
                            add_packagemanager "systemctl enable kdm.service" "SYSTEMD-ENABLE-KDM"
                            add_packagemanager "systemctl enable upower.service" "SYSTEMD-ENABLE-KDM-UPOWER"
                        elif [[ "$MATE_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'mate-session')" "CONFIG-XINITRC-MATE"
                        elif [[ "$CINNAMON_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'gnome-session-cinnamon')" "CONFIG-XINITRC-CINNAMON"
                        elif [[ "$AWESOME_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'awesome')" "CONFIG-XINITRC-AWESOME"                     
                        elif [[ "$E17_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'enlightenment_start')" "CONFIG-XINITRC-E17" 
                        elif [[ "$OPENBOX_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'openbox-session')" "CONFIG-XINITRC-OPENBOX"
                        elif [[ "$XFCE_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'startxfce4')" "CONFIG-XINITRC-XFCE"
                        else
                            add_packagemanager "$(config_xinitrc 'gnome-session')" "CONFIG-XINITRC-GNOME"
                        fi
                    fi
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-DISPLAY-MANAGER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break;
                    ;;
                3)  # Slim
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_SLIM\" 'INSTALL-SLIM'" "INSTALL-SLIM" ; then
                        DE_MANAGER="$S_OPT"
                        add_package "$INSTALL_SLIM"
                        add_packagemanager "systemctl enable slim.service" "SYSTEMD-ENABLE-SLIM"
                    fi
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-DISPLAY-MANAGER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                4)  # LightDM
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_LIGHTDM\" 'INSTALL-LIGHTDM'" "INSTALL-LIGHTDM" ; then
                        DE_MANAGER="$S_OPT"
                        add_package "$INSTALL_LIGHTDM"
                    fi
                    if [[ "QT_INSTALL" -eq 1 ]]; then
                        add_aur_package "$AUR_INSTALL_LIGHTDM_KDE"
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_LIGHTDM_KDE\" 'AUR-INSTALL-LIGHTDM-KDE'" "AUR-INSTALL-LIGHTDM-KDE"
                    fi
                    if [[ "$UNITY_INSTALLED" -eq 1 ]]; then
                        add_aur_package "$AUR_INSTALL_LIGHTDM_UNITY"
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_LIGHTDM_UNITY\" 'AUR-INSTALL-LIGHTDM-UNITY'" "AUR-INSTALL-LIGHTDM-UNITY"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_LIGHTDM\" 'AUR-INSTALL-LIGHTDM'" "AUR-INSTALL-LIGHTDM" ; then
                        add_aur_package "$AUR_INSTALL_LIGHTDM"
                        add_packagemanager "sed -i 's/#greeter-session=.*\$/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf" "RUN-LIGHTDM"
                        add_packagemanager "systemctl enable lightdm.service" "SYSTEMD-ENABLE-LIGHTDM"
                        if [[ "$XFCE_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "[[ ! -e /usr/bin/gdmflexiserver ]] && ln -s /usr/lib/lightdm/lightdm/gdmflexiserver /usr/bin/gdmflexiserver" "AUR-INSTALL-LIGHTDM-XFCE"
                        fi
                        if [[ "QT_INSTALL" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'startkde')" "CONFIG-XINITRC-KDE"
                            add_packagemanager "systemctl enable kdm.service" "SYSTEMD-ENABLE-KDM"
                            add_packagemanager "systemctl enable upower.service" "SYSTEMD-ENABLE-KDM-UPOWER"
                        elif [[ "$MATE_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'mate-session')" "CONFIG-XINITRC-MATE"
                        elif [[ "$CINNAMON_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'gnome-session-cinnamon')" "CONFIG-XINITRC-CINNAMON"
                        elif [[ "$AWESOME_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'awesome')" "CONFIG-XINITRC-AWESOME"                     
                        elif [[ "$E17_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'enlightenment_start')" "CONFIG-XINITRC-E17" 
                        elif [[ "$OPENBOX_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'openbox-session')" "CONFIG-XINITRC-OPENBOX"
                        elif [[ "$XFCE_INSTALLED" -eq 1 ]]; then
                            add_packagemanager "$(config_xinitrc 'startxfce4')" "CONFIG-XINITRC-XFCE"
                        else
                            add_packagemanager "$(config_xinitrc 'gnome-session')" "CONFIG-XINITRC-GNOME"
                        fi
                    fi
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-DISPLAY-MANAGER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                5)  # LXDM
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_LXDM\" 'INSTALL-LXDM'" "INSTALL-LXDM" ; then
                        DE_MANAGER="$S_OPT"
                        add_package "$INSTALL_LXDM"
                        add_packagemanager "systemctl enable lxdm.service" "SYSTEMD-ENABLE-LXDM"
                        add_packagemanager "$(config_xinitrc 'startlxde')" "CONFIG-XINITRC-GNOME"
                    fi
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-DISPLAY-MANAGER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                6)  # Qingy
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_QINGY\" 'INSTALL-QINGY'" "INSTALL-QINGY" ; then
                        DE_MANAGER="$S_OPT"
                        add_package "$INSTALL_QINGY"
                        add_packagemanager "systemctl enable qingy@ttyX" "SYSTEMD-ENABLE-QINGY"
                    fi
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-DISPLAY-MANAGER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                7)  # XDM
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_XDM\" 'INSTALL-XDM'" "INSTALL-XDM" ; then
                        DE_MANAGER="$S_OPT"
                        add_package "$INSTALL_XDM"
                        add_packagemanager "systemctl enable qingy@ttyX" "SYSTEMD-ENABLE-XDM"
                    fi
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-DISPLAY-MANAGER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
} 
#}}}
# -----------------------------------------------------------------------------
# INSTALL EXTRA {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_extra_menu"
    USAGE="install_extra_menu"
    DESCRIPTION=$(localize "INSTALL-EXTRA-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-EXTRA-DESC"     "Install Extra"
    localize_info "INSTALL-EXTRA-TITLE"    "Extra's"
    # Elementary Project, Yapan
    localize_info "INSTALL-EXTRA-MENU-1"   "Elementary Project"
    localize_info "INSTALL-EXTRA-MENU-I-1"      "ELEMENTARY PROJECT: Media Player, Sharing service, Screencasting, Contacts manager, RSS feeds Reader, File Manager, Note Taking, Compositing Manager, Email client, Dictionary, Maya Calendar, Web Browser, Audio Player, Text Editor, Dock, App Launcher, Desktop Settings Hub, Indicators Topbar, Elementary Icons, and Elementary Theme."
    localize_info "INSTALL-EXTRA-MENU-2"   "Yapan"
    localize_info "INSTALL-EXTRA-MENU-I-2"      "Yapan (Yet Another Package mAnager Notifier) - pacman Update Monitor — written in C++ and Qt. It shows an icon in the system tray and popup notifications for new packages and supports AUR helpers. Yapan: https://aur.archlinux.org/packages/yapan/ and https://bbs.archlinux.org/viewtopic.php?id=113078"
fi
# -------------------------------------
install_extra_menu()
{
    # 13
    local -r menu_name="INSTALL-EXTRA"  # You must define Menu Name here
    local BreakableKey="D"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"        # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-EXTRA-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EXTRA-MENU-1" "" "$AUR" "INSTALL-EXTRA-MENU-I-1" "MenuTheme[@]" # Elementary Project
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EXTRA-MENU-2" "" "$AUR" "INSTALL-EXTRA-MENU-I-2" "MenuTheme[@]" # Yapan
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Elementary Project
                    MenuChecks[$((S_OPT - 1))]=1
                    install_elementary_project_menu
                    # Progress Status
                    StatusBar1="INSTALL-EXTRA-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Yapan
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_YAPAN\" 'INSTALL-YAPAN'" "INSTALL-YAPAN" ; then
                        add_package "$INSTALL_YAPAN"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_YAPAN\" 'AUR-INSTALL-YAPAN'" "AUR-INSTALL-YAPAN" ; then
                        add_aur_package "$AUR_INSTALL_YAPAN"
                    fi
                    break; 
                    # Progress Status
                    StatusBar1="INSTALL-EXTRA-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# ELEMENTARY PROJECT {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_elementary_project_menu"
    USAGE="install_elementary_project_menu"
    DESCRIPTION=$(localize "INSTALL-ELEMENTARY-PROJECT-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-ELEMENTARY-PROJECT-DESC"   "Install Elementary Project"
    localize_info "INSTALL-ELEMENTARY-PROJECT-INFO-1" "Note: Some of these programs still in alpha stage and may not work"
    #
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-1"   "Media Player"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-1"      "Media Player: A simple and modern media player - audience-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-2"   "Sharing service"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-2"      "Sharing service: A sharing service that allows source apps to send their data to registered destination apps - contractor-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-3"   "Screencasting"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-3"      "Screencasting: A simple screencasting app from the elementary project - eidete-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-4"   "Contacts Manager"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-4"      "Contacts Manager: The contacts manager from the Elementary project - dexter-contacts-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-5"   "RSS Feeds Reader"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-5"      "RSS Feeds Reader: RSS feeds Reader from the Elementary Project - feedler-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-6"   "File Manager"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-6"      "File Manager: A simple, powerful and sexy file manager from elementary (Marlin fork) - pantheon-files-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-7"   "Note Taking"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-7"      "Note Taking: A beautiful, fast, and simple note taking app in the style of elementary - footnote-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-8"   "Compositing Manager"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-8"      "Compositing Manager: A window & compositing manager based on libmutter and designed by elementary - gala-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-9"   "Email client"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-9"      "Email client: A new lightweight, easy-to-use, feature-rich email client (beta version) - geary-git"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-10"   "Dictionary"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-10"      "Dictionary: Dictionary application from the Elementary project - lingo-dictionary-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-11"   "Calendar"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-11"      "Calendar: Calendar application written in Vala from the Elementary project - maya-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-12"   "Web Browser"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-12"      "Web Browser: Lightweight web browser based on Gtk WebKit - midori"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-13"   "Audio Player"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-13"      "Audio Player: The official audio player of elementary OS. - noise-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-14"   "Text Editor"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-14"      "Text Editor: A text editor written in Vala by elementary - scratch-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-15"   "Dock"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-15"      "Dock: A stupidly simple dock from elementary - plank-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-16"   "Terminal"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-16"      "Terminal: A super lightweight, beautiful, and simple terminal from the Elementary project - pantheon-terminal-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-17"   "App Launcher"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-17"      "App Launcher: A lightweight and stylish app launcher from elementary - slingshot-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-18"   "Desktop Settings Hub"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-18"      "Desktop Settings Hub: Modular desktop settings hub - switchboard-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-19"   "Indicators Topbar"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-19"      "Indicators Topbar: Stylish top panel that holds indicators and spawns an application launcher - wingpanel-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-20"   "Elementary Icons"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-20"      "Elementary Icons: An icon theme designed to be smooth, sexy, clear, and efficient (Development branch) - elementary-icons-bzr"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-21"   "Elementary Theme"
    localize_info "INSTALL-ELEMENTARY-PROJECT-MENU-I-21"      "Elementary Theme: Development branch of the elementary GTK theme. - egtk-bzr"
fi
# -------------------------------------feedler-bzr
install_elementary_project_menu()
{
    local -r menu_name="ELEMENTARY-PROJECT"  # You must define Menu Name here
    local BreakableKey="B"                   # Q=Quit, D=Done, B=Back
    local RecommendedOptions="10"            # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 3 4 10 11 13 16 17 20 21"
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-ELEMENTARY-PROJECT-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_error "INSTALL-ELEMENTARY-PROJECT-INFO-1"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-1"  "aumidoridience-bzr"    "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-1"  "MenuTheme[@]" # 1  Media Player
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-2"  "contractor-bzr"        "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-2"  "MenuTheme[@]" # 2  Sharing service
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-3"  "eidete-bzr"            "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-3"  "MenuTheme[@]" # 3 Screencasting
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-4"  "dexter-contacts-bzr"   "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-4"  "MenuTheme[@]" # 4  Contacts manager
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-5"  "feedler-bzr"           "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-5"  "MenuTheme[@]" # 5  RSS Feeds Reader
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-6"  "files-bzr"             "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-6"  "MenuTheme[@]" # 6  File Manager
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-7"  "footnote-bzr"          "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-7"  "MenuTheme[@]" # 7 Note Taking
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-8"  "gala-bzr"              "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-8"  "MenuTheme[@]" # 8  Compositing Manager
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-9"  "geary-git"             "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-9"  "MenuTheme[@]" # 9 Email client 
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-10" "lingo-dictionary-bzr"  "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-10" "MenuTheme[@]" # 10 Dictionary
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-11" "maya-bzr"              "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-11" "MenuTheme[@]" # 11 Calendar
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-12" "midori"                ""     "INSTALL-ELEMENTARY-PROJECT-MENU-I-12" "MenuTheme[@]" # 12 Web Browser
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-13" "noise-bzr"             "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-13" "MenuTheme[@]" # 13 Audio Player
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-14" "scratch-bzr"           "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-14" "MenuTheme[@]" # 14 Text Editor
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-15" "plank-bzr"             "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-15" "MenuTheme[@]" # 15 Dock
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-16" "pantheon-terminal-bzr" "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-16" "MenuTheme[@]" # 16 Terminal
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-17" "slingshot-bzr"         "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-17" "MenuTheme[@]" # 17 App Launcher
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-18" "switchboard-bzr"       "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-18" "MenuTheme[@]" # 18 Desktop Settings Hub
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-19" "wingpanel-bzr"         "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-19" "MenuTheme[@]" # 19 Indicators Topbar
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-20" "elementary-icons-bzr"  "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-20" "MenuTheme[@]" # 20 Elementary Icons
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ELEMENTARY-PROJECT-MENU-21" "egtk-bzr"              "$AUR" "INSTALL-ELEMENTARY-PROJECT-MENU-I-21" "MenuTheme[@]" # 21 Elementary Theme
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Media Player audience-bzr
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_EP_AUDIENCE\" 'INSTALL-EP-AUDIENCE'" "INSTALL-EP-AUDIENCE" ; then
                        add_package "$INSTALL_EP_AUDIENCE" # gtk3
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_AUDIENCE\" 'AUR-INSTALL-EP-AUDIENCE'" "AUR-INSTALL-EP-AUDIENCE" ; then
                        add_aur_package "$AUR_INSTALL_EP_AUDIENCE" # gtk3
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Sharing service
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_CONTRACTOR\" 'AUR-INSTALL-EP-CONTRACTOR'" "AUR-INSTALL-EP-CONTRACTOR" ; then
                        add_aur_package "$AUR_INSTALL_EP_CONTRACTOR"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Screencasting
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_EIDETE\" 'AUR-INSTALL-EP-EIDETE'" "AUR-INSTALL-EP-EIDETE" ; then
                        add_aur_package "$AUR_INSTALL_EP_EIDETE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Contacts manager
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_DEXTER\" 'AUR-INSTALL-EP-DEXTER'" "AUR-INSTALL-EP-DEXTER" ; then
                        add_aur_package "$AUR_INSTALL_EP_DEXTER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # RSS Feeds Reader
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_FEEDLER\" 'AUR-INSTALL-EP-FEEDLER'" "AUR-INSTALL-EP-FEEDLER" ; then
                        add_aur_package "$AUR_INSTALL_EP_FEEDLER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # File Manager
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_EP_FILES\" 'INSTALL-EP-FILES'" "INSTALL-EP-FILES" ; then
                        add_package "$INSTALL_EP_FILES"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_FILES\" 'AUR-INSTALL-EP-FILES'" "AUR-INSTALL-EP-FILES" ; then
                        add_aur_package "$AUR_INSTALL_EP_FILES"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # Note Taking
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_FOOTNOTE\" 'AUR-INSTALL-EP-FOOTNOTE'" "AUR-INSTALL-EP-FOOTNOTE" ; then
                        add_aur_package "$AUR_INSTALL_EP_FOOTNOTE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # Compositing Manager
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_GALA\" 'AUR-INSTALL-EP-GALA'" "AUR-INSTALL-EP-GALA" ; then
                        add_aur_package "$AUR_INSTALL_EP_GALA"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # Email client
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_GEARY\" 'AUR-INSTALL-EP-GEARY'" "AUR-INSTALL-EP-GEARY" ; then
                        add_aur_package "$AUR_INSTALL_EP_GEARY"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               10)  # Dictionary
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_LINGO\" 'AUR-INSTALL-EP-LINGO'" "AUR-INSTALL-EP-LINGO" ; then
                        add_aur_package "$AUR_INSTALL_EP_LINGO"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               11)  # Calendar
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_MAYA\" 'AUR-INSTALL-EP-MAYA'" "AUR-INSTALL-EP-MAYA" ; then
                        add_aur_package "$AUR_INSTALL_EP_MAYA"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               12)  # Web Browser
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_EP_MIDORI\" 'INSTALL-EP-MIDORI'" "INSTALL-EP-MIDORI" ; then
                        add_package "$INSTALL_EP_MIDORI"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               13)  # Audio Player
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_NOISE\" 'AUR-INSTALL-EP-NOISE'" "AUR-INSTALL-EP-NOISE" ; then
                        add_aur_package "$AUR_INSTALL_EP_NOISE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               14)  # Text Editor
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_SCRATCH\" 'AUR-INSTALL-EP-SCRATCH'" "AUR-INSTALL-EP-SCRATCH" ; then
                        add_aur_package "$AUR_INSTALL_EP_SCRATCH"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               15)  # Dock
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_PLANK\" 'AUR-INSTALL-EP-PLANK'" "AUR-INSTALL-EP-PLANK" ; then
                        add_aur_package "$AUR_INSTALL_EP_PLANK"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               16)  # Terminal
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_PANTHEON\" 'AUR-INSTALL-EP-PANTHEON'" "AUR-INSTALL-EP-PANTHEON" ; then
                        add_aur_package "$AUR_INSTALL_EP_PANTHEON"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               17)  # App Launcher
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_SLINGSHOT\" 'AUR-INSTALL-EP-SLINGSHOT'" "AUR-INSTALL-EP-SLINGSHOT" ; then
                        add_aur_package "$AUR_INSTALL_EP_SLINGSHOT"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               18)  # Desktop Settings Hub
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_SWITCHBOARD\" 'AUR-INSTALL-EP-SWITCHBOARD" "AUR-INSTALL-EP-SWITCHBOARD" ; then
                        add_aur_package "$AUR_INSTALL_EP_SWITCHBOARD"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               19)  # Indicators Topbar
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_WINGPANEL\" 'AUR-INSTALL-EP-WINGPANEL'" "AUR-INSTALL-EP-WINGPANEL" ; then
                        add_aur_package "$AUR_INSTALL_EP_WINGPANEL"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               20)  # Elementary Icons
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_ICONS\" 'AUR-INSTALL-EP-ICONS'" "AUR-INSTALL-EP-ICONS" ; then
                        add_aur_package "$AUR_INSTALL_EP_ICONS"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary" "RUN-GTK_UPDATE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               21)  # Elementary Theme
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_EGTK\" 'AUR-INSTALL-EP-EGTK'" "AUR-INSTALL-EP-EGTK" ; then
                        add_aur_package "$AUR_INSTALL_EP_EGTK"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ELEMENTARY-PROJECT-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL AUDIO APPS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_audio_apps_menu"
    USAGE="install_audio_apps_menu"
    DESCRIPTION=$(localize "INSTALL-AUDIO-APPS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-AUDIO-APPS-DESC"   "Install Audio Apps"
    # Players, Editors / Tools, Codecs
    localize_info "INSTALL-AUDIO-APPS-MENU-1"   "Players"
    localize_info "INSTALL-AUDIO-APPS-MENU-I-1"      "Players: Sub Menu"
    localize_info "INSTALL-AUDIO-APPS-MENU-2"   "Editors / Tools"
    localize_info "INSTALL-AUDIO-APPS-MENU-I-2"      "Editors / Tools: Sub Menu: soundconverter, puddletag, Audacity, Ocenaudio"
    localize_info "INSTALL-AUDIO-APPS-MENU-3"   "Codecs"
    localize_info "INSTALL-AUDIO-APPS-MENU-I-3"      "Codecs: gstreamer0.10-base, gstreamer0.10-good-plugins, mpg123, flac, faac, faad2, lame, libdca, wavpack"
fi
# -------------------------------------
install_audio_apps_menu()
{
    # 8
    local -r menu_name="AUDIO-APPS"  # You must define Menu Name here
    local BreakableKey="D"           # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-3"   # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-AUDIO-APPS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-AUDIO-APPS-MENU-1" "" "" "INSTALL-AUDIO-APPS-MENU-I-1" "MenuTheme[@]" # 1 Players
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-AUDIO-APPS-MENU-2" "" "" "INSTALL-AUDIO-APPS-MENU-I-2" "MenuTheme[@]" # 2 Editors | Tools
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-AUDIO-APPS-MENU-3" "" "" "INSTALL-AUDIO-APPS-MENU-I-3" "MenuTheme[@]" # 3 Codecs
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Players
                    MenuChecks[$((S_OPT - 1))]=1
                    install_players_menu
                    # Progress Status
                    StatusBar1="INSTALL-AUDIO-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Editors | Tools
                    MenuChecks[$((S_OPT - 1))]=1
                    install_audio_editors_menu
                    # Progress Status
                    StatusBar1="INSTALL-AUDIO-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Codecs
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_AUDIO_CODECS\" 'INSTALL-AUDIO-CODECS'" "INSTALL-AUDIO-CODECS" ; then
                        add_package "$INSTALL_AUDIO_CODECS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-AUDIO-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL AUDIO EDITORS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_audio_editors_menu"
    USAGE="install_audio_editors_menu"
    DESCRIPTION=$(localize "INSTALL-AUDIO-EDITORS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-AUDIO-EDITORS-DESC"   "Install Audio Editors"
    #
    localize_info "INSTALL-AUDIO-EDITORS-MENU-1"   "Sound Converter"
    localize_info "INSTALL-AUDIO-EDITORS-MENU-I-1"      "soundconverter: or soundkonverter Depending on DE."
    localize_info "INSTALL-AUDIO-EDITORS-MENU-2"   "Puddle tag"
    localize_info "INSTALL-AUDIO-EDITORS-MENU-I-2"      "puddletag: An audio tag editor for GNU/Linux (like Mp3tag)."
    localize_info "INSTALL-AUDIO-EDITORS-MENU-3"   "Audacity"
    localize_info "INSTALL-AUDIO-EDITORS-MENU-I-3"      "Audacity: A program that lets you manipulate digital audio waveforms."
    localize_info "INSTALL-AUDIO-EDITORS-MENU-4"   "Ocenaudio"
    localize_info "INSTALL-AUDIO-EDITORS-MENU-I-4"      "Ocenaudio: A cross-platform, easy to use, fast and functional audio editor."
fi
# -------------------------------------
install_audio_editors_menu()
{
    local -r menu_name="INSTALL-AUDIO-EDITORS"  # You must define Menu Name here
    local BreakableKey="B"                      # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"                # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions 2 3"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 2 3 4"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 2 3 4"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-AUDIO-EDITORS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-AUDIO-EDITORS-MENU-1" "" ""     "" "MenuTheme[@]" # 1 soundconverter
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-AUDIO-EDITORS-MENU-2" "" "$AUR" "" "MenuTheme[@]" # 2 puddletag
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-AUDIO-EDITORS-MENU-3" "" ""     "" "MenuTheme[@]" # 3 Audacity
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-AUDIO-EDITORS-MENU-4" "" "$AUR" "" "MenuTheme[@]" # 4 Ocenaudio
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # soundconverter
                    MenuChecks[$((SS_OPT - 1))]=1
                    if [[ "QT_INSTALL" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                            if add_packagemanager "package_install \"$INSTALL_SOUNDCONVERTER\" 'INSTALL-SOUNDCONVERTER'" "INSTALL-SOUNDCONVERTER" ; then
                                add_package "$INSTALL_SOUNDCONVERTER"
                            fi
                        fi
                        if add_packagemanager "package_install \"$INSTALL_SOUNDKONVERTER\" 'INSTALL-SOUNDKONVERTER'" "INSTALL-SOUNDKONVERTER" ; then
                            add_package "$INSTALL_SOUNDKONVERTER"
                        fi
                    else
                        if add_packagemanager "package_install \"$INSTALL_SOUNDCONVERTER\" 'INSTALL-SOUNDCONVERTER'" "INSTALL-SOUNDCONVERTER" ; then
                            add_package "$INSTALL_SOUNDCONVERTER"
                        fi
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-AUDIO-EDITORS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # puddletag
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_PUDDLETAG\" 'AUR-INSTALL-PUDDLETAG'" "AUR-INSTALL-PUDDLETAG" ; then
                        add_aur_package "$AUR_INSTALL_PUDDLETAG"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-AUDIO-EDITORS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Audacity
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_AUDACITY\" 'INSTALL-AUDACITY'" "INSTALL-AUDACITY" ; then
                        add_package "$INSTALL_AUDACITY"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-AUDIO-EDITORS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Ocenaudio
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_OCENAUDIO\" 'AUR-INSTALL-OCENAUDIO'" "AUR-INSTALL-OCENAUDIO" ; then
                        add_aur_package "$AUR_INSTALL_OCENAUDIO"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-AUDIO-EDITORS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL PLAYERS MENU {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_players_menu"
    USAGE="install_players_menu"
    DESCRIPTION=$(localize "INSTALL-PLAYERS-MENU-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-PLAYERS-MENU-DESC"   "Install Players"

    localize_info "INSTALL-PLAYERS-MENU-MENU-1"   "Amarok"
    localize_info "INSTALL-PLAYERS-MENU-MENU-I-1"       "Amarok: The powerful music player for KDE"
    localize_info "INSTALL-PLAYERS-MENU-MENU-2"   "Audacious"
    localize_info "INSTALL-PLAYERS-MENU-MENU-I-2"       "Audacious: Lightweight, advanced audio player focused on audio quality with Plugins for Audacious"
    localize_info "INSTALL-PLAYERS-MENU-MENU-3"   "Banshee"
    localize_info "INSTALL-PLAYERS-MENU-MENU-I-3"       "Banshee: Music management and playback for GNOME"
    localize_info "INSTALL-PLAYERS-MENU-MENU-4"   "Clementine"
    localize_info "INSTALL-PLAYERS-MENU-MENU-I-4"       "Clementine: A music player and library organizer"
    localize_info "INSTALL-PLAYERS-MENU-MENU-5"   "Dead beef"
    localize_info "INSTALL-PLAYERS-MENU-MENU-I-5"       "Dead beef: An audio player for GNU/Linux based on GTK2."
    localize_info "INSTALL-PLAYERS-MENU-MENU-6"   "Exaile"
    localize_info "INSTALL-PLAYERS-MENU-MENU-I-6"       "Exaile: A full-featured media player for GTK+"
    localize_info "INSTALL-PLAYERS-MENU-MENU-7"   "Musique"
    localize_info "INSTALL-PLAYERS-MENU-MENU-I-7"       "Musique: Just another music player, only better"
    localize_info "INSTALL-PLAYERS-MENU-MENU-8"   "Nuvola Player"
    localize_info "INSTALL-PLAYERS-MENU-MENU-I-8"       "Nuvola Player: Integrated Google Music, Grooveshark, 8tracks and Hype Machine player."
    localize_info "INSTALL-PLAYERS-MENU-MENU-9"   "Rhythmbox"
    localize_info "INSTALL-PLAYERS-MENU-MENU-I-9"       "Rhythmbox: An iTunes-like music playback and management application"
    localize_info "INSTALL-PLAYERS-MENU-MENU-10"   "Radio tray"
    localize_info "INSTALL-PLAYERS-MENU-MENU-I-10"       "Radio tray: An online radio streaming player that runs on a Linux system tray."
    localize_info "INSTALL-PLAYERS-MENU-MENU-11"   "Spotify"
    localize_info "INSTALL-PLAYERS-MENU-MENU-I-11"       "Spotify: A proprietary peer-to-peer music streaming service"
    localize_info "INSTALL-PLAYERS-MENU-MENU-12"   "Tomahawk"
    localize_info "INSTALL-PLAYERS-MENU-MENU-I-12"       "Tomahawk: A Music Player App written in C++/Qt"
    localize_info "INSTALL-PLAYERS-MENU-MENU-13"   "Timidity++"
    localize_info "INSTALL-PLAYERS-MENU-MENU-I-13"       "Timidity++: A MIDI to WAVE converter and player"
fi
# -------------------------------------
install_players_menu()
{
    local -r menu_name="INSTALL-PLAYERS"  # You must define Menu Name here
    local BreakableKey="B"                # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-5"        # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #Banshee
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 12 13"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        #Banshee
        print_title "INSTALL-PLAYERS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PLAYERS-MENU-MENU-1"  "" ""     "INSTALL-PLAYERS-MENU-MENU-I-1"  "MenuTheme[@]" # 1  Amarok
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PLAYERS-MENU-MENU-2"  "" ""     "INSTALL-PLAYERS-MENU-MENU-I-2"  "MenuTheme[@]" # 2  Audacious
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PLAYERS-MENU-MENU-3"  "" ""     "INSTALL-PLAYERS-MENU-MENU-I-3"  "MenuTheme[@]" # 3  Banshee
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PLAYERS-MENU-MENU-4"  "" ""     "INSTALL-PLAYERS-MENU-MENU-I-4"  "MenuTheme[@]" # 4  Clementine
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PLAYERS-MENU-MENU-5"  "" ""     "INSTALL-PLAYERS-MENU-MENU-I-5"  "MenuTheme[@]" # 5  Dead beef
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PLAYERS-MENU-MENU-6"  "" "$AUR" "INSTALL-PLAYERS-MENU-MENU-I-6"  "MenuTheme[@]" # 6  Exaile
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PLAYERS-MENU-MENU-7"  "" "$AUR" "INSTALL-PLAYERS-MENU-MENU-I-7"  "MenuTheme[@]" # 7  Musique
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PLAYERS-MENU-MENU-8"  "" "$AUR" "INSTALL-PLAYERS-MENU-MENU-I-8"  "MenuTheme[@]" # 8  Nuvola Player
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PLAYERS-MENU-MENU-9"  "" ""     "INSTALL-PLAYERS-MENU-MENU-I-9"  "MenuTheme[@]" # 9  Rhythmbox
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PLAYERS-MENU-MENU-10" "" "$AUR" "INSTALL-PLAYERS-MENU-MENU-I-10" "MenuTheme[@]" # 10 Radio tray
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PLAYERS-MENU-MENU-11" "" "$AUR" "INSTALL-PLAYERS-MENU-MENU-I-11" "MenuTheme[@]" # 11 Spotify
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PLAYERS-MENU-MENU-12" "" "$AUR" "INSTALL-PLAYERS-MENU-MENU-I-12" "MenuTheme[@]" # 12 Tomahawk
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PLAYERS-MENU-MENU-13" "" ""     "INSTALL-PLAYERS-MENU-MENU-I-13" "MenuTheme[@]" # 13 Timidity++
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Amarok
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_AMAROK\" 'INSTALL-AMAROK'" "INSTALL-AMAROK" ; then
                        add_package "$INSTALL_AMAROK"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PLAYERS-MENU-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Audacious
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_AUDACIOUS\" 'INSTALL-AUDACIOUS'" "INSTALL-AUDACIOUS" ; then
                        add_package "$INSTALL_AUDACIOUS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PLAYERS-MENU-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Banshee
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_BANSHEE\" 'INSTALL-BANSHEE'" "INSTALL-BANSHEE" ; then
                        add_package "$INSTALL_BANSHEE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PLAYERS-MENU-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Clementine
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_CLEMENTINE\" 'INSTALL-CLEMENTINE'" "INSTALL-CLEMENTINE" ; then
                        add_package "$INSTALL_CLEMENTINE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PLAYERS-MENU-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Dead beef
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_DEADBEEF\" 'INSTALL-DEADBEEF'" "INSTALL-DEADBEEF" ; then
                        add_package "$INSTALL_DEADBEEF"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PLAYERS-MENU-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Exaile
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EXAILE\" 'AUR-INSTALL-EXAILE'" "AUR-INSTALL-EXAILE" ; then
                        add_aur_package "$AUR_INSTALL_EXAILE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PLAYERS-MENU-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # Musique
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_MUSIQUE\" 'AUR-INSTALL-MUSIQUE'" "AUR-INSTALL-MUSIQUE" ; then
                        add_aur_package "$AUR_INSTALL_MUSIQUE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PLAYERS-MENU-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # Nuvola Player
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_NUVOLAPLAYER\" 'AUR-INSTALL-NUVOLAPLAYER" "AUR-INSTALL-NUVOLAPLAYER" ; then
                        add_aur_package "$AUR_INSTALL_NUVOLAPLAYER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PLAYERS-MENU-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # Rhythmbox
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_RHYTHMBOX\" 'INSTALL-RHYTHMBOX'" "INSTALL-RHYTHMBOX" ; then
                        add_package "$INSTALL_RHYTHMBOX"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PLAYERS-MENU-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               10)  # Radio tray
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_RADIOTRAY\" 'AUR-INSTALL-RADIOTRAY'" "AUR-INSTALL-RADIOTRAY" ; then
                        add_aur_package "$AUR_INSTALL_RADIOTRAY"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PLAYERS-MENU-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               11)  # Spotify
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_SPOTIFY\" 'AUR-INSTALL-SPOTIFY'" "AUR-INSTALL-SPOTIFY" ; then
                        add_aur_package "$AUR_INSTALL_SPOTIFY"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PLAYERS-MENU-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               12)  # Tomahawk
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_TOMAHAWK\" 'AUR-INSTALL-TOMAHAWK'" "AUR-INSTALL-TOMAHAWK" ; then
                        add_aur_package "$AUR_INSTALL_TOMAHAWK"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PLAYERS-MENU-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               13)  # Timidity++
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_TIMIDITY\" 'AUR-INSTALL-TIMIDITY'" "AUR-INSTALL-TIMIDITY" ; then
                        add_aur_package "$AUR_INSTALL_TIMIDITY"
                        add_packagemanager"echo -e 'soundfont /usr/share/soundfonts/fluidr3/FluidR3GM.SF2' >> /etc/timidity++/timidity.cfg" "RUN-TIMIDITY"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PLAYERS-MENU-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL OFFICE APPS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_office_apps_menu"
    USAGE="install_office_apps_menu"
    DESCRIPTION=$(localize "INSTALL-OFFICE-APPS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-OFFICE-APPS-DESC"      "Install Office Apps"
    localize_info "INSTALL-OFFICE-APPS-TITLE"     "Office Applications"
    #
    localize_info "INSTALL-OFFICE-APPS-MENU-1"    "LibreOffice"
    localize_info "INSTALL-OFFICE-APPS-MENU-1-I"        "Libre Office: LibreOffice is the free power-packed Open Source personal productivity suite for Windows, Macintosh and Linux, that gives you six feature-rich applications for all your document production and data processing needs: Writer, Calc, Impress, Draw, Math and Base. - https://wiki.archlinux.org/index.php/LibreOffice"
    localize_info "INSTALL-OFFICE-APPS-MENU-2"    "Calligra or Abiword + Gnumeric"
    localize_info "INSTALL-OFFICE-APPS-MENU-2-I"        "Calligra (Calligra is the new name of the KOffice Suite, so the Calligra packages will replace the KOffice packages.) or Abiword (A fully-featured word processor) + Gnumeric (A GNOME Spreadsheet Program): Depending on DE"
    localize_info "INSTALL-OFFICE-APPS-MENU-3"    "Latex"
    localize_info "INSTALL-OFFICE-APPS-MENU-3-I"        "LaTeX: LaTeX is a popular markup language and document preparation system, often used in the sciences. The current implementation in Arch Linux is TeX Live. - https://wiki.archlinux.org/index.php/LaTeX"
    localize_info "INSTALL-OFFICE-APPS-MENU-4"    "Calibre"
    localize_info "INSTALL-OFFICE-APPS-MENU-4-I"        "calibre: Ebook management application"
    localize_info "INSTALL-OFFICE-APPS-MENU-5"    "GcStar"
    localize_info "INSTALL-OFFICE-APPS-MENU-5-I"        "gcstar: A collection management application"
    localize_info "INSTALL-OFFICE-APPS-MENU-6"    "Homebank"
    localize_info "INSTALL-OFFICE-APPS-MENU-6-I"        "homebank: Free, easy, personal accounting for everyone: http://homebank.free.fr/"
    localize_info "INSTALL-OFFICE-APPS-MENU-7"    "Impressive"
    localize_info "INSTALL-OFFICE-APPS-MENU-7-I"        "impressive: A fancy PDF presentation program (previously known as KeyJNote)."
    localize_info "INSTALL-OFFICE-APPS-MENU-8"    "Nitrotasks"
    localize_info "INSTALL-OFFICE-APPS-MENU-8-I"        "nitrotasks: An eyecandy task managment tool"
    localize_info "INSTALL-OFFICE-APPS-MENU-9"    "OCR Feeder"
    localize_info "INSTALL-OFFICE-APPS-MENU-9-I"        "ocrfeeder: GTK+ document layout analysis and optical character recognition application"
    localize_info "INSTALL-OFFICE-APPS-MENU-10"   "Xmind"
    localize_info "INSTALL-OFFICE-APPS-MENU-10-I"       "xmind: Brainstorming and Mind Mapping Software - http://www.xmind.net/"
    localize_info "INSTALL-OFFICE-APPS-MENU-11"   "Zathura"
    localize_info "INSTALL-OFFICE-APPS-MENU-11-I"       "zathura: a document viewer"
fi
# -------------------------------------
install_office_apps_menu()
{
    # 4
    local -r menu_name="OFFICE-APPS"  # You must define Menu Name here
    local BreakableKey="D"            # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"      # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 6 7 9 10 11"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 2 6 7 8 9 10 11"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-OFFICE-APPS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-1"  "" ""          "INSTALL-OFFICE-APPS-MENU-1-I"  "MenuTheme[@]" # 1 LibreOffice
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-2"  "" "$SOME_AUR" "INSTALL-OFFICE-APPS-MENU-2-I"  "MenuTheme[@]" # 2 Calligra or Abiword + Gnumeric
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-3"  "" ""          "INSTALL-OFFICE-APPS-MENU-3-I"  "MenuTheme[@]" # 3 latex
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-4"  "" ""          "INSTALL-OFFICE-APPS-MENU-4-I"  "MenuTheme[@]" # 4 calibre
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-5"  "" ""          "INSTALL-OFFICE-APPS-MENU-5-I"  "MenuTheme[@]" # 5 gcstar
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-6"  "" ""          "INSTALL-OFFICE-APPS-MENU-6-I"  "MenuTheme[@]" # 6 homebank
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-7"  "" ""          "INSTALL-OFFICE-APPS-MENU-7-I"  "MenuTheme[@]" # 7 impressive
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-8"  "" "$AUR"      "INSTALL-OFFICE-APPS-MENU-8-I"  "MenuTheme[@]" # 8 nitrotasks
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-9"  "" ""          "INSTALL-OFFICE-APPS-MENU-9-I"  "MenuTheme[@]" # 9 ocrfeeder
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-10" "" ""          "INSTALL-OFFICE-APPS-MENU-10-I" "MenuTheme[@]" # 10 xmind
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-11" "" ""          "INSTALL-OFFICE-APPS-MENU-11-I" "MenuTheme[@]" # 11 zathura
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #	A fully-featured word processor
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # LibreOffice
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_LIBRE_OFFICE\" 'INSTALL-LIBRE_OFFICE'" "INSTALL-LIBRE_OFFICE" ; then
                        add_package "$INSTALL_LIBRE_OFFICE"
                    fi
                    if [[ "QT_INSTALL" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1   ]]; then
                            if add_packagemanager "package_install \"$INSTALL_LIBRE_OFFICE_GNOME\" 'INSTALL-LIBRE-OFFICE-GNOME'" "INSTALL-LIBRE-OFFICE-GNOME" ; then
                                add_package "$INSTALL_LIBRE_OFFICE_GNOME"
                            fi
                        fi
                        if add_packagemanager "package_install \"$INSTALL_LIBRE_OFFICE_KDE\" 'INSTALL-LIBRE-OFFICE-KDE'" "INSTALL-LIBRE-OFFICE-KDE" ; then
                            add_package "$INSTALL_LIBRE_OFFICE_KDE"
                        fi
                    else
                        if add_packagemanager "package_install \"$INSTALL_LIBRE_OFFICE_GNOME\" 'INSTALL-LIBRE-OFFICE-GNOME'" "INSTALL-LIBRE-OFFICE-GNOME" ; then
                            add_package "$INSTALL_LIBRE_OFFICE_GNOME"
                        fi
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-OFFICE-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Calligra or Abiword + Gnumeric
                    MenuChecks[$((S_OPT - 1))]=1
                    if [[ "QT_INSTALL" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                            if add_packagemanager "package_install \"$INSTALL_GNUMERIC\" 'INSTALL-GNUMERIC'" "INSTALL-GNUMERIC" ; then
                                add_package "$INSTALL_GNUMERIC"
                            fi
                        fi
                        if add_packagemanager "package_install \"$INSTALL_CALLIGRA\" 'INSTALL-CALLIGRA'" "INSTALL-CALLIGRA" ; then
                            add_package "$INSTALL_CALLIGRA"
                        fi
                    else
                        if add_packagemanager "package_install \"$INSTALL_GNUMERIC\" 'INSTALL-GNUMERIC'" "INSTALL-GNUMERIC" ; then
                            add_package "$INSTALL_GNUMERIC"
                        fi
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_HUNSPELL\" 'AUR-INSTALL-HUNSPELL'" "AUR-INSTALL-HUNSPELL" ; then
                        add_aur_package "$AUR_INSTALL_HUNSPELL"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ASPELL_LANGUAGE\" \"AUR-INSTALL-ASPELL-LANGUAGE\"" "AUR-INSTALL-ASPELL-LANGUAGE" ; then
                        add_aur_package "$AUR_INSTALL_ASPELL_LANGUAGE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-OFFICE-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # LATEX
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_LATEX\" 'INSTALL-LATEX'" "INSTALL-LATEX" ; then
                        add_package "$INSTALL_LATEX"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_TEXMAKER\" 'AUR-INSTALL-TEXMAKER'" "AUR-INSTALL-TEXMAKER" ; then
                        add_aur_package "$AUR_INSTALL_TEXMAKER"
                    fi
                    if [[ "$LANGUAGE" == "pt_BR" ]]; then
                        if add_packagemanager "aur_package_install \"$AUR_INSTALL_ABNTEX\" 'AUR-INSTALL-ABNTEX'" "AUR-INSTALL-ABNTEX" ; then
                            add_aur_package "$AUR_INSTALL_ABNTEX"
                        fi
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-OFFICE-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # calibre
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_CALIBRE\" 'INSTALL-CALIBRE'" "INSTALL-CALIBRE" ; then
                        add_package "$INSTALL_CALIBRE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-OFFICE-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # gcstar
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GCSTAR\" 'INSTALL-GCSTAR'" "INSTALL-GCSTAR" ; then
                        add_package "$INSTALL_GCSTAR"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-OFFICE-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # homebank
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_HOMEBANK\" 'INSTALL-HOMEBANK'" "INSTALL-HOMEBANK" ; then
                        add_package "$INSTALL_HOMEBANK"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-OFFICE-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # impressive
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_IMPRESSIVE\" 'INSTALL-IMPRESSIVE'" "INSTALL-IMPRESSIVE" ; then
                        add_package "$INSTALL_IMPRESSIVE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-OFFICE-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # nitrotasks
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_NITROTASKS\" 'AUR-INSTALL-NITROTASKS'" "AUR-INSTALL-NITROTASKS" ; then
                        add_aur_package "$AUR_INSTALL_NITROTASKS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-OFFICE-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # ocrfeeder
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_OCRFEEDER\" 'INSTALL-OCRFEEDER'" "INSTALL-OCRFEEDER" ; then
                        add_package "$INSTALL_OCRFEEDER"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ASPELL_LANGUAGE\" \"AUR-INSTALL-ASPELL-$LANGUAGE_AS\"" "AUR-INSTALL-ASPELL-$LANGUAGE_AS" ; then
                        add_aur_package "$AUR_INSTALL_ASPELL_LANGUAGE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-OFFICE-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               10)  # xmind
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_XMIND\" 'AUR-INSTALL-XMIND'" "AUR-INSTALL-XMIND" ; then
                        add_aur_package "$AUR_INSTALL_XMIND"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-OFFICE-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               11)  # zathura
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_ZATHURA\" 'INSTALL-ZATHURA'" "INSTALL-ZATHURA" ; then
                        add_package "$INSTALL_ZATHURA"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-OFFICE-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL SYSTEM APPS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_system_apps_menu"
    USAGE="install_system_apps_menu"
    DESCRIPTION=$(localize "INSTALL-SYSTEM-APPS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-SYSTEM-APPS-DESC"  "Install System Tools Applications."
    localize_info "INSTALL-SYSTEM-APPS-NOTES" "Install System Tools Applications."
    localize_info "INSTALL-SYSTEM-APPS-TITLE" "Notes."
    # Gparted, Grsync, Htop, Virtualbox, Webmin, WINE
    localize_info "INSTALL-SYSTEM-APPS-MENU-1"   "Gparted"
    localize_info "INSTALL-SYSTEM-APPS-MENU-I-1"        "Gparted: A Partition Magic clone, frontend to GNU Parted. https://wiki.archlinux.org/index.php/GParted"
    localize_info "INSTALL-SYSTEM-APPS-MENU-2"   "Grsync"
    localize_info "INSTALL-SYSTEM-APPS-MENU-I-2"        "Grsync: GTK GUI for rsync"
    localize_info "INSTALL-SYSTEM-APPS-MENU-3"   "Htop"
    localize_info "INSTALL-SYSTEM-APPS-MENU-I-3"        "Htop: Interactive process viewer"
    localize_info "INSTALL-SYSTEM-APPS-MENU-4"   "Virtualbox"
    localize_info "INSTALL-SYSTEM-APPS-MENU-I-4"        "VirtualBox is a virtual PC emulator like VMware - https://wiki.archlinux.org/index.php/VirtualBox"
    localize_info "INSTALL-SYSTEM-APPS-MENU-5"   "Webmin"
    localize_info "INSTALL-SYSTEM-APPS-MENU-I-5"        "Webmin runs as a service. Using webmin, you can administer other services and server configuration using a web browser, either from the server or remotely. https://wiki.archlinux.org/index.php/Webmin"
    localize_info "INSTALL-SYSTEM-APPS-MENU-6"   "WINE"
    localize_info "INSTALL-SYSTEM-APPS-MENU-I-6"        "Wine (originally an acronym for 'Wine Is Not an Emulator') is a compatibility layer capable of running Windows applications on several POSIX-compliant operating systems, such as Linux, Mac OSX, & BSD. https://wiki.archlinux.org/index.php/Wine"
fi
# -------------------------------------
install_system_apps_menu()
{
    # 5
    local -r menu_name="SYSTEM-TOOLS-APPS"  # You must define Menu Name here
    local BreakableKey="D"                  # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"            # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions 6"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 2 3 4 6"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 2 3 4 5 6"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-SYSTEM-APPS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SYSTEM-APPS-MENU-1" "" "" "INSTALL-SYSTEM-APPS-MENU-I-1" "MenuTheme[@]" # 1 Gparted
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SYSTEM-APPS-MENU-2" "" "" "INSTALL-SYSTEM-APPS-MENU-I-2" "MenuTheme[@]" # 2 Grsync
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SYSTEM-APPS-MENU-3" "" "" "INSTALL-SYSTEM-APPS-MENU-I-3" "MenuTheme[@]" # 3 Htop
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SYSTEM-APPS-MENU-4" "" "" "INSTALL-SYSTEM-APPS-MENU-I-4" "MenuTheme[@]" # 4 Virtualbox
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SYSTEM-APPS-MENU-5" "" "" "INSTALL-SYSTEM-APPS-MENU-I-5" "MenuTheme[@]" # 5 Webmin
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SYSTEM-APPS-MENU-6" "" "" "INSTALL-SYSTEM-APPS-MENU-I-6" "MenuTheme[@]" # 6 WINE
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Gparted
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GPARTED\" 'INSTALL-GPARTED'" "INSTALL-GPARTED" ; then
                        add_package "$INSTALL_GPARTED"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-SYSTEM-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Grsync
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GRSYNC\" 'INSTALL-GRSYNC'" "INSTALL-GRSYNC" ; then
                        add_package "$INSTALL_GRSYNC"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-SYSTEM-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Htop
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_HTOP\" 'INSTALL-HTOP'" "INSTALL-HTOP" ; then
                        add_package "$INSTALL_HTOP"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-SYSTEM-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Virtualbox
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_VIRTUALBOX\" 'INSTALL-VIRTUALBOX'" "INSTALL-VIRTUALBOX" ; then
                        add_package "$INSTALL_VIRTUALBOX"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_VIRTUALBOX_EXT_ORACLE\" 'AUR-INSTALL-VIRTUALBOX-EXT-ORACLE'" "AUR-INSTALL-VIRTUALBOX-EXT-ORACLE" ; then
                        add_aur_package "$AUR_INSTALL_VIRTUALBOX_EXT_ORACLE"
                        add_module "vboxdrv" "MODULE-VIRTUALBOX"
                        add_packagemanager "systemctl enable vboxservice.service" "SYSTEMD-ENABLE-VIRTUALBOX"
                        add_packagemanager "add_user_2_group 'vboxusers'" "GROUPADD-VBOXUSERS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-SYSTEM-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Webmin
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_WEBMIN\" 'INSTALL-WEBMIN'" "INSTALL-WEBMIN" ; then
                        add_package "$INSTALL_WEBMIN"
                        add_packagemanager "systemctl enable webmin.service" "SYSTEMD-ENABLE-WEBMIN"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-SYSTEM-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # WINE
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_WINE\" 'INSTALL-WINE'" "INSTALL-WINE" ; then
                        add_package "$INSTALL_WINE"
                    fi
                    if [[ "$ARCHI" == "x86_64" ]]; then
                        if [[ "$VIDEO_CARD" -eq 1 ]]; then    # nVidia for WINE
                            if add_packagemanager "package_install \"$INSTALL_WINE_NVIDIA\" 'INSTALL-WINE-NVIDIA'" "INSTALL-WINE-NVIDIA" ; then
                                add_package "$INSTALL_WINE_NVIDIA"
                            fi
                        elif [[ "$VIDEO_CARD" -eq 2 ]]; then  # Nouveau
                            if add_packagemanager "package_install  \"$INSTALL_WINE_NOUVEAU\" 'INSTALL-WINE-NOUVEAU'" "INSTALL-WINE-NOUVEAU" ; then
                                add_package "$INSTALL_WINE_NOUVEAU"
                            fi
                        elif [[ "$VIDEO_CARD" -eq 3 ]]; then  # Intel
                            if add_packagemanager "package_install \"$INSTALL_WINE_INTEL\" 'INSTALL-WINE-INTEL'" "INSTALL-WINE-INTEL" ; then
                                add_package "$INSTALL_WINE_INTEL"
                            fi
                        elif [[ "$VIDEO_CARD" -eq 4 ]]; then  # ATI
                            if add_packagemanager "package_install \"$INSTALL_WINE_ATI\" 'INSTALL-WINE-ATI'" "INSTALL-WINE-ATI" ; then
                                add_package "$INSTALL_WINE_ATI"
                            fi
                        fi
                        if add_packagemanager "package_install \"$INSTALL_WINE_ALSA\" 'INSTALL-WINE-ALSA'" "INSTALL-WINE-ALSA" ; then
                            add_package "$INSTALL_WINE_ALSA"
                        fi
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-SYSTEM-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL GNOME DE EXTRAS MENU {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_gnome_de_extras_menu"
    USAGE="install_gnome_de_extras_menu"
    DESCRIPTION=$(localize "INSTALL-GNOME-DE-EXTRAS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-GNOME-DE-EXTRAS-DESC"  "Install GNOME Desktop Extras"
    localize_info "INSTALL-GNOME-DE-EXTRAS-TITLE" "Gnome Desktop Environments Extras"
    # GNOME Icons, GTK Themes and even Unity
    localize_info "INSTALL-GNOME-DE-EXTRAS-MENU-1"    "GNOME Icons"
    localize_info "INSTALL-GNOME-DE-EXTRAS-MENU-1-I"      "GNOME Icons: awoken-icons faenza-icon-theme faenza-cupertino-icon-theme faience-icon-theme elementary-icons-bzr"
    localize_info "INSTALL-GNOME-DE-EXTRAS-MENU-2"    "GTK Themes"
    localize_info "INSTALL-GNOME-DE-EXTRAS-MENU-2-I"      "GTK Themes: gtk-theme-adwaita-cupertino gtk-theme-boomerang xfce-theme-blackbird xfce-theme-bluebird egtk-bzr xfce-theme-greybird light-themes orion-gtk-theme zukini-theme zukitwo-themes"
    localize_info "INSTALL-GNOME-DE-EXTRAS-MENU-3"    "Unity"
    localize_info "INSTALL-GNOME-DE-EXTRAS-MENU-3-I"      "Unity: Unity is an alternative shell for the GNOME desktop environment, developed by Canonical in its Ayatana project. It consists of several components including the Launcher, Dash, lenses, Panel, indicators, Notify OSD and Overlay Scrollbar. Unity used to available in two implementations: 'Unity' is the 3D accelerated version, which uses Compiz window manager and Nux toolkit; and 'Unity 2D' is a lighter alternative, which uses Metacity window manager and Qt toolkit. Unity 2D is already dropped by Canonical from Ubuntu 12.10."
fi
# -------------------------------------
install_gnome_de_extras_menu()
{
    # 11
    local -r menu_name="INSTALL-GNOME-DE-EXTRAS"  # You must define Menu Name here
    local BreakableKey="B"                  # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 2"          # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    local -a MenuThemeWarn=( "${BRed}" "${White}" ")" )
    #
    while [[ 1 ]]; do
        print_title "INSTALL-GNOME-DE-EXTRAS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOME-DE-EXTRAS-MENU-1" "" "$AUR" "INSTALL-GNOME-DE-EXTRAS-MENU-1-I" "MenuTheme[@]"     # 1 GNOME Icons
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOME-DE-EXTRAS-MENU-2" "" "$AUR" "INSTALL-GNOME-DE-EXTRAS-MENU-2-I" "MenuTheme[@]"     # 2 GTK Themes
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GNOME-DE-EXTRAS-MENU-3" "" "$AUR" "INSTALL-GNOME-DE-EXTRAS-MENU-3-I" "MenuThemeWarn[@]" # Unity
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # GNOME Icons
                    MenuChecks[$((S_OPT - 1))]=1
                    install_icons_menu
                    # Progress Status
                    StatusBar1="INSTALL-GNOME-DE-EXTRAS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # GTK Themes
                    MenuChecks[$((S_OPT - 1))]=1
                    install_gtk_themes_menu
                    # Progress Status
                    StatusBar1="INSTALL-GNOME-DE-EXTRAS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Unity
                    MenuChecks[$((S_OPT - 1))]=1
                    install_unity_now
                    # Progress Status
                    StatusBar1="INSTALL-GNOME-DE-EXTRAS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL GTK THEMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_gtk_themes_menu"
    USAGE="install_gtk_themes_menu"
    DESCRIPTION=$(localize "INSTALL-GTK-THEMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-GTK-THEMES-DESC"   "Install GTK Themes"
    #
    localize_info "INSTALL-GTK-THEMES-MENU-1"    "Adwaita Cupertino"
    localize_info "INSTALL-GTK-THEMES-MENU-I-1"      "Adwaita Cupertino: Adwaita Cupertino GTK3 theme with matte and glassy metacity icons."
    localize_info "INSTALL-GTK-THEMES-MENU-2"    "Boomerang"
    localize_info "INSTALL-GTK-THEMES-MENU-I-2"      "Boomerang: A modern and well polished theme for GNOME desktop (gtk3, gtk2 and metacity)"
    localize_info "INSTALL-GTK-THEMES-MENU-3"    "Blackbird"
    localize_info "INSTALL-GTK-THEMES-MENU-I-3"      "Blackbird: A dark, ink black Xfce theme, based off of Greybird"
    localize_info "INSTALL-GTK-THEMES-MENU-4"    "Bluebird"
    localize_info "INSTALL-GTK-THEMES-MENU-I-4"      "Bluebird: A light blue Xfce theme, introduced in the release of Xubuntu 10.10"
    localize_info "INSTALL-GTK-THEMES-MENU-5"    "eGTK"
    localize_info "INSTALL-GTK-THEMES-MENU-I-5"      "eGTK: Development branch of the elementary GTK theme."
    localize_info "INSTALL-GTK-THEMES-MENU-6"    "Greybird"
    localize_info "INSTALL-GTK-THEMES-MENU-I-6"      "Greybird: A grey and blue Xfce theme, introduced in the release of Xubuntu 11.04 and updated for 12.04; includes the classic low saturation theme"
    localize_info "INSTALL-GTK-THEMES-MENU-7"    "Light"
    localize_info "INSTALL-GTK-THEMES-MENU-I-7"      "Light: Ubuntu 'light' themes Ambiance and Radiance (GTK2 and GTK3)"
    localize_info "INSTALL-GTK-THEMES-MENU-8"    "Orion"
    localize_info "INSTALL-GTK-THEMES-MENU-I-8"      "Orion: A modern and light GTK theme"
    localize_info "INSTALL-GTK-THEMES-MENU-9"    "Zukini"
    localize_info "INSTALL-GTK-THEMES-MENU-I-9"      "Zukini: A gtk2, gtk3, metacity, gnome-shell and unity theme..."
    localize_info "INSTALL-GTK-THEMES-MENU-10"   "Zukitwo"
    localize_info "INSTALL-GTK-THEMES-MENU-I-10"     "Zukitwo: A theme for gtk3, gtk2, metacity, xfwm4, gnome-shell and unity..."
fi
# -------------------------------------
install_gtk_themes_menu() 
{ 
    # 11 sub 2
    local -r menu_name="INSTALL-GTK-THEMES"  # You must define Menu Name here
    local BreakableKey="D"                   # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-10"          # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-GTK-THEMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GTK-THEMES-MENU-1"  "" "$AUR" "INSTALL-GTK-THEMES-MENU-I-1"  "MenuTheme[@]" # 1 Adwaita Cupertino
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GTK-THEMES-MENU-2"  "" "$AUR" "INSTALL-GTK-THEMES-MENU-I-2"  "MenuTheme[@]" # 2 Boomerang
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GTK-THEMES-MENU-3"  "" "$AUR" "INSTALL-GTK-THEMES-MENU-I-3"  "MenuTheme[@]" # 3 Blackbird
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GTK-THEMES-MENU-4"  "" "$AUR" "INSTALL-GTK-THEMES-MENU-I-4"  "MenuTheme[@]" # 4 Bluebird
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GTK-THEMES-MENU-5"  "" "$AUR" "INSTALL-GTK-THEMES-MENU-I-5"  "MenuTheme[@]" # 5 eGTK
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GTK-THEMES-MENU-6"  "" "$AUR" "INSTALL-GTK-THEMES-MENU-I-6"  "MenuTheme[@]" # 6 Greybird
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GTK-THEMES-MENU-7"  "" "$AUR" "INSTALL-GTK-THEMES-MENU-I-7"  "MenuTheme[@]" # 7 Light
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GTK-THEMES-MENU-8"  "" "$AUR" "INSTALL-GTK-THEMES-MENU-I-8"  "MenuTheme[@]" # 8 Orion
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GTK-THEMES-MENU-9"  "" "$AUR" "INSTALL-GTK-THEMES-MENU-I-9"  "MenuTheme[@]" # 9 Zukini
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GTK-THEMES-MENU-10" "" "$AUR" "INSTALL-GTK-THEMES-MENU-I-10" "MenuTheme[@]" # 10 Zukitwo
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Adwaita Cupertino
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_ADWAITA\" 'AUR-INSTALL-GTK-THEMES-ADWAITA'" "AUR-INSTALL-GTK-THEMES-ADWAITA" ; then
                        add_aur_package "$AUR_INSTALL_GTK_THEMES_ADWAITA"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GTK-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Boomerang
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_BOOMERANG\" 'AUR-INSTALL-GTK-THEMES-BOOMERANG'" "AUR-INSTALL-GTK-THEMES-BOOMERANG" ; then
                        add_aur_package "$AUR_INSTALL_GTK_THEMES_BOOMERANG"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GTK-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Blackbird
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_BLACKBIRD\" 'AUR-INSTALL-GTK-THEMES-BLACKBIRD'" "AUR-INSTALL-GTK-THEMES-BLACKBIRD" ; then
                        add_aur_package "$AUR_INSTALL_GTK_THEMES_BLACKBIRD"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GTK-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Bluebird
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_BLUEBIRD\" 'AUR-INSTALL-GTK-THEMES-BLUEBIRD'" "AUR-INSTALL-GTK-THEMES-BLUEBIRD" ; then
                        add_aur_package "$AUR_INSTALL_GTK_THEMES_BLUEBIRD"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GTK-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # eGTK
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_EGTK\" 'AUR-INSTALL-GTK-THEMES-EGTK'" "AUR-INSTALL-GTK-THEMES-EGTK" ; then
                        add_aur_package "$AUR_INSTALL_GTK_THEMES_EGTK"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GTK-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Greybird
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_XFCE_GREYBIRD\" 'AUR-INSTALL-GTK-THEMES-XFCE-GREYBIRD'" "AUR-INSTALL-GTK-THEMES-XFCE-GREYBIRD" ; then
                        add_aur_package "$AUR_INSTALL_GTK_THEMES_XFCE_GREYBIRD"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GTK-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # Light
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_LIGHT_THEMES\" 'AUR-INSTALL-GTK-THEMES-LIGHT-THEMES'" "AUR-INSTALL-GTK-THEMES-LIGHT-THEMES" ; then
                        add_aur_package "$AUR_INSTALL_GTK_THEMES_LIGHT_THEMES"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GTK-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # Orion
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_ORION\" 'AUR-INSTALL-GTK-THEMES-ORION'" "AUR-INSTALL-GTK-THEMES-ORION" ; then
                        add_aur_package "$AUR_INSTALL_GTK_THEMES_ORION"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GTK-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # Zukini
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_ZUKINI\" 'AUR-INSTALL-GTK-THEMES-ZUKINI'" "AUR-INSTALL-GTK-THEMES-ZUKINI" ; then
                        add_aur_package "$AUR_INSTALL_GTK_THEMES_ZUKINI"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GTK-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               10)  # Zukitwo
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_ZUKITWO\" 'AUR-INSTALL-GTK-THEMES-ZUKITWO'" "AUR-INSTALL-GTK-THEMES-ZUKITWO" ; then
                        add_aur_package "$AUR_INSTALL_GTK_THEMES_ZUKITWO"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GTK-THEMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
} 
#}}}
# -----------------------------------------------------------------------------
# INSTALL ICONS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_icons_menu"
    USAGE="install_icons_menu"
    DESCRIPTION=$(localize "INSTALL-ICONS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-ICONS-DESC"   "Install ICONS: Install also the elementary XFCE icons" 
    localize_info "INSTALL-ICONS-TITLE"  "GNOME ICONS" 
    localize_info "INSTALL-ICONS-INFO-1" "Install also the elementary XFCE icons" 
    #
    localize_info "INSTALL-ICONS-MENU-1"    "Awoken" 
    localize_info "INSTALL-ICONS-MENU-I-1"       "Awoken: Simple and quite complete icon set, Token-style. awoken-icons" 
    localize_info "INSTALL-ICONS-MENU-2"    "Faenza" 
    localize_info "INSTALL-ICONS-MENU-I-2"       "Faenza: Faenza icon theme for KDE4. faenza-icon-theme" 
    localize_info "INSTALL-ICONS-MENU-3"    "Faenza-Cupertino" 
    localize_info "INSTALL-ICONS-MENU-I-3"       "Faenza-Cupertino: Icon theme designed for Equinox GTK theme, recolored. faenza-cupertino-icon-theme" 
    localize_info "INSTALL-ICONS-MENU-4"    "Faience" 
    localize_info "INSTALL-ICONS-MENU-I-4"       "Faience: An icon theme based on Faenza. faience-icon-theme" 
    localize_info "INSTALL-ICONS-MENU-5"    "Elementary" 
    localize_info "INSTALL-ICONS-MENU-I-5"       "Elementary: An icon theme designed to be smooth, sexy, clear, and efficient (Development branch). elementary-icons-bzr" 
    localize_info "INSTALL-ICONS-MENU-6"    "Nitrux" 
    localize_info "INSTALL-ICONS-MENU-I-6"       "Nitrux: new squared icon set for Linux that sports clean lines, smooth gradients, and simple icon logos. nitrux-icon-theme" 
fi
# -------------------------------------
install_icons_menu() 
{ 
    # 11 sub 1
    local -r menu_name="INSTALL-ICONS"  # You must define Menu Name here
    local BreakableKey="D"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-6"      # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    if add_packagemanager "package_install \"$INSTALL_GTK_ICONS\" 'INSTALL-GTK-ICONS'" "INSTALL-GTK-ICONS" ; then
        add_package "$INSTALL_GTK_ICONS"
    fi
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-ICONS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ICONS-MENU-1" "" "$AUR" "INSTALL-ICONS-MENU-I-1" "MenuTheme[@]" # 1 Awoken
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ICONS-MENU-2" "" "$AUR" "INSTALL-ICONS-MENU-I-2" "MenuTheme[@]" # 2 Faenza
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ICONS-MENU-3" "" "$AUR" "INSTALL-ICONS-MENU-I-3" "MenuTheme[@]" # 3 Faenza-Cupertino
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ICONS-MENU-4" "" "$AUR" "INSTALL-ICONS-MENU-I-4" "MenuTheme[@]" # 4 Faience
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ICONS-MENU-5" "" "$AUR" "INSTALL-ICONS-MENU-I-5" "MenuTheme[@]" # 5 Elementary
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ICONS-MENU-6" "" "$AUR" "INSTALL-ICONS-MENU-I-6" "MenuTheme[@]" # 6 Nitrux
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Awoken
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_AWOKEN\" 'AUR-INSTALL-GNOME-ICONS-AWOKEN'" "AUR-INSTALL-GNOME-ICONS-AWOKEN" ; then
                        add_aur_package "$AUR_INSTALL_GNOME_ICONS_AWOKEN"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/AwOken" "RUN-GTK-ICONS-1"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/AwOken-Dark" "RUN-GTK-ICONS-2"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-INSTALL-ICONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Faenza
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_FAENZA\" 'AUR-INSTALL-GNOME-ICONS-FAENZA'" "AUR-INSTALL-GNOME-ICONS-FAENZA" ; then
                        add_aur_package "$AUR_INSTALL_GNOME_ICONS_FAENZA"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza" "RUN-GTK-ICONS-3"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Dark" "RUN-GTK-ICONS-4"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Darker" "RUN-GTK-ICONS-5"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Darkest" "RUN-GTK-ICONS-6"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-INSTALL-ICONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Faenza-Cupertino
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_FEANZA_CUPERTINO\" 'AUR-INSTALL-GNOME-ICONS-FEANZA-CUPERTINO'" "AUR-INSTALL-GNOME-ICONS-FEANZA-CUPERTINO" ; then
                        add_aur_package "$AUR_INSTALL_GNOME_ICONS_FEANZA_CUPERTINO"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino" "RUN-GTK-ICONS-7"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino-Dark" "RUN-GTK-ICONS-8"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino-Darker" "RUN-GTK-ICONS-9"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino-Darkest" "RUN-GTK-ICONS-10"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-INSTALL-ICONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Faience
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_FAIENCE\" 'AUR-INSTALL-GNOME-ICONS-FAIENCE'" "AUR-INSTALL-GNOME-ICONS-FAIENCE" ; then
                        add_aur_package "$AUR_INSTALL_GNOME_ICONS_FAIENCE"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience" "RUN-GTK-ICONS-11"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience-Azur" "RUN-GTK-ICONS-12"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience-Claire" "RUN-GTK-ICONS-13"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience-Ocre" "RUN-GTK-ICONS-14"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-INSTALL-ICONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Elementary
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_ELEMENTARY\" 'AUR-INSTALL-GNOME-ICONS-ELEMENTARY'" "AUR-INSTALL-GNOME-ICONS-ELEMENTARY" ; then
                        add_aur_package "$AUR_INSTALL_GNOME_ICONS_ELEMENTARY"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary" "RUN-GTK-ICONS-15"
                    fi
                    #
                    read_input_yn "INSTALL-ICONS-INFO-1" " " 1 # Allow Bypass
                    if [[ "$YN_OPTION" -eq 1 ]]; then
                        if add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_ELEMENTARY_XFCE\" 'AUR-INSTALL-GNOME-ICONS-ELEMENTARY-XFCE'" "AUR-INSTALL-GNOME-ICONS-ELEMENTARY-XFCE" ; then
                            add_aur_package "$AUR_INSTALL_GNOME_ICONS_ELEMENTARY_XFCE"
                            add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary-xfce" "RUN-GTK-ICONS-16"
                            add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary-xfce-dark" "RUN-GTK-ICONS-17"
                        fi
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-INSTALL-ICONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Nitrux
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_NITRUX\" 'AUR-INSTALL-GNOME-ICONS-NITRUX'" "AUR-INSTALL-GNOME-ICONS-NITRUX" ; then
                        add_aur_package "$AUR_INSTALL_GNOME_ICONS_NITRUX"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX" "RUN-GTK-ICONS-18"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-BTN" "RUN-GTK-ICONS-19"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-BTN-blufold" "RUN-GTK-ICONS-20"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-C" "RUN-GTK-ICONS-21"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-DRK" "RUN-GTK-ICONS-22"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-G" "RUN-GTK-ICONS-23"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-G-lightpnl" "RUN-GTK-ICONS-24"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-INSTALL-ICONS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
} 
#}}}
# -----------------------------------------------------------------------------
# INSTALL GAMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_games_menu"
    USAGE="install_games_menu"
    DESCRIPTION=$(localize "INSTALL-GAMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-GAMES-DESC"   "Install Games"
    localize_info "INSTALL-GAMES-TITLE"  "GAMES"
    #
    localize_info "INSTALL-GAMES-MENU-1"    "Action | Adventure"
    localize_info "INSTALL-GAMES-MENU-I-1"       "Action | Adventure: Sub Menu"
    localize_info "INSTALL-GAMES-MENU-2"    "Arcade | Platformer"
    localize_info "INSTALL-GAMES-MENU-I-2"       "Arcade | Platformer: Sub Menu"
    localize_info "INSTALL-GAMES-MENU-3"    "Dungeon"
    localize_info "INSTALL-GAMES-MENU-I-3"       "Dungeon: Sub Menu"
    localize_info "INSTALL-GAMES-MENU-4"    "Emulators"
    localize_info "INSTALL-GAMES-MENU-I-4"       "Emulators: Sub Menu"
    localize_info "INSTALL-GAMES-MENU-5"    "FPS"
    localize_info "INSTALL-GAMES-MENU-I-5"       "FPS: Sub Menu"
    localize_info "INSTALL-GAMES-MENU-6"    "MMO"
    localize_info "INSTALL-GAMES-MENU-I-6"       "MMO: Sub Menu"
    localize_info "INSTALL-GAMES-MENU-7"    "Puzzle"
    localize_info "INSTALL-GAMES-MENU-I-7"       "Puzzle: Sub Menu"
    localize_info "INSTALL-GAMES-MENU-8"    "RPG"
    localize_info "INSTALL-GAMES-MENU-I-8"       "RPG: Sub Menu"
    localize_info "INSTALL-GAMES-MENU-9"    "Racing"
    localize_info "INSTALL-GAMES-MENU-I-9"       "Racing: Sub Menu"
    localize_info "INSTALL-GAMES-MENU-10"   "Simulation"
    localize_info "INSTALL-GAMES-MENU-I-10"      "Simulation: Sub Menu"
    localize_info "INSTALL-GAMES-MENU-11"   "Strategy"
    localize_info "INSTALL-GAMES-MENU-I-11"      "Strategy: Sub Menu"
    localize_info "INSTALL-GAMES-MENU-12"   "Gnome"
    localize_info "INSTALL-GAMES-MENU-I-12"      "Gnome: $INSTALL_GNOME_GAMES"
    localize_info "INSTALL-GAMES-MENU-13"   "KDE"
    localize_info "INSTALL-GAMES-MENU-I-13"      "KDE: $INSTALL_KDE_GAMES"
    localize_info "INSTALL-GAMES-MENU-14"   "Misc"
    localize_info "INSTALL-GAMES-MENU-I-14"      "Misc: $INSTALL_MISC_GAMES"
fi
# -------------------------------------
install_games_menu()
{
    # 10
    local -r menu_name="INSTALL-GAMES"  # You must define Menu Name here
    local BreakableKey="D"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="12"       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions 1-14"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 14"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_nameMisc}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-GAMES-TITLE" " - https://wiki.archlinux.org/index.php/Games"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-1"  "" "" "INSTALL-GAMES-MENU-I-1"  "MenuTheme[@]" # 1  Action | Adventure
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-2"  "" "" "INSTALL-GAMES-MENU-I-2"  "MenuTheme[@]" # 2  Arcade | Platformer
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-3"  "" "" "INSTALL-GAMES-MENU-I-3"  "MenuTheme[@]" # 3  Dungeon
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-4"  "" "" "INSTALL-GAMES-MENU-I-4"  "MenuTheme[@]" # 4  Emulators
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-5"  "" "" "INSTALL-GAMES-MENU-I-5"  "MenuTheme[@]" # 5  FPS
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-6"  "" "" "INSTALL-GAMES-MENU-I-6"  "MenuTheme[@]" # 6  MMO
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-7"  "" "" "INSTALL-GAMES-MENU-I-7"  "MenuTheme[@]" # 7  Puzzle
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-8"  "" "" "INSTALL-GAMES-MENU-I-8"  "MenuTheme[@]" # 8  RPG
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-9"  "" "" "INSTALL-GAMES-MENU-I-9"  "MenuTheme[@]" # 9  Racing
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-10" "" "" "INSTALL-GAMES-MENU-I-10" "MenuTheme[@]" # 10 Simulation
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-11" "" "" "INSTALL-GAMES-MENU-I-11" "MenuTheme[@]" # 11 Strategy
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-12" "" "" "INSTALL-GAMES-MENU-I-12" "MenuTheme[@]" # 12 Gnome
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-13" "" "" "INSTALL-GAMES-MENU-I-13" "MenuTheme[@]" # 13 KDE
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GAMES-MENU-14" "" "" "INSTALL-GAMES-MENU-I-14" "MenuTheme[@]" # 14 Misc
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Action | Adventure
                    MenuChecks[$((S_OPT - 1))]=1
                    install_action_games_menu
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Arcade | Platformer
                    MenuChecks[$((S_OPT - 1))]=1
                    install_arade_games_menu
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Dungeon
                    MenuChecks[$((S_OPT - 1))]=1
                    install_dungon_games_menu
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Emulators
                    MenuChecks[$((S_OPT - 1))]=1
                    install_emulator_games_menu
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # FPS
                    MenuChecks[$((S_OPT - 1))]=1
                    install_fps_games_menu
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # MMO
                    MenuChecks[$((S_OPT - 1))]=1
                    install_mmo_games_menu
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # Puzzle
                    MenuChecks[$((S_OPT - 1))]=1
                    install_puzzle_games_menu
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # RPG
                    MenuChecks[$((S_OPT - 1))]=1
                    install_rpg_games_menu
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # Racing
                    MenuChecks[$((S_OPT - 1))]=1
                    install_racing_games_menu
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               10)  # Simulation
                    MenuChecks[$((S_OPT - 1))]=1
                    install_simulation_games_menu
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               11)  # Strategy
                    MenuChecks[$((S_OPT - 1))]=1
                    install_strategy_games_menu
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               12)  # Gnome
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GNOME_GAMES\" 'INSTALL-GNOME-GAMES'" "INSTALL-GNOME-GAMES" ; then
                        add_package "$INSTALL_GNOME_GAMES"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               13)  # KDE
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_KDE_GAMES\" 'INSTALL-KDE-GAMES'" "INSTALL-KDE-GAMES" ; then
                        add_package "$INSTALL_KDE_GAMES"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               14)  # Misc
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_MISC_GAMES\" 'INSTALL-MISC-GAMES'" "INSTALL-MISC-GAMES" ; then
                        add_package "$INSTALL_MISC_GAMES"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL ACTION GAMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_action_games_menu"
    USAGE="install_action_games_menu"
    DESCRIPTION=$(localize "INSTALL-ACTION-GAMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-ACTION-GAMES-DESC"   "Install Action/Adventure Games"
    localize_info "INSTALL-ACTION-GAMES-TITLE"  "Install Action/Adventure Games"
    #
    localize_info "INSTALL-ACTION-GAMES-MENU-1"   "Astromenace"
    localize_info "INSTALL-ACTION-GAMES-MENU-I-1"        "Astromenace: Hardcore 3D space shooter with spaceship upgrade possibilities"
    localize_info "INSTALL-ACTION-GAMES-MENU-2"   "Counter-Strike 2D"
    localize_info "INSTALL-ACTION-GAMES-MENU-I-2"        "Counter-Strike 2D: A more than just a freeware clone of the well known game Counter-Strike"
    localize_info "INSTALL-ACTION-GAMES-MENU-3"   "Dead Cyborg Episode 1"
    localize_info "INSTALL-ACTION-GAMES-MENU-I-3"        "Dead Cyborg Episode 1: Free, donation based oldskool sci-fi adventure game with 3D first person view"
    localize_info "INSTALL-ACTION-GAMES-MENU-4"   "M.A.R.S. Shooter"
    localize_info "INSTALL-ACTION-GAMES-MENU-I-4"        "M.A.R.S. Shooter: A ridiculous space shooter with nice graphics"
    localize_info "INSTALL-ACTION-GAMES-MENU-5"   "Nikki"
    localize_info "INSTALL-ACTION-GAMES-MENU-I-5"        "Nikki: Nikki and the robots: A game where you take the role of Nikki and try to cross those evil plans on behalf of a secret organization."
    localize_info "INSTALL-ACTION-GAMES-MENU-6"   "OpenTyrian"
    localize_info "INSTALL-ACTION-GAMES-MENU-I-6"        "opentyrian-hg: OpenTyrian is a port of the DOS shoot-em-up Tyrian. This is a Port of the classic DOS game Tyrian"
    localize_info "INSTALL-ACTION-GAMES-MENU-7"   "Sonic Robot Blast 2"
    localize_info "INSTALL-ACTION-GAMES-MENU-I-7"        "Sonic Robot Blast 2: Sonic Robo Blast 2. A 3-D Sonic fan-game based off of Doom Legacy."
    localize_info "INSTALL-ACTION-GAMES-MENU-8"   "Steelstorm"
    localize_info "INSTALL-ACTION-GAMES-MENU-I-8"        "Steelstorm: a classic top down shooter, rife with explosions and things to explode, with a distinct visual style."
    localize_info "INSTALL-ACTION-GAMES-MENU-9"   "Yo Frankie!"
    localize_info "INSTALL-ACTION-GAMES-MENU-I-9"        "Yo Frankie!: A 3D platform game based on the bully rodent in Big Buck Bunny"
fi
# -------------------------------------
install_action_games_menu()
{
    local -r menu_name="ACTION-ADVENTURE-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                       # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"                 # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="1-9"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-ACTION-GAMES-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACTION-GAMES-MENU-1" "" ""     "INSTALL-ACTION-GAMES-MENU-I-1" "MenuTheme[@]" # 1 Astromenace
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACTION-GAMES-MENU-2" "" "$AUR" "INSTALL-ACTION-GAMES-MENU-I-2" "MenuTheme[@]" # 2 Counter-Strike 2D
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACTION-GAMES-MENU-3" "" "$AUR" "INSTALL-ACTION-GAMES-MENU-I-3" "MenuTheme[@]" # 3 Dead Cyborg Episode 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACTION-GAMES-MENU-4" "" "$AUR" "INSTALL-ACTION-GAMES-MENU-I-4" "MenuTheme[@]" # 4 
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACTION-GAMES-MENU-5" "" "$AUR" "INSTALL-ACTION-GAMES-MENU-I-5" "MenuTheme[@]" # 5 
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACTION-GAMES-MENU-6" "" "$AUR" "INSTALL-ACTION-GAMES-MENU-I-6" "MenuTheme[@]" # 6 
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACTION-GAMES-MENU-7" "" "$AUR" "INSTALL-ACTION-GAMES-MENU-I-7" "MenuTheme[@]" # 7 
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACTION-GAMES-MENU-8" "" "$AUR" "INSTALL-ACTION-GAMES-MENU-I-8" "MenuTheme[@]" # 8 
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACTION-GAMES-MENU-9" "" "$AUR" "INSTALL-ACTION-GAMES-MENU-I-9" "MenuTheme[@]" # 9 
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Astromenace
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_ASTROMENANCE\" 'INSTALL-ASTROMENANCE'" "INSTALL-ASTROMENANCE" ; then
                        add_package "$INSTALL_ASTROMENANCE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACTION-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Counter-Strike 2D
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_COUNTER_STRIKE_2D\" 'AUR-INSTALL-COUNTER-STRIKE-2D'" "AUR-INSTALL-COUNTER-STRIKE-2D" ; then
                        add_aur_package "$AUR_INSTALL_COUNTER_STRIKE_2D"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACTION-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Dead Cyborg Episode 1
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_DEAD_CYBORG_EP_1\" 'AUR-INSTALL-DEAD-CYBORG-EP-1'" "AUR-INSTALL-DEAD-CYBORG-EP-1" ; then
                        add_aur_package "$AUR_INSTALL_DEAD_CYBORG_EP_1"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACTION-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_MARS_SHOOTER\" 'AUR-INSTALL-MARS-SHOOTER'" "AUR-INSTALL-MARS-SHOOTER" ; then
                        add_aur_package "$AUR_INSTALL_MARS_SHOOTER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACTION-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_NIKKI\" 'AUR-INSTALL-NIKKI'" "AUR-INSTALL-NIKKI" ; then
                        add_aur_package "$AUR_INSTALL_NIKKI"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACTION-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_OPENTYRIAN\" 'AUR-INSTALL-OPENTYRIAN'" "AUR-INSTALL-OPENTYRIAN" ; then
                        add_aur_package "$AUR_INSTALL_OPENTYRIAN"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACTION-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_SRB2\" 'AUR-INSTALL-SRB2" "AUR-INSTALL-SRB2" ; then
                        add_aur_package "$AUR_INSTALL_SRB2"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACTION-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_STEELSTORM\" 'AUR-INSTALL-STEELSTORM'" "AUR-INSTALL-STEELSTORM" ; then
                        add_aur_package "$AUR_INSTALL_STEELSTORM"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACTION-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_YOFRANKIE\" 'AUR-INSTALL-YOFRANKIE'" "AUR-INSTALL-YOFRANKIE" ; then
                        add_aur_package "$AUR_INSTALL_YOFRANKIE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACTION-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL ARCADE GAMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_arade_games_menu"
    USAGE="install_arade_games_menu"
    DESCRIPTION=$(localize "INSTALL-ARCADE-GAMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-ARCADE-GAMES-DESC"  "Install Arcade Platformer Games"
    localize_info "INSTALL-ARCADE-GAMES-TITLE" "Install Arcade Platformer Games"
    #
    localize_info "INSTALL-ARCADE-GAMES-MENU-1"     "Abuse"
    localize_info "INSTALL-ARCADE-GAMES-MENU-I-1"         "Abuse: A side-scroller action game that pits you against ruthless alien killers."
    localize_info "INSTALL-ARCADE-GAMES-MENU-2"     "Battle Tanks"
    localize_info "INSTALL-ARCADE-GAMES-MENU-I-2"         "Battle Tanks: Fast 2d tank arcade game with multiplayer and split-screen modes."
    localize_info "INSTALL-ARCADE-GAMES-MENU-3"     "Bomberclone"
    localize_info "INSTALL-ARCADE-GAMES-MENU-I-3"         "Bomberclone: A clone of the game AtomicBomberMan."
    localize_info "INSTALL-ARCADE-GAMES-MENU-4"     "Those Funny Funguloids"
    localize_info "INSTALL-ARCADE-GAMES-MENU-I-4"         "Those Funny Funguloids: 3D game about collecting mushrooms in outerspace"
    localize_info "INSTALL-ARCADE-GAMES-MENU-5"     "Frogatto"
    localize_info "INSTALL-ARCADE-GAMES-MENU-I-5"         "Frogatto: An old-school 2d platformer game, starring a certain quixotic frog"
    localize_info "INSTALL-ARCADE-GAMES-MENU-6"     "Goonies"
    localize_info "INSTALL-ARCADE-GAMES-MENU-I-6"         "Goonies: A remake of the MSX Goonies game"
    localize_info "INSTALL-ARCADE-GAMES-MENU-7"     "Mari0"
    localize_info "INSTALL-ARCADE-GAMES-MENU-I-7"         "Mari0: The Mario game with Portal gun mechanics"
    localize_info "INSTALL-ARCADE-GAMES-MENU-8"     "Neverball"
    localize_info "INSTALL-ARCADE-GAMES-MENU-I-8"         "Neverball: 3D game similar to Super Monkey Ball or Marble Madness"
    localize_info "INSTALL-ARCADE-GAMES-MENU-9"     "Opensonic"
    localize_info "INSTALL-ARCADE-GAMES-MENU-I-9"         "Opensonic: Game based on the Sonic the Hedgehog Universe."
    localize_info "INSTALL-ARCADE-GAMES-MENU-10"    "Robombs"
    localize_info "INSTALL-ARCADE-GAMES-MENU-I-10"        "Robombs: A free LAN game inspired by Bomberman"
    localize_info "INSTALL-ARCADE-GAMES-MENU-11"    "Super Mario Chronicles"
    localize_info "INSTALL-ARCADE-GAMES-MENU-I-11"        "Super Mario Chronicles: Secret Maryo Chronicles"
    localize_info "INSTALL-ARCADE-GAMES-MENU-12"    "Xmoto"
    localize_info "INSTALL-ARCADE-GAMES-MENU-I-12"        "Xmoto: A challenging 2D motocross platform game, where physics play an important role."
fi
# -------------------------------------
install_arade_games_menu()
{
    local -r menu_name="INSTALL-ARCADE-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                     # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 11"            # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="1-12"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 1 2"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 1 2 11"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-ARCADE-GAMES-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ARCADE-GAMES-MENU-1"  "" ""     "INSTALL-ARCADE-GAMES-MENU-I-1"  "MenuTheme[@]" # 1  Abuse
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ARCADE-GAMES-MENU-2"  "" ""     "INSTALL-ARCADE-GAMES-MENU-I-2"  "MenuTheme[@]" # 2  Battle Tanks
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ARCADE-GAMES-MENU-3"  "" ""     "INSTALL-ARCADE-GAMES-MENU-I-3"  "MenuTheme[@]" # 3  Bomberclone
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ARCADE-GAMES-MENU-4"  "" "$AUR" "INSTALL-ARCADE-GAMES-MENU-I-4"  "MenuTheme[@]" # 4  Those Funny Funguloids
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ARCADE-GAMES-MENU-5"  "" ""     "INSTALL-ARCADE-GAMES-MENU-I-5"  "MenuTheme[@]" # 5  Frogatto  
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ARCADE-GAMES-MENU-6"  "" "$AUR" "INSTALL-ARCADE-GAMES-MENU-I-6"  "MenuTheme[@]" # 6  Goonies
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ARCADE-GAMES-MENU-7"  "" "$AUR" "INSTALL-ARCADE-GAMES-MENU-I-7"  "MenuTheme[@]" # 7  Mari0
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ARCADE-GAMES-MENU-8"  "" ""     "INSTALL-ARCADE-GAMES-MENU-I-8"  "MenuTheme[@]" # 8  Neverball
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ARCADE-GAMES-MENU-9"  "" "$AUR" "INSTALL-ARCADE-GAMES-MENU-I-9"  "MenuTheme[@]" # 9  Opensonic
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ARCADE-GAMES-MENU-10" "" "$AUR" "INSTALL-ARCADE-GAMES-MENU-I-10" "MenuTheme[@]" # 10 Robombs
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ARCADE-GAMES-MENU-11" "" ""     "INSTALL-ARCADE-GAMES-MENU-I-11" "MenuTheme[@]" # 11 Super Mario Chronicles
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ARCADE-GAMES-MENU-12" "" ""     "INSTALL-ARCADE-GAMES-MENU-I-12" "MenuTheme[@]" # 12 Xmoto
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Abuse
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_ABUSE\" 'INSTALL-ABUSE'" "INSTALL-ABUSE" ; then
                        add_package "$INSTALL_ABUSE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ARCADE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Battle Tanks
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_BTANKS\" 'INSTALL-BTANKS'" "INSTALL-BTANKS" ; then
                        add_package "$INSTALL_BTANKS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ARCADE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Bomberclone
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_BOMBERCLONE\" 'INSTALL-BOMBERCLONE'" "INSTALL-BOMBERCLONE" ; then
                        add_package "$INSTALL_BOMBERCLONE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ARCADE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Those Funny Funguloids
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_FUNGULOIDS\" 'AUR-INSTALL-FUNGULOIDS'" "AUR-INSTALL-FUNGULOIDS" ; then
                        add_aur_package "$AUR_INSTALL_FUNGULOIDS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ARCADE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Frogatto
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_FROGATTO\" 'INSTALL-FROGATTO'" "INSTALL-FROGATTO" ; then
                        add_package "$INSTALL_FROGATTO"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ARCADE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Goonies
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GOONIES\" 'AUR-INSTALL-GOONIES'" "AUR-INSTALL-GOONIES" ; then
                        add_aur_package "$AUR_INSTALL_GOONIES"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ARCADE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # Mari0
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_MARI0\" 'AUR-INSTALL-MARI0'" "AUR-INSTALL-MARI0" ; then
                        add_aur_package "$AUR_INSTALL_MARI0"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ARCADE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # Neverball
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_NEVERBALL\" 'INSTALL-NEVERBALL'" "INSTALL-NEVERBALL" ; then
                        add_package "$INSTALL_NEVERBALL"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ARCADE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # Opensonic
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_OPENSONIC\" 'AUR-INSTALL-OPENSONIC'" "AUR-INSTALL-OPENSONIC" ; then
                        add_aur_package "$AUR_INSTALL_OPENSONIC"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ARCADE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               10)  # Robombs
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ROBOMBS_BIN\" 'AUR-INSTALL-ROBOMBS-BIN'" "AUR-INSTALL-ROBOMBS-BIN" ; then
                        add_aur_package "$AUR_INSTALL_ROBOMBS_BIN"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ARCADE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               11)  # Super Mario Chronicles
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_SMC\" 'INSTALL-SMC'" "INSTALL-SMC" ; then
                        add_package "$INSTALL_SMC"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ARCADE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               12)  # Xmoto
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_XMOTO\" 'INSTALL-XMOTO'" "INSTALL-XMOTO" ; then
                        add_package "$INSTALL_XMOTO"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ARCADE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL DUNGEON GAMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_dungon_games_menu"
    USAGE="install_dungon_games_menu"
    DESCRIPTION=$(localize "INSTALL-DUNGEON-GAMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-DUNGEON-GAMES-DESC"   "Install Dungon Games"
    #
    localize_info "INSTALL-DUNGEON-GAMES-MENU-1"    "Adom"
    localize_info "INSTALL-DUNGEON-GAMES-MENU-I-1"       "Adom: A roguelike game with a quest-centric, plot driven structure"
    localize_info "INSTALL-DUNGEON-GAMES-MENU-2"    "Tales of MajEyal"
    localize_info "INSTALL-DUNGEON-GAMES-MENU-I-2"       "Tales of MajEyal: An open-source, single-player, role-playing roguelike game set in the world of Eyal."
    localize_info "INSTALL-DUNGEON-GAMES-MENU-3"    "Lost Labyrinth"
    localize_info "INSTALL-DUNGEON-GAMES-MENU-I-3"       "Lost Labyrinth: RPG turn based game"
    localize_info "INSTALL-DUNGEON-GAMES-MENU-4"    "S.C.O.U.R.G.E."
    localize_info "INSTALL-DUNGEON-GAMES-MENU-I-4"       "S.C.O.U.R.G.E.: A rogue-like game with a 3d graphical front-end"
    localize_info "INSTALL-DUNGEON-GAMES-MENU-5"    "Stone-Soupe"
    localize_info "INSTALL-DUNGEON-GAMES-MENU-I-5"       "Stone-Soupe: An open-source, single-player, role-playing roguelike game of exploration and treasure-hunting"
fi
# -------------------------------------
install_dungon_games_menu()
{
    local -r menu_name="INSTALL-DUNGEON-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                      # Q=Quit, D=Done, B=Back
    local RecommendedOptions="5"       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="1-5"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-DUNGEON-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DUNGEON-GAMES-MENU-1" "" "$AUR" "INSTALL-DUNGEON-GAMES-MENU-I-1" "MenuTheme[@]" # 1 Adom
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DUNGEON-GAMES-MENU-2" "" "$AUR" "INSTALL-DUNGEON-GAMES-MENU-I-2" "MenuTheme[@]" # 2 Tales of MajEyal
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DUNGEON-GAMES-MENU-3" "" "$AUR" "INSTALL-DUNGEON-GAMES-MENU-I-3" "MenuTheme[@]" # 3 Lost Labyrinth
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DUNGEON-GAMES-MENU-4" "" "$AUR" "INSTALL-DUNGEON-GAMES-MENU-I-4" "MenuTheme[@]" # 4 S.C.O.U.R.G.E.
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DUNGEON-GAMES-MENU-5" "" ""     "INSTALL-DUNGEON-GAMES-MENU-I-5" "MenuTheme[@]" # 5 Stone-Soupe
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Adom
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ADOM\" 'AUR-INSTALL-ADOM'" "AUR-INSTALL-ADOM" ; then
                        add_aur_package "$AUR_INSTALL_ADOM"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DUNGEON-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Tales of MajEyal
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_TOME4\" 'AUR-INSTALL-TOME4'" "AUR-INSTALL-TOME4" ; then
                        add_aur_package "$AUR_INSTALL_TOME4"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DUNGEON-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Lost Labyrinth
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_LOST_LABYRINTH\" 'AUR-INSTALL-LOST-LABYRINTH'" "AUR-INSTALL-LOST-LABYRINTH" ; then
                        add_aur_package "$AUR_INSTALL_LOST_LABYRINTH"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DUNGEON-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # S.C.O.U.R.G.E.
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_SCOURGE\" 'AUR-INSTALL-SCOURGE'" "AUR-INSTALL-SCOURGE" ; then
                        add_aur_package "$AUR_INSTALL_SCOURGE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DUNGEON-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Stone-Soupe
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_STONE_SOUP\" 'AUR-INSTALL-STONE-SOUP'" "AUR-INSTALL-STONE-SOUP" ; then
                        add_aur_package "$AUR_INSTALL_STONE_SOUP"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DUNGEON-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL EMULATORS GAMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_emulator_games_menu"
    USAGE="install_emulator_games_menu"
    DESCRIPTION=$(localize "INSTALL-EMULATORS-GAMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-EMULATORS-GAMES-DESC"   "Install Emulator Games"
    #
    localize_info "INSTALL-EMULATORS-GAMES-MENU-1"    "BSNES"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-I-1"        "BSNES: A library that exposes the core emulation of BSNES, a Super Nintendo Entertainment System (SNES) emulator."
    localize_info "INSTALL-EMULATORS-GAMES-MENU-2"    "Desmume-svn"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-I-2"        "Desmume-svn: Nintendo DS emulator, svn version"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-3"    "Dolphin"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-I-3"        "Dolphin: A Gamecube / Wii / Triforce Emulator"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-4"    "Epsxe"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-I-4"        "Epsxe: Enhanced PSX emulator"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-5"    "Project 64"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-I-5"        "Project 64: A very popular and accurate Nintendo 64 Emulator (run via wine)"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-6"    "Visual Boy Advanced"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-I-6"        "Visual Boy Advanced: Gameboy Advance Emulator combining features of all VBA forks - GTK GUI"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-7"    "wxmupen64plus"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-I-7"        "wxmupen64plus: A full-featured frontend for Mupen64Plus written using wxWidgets"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-8"    "zsnes"
    localize_info "INSTALL-EMULATORS-GAMES-MENU-I-8"        "zsnes: Super Nintendo emulator"
fi
# -------------------------------------
install_emulator_games_menu()
{
    local -r menu_name="INSTALL-EMULATORS-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                        # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""                   # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="1-8"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-EMULATORS-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EMULATORS-GAMES-MENU-1" "" "$AUR" "INSTALL-EMULATORS-GAMES-MENU-I-1" "MenuTheme[@]" # 1 BSNES
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EMULATORS-GAMES-MENU-2" "" "$AUR" "INSTALL-EMULATORS-GAMES-MENU-I-2" "MenuTheme[@]" # 2 Desmume-svn
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EMULATORS-GAMES-MENU-3" "" "$AUR" "INSTALL-EMULATORS-GAMES-MENU-I-3" "MenuTheme[@]" # 3 Dolphin
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EMULATORS-GAMES-MENU-4" "" "$AUR" "INSTALL-EMULATORS-GAMES-MENU-I-4" "MenuTheme[@]" # 4 Epsxe
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EMULATORS-GAMES-MENU-5" "" "$AUR" "INSTALL-EMULATORS-GAMES-MENU-I-5" "MenuTheme[@]" # 5 Project 64
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EMULATORS-GAMES-MENU-6" "" "$AUR" "INSTALL-EMULATORS-GAMES-MENU-I-6" "MenuTheme[@]" # 6 Visual Boy Advanced
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EMULATORS-GAMES-MENU-7" "" "$AUR" "INSTALL-EMULATORS-GAMES-MENU-I-7" "MenuTheme[@]" # 7 wxmupen64plus
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EMULATORS-GAMES-MENU-8" "" ""     "INSTALL-EMULATORS-GAMES-MENU-I-8" "MenuTheme[@]" # 8 zsnes
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # BSNES
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_BSNES\" 'AUR-INSTALL-BSNES'" "AUR-INSTALL-BSNES" ; then
                        add_aur_package "$AUR_INSTALL_BSNES"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-EMULATORS-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Desmume-svn
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_DESMUME\" 'AUR-INSTALL-DESMUME'" "AUR-INSTALL-DESMUME" ; then
                        add_aur_package "$AUR_INSTALL_DESMUME"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-EMULATORS-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Dolphin
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_DOLPHIN\" 'AUR-INSTALL-DOLPHIN'" "AUR-INSTALL-DOLPHIN" ; then
                        add_aur_package "$AUR_INSTALL_DOLPHIN"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-EMULATORS-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Epsxe
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_EPSXE\" 'AUR-INSTALL-EPSXE'" "AUR-INSTALL-EPSXE" ; then
                        add_aur_package "$AUR_INSTALL_EPSXE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-EMULATORS-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Project 64
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_PROJECT_64\" 'AUR-INSTALL-PROJECT-64'" "AUR-INSTALL-PROJECT-64" ; then
                        add_aur_package "$AUR_INSTALL_PROJECT_64"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-EMULATORS-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Visual Boy Advanced
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_VBA\" 'AUR-INSTALL-VBA'" "AUR-INSTALL-VBA" ; then
                        add_aur_package "$AUR_INSTALL_VBA"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-EMULATORS-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # wxmupen64plus
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_WXMUPEN64PLUS\" 'AUR-INSTALL-WXMUPEN64PLUS'" "AUR-INSTALL-WXMUPEN64PLUS" ; then
                        add_aur_package "$AUR_INSTALL_WXMUPEN64PLUS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-EMULATORS-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # zsnes
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_ZSNES\" 'INSTALL-ZSNES'" "INSTALL-ZSNES" ; then
                        add_package "$INSTALL_ZSNES"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-EMULATORS-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL FPS GAMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_fps_games_menu"
    USAGE="install_fps_games_menu"
    DESCRIPTION=$(localize "INSTALL-FPS-GAMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-FPS-GAMES-DESC"   "Install FPS Games"
    #
    localize_info "INSTALL-FPS-GAMES-MENU-1"    "Alienarena"
    localize_info "INSTALL-FPS-GAMES-MENU-I-1"      "Alienarena: Multiplayer retro sci-fi deathmatch game"
    localize_info "INSTALL-FPS-GAMES-MENU-2"    "Warsow"
    localize_info "INSTALL-FPS-GAMES-MENU-I-2"      "Warsow: Free online multiplayer competitive FPS based on the Qfusion engine"
    localize_info "INSTALL-FPS-GAMES-MENU-3"    "Wolfenstein"
    localize_info "INSTALL-FPS-GAMES-MENU-I-3"      "Wolfenstein: Enemy Territory is a completely free, standalone, team-based, multiplayer FPS. enemy-territory"
    localize_info "INSTALL-FPS-GAMES-MENU-4"    "World of Padman"
    localize_info "INSTALL-FPS-GAMES-MENU-I-4"      "World of Padman: Cartoon-style multiplayer first-person shooter"
    localize_info "INSTALL-FPS-GAMES-MENU-5"    "Xonotic"
    localize_info "INSTALL-FPS-GAMES-MENU-I-5"      "Xonotic: A free, fast-paced crossplatform first-person shooter"
fi
# -------------------------------------
install_fps_games_menu()
{
    local -r menu_name="INSTALL-FPS-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                  # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""             # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="1-5"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-FPS-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-FPS-GAMES-MENU-1" "" ""     "INSTALL-FPS-GAMES-MENU-I-1" "MenuTheme[@]" # 1 Alienarena
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-FPS-GAMES-MENU-2" "" ""     "INSTALL-FPS-GAMES-MENU-I-2" "MenuTheme[@]" # 2 Warsow
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-FPS-GAMES-MENU-3" "" "$AUR" "INSTALL-FPS-GAMES-MENU-I-3" "MenuTheme[@]" # 3 Wolfenstein
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-FPS-GAMES-MENU-4" "" "$AUR" "INSTALL-FPS-GAMES-MENU-I-4" "MenuTheme[@]" # 4 World of Padman
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-FPS-GAMES-MENU-5" "" ""     "INSTALL-FPS-GAMES-MENU-I-5" "MenuTheme[@]" # 5 Xonotic
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Alienarena
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_ALIENARENA\" 'INSTALL-ALIENARENA'" "INSTALL-ALIENARENA" ; then
                        add_package "$INSTALL_ALIENARENA"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-FPS-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Warsow
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_WARSOW\" 'INSTALL-WARSOW'" "INSTALL-WARSOW" ; then
                        add_package "$INSTALL_WARSOW"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-FPS-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Wolfenstein
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ENEMY_TERRITORY\" 'AUR-INSTALL-ENEMY-TERRITORY'" "AUR-INSTALL-ENEMY-TERRITORY" ; then
                        add_aur_package "$AUR_INSTALL_ENEMY_TERRITORY"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-FPS-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # World of Padman
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_WORLD_OF_PADMAN\" 'AUR-INSTALL-WORLD-OF-PADMAN'" "AUR-INSTALL-WORLD-OF-PADMAN" ; then
                        add_aur_package "$AUR_INSTALL_WORLD_OF_PADMAN"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-FPS-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Xonotic
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_XONOTIC\" 'INSTALL-XONOTIC'" "INSTALL-XONOTIC" ; then
                        add_package "$INSTALL_XONOTIC"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-FPS-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL MMO GAMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_mmo_games_menu"
    USAGE="install_mmo_games_menu"
    DESCRIPTION=$(localize "INSTALL-MMO-GAMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-MMO-GAMES-DESC"   "Install MMO Games"
    #
    localize_info "INSTALL-MMO-GAMES-MENU-1"    "Heroes of Newerth"
    localize_info "INSTALL-MMO-GAMES-MENU-I-1"       "Heroes of Newerth: Heroes of Newerth is a Real Time Strategy game heavily influcenced by DotA"
    localize_info "INSTALL-MMO-GAMES-MENU-2"    "Manaplus"
    localize_info "INSTALL-MMO-GAMES-MENU-I-2"       "Manaplus: ManaPlus is a 2D MMORPG game advanced client for games based on eAthena fork The Mana World (tAthena) also for other forks like Evol."
    localize_info "INSTALL-MMO-GAMES-MENU-3"    "Runescape"
    localize_info "INSTALL-MMO-GAMES-MENU-I-3"       "Runescape: Runescape Client for Linux and Unix. unix-runescape-client"
    localize_info "INSTALL-MMO-GAMES-MENU-4"    "Savage 2"
    localize_info "INSTALL-MMO-GAMES-MENU-I-4"       "Savage 2: A Tortured Soul is an fantasy themed online multiplayer team-based FPS/RTS/RPG hybrid. Completely free as of December 2008."
    localize_info "INSTALL-MMO-GAMES-MENU-5"    "Spiral Knights"
    localize_info "INSTALL-MMO-GAMES-MENU-I-5"       "Spiral Knights: The Spiral Knights have awoken on an alien world. Their equipment stores have been raided and their starship, The Skylark, will not recover from the crash. They must work together to survive on a journey that will take them to the very core of the world."
    localize_info "INSTALL-MMO-GAMES-MENU-6"    "Wakfu"
    localize_info "INSTALL-MMO-GAMES-MENU-I-6"       "Wakfu: A turn-based tactical Massively Multiplayer Online Role-playing Game (MMORPG) written in Java/OpenGL."
fi
# -------------------------------------
install_mmo_games_menu()
{
    local -r menu_name="INSTALL-MMO-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                  # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""             # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="1-6"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-MMO-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MMO-GAMES-MENU-1" "" "$AUR" "INSTALL-MMO-GAMES-MENU-I-1" "MenuTheme[@]" # 1 Heroes of Newerth
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MMO-GAMES-MENU-2" "" "$AUR" "INSTALL-MMO-GAMES-MENU-I-2" "MenuTheme[@]" # 2 Manaplus
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MMO-GAMES-MENU-3" "" "$AUR" "INSTALL-MMO-GAMES-MENU-I-3" "MenuTheme[@]" # 3 Runescape
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MMO-GAMES-MENU-4" "" "$AUR" "INSTALL-MMO-GAMES-MENU-I-4" "MenuTheme[@]" # 4 Savage 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MMO-GAMES-MENU-5" "" "$AUR" "INSTALL-MMO-GAMES-MENU-I-5" "MenuTheme[@]" # 5 Spiral Knights
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MMO-GAMES-MENU-6" "" "$AUR" "INSTALL-MMO-GAMES-MENU-I-6" "MenuTheme[@]" # 6 Wakfu
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Heroes of Newerth
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_HON\" 'AUR-INSTALL-HON'" "AUR-INSTALL-HON" ; then
                        add_aur_package "$AUR_INSTALL_HON"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-MMO-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Manaplus
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_MANAPLUS\" 'AUR-INSTALL-MANAPLUS'" "AUR-INSTALL-MANAPLUS" ; then
                        add_aur_package "$AUR_INSTALL_MANAPLUS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-MMO-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Runescape
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_RUNESCAPE\" 'AUR-INSTALL-RUNESCAPE'" "AUR-INSTALL-RUNESCAPE" ; then
                        add_aur_package "$AUR_INSTALL_RUNESCAPE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-MMO-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Savage 2
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_SAVAGE_2\" 'AUR-INSTALL-SAVAGE-2'" "AUR-INSTALL-SAVAGE-2" ; then
                        add_aur_package "$AUR_INSTALL_SAVAGE_2"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-MMO-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Spiral Knights
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_KNIGHTS\" 'AUR-INSTALL-SPIRAL-KNIGHTS'" "AUR-INSTALL-SPIRAL-KNIGHTS" ; then
                        add_aur_package "$AUR_INSTALL_SPIRAL_KNIGHTS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-MMO-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Wakfu
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_WAKFU\" 'AUR-INSTALL-WAKFU'" "AUR-INSTALL-WAKFU" ; then
                        add_aur_package "$AUR_INSTALL_WAKFU"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-MMO-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL PUZZLE GAMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_puzzle_games_menu"
    USAGE="install_puzzle_games_menu"
    DESCRIPTION=$(localize "INSTALL-PUZZLE-GAMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-PUZZLE-GAMES-DESC"   "Install Puzzle Games"
    #
    localize_info "INSTALL-PUZZLE-GAMES-MENU-1"    "frozen-bubble"
    localize_info "INSTALL-PUZZLE-GAMES-MENU-I-1"       "frozen-bubble: A game in which you throw colorful bubbles and build groups to destroy the bubbles"
    localize_info "INSTALL-PUZZLE-GAMES-MENU-2"    "Numptyphysics"
    localize_info "INSTALL-PUZZLE-GAMES-MENU-I-2"       "Numptyphysics: a drawing puzzle game in the spirit of Crayon Physics"
fi
# -------------------------------------
install_puzzle_games_menu()
{
    local -r menu_name="INSTALL-PUZZLE-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                     # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"               # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="1-2"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-PUZZLE-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PUZZLE-GAMES-MENU-1" "" ""     "INSTALL-PUZZLE-GAMES-MENU-I-1" "MenuTheme[@]" # frozen-bubble
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-PUZZLE-GAMES-MENU-2" "" "$AUR" "INSTALL-PUZZLE-GAMES-MENU-I-2" "MenuTheme[@]" # Numptyphysics
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # frozen-bubble
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_FROZEN_BUBBLE\" 'INSTALL-FROZEN-BUBBLE'" "INSTALL-FROZEN-BUBBLE" ; then
                        add_package "$INSTALL_FROZEN_BUBBLE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PUZZLE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Numptyphysics
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_NUMPTYPHYSICS\" 'AUR-INSTALL-NUMPTYPHYSICS'" "AUR-INSTALL-NUMPTYPHYSICS" ; then
                        add_aur_package "$AUR_INSTALL_NUMPTYPHYSICS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-PUZZLE-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL RPG GAMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_rpg_games_menu"
    USAGE="install_rpg_games_menu"
    DESCRIPTION=$(localize "INSTALL-RPG-GAMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-RPG-GAMES-DESC"   "Install RPG GAMES"
    #
    localize_info "INSTALL-RPG-GAMES-MENU-1"    "Ardentryst"
    localize_info "INSTALL-RPG-GAMES-MENU-I-1"       "Ardentryst: An Action/RPG sidescoller with a focus on story and character development"
    localize_info "INSTALL-RPG-GAMES-MENU-2"    "Flare RPG"
    localize_info "INSTALL-RPG-GAMES-MENU-I-2"       "Flare RPG: Open Source Action Roleplaying Game"
    localize_info "INSTALL-RPG-GAMES-MENU-3"    "Freedroid RPG"
    localize_info "INSTALL-RPG-GAMES-MENU-I-3"       "Freedroid RPG: A Mature Science Fiction Role Playing game set in the future"
fi
# -------------------------------------
install_rpg_games_menu()
{
    local -r menu_name="INSTALL-RPG-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                  # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""             # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="1-3"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-RPG-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RPG-GAMES-MENU-1" "" "$AUR" "INSTALL-RPG-GAMES-MENU-I-1" "MenuTheme[@]" # 1 Ardentryst
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RPG-GAMES-MENU-2" "" "$AUR" "INSTALL-RPG-GAMES-MENU-I-2" "MenuTheme[@]" # 2 Flare RPG
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RPG-GAMES-MENU-3" "" ""     "INSTALL-RPG-GAMES-MENU-I-3" "MenuTheme[@]" # 3 Freedroid RPG
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Ardentryst
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ARDENTRYST\" 'AUR-INSTALL-ARDENTRYST'" "AUR-INSTALL-ARDENTRYST" ; then
                        add_aur_package "$AUR_INSTALL_ARDENTRYST"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-RPG-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Flare RPG
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_FLARE_RPG\" 'AUR-INSTALL-FLARE-RPG'" "AUR-INSTALL-FLARE-RPG" ; then
                        add_aur_package "$AUR_INSTALL_FLARE_RPG"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-RPG-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Freedroid RPG
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_FREEDROUDRPG\" 'INSTALL-FREEDROUDRPG'" "INSTALL-FREEDROUDRPG" ; then
                        add_package "$INSTALL_FREEDROUDRPG"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-RPG-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL RACING GAMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_racing_games_menu"
    USAGE="install_racing_games_menu"
    DESCRIPTION=$(localize "INSTALL-RACING-GAMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-RACING-GAMES-DESC"   "Install Racing Games"
    #
    localize_info "INSTALL-RACING-GAMES-MENU-1"    "Maniadrive"
    localize_info "INSTALL-RACING-GAMES-MENU-I-1"        "Maniadrive: An acrobatic racing game"
    localize_info "INSTALL-RACING-GAMES-MENU-2"    "Death Rally"
    localize_info "INSTALL-RACING-GAMES-MENU-I-2"        "Death Rally: A free windows port of the classic racing game from Remedy games, played in Wine."
    localize_info "INSTALL-RACING-GAMES-MENU-3"    "Stun Trally"
    localize_info "INSTALL-RACING-GAMES-MENU-I-3"        "Stun Trally: Stunt Rally game with track editor, based on VDrift and OGRE"
    localize_info "INSTALL-RACING-GAMES-MENU-4"    "Supertuxkart"
    localize_info "INSTALL-RACING-GAMES-MENU-I-4"        "Supertuxkart: Kart racing game featuring Tux and his friends"
    localize_info "INSTALL-RACING-GAMES-MENU-5"    "Speed Dreams"
    localize_info "INSTALL-RACING-GAMES-MENU-I-5"        "Speed Dreams: A racing simulator with rich graphics and physics"
fi
# -------------------------------------
install_racing_games_menu()
{
    local -r menu_name="INSTALL-RACING-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                     # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""                # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="1-5"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 5"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-RACING-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RACING-GAMES-MENU-1" "" "$AUR" "INSTALL-RACING-GAMES-MENU-I-1" "MenuTheme[@]" # 1 Maniadrive
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RACING-GAMES-MENU-2" "" "$AUR" "INSTALL-RACING-GAMES-MENU-I-2" "MenuTheme[@]" # 2 Death Rally
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RACING-GAMES-MENU-3" "" "$AUR" "INSTALL-RACING-GAMES-MENU-I-3" "MenuTheme[@]" # 3 Stun Trally
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RACING-GAMES-MENU-4" "" ""     "INSTALL-RACING-GAMES-MENU-I-4" "MenuTheme[@]" # 4 Supertuxkart
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RACING-GAMES-MENU-5" "" ""     "INSTALL-RACING-GAMES-MENU-I-5" "MenuTheme[@]" # 5 Speed Dreams
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Maniadrive
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_MANIADRIVE\" 'AUR-INSTALL-MANIADRIVE'" "AUR-INSTALL-MANIADRIVE" ; then
                        add_aur_package "$AUR_INSTALL_MANIADRIVE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-RACING-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Death Rally
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_DEATH_RALLY\" 'AUR-INSTALL-DEATH-RALLY'" "AUR-INSTALL-DEATH-RALLY" ; then
                        add_aur_package "$AUR_INSTALL_DEATH_RALLY"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-RACING-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Stun Trally
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_STUNTRALLY\" 'AUR-INSTALL-STUNTRALLY'" "AUR-INSTALL-STUNTRALLY" ; then
                        add_aur_package "$AUR_INSTALL_STUNTRALLY"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-RACING-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Supertuxkart
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_SUPTERTUXKART\" 'INSTALL-SUPTERTUXKART'" "INSTALL-SUPTERTUXKART" ; then
                        add_package "$INSTALL_SUPTERTUXKART"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-RACING-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Speed Dreams
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_SPEED_DREAMS\" 'INSTALL-SPEED-DREAMS'" "INSTALL-SPEED-DREAMS" ; then
                        add_package "$INSTALL_SPEED_DREAMS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-RACING-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL SIMULATION GAMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_simulation_games_menu"
    USAGE="install_simulation_games_menu"
    DESCRIPTION=$(localize "INSTALL-SIMULATION-GAMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-SIMULATION-GAMES-DESC"   "Install Simulation Games"
    #
    localize_info "INSTALL-SIMULATION-GAMES-MENU-1"    "Simutrans"
    localize_info "INSTALL-SIMULATION-GAMES-MENU-I-1"        "Simutrans: An Open Source Transportation Simulation Game"
    localize_info "INSTALL-SIMULATION-GAMES-MENU-2"    "Theme Hospital"
    localize_info "INSTALL-SIMULATION-GAMES-MENU-I-2"        "Theme Hospital: Reimplementation of the Game Engine of Theme Hospital. corsix-th"
    localize_info "INSTALL-SIMULATION-GAMES-MENU-3"    "Openttd"
    localize_info "INSTALL-SIMULATION-GAMES-MENU-I-3"        "Openttd: An Engine for Running Transport Tycoon Deluxe."
fi
# -------------------------------------
install_simulation_games_menu()
{
    local -r menu_name="INSTALL-SIMULATION-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                         # Q=Quit, D=Done, B=Back
    local RecommendedOptions="3"                   # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="1-3"
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 1"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-SIMULATION-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SIMULATION-GAMES-MENU-1" "" ""     "INSTALL-SIMULATION-GAMES-MENU-I-1" "MenuTheme[@]" # 1 Simutrans
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SIMULATION-GAMES-MENU-2" "" "$AUR" "INSTALL-SIMULATION-GAMES-MENU-I-2" "MenuTheme[@]" # 2 Theme Hospital 
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SIMULATION-GAMES-MENU-3" "" ""     "INSTALL-SIMULATION-GAMES-MENU-I-3" "MenuTheme[@]" # 3 Openttd
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Simutrans
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_SIMUTRANS\" 'INSTALL-SIMUTRANS'" "INSTALL-SIMUTRANS" ; then
                        add_package "$INSTALL_SIMUTRANS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-SIMULATION-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Theme Hospital
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_CORSIX_TH\" 'AUR-INSTALL-CORSIX-TH'" "AUR-INSTALL-CORSIX-TH" ; then
                        add_aur_package "$AUR_INSTALL_CORSIX_TH"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-SIMULATION-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Openttd
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_OPENTTD\" 'INSTALL-OPENTTD'" "INSTALL-OPENTTD" ; then
                        add_package "$INSTALL_OPENTTD"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-SIMULATION-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL STRATEGY GAMES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_strategy_games_menu"
    USAGE="install_strategy_games_menu"
    DESCRIPTION=$(localize "INSTALL-STRATEGY-GAMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-STRATEGY-GAMES-DESC"   "Install Strategy Games"
    #
    localize_info "INSTALL-STRATEGY-GAMES-MENU-1"    "0ad"
    localize_info "INSTALL-STRATEGY-GAMES-MENU-I-1"          "0ad: Cross-platform, 3D and historically-based Real-Time Strategy Game"
    localize_info "INSTALL-STRATEGY-GAMES-MENU-2"    "Hedgewars"
    localize_info "INSTALL-STRATEGY-GAMES-MENU-I-2"          "Hedgewars: Free Worms-like turn based strategy game"
    localize_info "INSTALL-STRATEGY-GAMES-MENU-3"    "Megaglest"
    localize_info "INSTALL-STRATEGY-GAMES-MENU-I-3"          "Megaglest: Fork of Glest, a 3D Real-Time Strategy Game in a Fantastic World."
    localize_info "INSTALL-STRATEGY-GAMES-MENU-4"    "Unknown-horizons"
    localize_info "INSTALL-STRATEGY-GAMES-MENU-I-4"          "Unknown-horizons: A 2D Realtime Strategy Simulation with an emphasis on economy and City Building"
    localize_info "INSTALL-STRATEGY-GAMES-MENU-5"    "Warzone2100"
    localize_info "INSTALL-STRATEGY-GAMES-MENU-I-5"          "Warzone2100: 	3D Realtime Strategy Game on a future Earth"
    localize_info "INSTALL-STRATEGY-GAMES-MENU-6"    "Wesnoth"
    localize_info "INSTALL-STRATEGY-GAMES-MENU-I-6"          "Wesnoth: A turn-based Strategy Game on a fantasy world"
    localize_info "INSTALL-STRATEGY-GAMES-MENU-7"    "Zod"
    localize_info "INSTALL-STRATEGY-GAMES-MENU-I-7"          "Zod: The Zod Engine - An Open Source Remake of the 1996 Game Z by Bitmap Brothers"
fi
# -------------------------------------
install_strategy_games_menu()
{
    local -r menu_name="INSTALL-STRATEGY-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                       # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""                  # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="1-7"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-STRATEGY-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-STRATEGY-GAMES-MENU-1" "" ""     "INSTALL-STRATEGY-GAMES-MENU-I-1" "MenuTheme[@]" # 1 0ad
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-STRATEGY-GAMES-MENU-2" "" ""     "INSTALL-STRATEGY-GAMES-MENU-I-2" "MenuTheme[@]" # 2 Hedgewars
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-STRATEGY-GAMES-MENU-3" "" ""     "INSTALL-STRATEGY-GAMES-MENU-I-3" "MenuTheme[@]" # 3 Megaglest
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-STRATEGY-GAMES-MENU-4" "" "$AUR" "INSTALL-STRATEGY-GAMES-MENU-I-4" "MenuTheme[@]" # 4 Unknown-horizons
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-STRATEGY-GAMES-MENU-5" "" ""     "INSTALL-STRATEGY-GAMES-MENU-I-5" "MenuTheme[@]" # 5 Warzone2100
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-STRATEGY-GAMES-MENU-6" "" ""     "INSTALL-STRATEGY-GAMES-MENU-I-6" "MenuTheme[@]" # 6 Wesnoth
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-STRATEGY-GAMES-MENU-7" "" "$AUR" "INSTALL-STRATEGY-GAMES-MENU-I-7" "MenuTheme[@]" # 7 Zod
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 0ad
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_0AD\" 'INSTALL-0AD'" "INSTALL-0AD" ; then
                        add_package "$INSTALL_0AD"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-STRATEGY-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Hedgewars
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_HEDGEWARS\" 'INSTALL-HEDGEWARS'" "INSTALL-HEDGEWARS" ; then
                        add_package "$INSTALL_HEDGEWARS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-STRATEGY-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Megaglest
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_MEGAGLEST\" 'INSTALL-MEGAGLEST'" "INSTALL-MEGAGLEST" ; then
                        add_package "$INSTALL_MEGAGLEST"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-STRATEGY-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Unknown-horizons
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_UNKNOW_HORIZONS\" 'INSTALL-UNKNOW-HORIZONS'" "INSTALL-UNKNOW-HORIZONS" ; then
                        add_package "$INSTALL_UNKNOW_HORIZONS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-STRATEGY-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Warzone2100
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_WARZONE2100\" 'INSTALL-WARZONE2100'" "INSTALL-WARZONE2100" ; then
                        add_package "$INSTALL_WARZONE2100"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-STRATEGY-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Wesnoth
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_WESNOTH\"  'INSTALL-WESNOTH'" "INSTALL-WESNOTH" ; then
                        add_package "$INSTALL_WESNOTH"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-STRATEGY-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # Zod
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_COMMANDER_ZOD\" 'AUR-INSTALL-COMMANDER-ZOD'" "AUR-INSTALL-COMMANDER-ZOD" ; then
                        add_aur_package "$AUR_INSTALL_COMMANDER_ZOD"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-STRATEGY-GAMES-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# CREATE SITES FOLDER {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="create_sites_folder"
    USAGE="create_sites_folder"
    DESCRIPTION=$(localize "CREATE-SITES-FOLDER-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "CREATE-SITES-FOLDER-DESC"   "Create Web Sites Folder"
    localize_info "CREATE-SITES-FOLDER-INFO-1" "The folder (Sites) has been created in your home"
    localize_info "CREATE-SITES-FOLDER-INFO-2" "You can access your Web Projects at"
fi
# -------------------------------------
create_sites_folder()
{
    # copy_file "from" "to" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    # copy_dir "from" "to" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    [[ ! -f  /etc/httpd/conf/extra/httpd-userdir.conf.aui ]] && copy_file '/etc/httpd/conf/extra/httpd-userdir.conf' '/etc/httpd/conf/extra/httpd-userdir.conf.aui' "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    sed -i 's/public_html/Sites/g' /etc/httpd/conf/extra/httpd-userdir.conf
    su - "$USERNAME" -c "mkdir -p ~/Sites"
    su - "$USERNAME" -c "chmod o+x ~/ && chmod -R o+x ~/Sites"
    echo ''
    print_this "CREATE-SITES-FOLDER-INFO-1"
    print_this "CREATE-SITES-FOLDER-INFO-2" " \"http://localhost/~${USERNAME}\""
    if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL WEB SERVER {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_web_server_menu"
    USAGE="install_web_server_menu"
    DESCRIPTION=$(localize "Install Web Server")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-WEB-SERVER-DESC"  "Main Menu"
    localize_info "INSTALL-WEB-SERVER-TITLE" "Web Server"
    #
    localize_info "INSTALL-WEB-SERVER-MENU-1"   "LAPP - APACHE, POSTGRESQL & PHP + ADMINER"
    localize_info "INSTALL-WEB-SERVER-MENU-I-1"         "POSTGRESQL: A Sophisticated Object-Relational DBMS"
    localize_info "INSTALL-WEB-SERVER-MENU-2"   "LAMP - APACHE, MYSQL & PHP + ADMINER"
    localize_info "INSTALL-WEB-SERVER-MENU-I-2"         "MYSQL: A fast SQL Database Server"
fi
# -------------------------------------
install_web_server_menu()
{
    # 11
    #@FIX
    local -r menu_name="WEB-SERVER"  # You must define Menu Name here
    local BreakableKey="D"           # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""      # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"  # As a Programmer, I'm not interested in Apache, but Wt, so I left it out
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}" "${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        #
        print_title "INSTALL-WEB-SERVER-TITLE" " - https://wiki.archlinux.org/index.php/LAMP|LAPP"
        print_caution "${StatusBar1}" "${StatusBar2}"
        #
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-WEB-SERVER-MENU-1" "" "INSTALL-WEB-SERVER-MENU-I-1" "INSTALL-WEB-SERVER-MENU-I-1" "MenuTheme[@]" # 1 POSTGRESQL
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-WEB-SERVER-MENU-2" "" "INSTALL-WEB-SERVER-MENU-I-2" "INSTALL-WEB-SERVER-MENU-I-2" "MenuTheme[@]" # 2 MYSQL
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # POSTGRESQL
                    MenuChecks[$((S_OPT - 1))]=1
                    WEBSERVER="$S_OPT"
                    if add_packagemanager "package_install \"$INSTALL_WEB_SERVER_1\" 'INSTALL-WEB-SERVER-1'" "INSTALL-WEB-SERVER-1" ; then
                        add_package "$INSTALL_WEB_SERVER_1"
                    fi
                    #
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ADMINER\" 'AUR-INSTALL-ADMINER'" "AUR-INSTALL-ADMINER" ; then # if you add something, change this name
                        add_aur_package "$AUR_INSTALL_ADMINER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-WEB-SERVER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # MYSQL
                    MenuChecks[$((S_OPT - 1))]=1
                    WEBSERVER="$S_OPT"
                    if add_packagemanager "package_install \"$INSTALL_WEB_SERVER_2\" 'INSTALL-WEB-SERVER-2'" "INSTALL-WEB-SERVER-2" ; then
                        add_package "$INSTALL_WEB_SERVER_2" 
                        add_packagemanager "systemctl enable httpd.service mysqld.service" "SYSTEMD-ENABLE-WEBSERVER-1"
                        add_packagemanager "systemctl start mysqld.service" "SYSTEMD-START-MYSQL"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ADMINER\" 'AUR-INSTALL-ADMINER'" "AUR-INSTALL-ADMINER" ; then # if you add something, change this name
                        add_aur_package "$AUR_INSTALL_ADMINER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-WEB-SERVER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL FONTS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_fonts_menu"
    USAGE="install_fonts_menu"
    DESCRIPTION=$(localize "INSTALL-FONTS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-FONTS-DESC"     "Install Fonts"
    #
    localize_info "INSTALL-FONTS-MENU-1"    "ttf-dejavu"
    localize_info "INSTALL-FONTS-MENU-I-1"       "ttf-dejavu: Font family based on the Bitstream Vera Fonts with a wider range of characters"
    localize_info "INSTALL-FONTS-MENU-2"    "ttf-google-webfonts"
    localize_info "INSTALL-FONTS-MENU-I-2"       "ttf-google-webfonts: Google Web Fonts catalogue. Note: Removes: ttf-droid ttf-roboto ttf-ubuntu-font-family"
    localize_info "INSTALL-FONTS-MENU-3"    "ttf-funfonts"
    localize_info "INSTALL-FONTS-MENU-I-3"       "ttf-funfonts: 76 selected TTF fonts from 6760 font packages"
    localize_info "INSTALL-FONTS-MENU-4"    "ttf-kochi-substitute"
    localize_info "INSTALL-FONTS-MENU-I-4"       "ttf-kochi-substitute: High quality Japanese TrueType fonts"
    localize_info "INSTALL-FONTS-MENU-5"    "ttf-liberation"
    localize_info "INSTALL-FONTS-MENU-I-5"       "ttf-liberation: Red Hats Liberation fonts."
    localize_info "INSTALL-FONTS-MENU-6"    "ttf-ms-fonts"
    localize_info "INSTALL-FONTS-MENU-I-6"       "ttf-ms-fonts: Core TTF Fonts from Microsoft"
    localize_info "INSTALL-FONTS-MENU-7"    "ttf-vista-fonts"
    localize_info "INSTALL-FONTS-MENU-I-7"       "ttf-vista-fonts: Microsoft Vista True Type Fonts"
    localize_info "INSTALL-FONTS-MENU-8"    "wqy-microhei"
    localize_info "INSTALL-FONTS-MENU-I-8"       "wqy-microhei: A Sans-Serif style high quality CJK outline font. Chinese/Japanese/Korean Support"
fi
# -------------------------------------
install_fonts_menu()
{
    # 12
    local -r menu_name="INSTALL-FONTS"  # You must define Menu Name here
    local BreakableKey="D"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 5-7"    # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-FONTS-DESC" " - https://wiki.archlinux.org/index.php/Fonts"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-FONTS-MENU-1"  "" ""     "INSTALL-FONTS-MENU-I-1" "MenuTheme[@]" # 1 ttf-dejavu
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-FONTS-MENU-2"  "" "$AUR" "INSTALL-FONTS-MENU-I-2" "MenuTheme[@]" # 2 ttf-google-webfonts
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-FONTS-MENU-3"  "" "$AUR" "INSTALL-FONTS-MENU-I-3" "MenuTheme[@]" # 3 ttf-funfonts
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-FONTS-MENU-4"  "" "$AUR" "INSTALL-FONTS-MENU-I-4" "MenuTheme[@]" # 4 ttf-kochi-substitute
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-FONTS-MENU-5"  "" ""     "INSTALL-FONTS-MENU-I-5" "MenuTheme[@]" # 5 ttf-liberation
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-FONTS-MENU-6"  "" "$AUR" "INSTALL-FONTS-MENU-I-6" "MenuTheme[@]" # 6 ttf-ms-fonts
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-FONTS-MENU-7"  "" "$AUR" "INSTALL-FONTS-MENU-I-7" "MenuTheme[@]" # 7 ttf-vista-fonts 
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-FONTS-MENU-8"  "" ""     "INSTALL-FONTS-MENU-I-8" "MenuTheme[@]" # 8 wqy-microhei
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # ttf-dejavu
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_TTF_DEJAVU\" 'INSTALL-TTF-DEJAVU'" "INSTALL-TTF-DEJAVU" ; then
                        add_package "$INSTALL_TTF_DEJAVU"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-FONTS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # ttf-google-webfonts
                    MenuChecks[$((S_OPT - 1))]=1
                    add_packagemanager "package_remove 'ttf-droid ttf-roboto ttf-ubuntu-font-family'" "REMOVE-GOOGLE-WEBFONTS"
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GOOGLE_WEBFONTS\" 'AUR-INSTALL-GOOGLE-WEBFONTS'" "AUR-INSTALL-GOOGLE-WEBFONTS" ; then
                        add_aur_package "$AUR_INSTALL_GOOGLE_WEBFONTS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-FONTS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # ttf-funfonts
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_FUN_FONTS\" 'AUR-INSTALL-FUN-FONTS'" "AUR-INSTALL-FUN-FONTS" ; then
                        add_aur_package "$AUR_INSTALL_FUN_FONTS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-FONTS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # ttf-kochi-substitute
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_KOCHI_FONTS\" 'AUR-INSTALL-KOCHI-FONTS'" "AUR-INSTALL-KOCHI-FONTS" ; then
                        add_aur_package "$AUR_INSTALL_KOCHI_FONTS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-FONTS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # ttf-liberation
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_TTF_LIBERATION\" 'INSTALL-TTF-LIBERATION'" "INSTALL-TTF-LIBERATION" ; then
                        add_package "$INSTALL_TTF_LIBERATION"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-FONTS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # ttf-ms-fonts
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_MS_FONTS\" 'AUR-INSTALL-MS-FONTS'" "AUR-INSTALL-MS-FONTS" ; then
                        add_aur_package "$AUR_INSTALL_MS_FONTS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-FONTS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # ttf-vista-fonts
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_VISTA_FONTS\" 'AUR-INSTALL-VISTA-FONTS'" "AUR-INSTALL-VISTA-FONTS" ; then
                        add_aur_package "$AUR_INSTALL_VISTA_FONTS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-FONTS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # wqy-microhei
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_WQY_FONTS\" 'INSTALL-WQY-FONTS'" "INSTALL-WQY-FONTS" ; then
                        add_package "$INSTALL_WQY_FONTS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-FONTS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# CLEAN ORPHAN PACKAGES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="clean_orphan_packages"
    USAGE="clean_orphan_packages"
    DESCRIPTION=$(localize "Clean Orphan Packages")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# -------------------------------------
clean_orphan_packages()
{
    # 14
    print_title "CLEAN ORPHAN PACKAGES"
    CONFIG_ORPHAN=1
}
#}}}
# -----------------------------------------------------------------------------
# GET NETWORK MANAGER {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="get_network_manager_menu"
    USAGE=$(localize "GET-NETWORK-MANAGER-USAGE")
    DESCRIPTION=$(localize "GET-NETWORK-MANAGER-DESC")
    NOTES=$(localize "GET-NETWORK-MANAGER-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "GET-NETWORK-MANAGER-USAGE" "get_network_manager_menu"
    localize_info "GET-NETWORK-MANAGER-DESC"  "Get Network Manager"
    localize_info "GET-NETWORK-MANAGER-NOTES" "None."
    #
    localize_info "GET-NETWORK-MANAGER-TITLE"    "Network Managers"
    localize_info "GET-NETWORK-MANAGER-MENU-1"   "Network Manager"
    localize_info "GET-NETWORK-MANAGER-MENU-1-I"    "NetworkManager is a program for providing detection and configuration for systems to automatically connect to network. NetworkManager's functionality can be useful for both wireless and wired networks."
    localize_info "GET-NETWORK-MANAGER-MENU-2"   "WICD"
    localize_info "GET-NETWORK-MANAGER-MENU-2-I"    "Wicd is a network connection manager that can manage wireless and wired interfaces, similar and an alternative to NetworkManager."
    localize_info "GET-NETWORK-MANAGER-MENU-3"   "None"
    localize_info "GET-NETWORK-MANAGER-MENU-3-I"    "Do not install any Network Manager."
fi
# -------------------------------------
get_network_manager_menu()
{
    # 
    local -r menu_name="GET-NETWORK-MANAGER"  # You must define Menu Name here
    local BreakableKey="D"                    # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"              # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "GET-NETWORK-MANAGER-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GET-NETWORK-MANAGER-MENU-1" "" "" "GET-NETWORK-MANAGER-MENU-1-I" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GET-NETWORK-MANAGER-MENU-2" "" "" "GET-NETWORK-MANAGER-MENU-2-I" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GET-NETWORK-MANAGER-MENU-3" "" "" "GET-NETWORK-MANAGER-MENU-3-I" "MenuTheme[@]" # 3
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # networkmanager
                    NETWORK_MANAGER="networkmanager"
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-NETWORK-MANAGER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                2)  # wicd
                    NETWORK_MANAGER="wicd"
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-NETWORK-MANAGER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                3)  # None
                    NETWORK_MANAGER="" # @FIX Insure Null value in save
                    S_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-NETWORK-MANAGER-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL NETWORK MANAGER {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_network_manager_now"
    USAGE=$(localize "INSTALL-NETWORK-MANAGER-USAGE")
    DESCRIPTION=$(localize "INSTALL-NETWORK-MANAGER-DESC")
    NOTES=$(localize "INSTALL-NETWORK-MANAGER-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-NETWORK-MANAGER-USAGE" "install_network_manager_now"
    localize_info "INSTALL-NETWORK-MANAGER-DESC"  "Install Network Manager"
    localize_info "INSTALL-NETWORK-MANAGER-NOTES" "None."
    localize_info "INSTALL-NETWORK-MANAGER-WARN"  "No Network Manager Installed."
fi
# -------------------------------------
install_network_manager_now()
{
    # 1
    # @FIX use 
    if [[ "$NETWORK_MANAGER" == "networkmanager" ]]; then
        if [[ "QT_INSTALL" -eq 1 ]]; then
            if add_packagemanager "package_install \"$INSTALL_NETWORKMANAGER_KDE\" 'INSTALL-NETWORKMANAGER-KDE'" "INSTALL-NETWORKMANAGER-KDE" ; then
                add_package "$INSTALL_NETWORKMANAGER_KDE"
            fi
            if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                if add_packagemanager "package_install \"$INSTALL_NETWORKMANAGER_APPLET\" 'INSTALL-NETWORKMANAGER-APPLET'" "INSTALL-NETWORKMANAGER-APPLET" ; then
                    add_package "$INSTALL_NETWORKMANAGER_APPLET"
                fi
            fi
        else
            if add_packagemanager "package_install \"$INSTALL_NETWORKMANAGER\" 'INSTALL-NETWORKMANAGER'" "INSTALL-NETWORKMANAGER" ; then
                add_package "$INSTALL_NETWORKMANAGER"
            fi
        fi
        if add_packagemanager "package_install \"$INSTALL_NETWORKMANAGER_NTP\" 'INSTALL-NETWORKMANAGER-NTP'" "INSTALL-NETWORKMANAGER-NTP" ; then
            add_package "$INSTALL_NETWORKMANAGER_NTP"
            add_user_group "networkmanager"
        fi
        # Network Management daemon
        # Application development toolkit for controlling system-wide privileges
        add_packagemanager "systemctl enable NetworkManager.service" "SYSTEMD-ENABLE-NETWORKMANAGER"
        add_packagemanager "add_user_2_group 'networkmanager'" "GROUPADD-NETWORKMANAGER"
    elif [[ "$NETWORK_MANAGER" == "wicd" ]]; then
        if [[ "QT_INSTALL" -eq 1 ]]; then
            if add_packagemanager "aur_package_install \"$AUR_INSTALL_WICD_KDE\" 'AUR-INSTALL-WICD-KDE'" "AUR-INSTALL-WICD-KDE" ; then
                add_aur_package "$AUR_INSTALL_WICD_KDE"
            fi
            if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                if add_packagemanager "package_install \"$INSTALL_WICD_GTK\" 'INSTALL-WICD-GTK'" "INSTALL-WICD-GTK" ; then
                    add_package "$INSTALL_WICD_GTK"
                fi
            fi
        else
            if add_packagemanager "package_install \"$INSTALL_WICD_GTK\" 'INSTALL-WICD-GTK'" "INSTALL-WICD-GTK" ; then
                add_package "$INSTALL_WICD_GTK"
            fi
        fi
        # Network Management daemon
        add_packagemanager "systemctl enable wicd.service" "SYSTEMD-ENABLE-WICD"
    else
        print_warning "INSTALL-NETWORK-MANAGER-WARN"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL ACCESSORIES APPS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_accessories_apps_menu"
    USAGE="install_accessories_apps_menu"
    DESCRIPTION=$(localize "INSTALL-ACCESSORIES-APPS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-ACCESSORIES-APPS-DESC"    "Install Accessory Applications"
    localize_info "INSTALL-ACCESSORIES-APPS-TITLE"   "Accessory Applications"
    #
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-1"    "Cairo Dock"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-1"       "Cairo-dock is a highly customizable dock written in C. "
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-2"    "Conky + CONKY-colors"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-2"       "Conky + CONKY-colors: Lightweight system monitor for X. An easier way to configure Conky."
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-3"    "Deepin Screenshot"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-3"       "Deepin Screenshot: a screen snapshot tool from deepin linux"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-4"    "Dockbarx"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-4"       "Dockbarx: TaskBar with groupping and group manipulation (with optional MATE support)"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-5"    "Docky"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-5"       "Docky: Full fledged dock application that makes opening common applications and managing windows easier and quicker"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-6"    "Speedcrunch or galculator"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-6"       "Speedcrunch or galculator: Depending on DE -> Simple but powerful calculator using Qt or GTK+ based scientific calculator"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-7"    "Gnome Pie"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-7"       "Gnome Pie: A visual application launcher for gnome."
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-8"    "Guake"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-8"       "Guake: Nice Terminal Popup F12"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-9"    "Kupfer"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-9"       "Kupfer: Launcher application written in python. Similar to Gnome-Do / Launchy"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-10"   "Pyrenamer"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-10"      "Pyrenamer: Mass file renamer"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-11"   "Shutter"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-11"      "Shutter: A featureful screenshot tool (formerly gscrot)"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-12"   "Synapse"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-12"      "Synapse: A semantic file launcher and Zeitgeist client library"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-13"   "Terminator"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-13"      "Terminator: an application that provides lots of terminals in a single window and Library for registering global keyboard shortcuts - Python 2 bindings"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-14"   "Zim"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-14"      "Zim: A WYSIWYG text editor that aims at bringing the concept of a wiki to the desktop."
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-15"   "Revelation"
    localize_info "INSTALL-ACCESSORIES-APPS-MENU-I-15"      "Revelation: Password Safe."
fi
# -------------------------------------
install_accessories_apps_menu()
{
    # 4
    local -r menu_name="ACCESSORIES-APPS"  # You must define Menu Name here
    local BreakableKey="D"                 # Q=Quit, D=Done, B=Back
    local RecommendedOptions="15"          # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions 6 7"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 6 7"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 6 7 12"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-ACCESSORIES-APPS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-1"  "" "$AUR"       "INSTALL-ACCESSORIES-APPS-MENU-I-1"  "MenuTheme[@]" # 1  Cairo
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-2"  "" "$AUR"       "INSTALL-ACCESSORIES-APPS-MENU-I-2"  "MenuTheme[@]" # 2  Conky + CONKY-colors
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-3"  "" "$AUR"       "INSTALL-ACCESSORIES-APPS-MENU-I-3"  "MenuTheme[@]" # 3  Deepin Screenshot
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-4"  "" "$AUR"       "INSTALL-ACCESSORIES-APPS-MENU-I-4"  "MenuTheme[@]" # 4  Dockbarx
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-5"  "" ""           "INSTALL-ACCESSORIES-APPS-MENU-I-5"  "MenuTheme[@]" # 5  Docky
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-6"  "" "$MAYBE_AUR" "INSTALL-ACCESSORIES-APPS-MENU-I-6"  "MenuTheme[@]" # 6  Speedcrunch or galculator
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-7"  "" "$AUR"       "INSTALL-ACCESSORIES-APPS-MENU-I-7"  "MenuTheme[@]" # 7  Gnome Pie
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-8"  "" ""           "INSTALL-ACCESSORIES-APPS-MENU-I-8"  "MenuTheme[@]" # 8  Guake
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-9"  "" "$AUR"       "INSTALL-ACCESSORIES-APPS-MENU-I-9"  "MenuTheme[@]" # 9  Kupfer
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-10" "" "$AUR"       "INSTALL-ACCESSORIES-APPS-MENU-I-10" "MenuTheme[@]" # 10 Pyrenamer
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-11" "" "$AUR"       "INSTALL-ACCESSORIES-APPS-MENU-I-11" "MenuTheme[@]" # 11 Shutter
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-12" "" "$AUR"       "INSTALL-ACCESSORIES-APPS-MENU-I-12" "MenuTheme[@]" # 12 Synapse
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-13" "" ""           "INSTALL-ACCESSORIES-APPS-MENU-I-13" "MenuTheme[@]" # 13 Terminator
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-14" "" ""           "INSTALL-ACCESSORIES-APPS-MENU-I-14" "MenuTheme[@]" # 14 Zim
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ACCESSORIES-APPS-MENU-15" "" "$AUR"       "INSTALL-ACCESSORIES-APPS-MENU-I-15" "MenuTheme[@]" # 15 Revelation
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Cairo
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_CAIRO\" 'AUR-INSTALL-CAIRO'" "AUR-INSTALL-CAIRO" ; then
                        add_aur_package "$AUR_INSTALL_CAIRO"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Conky + CONKY-colors
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_CONKY\" 'AUR-INSTALL-CONKY'" "AUR-INSTALL-CONKY" ; then
                        add_aur_package "$AUR_INSTALL_CONKY" 
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Deepin Screenshot
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_DEEPIN_SCROT\" 'AUR-INSTALL-DEEPIN-SCROT'" "AUR-INSTALL-DEEPIN-SCROT" ; then
                        add_aur_package "$AUR_INSTALL_DEEPIN_SCROT"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Dockbarx
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_DOCKBARX\" 'AUR-INSTALL-DOCKBARX'" "AUR-INSTALL-DOCKBARX" ; then
                        add_aur_package "$AUR_INSTALL_DOCKBARX"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Docky
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_DOCKY\" 'INSTALL-DOCKY'" "INSTALL-DOCKY" ; then
                        add_package "$INSTALL_DOCKY"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Speedcrunch or galculator
                    MenuChecks[$((S_OPT - 1))]=1
                    if [[ "QT_INSTALL" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                            if add_packagemanager "aur_package_install \"$AUR_INSTALL_GALGULATOR\" 'AUR-INSTALL-GALCULATOR'" "AUR-INSTALL-GALCULATOR" ; then
                                add_aur_package "$AUR_INSTALL_GALGULATOR"
                            fi
                        fi
                        if add_packagemanager "aur_package_install \"$AUR_INSTALL_SPEEDCRUNCH\" 'AUR-INSTALL-SPEEDCRUNCH'" "AUR-INSTALL-SPEEDCRUNCH" ; then
                            add_aur_package "$AUR_INSTALL_SPEEDCRUNCH"
                        fi
                    else
                        if add_packagemanager "aur_package_install \"$AUR_INSTALL_GALGULATOR\" 'AUR-INSTALL-GALGULATOR'" "AUR-INSTALL-GALGULATOR" ; then
                            add_aur_package "$AUR_INSTALL_GALGULATOR"
                        fi
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # Gnome Pie
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_PIE\" 'AUR-INSTALL-GNOME-PIE'" "AUR-INSTALL-GNOME-PIE" ; then
                        add_aur_package "$AUR_INSTALL_GNOME_PIE" 
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # Guake
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GUAKE\" 'INSTALL-GUAKE'" "INSTALL-GUAKE" ; then
                        add_package "$INSTALL_GUAKE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # Kupfer
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_KUPFER\" 'AUR-INSTALL-KUPFER'" "AUR-INSTALL-KUPFER" ; then
                        add_aur_package "$AUR_INSTALL_KUPFER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               10)  # Pyrenamer
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_PYRENAMER\" 'AUR-INSTALL-PYRENAMER'" "AUR-INSTALL-PYRENAMER" ; then
                        add_aur_package "$AUR_INSTALL_PYRENAMER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               11)  # Shutter
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_SHUTTER\" 'AUR-INSTALL-SHUTTER'" "AUR-INSTALL-SHUTTER" ; then
                        add_aur_package "$AUR_INSTALL_SHUTTER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               12)  # Synapse
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_ZEITGEIST\" 'INSTALL-ZEITGEIST'" "INSTALL-ZEITGEIST" ; then
                        add_package "$INSTALL_ZEITGEIST"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ZEITGEIST\" 'AUR-INSTALL-ZEITGEIST'" "AUR-INSTALL-ZEITGEIST" ; then
                        add_aur_package "$AUR_INSTALL_ZEITGEIST"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               13)  # Terminator
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_TERMINATOR\" 'INSTALL-TERMINATOR'" "INSTALL-TERMINATOR" ; then
                        add_package "$INSTALL_TERMINATOR"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               14)  # Zim
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_ZIM\" 'INSTALL-ZIM'" "INSTALL-ZIM" ; then
                        add_package "$INSTALL_ZIM"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               15)  # Revelation
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_REVELATION\" 'AUR-INSTALL-REVELATION'" "AUR-INSTALL-REVELATION" ; then
                        add_aur_package "$AUR_INSTALL_REVELATION"
                        add_packagemanager "make_dir '/etc/gconf/schemas/' \"$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO\"; cd /etc/gconf/schemas/; ln -s /usr/share/gconf/schemas/revelation.schemas; cd \$(pwd)" "AUR-INSTALL-REVELATION-SETUP"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ACCESSORIES-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL DEVELOPMENT APPS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_development_apps_menu"
    USAGE="install_development_apps_menu"
    DESCRIPTION=$(localize "INSTALL-DEVELOPMENT-APPS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-DEVELOPMENT-APPS-DESC"    "Install Development Apps"
    #
    MENU_NUMBER=1
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Qt and Creator"      # 1
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                   "Qt and Creator: A cross-platform application and UI framework"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Wt"                  # 2
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                   "Wt Pronounced [Witty]: C++ Web Applications Frame work based on Widgets."
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "PostgreSQL"          # 3
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                   "PostgreSQL: A sophisticated Object-Relational DBMS"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "MySQL and Workbench" # 4
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                   "MySQL and Workbench: In AUR - DBMS - Commercial License."
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Aptana-Studio"       # 5
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                   "Aptana-Studio: The professional, open source development tool for the open web."
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Bluefish"            # 6
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                   "Bluefish: A powerful HTML editor for experienced web designers and programmers"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Eclipse"             # 7
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                   "Eclipse: An IDE for Java and other languages - Sub menu for Customizing."
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Emacs"               # 8
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                   "emacs: The extensible, customizable, self-documenting real-time display editor"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "gVim"                # 9
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                   "gvim: Vi Improved, a highly configurable, improved version of the vi text editor (with advanced features, such as a GUI)"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Geany"               # 10
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                   "geany: Fast and lightweight IDE"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "IntelliJ IDEA"       # 11
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                  "IntelliJ IDEA: IDE for Java, Groovy and other programming languages with advanced refactoring features"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "kDevelop"            # 12
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                  "kdevelop: A C/C++ development environment for KDE"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Netbeans"           # 13
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                  "Netbeans: IDE for Java, PHP, Groovy, C, C++ and Python"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Oracle Java"        # 14
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                  "Oracle Java: Java 7 Development Kit - https://wiki.archlinux.org/index.php/Java & http://www.oracle.com/technetwork/java/javase/downloads/index.html"    
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Sublime Text 2"     # 15
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                  "Sublime Text 2: sophisticated text editor for code, html and prose"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Debugger Tools"     # 16
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                  "Debugger Tools: $AUR_INSTALL_DEBUGGER_TOOLS"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Meld"               # 17
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                  "meld: Visual diff and merge tool"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "RabbitVCS"          # 18
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                  "RabbitVCS: A project with the goal of developing a collection of utilities to allow for better client integration with some of the popular version control systems (core)"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "aStyle"             # 19
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                  "astyle: A free, fast and small automatic formatter for C, C++, C#, and Java source code."
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Putty"              # 20
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                  "putty: A terminal integrated SSH/Telnet client"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$MENU_NUMBER"         "Utilities"          # 21
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-$((MENU_NUMBER++))-I"                  "Utilities: $INSTALL_UTILITES"
fi
# -------------------------------------
install_development_apps_menu()
{
    # 3
    local -r menu_name="DEVELOPMENT-APPS"  # You must define Menu Name here
    local BreakableKey="D"                 # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"           # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions 2"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 2 5"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 2 3 6 7 13 16 19-21"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-DEVELOPMENT-APPS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-1"  "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-1-I"  "MenuTheme[@]" # 1  Qt and Creator
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-2"  "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-2-I"  "MenuTheme[@]" # 2  Wt
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-3"  "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-3-I"  "MenuTheme[@]" # 3  postgresql
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-4"  "" "$AUR"      "INSTALL-DEVELOPMENT-APPS-MENU-4-I"  "MenuTheme[@]" # 4  MySQL and Workbench
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-5"  "" "$AUR"      "INSTALL-DEVELOPMENT-APPS-MENU-5-I"  "MenuTheme[@]" # 5  Aptana-Studio
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-6"  "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-6-I"  "MenuTheme[@]" # 6  Bluefish
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-7"  "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-7-I"  "MenuTheme[@]" # 7  Eclipse
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-8"  "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-8-I"  "MenuTheme[@]" # 8  emacs
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-9"  "" "$SOME_AUR" "INSTALL-DEVELOPMENT-APPS-MENU-9-I"  "MenuTheme[@]" # 9  gvim
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-10" "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-10-I" "MenuTheme[@]" # 10 geany
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-11" "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-11-I" "MenuTheme[@]" # 11 IntelliJ IDEA
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-12" "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-12-I" "MenuTheme[@]" # 12 kdevelop
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-13" "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-13-I" "MenuTheme[@]" # 13 Netbeans
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-14" "" "$AUR"      "INSTALL-DEVELOPMENT-APPS-MENU-14-I" "MenuTheme[@]" # 14 Oracle Java
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-15" "" "$AUR"      "INSTALL-DEVELOPMENT-APPS-MENU-15-I" "MenuTheme[@]" # 15 Sublime Text 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-16" "" "$AUR"      "INSTALL-DEVELOPMENT-APPS-MENU-16-I" "MenuTheme[@]" # 16 Debugger Tools
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-17" "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-17-I" "MenuTheme[@]" # 17 Meld
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-18" "" "$AUR"      "INSTALL-DEVELOPMENT-APPS-MENU-18-I" "MenuTheme[@]" # 18 RabbitVCS
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-19" "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-19-I" "MenuTheme[@]" # 19 astyle
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-20" "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-20-I" "MenuTheme[@]" # 20 putty
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-21" "" ""          "INSTALL-DEVELOPMENT-APPS-MENU-21-I" "MenuTheme[@]" # 21 Utilities
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #postgresql
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Qt and Creator
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_QT\" 'INSTALL-QT'" "INSTALL-QT" ; then
                        add_package "$INSTALL_QT"
                        add_packagemanager "mkdir -p /home/\$USERNAME/.config/Nokia/qtcreator/styles" "RUN-QT-1"
                        add_packagemanager "curl -o monokai.xml http://angrycoding.googlecode.com/svn/branches/qt-creator-monokai-theme/monokai.xml" "RUN-QT-2"
                        add_packagemanager "mv monokai.xml /home/\$USERNAME/.config/Nokia/qtcreator/styles/" "RUN-QT-3"
                        add_packagemanager "chown -R \$USERNAME:\$USERNAME /home/\$USERNAME/.config" "RUN-QT-4"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Wt
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_WT\" 'INSTALL-WT'" "INSTALL-WT" ; then
                        add_package "$INSTALL_WT"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # postgresql 
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_POSTGRESQL\" 'INSTALL-POSTGRESQL'" "INSTALL-POSTGRESQL" ; then
                        add_package "$INSTALL_POSTGRESQL"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;                    
                4)  # MySQL and Workbenchhttps://wiki.archlinux.org/index.php/Java
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_MYSQL_WORKBENCH\" 'AUR-INSTALL-MYSQL-WORKBENCH'" "AUR-INSTALL-MYSQL-WORKBENCH" ; then
                        add_aur_package "$AUR_INSTALL_MYSQL_WORKBENCH"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Aptana-Studio
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_APTANA_STUDIO\" 'AUR-INSTALL-APTANA-STUDIO'" "AUR-INSTALL-APTANA-STUDIO" ; then
                        add_aur_package "$AUR_INSTALL_APTANA_STUDIO"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Bluefish
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_BLUEFISH\" 'INSTALL-BLUEFISH'" "INSTALL-BLUEFISH" ; then
                        add_package "$INSTALL_BLUEFISH"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # Eclipse
                    MenuChecks[$((S_OPT - 1))]=1
                    install_eclipse_dev_menu
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # emacs
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_EMACS\" 'INSTALL-EMACS'" "INSTALL-EMACS" ; then
                        add_package "$INSTALL_EMACS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # gvim
                    MenuChecks[$((S_OPT - 1))]=1	
                    if add_packagemanager "package_install \"$INSTALL_VIM\" 'INSTALL-VIM'" "INSTALL-VIM" ; then
                        add_packagemanager "package_remove 'vim'" "REMOVE-GVIM"
                        add_package "$INSTALL_VIM"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_DISCOUNT\" 'AUR-INSTALL-DISCOUNT'" "AUR-INSTALL-DISCOUNT" ; then
                        add_aur_package "$AUR_INSTALL_DISCOUNT"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               10)  # geany
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GEANY\" 'INSTALL-GEANY'" "INSTALL-GEANY" ; then
                        add_package "$INSTALL_GEANY"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               11)  # IntelliJ IDEA
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_INTELLIJ\" 'INSTALL-INTELLIJ'" "INSTALL-INTELLIJ" ; then
                        add_package "$INSTALL_INTELLIJ"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               12)  # kdevelop
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_KDEVELOP\" 'INSTALL-KDEVELOP'" "INSTALL-KDEVELOP" ; then
                        add_package "$INSTALL_KDEVELOP"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               13)  # Netbeans
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_NETBEANS\" 'INSTALL-NETBEANS'" "INSTALL-NETBEANS" ; then
                        add_package "$INSTALL_NETBEANS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               14)  # Oracle Java
                    MenuChecks[$((S_OPT - 1))]=1
                    add_packagemanager "package_remove 'jre7-openjdk jdk7-openjdk'" "REMOVE-JDK"
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_JDK\" 'AUR-INSTALL-JDK'" "AUR-INSTALL-JDK" ; then
                        add_aur_package "$AUR_INSTALL_JDK"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               15)  # Sublime Text 2
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_SUBLIME\" 'AUR-INSTALL-SUBLIME'" "AUR-INSTALL-SUBLIME" ; then
                        add_aur_package "$AUR_INSTALL_SUBLIME"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               16)  # Debugger Tools
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_DEBUGGER_TOOLS\" 'AUR-INSTALL-DEBUGGER-TOOLS'" "AUR-INSTALL-DEBUGGER-TOOLS" ; then
                        add_aur_package "$AUR_INSTALL_DEBUGGER_TOOLS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               17)  # meld
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_MELD\" 'INSTALL-MELD'" "INSTALL-MELD" ; then
                        add_package "$INSTALL_MELD"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               18)  # RabbitVCS
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_RABBITVCS\" 'AUR-INSTALL-RABBITVCS'" "AUR-INSTALL-RABBITVCS" ; then
                        add_aur_package "$AUR_INSTALL_RABBITVCS"
                    fi
                    # @FIX check what is to be installed
                    add_packagemanager "if [[ check_package 'nautilus' ]]; then if aur_package_install \"$AUR_INSTALL_RABBITVCS_NAUTILUS\" 'AUR-INSTALL-RABBITVCS-NAUTILUS'; then add_aur_package "$AUR_INSTALL_RABBITVCS_NAUTILUS"; fi fi " "AUR-INSTALL-RABBITVCS-NAUTILUS"
                    add_packagemanager "if [[ check_package 'thunar' ]]; then if aur_package_install \"$AUR_INSTALL_RABBITVCS_THUNAR\" 'AUR-INSTALL-RABBITVCS-THUNAR'; then add_aur_package "$AUR_INSTALL_RABBITVCS_THUNAR"; fi fi" "AUR-INSTALL-RABBITVCS-THUNAR"
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_RABBITVCS_CLI\" 'AUR-INSTALL-RABBITVCS-CLI'" "AUR-INSTALL-RABBITVCS-CLI" ; then
                        add_aur_package "$AUR_INSTALL_RABBITVCS_CLI"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               19)  # astyle
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_ASTYLE\"  'INSTALL-ASTYLE'" "INSTALL-ASTYLE" ; then
                        add_package "$INSTALL_ASTYLE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               20)  # putty
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_PUTTY\" 'INSTALL-PUTTY'" "INSTALL-PUTTY" ; then
                        add_package "$INSTALL_PUTTY"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               21)  # Utilities
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_UTILITES\" 'INSTALL-UTITILTIES'" "INSTALL-UTITILTIES" ; then
                        add_package "$INSTALL_UTILITES"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DEVELOPMENT-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ $(to_lower_case "$S_OPT") == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else 
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL ECLIPSE DEV {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_eclipse_dev_menu"
    USAGE="install_eclipse_dev_menu"
    DESCRIPTION=$(localize "INSTALL-ECLIPSE-DEV-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-ECLIPSE-DEV-DESC"   "Install Eclipse Dev"
    localize_info "INSTALL-ECLIPSE-DEV-INFO-1" "Eclipse is an open source community project, which aims to provide a universal development platform."
    #
    localize_info "INSTALL-ECLIPSE-DEV-MENU-1" "Eclipse IDE"
    localize_info "INSTALL-ECLIPSE-DEV-MENU-2" "Eclipse IDE for C/C++ Developers"
    localize_info "INSTALL-ECLIPSE-DEV-MENU-3" "Android Development Tools for Eclipse"
    localize_info "INSTALL-ECLIPSE-DEV-MENU-4" "Web Development Tools for Eclipse"
    localize_info "INSTALL-ECLIPSE-DEV-MENU-5" "PHP Development Tools for Eclipse"
    localize_info "INSTALL-ECLIPSE-DEV-MENU-6" "Python Development Tools for Eclipse"
    localize_info "INSTALL-ECLIPSE-DEV-MENU-7" "Aptana Studio Plugin for Eclipse"
    localize_info "INSTALL-ECLIPSE-DEV-MENU-8" "Vim-like Editing Plugin for Eclipse"
    localize_info "INSTALL-ECLIPSE-DEV-MENU-9" "Git support Plugin for Eclipse"
fi
# -------------------------------------
install_eclipse_dev_menu()
{
    local -r menu_name="INSTALL-ECLIPSE-DEV"  # You must define Menu Name here
    local BreakableKey="B"                    # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 2"            # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions 6"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 3 6"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 3 4 5 6"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-ECLIPSE-DEV-DESC" " - https://wiki.archlinux.org/index.php/Eclipse"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info  "INSTALL-ECLIPSE-DEV-INFO-1"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-1" "" ""     "" "MenuTheme[@]" # 1 Eclipse IDE
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-2" "" ""     "" "MenuTheme[@]" # 2 Eclipse IDE for C/C++ Developers
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-3" "" "$AUR" "" "MenuTheme[@]" # 3 Android Development Tools for Eclipse
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-4" "" "$AUR" "" "MenuTheme[@]" # 4 Web Development Tools for Eclipse
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-5" "" "$AUR" "" "MenuTheme[@]" # 5 PHP Development Tools for Eclipse
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-6" "" "$AUR" "" "MenuTheme[@]" # 6 Python Development Tools for Eclipse
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-7" "" "$AUR" "" "MenuTheme[@]" # 7 Aptana Studio Plugin for Eclipse
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-8" "" "$AUR" "" "MenuTheme[@]" # 8 Vim-like Editing Plugin for Eclipse
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-9" "" "$AUR" "" "MenuTheme[@]" # 9 Git support Plugin for Eclipse
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Eclipse IDE
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_ECLIPSE\" 'INSTALL-ECLIPSE'" "INSTALL-ECLIPSE" ; then
                        add_package "$INSTALL_ECLIPSE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ECLIPSE-DEV-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Eclipse IDE for C/C++ Developers
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_ECLIPSE_CDT\" 'INSTALL-ECLIPSE-CDT'" "INSTALL-ECLIPSE-CDT" ; then
                        add_package "$INSTALL_ECLIPSE_CDT"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ECLIPSE-DEV-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Android Development Tools for Eclipse
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_ANDROID\" 'AUR-INSTALL-ECLIPSE-ANDROID'" "AUR-INSTALL-ECLIPSE-ANDROID" ; then
                        add_aur_package "$AUR_INSTALL_ECLIPSE_ANDROID"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ECLIPSE-DEV-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Web Development Tools for Eclipse
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_WTP\" 'AUR-INSTALL-ECLIPSE-WTP'" "AUR-INSTALL-ECLIPSE-WTP" ; then
                        add_aur_package "$AUR_INSTALL_ECLIPSE_WTP"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ECLIPSE-DEV-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # PHP Development Tools for Eclipse
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_PDT\" 'AUR-INSTALL-ECLIPSE-PDT'" "AUR-INSTALL-ECLIPSE-PDT" ; then
                        add_aur_package "$AUR_INSTALL_ECLIPSE_PDT"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ECLIPSE-DEV-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Python Development Tools for Eclipse
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_PYDEV\" 'AUR-INSTALL-ECLIPSE-PYDEV'" "AUR-INSTALL-ECLIPSE-PYDEV" ; then
                        add_aur_package "$AUR_INSTALL_ECLIPSE_PYDEV"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ECLIPSE-DEV-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # Aptana Studio Plugin for Eclipse
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_APTANA\" 'AUR-INSTALL-ECLIPSE-APTANA'" "AUR-INSTALL-ECLIPSE-APTANA" ; then
                        add_aur_package "$AUR_INSTALL_ECLIPSE_APTANA"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ECLIPSE-DEV-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_VRAPPER\" 'AUR-INSTALL-ECLIPSE-VRAPPER'" "AUR-INSTALL-ECLIPSE-VRAPPER" ; then
                        add_aur_package "$AUR_INSTALL_ECLIPSE_VRAPPER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ECLIPSE-DEV-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_EGIT\" 'AUR-INSTALL-ECLIPSE-EGIT'" "AUR-INSTALL-ECLIPSE-EGIT" ; then
                        add_aur_package "$AUR_INSTALL_ECLIPSE_EGIT"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-ECLIPSE-DEV-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL INTERNET APPS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_internet_apps_menu"
    USAGE="install_internet_apps_menu"
    DESCRIPTION=$(localize "INSTALL-INTERNET-APPS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-INTERNET-APPS-DESC"  "Install Internet Applications"
    localize_info "INSTALL-INTERNET-APPS-TITLE" "Internet Applications"
    # Browsers, Download / Fileshare, Email / RSS, Instant Messaging, Internet Relay Chat, Mapping Tools, VNC / Desktop Share
    localize_info "INSTALL-INTERNET-MENU-1"     "Browsers"
    localize_info "INSTALL-INTERNET-MENU-I-1"       "Browsers: Sub Menu: Firefox, Chrome, Opera"
    localize_info "INSTALL-INTERNET-MENU-2"     "Download / Fileshare"
    localize_info "INSTALL-INTERNET-MENU-I-2"       "Download / Fileshare: Transmission"
    localize_info "INSTALL-INTERNET-MENU-3"     "Email / RSS"
    localize_info "INSTALL-INTERNET-MENU-I-3"       "Email / RSS: Evolution, Firebird"
    localize_info "INSTALL-INTERNET-MENU-4"     "Instant Messaging"
    localize_info "INSTALL-INTERNET-MENU-I-4"       "Instant Messaging (IM): Pidgin, Skype"
    localize_info "INSTALL-INTERNET-MENU-5"     "Internet Relay Chat"
    localize_info "INSTALL-INTERNET-MENU-I-5"       "Internet Relay Chat (IRC): "
    localize_info "INSTALL-INTERNET-MENU-6"     "Mapping Tools"
    localize_info "INSTALL-INTERNET-MENU-I-6"       "Mapping Tools: Google Map, NASA"
    localize_info "INSTALL-INTERNET-MENU-7"     "VNC / Desktop Share"
    localize_info "INSTALL-INTERNET-MENU-I-7"       "VNC / Desktop Share: "
fi
# -------------------------------------
install_internet_apps_menu()
{
    # 7
    local -r menu_name="INTERNET-APPS"  # You must define Menu Name here
    local BreakableKey="D"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-4 6"    # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions 5"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 5 7"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 5 7"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-INTERNET-APPS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-1" "" "" "INSTALL-INTERNET-MENU-I-1" "MenuTheme[@]" # 1 Browser
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-2" "" "" "INSTALL-INTERNET-MENU-I-2" "MenuTheme[@]" # 2 Download / Fileshare
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-3" "" "" "INSTALL-INTERNET-MENU-I-3" "MenuTheme[@]" # 3 Email / RSS
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-4" "" "" "INSTALL-INTERNET-MENU-I-4" "MenuTheme[@]" # 4 Instant Messaging
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-5" "" "" "INSTALL-INTERNET-MENU-I-5" "MenuTheme[@]" # 5 Internet Relay Chat
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-6" "" "" "INSTALL-INTERNET-MENU-I-6" "MenuTheme[@]" # 6 Mapping Tools
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-7" "" "" "INSTALL-INTERNET-MENU-I-7" "MenuTheme[@]" # 7 VNC / Desktop Share
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Browser
                    MenuChecks[$((S_OPT - 1))]=1
                    install_browsers_menu
                    # Progress Status
                    StatusBar1="INSTALL-INTERNET-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Download / Fileshare
                    MenuChecks[$((S_OPT - 1))]=1
                    install_download_fileshare_menu
                    # Progress Status
                    StatusBar1="INSTALL-INTERNET-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Email / RSS
                    MenuChecks[$((S_OPT - 1))]=1
                    install_email_menu
                    # Progress Status
                    StatusBar1="INSTALL-INTERNET-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Instant Messaging
                    MenuChecks[$((S_OPT - 1))]=1
                    install_im_menu
                    # Progress Status
                    StatusBar1="INSTALL-INTERNET-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Internet Relay Chat
                    MenuChecks[$((S_OPT - 1))]=1
                    install_irc_menu
                    # Progress Status
                    StatusBar1="INSTALL-INTERNET-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Mapping Tools
                    MenuChecks[$((S_OPT - 1))]=1
                    install_mapping_menu
                    # Progress Status
                    StatusBar1="INSTALL-INTERNET-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # VNC / Desktop Share
                    MenuChecks[$((S_OPT - 1))]=1
                    install_desktop_share_menu
                    # Progress Status
                    StatusBar1="INSTALL-INTERNET-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL BROWSERS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_browsers_menu"
    USAGE="install_browsers_menu"
    DESCRIPTION=$(localize "INSTALL-BROWSERS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-BROWSERS-DESC"     "Install Internet Apps"
    localize_info "INSTALL-BROWSERS-TITLE"    "Web Browsers"
    #
    localize_info "INSTALL-BROWSERS-MENU-1"   "Firefox"
    localize_info "INSTALL-BROWSERS-MENU-2"   "Chromium"
    localize_info "INSTALL-BROWSERS-MENU-3"   "Google Chrome"
    localize_info "INSTALL-BROWSERS-MENU-4"   "Opera"
    localize_info "INSTALL-BROWSERS-MENU-5"   "Rekonq or Midori"
    localize_info "INSTALL-BROWSERS-MENU-5-I" "Rekonq or Midori: Depending on DE"
fi
# -------------------------------------
install_browsers_menu()
{
    local -r menu_name="INSTALL-BROWSERS"  # You must define Menu Name here
    local BreakableKey="B"                 # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"           # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions 2"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 2 3 4"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 2 3 4 5"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-BROWSERS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BROWSERS-MENU-1" "" ""     "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BROWSERS-MENU-2" "" ""     "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BROWSERS-MENU-3" "" "$AUR" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BROWSERS-MENU-4" "" ""     "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-BROWSERS-MENU-5" "" ""     "INSTALL-BROWSERS-MENU-5-I" "MenuTheme[@]" # 5
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_FIREFOX\" 'INSTALL-FIREFOX'" "INSTALL-FIREFOX" ; then
                        add_package "$INSTALL_FIREFOX"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-BROWSERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_CHROMIUM\" 'INSTALL-CHROMIUM'" "INSTALL-CHROMIUM" ; then
                        add_package "$INSTALL_CHROMIUM"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-BROWSERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GOOGLE_CHROME\" 'AUR-INSTALL-GOOGLE-CHROME'" "AUR-INSTALL-GOOGLE-CHROME" ; then
                        add_aur_package "$AUR_INSTALL_GOOGLE_CHROME"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-BROWSERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_OPERA\" 'INSTALL-OPERA'" "INSTALL-OPERA" ; then
                        add_package "$INSTALL_OPERA"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-BROWSERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if [[ "QT_INSTALL" -eq 1 ]]; then
                        if add_packagemanager "package_install \"$INSTALL_REKONQ\" 'INSTALL-REKONQ'" "INSTALL-REKONQ" ; then
                            add_package "$INSTALL_REKONQ"
                        fi
                    else
                        if add_packagemanager "package_install \"$INSTALL_MIDORI\" 'INSTALL-MIDORI'" "INSTALL-MIDORI" ; then
                            add_package "$INSTALL_MIDORI"
                        fi
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-BROWSERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL DOWNLOAD FILESHARE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_download_fileshare_menu"
    USAGE="install_download_fileshare_menu"
    DESCRIPTION=$(localize "INSTALL-DOWNLOAD-FILESHARE-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-DOWNLOAD-FILESHARE-DESC"   "Install Download / Fileshare Apps"
    #
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-1"   "Transmission"
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-I-1"      "Transmission: Transmission is a light-weighted and cross-platform BitTorrent client. It is the default BitTorrent client in many Linux distributions."
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-2"   "Deluge"
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-I-2"      "Deluge: Deluge is a lightweight, BitTorrent client written in python that offers users a powerful client/server architecture. Once a headless daemon has been setup, user can interact with it in three ways including a WebUI, GTK-UI, and console interface."
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-3"   "Dropbox"
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-I-3"      "Dropbox: Dropbox is a file sharing system that recently introduced a GNU/Linux client. Use it to transparently sync files across computers and architectures. Simply drop files into your ~/Dropbox folder, and they will automatically sync to your centralized repository."
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-4"   "Insync"
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-I-4"      "Insync: An unofficial Google Drive client that runs on Linux, with support for various desktops"
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-5"   "JDownloader"
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-I-5"      "JDownloader: JDownloader is a Download Manager written in Java. JDownloader can download normal files, but also files from online file hosting services like Rapidshare.com."
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-6"   "Nitroshare"
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-I-6"      "Nitroshare: Makes sending a file to another machine on the local network as easy as dragging-and-dropping"
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-7"   "Sparkleshare"
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-I-7"      "Sparkleshare: An open-source clone of Dropbox, written in Mono"
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-8"   "Steadyflow"
    localize_info "INSTALL-DOWNLOAD-FILESHARE-MENU-I-8"      "Steadyflow: steadyflow-bzr is a download manager that aims for minimalism, ease of use, and a clean, malleable codebase"
fi
# -------------------------------------
install_download_fileshare_menu()
{
    local -r menu_name="INSTALL-DOWNLOAD-FILESHARE"  # You must define Menu Name here
    local BreakableKey="B"                           # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"                     # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-DOWNLOAD-FILESHARE-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DOWNLOAD-FILESHARE-MENU-1" "" ""     "INSTALL-DOWNLOAD-FILESHARE-MENU-I-1" "MenuTheme[@]" # 1 Transmission
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DOWNLOAD-FILESHARE-MENU-2" "" "$AUR" "INSTALL-DOWNLOAD-FILESHARE-MENU-I-2" "MenuTheme[@]" # 2 deluge
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DOWNLOAD-FILESHARE-MENU-3" "" "$AUR" "INSTALL-DOWNLOAD-FILESHARE-MENU-I-3" "MenuTheme[@]" # 3 dropbox
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DOWNLOAD-FILESHARE-MENU-4" "" "$AUR" "INSTALL-DOWNLOAD-FILESHARE-MENU-I-4" "MenuTheme[@]" # 4 insync
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DOWNLOAD-FILESHARE-MENU-5" "" "$AUR" "INSTALL-DOWNLOAD-FILESHARE-MENU-I-5" "MenuTheme[@]" # 5 jdownloader
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DOWNLOAD-FILESHARE-MENU-6" "" "$AUR" "INSTALL-DOWNLOAD-FILESHARE-MENU-I-6" "MenuTheme[@]" # 6 nitroshare
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DOWNLOAD-FILESHARE-MENU-7" "" ""     "INSTALL-DOWNLOAD-FILESHARE-MENU-I-7" "MenuTheme[@]" # 7 sparkleshare
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DOWNLOAD-FILESHARE-MENU-8" "" "$AUR" "INSTALL-DOWNLOAD-FILESHARE-MENU-I-8" "MenuTheme[@]" # 8 steadyflow-bzr
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Transmission
                    MenuChecks[$((SS_OPT - 1))]=1
                    if [[ "$QT_INSTALL" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1 ]]; then # @FIX Should I install them both?
                            if add_packagemanager "package_install \"$INSTALL_TRANSMISSION_GTK\" 'INSTALL-TRANSMISSION-GTK'" "INSTALL-TRANSMISSION-GTK" ; then
                                add_package "$INSTALL_TRANSMISSION_GTK"
                            fi
                        fi
                        if add_packagemanager "package_install \"$INSTALL_TRANSMISSION_QT\" 'INSTALL-TRANSMISSION-QT'" "INSTALL-TRANSMISSION-QT" ; then
                            add_package "$INSTALL_TRANSMISSION_QT"
                        fi
                    else
                        if add_packagemanager "package_install \"$INSTALL_TRANSMISSION_GTK\" 'INSTALL-TRANSMISSION-GTK'" "INSTALL-TRANSMISSION-GTK" ; then
                            add_package "$INSTALL_TRANSMISSION_GTK"
                        fi
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DOWNLOAD-FILESHARE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # deluge
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_DELUGE\" 'INSTALL-DELUGE'" "INSTALL-DELUGE" ; then
                        add_package "$INSTALL_DELUGE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DOWNLOAD-FILESHARE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # dropbox
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_DROPBOX\" 'AUR-INSTALL-DROPBOX'" "AUR-INSTALL-DROPBOX" ; then
                        add_aur_package "$AUR_INSTALL_DROPBOX"
                    fi
                    add_packagemanager "if [[ check_package 'nautilus' ]]; then if aur_package_install \"$AUR_INSTALL_DROPBOX_NAUTILUS\" 'AUR-INSTALL-DROPBOX-NAUTILUS'; then add_aur_package "$AUR_INSTALL_DROPBOX_NAUTILUS"; fi fi" "AUR-INSTALL-DROPBOX-NAUTILUS"
                    add_packagemanager "if [[ check_package 'thunar' ]]; then if aur_package_install \"$AUR_INSTALL_DROPBOX_THUNAR\" 'AUR-INSTALL-DROPBOX-THUNAR'; then add_aur_package "$AUR_INSTALL_DROPBOX_THUNAR"; fi fi" "AUR-INSTALL-DROPBOX-THUNAR"
                    add_packagemanager "if [[ check_package 'kdebase-dolphin' ]]; then if aur_package_install \"$AUR_INSTALL_DROPBOX_KFILEBOX\" 'AUR-INSTALL-DROPBOX-KFILEBOX'; then add_aur_package "$AUR_INSTALL_DROPBOX_KFILEBOX"; fi fi" "AUR-INSTALL-DROPBOX-KFILEBOX"
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_DROPBOX_CLI\" 'AUR-INSTALL-DROPBOX-CLI'" "AUR-INSTALL-DROPBOX-CLI" ; then
                        add_aur_package "$AUR_INSTALL_DROPBOX_CLI"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DOWNLOAD-FILESHARE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # insync
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_INSYNC\" 'AUR-INSTALL-INSYNC'" "AUR-INSTALL-INSYNC" ; then
                        add_aur_package "$AUR_INSTALL_INSYNC"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DOWNLOAD-FILESHARE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # jdownloader
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_JDOWNLOADER\" 'AUR-INSTALL-JDOWNLOADER'" "AUR-INSTALL-JDOWNLOADER" ; then
                        add_aur_package "$AUR_INSTALL_JDOWNLOADER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DOWNLOAD-FILESHARE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # nitroshare
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_NITROSHARE\" 'AUR-INSTALL-NITROSHARE" "AUR-INSTALL-NITROSHARE" ; then
                        add_aur_package "$AUR_INSTALL_NITROSHARE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DOWNLOAD-FILESHARE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # sparkleshare
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_SPARKLESHARE\" 'INSTALL-SPARKLESHARE'" "INSTALL-SPARKLESHARE" ; then
                        add_package "$INSTALL_SPARKLESHARE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DOWNLOAD-FILESHARE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # steadyflow-bzr
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_STEADYFLOW\" 'AUR-INSTALL-STEADYFLOW'" "AUR-INSTALL-STEADYFLOW" ; then
                        add_aur_package "$AUR_INSTALL_STEADYFLOW"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DOWNLOAD-FILESHARE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL EMAIL {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_email_menu"
    USAGE="install_email_menu"
    DESCRIPTION=$(localize "INSTALL-EMAIL-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-EMAIL-DESC"     "Install Email / RSS Applications"
    #
    localize_info "INSTALL-EMAIL-MENU-1"    "Evolution"
    localize_info "INSTALL-EMAIL-MENU-I-1"         "Evolution: Evolution is a GNOME mail client it supports IMAP, Microsoft Exchange Server and Novell GroupWise. It also has a calender function that supports vcal,csv, google calendar and many more. You can also organise your contacts, tasks and memos with Evolution. The beautiful thing about evolution is that it's easy to use and integrates with the gnome environment. You can see your calendar, tasks and location in the GNOME panel along with the weather and date. Just add the clock to your gnome panel."
    localize_info "INSTALL-EMAIL-MENU-2"    "Thunderbird"
    localize_info "INSTALL-EMAIL-MENU-I-2"         "Thunderbird: Mozilla Thunderbird is an email, newsgroup, and news feed client designed around simplicity and full-featuredness while avoiding bloat. It supports POP, IMAP, SMTP, S/MIME, and OpenPGP encryption (through the Enigmail extension). Similarly to Firefox, it has a wide variety of extension and addons available for download that add more features."
    localize_info "INSTALL-EMAIL-MENU-3"    "Liferea"
    localize_info "INSTALL-EMAIL-MENU-I-3"         "Liferea: A desktop news aggregator for online news feeds and weblogs"
    localize_info "INSTALL-EMAIL-MENU-4"    "Lightread"
    localize_info "INSTALL-EMAIL-MENU-I-4"         "Lightread: A totally awesome offline Google Reader."
fi
# -------------------------------------
install_email_menu()
{
    local -r menu_name="INSTALL-EMAIL"  # You must define Menu Name here
    local BreakableKey="B"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 2"      # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-EMAIL-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EMAIL-MENU-1" "" "" "INSTALL-EMAIL-MENU-I-1" "MenuTheme[@]" # 1 Evolution
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EMAIL-MENU-2" "" "" "INSTALL-EMAIL-MENU-I-2" "MenuTheme[@]" # 2 Thunderbird
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EMAIL-MENU-3" "" "" "INSTALL-EMAIL-MENU-I-3" "MenuTheme[@]" # 3 Liferea
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-EMAIL-MENU-4" "" "" "INSTALL-EMAIL-MENU-I-4" "MenuTheme[@]" # 4 Lightread
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Evolution
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_EVOLUTION\" 'INSTALL-EVOLUTION'" "INSTALL-EVOLUTION" ; then
                        add_package "$INSTALL_EVOLUTION"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-EMAIL-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Thunderbird
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_THUNDERBIRD\" 'INSTALL-THUNDERBIRD'" "INSTALL-THUNDERBIRD" ; then
                        add_package "$INSTALL_THUNDERBIRD"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-EMAIL-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Liferea
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_LIFEREA\" 'INSTALL-LIFEREA'" "INSTALL-LIFEREA" ; then
                        add_package "$INSTALL_LIFEREA"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-EMAIL-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Lightread
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_LIGHTREAD\" 'AUR-INSTALL-LIGHTREAD'" "AUR-INSTALL-LIGHTREAD" ; then
                        add_aur_package "$AUR_INSTALL_LIGHTREAD"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-EMAIL-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL IM {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_im_menu"
    USAGE="install_im_menu"
    DESCRIPTION=$(localize "INSTALL-IM-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-IM-DESC"   "Install IM - Instant Messaging"
    #
    localize_info "INSTALL-IM-MENU-1"   "Pidgin"
    localize_info "INSTALL-IM-MENU-I-1"      "Pidgin: Multi-protocol instant messaging client"
    localize_info "INSTALL-IM-MENU-2"   "Skype"
    localize_info "INSTALL-IM-MENU-I-2"      "Skype: P2P software for high-quality voice communication - with a Commerical License."
    localize_info "INSTALL-IM-MENU-3"   "Emesene"
    localize_info "INSTALL-IM-MENU-I-3"      "Emesene: A pygtk MSN Messenger client"
    localize_info "INSTALL-IM-MENU-4"   "Google Talkplugin"
    localize_info "INSTALL-IM-MENU-I-4"      "Google Talkplugin: Video chat browser plug-in for Google Talk"
    localize_info "INSTALL-IM-MENU-5"   "Teamspeak3"
    localize_info "INSTALL-IM-MENU-I-5"      "Teamspeak3: TeamSpeak is software for quality voice communication via the Internet"
fi
# -------------------------------------
install_im_menu()
{
    local -r menu_name="INSTALL-IM"  # You must define Menu Name here
    local BreakableKey="B"           # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 2"   # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-IM-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-IM-MENU-3" "" ""     "INSTALL-IM-MENU-I-3" "MenuTheme[@]" # 1 Pidgin
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-IM-MENU-4" "" ""     "INSTALL-IM-MENU-I-4" "MenuTheme[@]" # 2 Skype
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-IM-MENU-1" "" ""     "INSTALL-IM-MENU-I-1" "MenuTheme[@]" # 3 Emesene
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-IM-MENU-2" "" "$AUR" "INSTALL-IM-MENU-I-2" "MenuTheme[@]" # 4 Google Talkplugin
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-IM-MENU-5" "" "$AUR" "INSTALL-IM-MENU-I-5" "MenuTheme[@]" # 5 Teamspeak3
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Pidgin
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_PIDGIN\" 'INSTALL-PIDGIN'" "INSTALL-PIDGIN" ; then
                        add_package "$INSTALL_PIDGIN"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-IM-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Skype
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_taskmanager "required_repo 'multilib'" "REQUIRED-REPO-MULTILIB"                    
                    if add_packagemanager "package_install \"$INSTALL_SKYPE\" 'INSTALL-SKYPE'" "INSTALL-SKYPE" ; then
                        add_package "$INSTALL_SKYPE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-IM-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Emesene
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_EMESENE\"  'INSTALL-EMESENE'" "INSTALL-EMESENE" ; then
                        add_package "$INSTALL_EMESENE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-IM-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Google Talkplugin
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GOOGLE_TALKPLUGIN\" 'AUR-INSTALL-GOOGLE-TALKPLUGIN'" "AUR-INSTALL-GOOGLE-TALKPLUGIN" ; then
                        add_aur_package "$AUR_INSTALL_GOOGLE_TALKPLUGIN"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-IM-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Teamspeak3
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_TEAMSPEAK3\" 'AUR-INSTALL-TEAMSPEAK3'" "AUR-INSTALL-TEAMSPEAK3" ; then
                        add_aur_package "$AUR_INSTALL_TEAMSPEAK3"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-IM-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL IRC {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_irc_menu"
    USAGE="install_irc_menu"
    DESCRIPTION=$(localize "INSTALL-IRC-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-IRC-DESC"   "Install IRC - Internet Relay Chat"
    #
    localize_info "INSTALL-IRC-MENU-1"   "irssi"
    localize_info "INSTALL-IRC-MENU-I-1"     "irssi: Modular text mode IRC client with Perl scripting"
    localize_info "INSTALL-IRC-MENU-2"   "quassel or xchat"
    localize_info "INSTALL-IRC-MENU-I-2"     "quassel or xchat: quassel (QT4 irc client with a separated core) or xchat (A GTK+ based IRC client): Depending on DE"
fi
# -------------------------------------
install_irc_menu()
{
    local -r menu_name="INSTALL-IRC"  # You must define Menu Name here
    local BreakableKey="B"            # Q=Quit, D=Done, B=Back
    local RecommendedOptions="2"      # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-IRC-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-IRC-MENU-1" "" "" "INSTALL-IRC-MENU-I-1" "MenuTheme[@]" # irssi
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-IRC-MENU-2" "" "" "INSTALL-IRC-MENU-I-2" "MenuTheme[@]" # quassel or xchat
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # irssi
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_IRSSI\" 'INSTALL-IRSSI'" "INSTALL-IRSSI" ; then
                        add_package "$INSTALL_IRSSI"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-IRC-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # quassel or xchat
                    MenuChecks[$((SS_OPT - 1))]=1
                    if [[ "QT_INSTALL" -eq 1 ]]; then
                        if [[ "QT_INSTALL" -eq 1 ]]; then
                            if add_packagemanager "package_install \"$INSTALL_XCHAT\" 'INSTALL-XCHAT'" "INSTALL-XCHAT" ; then
                                add_package "$INSTALL_XCHAT"
                            fi
                        fi
                        if add_packagemanager "package_install \"$INSTALL_QUASSEL\" 'INSTALL-QUASSEL'" "INSTALL-QUASSEL" ; then
                            add_package "$INSTALL_QUASSEL"
                        fi
                    else
                        if add_packagemanager "package_install \"$INSTALL_XCHAT\" 'INSTALL-XCHAT'" "INSTALL-XCHAT" ; then
                            add_package "$INSTALL_XCHAT"
                        fi
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-IRC-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL MAPPING {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_mapping_menu"
    USAGE="install_mapping_menu"
    DESCRIPTION=$(localize "INSTALL-MAPPING-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-MAPPING-DESC"     "Install Mapping Tools"
    #
    localize_info "INSTALL-MAPPING-MENU-1"   "Google Earth"
    localize_info "INSTALL-MAPPING-MENU-I-1"        "Google Earth: Google Earth lets you fly anywhere on Earth to view satellite imagery, maps, terrain, 3D buildings, from galaxies in outer space to the canyons of the ocean. You can explore rich geographical content, save your toured places, and share with others."
    localize_info "INSTALL-MAPPING-MENU-2"   "NASA World Wind"
    localize_info "INSTALL-MAPPING-MENU-I-2"        "NASA World Wind: An Open Source 3D Interactive World viewer"
fi
# -------------------------------------
install_mapping_menu()
{
    local -r menu_name="INSTALL-MAPPING"  # You must define Menu Name here
    local BreakableKey="B"                # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 2"        # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #                    
    while [[ 1 ]];  do
        print_title "INSTALL-MAPPING-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAPPING-MENU-1" "" "$AUR" "" "MenuTheme[@]" # Google Earth
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAPPING-MENU-2" "" "$AUR" "" "MenuTheme[@]" # NASA World Wind
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Google Earth
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_taskmanager "required_repo 'multilib'" "REQUIRED-REPO-MULTILIB"
                    if add_packagemanager "package_install \"$INSTALL_GOOGLE_EARTH\" 'INSTALL-GOOGLE-EARTH'" "INSTALL-GOOGLE-EARTH" ; then
                        add_package "$INSTALL_GOOGLE_EARTH"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GOOGLE_EARTH\" 'AUR-INSTALL-GOOGLE-EARTH'" "AUR-INSTALL-GOOGLE-EARTH" ; then
                        add_aur_package "$AUR_INSTALL_GOOGLE_EARTH"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-MAPPING-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # NASA World Wind
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_WORLDWIND\" 'AUR-INSTALL-WORLDWIND'" "AUR-INSTALL-WORLDWIND" ; then
                        add_aur_package "$AUR_INSTALL_WORLDWIND"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-MAPPING-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL DESKTOP SHARE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_desktop_share_menu"
    USAGE="install_desktop_share_menu"
    DESCRIPTION=$(localize "INSTALL-DESKTOP-SHARE-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-DESKTOP-SHARE-DESC"   "Install Desktop Share"
    localize_info "INSTALL-DESKTOP-SHARE-MENU-1"   "Remmina"
    localize_info "INSTALL-DESKTOP-SHARE-MENU-I-1"       "Remmina: Remmina is a remote desktop client written in GTK+."
    localize_info "INSTALL-DESKTOP-SHARE-MENU-2"   "Teamviewer"
    localize_info "INSTALL-DESKTOP-SHARE-MENU-I-2"       "Teamviewer: All-in-one solution for accessing PC's using the internet - has Commercial license."
fi
# -------------------------------------
install_desktop_share_menu()
{
    local -r menu_name="INSTALL-DESKTOP-SHARE"  # You must define Menu Name here
    local BreakableKey="B"                      # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"                # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-DESKTOP-SHARE-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # $AURReset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-SHARE-MENU-1" "" ""     "INSTALL-DESKTOP-SHARE-MENU-I-1" "MenuTheme[@]" # Remmina
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-SHARE-MENU-2" "" "$AUR" "INSTALL-DESKTOP-SHARE-MENU-I-2" "MenuTheme[@]" # Teamviewer
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Remmina
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_REMMINA\" 'INSTALL-REMMINA'" "INSTALL-REMMINA" ; then
                        add_package "$INSTALL_REMMINA"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DESKTOP-SHARE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Teamviewer
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_TEAMVIEWER\" 'AUR-INSTALL-TEAMVIEWER'" "AUR-INSTALL-TEAMVIEWER" ; then
                        add_aur_package "$AUR_INSTALL_TEAMVIEWER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-DESKTOP-SHARE-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL GRAPHICS APPS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_graphics_apps_menu"
    USAGE="install_graphics_apps_menu"
    DESCRIPTION=$(localize "INSTALL-GRAPHICS-APPS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-GRAPHICS-APPS-DESC"   "Install Graphic Applications"
    #
    localize_info "INSTALL-GRAPHICS-APPS-TITLE"    "Graphic Applications"
    # Blender, Handbrake, CD/DVD Burners, Gimp, Gthumb, Inkscape, Mcomix, MyPaint, Scribus, Shotwell, Simple-scan, Xnviewmp, Qt Image Viewers, Qt Image Editors
    localize_info "INSTALL-GRAPHICS-APPS-MENU-1"   "AV Studio"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-1"      "AV Studio: Installs all Below and more Audio and Video Apps"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-2"   "Blender"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-2"      "Blender: A fully integrated 3D graphics creation suite."
    localize_info "INSTALL-GRAPHICS-APPS-MENU-3"   "Handbrake"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-3"      "Handbrake: Multithreaded video transcoder"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-4"   "CD/DVD Burners"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-4"      "CD/DVD Burners: brasero (A disc burning application for Gnome), dvd+rw-tools (DVD burning tools), dvdauthor (DVD authoring tools), Gnomebaker (AUR: A full featured CD/DVD burning application for Gnome), k3b (Feature-rich and easy to handle CD burning application) and Xfburn"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-5"   "Gimp"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-5"      "Gimp: GNU Image Manipulation Program"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-6"   "Gimp-plugins"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-6"      "Gimp-plugins: GNU Image Manipulation Program Plugins."
    localize_info "INSTALL-GRAPHICS-APPS-MENU-7"   "Gthumb"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-7"      "Gthumb: Image browser and viewer for the GNOME Desktop"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-8"   "Inkscape"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-8"      "Inkscape: Vector graphics editor using the SVG file format"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-9"   "Mcomix"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-9"      "Mcomix: A user-friendly, customizable image viewer specifically designed to handle comic books"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-10"  "MyPaint"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-10"      "MyPaint: A fast and easy painting application for digital painters, with brush dynamics"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-11"  "Scribus"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-11"      "Scribus: A desktop publishing program"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-12"  "Shotwell"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-12"      "Shotwell: A digital photo organizer designed for the GNOME desktop environment"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-13"  "Simple-scan"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-13"      "Simple-scan: Simple scanning utility"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-14"  "Xnviewmp"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-14"      "Xnviewmp: An efficient multimedia viewer, browser and converter (beta release)."
    localize_info "INSTALL-GRAPHICS-APPS-MENU-15"   "Qt Image Viewers"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-15"       "Qt Image Viewers: nomacs, limoo, qiviewer"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-16"   "Qt Image Editors"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-16"       "Image Editors: easypaint-git, pencil-svn"

fi
# -------------------------------------
install_graphics_apps_menu()
{
    # 6
    local -r menu_name="INSTALL-GRAPHICS-APPS"  # You must define Menu Name here
    local BreakableKey="D"                      # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""                # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions 3-13"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions 1"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 1"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 1"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-GRAPHICS-APPS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-1"  "" "$SOME_AUR" "INSTALL-GRAPHICS-APPS-MENU-I-1"  "MenuTheme[@]" # AV Studio
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-2"  "" ""          "INSTALL-GRAPHICS-APPS-MENU-I-2"  "MenuTheme[@]" # Blender
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-3"  "" ""          "INSTALL-GRAPHICS-APPS-MENU-I-3"  "MenuTheme[@]" # Handbrake
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-4"  "" "$SOME_AUR" "INSTALL-GRAPHICS-APPS-MENU-I-4"  "MenuTheme[@]" # CD/DVD Burners
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-5"  "" ""          "INSTALL-GRAPHICS-APPS-MENU-I-5"  "MenuTheme[@]" # Gimp
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-6"  "" "$AUR"      "INSTALL-GRAPHICS-APPS-MENU-I-6"  "MenuTheme[@]" # Gimp-plugins
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-7"  "" ""          "INSTALL-GRAPHICS-APPS-MENU-I-7"  "MenuTheme[@]" # Gthumb
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-8"  "" ""          "INSTALL-GRAPHICS-APPS-MENU-I-8"  "MenuTheme[@]" # Inkscape
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-9"  "" ""          "INSTALL-GRAPHICS-APPS-MENU-I-9"  "MenuTheme[@]" # Mcomix
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-10" "" ""          "INSTALL-GRAPHICS-APPS-MENU-I-10" "MenuTheme[@]" # MyPaint
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-11" "" ""          "INSTALL-GRAPHICS-APPS-MENU-I-11" "MenuTheme[@]" # Scribus
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-12" "" ""          "INSTALL-GRAPHICS-APPS-MENU-I-12" "MenuTheme[@]" # Shotwell
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-13" "" ""          "INSTALL-GRAPHICS-APPS-MENU-I-13" "MenuTheme[@]" # Simple-scan
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-14" "" "$AUR"      "INSTALL-GRAPHICS-APPS-MENU-I-14" "MenuTheme[@]" # Xnviewmp
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-15" "" ""          "INSTALL-GRAPHICS-APPS-MENU-I-15" "MenuTheme[@]" # Qt Image Viewers
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-16" "" "$AUR"      "INSTALL-GRAPHICS-APPS-MENU-I-16" "MenuTheme[@]" # Qt Image Editors
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # AV Studio
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_BLENDER\" 'INSTALL-BLENDER'" "INSTALL-BLENDER" ; then
                        add_package "$INSTALL_BLENDER"
                    fi
                    if add_packagemanager "package_install \"$INSTALL_HANDBRAKE\" 'INSTALL-HANDBRAKE'" "INSTALL-HANDBRAKE" ; then
                        add_package "$INSTALL_HANDBRAKE"
                    fi
                    if add_packagemanager "package_install \"$INSTALL_CD_DVD_BURNERS\" 'INSTALL-CD-DVD-BURNERS'" "INSTALL-CD-DVD-BURNERS" ; then
                        add_package "$INSTALL_CD_DVD_BURNERS"
                    fi
                    if add_packagemanager "package_install \"$INSTALL_GIMP\"  'INSTALL-GIMP'" "INSTALL-GIMP" ; then
                        add_package "$INSTALL_GIMP"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GIMP_PLUGINS\" 'AUR-INSTALL-GIMP-PLUGINS'" "AUR-INSTALL-GIMP-PLUGINS" ; then
                        add_aur_package "$AUR_INSTALL_GIMP_PLUGINS"
                    fi
                    if add_packagemanager "package_install \"$INSTALL_GTHUMB\" 'INSTALL-GTHUMB'" "INSTALL-GTHUMB" ; then
                        add_package "$INSTALL_GTHUMB"
                    fi
                    if add_packagemanager "package_install \"$INSTALL_INKSCAPE\" 'INSTALL-INKSCAPE'" "INSTALL-INKSCAPE" ; then
                        add_package "$INSTALL_INKSCAPE"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_SOZI\" 'AUR-INSTALL-SOZI'" "AUR-INSTALL-SOZI" ; then
                        add_aur_package "$AUR_INSTALL_SOZI"
                    fi
                    if add_packagemanager "package_install \"$INSTALL_MCOMIX\" 'INSTALL-MCOMIX'" "INSTALL-MCOMIX" ; then
                        add_package "$INSTALL_MCOMIX"
                    fi
                    if add_packagemanager "package_install \"$INSTALL_MYPAINT\"  'INSTALL-MYPAINT'" "INSTALL-MYPAINT" ; then
                        add_package "$INSTALL_MYPAINT"
                    fi
                    if add_packagemanager "package_install \"$INSTALL_SCRIBUS\" 'INSTALL-SCRIBUS'" "INSTALL-SCRIBUS" ; then
                        add_package "$INSTALL_SCRIBUS"
                    fi

                    if add_packagemanager "package_install \"$INSTALL_SHOTWELL\" 'INSTALL-SHOTWELL'" "INSTALL-SHOTWELL" ; then
                        add_package "$INSTALL_SHOTWELL"
                    fi
                    # Simple-scan
                    if add_packagemanager "package_install \"$INSTALL_SIMPLE_SCAN\" 'INSTALL-SIMPLE-SCAN'" "INSTALL-SIMPLE-SCAN" ; then
                        add_package "$INSTALL_SIMPLE_SCAN"
                    fi
                    # Xnviewmp
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_XNVIEWMP\" 'AUR-INSTALL-XNVIEWMP'" "AUR-INSTALL-XNVIEWMP" ; then
                        add_aur_package "$AUR_INSTALL_XNVIEWMP"
                    fi
                    # Qt Image Viewers 
                    if add_packagemanager "package_install \"$INSTALL_QT_IMAGE_VIEWERS\" 'INSTALL-QT-IMAGE-VIEWERS'" "INSTALL-QT-IMAGE-VIEWERS" ; then
                        add_package "$INSTALL_QT_IMAGE_VIEWERS"
                    fi
                    #
                    if add_packagemanager "aur_package_install \"$AUR_QT_IMAGE_VIEWERS\" 'AUR-INSTALL-QT-IMAGE-VIEWERS'" "AUR-INSTALL-QT-IMAGE-VIEWERS" ; then
                        add_package "$AUR_QT_IMAGE_VIEWERS"
                    fi
                    # Qt Image Editors
                    if add_packagemanager "aur_package_install \"$AUR_QT_IMAGE_EDITORS\" 'AUR-INSTALL-QT-IMAGE-EDITORS'" "AUR-INSTALL-QT-IMAGE-EDITORS" ; then
                        add_aur_package "$AUR_QT_IMAGE_EDITORS"
                    fi
                    #
                    if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                        if add_packagemanager "package_install \"$AV_STUDIO_GTK\" 'INSTALL-AUDIO-VIDEO-STUDIO-GTK'" "INSTALL-AUDIO-VIDEO-STUDIO-GTK" ; then
                            add_package "$AV_STUDIO_GTK"
                        fi
                    fi
                    #
                    if [[ "QT_INSTALL" -eq 1 ]]; then
                        if add_packagemanager "package_install \"$AV_STUDIO_KDE\" 'INSTALL-AUDIO-VIDEO-STUDIO-KDE'" "INSTALL-AUDIO-VIDEO-STUDIO-KDE" ; then
                            add_package "$AV_STUDIO_KDE"
                        fi
                    else
                        if add_packagemanager "package_install \"$AV_STUDIO_KDEGRAPHICS\" 'INSTALL-AUDIO-VIDEO-STUDIO-KDEGRAPHICS'" "INSTALL-AUDIO-VIDEO-STUDIO-KDEGRAPHICS" ; then
                            add_package "$AV_STUDIO_KDEGRAPHICS"
                        fi
                    fi
                    #
                    if add_packagemanager "aur_package_install \"$AV_STUDIO_AUR\" 'AUR-INSTALL-AUDIO-VIDEO-STUDIO'" "AUR-INSTALL-AUDIO-VIDEO-STUDIO" ; then
                        add_aur_package "$AV_STUDIO_AUR"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Blender
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_BLENDER\" 'INSTALL-BLENDER'" "INSTALL-BLENDER" ; then
                        add_package "$INSTALL_BLENDER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Handbrake
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_HANDBRAKE\" 'INSTALL-HANDBRAKE'" "INSTALL-HANDBRAKE" ; then
                        add_package "$INSTALL_HANDBRAKE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # CD/DVD Burners
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_CD_DVD_BURNERS\" 'INSTALL-CD-DVD-BURNERS'" "INSTALL-CD-DVD-BURNERS" ; then
                        add_package "$INSTALL_CD_DVD_BURNERS"
                    fi
                    #
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_CD_DVD_BURNERS\" 'AUR-INSTALL-CD-DVD-BURNERS'" "AUR-INSTALL-CD-DVD-BURNERS" ; then
                        add_aur_package "$AUR_INSTALL_CD_DVD_BURNERS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Gimp
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GIMP\"  'INSTALL-GIMP'" "INSTALL-GIMP" ; then
                        add_package "$INSTALL_GIMP"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Gimp-plugins
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GIMP\"  'INSTALL-GIMP'" "INSTALL-GIMP" ; then
                        add_package "$INSTALL_GIMP"
                    fi
                    #
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GIMP_PLUGINS\" 'AUR-INSTALL-GIMP-PLUGINS'" "AUR-INSTALL-GIMP-PLUGINS" ; then
                        add_aur_package "$AUR_INSTALL_GIMP_PLUGINS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # Gthumb
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GTHUMB\" 'INSTALL-GTHUMB'" "INSTALL-GTHUMB" ; then
                        add_package "$INSTALL_GTHUMB"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # Inkscape
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_INKSCAPE\" 'INSTALL-INKSCAPE'" "INSTALL-INKSCAPE" ; then
                        add_package "$INSTALL_INKSCAPE"
                    fi
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_SOZI\" 'AUR-INSTALL-SOZI'" "AUR-INSTALL-SOZI" ; then
                        add_aur_package "$AUR_INSTALL_SOZI"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # Mcomix
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_MCOMIX\" 'INSTALL-MCOMIX'" "INSTALL-MCOMIX" ; then
                        add_package "$INSTALL_MCOMIX"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               10)  # MyPaint
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_MYPAINT\"  'INSTALL-MYPAINT'" "INSTALL-MYPAINT" ; then
                        add_package "$INSTALL_MYPAINT"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               11)  # Scribus
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_SCRIBUS\" 'INSTALL-SCRIBUS'" "INSTALL-SCRIBUS" ; then
                        add_package "$INSTALL_SCRIBUS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               12)  # Shotwell
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_SHOTWELL\" 'INSTALL-SHOTWELL'" "INSTALL-SHOTWELL" ; then
                        add_package "$INSTALL_SHOTWELL"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               13)  # Simple-scan
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_SIMPLE_SCAN\" 'INSTALL-SIMPLE-SCAN'" "INSTALL-SIMPLE-SCAN" ; then
                        add_package "$INSTALL_SIMPLE_SCAN"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               14)  # Xnviewmp
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_XNVIEWMP\" 'AUR-INSTALL-XNVIEWMP'" "AUR-INSTALL-XNVIEWMP" ; then
                        add_aur_package "$AUR_INSTALL_XNVIEWMP"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               15)  # Qt Image Viewers 
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_QT_IMAGE_VIEWERS\" 'INSTALL-QT-IMAGE-VIEWERS'" "INSTALL-QT-IMAGE-VIEWERS" ; then
                        add_package "$INSTALL_QT_IMAGE_VIEWERS"
                    fi
                    #
                    if add_packagemanager "aur_package_install \"$AUR_QT_IMAGE_VIEWERS\" 'AUR-INSTALL-QT-IMAGE-VIEWERS'" "AUR-INSTALL-QT-IMAGE-VIEWERS" ; then
                        add_package "$AUR_QT_IMAGE_VIEWERS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
               16)  # Qt Image Editors
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_QT_IMAGE_EDITORS\" 'AUR-INSTALL-QT-IMAGE-EDITORS'" "AUR-INSTALL-QT-IMAGE-EDITORS" ; then
                        add_aur_package "$AUR_QT_IMAGE_EDITORS"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-GRAPHICS-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL VIDEO APPS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_video_apps_menu"
    USAGE="install_video_apps_menu"
    DESCRIPTION=$(localize "INSTALL-VIDEO-APPS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-VIDEO-APPS-DESC"     "Install Video Apps"
    # Players, Editors \ Tools, Codecs
    localize_info "INSTALL-VIDEO-APPS-MENU-1"   "Players"
    localize_info "INSTALL-VIDEO-APPS-MENU-I-1"     "Players: Sub Menu"
    localize_info "INSTALL-VIDEO-APPS-MENU-2"   "Editors / Tools"
    localize_info "INSTALL-VIDEO-APPS-MENU-I-2"     "Editors / Tools: Sub Menu"
    localize_info "INSTALL-VIDEO-APPS-MENU-3"   "Codecs"
    localize_info "INSTALL-VIDEO-APPS-MENU-I-3"     "Codecs: $AUR_INSTALL_CODECS_64"
fi
# -------------------------------------
install_video_apps_menu()
{
    # 9
    local -r menu_name="INSTALL-VIDEO-APPS"  # You must define Menu Name here
    local BreakableKey="D"                   # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-3"           # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-VIDEO-APPS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-APPS-MENU-1" "" ""     "INSTALL-VIDEO-APPS-MENU-I-1" "MenuTheme[@]" # 1 Players
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-APPS-MENU-2" "" "$AUR" "INSTALL-VIDEO-APPS-MENU-I-2" "MenuTheme[@]" # 2 Editors | Tools
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-APPS-MENU-3" "" "$AUR" "INSTALL-VIDEO-APPS-MENU-I-3" "MenuTheme[@]" # 3 Codecs
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Players
                    MenuChecks[$((S_OPT - 1))]=1
                    install_video_players_menu
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Editors | Tools
                    MenuChecks[$((S_OPT - 1))]=1
                    install_video_editors_tools_menu
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Codecs
                    MenuChecks[$((S_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_VIDEO_CODECS\"  'INSTALL-VIDEO-CODECS'" "INSTALL-VIDEO-CODECS" ; then
                        add_package "$INSTALL_VIDEO_CODECS"
                    fi
                    if [[ "$ARCHI" != "x86_64" ]]; then
                        if add_packagemanager "aur_package_install \"$AUR_INSTALL_CODECS\" 'AUR-INSTALL-CODECS'" "AUR-INSTALL-CODECS" ; then
                            add_aur_package "$AUR_INSTALL_CODECS"
                        fi
                    else
                        if add_packagemanager "aur_package_install \"$AUR_INSTALL_CODECS_64\" 'AUR-INSTALL-CODECS-64'" "AUR-INSTALL-CODECS-64" ; then
                            add_aur_package "$AUR_INSTALL_CODECS_64"
                        fi
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-APPS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL VIDEO PLAYERS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_video_players_menu"
    USAGE="install_video_players_menu"
    DESCRIPTION=$(localize "INSTALL-VIDEO-PLAYERS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-VIDEO-PLAYERS-DESC"   "Install Video Players"

    localize_info "INSTALL-VIDEO-PLAYERS-MENU-1"   "Audience-bzr"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-I-1"       "Audience-bzr: A simple and modern media player."
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-2"   "Gnome-mplayer"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-I-2"       "Gnome-mplayer: A simple MPlayer GUI."
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-3"   "Parole"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-I-3"       "Parole: A modern media player based on the GStreamer framework"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-4"   "MiniTube"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-I-4"       "MiniTube: A native YouTube client in QT. Watch YouTube videos without Flash Player"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-5"   "Miro"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-I-5"       "Miro: The free and open source internet TV platform"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-6"   "Rosa Media Player"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-I-6"       "Rosa Media Player: The new multimedia player(based on SMPlayer) with clean and elegant UI."
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-7"   "smplayer"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-I-7"       "smplayer: A complete front-end for MPlayer"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-8"   "VLC"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-I-8"       "VLC: A multi-platform MPEG, VCD/DVD, and DivX player"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-9"   "XBMC"
    localize_info "INSTALL-VIDEO-PLAYERS-MENU-I-9"       "XBMC: A software media player and entertainment hub for digital media"
fi
# -------------------------------------
install_video_players_menu()
{
    local -r menu_name="INSTALL-VIDEO-PLAYERS"  # You must define Menu Name here
    local BreakableKey="B"                      # Q=Quit, D=Done, B=Back
    local RecommendedOptions="2 3 7 8"          # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions 4"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions  4"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions 2-9"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-VIDEO-PLAYERS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-PLAYERS-MENU-1" "" "$AUR" "INSTALL-VIDEO-PLAYERS-MENU-I-1" "MenuTheme[@]" # 1 Audience-bzr
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-PLAYERS-MENU-2" "" ""     "INSTALL-VIDEO-PLAYERS-MENU-I-2" "MenuTheme[@]" # 2 Gnome-mplayer
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-PLAYERS-MENU-3" "" ""     "INSTALL-VIDEO-PLAYERS-MENU-I-3" "MenuTheme[@]" # 3 Parole
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-PLAYERS-MENU-4" "" ""     "INSTALL-VIDEO-PLAYERS-MENU-I-4" "MenuTheme[@]" # 4 MiniTube
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-PLAYERS-MENU-5" "" ""     "INSTALL-VIDEO-PLAYERS-MENU-I-5" "MenuTheme[@]" # 5 Miro
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-PLAYERS-MENU-6" "" "$AUR" "INSTALL-VIDEO-PLAYERS-MENU-I-6" "MenuTheme[@]" # 6 Rosa Media Player
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-PLAYERS-MENU-7" "" ""     "INSTALL-VIDEO-PLAYERS-MENU-I-7" "MenuTheme[@]" # 7 smplayer
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-PLAYERS-MENU-8" "" ""     "INSTALL-VIDEO-PLAYERS-MENU-I-8" "MenuTheme[@]" # 8 VLC
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-PLAYERS-MENU-9" "" ""     "INSTALL-VIDEO-PLAYERS-MENU-I-9" "MenuTheme[@]" # 9 XBMC
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Audience-bzr
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_AUDIENCE\" 'AUR-INSTALL-AUDIENCE'" "AUR-INSTALL-AUDIENCE" ; then
                        add_aur_package "$AUR_INSTALL_AUDIENCE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-PLAYERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Gnome-mplayer
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_GNOME_MPLAYER\"  'INSTALL-GNOME-MPLAYER'" "INSTALL-GNOME-MPLAYER" ; then
                        add_package "$INSTALL_GNOME_MPLAYER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-PLAYERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # Parole
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_PAROLE\" 'INSTALL-PAROLE'" "INSTALL-PAROLE" ; then
                        add_package "$INSTALL_PAROLE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-PLAYERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # MiniTube
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_MINITUBE\" 'INSTALL-MINITUBE'" "INSTALL-MINITUBE" ; then
                        add_package "$INSTALL_MINITUBE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-PLAYERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Miro
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_MIRO\" 'INSTALL-MIRO'" "INSTALL-MIRO" ; then
                        add_package "$INSTALL_MIRO"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-PLAYERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Rosa Media Player
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ROSA_MEDIA_PLAYER\" 'AUR-INSTALL-ROSA-MEDIA-PLAYER'" "AUR-INSTALL-ROSA-MEDIA-PLAYER" ; then
                        add_aur_package "$AUR_INSTALL_ROSA_MEDIA_PLAYER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-PLAYERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                7)  # smplayer
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_SMPLAYER\" 'INSTALL-SMPLAYER'" "INSTALL-SMPLAYER" ; then
                        add_package "$INSTALL_SMPLAYER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-PLAYERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                8)  # VLC
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_VLC\" 'INSTALL-VLC'" "INSTALL-VLC" ; then
                        add_package "$INSTALL_VLC"
                    fi
                    if [[ "QT_INSTALL" -eq 1 ]]; then
                        if add_packagemanager "package_install \"$INSTALL_VLC_KDE\" 'INSTALL-VLC-KDE'" "INSTALL-VLC-KDE" ; then
                            add_package "$INSTALL_VLC_KDE"
                        fi
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-PLAYERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                9)  # XBMC
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_XBNC\" 'INSTALL-XBNC'" "INSTALL-XBNC" ; then
                        add_package "$INSTALL_XBNC"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-PLAYERS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL VIDEO EDITORS TOOLS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_video_editors_tools_menu"
    USAGE="install_video_editors_tools_menu"
    DESCRIPTION=$(localize "INSTALL-VIDEO-EDITORS-TOOLS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-DESC"  "Install Video Editors Tools"
    #
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-TITLE" "Video Editors and Tools"
    #
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-MENU-1"   "Arista-transcoder"
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-MENU-I-1"        "Arista-transcoder: Easy to use multimedia transcoder for the GNOME Desktop"
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-MENU-2"   "Transmageddon"
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-MENU-I-2"        "Transmageddon: Simple python application for transcoding video into formats supported by GStreamer"
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-MENU-3"   "KDEenlive"
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-MENU-I-3"        "KDEenlive: A non-linear video editor for Linux"
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-MENU-4"   "Openshot"
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-MENU-I-4"        "Openshot: An Open-Source, non-linear video editor for Linux based on MLT framework"
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-MENU-5"   "Pitivi"
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-MENU-I-5"        "Pitivi: Editor for audio/video projects using the GStreamer framework"
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-MENU-6"   "Kazam"
    localize_info "INSTALL-VIDEO-EDITORS-TOOLS-MENU-I-6"        "Kazam-bzr: A screencasting program with design in mind. Unstable branch."
fi
# -------------------------------------
install_video_editors_tools_menu()
{
    local -r menu_name="INSTALL-VIDEO-EDITORS-TOOLS"  # You must define Menu Name here
    local BreakableKey="B"                            # Q=Quit, D=Done, B=Back
    local RecommendedOptions="4"                      # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions 3"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    #
    RecommendedOptions="$RecommendedOptions $BreakableKey"
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-VIDEO-EDITORS-TOOLS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-EDITORS-TOOLS-MENU-1" "" "$AUR" "INSTALL-VIDEO-EDITORS-TOOLS-MENU-I-1" "MenuTheme[@]" # 1 Arista-transcoder
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-EDITORS-TOOLS-MENU-2" "" ""     "INSTALL-VIDEO-EDITORS-TOOLS-MENU-I-2" "MenuTheme[@]" # 2 Transmageddon
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-EDITORS-TOOLS-MENU-3" "" ""     "INSTALL-VIDEO-EDITORS-TOOLS-MENU-I-3" "MenuTheme[@]" # 3 KDEenlive
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-EDITORS-TOOLS-MENU-4" "" ""     "INSTALL-VIDEO-EDITORS-TOOLS-MENU-I-4" "MenuTheme[@]" # 4 Openshot
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-EDITORS-TOOLS-MENU-5" "" ""     "INSTALL-VIDEO-EDITORS-TOOLS-MENU-I-5" "MenuTheme[@]" # 5 Pitivi
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-EDITORS-TOOLS-MENU-6" "" "$AUR" "INSTALL-VIDEO-EDITORS-TOOLS-MENU-I-6" "MenuTheme[@]" # 6 Kazam-bzr
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Arista-transcoder
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_ARISTA_TRANSCODER\" 'AUR-INSTALL-ARISTA-TRANSCODER'" "AUR-INSTALL-ARISTA-TRANSCODER" ; then
                        add_package "$AUR_INSTALL_ARISTA_TRANSCODER"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-EDITORS-TOOLS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                2)  # Transmageddon
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_TRAMSMAGEDDON\" 'INSTALL-TRAMSMAGEDDON'" "INSTALL-TRAMSMAGEDDON" ; then
                        add_package "$INSTALL_TRAMSMAGEDDON"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-EDITORS-TOOLS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                3)  # KDEenlive
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_KDENLIVE\" 'INSTALL-KDENLIVE'" "INSTALL-KDENLIVE" ; then
                        add_package "$INSTALL_KDENLIVE"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-EDITORS-TOOLS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                4)  # Openshot
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_OPENSHOT\" 'INSTALL-OPENSHOT'" "INSTALL-OPENSHOT" ; then
                        add_package "$INSTALL_OPENSHOT"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-EDITORS-TOOLS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                5)  # Pitivi
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "package_install \"$INSTALL_PITIVI\" 'INSTALL-PITIVI'" "INSTALL-PITIVI" ; then
                        add_package "$INSTALL_PITIVI"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-EDITORS-TOOLS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                6)  # Kazam-bzr
                    MenuChecks[$((SS_OPT - 1))]=1
                    if add_packagemanager "aur_package_install \"$AUR_INSTALL_KAZAM_BZR\" 'AUR-INSTALL-KAZAM-BZR'" "AUR-INSTALL-KAZAM-BZR" ; then
                        add_aur_package "$AUR_INSTALL_KAZAM_BZR"
                    fi
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-EDITORS-TOOLS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL SCIENCE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_science"
    USAGE="install_science"
    DESCRIPTION=$(localize "INSTALL-SCIENCE-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-SCIENCE-DESC"   "Install Science and Education"
fi
# -------------------------------------
install_science()
{
    print_title "INSTALL-SCIENCE-DESC"
    echo ''
    print_info "Full List: $INSTALL_SCIENCE_EDUCATION" 
    if add_packagemanager "package_install \"$INSTALL_SCIENCE_EDUCATION\" 'INSTALL-SCIENCE'" "INSTALL-SCIENCE" ; then
        add_package "$INSTALL_SCIENCE_EDUCATION"
    fi
    if add_packagemanager "package_install \"$INSTALL_GIMP\"  'INSTALL-GIMP'" "INSTALL-GIMP" ; then
       add_package "$INSTALL_GIMP"
    fi
    if add_packagemanager "aur_package_install \"$AUR_INSTALL_GIMP_PLUGINS\" 'AUR-INSTALL-GIMP-PLUGINS'" "AUR-INSTALL-GIMP-PLUGINS" ; then
       add_aur_package "$AUR_INSTALL_GIMP_PLUGINS"
    fi
    if add_packagemanager "aur_package_install \"$AUR_SCIENCE\" 'AUR-INSTALL-GIMP-PLUGINS-SCIENCE'" "AUR-INSTALL-GIMP-PLUGINS-SCIENCE" ; then
       add_aur_package "$AUR_SCIENCE"
    fi
    if [[ "$QT_INSTALL" -eq 1 ]]; then
        if add_packagemanager "package_install \"$INSTALL_SCIENCE_KDE\"  'INSTALL-SCIENCE-KDE'" "INSTALL-SCIENCE-KDE" ; then
           add_package "$INSTALL_SCIENCE_KDE"
        fi
    fi
    #    
    if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL VIDEO CARD NOW {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_video_card_now"
    USAGE="install_video_card_now"
    DESCRIPTION=$(localize "INSTALL-VIDEO-CARD-NOW-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-VIDEO-CARD-NOW-DESC"   "Install Video Card"
    localize_info "INSTALL-VIDEO-CARD-NOW-WARN"   "No Video Card installed"
fi
# -------------------------------------
install_video_card_now()
{
    print_title "INSTALL-VIDEO-CARD-NOW-DESC"
    echo ''
    #
    if [[ "$VIDEO_CARD" -eq 1 ]]; then    # NVIDIA
        #refresh_pacman
        #TEMP=$(pacman -Qe | grep xf86-video | awk '{print $1}')
        #if [[ -n "$TEMP" ]]; then
        #    add_packagemanager "package_remove \"$TEMP\"" "REMOVE-NVIDIA-XF86-VIDEO" # 
        #fi
        #
        add_packagemanager "TEMP=\$(pacman -Qe | grep xf86-video | awk '{print \$1}'); if [[ -n \"\$TEMP\" ]]; then package_remove \"\$TEMP\" \"REMOVE-NVIDIA-XF86-VIDEO-LIVE\"; fi" "REMOVE-NVIDIA-XF86-VIDEO"
        #
        add_packagemanager "package_remove 'libgl'" "REMOVE-NVIDIA"
        if add_packagemanager "package_install \"$INSTALL_NVIDIA\" 'INSTALL-NVIDIA'" "INSTALL-NVIDIA" ; then
            add_package "$INSTALL_NVIDIA"
            add_packagemanager "nvidia-xconfig" "RUN-NVIDIA-XCONFIG"
        fi
    elif [[ "$VIDEO_CARD" -eq 2 ]]; then    # Nouveau
        if add_packagemanager "package_install \"$INSTALL_NOUVEAU\" 'INSTALL-NOUVEAU'" "INSTALL-NOUVEAU" ; then
            add_package "$INSTALL_NOUVEAU"
            add_module "nouveau" "MODULE-NOUVEAU"
        fi
    elif [[ "$VIDEO_CARD" -eq 3 ]]; then    # Intel
        if add_packagemanager "package_install \"$INSTALL_INTEL\" 'INSTALL-INTEL'" "INSTALL-INTEL" ; then
            add_package "$INSTALL_INTEL"
        fi
    elif [[ "$VIDEO_CARD" -eq 4 ]]; then    # ATI
        if add_packagemanager "package_install \"$INSTALL_ATI\" 'INSTALL-ATI'" "INSTALL-ATI" ; then
            add_package "$INSTALL_ATI"
            add_module "radeon" "MODULE-RADEON"
        fi
    elif [[ "$VIDEO_CARD" -eq 5 ]]; then    # Vesa
        if add_packagemanager "package_install \"$INSTALL_VESA\" 'INSTALL-VESA'" "INSTALL-VESA" ; then
            add_package "$INSTALL_VESA"
        fi
    elif [[ "$VIDEO_CARD" -eq 6 ]]; then    # Virtualbox
        if add_packagemanager "package_install \"$INSTALL_VIRTUALBOX\" 'INSTALL-VIRTUALBOX'" "INSTALL-VIRTUALBOX" ; then
            add_package "$INSTALL_VIRTUALBOX"
            add_module "vboxguest" "MODULE-VIRUALBOX-GUEST"
            add_module "vboxsf"    "MODULE-VITRUALBOX-SF"
            add_module "vboxvideo" "MODULE-VIRTUALBOX-VIDEO"
            add_user_group "vboxsf"
        fi
    else
        write_error "INSTALL-VIDEO-CARD-NOW-WARN" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    fi
    #
    if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL VIDEO CARDS MENU {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_video_cards_menu"
    USAGE=$(localize "INSTALL-VIDEO-CARDS-USAGE")
    DESCRIPTION=$(localize "INSTALL-VIDEO-CARDS-DESC")
    NOTES=$(localize "INSTALL-VIDEO-CARDS-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-VIDEO-CARDS-USAGE" "install_video_cards_menu 1->(1=Install, 2=Remove)"
    localize_info "INSTALL-VIDEO-CARDS-DESC"  "Install Video Card"
    localize_info "INSTALL-VIDEO-CARDS-NOTES" "None."
    #
    localize_info "INSTALL-VIDEO-CARDS-TITLE"  "Video Cards"
    # nVidia, Nouveau, Intel, ATI, Vesa, Virtualbox
    localize_info "INSTALL-VIDEO-CARDS-MENU-1"   "nVidia"
    localize_info "INSTALL-VIDEO-CARDS-MENU-1-I"          "nVidia: https://wiki.archlinux.org/index.php/NVIDIA"
    localize_info "INSTALL-VIDEO-CARDS-MENU-2"   "Nouveau"
    localize_info "INSTALL-VIDEO-CARDS-MENU-2-I"          "Nouveau: https://wiki.archlinux.org/index.php/Nouveau"
    localize_info "INSTALL-VIDEO-CARDS-MENU-3"   "Intel"
    localize_info "INSTALL-VIDEO-CARDS-MENU-3-I"          "Intel: https://wiki.archlinux.org/index.php/Intel_Graphics"
    localize_info "INSTALL-VIDEO-CARDS-MENU-4"   "ATI"
    localize_info "INSTALL-VIDEO-CARDS-MENU-4-I"          "ATI: https://wiki.archlinux.org/index.php/ATI"
    localize_info "INSTALL-VIDEO-CARDS-MENU-5"   "Vesa"
    localize_info "INSTALL-VIDEO-CARDS-MENU-5-I"          "Vesa: https://wiki.archlinux.org/index.php/Xorg"
    localize_info "INSTALL-VIDEO-CARDS-MENU-6"   "Virtualbox"
    localize_info "INSTALL-VIDEO-CARDS-MENU-6-I"          "Virtualbox: Setup a Virtual Display Card: https://wiki.archlinux.org/index.php/VirtualBox"
    localize_info "INSTALL-VIDEO-CARDS-MENU-7"   "Skip"
    localize_info "INSTALL-VIDEO-CARDS-MENU-7-I"          "Skip: Do not install any Video Card."
fi
# -------------------------------------
install_video_cards_menu()
{
    local -r menu_name="INSTALL-VIDEO-CARDS"     # You must define Menu Name here
    local BreakableKey="Q"                       # Q=Quit, D=Done, B=Back
    detected_video_card                          # Detect Video Card
    local RecommendedOptions="$VIDEO_CARD"       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    #
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        RecommendedOptions="$RecommendedOptions"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        RecommendedOptions="$RecommendedOptions"    
    fi
    # @FIX do a snoop and auto fill a recommendation
    # 
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}" "${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-RECOMMENDED"
    StatusBar2=": $RecommendedOptions"
    #
    while [[ 1 ]]; do
        #
        print_title "INSTALL-VIDEO-CARDS-TITLE" " - https://wiki.archlinux.org/index.php/HCL/Video_Cards"
        print_caution "${StatusBar1}" "${StatusBar2}"
        #
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        # "nVidia" "Nouveau" "Intel" "ATI" "Vesa" "Virtualbox" "Skip"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-1" "" "" "INSTALL-VIDEO-CARDS-MENU-1-I" "MenuTheme[@]" # 1 nVidia
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-2" "" "" "INSTALL-VIDEO-CARDS-MENU-2-I" "MenuTheme[@]" # 2 Nouveau
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-3" "" "" "INSTALL-VIDEO-CARDS-MENU-3-I" "MenuTheme[@]" # 3 Intel
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-4" "" "" "INSTALL-VIDEO-CARDS-MENU-4-I" "MenuTheme[@]" # 4 ATI
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-5" "" "" "INSTALL-VIDEO-CARDS-MENU-5-I" "MenuTheme[@]" # 5 Vesa
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-6" "" "" "INSTALL-VIDEO-CARDS-MENU-6-I" "MenuTheme[@]" # 6 Virtualbox
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-7" "" "" "INSTALL-VIDEO-CARDS-MENU-7-I" "MenuTheme[@]" # 7 Skip
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
        read_input_options "$RecommendedOptions" "$BreakableKey"
        RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
        BYPASS="$Old_BYPASS" # Restore Bypass
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # nVidia
                    #if [[ "$1" -eq 1 ]]; then
                        MenuChecks[$((SS_OPT - 1))]=1
                        VIDEO_CARD=1 # 1 NVIDIA
                        SS_OPT="$BreakableKey"
                    #else
                    #    MenuChecks[$((SS_OPT - 1))]=2
                    #    VIDEO_CARD=7 # Set to skip; you must select video card next
                    #    remove_package "$INSTALL_NVIDIA"
                    #    remove_packagemanager "REMOVE-NVIDIA"
                    #    remove_packagemanager "INSTALL-NVIDIA"
                    #    remove_packagemanager "RUN-NVIDIA-XCONFIG"
                    #fi
                    SS_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-CARDS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                2)  # Nouveau
                    #if [[ "$1" -eq 1 ]]; then
                        MenuChecks[$((SS_OPT - 1))]=1
                        VIDEO_CARD=2 # 2 NOUVEAU
                        SS_OPT="$BreakableKey"
                    #else
                    #    MenuChecks[$((SS_OPT - 1))]=2
                    #    VIDEO_CARD=7 # Set to skip; you must select video card next
                    #    remove_module "MODULE-NOUVEAU"
                    #    remove_package "$INSTALL_NOUVEAU"
                    #    remove_packagemanager "INSTALL-NOUVEAU"
                    #fi
                    SS_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-CARDS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                3)  # Intel
                    #if [[ "$1" -eq 1 ]]; then
                        MenuChecks[$((SS_OPT - 1))]=1
                        VIDEO_CARD=3 # 3 INTEL
                        SS_OPT="$BreakableKey"
                    #else
                    #    MenuChecks[$((SS_OPT - 1))]=2
                    #    VIDEO_CARD=7 # Set to skip; you must select video card next
                    #    remove_package "$INSTALL_INTEL"
                    #    remove_packagemanager "INSTALL-INTEL"
                    #fi
                    SS_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-CARDS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                4)  # ATI
                    #if [[ "$1" -eq 1 ]]; then
                        MenuChecks[$((SS_OPT - 1))]=1
                        VIDEO_CARD=4 # 4 ATI
                        SS_OPT="$BreakableKey"
                    #else
                    #    MenuChecks[$((SS_OPT - 1))]=2
                    #    VIDEO_CARD=7 # Set to skip; you must select video card next
                    #    remove_module "MODULE-RADEON"
                    #    remove_package "$INSTALL_ATI"
                    #    remove_packagemanager "INSTALL-ATI"
                    #fi
                    SS_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-CARDS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                5)  # Vesa
                    #if [[ "$1" -eq 1 ]]; then
                        MenuChecks[$((SS_OPT - 1))]=1
                        VIDEO_CARD=5 # 5 VESA
                        SS_OPT="$BreakableKey"
                    #else
                    #    MenuChecks[$((SS_OPT - 1))]=2
                    #    VIDEO_CARD=7 # Set to skip; you must select video card next
                    #    remove_package "$INSTALL_VESA"
                    #    remove_packagemanager "INSTALL-VESA"
                    #fi
                    SS_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-CARDS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                6)  # VIRTUALBOX
                    #if [[ "$1" -eq 1 ]]; then
                        MenuChecks[$((SS_OPT - 1))]=1
                        VIDEO_CARD=6 # 6 VIRTUALBOX
                        SS_OPT="$BreakableKey"
                    #else
                    #    MenuChecks[$((SS_OPT - 1))]=2
                    #    VIDEO_CARD=7 # Set to skip; you must select video card next
                    #    remove_user_group "vboxsf"
                    #    remove_module "MODULE-VIRUALBOX-GUEST"
                    #    remove_module "MODULE-VITRUALBOX-SF"
                    #    remove_module "MODULE-VIRTUALBOX-VIDEO"
                    #    remove_package "$INSTALL_VIRTUALBOX"
                    #    remove_packagemanager "INSTALL-VIRTUALBOX"
                    #fi
                    SS_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-CARDS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                7)  # SKIP
                    MenuChecks[$((SS_OPT - 1))]=1
                    VIDEO_CARD=7 # 7 SKIP, No Video Card Installed
                    SS_OPT="$BreakableKey"
                    # Progress Status
                    StatusBar1="INSTALL-VIDEO-CARDS-MENU-$((S_OPT - 1))"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    print_this "$StatusBar1 $StatusBar2"
                    break
                    ;;
                *)  # Catch ALL
                    if [[ "$SS_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                            return 0
                        else
                            return 1
                        fi
                    else
                        invalid_option "$SS_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$SS_OPT" "$BreakableKey"
    done
}
#}}}
# -----------------------------------------------------------------------------
# TEST INSTALLATION {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="test_installation"
    USAGE="test_installation"
    DESCRIPTION=$(localize "TEST-INSTALLATION-DESC")
    NOTES=$(localize "TEST-INSTALLATION-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "TEST-INSTALLATION-DESC"           "Test Install"
    localize_info "TEST-INSTALLATION-NOTES"          "None."
    #
    localize_info "TEST-INSTALLATION-INFO"           "Test Install"
    localize_info "TEST-INSTALLATION-CORE"           "Testing Core Packages."
    localize_info "TEST-INSTALLATION-AUR"            "Testing AUR Packages."
    localize_info "TEST-INSTALLATION-CORE-INSTALLED" "Core Package Installed"
    localize_info "TEST-INSTALLATION-AUR-INSTALLED"  "AUR Package Installed"
    localize_info "TEST-INSTALLATION-CORE-WARN"      "pacman Did Not find Core Package:"
    localize_info "TEST-INSTALLATION-AUR-WARN"       "pacman Did Not find AUR Package:"
    localize_info "TEST-INSTALLATION-LOG"            "pacman Install Error Log."
fi
# -------------------------------------
test_installation()
{
    # @FIX how to test now?
    print_title "TEST-INSTALLATION-DESC"
    print_info "TEST-INSTALLATION-INFO"    
    #
    make_dir "$LOG_PATH/ssp/"    "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    echo "# $(localize "TEST-INSTALLATION-LOG"): $SCRIPT_NAME Version: $SCRIPT_VERSION on $DATE_TIME." > "${LOG_PATH}/ssp/0-failures.txt" # Truncate file
    echo "# *** Core ***" >> "${LOG_PATH}/ssp/0-failures.txt"
    print_info "TEST-INSTALLATION-CORE"    
    local -i total="${#PACKAGES[@]}"
    for (( i=0; i<${total}; i++ )); do
        if check_package "${PACKAGES[$i]}" ; then
            print_info "TEST-INSTALLATION-CORE-INSTALLED" ": ${PACKAGES[$i]}"
        else
            print_error "TEST-INSTALLATION-CORE-WARN" ": ${PACKAGES[$i]}"
            echo "${PACKAGES[$i]}" >> "${LOG_PATH}/ssp/0-failures.txt"
        fi
    done
    print_info "TEST-INSTALLATION-AUR"    
    echo "# *** AUR ***" >> "${LOG_PATH}/ssp/0-failures.txt"
    local -i total="${#AUR_PACKAGES[@]}"
    for (( i=0; i<${total}; i++ )); do
        if check_package "${AUR_PACKAGES[$i]}" ; then
            print_info "TEST-INSTALLATION-AUR-INSTALLED" ": ${AUR_PACKAGES[$i]}"
        else
            print_error "TEST-INSTALLATION-AUR-WARN" ": ${AUR_PACKAGES[$i]}"
            echo "${AUR_PACKAGES[$i]}" >> "${LOG_PATH}/ssp/0-failures.txt"
        fi
    done
    if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# REINSTALLATION {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="reinstallation"
    USAGE="reinstallation"
    DESCRIPTION=$(localize "REINSTALLATION-DESC")
    NOTES=$(localize "REINSTALLATION-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "REINSTALLATION-DESC"           "Re-Install all Packages"
    localize_info "REINSTALLATION-NOTES"          "None."
    #
    localize_info "REINSTALLATION-INFO"           "Reinstall"
    localize_info "REINSTALLATION-CORE"           "Retry Core Packages."
    localize_info "REINSTALLATION-AUR"            "Retry AUR Packages."
    localize_info "REINSTALLATION-CORE-INSTALLED" "Core Package Installed"
    localize_info "REINSTALLATION-AUR-INSTALLED"  "AUR Package Installed"
    localize_info "REINSTALLATION-CORE-WARN"      "pacman Did Not find Core Package:"
    localize_info "REINSTALLATION-AUR-WARN"       "pacman Did Not find AUR Package:"
fi
# -------------------------------------
reinstallation()
{
    # @FIX how to test now?
    print_title "REINSTALLATION-DESC"
    print_info "REINSTALLATION-INFO"    
    #
    print_info "REINSTALLATION-CORE"    
    local -i total="${#PACKAGES[@]}"
    for (( i=0; i<${total}; i++ )); do
        if check_package "${PACKAGES[$i]}" ; then
            print_info "REINSTALLATION-CORE-INSTALLED" ": ${PACKAGES[$i]}"
        else
            print_error "REINSTALLATION-CORE-WARN" ": ${PACKAGES[$i]}"
            install_package "${PACKAGES[$i]}" "REINSTALLATION-CORE-PACKAGE-$i"
        fi
    done
    print_info "REINSTALLATION-AUR"    
    local -i total="${#AUR_PACKAGES[@]}"
    for (( i=0; i<${total}; i++ )); do
        if check_package "${AUR_PACKAGES[$i]}" ; then
            print_info "REINSTALLATION-AUR-INSTALLED" ": ${AUR_PACKAGES[$i]}"
        else
            print_error "REINSTALLATION-AUR-WARN" ": ${AUR_PACKAGES[$i]}"
            aur_package_install "${AUR_PACKAGES[$i]}" "REINSTALLATION-AUR-PACKAGE-$i"
        fi
    done
    if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
}
#}}}
# *******************************************************************************************************************************
# INSTALL SOFTWARE LIVE }}}
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_software_live"
    USAGE="install_software_live"
    DESCRIPTION=$(localize "Install Software on Live OS")
    NOTES=$(localize "INSTALL-SOFTWARE-LIVE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-SOFTWARE-LIVE-DESC"  "Test functions out for Developers"
    localize_info "INSTALL-SOFTWARE-LIVE-NOTES" "Calls finish 2, so exit 0 after calling this. All the Custom scripts should be writen to Package Manager, so after testing, move them there, only allow custom scripts in testing mode only."
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
    localize_info "INSTALL-SOFTWARE-FAIL-1"       "Failed to Execute"
    localize_info "INSTALL-SOFTWARE-PASSED"       "Executed Successfully"
fi
# -------------------------------------
install_software_live()
{
    verify_config 2
    if [[ "$MOUNTPOINT" == "/mnt" ]]; then
        print_error "INSTALL-SOFTWARE-WARN"
        exit 1
    fi
    if [[ "$IS_LAST_CONFIG_LOADED" -eq 0 ]]; then
        print_error "INSTALL-SOFTWARE-WARN-2"
        exit 1
    fi
    print_title "INSTALL-SOFTWARE-LIVE-TITLE" ' - https://wiki.archlinux.org/index.php/Beginners%27_Guide#Boot_Arch_Linux_Installation_Media'
    print_info "INSTALL-SOFTWARE-LIVE-INFO-1"
    configure_pacman_package_signing
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "configure_pacman_package_signing : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    print_info "INSTALL-SOFTWARE-LIVE-INFO-2"
    system_upgrade
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "system_upgrade : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
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
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "CONFIG_HOSTNAME : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    #
    # Install PACKMANAGER
    if [[ "${#PACKMANAGER}" -ne 0 ]]; then
        print_info "Install PACKAGEMANAGER..."
        total="${#PACKMANAGER[@]}"
        for (( index=0; index<${total}; index++ )); do
            # @FIX test return logic; 0 = success; 
            eval "${PACKMANAGER[$index]}"
            if [ "$?" -eq 0 ]; then
                write_log   "INSTALL-SOFTWARE-PASSED" "${PACKMANAGER_NAME[$index]} : ${PACKMANAGER[$index]} -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            else
                write_error "INSTALL-SOFTWARE-FAIL-1" ": ${PACKMANAGER_NAME[$index]} : ${PACKMANAGER[$index]} -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                print_error "INSTALL-SOFTWARE-FAIL-1" ": ${PACKMANAGER_NAME[$index]} : ${PACKMANAGER[$index]} -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                if [[ "$DEBUGGING" -eq 1 || "$DEBUGGING" -eq 2 ]]; then pause_function "eval PACKMANAGER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO (line by line errors)"; fi
            fi
        done
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "eval PACKMANAGER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    #
    # FLESH
    if [[ "$FLESH" -eq 1 ]]; then
        configure_user_account
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "configure_user_account : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
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
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "CONFIG_TOR : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
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
        make_dir "/home/${USERNAME}/.kde4/share/apps/color-schemes" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        mv Sweet/Sweet.colors "/home/${USERNAME}/.kde4/share/apps/color-schemes"
        mv Kawai/Kawai.colors "/home/${USERNAME}/.kde4/share/apps/color-schemes"
        make_dir "/home/${USERNAME}/.kde4/share/apps/QtCurve" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        mv Sweet/Sweet.qtcurve "/home/${USERNAME}/.kde4/share/apps/QtCurve"
        mv Kawai/Kawai.qtcurve "/home/${USERNAME}/.kde4/share/apps/QtCurve"
        chown -R "${USERNAME}:${USERNAME}" "/home/${USERNAME}/.kde4"
        rm -fr Kawai Sweet
        #
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "CONFIG_KDE : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    # SSH
    if [[ "$CONFIG_SSH" -eq 1 ]]; then
        print_info "INSTALL-SOFTWARE-LIVE-INFO-9"
        [[ ! -f /etc/ssh/sshd_config.aui ]] && copy_file "/etc/ssh/sshd_config" "/etc/ssh/sshd_config.aui" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO";
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
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "CONFIG_SSH : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    #
    # Configure XORG
    if [[ "$CONFIG_XORG" -eq 1 ]]; then
        print_info "INSTALL-SOFTWARE-LIVE-INFO-10"
        if [[ "$LANGUAGE" == "de_DE" || "$LANGUAGE" == "es_ES" || "$LANGUAGE" == "es_CL" || "$LANGUAGE" == "it_IT" || "$LANGUAGE" == "fr_FR" || "$LANGUAGE" == "pt_BR" || "$LANGUAGE" == "pt_PT" ]]; then
            cd ..
            [[ ! -f /etc/X11/xorg.conf.d/10-evdev.conf.aui ]] && copy_file "/etc/X11/xorg.conf.d/10-evdev.conf" "/etc/X11/xorg.conf.d/10-evdev.conf.aui" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO";
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
        cd "$FULL_SCRIPT_PATH"
        #
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "CONFIG_XORG : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    # @FIX
    if [[ "$WEBSERVER" -eq 1 ]]; then    
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
            copy_file '/etc/httpd/conf/httpd.conf' '/etc/httpd/conf/httpd.conf.aui' "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
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
    # @FIX
    if [[ "$WEBSERVER" -eq 2 ]]; then    
        #echo "Enter your new mysql root account password"
        #/usr/bin/mysqladmin -u root password
        /usr/bin/mysql_secure_installation
        # CONFIGURE HTTPD.CONF {{{
        if [ ! -f  /etc/httpd/conf/httpd.conf.aui ]; then
            copy_file '/etc/httpd/conf/httpd.conf' '/etc/httpd/conf/httpd.conf.aui' "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
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
    #   
    # Clean Orphan Packages
    if [[ "$CONFIG_ORPHAN" -eq 1 ]]; then
        print_info "INSTALL-SOFTWARE-LIVE-INFO-14"
        pacman -Rsc --noconfirm $(pacman -Qqdt)
        #pacman -Sc --noconfirm
        pacman-optimize
        #
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "CONFIG_ORPHAN : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    #
    if [[ "$REINSTALL" -eq 1 ]]; then
        reinstallation
    fi
    #
    if [[ "$TEST_INSTALL" -eq 1 ]]; then
        test_installation    
    fi
    #
    finish 2 # install_software_live
    exit 0
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL LOAD SOFTWARE }}}
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_loaded_software"
    USAGE="install_loaded_software"
    DESCRIPTION=$(localize "INSTALL-LOAD-SOFTWARE-DESC")
    NOTES=$(localize "INSTALL-LOAD-SOFTWARE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-LOAD-SOFTWARE-DESC"  "Install loaded Software"
    localize_info "INSTALL-LOAD-SOFTWARE-NOTES" "None."
    #
    localize_info "INSTALL-LOAD-SOFTWARE-TITLE-1" "Install Software from Configuration files, Assumes you are in Live Mode, meaning you booted into your Live OS, not an installation disk."
    localize_info "INSTALL-LOAD-SOFTWARE-INFO-1" "Install Software from Configuration files, Assumes you are in Live Mode, meaning you booted into your Live OS, not an installation disk."
    localize_info "INSTALL-LOAD-SOFTWARE-INFO-2" "This option Assumes that you have a bootable OS and and have gone through the Application Software Menu and Saved it, now we are going to load it and install it."
    localize_info "INSTALL-LOAD-SOFTWARE-INFO-3" "Normally you will use the user name (&#36;USERNAME) in the file, but its possible that you may wish to use another User Name to install this with, make sure User Name Exist in this OS before doing this."
    localize_info "INSTALL-LOAD-SOFTWARE-INFO-4" "You will have to abort (Ctrl-C) if you wish to change Software Installation Setting, pick New Software Configuration."
    localize_info "INSTALL-LOAD-SOFTWARE-INFO-5" "Load Last Install."
    #
    localize_info "INSTALL-LOAD-SOFTWARE-WARN-1" "Live mode only"
    localize_info "INSTALL-LOAD-SOFTWARE-WARN-2" "No Software Configuration files found!, run option to create Configuration files and Save Configuration."
fi
# -------------------------------------
install_loaded_software()
{
    print_title "INSTALL-LOAD-SOFTWARE-TITLE-1"
    print_info "$TEXT_SCRIPT_ID"
    #
    verify_config 2
    # Live mode only
    if [[ "$MOUNTPOINT" == "/mnt" ]]; then
        print_error "INSTALL-LOAD-SOFTWARE-WARN-1" "!"
        exit 1
    fi
    #
    if [[ "$IS_SOFTWARE_CONFIG_LOADED" -eq 0 ]]; then            
        print_error "INSTALL-LOAD-SOFTWARE-WARN-2"
        pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        exit 0
    fi
    print_info "$TEXT_SCRIPT_ID"
    print_info "INSTALL-LOAD-SOFTWARE-INFO-1"
    print_info "INSTALL-LOAD-SOFTWARE-INFO-2"
    print_info "INSTALL-LOAD-SOFTWARE-INFO-3"
    print_info "INSTALL-LOAD-SOFTWARE-INFO-4"
    #echo "Copying over all Configuration files to Live OS."
    #copy_dir "${FULL_SCRIPT_PATH}/etc/" "/" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    
    #print_info "Create Custom AUR Repository..."
    #create_custom_aur_repo # @FIX still can not get this to work
    
    print_info "INSTALL-LOAD-SOFTWARE-INFO-5"
    install_software_live; exit 0; # Calls finish 2, call exit 0
}
#{{{
# ****** END OF SCRIPT ******

