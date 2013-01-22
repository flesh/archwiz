#!/bin/bash
#
# LAST_UPDATE="21 Jan 2013 16:33"
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
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_menu"
    USAGE="install_menu"
    DESCRIPTION=$(localize "INSTALL-MENU-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-MENU-DESC"  "Install Menu"
    localize_info "INSTALL-MENU-NOTES" "NONE"
    #
    localize_info "INSTALL-MENU-TITLE" "Arch Wizard Main Menu"
    #
    localize_info "INSTALL-MENU-ITEM-SAVE" "Save Software Configuration for later use" 
    localize_info "INSTALL-MENU-ITEM-1"    "Wizard"
    localize_info "INSTALL-MENU-ITEM-2"    "Basic Setup"
    localize_info "INSTALL-MENU-ITEM-3"    "Desktop Environment"
    localize_info "INSTALL-MENU-ITEM-4"    "Display Manager"
    localize_info "INSTALL-MENU-ITEM-5"    "Accessories Apps"
    localize_info "INSTALL-MENU-ITEM-6"    "Development Apps"
    localize_info "INSTALL-MENU-ITEM-7"    "Office Apps"
    localize_info "INSTALL-MENU-ITEM-8"    "System Apps"
    localize_info "INSTALL-MENU-ITEM-9"    "Internet Apps"
    localize_info "INSTALL-MENU-ITEM-10"   "Graphics Apps"
    localize_info "INSTALL-MENU-ITEM-11"   "Audio Apps"
    localize_info "INSTALL-MENU-ITEM-12"   "Video Apps"
    localize_info "INSTALL-MENU-ITEM-13"   "Games"
    localize_info "INSTALL-MENU-ITEM-14"   "Science"
    localize_info "INSTALL-MENU-ITEM-15"   "Web server"
    localize_info "INSTALL-MENU-ITEM-16"   "Fonts"
    localize_info "INSTALL-MENU-ITEM-17"   "Extra"
    localize_info "INSTALL-MENU-ITEM-18"   "Kernel"
    localize_info "INSTALL-MENU-ITEM-19"   "Clean Orphan Packages"
    localize_info "INSTALL-MENU-ITEM-20"   "Edit Configuration"
    localize_info "INSTALL-MENU-ITEM-21"   "Load Custom Software"
    localize_info "INSTALL-MENU-ITEM-22"   "Load Software"
    localize_info "INSTALL-MENU-ITEM-23"   "Save Software"
    localize_info "INSTALL-MENU-ITEM-24"   "Quit"
    localize_info "INSTALL-MENU-ITEM-24-L" "Save and Install Software"
    #
    localize_info "INSTALL-MENU-INFO-1"    "Wizard: Install packages via a Wizard."
    localize_info "INSTALL-MENU-INFO-2"    "Basic Setup: Required: SYSTEMD, Video Card, DBUS, AVAHI, ACPI, ALSA, (UN)COMPRESS TOOLS, NFS, SAMBA, XORG, CUPS, SSH and more."
    localize_info "INSTALL-MENU-INFO-3"    "Desktop Environment: Mate, KDE, XFCE, Awesome, Cinnamon, E17, LXDE, OpenBox, GNOME and Unity."
    localize_info "INSTALL-MENU-INFO-4"    "Display Manager: GDM, Elsa, LightDM, LXDM and Slim."
    localize_info "INSTALL-MENU-INFO-5"    "Accessories Apps: cairo-dock-bzr, Conky, deepin-scrot, dockbarx, speedcrunch, galculator, gnome-pie, guake, kupfer, pyrenamer, shutter, synapse, terminator, zim, Revelation."
    localize_info "INSTALL-MENU-INFO-6"    "Development Apps: aptana-studio, bluefish, eclipse, emacs, gvim, geany, IntelliJ IDEA, kdevelop, Oracle Java, Qt and Creator, Sublime Text 2, Debugger Tools, MySQL Workbench, meld, RabbitVCS, Wt, astyle and putty."
    localize_info "INSTALL-MENU-INFO-7"    "Office Apps: Libre Office, Caligra or Abiword + Gnumeric, latex, calibre, gcstar, homebank, impressive, nitrotasks, ocrfeeder, xmind and zathura."
    localize_info "INSTALL-MENU-INFO-8"    "System Apps:"
    localize_info "INSTALL-MENU-INFO-9"    "Internet Apps:"
    localize_info "INSTALL-MENU-INFO-10"   "Graphics Apps:"
    localize_info "INSTALL-MENU-INFO-11"   "Audio Apps:"
    localize_info "INSTALL-MENU-INFO-12"   "Video Apps:"
    localize_info "INSTALL-MENU-INFO-13"   "Games:"
    localize_info "INSTALL-MENU-INFO-14"   "Science and Education: ${INSTALL_SCIENCE_EDUCATION}."
    localize_info "INSTALL-MENU-INFO-15"   "Web server:"
    localize_info "INSTALL-MENU-INFO-16"   "Fonts:"
    localize_info "INSTALL-MENU-INFO-17"   "Extra:"
    localize_info "INSTALL-MENU-INFO-18"   "Install optional Kernals: "
    localize_info "INSTALL-MENU-INFO-19"   "Clean Orphan Packages:"
    localize_info "INSTALL-MENU-INFO-20"   "Edit Configuration: Loads Saved Software."
    localize_info "INSTALL-MENU-INFO-21"   "Load Custom Software; Not yet written."
    localize_info "INSTALL-MENU-INFO-22"   "Allows you to review and edit configuration variables before installing software."
    localize_info "INSTALL-MENU-INFO-23"   "Save Software: Saves and Installs list and configurations creates with this menu."
    localize_info "INSTALL-MENU-INFO-24"   "Quit Menu: If in Boot mode will run pacstrap, if in software mode will install Software."
    localize_info "INSTALL-MENU-INFO-24-L" "Save and Install Software."
    localize_info "INSTALL-MENU-COMPLETED" "Completed"
    localize_info "INSTALL-MENU-INSTALLED" "Installed"
    localize_info "INSTALL-MENU-REMOVED"   "Removed"
    localize_info "INSTALL-MENU-REC"       "Recommended Options"
fi
# -------------------------------------
install_menu()
{
    local -r menu_name="Install-Menu"  # You must define Menu Name here
    local BreakableKey="Q"             # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-MENU-TITLE" " - https://github.com/flesh/archwiz"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
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
        if [[ "$MOUNTPOINT" == " " ]]; then
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-24-L" "" "" "INSTALL-MENU-INFO-24-L" "MenuTheme[@]"
        else
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MENU-ITEM-24"   "" "" "INSTALL-MENU-INFO-24"   "MenuTheme[@]"
        fi
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        BYPASS="$Old_BYPASS" # Restroe Bypass
        #
        local OPT
        for OPT in ${OPTIONS[@]}; do
            case "$OPT" in
                1)  # Wizard
                    run_install_wizzard
                    exit 0
                    StatusBar1="INSTALL-MENU-ITEM-1"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
                2)  # Basic Setup with Add and Remove
                    if [[ "${MenuChecks[$((OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((OPT - 1))]=1
                        install_basic 1
                        StatusBar1="INSTALL-MENU-ITEM-2"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    else
                        MenuChecks[$((OPT - 1))]=2
                        install_basic 2
                        StatusBar1="INSTALL-MENU-ITEM-2"
                        StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    fi
                    ;;
                3)  # Desktop Environment
                    MenuChecks[$((OPT - 1))]=1
                    install_desktop_environment_menu 
                    StatusBar1="INSTALL-MENU-ITEM-3"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
                4)  # Display Manager
                    MenuChecks[$((OPT - 1))]=1
                    install_display_manager_menu
                    StatusBar1="INSTALL-MENU-ITEM-4"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
                5)  # Accessories Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_accessories_apps_menu    
                    StatusBar1="INSTALL-MENU-ITEM-5"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
                6)  # Development Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_development_apps_menu    
                    StatusBar1="INSTALL-MENU-ITEM-6"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
                7)  # Office Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_office_apps_menu         
                    StatusBar1="INSTALL-MENU-ITEM-7"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
                8)  # System Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_system_apps_menu
                    StatusBar1="INSTALL-MENU-ITEM-8"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
                9)  # Internet Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_internet_apps_menu
                    StatusBar1="INSTALL-MENU-ITEM-10"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               10)  # Graphics Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_graphics_apps_menu
                    StatusBar1="INSTALL-MENU-ITEM-9"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               11)  # Audio Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_audio_apps_menu
                    StatusBar1="INSTALL-MENU-ITEM-11"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               12)  # Video Apps
                    MenuChecks[$((OPT - 1))]=1
                    install_video_apps_menu
                    StatusBar1="INSTALL-MENU-ITEM-12"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               13)  # Games
                    MenuChecks[$((OPT - 1))]=1
                    install_games_menu
                    StatusBar1="INSTALL-MENU-ITEM-13"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               14)  # Science
                    MenuChecks[$((OPT - 1))]=1
                    install_science
                    StatusBar1="INSTALL-MENU-ITEM-14"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               15)  # Web server
                    MenuChecks[$((OPT - 1))]=1
                    install_web_server_menu
                    StatusBar1="INSTALL-MENU-ITEM-15"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               16)  # Fonts
                    MenuChecks[$((OPT - 1))]=1
                    install_fonts_menu
                    StatusBar1="INSTALL-MENU-ITEM-16"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               17)  # Extra
                    MenuChecks[$((OPT - 1))]=1
                    install_extra_menu
                    StatusBar1="INSTALL-MENU-ITEM-17"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               18)  # Kernel
                    MenuChecks[$((OPT - 1))]=1
                    install_kernel_menu
                    StatusBar1="INSTALL-MENU-ITEM-18"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               19)  # Clean Orphan Packages
                    MenuChecks[$((OPT - 1))]=1
                    clean_orphan_packages
                    StatusBar1="INSTALL-MENU-ITEM-19"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               20)  # Edit Configuration
                    MenuChecks[$((OPT - 1))]=1
                    get_hostname
                    configure_timezone
                    get_user_name
                    add_custom_repositories
                    StatusBar1="INSTALL-MENU-ITEM-20"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               21)  # Load Custom Software
                    MenuChecks[$((OPT - 1))]=1
                    # load_custom_software
                    StatusBar1="INSTALL-MENU-ITEM-21"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               22)  # Load Software
                    MenuChecks[$((OPT - 1))]=1
                    load_software # @FIX
                    StatusBar1="INSTALL-MENU-ITEM-22"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
                    ;;
               23)  # Save Software
                    MenuChecks[$((OPT - 1))]=1
                    save_software
                    SAVED_SOFTWARE=1
                    StatusBar1="INSTALL-MENU-ITEM-23"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
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
                    StatusBar1="INSTALL-MENU-ITEM-24"
                    StatusBar2=$(localize "INSTALL-MENU-COMPLETED")
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
    BYPASS="$Old_BYPASS" # Restroe Bypass
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
    install_desktop_environment_menu
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
    localize_info "INSTALL-TYPE-MENU-0" "Normal"
    localize_info "INSTALL-TYPE-MENU-1" "Gamer"
    localize_info "INSTALL-TYPE-MENU-2" "Professional"
    localize_info "INSTALL-TYPE-MENU-3" "Programmer"
    # 0=Normal, 1=Gamer, 2=Professional and 3=Programmer
    localize_info "INSTALL-TYPE-MENU-INFO-0" "Normal: Minimal well rounded Applications."
    localize_info "INSTALL-TYPE-MENU-INFO-1" "Gamer: Normal plus a lot of games."
    localize_info "INSTALL-TYPE-MENU-INFO-2" "Professional: Normal plus Video and Audio Applications."
    localize_info "INSTALL-TYPE-MENU-INFO-3" "Programmer: Professional plus some important Programming Applications"
fi
# -------------------------------------
install_type_menu()
{
    local -r menu_name="INSTALL-TYPE"  # You must define Menu Name here
    local BreakableKey="D"             # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-TYPE-TITLE" 
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-0" "" "" "INSTALL-TYPE-MENU-INFO-0" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-1" "" "" "INSTALL-TYPE-MENU-INFO-1" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-2" "" "" "INSTALL-TYPE-MENU-INFO-2" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-3" "" "" "INSTALL-TYPE-MENU-INFO-3" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        BYPASS="$Old_BYPASS" # Restroe Bypass
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Normal
                    MenuChecks[$((S_OPT - 1))]=1
                    INSTALL_TYPE=0
                    S_OPT="$BreakableKey"
                    break;
                    ;;
                2)  # Gamer
                    MenuChecks[$((S_OPT - 1))]=1
                    INSTALL_TYPE=1
                    S_OPT="$BreakableKey"
                    break;
                    ;;
                3)  # Professional 
                    MenuChecks[$((S_OPT - 1))]=1
                    S_OPT="$BreakableKey"
                    INSTALL_TYPE=2
                    break;
                    ;;
                4)  # Programmer
                    MenuChecks[$((S_OPT - 1))]=1
                    INSTALL_TYPE=3
                    S_OPT="$BreakableKey"
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
    localize_info "INSTALL-CUSTOM-DE-MENU-I-1"      "Mate: "
    localize_info "INSTALL-CUSTOM-DE-MENU-2"   "KDE"
    localize_info "INSTALL-CUSTOM-DE-MENU-I-2"      "KDE: "
    localize_info "INSTALL-CUSTOM-DE-MENU-3"   "XFCE"
    localize_info "INSTALL-CUSTOM-DE-MENU-I-3"      "XFCE: "
    localize_info "INSTALL-CUSTOM-DE-MENU-4"   "Razor-QT & Openbox"
    localize_info "INSTALL-CUSTOM-DE-MENU-I-4"      "Razor-QT & Openbox: "
    localize_info "INSTALL-CUSTOM-DE-MENU-5"   "Cinnamon"
    localize_info "INSTALL-CUSTOM-DE-MENU-I-5"      "Cinnamon: "
    localize_info "INSTALL-CUSTOM-DE-MENU-6"   "Awesume"
    localize_info "INSTALL-CUSTOM-DE-MENU-I-6"      "Awesume: "
fi
# -------------------------------------
install_custom_de_menu()
{
    local -r menu_name="INSTALL-CUSTOM-DE"  # You must define Menu Name here
    local BreakableKey="D"                  # Q=Quit, D=Done, B=Back
    local RecommendedOptions="4"            # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
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
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        BYPASS="$Old_BYPASS" # Restroe Bypass
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Mate
                    MenuChecks[$((S_OPT - 1))]=1
                    CUSTOM_DE=1
                    S_OPT="$BreakableKey"
                    break;
                    ;;
                2)  # KDE
                    MenuChecks[$((S_OPT - 1))]=1
                    CUSTOM_DE=2
                    S_OPT="$BreakableKey"
                    break;
                    ;;
                3)  # XFCE 
                    MenuChecks[$((S_OPT - 1))]=1
                    S_OPT="$BreakableKey"
                    CUSTOM_DE=3
                    break;
                    ;;
                4)  # Razor-QT & Openbox
                    MenuChecks[$((S_OPT - 1))]=1
                    S_OPT="$BreakableKey"
                    CUSTOM_DE=4
                    break;
                    ;;
                5)  # Cinnamon 
                    MenuChecks[$((S_OPT - 1))]=1
                    S_OPT="$BreakableKey"
                    CUSTOM_DE=5
                    break;
                    ;;
                6)  # Awesume
                    MenuChecks[$((S_OPT - 1))]=1
                    CUSTOM_DE=6
                    S_OPT="$BreakableKey"
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
    localize_info "INSTALL-BASICS-MENU-I-2"      ""
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
    local RecommendedOptions="1 2 7 11"       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
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
    if [[ "$INSTALLED_VIDEO_CARD" -eq 0 ]]; then
        RecommendedOptions="$RecommendedOptions 12"
    fi
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    StatusBar1="INSTALL-BASICS-MENU-REC"
    StatusBar2="$RecommendedOptions"
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
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # NFS
                    if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_NFS=1
                        StatusBar1="INSTALL-BASICS-MENU-1"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    else
                        MenuChecks[$((S_OPT - 1))]=2
                        INSTALL_NFS=0
                        StatusBar1="INSTALL-BASICS-MENU-1"
                        StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    fi
                    ;;
                2)  # SAMBA
                    if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_SAMBA=1
                        StatusBar1="INSTALL-BASICS-MENU-2"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    else
                        MenuChecks[$((S_OPT - 1))]=2
                        INSTALL_SAMBA=0
                        StatusBar1="INSTALL-BASICS-MENU-2"
                        StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    fi
                    ;;
                3)  # Laptop Mode Tools
                    if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_LMT=1
                        StatusBar1="INSTALL-BASICS-MENU-3"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    else
                        MenuChecks[$((S_OPT - 1))]=2
                        INSTALL_LMT=0
                        StatusBar1="INSTALL-BASICS-MENU-3"
                        StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    fi
                    ;;
                4)  # Preload
                    if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_PRELOAD=1
                        StatusBar1="INSTALL-BASICS-MENU-4"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    else
                        MenuChecks[$((S_OPT - 1))]=2
                        INSTALL_PRELOAD=0
                        StatusBar1="INSTALL-BASICS-MENU-4"
                        StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    fi
                    ;;
                5)  # Zram
                    if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_ZRAM=1
                        StatusBar1="INSTALL-BASICS-MENU-5"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    else
                        MenuChecks[$((S_OPT - 1))]=2
                        INSTALL_ZRAM=0
                        StatusBar1="INSTALL-BASICS-MENU-5"
                        StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    fi
                    ;;
                6)  # Tor
                    if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_TOR=1
                        StatusBar1="INSTALL-BASICS-MENU-6"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    else
                        MenuChecks[$((S_OPT - 1))]=2
                        INSTALL_TOR=0
                        StatusBar1="INSTALL-BASICS-MENU-6"
                        StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    fi
                    ;;
                7)  # CUPS
                    if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_CUPS=1
                        StatusBar1="INSTALL-BASICS-MENU-7"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    else
                        MenuChecks[$((S_OPT - 1))]=2
                        INSTALL_CUPS=0
                        StatusBar1="INSTALL-BASICS-MENU-7"
                        StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    fi
                    ;;
                8)  # USB 3G MODEM
                    if [[ "${MenuChecks[$((S_OPT - 1))]}" -eq 0 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                        INSTALL_USB_MODEM=1
                        StatusBar1="INSTALL-BASICS-MENU-8"
                        StatusBar2=$(localize "INSTALL-MENU-INSTALLED")
                    else
                        MenuChecks[$((S_OPT - 1))]=2
                        INSTALL_USB_MODEM=0
                        StatusBar1="INSTALL-BASICS-MENU-8"
                        StatusBar2=$(localize "INSTALL-MENU-REMOVED")
                    fi
                    ;;
                9)  # Addition Firmwares
                    install_additional_firmwares_menu 1
                    if [[ "$INSTALL_FIRMWARE" -eq 1 ]]; then
                        MenuChecks[$((S_OPT - 1))]=1
                    else
                        MenuChecks[$((S_OPT - 1))]=2
                    fi
                    ;;
               10)  # Choose AUR Helper 
                    MenuChecks[$((S_OPT - 1))]=1
                    choose_aurhelper
                    ;;
               11)  # Network Managers
                    MenuChecks[$((S_OPT - 1))]=1                     
                    get_network_manager_menu
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
    localize_info "INSTALL-BASIC-SETUP-USAGE" "install_basic_setup 1->(1=Install, 2=Remove)"
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
    #
    localize_info "INSTALL-BASIC-SETUP-XORG-TITLE"   "XORG"
    localize_info "INSTALL-BASIC-SETUP-XORG-INFO-1"  "Xorg is the public, open-source implementation of the X window system version 11."
    localize_info "INSTALL-BASIC-SETUP-XORG-INFO-2"  "Installing X-Server (req. for Desktop Environment, GPU Drivers, Keyboardlayout,...)"
    localize_info "INSTALL-BASIC-SETUP-XORG-SELECT"  "Select keyboard layout:"
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
    add_package        "$INSTALL_SYSTEMD"
    add_packagemanager "package_install \"$INSTALL_SYSTEMD\" 'INSTALL-SYSTEMD'" "INSTALL-SYSTEMD"
    add_aur_package    "$AUR_INSTALL_SYSTEMD"
    add_packagemanager "aur_package_install \"$AUR_INSTALL_SYSTEMD\" 'AUR-INSTALL-SYSTEMD'" "AUR-INSTALL-SYSTEMD"
    add_packagemanager "systemctl enable cronie.service" "SYSTEMD-ENABLE-SYSTEMD"
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
    add_packagemanager "systemctl enable alsa-store.service alsa-restore.service" "SYSTEMD-ENABLE-ALSA" # @FIX does this need to be called?
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
    # https://wiki.archlinux.org/index.php/Systemd
    add_packagemanager "systemctl enable systemd-readahead-collect systemd-readahead-replay" "SYSTEMD-ENABLE-READAHEAD"
    #
    print_info "INSTALL-BASIC-SETUP-XORG-TITLE" " - https://wiki.archlinux.org/index.php/Xorg"
    print_this "INSTALL-BASIC-SETUP-XORG-INFO-1"
    print_this "INSTALL-BASIC-SETUP-XORG-INFO-2"
    add_package        "$INSTALL_XORG"
    add_packagemanager "package_install \"$INSTALL_XORG\" 'INSTALL-XORG'" "INSTALL-XORG"
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
        add_package "$INSTALL_USB_3G_MODEM"
        add_packagemanager "package_install \"$INSTALL_USB_3G_MODEM\" 'INSTALL-USB-3G-MODEM'" "INSTALL-USB-3G-MODEM"
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
        add_package "$INSTALL_GIT_TOR"
        add_packagemanager "package_install \"$INSTALL_GIT_TOR\" 'INSTALL-GIT-TOR'" "INSTALL-GIT-TOR"
        add_packagemanager "systemctl enable tor.service privoxy.service" "SYSTEMD-ENABLE-GIT-TOR"
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
        add_package "$INSTALL_NFS_PACKAGES"
        add_packagemanager "package_install \"$INSTALL_NFS_PACKAGES\" 'INSTALL-NFS'" "INSTALL-NFS"
        add_packagemanager "systemctl enable rpc-statd.service" "SYSTEMD-ENABLE-NFS"
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
        add_package "$INSTALL_SAMBA_PACKAGES"
        add_packagemanager "package_install \"$INSTALL_SAMBA_PACKAGES\" 'INSTALL-SAMBA'" "INSTALL-SAMBA"
        add_packagemanager "copy_file '/etc/samba/smb.conf.default' '/etc/samba/smb.conf' \"$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO\"" "COPY-CONFIG-SAMBA"
        add_packagemanager "systemctl enable smbd smbnetfs nmbd winbindd.service" "SYSTEMD-ENABLE-SAMBA"
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
        add_package "$INSTALL_PRELOAD_PACKAGES"
        add_packagemanager "package_install \"$INSTALL_PRELOAD_PACKAGES\" 'INSTALL-PRELOAD'" "INSTALL-PRELOAD"
        add_packagemanager "systemctl enable preload.service" "SYSTEMD-ENABLE-PRELOAD"
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
        add_aur_package "$AUR_INSTALL_ZRAM"
        add_packagemanager "aur_package_install \"$AUR_INSTALL_ZRAM\" 'AUR-INSTALL-ZRAM'" "AUR-INSTALL-ZRAM"
        add_packagemanager "systemctl enable zram.service" "SYSTEMD-ENABLE-ZRAM"
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
        add_package        "$INSTALL_LAPTOP_MODE_TOOLS"
        add_packagemanager "package_install \"$INSTALL_LAPTOP_MODE_TOOLS\" 'INSTALL-LAPTOP-MODE-TOOLS'" "INSTALL-LAPTOP-MODE-TOOLS"
        add_packagemanager "systemctl enable laptop-mode-tools.service" "SYSTEMD-ENABLE-LAPTOP-MODE-TOOLS"
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
    localize_info "INSTALL-CUPS-YN" "Install CUPS - AKA Common Unix Printing System" 
    localize_info "INSTALL-CUPS-TITLE" "CUPS - AKA Common Unix Printing System" 
    localize_info "INSTALL-CUPS-INFO" "CUPS is the standards-based, open source printing system developed by Apple Inc. for Mac OS® X and other UNIX®-like operating systems." 
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
        add_packagemanager "package_install \"$INSTALL_CUPS_PACK\" 'INSTALL-CUPS'" "INSTALL-CUPS"
        add_packagemanager "systemctl enable cups.service" "SYSTEMD-ENABLE-CUPS"
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
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-INFO-9"  "libffado: (Fireware Audio Devices)"
    localize_info "INSTALL-ADDITIONAL-FIRMWARE-INFO-10" "libraw1394: (IEEE1394 Driver)"
fi
# -------------------------------------
install_additional_firmwares_menu()
{
    # Install Software 
    local -r menu_name="INSTALL-ADDITIONAL-FIRMWARE"  # You must define Menu Name here
    local BreakableKey="D"                            # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""                       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    print_title "INSTALL-ADDITIONAL-FIRMWARE-TITLE"
    print_info  "INSTALL-ADDITIONAL-FIRMWARE-INFO"
    local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
    read_input_yn "INSTALL-ADDITIONAL-FIRMWARE-INSTALL" " " 0
    BYPASS="$Old_BYPASS" # Restroe Bypass
    if [[ "$YN_OPTION" -eq 1 ]]; then
        #
        StatusBar1="INSTALL-MENU-REC"
        StatusBar2="$RecommendedOptions"
        while [[ 1 ]]; do
            print_title "INSTALL-ADDITIONAL-FIRMWARE-TITLE"
            print_caution "${StatusBar1}" "${StatusBar2}"
            local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
            #
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "alsa-firmware"        "" ""     "" "MenuTheme[@]" # 1
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ipw2100-fw"           "" ""     "" "MenuTheme[@]" # 2
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ipw2200-fw"           "" ""     "" "MenuTheme[@]" # 3
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "b43-firmware"         "" "$AUR" "" "MenuTheme[@]" # 4
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "b43-firmware-legacy"  "" "$AUR" "" "MenuTheme[@]" # 5
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "broadcom-wl"          "" "$AUR" "" "MenuTheme[@]" # 6
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "zd1211-firmware"      "" ""     "" "MenuTheme[@]" # 7
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "bluez-firmware"       "" ""     "" "MenuTheme[@]" # 8
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "libffado"             "" ""     "INSTALL-ADDITIONAL-FIRMWARE-INFO-9"  "MenuTheme[@]" # 9
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "libraw1394"           "" ""     "INSTALL-ADDITIONAL-FIRMWARE-INFO-10" "MenuTheme[@]" # 10
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "sane-gt68xx-firmware" "" ""     "" "MenuTheme[@]" # 11
            #
            print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
            #
            local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
            read_input_options "$SUB_OPTIONS" "$BreakableKey"
            SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
            BYPASS="$Old_BYPASS" # Restroe Bypass
            #
            local S_OPT
            for S_OPT in ${OPTIONS[@]}; do
                case "$S_OPT" in
                    1)  # alsa-firmware
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            add_package "$INSTALL_ALSA_FIRMWARE"
                            add_packagemanager "package_install \"$INSTALL_ALSA_FIRMWARE\" 'INSTALL-ALSA-FIRMWARE'" "INSTALL-ALSA-FIRMWARE"
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$INSTALL_ALSA_FIRMWARE"
                            remove_packagemanager "INSTALL-ALSA_FIRMWARE"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        ;;
                    2)  # ipw2100-fw
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            add_package "$INSTALL_IPW2100_FW"
                            add_packagemanager "package_install \"$INSTALL_IPW2100_FW\" 'INSTALL-IPW2100-FW'" "INSTALL-IPW2100-FW"
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$INSTALL_IPW2100_FW"
                            remove_packagemanager "INSTALL-IPW2100-FW"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        ;;
                    3)  # ipw2200-fw 
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            add_package "$INSTALL_IPW2200_FW"
                            add_packagemanager "package_install \"$INSTALL_IPW2200_FW\" 'INSTALL-IPW2200-FW'" "INSTALL-IPW2200-FW"
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$INSTALL_IPW2200_FW"
                            remove_packagemanager "INSTALL-IPW2200-FW"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        ;;
                    4)  # b43-firmware
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            add_aur_package "$AUR_INSTALL_B43_FIRMWARE"
                            add_packagemanager "aur_package_install \"$AUR_INSTALL_B43_FIRMWARE\" 'AUR-INSTALL-B43-FIRMWARE'" "AUR-INSTALL-B43-FIRMWARE"
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$AUR_INSTALL_B43_FIRMWARE"
                            remove_packagemanager "AUR-INSTALL-B43-FIRMWARE"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        ;;
                    5)  # b43-firmware-legacy
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            add_aur_package "$AUR_INSTALL_B43_FIRMWARE_LEGACY"
                            add_packagemanager "aur_package_install \"$AUR_INSTALL_B43_FIRMWARE_LEGACY\" 'AUR-INSTALL-B43-FIRMWARE-LEGACY'" "AUR-INSTALL-B43-FIRMWARE-LEGACY"
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$AUR_INSTALL_B43_FIRMWARE_LEGACY"
                            remove_packagemanager "AUR-INSTALL-B43-FIRMWARE-LEGACY"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        ;;
                    6)  # broadcom-wl
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            add_aur_package "$AUR_INSTALL_BROADCOM_WL"
                            add_packagemanager "aur_package_install \"$AUR_INSTALL_BROADCOM_WL\" 'AUR-INSTALL-BROADCOM-WL'" "AUR-INSTALL-BROADCOM-WL"
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$AUR_INSTALL_BROADCOM_WL"
                            remove_packagemanager "AUR-INSTALL-BROADCOM-WL"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        ;;
                    7)  # zd1211-firmware
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            add_package "$INSTALL_ZD1211_FIRMWARE"
                            add_packagemanager "package_install \"$INSTALL_ZD1211_FIRMWARE\" 'INSTALL-ZD1211-FIRMWARE'" "INSTALL-ZD1211-FIRMWARE"
                        else
                            remove_package "$INSTALL_ZD1211_FIRMWARE"
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_packagemanager "INSTALL-ZD1211-FIRMWARE"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        ;;
                    8)  # bluez-firmware
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            add_package "$INSTALL_BLUEZ_FIREWARE"
                            add_packagemanager "package_install \"$INSTALL_BLUEZ_FIREWARE\" 'INSTALL-BLUEZ-FIREWARE'" "INSTALL-BLUEZ-FIREWARE"
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$INSTALL_BLUEZ_FIREWARE"
                            remove_packagemanager "INSTALL-BLUEZ-FIREWARE"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        ;;
                    9)  # libffado
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            add_package "$INSTALL_LIBFFADO"
                            add_packagemanager "package_install \"$INSTALL_LIBFFADO\" 'INSTALL-LIBFFADO'" "INSTALL-LIBFFADO"
                        else
                            remove_package "$INSTALL_LIBFFADO"
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_packagemanager "INSTALL-LIBFFADO"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        ;;
                   10)  # libraw1394
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            add_package "$INSTALL_LIBRAW1394"
                            add_packagemanager "package_install \"$INSTALL_LIBRAW1394\" 'INSTALL-LIBRAW1394'" "INSTALL-LIBRAW1394"
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$INSTALL_LIBRAW1394"
                            remove_packagemanager "INSTALL-LIBRAW1394"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
                        ;;
                   11)  # sane-gt68xx-firmware
                        if [[ "$1" -eq 1 ]]; then
                            MenuChecks[$((S_OPT - 1))]=1
                            add_package "$INSTALL_SANE_GT68XX_FIRMWARE"
                            add_packagemanager "package_install \"$INSTALL_SANE_GT68XX_FIRMWARE\" 'INSTALL-SANE-GT68XX-FIRMWARE'" "INSTALL-SANE-GT68XX-FIRMWARE"
                        else
                            MenuChecks[$((S_OPT - 1))]=2
                            remove_package "$INSTALL_SANE_GT68XX_FIRMWARE"
                            remove_packagemanager "INSTALL-SANE-GT68XX-FIRMWARE"
                            return 0
                        fi                    
                        INSTALL_FIRMWARE=1
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
    #
    localize_info "INSTALL-KERNEL-MENU-0"   "Liquorix"
    localize_info "INSTALL-KERNEL-MENU-I-0"     "Liquorix is a distro kernel replacement built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads, often used as a Debian Linux performance replacement kernel. damentz, the maintainer of the Liquorix patchset, is a developer for the Zen patchset as well, so many of the improvements there are found in this patchset. http://liquorix.net/"
    localize_info "INSTALL-KERNEL-MENU-1"   "LTS"
    localize_info "INSTALL-KERNEL-MENU-I-1"     "Long term support (LTS) Linux kernel and modules from the [core] repository."
    localize_info "INSTALL-KERNEL-MENU-2"   "ZEN"
    localize_info "INSTALL-KERNEL-MENU-I-2"     "The Zen Kernel is a the result of a collaborative effort of kernel hackers to provide the best Linux kernel possible for every day systems. https://github.com/damentz/zen-kernel?"
    localize_info "INSTALL-KERNEL-MENU-3"   ""
    localize_info "INSTALL-KERNEL-MENU-I-3"     ""
fi
# -------------------------------------
install_kernel_menu()
{
    local -r menu_name="INSTALL-KERNEL"  # You must define Menu Name here
    local BreakableKey="D"               # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""          # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "CONFIGURE-KERNEL-TITLE" " - https://wiki.archlinux.org/index.php/Kernels"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-0" "" "" "INSTALL-TYPE-MENU-I-0" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-1" "" "" "INSTALL-TYPE-MENU-I-1" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-2" "" "" "INSTALL-TYPE-MENU-I-2" "MenuTheme[@]"
        #add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-TYPE-MENU-3" "" "" "INSTALL-TYPE-MENU-I-3" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Liquorix
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package        "$INSTALL_LIQURIX"
                    add_packagemanager "package_install \"$INSTALL_LIQURIX\" 'INSTALL-LIQURIX'" "INSTALL-LIQURIX"
                    #
                    add_aur_package    "$AUR_INSTALL_LIQURIX"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_LIQURIX\" 'AUR-INSTALL-LIQURIX'" "AUR-INSTALL-LIQURIX"
                    if [[ "$VIDEO_CARD" -eq 1 ]]; then    # nVidia for Liqurix
                        add_aur_package    "$AUR_INSTALL_LIQURIX_NVIDIA"
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_LIQURIX_NVIDIA\" 'AUR-INSTALL-LIQURIX-NVIDIA'" "AUR-INSTALL-LIQURIX-NVIDIA"
                    fi
                    # @FIX too many other things to do
                    S_OPT="$BreakableKey"
                    break;
                    ;;
                2)  # linux-lts 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package        "$INSTALL_LTS"
                    add_packagemanager "package_install \"$INSTALL_LTS\" 'INSTALL-LTS'" "INSTALL-LTS"
                    S_OPT="$BreakableKey"
                    break;
                    ;;
                3)  # linux-zen 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package    "$AUR_INSTALL_ZEN"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ZEN\" 'AUR-INSTALL-ZEN'" "AUR-INSTALL-ZEN"
                    S_OPT="$BreakableKey"
                    break;
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    S_OPT="$BreakableKey"
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
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-9-I"      "Gnome Desktop Extras:"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-10"   "Window Managers"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-10-I"     "Window Managers: A Window Manager (WM) [Awesome, Openbox] is one component of a system's graphical user interface (GUI). Users may prefer to install a full-fledged Desktop Environment, which provides a complete user interface, including icons, windows, toolbars, wallpapers, and desktop widgets. https://wiki.archlinux.org/index.php/Window_Manager"
    #
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-REC"       "Recommended Options"
    #
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
fi
# -------------------------------------
install_desktop_environment_menu() 
{ 
    # 2
    local -r menu_name="DESKTOP-ENVIRONMENT"  # You must define Menu Name here
    local BreakableKey="D"                    # Q=Quit, D=Done, B=Back
    local RecommendedOptions="10"             # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
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
    elif [[ "$CUSTOM_DE" -eq 6 ]]; then       # Awesume
        RecommendedOptions="10"
    fi
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
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
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        BYPASS="$Old_BYPASS" # Restroe Bypass
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Mate
                    MenuChecks[$((S_OPT - 1))]=1
                    install_mate_now
                    ;;
                2)  # KDE
                    MenuChecks[$((S_OPT - 1))]=1
                    install_kde_menu
                    ;;
                3)  # XFCE
                    MenuChecks[$((S_OPT - 1))]=1
                    install_xfce_menu
                    ;;
                4)  # Razor-qt
                    MenuChecks[$((S_OPT - 1))]=1
                    install_razor_qt_menu
                    ;;
                5)  # Cinnamon
                    MenuChecks[$((S_OPT - 1))]=1
                    install_cinnamon_menu
                    ;;
                6)  # E17
                    MenuChecks[$((S_OPT - 1))]=1
                    install_e17_menu
                    ;;
                7)  # LXDE
                    MenuChecks[$((S_OPT - 1))]=1
                    install_lxde_menu
                    ;;
                8)  # GNOME
                    MenuChecks[$((S_OPT - 1))]=1
                    install_gnome_menu
                    ;;
                9)  # GNOME DE Extras
                    MenuChecks[$((S_OPT - 1))]=1
                    install_gnome_de_extras_menu
                    ;;
               10)  # Window Managers
                    MenuChecks[$((S_OPT - 1))]=1
                    install_window_manager_menu
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
    localize_info "INSTALL-WINDOW-MANAGER-TITLE"   "Desktop Environment"
    localize_info "INSTALL-WINDOW-MANAGER-INFO-1"  "A Desktop environments (DE) provide a complete graphical user interface (GUI) for a system by bundling together a variety of X clients written using a common widget toolkit and set of libraries."
    localize_info "INSTALL-WINDOW-MANAGER-INFO-2"  "Mate, KDE, XFCE, Awesome, Cinnamon, E17, LXDE, OpenBox, GNOME, and Unity"
    #
    localize_info "INSTALL-WINDOW-MANAGER-MENU-1"    "Awesome"
    localize_info "INSTALL-WINDOW-MANAGER-MENU-1-I"      "Awesome: awesome is a highly configurable, next generation framework window manager for X. It is very fast, extensible and licensed under the GNU GPLv2 license. Configured in Lua, it has a system tray, information bar, and launcher built in. There are extensions available to it written in Lua. Awesome uses XCB as opposed to Xlib, which may result in a speed increase. Awesome has other features as well, such as an early replacement for notification-daemon, a right-click menu similar to that of the *box window managers, and many other things."
    localize_info "INSTALL-WINDOW-MANAGER-MENU-2"    "OpenBox"
    localize_info "INSTALL-WINDOW-MANAGER-MENU-2-I"      "OpenBox"
    #
    localize_info "INSTALL-WINDOW-MANAGER-REC"       "Recommended Options"
    #
    # Fluxbox 
    # Enlightenment
    # Metacity
    # Compiz 
    # twm
    # Window Maker
    # 
    #
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
    elif [[ "$CUSTOM_DE" -eq 6 ]]; then       # Awesume
        RecommendedOptions="1"
    fi
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-WINDOW-MANAGER-TITLE" " - https://wiki.archlinux.org/index.php/Window_Manager"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_this  "INSTALL-WINDOW-MANAGER-INFO-1"
        print_this  "INSTALL-WINDOW-MANAGER-INFO-2"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-WINDOW-MANAGER-MENU-1"  "" ""     "INSTALL-WINDOW-MANAGER-MENU-1-I"  "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-WINDOW-MANAGER-MENU-2"  "" "$AUR" "INSTALL-WINDOW-MANAGER-MENU-2-I"  "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        BYPASS="$Old_BYPASS" # Restroe Bypass
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_awesome_menu
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_openbox_menu
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
    add_package        "$INSTALL_MATE"
    add_packagemanager "package_install \"$INSTALL_MATE\" 'INSTALL-MATE'" "INSTALL-MATE"
    add_packagemanager "systemctl enable polkit.service"          "SYSTEMD-ENABLE-MATE-3"
    add_packagemanager "systemctl enable accounts-daemon.service" "SYSTEMD-ENABLE-MATE-1"
    add_packagemanager "systemctl enable upower.service"          "SYSTEMD-ENABLE-MATE-2"
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
    localize_info "INSTALL-KDE-TITLE"   "KDE CUSTOMIZATION"
    localize_info "INSTALL-KDE-INFO-1"  "KDE is an international free software community producing an integrated set of cross-platform applications designed to run on Linux, FreeBSD, Microsoft Windows, Solaris and Mac OS X systems. It is known for its Plasma Desktop, a desktop environment provided as the default working environment on many Linux distributions."
fi
# -------------------------------------
install_kde_menu()
{
    # 2
    local -r menu_name="INSTALL-KDE"  # You must define Menu Name here
    local BreakableKey="D"            # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 5 7"  # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    add_package "$INSTALL_KDE"
    add_packagemanager "package_install \"$INSTALL_KDE\" 'INSTALL-KDE'" "INSTALL-KDE" # "kde-telepathy telepathy"
    if [[ "$PHONON" -eq 0 ]]; then
        add_package "$INSTALL_PHONON"
        add_packagemanager "package_install \"$INSTALL_PHONON\" 'INSTALL-PHONON'" "INSTALL-PHONON" 
    else
        add_package "$INSTALL_PHONON_VLC"
        add_packagemanager "package_install \"$INSTALL_PHONON_VLC\" 'INSTALL-PHONON_VLC'" "INSTALL-PHONON_VLC" 
    fi
    #add_packagemanager "package_remove 'kdemultimedia-kscd kdemultimedia-juk'" "REMOVE-KDE"
    add_aur_package "$AUR_INSTALL_KDE"
    add_packagemanager "aur_package_install \"$AUR_INSTALL_KDE\" 'AUR-INSTALL-KDE'" "AUR-INSTALL-KDE"
    #
    CONFIG_KDE=1
    KDE_INSTALLED=1
    # Application development toolkit for controlling system-wide privileges
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    # polkit.service
    # systemd-logind replaced console-kit-daemon.service
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-KDE-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info "INSTALL-KDE-INFO-1"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "apper"         "" ""     "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "bangarang"     "" "$AUR" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "choqok"        "" ""     "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "digikam"       "" ""     "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "k3b"           "" ""     "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "rosa-icons"    "" "$AUR" "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Plasma Themes" "" ""     "" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "yakuake"       "" ""     "" "MenuTheme[@]" # 8
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #        
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_APPER"
                    add_packagemanager "package_install \"$INSTALL_APPER\" 'INSTALL-APPER'" "INSTALL-APPER"
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_BANGARANG"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_BANGARANG\" 'AUR-INSTALL-BANGARANG'" "AUR-INSTALL-BANGARANG"
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_CHOQOK"
                    add_packagemanager "package_install \"$INSTALL_CHOQOK\" 'INSTALL-CHOQOK'" "INSTALL-CHOQOK"
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_DIGIKAM"
                    add_packagemanager "package_install \"$INSTALL_DIGIKAM\" 'INSTALL-DIGIKAM'" "INSTALL-DIGIKAM"
                    ;;
                5)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_K3B"
                    add_packagemanager "package_install \"$INSTALL_K3B\" 'INSTALL-K3B'" "INSTALL-K3B"
                    ;;
                6)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ROSA_ICONS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ROSA_ICONS\" 'AUR-INSTALL-ROSA-ICONS'" "AUR-INSTALL-ROSA-ICONS"
                    ;;
                7)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_PLASMA_THEMES"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_PLASMA_THEMES\" 'AUR-INSTALL-PLASMA-THEMES'" "AUR-INSTALL-PLASMA-THEMES"
                    ;;
                8)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_YAKUAKE"
                    add_packagemanager "package_install \"$INSTALL_YAKUAKE\" 'INSTALL-YAKUAKE'" "INSTALL-YAKUAKE"
                    add_aur_package "$AUR_INSTALL_YAKUAKE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_YAKUAKE\" 'AUR-INSTALL-YAKUAKE'" "AUR-INSTALL-YAKUAKE"
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
    DESCRIPTION=$(localize "CONFIGURE-GNOME-DESC")
    NOTES=$(localize "CONFIGURE-GNOME-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "CONFIGURE-GNOME-DESC"   "Install Gnome"
    localize_info "CONFIGURE-GNOME-NOTES"  "None."
    localize_info "CONFIGURE-GNOME-TITLE"  "GNOME CUSTOMIZATION"
    #
    localize_info "CONFIGURE-GNOME-TITLE"  "GNOME"
    localize_info "CONFIGURE-GNOME-INFO-1" "GNOME is a desktop environment and graphical user interface that runs on top of a computer operating system. It is composed entirely of free and open source software. It is an international project that includes creating software development frameworks, selecting application software for the desktop, and working on the programs that manage application launching, file handling, and window and task management."
    localize_info "CONFIGURE-GNOME-INFO-2" "GNOME Shell Extensions: disper gpaste gnome-shell-extension-gtile-git gnome-shell-extension-mediaplayer-git gnome-shell-extension-noa11y-git gnome-shell-extension-pomodoro-git gnome-shell-extension-user-theme-git gnome-shell-extension-weather-git gnome-shell-system-monitor-applet-git"
    localize_info "CONFIGURE-GNOME-INFO-3" "GNOME Shell Themes: gnome-shell-theme-default-mod gnome-shell-theme-dark-shine gnome-shell-theme-elegance gnome-shell-theme-eos gnome-shell-theme-frieze gnome-shell-theme-google+"
fi
# -------------------------------------
install_gnome_menu()
{
    # 9
    local -r menu_name="INSTALL-GNOME"  # You must define Menu Name here
    local BreakableKey="D"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-5"      # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    GNOME_INSTALLED=1
    CONFIG_GNOME=1
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    print_title "CONFIGURE-GNOME-TITLE" " - https://wiki.archlinux.org/index.php/GNOME"
    print_info  "CONFIGURE-GNOME-INFO-1"
    print_info  "CONFIGURE-GNOME-INFO-2"
    print_info  "CONFIGURE-GNOME-INFO-3"
    add_package "$INSTALL_GNOME" 
    add_packagemanager "package_install \"$INSTALL_GNOME\" 'INSTALL-GNOME'" "INSTALL-GNOME"
    # telepathy
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "CONFIGURE-GNOME-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GNOME Shell Extensions" "" "$AUR" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GNOME Shell Themes"     "" ""     "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "GNOME Packagekit"       "" ""     "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "activity-journal"       "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "activity-log-manager"   "" "$AUR" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gloobus-sushi-bzr"      "" "$AUR" "" "MenuTheme[@]" # 6
        #
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # GNOME Shell Extensions
                    MenuChecks[$((S_OPT - 1))]=1
                    install_gnome_menushell_extensions_menu
                    ;;
                2)  # GNOME Shell Themes
                    MenuChecks[$((S_OPT - 1))]=1
                    install_gnome_menushell_themes_menu
                    ;;
                3)  # GNOME Packagekit
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GNOME_PACKAGEKIT"
                    add_packagemanager "package_install \"$INSTALL_GNOME_PACKAGEKIT\" 'INSTALL-GNOME-PACKAGEKIT'" "INSTALL-GNOME-PACKAGEKIT"
                    ;;
                4)  # activity-journal
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_CUSTOM_ACT_JOURNAL"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_CUSTOM_ACT_JOURNAL\" 'AUR-INSTALL-GNOME-CUSTOM-ACT-JOURNAL'" "AUR-INSTALL-GNOME-CUSTOM-ACT-JOURNAL"
                    ;;
                5)  # activity-log-manager
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_CUSTOM_ACT_LOG_MANAGER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_CUSTOM_ACT_LOG_MANAGER\" 'AUR-INSTALL-GNOME-CUSTOM-ACT-LOG-MANAGER'" "AUR-INSTALL-GNOME-CUSTOM-ACT-LOG-MANAGER"
                    ;;
                6)  # gloobus-sushi-bzr
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_CUSTOM_GLOOBUS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_CUSTOM_GLOOBUS\" 'AUR-INSTALL-GNOME-CUSTOM-GLOOBUS'" "AUR-INSTALL-GNOME-CUSTOM-GLOOBUS"
                    ;;
                *)  # Catch ALL 
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        S_OPT="$BreakableKey"
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
    #}}}
    #Gnome Display Manager (a reimplementation of xdm)
    #D-Bus interface for user account query and manipulation
    #Application development toolkit for controlling system-wide privileges
    #Abstraction for enumerating power devices, listening to device events and querying history and statistics
    #A framework for defining and tracking users, login sessions, and seats
    # polkit.service
    # systemd-logind replaced console-kit-daemon.service
    add_packagemanager "systemctl enable accounts-daemon.service upower.service" "SYSTEMD-ENABLE-GNOME"
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
    localize_info "INSTALL-GNOMESHELL-EXTENSIONS-DESC"   "Install Gnomeshell Extensions"
fi
# -------------------------------------
install_gnome_menushell_extensions_menu()
{
    local -r menu_name="INSTALL-GNOMESHELL-EXTENSIONS"  # You must define Menu Name here
    local BreakableKey="B"                              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-3 7 8"                  # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 9 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-GNOMESHELL-EXTENSIONS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "disper"                "" "" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gpaste"                "" "" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "mediaplayer"           "" "" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "noa11y"                "" "" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "pomodoro"              "" "" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "System-monitor-applet" "" "" "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "user-theme"            "" "" "" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "weather"               "" "" "" "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gtile"                 "" "" "" "MenuTheme[@]" # 9
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_DISPER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_DISPER\" 'AUR-INSTALL-GSHELL-DISPER'" "AUR-INSTALL-GSHELL-DISPER"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_GPASTE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_GPASTE\" 'AUR-INSTALL-GSHELL-GPASTE'" "AUR-INSTALL-GSHELL-GPASTE"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_MEDIAPLAYER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_MEDIAPLAYER\" 'AUR-INSTALL-GSHELL-MEDIAPLAYER'" "AUR-INSTALL-GSHELL-MEDIAPLAYER"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_NOA11Y"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_NOA11Y\" 'AUR-INSTALL-GSHELL-NOA11Y'" "AUR-INSTALL-GSHELL-NOA11Y"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_POMODORO"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_POMODORO\" 'AUR-INSTALL-GSHELL-POMODORO'" "AUR-INSTALL-GSHELL-POMODORO"
                    ;;
                6)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_SYSTEM_MONITOR"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_SYSTEM_MONITOR\" 'AUR-INSTALL-GSHELL-SYSTEM-MONITOR'" "AUR-INSTALL-GSHELL-SYSTEM-MONITOR"
                    ;;
                7)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_USER_THEME"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_USER_THEME\" 'AUR-INSTALL-GSHELL-USER-THEME'" "AUR-INSTALL-GSHELL-USER-THEME"
                    ;;
                8)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_WEATHER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_WEATHER\" 'AUR-INSTALL-GSHELL-WEATHER'" "AUR-INSTALL-GSHELL-WEATHER"
                    ;;
                9)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_GTILE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_GTILE\" 'AUR-INSTALL-GSHELL-GTILE'" "AUR-INSTALL-GSHELL-GTILE"
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
fi
# -------------------------------------
install_gnome_menushell_themes_menu()
{
    local -r menu_name="INSTALL-GNOMESHELL-THEMES"  # You must define Menu Name here
    local BreakableKey="B"                          # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-6"                  # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-GNOMESHELL-THEMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "default-mod" "" "" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "dark-shine"  "" "" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "elegance"    "" "" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "eos"         "" "" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "frieze"      "" "" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "google+"     "" "" "" "MenuTheme[@]" # 6
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_THEMES_DEFAULT"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_DEFAULT\" 'AUR-INSTALL-GSHELL-THEMES-DEFAULT'" "AUR-INSTALL-GSHELL-THEMES-DEFAULT"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_THEMES_DARK_SHINE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_DARK_SHINE\" 'AUR-INSTALL-GSHELL-THEMES-DARK-SHINE'" "AUR-INSTALL-GSHELL-THEMES-DARK-SHINE"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_THEMES_ELEGANCE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_ELEGANCE\" 'AUR-INSTALL-GSHELL-THEMES-ELEGANCE'" "AUR-INSTALL-GSHELL-THEMES-ELEGANCE"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_THEMES_EOS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_EOS\" 'AUR-INSTALL-GSHELL-THEMES-EOS'" "AUR-INSTALL-GSHELL-THEMES-EOS"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_THEMES_FRIEZE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_FRIEZE\" 'AUR-INSTALL-GSHELL-THEMES-FRIEZE'" "AUR-INSTALL-GSHELL-THEMES-FRIEZE"
                    ;;
                6)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GSHELL_THEMES_GOOGLE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GSHELL_THEMES_GOOGLE\" 'AUR-INSTALL-GSHELL-THEMES-GOOGLE'" "AUR-INSTALL-GSHELL-THEMES-GOOGLE"
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
    NAME="install_awesome_menu"
    USAGE="install_awesome_menu"
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
    localize_info "INSTALL-AWESOME-REC"    "Recommended Optins"
fi
# -------------------------------------
install_awesome_menu()
{
    # 4
    local -r menu_name="INSTALL-AWESOME"  # You must define Menu Name here
    local BreakableKey="D"                # Q=Quit, D=Done, B=Back
    local RecommendedOptions="4 6"        # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions 3 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 3 7 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    AWESOME_INSTALLED=1
    #
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
    add_package "$INSTALL_AWESOME"
    add_packagemanager "package_install \"$INSTALL_AWESOME\" 'INSTALL-AWESOME'" "INSTALL-AWESOME"
    add_aur_package "$AUR_INSTALL_AWESOME"
    add_packagemanager "aur_package_install \"$AUR_INSTALL_AWESOME\" 'AUR-INSTALL-AWESOME'" "AUR-INSTALL-AWESOME"
    add_packagemanager "make_dir \"/home/$USERNAME/.config/awesome/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/awesome/rc.lua' \"/home/$USERNAME/.config/awesome/\" \"$(basename $BASH_SOURCE) : $LINENO\"; chown -R $USERNAME:$USERNAME /home/$USERNAME/.config" "CONFIG-AWESOME"   
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]];  do
        print_title "INSTALL-AWESOME-TITLE" " - https://wiki.archlinux.org/index.php/Awesome"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info "INSTALL-AWESOME-INFO-1"
        print_info "INSTALL-AWESOME-INFO-2"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xcompmgr"     "" "" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "viewnior"     "" "" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gmrun"        "" "" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "PCManFM"      "" "" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "rxvt-unicode" "" "" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "scrot"        "" "" "scrot : [Print Screen]" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "thunar"       "" "" "thunar: [File Browser]" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "tint2"        "" "" "" "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "volwheel"     "" "" "" "MenuTheme[@]" # 9
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xfburn"       "" "" "" "MenuTheme[@]" # 10
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_XCOMPMGR"
                    add_packagemanager "package_install \"$INSTALL_XCOMPMGR\" 'INSTALL-XCOMPMGR'" "INSTALL-XCOMPMGR"
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_VIEWNIOR"
                    add_packagemanager "package_install \"$INSTALL_VIEWNIOR\" 'INSTALL-VIEWNIOR'" "INSTALL-VIEWNIOR"
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GMRUN"
                    add_packagemanager "package_install \"$INSTALL_GMRUN\" 'INSTALL-GMRUN'" "INSTALL-GMRUN"
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_PCMANFM"
                    add_packagemanager "package_install \"$INSTALL_PCMANFM\" 'INSTALL-PCMANFM'" "INSTALL-PCMANFM"
                    ;;
                5)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_RXVT_UNICODE"
                    add_packagemanager "package_install \"$INSTALL_RXVT_UNICODE\" 'INSTALL-RXVT-UNICODE'" "INSTALL-RXVT-UNICODE"
                    ;;
                6)  # scrot
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_SCROT"
                    add_packagemanager "package_install \"$INSTALL_SCROT\" 'INSTALL-SCROT'" "INSTALL-SCROT"
                    ;;
                7)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_THUNAR"
                    add_packagemanager "package_install \"$INSTALL_THUNAR\" 'INSTALL-THUNAR'" "INSTALL-THUNAR"
                    ;;
                8)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_TINT2"
                    add_packagemanager "package_install \"$INSTALL_TINT2\" 'INSTALL-TINT2'" "INSTALL-TINT2"
                    ;;
                9)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_VOLWHEEL"
                    add_packagemanager "package_install \"$INSTALL_VOLWHEEL\" 'INSTALL-VOLWHEEL'" "INSTALL-VOLWHEEL"
                    ;;
               10)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_XFBURN"
                    add_packagemanager "package_install \"$INSTALL_XFBURN\" 'INSTALL-XFBURN'" "INSTALL-XFBURN"
                    ;;
                *)  # Catch ALL 
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        S_OPT="$BreakableKey"
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    # systemd-logind replaced console-kit-daemon.service
    add_packagemanager "systemctl enable upower.service" "SYSTEMD-ENABLE-AWESOME"
}
#}}}

# -----------------------------------------------------------------------------
# INSTALL RAZOR QT MENU {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_razor_qt_menu"
    USAGE="install_razor_qt_menu"
    DESCRIPTION=$(localize "INSTALL-RAZOR-QT-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-RAZOR-QT-DESC"   "Install Razor-Qt"
    localize_info "INSTALL-RAZOR-QT-TITLE"  "RAZOR-QT"
    localize_info "INSTALL-RAZOR-QT-INFO-1" "RAZOR-QT is a highly configurable, next generation framework window manager for X. It is very fast, extensible and licensed under the GNU GPLv2 license."
    localize_info "INSTALL-RAZOR-QT-INFO-2" "RAZOR-QT CUSTOMIZATION"
    localize_info "INSTALL-RAZOR-QT-REC"    "Recommended Optins"
    #
    localize_info "INSTALL-RAZOR-QT-MENU-1"   "smplayer"
    localize_info "INSTALL-RAZOR-QT-MENU-I-1"       "smplayer: "
    localize_info "INSTALL-RAZOR-QT-MENU-2"   "vlc"
    localize_info "INSTALL-RAZOR-QT-MENU-I-2"       "vlc: "
    localize_info "INSTALL-RAZOR-QT-MENU-3"   "Clementine"
    localize_info "INSTALL-RAZOR-QT-MENU-I-3"       "Clementine: "
    localize_info "INSTALL-RAZOR-QT-MENU-4"   "qasmixer"
    localize_info "INSTALL-RAZOR-QT-MENU-I-4"       "qasmixer: "
    localize_info "INSTALL-RAZOR-QT-MENU-5"   "Qt Image Viewers"
    localize_info "INSTALL-RAZOR-QT-MENU-I-5"       "Qt Image Viewers: "
    localize_info "INSTALL-RAZOR-QT-MENU-6"   "Image Editors"
    localize_info "INSTALL-RAZOR-QT-MENU-I-6"       "Image Editors: easypaint-git, pencil-svn"
    localize_info "INSTALL-RAZOR-QT-MENU-7"   "scrot" 
    localize_info "INSTALL-RAZOR-QT-MENU-I-7"       "scrot : [Print Screen]"
    localize_info "INSTALL-RAZOR-QT-MENU-8"   "qtfm"
    localize_info "INSTALL-RAZOR-QT-MENU-I-8"       "qtfm: Qt File Browser."
    localize_info "INSTALL-RAZOR-QT-MENU-9"   "qterminal"
    localize_info "INSTALL-RAZOR-QT-MENU-I-9"       "qterminal: Qt Terminal"
    localize_info "INSTALL-RAZOR-QT-MENU-10"  "qpdfview"
    localize_info "INSTALL-RAZOR-QT-MENU-I-10"      "qpdfview: Qt PDF View"
fi
# -------------------------------------
install_razor_qt_menu()
{
    # 4
    local -r menu_name="INSTALL-RAZOR-QT"  # You must define Menu Name here
    local BreakableKey="D"                 # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-10"        # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    if [[ "$CUSTOM_DE" -eq 4 ]]; then
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"
    fi                    
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    RAZOR-QT_INSTALLED=1
    #
    # Needs a WM: openbox, fwwm2, kwin, KDE without Plasma Desktop
                    
    #
    #INSTALL_RAZOR_QT=""
    #add_package "$INSTALL_RAZOR_QT"
    #add_packagemanager "package_install \"$INSTALL_RAZOR_QT\" 'INSTALL-AWESOME'" "INSTALL-AWESOME"
    #
    add_aur_package "$AUR_INSTALL_RAZOR_QT"
    add_packagemanager "aur_package_install \"$AUR_INSTALL_RAZOR_QT\" 'AUR-INSTALL-RAZOR-QT'" "AUR-INSTALL-RAZOR-QT"
    add_packagemanager "make_dir \"/home/$USERNAME/.config/razor/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/razor/session.conf' \"/home/$USERNAME/.config/razor/\" \"$(basename $BASH_SOURCE) : $LINENO\"; chown -R $USERNAME:$USERNAME /home/$USERNAME/.config" "CONFIG-AWESOME"   

    add_packagemanager "$(config_xinitrc 'exec razor-session')" "CONFIG-XINITRC-RAZOR"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]];  do
        print_title "INSTALL-RAZOR-QT-TITLE" " - https://wiki.archlinux.org/index.php/Razor-qt"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info "INSTALL-RAZOR-QT-INFO-1"
        print_info "INSTALL-RAZOR-QT-INFO-2"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RAZOR-QT-MENU-1"  "" ""     "INSTALL-RAZOR-QT-MENU-I-1"  "MenuTheme[@]" # 1  smplayer
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RAZOR-QT-MENU-2"  "" ""     "INSTALL-RAZOR-QT-MENU-I-2"  "MenuTheme[@]" # 2  vlc
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RAZOR-QT-MENU-3"  "" ""     "INSTALL-RAZOR-QT-MENU-I-3"  "MenuTheme[@]" # 3  Clementine
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RAZOR-QT-MENU-4"  "" "$AUR" "INSTALL-RAZOR-QT-MENU-I-4"  "MenuTheme[@]" # 4  qasmixer
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RAZOR-QT-MENU-5"  "" "$AUR" "INSTALL-RAZOR-QT-MENU-I-5"  "MenuTheme[@]" # 5  Qt Image Viewers
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RAZOR-QT-MENU-6"  "" "$AUR" "INSTALL-RAZOR-QT-MENU-I-6"  "MenuTheme[@]" # 6  Image Editors
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RAZOR-QT-MENU-7"  "" ""     "INSTALL-RAZOR-QT-MENU-I-7"  "MenuTheme[@]" # 7  scrot
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RAZOR-QT-MENU-8"  "" "$AUR" "INSTALL-RAZOR-QT-MENU-I-8"  "MenuTheme[@]" # 8  qtfm
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RAZOR-QT-MENU-9"  "" "$AUR" "INSTALL-RAZOR-QT-MENU-I-9"  "MenuTheme[@]" # 9  qterminal
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-RAZOR-QT-MENU-10" "" "$AUR" "INSTALL-RAZOR-QT-MENU-I-10" "MenuTheme[@]" # 10 qpdfview
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # smplayer
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_SMPLAYER"
                    add_packagemanager "package_install \"$INSTALL_SMPLAYER\" 'INSTALL-SMPLAYER'" "INSTALL-SMPLAYER"
                    ;;
                2)  # vlc
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_VLC"
                    add_packagemanager "package_install \"$INSTALL_VLC\" 'INSTALL-VLC'" "INSTALL-VLC"
                    ;;
                3)  # Clementine
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_CLEMENTINE"
                    add_packagemanager "package_install \"$INSTALL_CLEMENTINE\" 'INSTALL-CLEMENTINE'" "INSTALL-CLEMENTINE"
                    ;;
                4)  # qasmixer 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_QASMIXER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_QASMIXER\" 'AUR-INSTALL-QASMIXER'" "AUR-INSTALL-QASMIXER"
                    ;;
                5)  # Qt Image Viewers 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_QT_IMAGE_VIEWERS"
                    add_packagemanager "package_install \"$INSTALL_QT_IMAGE_VIEWERS\" 'INSTALL-QT-IMAGE-VIEWERS'" "INSTALL-QT-IMAGE-VIEWERS"
                    #
                    add_package "$AUR_QT_IMAGE_VIEWERS"
                    add_packagemanager "aur_package_install \"$AUR_QT_IMAGE_VIEWERS\" 'AUR-INSTALL-QT-IMAGE-VIEWERS'" "AUR-INSTALL-QT-IMAGE-VIEWERS"
                    ;;
                6)  # Image Editors
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_QT_IMAGE_EDITORS"
                    add_packagemanager "aur_package_install \"$AUR_QT_IMAGE_EDITORS\" 'AUR-INSTALL-QT-IMAGE-EDITORS'" "AUR-INSTALL-QT-IMAGE-EDITORS"
                    ;;
                7)  # scrot
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_SCROT"
                    add_packagemanager "package_install \"$INSTALL_SCROT\" 'INSTALL-SCROT'" "INSTALL-SCROT"
                    ;;
                8)  # qtfm
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_TINT2"
                    add_packagemanager "package_install \"$INSTALL_TINT2\" 'INSTALL-TINT2'" "INSTALL-TINT2"
                    ;;
                9)  # qterminal
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_QTERMINAL" 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_QTERMINAL\" 'AUR-INSTALL-QTERMINAL'" "AUR-INSTALL-QTERMINAL"
                    ;;
               10)  # qpdfview
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_QT_PDF"
                    add_packagemanager "aur_package_install \"$AUR_QT_PDF\" 'AUR-INSTALL-QT-PDF'" "AUR-INSTALL-QT-PDF"
                    ;;
                *)  # Catch ALL 
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        S_OPT="$BreakableKey"
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    # systemd-logind replaced console-kit-daemon.service
    #add_packagemanager "systemctl enable upower.service" "SYSTEMD-ENABLE-RAZOR-QT"
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
    localize_info "INSTALL-CINNAMON-TITLE" "CINNAMON"
    localize_info "INSTALL-CINNAMON-INFO-1" "Cinnamon is a fork of GNOME Shell, initially developed by Linux Mint. It attempts to provide a more traditional user environment based on the desktop metaphor, like GNOME 2. Cinnamon uses Muffin, a fork of the GNOME 3 window manager Mutter, as its window manager."
    localize_info "INSTALL-CINNAMON-INFO-2" "CINNAMON CUSTOMIZATION"
    localize_info "INSTALL-CINNAMON-INFO-3" "Installed Cinnamon"
    #
    localize_info "INSTALL-CINNAMON-MENU-1" "Applets"
    localize_info "INSTALL-CINNAMON-MENU-2" "Themes"
    localize_info "INSTALL-CINNAMON-MENU-3" "GNOME Packagekit"
    localize_info "INSTALL-CINNAMON-MENU-4" "GNOME Activity Journal"
    localize_info "INSTALL-CINNAMON-MENU-5" "gloobus-sushi-bzr"
fi
# -------------------------------------
install_cinnamon_menu()
{
    # 5
    local -r menu_name="INSTALL-CINNAMON"  # You must define Menu Name here
    local BreakableKey="D"                 # Q=Quit, D=Done, B=Back 
    local RecommendedOptions="2"           # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 3 4 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    CINNAMON_INSTALLED=1
    add_package "$INSTALL_CINNAMON_PACKAGE"
    add_packagemanager "package_install \"$INSTALL_CINNAMON_PACKAGE\" 'INSTALL-CINNAMON'" "INSTALL-CINNAMON"
    add_aur_package "$AUR_INSTALL_CINNAMON_PACKAGE"
    add_packagemanager "aur_package_install \"$AUR_INSTALL_CINNAMON_PACKAGE\" 'AUR-INSTALL-CINNAMON'" "AUR-INSTALL-CINNAMON"
    # @FIX gnome-extra gnome-extra-meta telepathy
    # 
    # not sure how to run these commands; seems like they need to run after GUI is up and running; so adding them as a start up script may be what is needed
    # add_packagemanager "cinnamon-settings; cinnamon-settings panel; cinnamon-settings calendar; cinnamon-settings themes; cinnamon-settings applets; cinnamon-settings windows; cinnamon-settings fonts; cinnamon-settings hotcorner" "AUR-INSTALL-CINNAMON-SETTINGS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-CINNAMON-TITLE" " - https://wiki.archlinux.org/index.php/Cinnamon"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info  "INSTALL-CINNAMON-INFO-1"
        print_info  "INSTALL-CINNAMON-INFO-2"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CINNAMON-MENU-1" "" "$AUR" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CINNAMON-MENU-2" "" ""     "" "MenuTheme[@]" # 2 
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CINNAMON-MENU-3" "" ""     "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CINNAMON-MENU-4" "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-CINNAMON-MENU-5" "" "$AUR" "" "MenuTheme[@]" # 5
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_CINNAMON_APPLETS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_CINNAMON_APPLETS\" 'AUR-INSTALL-CINNAMON-APPLETS'" "AUR-INSTALL-CINNAMON-APPLETS"
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_CINNAMON_THEMES"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_CINNAMON_THEMES\" 'AUR-INSTALL-CINNAMON-THEMES'" "AUR-INSTALL-CINNAMON-THEMES"
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GNOME_PACKAGEKIT"
                    add_packagemanager "package_install \"$INSTALL_GNOME_PACKAGEKIT\" 'INSTALL-GNOME-PACKAGEKIT'" "INSTALL-GNOME-PACKAGEKIT"
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_ZEITGEIST"
                    add_packagemanager "package_install \"$INSTALL_ZEITGEIST\" 'INSTALL-ZEITGEIST'" "INSTALL-ZEITGEIST"
                    add_aur_package "$AUR_INSTALL_GNOME_ACTIVITY_JOURNAL"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ACTIVITY_JOURNAL\" 'AUR-INSTALL-GNOME-ACTIVITY-JOURNAL'" "AUR-INSTALL-GNOME-ACTIVITY-JOURNAL"
                    ;;
                5)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GLOOBUS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GLOOBUS\" 'AUR-INSTALL-GLOOBUS'" "AUR-INSTALL-GLOOBUS"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        S_OPT="$BreakableKey"
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
    # Gnome Display Manager (a reimplementation of xdm)
    # D-Bus interface for user account query and manipulation
    # Application development toolkit for controlling system-wide privileges
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    # polkit.service
    # systemd-logind replaced console-kit-daemon.service
    add_packagemanager "systemctl enable accounts-daemon.service upower.service" "SYSTEMD-ENABLE-CINNAMON"
    write_log "INSTALL-CINNAMON-INFO-3"
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
    localize_info "INSTALL-E17-INFO-2" "E17 CUSTOMIZATION"
fi
# -------------------------------------
install_e17_menu()
{
    # 6
    local -r menu_name="INSTALL-E17"  # You must define Menu Name here
    local BreakableKey="D"            # Q=Quit, D=Done, B=Back
    local RecommendedOptions="5 7"    # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 8 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    E17_INSTALLED=1
    add_package "$INSTALL_E17"
    add_packagemanager "package_install \"$INSTALL_E17\" 'INSTALL-E17'" "INSTALL-E17"
    add_aur_package "$AUR_INSTALL_E17"
    add_packagemanager "aur_package_install \"$AUR_INSTALL_E17\" 'AUR-INSTALL-E17'" "AUR-INSTALL-E17"
    add_packagemanager "chown -R $USERNAME:$USERNAME /home/$USERNAME/.config" "CONFIG-XFCE"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-E17-TITLE" " - https://wiki.archlinux.org/index.php/E17"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info "INSTALL-E17-INFO-1"
        print_info "INSTALL-E17-INFO-2"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "e17-icons"    "" "$AUR" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "e17-themes"   "" "$AUR" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "viewnior"     "" ""     "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "gmrun"        "" ""     "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "PCManFM"      "" ""     "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "rxvt-unicode" "" ""     "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "scrot"        "" ""     "scrot: Print Screen" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "thunar"       "" ""     "thunar: File Browser" "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xfburn"       "" ""     "" "MenuTheme[@]" # 9
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_E17_ICONS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_E17_ICONS\" 'AUR-INSTALL-E17-ICONS'" "AUR-INSTALL-E17-ICONS"
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_E17_THEMES"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_E17_THEMES\" 'AUR-INSTALL-E17-THEMES'" "AUR-INSTALL-E17-THEMES"
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_VIEWNIOR"
                    add_packagemanager "package_install \"$INSTALL_VIEWNIOR\" 'INSTALL-VIEWNIOR'" "INSTALL-VIEWNIOR"
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GMRUN"
                    add_packagemanager "package_install \"$INSTALL_GMRUN\" 'INSTALL-GMRUN'" "INSTALL-GMRUN"
                    ;;
                5)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_PCMANFM"
                    add_packagemanager "package_install \"$INSTALL_PCMANFM\" 'INSTALL-PCMANFM'" "INSTALL-PCMANFM"
                    ;;
                6)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_RXVT_UNICODE"
                    add_packagemanager "package_install \"$INSTALL_RXVT_UNICODE\" 'INSTALL-RXVT-UNICODE'" "INSTALL-RXVT-UNICODE"
                    ;;
                7)  # scrot
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_SCROT"
                    add_packagemanager "package_install \"$INSTALL_SCROT\" 'INSTALL-SCROT'" "INSTALL-SCROT"
                    ;;
                8)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_THUNAR"
                    add_packagemanager "package_install \"$INSTALL_THUNAR\" 'INSTALL-THUNAR'" "INSTALL-THUNAR"
                    ;;
                9)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_XFBURN"
                    add_packagemanager "package_install \"$INSTALL_XFBURN\" 'INSTALL-XFBURN'" "INSTALL-XFBURN"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        S_OPT="$BreakableKey"
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    # systemd-logind replaced console-kit-daemon.service
    add_packagemanager "systemctl enable upower.service" "SYSTEMD-ENABLE-E17"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL LXDE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_lxde_menu"
    USAGE="install_lxde_menu"
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
install_lxde_menu()
{
    # 7
    local -r menu_name="INSTALL-LXDE"  # You must define Menu Name here
    local BreakableKey="D"             # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 2"     # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    LXDE_INSTALLED=1
    #
    add_package "$INSTALL_LXDE"
    add_packagemanager "package_install \"$INSTALL_LXDE\" 'INSTALL-LXDE'" "INSTALL-LXDE"
    #
    add_aur_package "$AUR_INSTALL_LXDE"
    add_packagemanager "aur_package_install \"$AUR_INSTALL_LXDE\" 'AUR-INSTALL-LXDE'" "AUR-INSTALL-LXDE"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-LXDE-TITLE" " - https://wiki.archlinux.org/index.php/lxde"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info "INSTALL-LXDE-INFO-1"
        print_info "INSTALL-LXDE-INFO-2"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "viewnior" "" "" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xfburn"   "" "" "" "MenuTheme[@]" # 2
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_VIEWNIOR"
                    add_packagemanager "package_install \"$INSTALL_VIEWNIOR\" 'INSTALL-VIEWNIOR '" "INSTALL-VIEWNIOR"
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_XFBURN"
                    add_packagemanager "package_install \"$INSTALL_XFBURN\" 'INSTALL-XFBURN'" "INSTALL-XFBURN"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        S_OPT="$BreakableKey"
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    # systemd-logind replaced console-kit-daemon.service
    add_packagemanager "systemctl enable upower.service" "SYSTEMD-ENABLE-LXDE"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL OPENBOX {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_openbox_menu"
    USAGE="install_openbox_menu"
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
    #
    localize_info "INSTALL-OPENBOX-MENU-1"    "xcompmgr"
    localize_info "INSTALL-OPENBOX-MENU-I-1"        "xcompmgr: 	Composite Window-effects manager for X.org"
    localize_info "INSTALL-OPENBOX-MENU-2"    "viewnior"
    localize_info "INSTALL-OPENBOX-MENU-I-2"        "viewnior: A simple, fast and elegant image viewer program"
    localize_info "INSTALL-OPENBOX-MENU-3"    "gmrun"
    localize_info "INSTALL-OPENBOX-MENU-I-3"        "gmrun: A simple program which provides a run program window"
    localize_info "INSTALL-OPENBOX-MENU-4"    "PCManFM"
    localize_info "INSTALL-OPENBOX-MENU-I-4"        "PCManFM: An extremely fast and lightweight file manager"
    localize_info "INSTALL-OPENBOX-MENU-5"    "rxvt-unicode"
    localize_info "INSTALL-OPENBOX-MENU-I-5"        "rxvt-unicode: An unicode enabled rxvt-clone terminal emulator (urxvt)"
    localize_info "INSTALL-OPENBOX-MENU-6"    "scrot"
    localize_info "INSTALL-OPENBOX-MENU-I-6"        "scrot: Print Screen - A simple command-line screenshot utility for X"
    localize_info "INSTALL-OPENBOX-MENU-7"    "thunar"
    localize_info "INSTALL-OPENBOX-MENU-I-7"        "thunar: Modern file manager for Xfce"
    localize_info "INSTALL-OPENBOX-MENU-8"    "tint2"
    localize_info "INSTALL-OPENBOX-MENU-I-8"        "tint2: A basic, good-looking task manager for WMs"
    localize_info "INSTALL-OPENBOX-MENU-9"    "volwheel"
    localize_info "INSTALL-OPENBOX-MENU-I-9"        "volwheel: Tray icon to change volume with the mouse"
    localize_info "INSTALL-OPENBOX-MENU-10"   "xfburn"
    localize_info "INSTALL-OPENBOX-MENU-I-10"       "xfburn: A simple CD/DVD burning tool based on libburnia libraries"
fi
# -------------------------------------
install_openbox_menu() 
{ 
    # 8
    local -r menu_name="INSTALL-OPENBOX"  # You must define Menu Name here
    local BreakableKey="D"                # Q=Quit, D=Done, B=Back
    local RecommendedOptions="4 6"        # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    if [[ "$CUSTOM_DE" -eq 1 ]]; then         # Mate
        RecommendedOptions=""
    elif [[ "$CUSTOM_DE" -eq 2 ]]; then       # KDE
        RecommendedOptions=""
    elif [[ "$CUSTOM_DE" -eq 3 ]]; then       # XFCE
        RecommendedOptions=""
    elif [[ "$CUSTOM_DE" -eq 4 ]]; then       # Razor-QT & Openbox
        RecommendedOptions=""
    elif [[ "$CUSTOM_DE" -eq 5 ]]; then       # Cinnamon
        RecommendedOptions=""
    elif [[ "$CUSTOM_DE" -eq 6 ]]; then       # Awesume
        RecommendedOptions=""
    fi
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 7 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    OPENBOX_INSTALLED=1
    add_package "$INSTALL_OPENBOX"
    add_packagemanager "package_install \"$INSTALL_OPENBOX\" 'INSTALL-OPENBOX'" "INSTALL-OPENBOX"
    add_aur_package "$AUR_INSTALL_OPENBOX"
    add_packagemanager "aur_package_install \"$AUR_INSTALL_OPENBOX\" 'AUR-INSTALL-OPENBOX'" "AUR-INSTALL-OPENBOX"
    add_packagemanager "make_dir \"/home/$USERNAME/.config/openbox/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/openbox/rc.xml' \"/home/$USERNAME/.config/openbox/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/openbox/menu.xml' \"/home/$USERNAME/.config/openbox/\" \"$(basename $BASH_SOURCE) : $LINENO\"; copy_file '/etc/xdg/openbox/autostart' \"/home/$USERNAME/.config/openbox/\" \"$(basename $BASH_SOURCE) : $LINENO\"; chown -R $USERNAME:$USERNAME /home/$USERNAME/.config" "CONFIG-OPENBOX"  
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-OPENBOX-TITLE" " - https://wiki.archlinux.org/index.php/Openbox"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info  "INSTALL-OPENBOX-INFO-1"
        print_info  "INSTALL-OPENBOX-INFO-2"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OPENBOX-MENU-1"  "" "" "INSTALL-OPENBOX-MENU-I-1"  "MenuTheme[@]" # 1  xcompmgr
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OPENBOX-MENU-2"  "" "" "INSTALL-OPENBOX-MENU-I-2"  "MenuTheme[@]" # 2  viewnior
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OPENBOX-MENU-3"  "" "" "INSTALL-OPENBOX-MENU-I-3"  "MenuTheme[@]" # 3  gmrun
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OPENBOX-MENU-4"  "" "" "INSTALL-OPENBOX-MENU-I-4"  "MenuTheme[@]" # 4  PCManFM
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OPENBOX-MENU-5"  "" "" "INSTALL-OPENBOX-MENU-I-5"  "MenuTheme[@]" # 5  rxvt-unicode
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OPENBOX-MENU-6"  "" "" "INSTALL-OPENBOX-MENU-I-6"  "MenuTheme[@]" # 6  scrot
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OPENBOX-MENU-7"  "" "" "INSTALL-OPENBOX-MENU-I-7"  "MenuTheme[@]" # 7  thunar
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OPENBOX-MENU-8"  "" "" "INSTALL-OPENBOX-MENU-I-8"  "MenuTheme[@]" # 8  tint2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OPENBOX-MENU-9"  "" "" "INSTALL-OPENBOX-MENU-I-9"  "MenuTheme[@]" # 9  volwheel
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OPENBOX-MENU-10" "" "" "INSTALL-OPENBOX-MENU-I-10" "MenuTheme[@]" # 10 xfburn
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # xcompmgr
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_XCOMPMGR"
                    add_packagemanager "package_install \"$INSTALL_XCOMPMGR\" 'INSTALL-XCOMPMGR'" "INSTALL-XCOMPMGR"
                    ;;
                2)  # viewnior
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_VIEWNIOR"
                    add_packagemanager "package_install \"$INSTALL_VIEWNIOR\" 'INSTALL-VIEWNIOR'" "INSTALL-VIEWNIOR"
                    ;;
                3)  # gmrun
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GMRUN"
                    add_packagemanager "package_install \"$INSTALL_GMRUN\" 'INSTALL-GMRUN'" "INSTALL-GMRUN"
                    ;;
                4)  # PCManFM
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_PCMANFM"
                    add_packagemanager "package_install \"$INSTALL_PCMANFM\" 'INSTALL-PCMANFM'" "INSTALL-PCMANFM"
                    ;;
                5)  # rxvt-unicode
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_RXVT_UNICODE"
                    add_packagemanager "package_install \"$INSTALL_RXVT_UNICODE\" 'INSTALL-RXVT-UNICODE'" "INSTALL-RXVT-UNICODE"
                    ;;
                6)  # scrot
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_SCROT"
                    add_packagemanager "package_install \"$INSTALL_SCROT\" 'INSTALL-SCROT'" "INSTALL-SCROT"
                    ;;
                7)  # thunar
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_THUNAR"
                    add_packagemanager "package_install \"$INSTALL_THUNAR\" 'INSTALL-THUNAR'" "INSTALL-THUNAR"
                    ;;
                8)  # tint2
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_TINT2"
                    add_packagemanager "package_install \"$INSTALL_TINT2\" 'INSTALL-TINT2'" "INSTALL-TINT2"
                    ;;
                9)  # volwheel
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_VOLWHEEL"
                    add_packagemanager "package_install \"$INSTALL_VOLWHEEL\" 'INSTALL-VOLWHEEL'" "INSTALL-VOLWHEEL"
                    ;;
               10)  # xfburn
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_XFBURN"
                    add_packagemanager "package_install \"$INSTALL_XFBURN\" 'INSTALL-XFBURN'" "INSTALL-XFBURN"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        S_OPT="$BreakableKey"
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    # systemd-logind replaced console-kit-daemon.service
    #add_packagemanager "systemctl enable upower.service" "SYSTEMD-ENABLE-OPENBOX"
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
fi
# -------------------------------------
install_xfce_menu() 
{ 
    # 3
    local -r menu_name="INSTALL-XFCE"  # You must define Menu Name here
    local BreakableKey="D"             # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    XFCE_INSTALLED=1
    add_package "$INSTALL_XFCE_PACKAGE"
    add_packagemanager "package_install \"$INSTALL_XFCE_PACKAGE\" 'INSTALL-XFCE'" "INSTALL-XFCE"
    add_aur_package "$AUR_INSTALL_XFCE_PACKAGE"
    add_packagemanager "aur_package_install \"$AUR_INSTALL_XFCE_PACKAGE\" 'AUR-INSTALL-XFCE'" "AUR-INSTALL-XFCE"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-XFCE-TITLE" " - https://wiki.archlinux.org/index.php/Xfce"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info "INSTALL-XFCE-INFO-1"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "xfce4-volumed" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_XFCE_CUSTOM"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_XFCE_CUSTOM\" 'AUR-INSTALL-XFCE-CUSTOM'" "AUR-INSTALL-XFCE-CUSTOM"
                    ;;
                *)  # Catch ALL
                    if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
                        if save_array "MenuChecks[@]" "${MENU_PATH}" "${menu_name}.db" ; then
                            SAVED_MAIN_MENU=1
                        fi
                        S_OPT="$BreakableKey"
                    else
                        invalid_option "$S_OPT"
                    fi
                    ;;
            esac
        done
        is_breakable "$S_OPT" "$BreakableKey"
    done
    # Application development toolkit for controlling system-wide privileges
    # Abstraction for enumerating power devices, listening to device events and querying history and statistics
    # A framework for defining and tracking users, login sessions, and seats
    # polkit.service
    # systemd-logind replaced console-kit-daemon.service
    add_packagemanager "systemctl enable upower.service" "SYSTEMD-ENABLE-XFCE"
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
    BYPASS="$Old_BYPASS" # Restroe Bypass
    [[ "$YN_OPTION" -eq 0 ]] && return 0
    # @FIX use Add Repo function
    echo -e '\n[unity]\nServer = http://unity.xe-xe.org/$arch'             >> $MOUNTPOINT/etc/pacman.conf
    echo -e '\n[unity-extra]\nServer = http://unity.xe-xe.org/extra/$arch' >> $MOUNTPOINT/etc/pacman.conf
    add_package "$INSTALL_UNITY"
    add_packagemanager "package_install \"$INSTALL_UNITY\" 'INSTALL-UNITY'" "INSTALL-UNITY"
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
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #    
    while [[ 1 ]];  do
        print_title "INSTALL-DISPLAY-MANAGER-TITLE" " - https://wiki.archlinux.org/index.php/Display_Manager"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info  "INSTALL-DISPLAY-MANAGER-INFO-1"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-1" ""  ""     "INSTALL-DISPLAY-MANAGER-MENU-1-I" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-2" ""  ""     "INSTALL-DISPLAY-MANAGER-MENU-2-I" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-3" ""  ""     "INSTALL-DISPLAY-MANAGER-MENU-3-I" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-4" ""  "$AUR" "INSTALL-DISPLAY-MANAGER-MENU-4-I" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-5" ""  ""     "INSTALL-DISPLAY-MANAGER-MENU-5-I" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-6" ""  ""     "INSTALL-DISPLAY-MANAGER-MENU-1-I" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DISPLAY-MANAGER-MENU-7" ""  ""     "INSTALL-DISPLAY-MANAGER-MENU-7-I" "MenuTheme[@]" # 7
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # GDM
                    MenuChecks[$((S_OPT - 1))]=1
                    DE_MANAGER="$S_OPT"
                    add_package "$INSTALL_GDM"
                    add_packagemanager "package_install \"$INSTALL_GDM\" 'INSTALL-GDM'" "INSTALL-GDM"
                    # dbus-launch
                    add_package "$INSTALL_GDM_CONTROL"
                    add_packagemanager "package_install \"$INSTALL_GDM_CONTROL\" 'INSTALL-GDM-CONTROL'" "INSTALL-GDM-CONTROL" # One only
                    # gdm3setup https://aur.archlinux.org/packages/gdm3setup/ 
                    #add_aur_package "$AUR_INSTALL_GDM"
                    #add_packagemanager "aur_package_install \"$AUR_INSTALL_GDM\" 'AUR-INSTALL-GDM'" "AUR-INSTALL-GDM"
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
                    S_OPT="$BreakableKey"
                    break
                    ;;
                2)  # KDM
                    MenuChecks[$((S_OPT - 1))]=1
                    DE_MANAGER="$S_OPT"
                    add_package "$INSTALL_KDM"
                    add_packagemanager "package_install \"$INSTALL_KDM\" 'INSTALL-KDM'" "INSTALL-KDM"
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
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
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
                    S_OPT="$BreakableKey"
                    break;
                    ;;
                3)  # Slim
                    MenuChecks[$((S_OPT - 1))]=1
                    DE_MANAGER="$S_OPT"
                    add_package "$INSTALL_SLIM"
                    add_packagemanager "package_install \"$INSTALL_SLIM\" 'INSTALL-SLIM'" "INSTALL-SLIM"
                    add_packagemanager "systemctl enable slim.service" "SYSTEMD-ENABLE-SLIM"
                    S_OPT="$BreakableKey"
                    break
                    ;;
                4)  # LightDM
                    MenuChecks[$((S_OPT - 1))]=1
                    DE_MANAGER="$S_OPT"
                    add_package "$INSTALL_LIGHTDM"
                    add_packagemanager "package_install \"$INSTALL_LIGHTDM\" 'INSTALL-LIGHTDM'" "INSTALL-LIGHTDM"
                    add_packagemanager "copy_file 'gnome-autogen.sh' '/usr/bin/gnome-autogen.sh' \"$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO\"" "INSTALL-LIGHTDM-GNOME"
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        add_aur_package "$AUR_INSTALL_LIGHTDM_KDE"
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_LIGHTDM_KDE\" 'AUR-INSTALL-LIGHTDM-KDE'" "AUR-INSTALL-LIGHTDM-KDE"
                    fi
                    if [[ "$UNITY_INSTALLED" -eq 1 ]]; then
                        add_aur_package "$AUR_INSTALL_LIGHTDM_UNITY"
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_LIGHTDM_UNITY\" 'AUR-INSTALL-LIGHTDM-UNITY'" "AUR-INSTALL-LIGHTDM-UNITY"
                    fi
                    add_aur_package "$AUR_INSTALL_LIGHTDM"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_LIGHTDM\" 'AUR-INSTALL-LIGHTDM'" "AUR-INSTALL-LIGHTDM"
                    add_packagemanager "sed -i 's/#greeter-session=.*\$/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf" "RUN-LIGHTDM"
                    add_packagemanager "systemctl enable lightdm.service" "SYSTEMD-ENABLE-LIGHTDM"
                    if [[ "$XFCE_INSTALLED" -eq 1 ]]; then
                        add_packagemanager "[[ ! -e /usr/bin/gdmflexiserver ]] && ln -s /usr/lib/lightdm/lightdm/gdmflexiserver /usr/bin/gdmflexiserver" "AUR-INSTALL-LIGHTDM-XFCE"
                    fi
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
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
                    S_OPT="$BreakableKey"
                    break
                    ;;
                5)  # LXDM
                    MenuChecks[$((S_OPT - 1))]=1
                    DE_MANAGER="$S_OPT"
                    add_package "$INSTALL_LXDM"
                    add_packagemanager "package_install \"$INSTALL_LXDM\" 'INSTALL-LXDM'" "INSTALL-LXDM"
                    add_packagemanager "systemctl enable lxdm.service" "SYSTEMD-ENABLE-LXDM"
                    add_packagemanager "$(config_xinitrc 'startlxde')" "CONFIG-XINITRC-GNOME"
                    S_OPT="$BreakableKey"
                    break
                    ;;
                6)  # Qingy
                    MenuChecks[$((S_OPT - 1))]=1
                    DE_MANAGER="$S_OPT"
                    add_package "$INSTALL_QINGY"
                    add_packagemanager "package_install \"$INSTALL_QINGY\" 'INSTALL-QINGY'" "INSTALL-QINGY"
                    add_packagemanager "systemctl enable qingy@ttyX" "SYSTEMD-ENABLE-QINGY"
                    S_OPT="$BreakableKey"
                    break
                    ;;
                7)  # XDM
                    MenuChecks[$((S_OPT - 1))]=1
                    DE_MANAGER="$S_OPT"
                    add_package "$INSTALL_XDM"
                    add_packagemanager "package_install \"$INSTALL_XDM\" 'INSTALL-XDM'" "INSTALL-XDM"
                    add_packagemanager "systemctl enable qingy@ttyX" "SYSTEMD-ENABLE-XDM"
                    S_OPT="$BreakableKey"
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
    localize_info "INSTALL-EXTRA-DESC"   "Install Extra"
    localize_info "INSTALL-EXTRA-TITLE"  "Extra's"
    localize_info "INSTALL-EXTRA-INFO-1" "ELEMENTARY PROJECT: Media Player, Sharing service, Screencasting, Contacts manager, RSS feeds Reader, File Manager, Note Taking, Compositing Manager, Email client, Dictionary, Maya Calendar, Web Browser, Audio Player, Text Editor, Dock, App Launcher, Desktop Settings Hub, Indicators Topbar, Elementary Icons, and Elementary Theme."
    localize_info "INSTALL-EXTRA-INFO-2" "Yapan: https://aur.archlinux.org/packages/yapan/ and https://bbs.archlinux.org/viewtopic.php?id=113078"
    localize_info "INSTALL-EXTRA-INFO-3" "Yapan (Yet Another Package mAnager Notifier) — written in C++ and Qt. It shows an icon in the system tray and popup notifications for new packages and supports AUR helpers."
fi
# -------------------------------------
install_extra_menu()
{
    # 13
    local -r menu_name="INSTALL-EXTRA"  # You must define Menu Name here
    local BreakableKey="D"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"        # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-EXTRA-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info  "INSTALL-EXTRA-INFO-1"
        print_info  "INSTALL-EXTRA-INFO-2"
        print_info  "INSTALL-EXTRA-INFO-3"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Elementary Project" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Yapan" "" "$AUR" "Yapan: pacman Update Monitor" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_elementary_project_menu
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_YAPAN"
                    add_packagemanager "package_install \"$INSTALL_YAPAN\" 'INSTALL-YAPAN'" "INSTALL-YAPAN"
                    add_aur_package "$AUR_INSTALL_YAPAN"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_YAPAN\" 'AUR-INSTALL-YAPAN'" "AUR-INSTALL-YAPAN"
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
fi
# -------------------------------------
install_elementary_project_menu()
{
    local -r menu_name="ELEMENTARY-PROJECT"  # You must define Menu Name here
    local BreakableKey="B"                   # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"             # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 1 3 4 10 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-ELEMENTARY-PROJECT-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_error "INSTALL-ELEMENTARY-PROJECT-INFO-1"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Media Player"         "audience-bzr"          "" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Sharing service"      "contractor-bzr"        "" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Screencasting"        "eidete-bzr"            "" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Contacts manager"     "dexter-contacts-bzr"   "" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "RSS feeds Reader"     "feedler-bzr"           "" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "File Manager"         "files-bzr"             "" "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Note Taking"          "footnote-bzr"          "" "" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Compositing Manager"  "gala-bzr"              "" "" "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Email client"         "geary-git"             "" "" "MenuTheme[@]" # 9
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dictionary"           "lingo-dictionary-bzr"  "" "" "MenuTheme[@]" # 10
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Calendar"             "maya-bzr"              "" "" "MenuTheme[@]" # 11
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Web Browser"          "midori"                "" "" "MenuTheme[@]" # 12
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Audio Player"         "noise-bzr"             "" "" "MenuTheme[@]" # 13
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Text Editor"          "scratch-bzr"           "" "" "MenuTheme[@]" # 14
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dock"                 "plank-bzr"             "" "" "MenuTheme[@]" # 15
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Terminal"             "pantheon-terminal-bzr" "" "" "MenuTheme[@]" # 16
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "App Launcher"         "slingshot-bzr"         "" "" "MenuTheme[@]" # 17
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Desktop Settings Hub" "switchboard-bzr"       "" "" "MenuTheme[@]" # 18
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Indicators Topbar"    "wingpanel-bzr"         "" "" "MenuTheme[@]" # 19
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Elementary Icons"     "elementary-icons-bzr"  "" "" "MenuTheme[@]" # 20
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Elementary Theme"     "egtk-bzr"              "" "" "MenuTheme[@]" # 21
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # audience-bzr
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_AUDIENCE" # gtk3
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_AUDIENCE\" 'AUR-INSTALL-EP-AUDIENCE'" "AUR-INSTALL-EP-AUDIENCE"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_CONTRACTOR"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_CONTRACTOR\" 'AUR-INSTALL-EP-CONTRACTOR'" "AUR-INSTALL-EP-CONTRACTOR"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_EIDETE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_EIDETE\" 'AUR-INSTALL-EP-EIDETE'" "AUR-INSTALL-EP-EIDETE"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_DEXTER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_DEXTER\" 'AUR-INSTALL-EP-DEXTER'" "AUR-INSTALL-EP-DEXTER"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_FEEDLER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_FEEDLER\" 'AUR-INSTALL-EP-FEEDLER'" "AUR-INSTALL-EP-FEEDLER"
                    ;;
                6)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_FILES"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_FILES\" 'AUR-INSTALL-EP-FILES'" "AUR-INSTALL-EP-FILES"
                    ;;
                7)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_FOOTNOTE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_FOOTNOTE\" 'AUR-INSTALL-EP-FOOTNOTE'" "AUR-INSTALL-EP-FOOTNOTE"
                    ;;
                8)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_GALA"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_GALA\" 'AUR-INSTALL-EP-GALA'" "AUR-INSTALL-EP-GALA"
                    ;;
                9)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_GEARY"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_GEARY\" 'AUR-INSTALL-EP-GEARY'" "AUR-INSTALL-EP-GEARY"
                    ;;
               10)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_LINGO"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_LINGO\" 'AUR-INSTALL-EP-LINGO'" "AUR-INSTALL-EP-LINGO"
                    ;;
               11)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_MAYA"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_MAYA\" 'AUR-INSTALL-EP-MAYA'" "AUR-INSTALL-EP-MAYA"
                    ;;
               12)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_MIDORI"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_MIDORI\" 'AUR-INSTALL-EP-MIDORI'" "AUR-INSTALL-EP-MIDORI"
                    ;;
               13)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_NOISE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_NOISE\" 'AUR-INSTALL-EP-NOISE'" "AUR-INSTALL-EP-NOISE"
                    ;;
               14)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_SCRATCH"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_SCRATCH\" 'AUR-INSTALL-EP-SCRATCH'" "AUR-INSTALL-EP-SCRATCH"
                    ;;
               15)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_PLANK"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_PLANK\" 'AUR-INSTALL-EP-PLANK'" "AUR-INSTALL-EP-PLANK"
                    ;;
               16)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_PANTHEON"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_PANTHEON\" 'AUR-INSTALL-EP-PANTHEON'" "AUR-INSTALL-EP-PANTHEON"
                    ;;
               17)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_SLINGSHOT"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_SLINGSHOT\" 'AUR-INSTALL-EP-SLINGSHOT'" "AUR-INSTALL-EP-SLINGSHOT"
                    ;;
               18)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_SWITCHBOARD"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_SWITCHBOARD\" 'AUR-INSTALL-EP-SWITCHBOARD" "AUR-INSTALL-EP-SWITCHBOARD"
                    ;;
               19)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_WINGPANEL"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_WINGPANEL\" 'AUR-INSTALL-EP-WINGPANEL'" "AUR-INSTALL-EP-WINGPANEL"
                    ;;
               20)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_ICONS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_ICONS\" 'AUR-INSTALL-EP-ICONS'" "AUR-INSTALL-EP-ICONS"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary" "RUN-GTK_UPDATE"
                    ;;
               21)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EP_EGTK"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EP_EGTK\" 'AUR-INSTALL-EP-EGTK'" "AUR-INSTALL-EP-EGTK"
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
    localize_info "INSTALL-AUDIO-APPS-MENU-1" "Players"
    localize_info "INSTALL-AUDIO-APPS-MENU-2" "Editors | Tools"
    localize_info "INSTALL-AUDIO-APPS-MENU-3" "Codecs"
fi
# -------------------------------------
install_audio_apps_menu()
{
    # 8
    local -r menu_name="AUDIO-APPS"  # You must define Menu Name here
    local BreakableKey="D"           # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-3"   # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-AUDIO-APPS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-AUDIO-APPS-MENU-1" "" "" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-AUDIO-APPS-MENU-2" "" "" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-AUDIO-APPS-MENU-3" "" "" "" "MenuTheme[@]" # 3
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_players_menu
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_audio_editors_menu
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_AUDIO_CODECS"
                    add_packagemanager "package_install \"$INSTALL_AUDIO_CODECS\" 'INSTALL-AUDIO-CODECS'" "INSTALL-AUDIO-CODECS"
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
fi
# -------------------------------------
install_audio_editors_menu()
{
    local -r menu_name="INSTALL-AUDIO-EDITORS"  # You must define Menu Name here
    local BreakableKey="B"                      # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"                # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 2 3 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions 2 3 4 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 2 3 4 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-AUDIO-EDITORS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "soundconverter" "" "" "soundconverter: or soundkonverter Depending on DE" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "puddletag"      "" "" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Audacity"       "" "" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Ocenaudio"      "" "" "" "MenuTheme[@]" # 4
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                           add_package "$INSTALL_SOUNDCONVERTER"
                           add_packagemanager "package_install \"$INSTALL_SOUNDCONVERTER\" 'INSTALL-SOUNDCONVERTER'" "INSTALL-SOUNDCONVERTER"
                        fi
                        add_package "$INSTALL_SOUNDKONVERTER"
                        add_packagemanager "package_install \"$INSTALL_SOUNDKONVERTER\" 'INSTALL-SOUNDKONVERTER'" "INSTALL-SOUNDKONVERTER"
                    else
                        add_package "$INSTALL_SOUNDCONVERTER"
                        add_packagemanager "package_install \"$INSTALL_SOUNDCONVERTER\" 'INSTALL-SOUNDCONVERTER'" "INSTALL-SOUNDCONVERTER"
                     fi
                     ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_PUDDLETAG"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_PUDDLETAG\" 'AUR-INSTALL-PUDDLETAG'" "AUR-INSTALL-PUDDLETAG"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_AUDACITY"
                    add_packagemanager "package_install \"$INSTALL_AUDACITY\" 'INSTALL-AUDACITY'" "INSTALL-AUDACITY"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_OCENAUDIO"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_OCENAUDIO\" 'AUR-INSTALL-OCENAUDIO'" "AUR-INSTALL-OCENAUDIO"
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
# INSTALL PLAYERS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_players_menu"
    USAGE="install_players_menu"
    DESCRIPTION=$(localize "INSTALL-PLAYERS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-PLAYERS-DESC"   "Install Players"
fi
# -------------------------------------
install_players_menu()
{
    local -r menu_name="INSTALL-PLAYERS"  # You must define Menu Name here
    local BreakableKey="B"                # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-5"        # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        #
        print_title "INSTALL-PLAYERS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Amarok"        "" ""     "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Audacious"     "" ""     "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Banshee"       "" ""     "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Clementine"    "" ""     "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dead beef"     "" ""     "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Exaile"        "" "$AUR" "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Musique"       "" "$AUR" "" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Nuvola Player" "" "$AUR" "" "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Rhythmbox"     "" ""     "" "MenuTheme[@]" # 9
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Radio tray"    "" "$AUR" "" "MenuTheme[@]" # 10
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Spotify"       "" "$AUR" "" "MenuTheme[@]" # 11
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Tomahawk"      "" "$AUR" "" "MenuTheme[@]" # 12
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Timidity++"    "" ""     "" "MenuTheme[@]" # 13
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_AMAROK"
                    add_packagemanager "package_install \"$INSTALL_AMAROK\" 'INSTALL-AMAROK'" "INSTALL-AMAROK"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_AUDACIOUS"
                    add_packagemanager "package_install \"$INSTALL_AUDACIOUS\" 'INSTALL-AUDACIOUS'" "INSTALL-AUDACIOUS"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_BANSHEE"
                    add_packagemanager "package_install \"$INSTALL_BANSHEE\" 'INSTALL-BANSHEE'" "INSTALL-BANSHEE"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_CLEMENTINE"
                    add_packagemanager "package_install \"$INSTALL_CLEMENTINE\" 'INSTALL-CLEMENTINE'" "INSTALL-CLEMENTINE"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_DEADBEEF"
                    add_packagemanager "package_install \"$INSTALL_DEADBEEF\" 'INSTALL-DEADBEEF'" "INSTALL-DEADBEEF"
                    ;;
                6)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EXAILE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EXAILE\" 'AUR-INSTALL-EXAILE'" "AUR-INSTALL-EXAILE"
                    ;;
                7)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MUSIQUE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MUSIQUE\" 'AUR-INSTALL-MUSIQUE'" "AUR-INSTALL-MUSIQUE"
                    ;;
                8)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_NUVOLAPLAYER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_NUVOLAPLAYER\" 'AUR-INSTALL-NUVOLAPLAYER" "AUR-INSTALL-NUVOLAPLAYER"
                    ;;
                9)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_RHYTHMBOX"
                    add_packagemanager "package_install \"$INSTALL_RHYTHMBOX\" 'INSTALL-RHYTHMBOX'" "INSTALL-RHYTHMBOX"
                   ;;
               10)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_RADIOTRAY"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_RADIOTRAY\" 'AUR-INSTALL-RADIOTRAY'" "AUR-INSTALL-RADIOTRAY"
                    ;;
               11)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SPOTIFY"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SPOTIFY\" 'AUR-INSTALL-SPOTIFY'" "AUR-INSTALL-SPOTIFY"
                    ;;
               12)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_TOMAHAWK"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_TOMAHAWK\" 'AUR-INSTALL-TOMAHAWK'" "AUR-INSTALL-TOMAHAWK"
                    ;;
               13)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_TIMIDITY"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_TIMIDITY\" 'AUR-INSTALL-TIMIDITY'" "AUR-INSTALL-TIMIDITY"
                    add_packagemanager"echo -e 'soundfont /usr/share/soundfonts/fluidr3/FluidR3GM.SF2' >> /etc/timidity++/timidity.cfg" "RUN-TIMIDITY"
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
    localize_info "INSTALL-OFFICE-APPS-TITLE"     "OFFICE APPS"
    #
    localize_info "INSTALL-OFFICE-APPS-MENU-1"    "LibreOffice"
    localize_info "INSTALL-OFFICE-APPS-MENU-1-I"        "Libre Office - https://wiki.archlinux.org/index.php/LibreOffice"
    localize_info "INSTALL-OFFICE-APPS-MENU-2"    "Caligra or Abiword + Gnumeric"
    localize_info "INSTALL-OFFICE-APPS-MENU-2-I"        "Caligra or Abiword + Gnumeric: Depending on DE"
    localize_info "INSTALL-OFFICE-APPS-MENU-3"    "latex"
    localize_info "INSTALL-OFFICE-APPS-MENU-3-I"        "LATEX - https://wiki.archlinux.org/index.php/LaTeX"
    localize_info "INSTALL-OFFICE-APPS-MENU-4"    "calibre"
    localize_info "INSTALL-OFFICE-APPS-MENU-4-I"        "calibre: "
    localize_info "INSTALL-OFFICE-APPS-MENU-5"    "gcstar"
    localize_info "INSTALL-OFFICE-APPS-MENU-5-I"        "gcstar: "
    localize_info "INSTALL-OFFICE-APPS-MENU-6"    "homebank"
    localize_info "INSTALL-OFFICE-APPS-MENU-6-I"        "homebank: Free, easy, personal accounting for everyone: http://homebank.free.fr/"
    localize_info "INSTALL-OFFICE-APPS-MENU-7"    "impressive"
    localize_info "INSTALL-OFFICE-APPS-MENU-7-I"        "impressive: "
    localize_info "INSTALL-OFFICE-APPS-MENU-8"    "nitrotasks"
    localize_info "INSTALL-OFFICE-APPS-MENU-8-I"        "nitrotasks: "
    localize_info "INSTALL-OFFICE-APPS-MENU-9"    "ocrfeeder"
    localize_info "INSTALL-OFFICE-APPS-MENU-9-I"        "ocrfeeder: "
    localize_info "INSTALL-OFFICE-APPS-MENU-10"   "xmind"
    localize_info "INSTALL-OFFICE-APPS-MENU-10-I"       "xmind: "
    localize_info "INSTALL-OFFICE-APPS-MENU-11"   "zathura"
    localize_info "INSTALL-OFFICE-APPS-MENU-11-I"       "zathura: "
fi
# -------------------------------------
install_office_apps_menu()
{
    # 4
    local -r menu_name="OFFICE-APPS"  # You must define Menu Name here
    local BreakableKey="D"            # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"      # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions 6 7 9 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 6 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-OFFICE-APPS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-1"  "" "" "INSTALL-OFFICE-APPS-MENU-1-I"  "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-2"  "" "" "INSTALL-OFFICE-APPS-MENU-2-I"  "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-3"  "" "" "INSTALL-OFFICE-APPS-MENU-3-I"  "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-4"  "" "" "INSTALL-OFFICE-APPS-MENU-4-I"  "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-5"  "" "" "INSTALL-OFFICE-APPS-MENU-5-I"  "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-6"  "" "" "INSTALL-OFFICE-APPS-MENU-6-I"  "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-7"  "" "" "INSTALL-OFFICE-APPS-MENU-7-I"  "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-8"  "" "" "INSTALL-OFFICE-APPS-MENU-8-I"  "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-9"  "" "" "INSTALL-OFFICE-APPS-MENU-9-I"  "MenuTheme[@]" # 9
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-10" "" "" "INSTALL-OFFICE-APPS-MENU-10-I" "MenuTheme[@]" # 10
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-OFFICE-APPS-MENU-11" "" "" "INSTALL-OFFICE-APPS-MENU-11-I" "MenuTheme[@]" # 11
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # LibreOffice
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_LIBRE_OFFICE"
                    add_packagemanager "package_install \"$INSTALL_LIBRE_OFFICE\" 'INSTALL-LIBRE_OFFICE'" "INSTALL-LIBRE_OFFICE"
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1   ]]; then
                            add_package "$INSTALL_LIBRE_OFFICE_GNOME"
                            add_packagemanager "package_install \"$INSTALL_LIBRE_OFFICE_GNOME\" 'INSTALL-LIBRE-OFFICE-GNOME'" "INSTALL-LIBRE-OFFICE-GNOME"
                        fi
                        add_package "$INSTALL_LIBRE_OFFICE_KDE"
                        add_packagemanager "package_install \"$INSTALL_LIBRE_OFFICE_KDE\" 'INSTALL-LIBRE-OFFICE-KDE'" "INSTALL-LIBRE-OFFICE-KDE"
                    else
                        add_package "$INSTALL_LIBRE_OFFICE_GNOME"
                        add_packagemanager "package_install \"$INSTALL_LIBRE_OFFICE_GNOME\" 'INSTALL-LIBRE-OFFICE-GNOME'" "INSTALL-LIBRE-OFFICE-GNOME"
                    fi
                    ;;
                2)  # Caligra or Abiword + Gnumeric
                    MenuChecks[$((S_OPT - 1))]=1
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                            add_package "$INSTALL_GNUMERIC"
                            add_packagemanager "package_install \"$INSTALL_GNUMERIC\" 'INSTALL-GNUMERIC'" "INSTALL-GNUMERIC"
                        fi
                        add_package "$INSTALL_CALLIGRA"
                        add_packagemanager "package_install \"$INSTALL_CALLIGRA\" 'INSTALL-CALLIGRA'" "INSTALL-CALLIGRA"
                    else
                        add_package "$INSTALL_GNUMERIC"
                        add_packagemanager "package_install \"$INSTALL_GNUMERIC\" 'INSTALL-GNUMERIC'" "INSTALL-GNUMERIC"
                    fi
                    add_aur_package "$AUR_INSTALL_HUNSPELL"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_HUNSPELL\" 'AUR-INSTALL-HUNSPELL'" "AUR-INSTALL-HUNSPELL"
                    add_aur_package "$AUR_INSTALL_ASPELL_LANGUAGE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ASPELL_LANGUAGE\" \"AUR-INSTALL-ASPELL-LANGUAGE\"" "AUR-INSTALL-ASPELL-LANGUAGE"
                    ;;
                3)  # LATEX
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_LATEX"
                    add_packagemanager "package_install \"$INSTALL_LATEX\" 'INSTALL-LATEX'" "INSTALL-LATEX"
                    add_aur_package "$AUR_INSTALL_TEXMAKER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_TEXMAKER\" 'AUR-INSTALL-TEXMAKER'" "AUR-INSTALL-TEXMAKER"
                    if [[ "$LANGUAGE" == "pt_BR" ]]; then
                        add_aur_package "$AUR_INSTALL_ABNTEX"
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_ABNTEX\" 'AUR-INSTALL-ABNTEX'" "AUR-INSTALL-ABNTEX"
                    fi
                    ;;
                4)  # calibre
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_CALIBRE"
                    add_packagemanager "package_install \"$INSTALL_CALIBRE\" 'INSTALL-CALIBRE'" "INSTALL-CALIBRE"
                    ;;
                5)  # gcstar
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GCSTAR"
                    add_packagemanager "package_install \"$INSTALL_GCSTAR\" 'INSTALL-GCSTAR'" "INSTALL-GCSTAR"
                    ;;
                6)  # homebank
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_HOMEBANK"
                    add_packagemanager "package_install \"$INSTALL_HOMEBANK\" 'INSTALL-HOMEBANK'" "INSTALL-HOMEBANK"
                    ;;
                7)  # impressive
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_IMPRESSIVE"
                    add_packagemanager "package_install \"$INSTALL_IMPRESSIVE\" 'INSTALL-IMPRESSIVE'" "INSTALL-IMPRESSIVE"
                    ;;
                8)  # nitrotasks
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_NITROTASKS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_NITROTASKS\" 'AUR-INSTALL-NITROTASKS'" "AUR-INSTALL-NITROTASKS"
                    ;;
                9)  # ocrfeeder
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_OCRFEEDER"
                    add_packagemanager "package_install \"$INSTALL_OCRFEEDER\" 'INSTALL-OCRFEEDER'" "INSTALL-OCRFEEDER"
                    add_aur_package "$AUR_INSTALL_ASPELL_$LANGUAGE_AS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ASPELL_$LANGUAGE_AS\" \"AUR-INSTALL-ASPELL-$LANGUAGE_AS\"" "AUR-INSTALL-ASPELL-$LANGUAGE_AS"
                    ;;
                10)  # xmind
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_XMIND"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_XMIND\" 'AUR-INSTALL-XMIND'" "AUR-INSTALL-XMIND"
                    ;;
                11)  # zathura
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_ZATHURA"
                    add_packagemanager "package_install \"$INSTALL_ZATHURA\" 'INSTALL-ZATHURA'" "INSTALL-ZATHURA"
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
    #
    localize_info "INSTALL-SYSTEM-APPS-MENU-1" "Gparted"
    localize_info "INSTALL-SYSTEM-APPS-MENU-2" "Grsync"
    localize_info "INSTALL-SYSTEM-APPS-MENU-3" "Htop"
    localize_info "INSTALL-SYSTEM-APPS-MENU-4" "Virtualbox"
    localize_info "INSTALL-SYSTEM-APPS-MENU-5" "Webmin"
    localize_info "INSTALL-SYSTEM-APPS-MENU-6" "WINE"
    #
    localize_info "INSTALL-SYSTEM-APPS-MENU-I-1" "Gparted: https://wiki.archlinux.org/index.php/GParted"
    localize_info "INSTALL-SYSTEM-APPS-MENU-I-2" "Grsync: GTK GUI for rsync"
    localize_info "INSTALL-SYSTEM-APPS-MENU-I-3" "Htop: Interactive process viewer"
    localize_info "INSTALL-SYSTEM-APPS-MENU-I-4" "VirtualBox is a virtual PC emulator like VMware - https://wiki.archlinux.org/index.php/VirtualBox"
    localize_info "INSTALL-SYSTEM-APPS-MENU-I-5" "Webmin runs as a service. Using webmin, you can administer other services and server configuration using a web browser, either from the server or remotely. https://wiki.archlinux.org/index.php/Webmin"
    localize_info "INSTALL-SYSTEM-APPS-MENU-I-6" "Wine (originally an acronym for 'Wine Is Not an Emulator') is a compatibility layer capable of running Windows applications on several POSIX-compliant operating systems, such as Linux, Mac OSX, & BSD. https://wiki.archlinux.org/index.php/Wine"
fi
# -------------------------------------
install_system_apps_menu()
{
    # 5
    local -r menu_name="SYSTEM-TOOLS-APPS"  # You must define Menu Name here
    local BreakableKey="D"                  # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"            # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 6 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions 2 3 4 6 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 2 3 4 5 6 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-SYSTEM-APPS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SYSTEM-APPS-MENU-1" "" "" "INSTALL-SYSTEM-APPS-MENU-I-1" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SYSTEM-APPS-MENU-2" "" "" "INSTALL-SYSTEM-APPS-MENU-I-2" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SYSTEM-APPS-MENU-3" "" "" "INSTALL-SYSTEM-APPS-MENU-I-3" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SYSTEM-APPS-MENU-4" "" "" "INSTALL-SYSTEM-APPS-MENU-I-4" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SYSTEM-APPS-MENU-5" "" "" "INSTALL-SYSTEM-APPS-MENU-I-5" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-SYSTEM-APPS-MENU-6" "" "" "INSTALL-SYSTEM-APPS-MENU-I-6" "MenuTheme[@]" # 6
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GPARTED"
                    add_packagemanager "package_install \"$INSTALL_GPARTED\" 'INSTALL-GPARTED'" "INSTALL-GPARTED"
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GRSYNC"
                    add_packagemanager "package_install \"$INSTALL_GRSYNC\" 'INSTALL-GRSYNC'" "INSTALL-GRSYNC"
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_HTOP"
                    add_packagemanager "package_install \"$INSTALL_HTOP\" 'INSTALL-HTOP'" "INSTALL-HTOP"
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_VIRTUALBOX"
                    add_packagemanager "package_install \"$INSTALL_VIRTUALBOX\" 'INSTALL-VIRTUALBOX'" "INSTALL-VIRTUALBOX"
                    add_aur_package "$AUR_INSTALL_VIRTUALBOX_EXT_ORACLE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_VIRTUALBOX_EXT_ORACLE\" 'AUR-INSTALL-VIRTUALBOX-EXT-ORACLE'" "AUR-INSTALL-VIRTUALBOX-EXT-ORACLE"
                    add_module "vboxdrv" "MODULE-VIRTUALBOX"
                    add_packagemanager "systemctl enable vboxservice.service" "SYSTEMD-ENABLE-VIRTUALBOX"
                    add_packagemanager "add_user_2_group 'vboxusers'" "GROUPADD-VBOXUSERS"
                    ;;
                5)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_WEBMIN"
                    add_packagemanager "package_install \"$INSTALL_WEBMIN\" 'INSTALL-WEBMIN'" "INSTALL-WEBMIN"
                    add_packagemanager "systemctl enable webmin.service" "SYSTEMD-ENABLE-WEBMIN"
                    ;;
                6)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_WINE"
                    add_packagemanager "package_install \"$INSTALL_WINE\" 'INSTALL-WINE'" "INSTALL-WINE"
                    if [[ "$ARCHI" == "x86_64" ]]; then
                        if [[ "$VIDEO_CARD" -eq 1 ]]; then    # nVidia for WINE
                            add_package "$INSTALL_WINE_NVIDIA"
                            add_packagemanager "package_install \"$INSTALL_WINE_NVIDIA\" 'INSTALL-WINE-NVIDIA'" "INSTALL-WINE-NVIDIA"
                        elif [[ "$VIDEO_CARD" -eq 2 ]]; then  # Nouveau
                            add_package "$INSTALL_WINE_NOUVEAU"
                            add_packagemanager "package_install  \"$INSTALL_WINE_NOUVEAU\" 'INSTALL-WINE-NOUVEAU'" "INSTALL-WINE-NOUVEAU"
                        elif [[ "$VIDEO_CARD" -eq 3 ]]; then  # Intel
                            add_package "$INSTALL_WINE_INTEL"
                            add_packagemanager "package_install \"$INSTALL_WINE_INTEL\" 'INSTALL-WINE-INTEL'" "INSTALL-WINE-INTEL"
                        elif [[ "$VIDEO_CARD" -eq 4 ]]; then  # ATI
                            add_package "$INSTALL_WINE_ATI"
                            add_packagemanager "package_install \"$INSTALL_WINE_ATI\" 'INSTALL-WINE-ATI'" "INSTALL-WINE-ATI"
                        fi
                        add_package "$INSTALL_WINE_ALSA"
                        add_packagemanager "package_install \"$INSTALL_WINE_ALSA\" 'INSTALL-WINE-ALSA'" "INSTALL-WINE-ALSA"
                    fi
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
    DESCRIPTION=$(localize "INSTALL-DE-EXTRAS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-DE-EXTRAS-DESC"  "Install DE Extras"
    localize_info "INSTALL-DE-EXTRAS-TITLE" "Gnome Desktop Environments Extras"
    #
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-1"    "GNOME Icons"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-1-I"      "GNOME Icons: awoken-icons faenza-icon-theme faenza-cupertino-icon-theme faience-icon-theme elementary-icons-bzr"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-2"    "GTK Themes"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-2-I"      "GTK Themes: gtk-theme-adwaita-cupertino gtk-theme-boomerang xfce-theme-blackbird xfce-theme-bluebird egtk-bzr xfce-theme-greybird light-themes orion-gtk-theme zukini-theme zukitwo-themes"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-3"    "Unity"
    localize_info "INSTALL-DESKTOP-ENVIRONMENT-MENU-3-I"      "Unity: Unity is an alternative shell for the GNOME desktop environment, developed by Canonical in its Ayatana project. It consists of several components including the Launcher, Dash, lenses, Panel, indicators, Notify OSD and Overlay Scrollbar. Unity used to available in two implementations: 'Unity' is the 3D accelerated version, which uses Compiz window manager and Nux toolkit; and 'Unity 2D' is a lighter alternative, which uses Metacity window manager and Qt toolkit. Unity 2D is already dropped by Canonical from Ubuntu 12.10."
fi
# -------------------------------------
install_gnome_de_extras_menu()
{
    # 11
    local -r menu_name="INSTALL-DE-EXTRAS"  # You must define Menu Name here
    local BreakableKey="B"                  # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 2"          # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    local -a MenuThemeWarn=( "${BRed}" "${White}" ")" )
    #
    while [[ 1 ]]; do
        print_title "INSTALL-DE-EXTRAS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-ENVIRONMENT-MENU-1" "" "$AUR" "INSTALL-DESKTOP-ENVIRONMENT-MENU-1-I" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-ENVIRONMENT-MENU-2" "" "$AUR" "INSTALL-DESKTOP-ENVIRONMENT-MENU-2-I" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DESKTOP-ENVIRONMENT-MENU-3" "" "$AUR" "INSTALL-DESKTOP-ENVIRONMENT-MENU-3-I" "MenuThemeWarn[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_icons_menu
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_gtk_themes_menu
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_unity_now
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
fi
# -------------------------------------
install_gtk_themes_menu() 
{ 
    # 11 sub 2
    local -r menu_name="INSTALL-GTK-THEMES"  # You must define Menu Name here
    local BreakableKey="D"                   # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-10"          # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-GTK-THEMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Adwaita Cupertino" "" "" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Boomerang"         "" "" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Blackbird"         "" "" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Bluebird"          "" "" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "eGTK"              "" "" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Greybird"          "" "" "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Light"             "" "" "Light: aka Ambiance/Radiance" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Orion"             "" "" "" "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Zukini"            "" "" "" "MenuTheme[@]" # 9
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Zukitwo"           "" "" "" "MenuTheme[@]" # 10
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_ADWAITA"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_ADWAITA\" 'AUR-INSTALL-GTK-THEMES-ADWAITA'" "AUR-INSTALL-GTK-THEMES-ADWAITA"
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_BOOMERANG"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_BOOMERANG\" 'AUR-INSTALL-GTK-THEMES-BOOMERANG'" "AUR-INSTALL-GTK-THEMES-BOOMERANG"
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_BLACKBIRD"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_BLACKBIRD\" 'AUR-INSTALL-GTK-THEMES-BLACKBIRD'" "AUR-INSTALL-GTK-THEMES-BLACKBIRD"
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_BLUEBIRD"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_BLUEBIRD\" 'AUR-INSTALL-GTK-THEMES-BLUEBIRD'" "AUR-INSTALL-GTK-THEMES-BLUEBIRD"
                    ;;
                5)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_EGTK"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_EGTK\" 'AUR-INSTALL-GTK-THEMES-EGTK'" "AUR-INSTALL-GTK-THEMES-EGTK"
                    ;;
                6)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_XFCE_GREYBIRD"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_XFCE_GREYBIRD\" 'AUR-INSTALL-GTK-THEMES-XFCE-GREYBIRD'" "AUR-INSTALL-GTK-THEMES-XFCE-GREYBIRD"
                    ;;
                7)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_LIGHT_THEMES"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_LIGHT_THEMES\" 'AUR-INSTALL-GTK-THEMES-LIGHT-THEMES'" "AUR-INSTALL-GTK-THEMES-LIGHT-THEMES"
                    ;;
                8)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_ORION"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_ORION\" 'AUR-INSTALL-GTK-THEMES-ORION'" "AUR-INSTALL-GTK-THEMES-ORION"
                    ;;
                9)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_ZUKINI"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_ZUKINI\" 'AUR-INSTALL-GTK-THEMES-ZUKINI'" "AUR-INSTALL-GTK-THEMES-ZUKINI"
                    ;;
               10)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GTK_THEMES_ZUKITWO"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GTK_THEMES_ZUKITWO\" 'AUR-INSTALL-GTK-THEMES-ZUKITWO'" "AUR-INSTALL-GTK-THEMES-ZUKITWO"
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
fi
# -------------------------------------
install_icons_menu() 
{ 
    # 11 sub 1
    local -r menu_name="INSTALL-ICONS"  # You must define Menu Name here
    local BreakableKey="D"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-6"      # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    add_package "$INSTALL_GTK_ICONS"
    add_packagemanager "package_install \"$INSTALL_GTK_ICONS\" 'INSTALL-GTK-ICONS'" "INSTALL-GTK-ICONS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-ICONS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Awoken"           "" "" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Faenza"           "" "" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Faenza-Cupertino" "" "" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Faience"          "" "" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Elementary"       "" "" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Nitrux"           "" "" "" "MenuTheme[@]" # 6
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_ICONS_AWOKEN"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_AWOKEN\" 'AUR-INSTALL-GNOME-ICONS-AWOKEN'" "AUR-INSTALL-GNOME-ICONS-AWOKEN"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/AwOken" "RUN-GTK-ICONS-1"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/AwOken-Dark" "RUN-GTK-ICONS-2"
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_ICONS_FAENZA"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_FAENZA\" 'AUR-INSTALL-GNOME-ICONS-FAENZA'" "AUR-INSTALL-GNOME-ICONS-FAENZA"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza" "RUN-GTK-ICONS-3"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Dark" "RUN-GTK-ICONS-4"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Darker" "RUN-GTK-ICONS-5"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Darkest" "RUN-GTK-ICONS-6"
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_ICONS_FEANZA_CUPERTINO"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_FEANZA_CUPERTINO\" 'AUR-INSTALL-GNOME-ICONS-FEANZA-CUPERTINO'" "AUR-INSTALL-GNOME-ICONS-FEANZA-CUPERTINO"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino" "RUN-GTK-ICONS-7"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino-Dark" "RUN-GTK-ICONS-8"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino-Darker" "RUN-GTK-ICONS-9"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faenza-Cupertino-Darkest" "RUN-GTK-ICONS-10"
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_ICONS_FAIENCE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_FAIENCE\" 'AUR-INSTALL-GNOME-ICONS-FAIENCE'" "AUR-INSTALL-GNOME-ICONS-FAIENCE"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience" "RUN-GTK-ICONS-11"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience-Azur" "RUN-GTK-ICONS-12"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience-Claire" "RUN-GTK-ICONS-13"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/Faience-Ocre" "RUN-GTK-ICONS-14"
                    ;;
                5)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_ICONS_ELEMENTARY"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_ELEMENTARY\" 'AUR-INSTALL-GNOME-ICONS-ELEMENTARY'" "AUR-INSTALL-GNOME-ICONS-ELEMENTARY"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary" "RUN-GTK-ICONS-15"
                    #
                    read_input_yn "INSTALL-ICONS-INFO-1" " " 1 # Allow Bypass
                    if [[ "$YN_OPTION" -eq 1 ]]; then
                        add_aur_package "$AUR_INSTALL_GNOME_ICONS_ELEMENTARY_XFCE"
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_ELEMENTARY_XFCE\" 'AUR-INSTALL-GNOME-ICONS-ELEMENTARY-XFCE'" "AUR-INSTALL-GNOME-ICONS-ELEMENTARY-XFCE"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary-xfce" "RUN-GTK-ICONS-16"
                        add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/elementary-xfce-dark" "RUN-GTK-ICONS-17"
                    fi
                    ;;
                6)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_ICONS_NITRUX"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_ICONS_NITRUX\" 'AUR-INSTALL-GNOME-ICONS-NITRUX'" "AUR-INSTALL-GNOME-ICONS-NITRUX"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX" "RUN-GTK-ICONS-18"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-BTN" "RUN-GTK-ICONS-19"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-BTN-blufold" "RUN-GTK-ICONS-20"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-C" "RUN-GTK-ICONS-21"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-DRK" "RUN-GTK-ICONS-22"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-G" "RUN-GTK-ICONS-23"
                    add_packagemanager "gtk-update-icon-cache -f /usr/share/icons/NITRUX-G-lightpnl" "RUN-GTK-ICONS-24"
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
    DESCRIPTION=$(localize "INSTALL-DUNGEON-GAMES-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-DUNGEON-GAMES-DESC"   "Install Games"
    localize_info "INSTALL-DUNGEON-GAMES-TITLE"  "GAMES"
fi
# -------------------------------------
install_games_menu()
{
    # 10
    local -r menu_name="INSTALL-GAMES"  # You must define Menu Name here
    local BreakableKey="D"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="12"       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 1-14 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 14 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-DUNGEON-GAMES-TITLE" " - https://wiki.archlinux.org/index.php/Games"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Action | Adventure"  "" "" "Action | Adventure"  "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Arcade | Platformer" "" "" "Arcade | Platformer" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dungeon"           "" "" "Dungeon"           "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Emulators"         "" "" "Emulators"         "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "FPS"               "" "" "FPS: First Person Shooter" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "MMO"               "" "" "MMO"               "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Puzzle"            "" "" "Puzzle"            "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "RPG"               "" "" "RPG"               "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Racing"            "" "" "Racing"            "MenuTheme[@]" # 9
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Simulation"        "" "" "Simulation"        "MenuTheme[@]" # 10
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Strategy"          "" "" "Strategy"          "MenuTheme[@]" # 11
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Gnome"             "" "" "Gnome: $INSTALL_GNOME_GAMES" "MenuTheme[@]" # 12
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "KDE"               "" "" "KDE: $INSTALL_KDE_GAMES"     "MenuTheme[@]" # 13
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Misc"              "" "" "Misc: $INSTALL_MISC_GAMES"   "MenuTheme[@]" # 14
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_action_games_menu
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_arade_games_menu
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_dungon_games_menu
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_emulator_games_menu
                    ;;
                5)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_fps_games_menu
                    ;;
                6)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_mmo_games_menu
                    ;;
                7)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_puzzle_games_menu
                    ;;
                8)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_rpg_games_menu
                    ;;
                9)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_racing_games_menu
                    ;;
                10)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_simulation_games_menu
                    ;;
                11)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_strategy_games_menu
                    ;;
                12)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GNOME_GAMES"
                    add_packagemanager "package_install \"$INSTALL_GNOME_GAMES\" 'INSTALL-GNOME-GAMES'" "INSTALL-GNOME-GAMES"
                    ;;
                13)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_KDE_GAMES"
                    add_packagemanager "package_install \"$INSTALL_KDE_GAMES\" 'INSTALL-KDE-GAMES'" "INSTALL-KDE-GAMES"
                    ;;
                14)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_MISC_GAMES"
                    add_packagemanager "package_install \"$INSTALL_MISC_GAMES\" 'INSTALL-MISC-GAMES'" "INSTALL-MISC-GAMES"
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
    localize_info "INSTALL-ACTION-GAMES-DESC"               "Install Action/Adventure Games"
    localize_info "INSTALL-ACTION-GAMES-TITLE"              "Install Action/Adventure Games"
fi
# -------------------------------------
install_action_games_menu()
{
    local -r menu_name="ACTION-ADVENTURE-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                       # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"                 # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-ACTION-GAMES-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Astromenace"           "" ""     "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Counter-Strike 2D"     "" "$AUR" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dead Cyborg Episode 1" "" "$AUR" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "M.A.R.S. Shooter"      "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Nikki"                 "" "$AUR" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "opentyrian-hg"         "" "$AUR" "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Sonic Robot Blast 2"   "" "$AUR" "" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Steelstorm"            "" "$AUR" "" "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Yo Frankie!"           "" "$AUR" "" "MenuTheme[@]" # 9
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_ASTROMENANCE"
                    add_packagemanager "package_install \"$INSTALL_ASTROMENANCE\" 'INSTALL-ASTROMENANCE'" "INSTALL-ASTROMENANCE"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_COUNTER_STRIKE_2D"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_COUNTER_STRIKE_2D\" 'AUR-INSTALL-COUNTER-STRIKE-2D'" "AUR-INSTALL-COUNTER-STRIKE-2D"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DEAD_CYBORG_EP_1"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DEAD_CYBORG_EP_1\" 'AUR-INSTALL-DEAD-CYBORG-EP-1'" "AUR-INSTALL-DEAD-CYBORG-EP-1"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MARS_SHOOTER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MARS_SHOOTER\" 'AUR-INSTALL-MARS-SHOOTER'" "AUR-INSTALL-MARS-SHOOTER"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_NIKKI"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_NIKKI\" 'AUR-INSTALL-NIKKI'" "AUR-INSTALL-NIKKI"
                    ;;
                6)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_OPENTYRIAN"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_OPENTYRIAN\" 'AUR-INSTALL-OPENTYRIAN'" "AUR-INSTALL-OPENTYRIAN"
                    ;;
                7)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SRB2"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SRB2\" 'AUR-INSTALL-SRB2" "AUR-INSTALL-SRB2"
                    ;;
                8)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_STEELSTORM"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_STEELSTORM\" 'AUR-INSTALL-STEELSTORM'" "AUR-INSTALL-STEELSTORM"
                    ;;
                9)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_YOFRANKIE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_YOFRANKIE\" 'AUR-INSTALL-YOFRANKIE'" "AUR-INSTALL-YOFRANKIE"
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
fi
# -------------------------------------
install_arade_games_menu()
{
    local -r menu_name="INSTALL-ARCADE-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                     # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 11"            # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 1-12 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions 1 2 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 1 2 11 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-ARCADE-GAMES-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Abuse"                  "" ""     "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Battle Tanks"           "" ""     "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Bomberclone"            "" ""     "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Those Funny Funguloids" "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Frogatto"               "" ""     "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Goonies"                "" "$AUR" "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Mari0"                  "" "$AUR" "" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Neverball"              "" ""     "" "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Opensonic"              "" "$AUR" "" "MenuTheme[@]" # 9
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Robombs"                "" "$AUR" "" "MenuTheme[@]" # 10
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Super Mario Chronicles" "" ""     "" "MenuTheme[@]" # 11
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Xmoto"                  "" ""     "" "MenuTheme[@]" # 12
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # Abuse
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_ABUSE"
                    add_packagemanager "package_install \"$INSTALL_ABUSE\" 'INSTALL-ABUSE'" "INSTALL-ABUSE"
                    ;;
                2)  # Battle Tanks
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_BTANKS"
                    add_packagemanager "package_install \"$INSTALL_BTANKS\" 'INSTALL-BTANKS'" "INSTALL-BTANKS"
                    ;;
                3)  # Bomberclone
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_BOMBERCLONE"
                    add_packagemanager "package_install \"$INSTALL_BOMBERCLONE\" 'INSTALL-BOMBERCLONE'" "INSTALL-BOMBERCLONE"
                    ;;
                4)  # Those Funny Funguloids
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_FUNGULOIDS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_FUNGULOIDS\" 'AUR-INSTALL-FUNGULOIDS'" "AUR-INSTALL-FUNGULOIDS"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_FROGATTO"
                    add_packagemanager "package_install \"$INSTALL_FROGATTO\" 'INSTALL-FROGATTO'" "INSTALL-FROGATTO"
                    ;;
                6)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GOONIES"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GOONIES\" 'AUR-INSTALL-GOONIES'" "AUR-INSTALL-GOONIES"
                    ;;
                7)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MARI0"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MARI0\" 'AUR-INSTALL-MARI0'" "AUR-INSTALL-MARI0"
                    ;;
                8)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_NEVERBALL"
                    add_packagemanager "package_install \"$INSTALL_NEVERBALL\" 'INSTALL-NEVERBALL'" "INSTALL-NEVERBALL"
                    ;;
                9)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_OPENSONIC"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_OPENSONIC\" 'AUR-INSTALL-OPENSONIC'" "AUR-INSTALL-OPENSONIC"
                    ;;
               10)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ROBOMBS_BIN"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ROBOMBS_BIN\" 'AUR-INSTALL-ROBOMBS-BIN'" "AUR-INSTALL-ROBOMBS-BIN"
                    ;;
               11)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_SMC"
                    add_packagemanager "package_install \"$INSTALL_SMC\" 'INSTALL-SMC'" "INSTALL-SMC"
                    ;;
               12)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_XMOTO"
                    add_packagemanager "package_install \"$INSTALL_XMOTO\" 'INSTALL-XMOTO'" "INSTALL-XMOTO"
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
fi
# -------------------------------------
install_dungon_games_menu()
{
    local -r menu_name="INSTALL-DUNGEON-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                      # Q=Quit, D=Done, B=Back
    local RecommendedOptions="5"       # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 1-5 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-DUNGEON-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Adom"             "" "$AUR" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Tales of MajEyal" "" "$AUR" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Lost Labyrinth"   "" "$AUR" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "S.C.O.U.R.G.E."   "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Stone-Soupe"      "" ""     "" "MenuTheme[@]" # 5
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ADOM"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ADOM\" 'AUR-INSTALL-ADOM'" "AUR-INSTALL-ADOM"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_TOME4"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_TOME4\" 'AUR-INSTALL-TOME4'" "AUR-INSTALL-TOME4"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_LOST_LABYRINTH"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_LOST_LABYRINTH\" 'AUR-INSTALL-LOST-LABYRINTH'" "AUR-INSTALL-LOST-LABYRINTH"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SCOURGE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SCOURGE\" 'AUR-INSTALL-SCOURGE'" "AUR-INSTALL-SCOURGE"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_STONE_SOUP"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_STONE_SOUP\" 'AUR-INSTALL-STONE-SOUP'" "AUR-INSTALL-STONE-SOUP"
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
fi
# -------------------------------------
install_emulator_games_menu()
{
    local -r menu_name="INSTALL-EMULATORS-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                        # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""                   # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 1-8 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-EMULATORS-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "BSNES"               "" "$AUR" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Desmume-svn"         "" "$AUR" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dolphin"             "" "$AUR" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Epsxe"               "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Project 64"          "" "$AUR" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Visual Boy Advanced" "" "$AUR" "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "wxmupen64plus"       "" "$AUR" "" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "zsnes"               "" ""     "" "MenuTheme[@]" # 8
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_BSMES"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_BSMES\" 'AUR-INSTALL-BSMES'" "AUR-INSTALL-BSMES"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DESMUME"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DESMUME\" 'AUR-INSTALL-DESMUME'" "AUR-INSTALL-DESMUME"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DOLPHIN"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DOLPHIN\" 'AUR-INSTALL-DOLPHIN'" "AUR-INSTALL-DOLPHIN"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_EPSXE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_EPSXE\" 'AUR-INSTALL-EPSXE'" "AUR-INSTALL-EPSXE"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_PROJECT_64"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_PROJECT_64\" 'AUR-INSTALL-PROJECT-64'" "AUR-INSTALL-PROJECT-64"
                    ;;
                6)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_VBA"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_VBA\" 'AUR-INSTALL-VBA'" "AUR-INSTALL-VBA"
                    ;;
                7)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_WXMUPEN64PLUS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_WXMUPEN64PLUS\" 'AUR-INSTALL-WXMUPEN64PLUS'" "AUR-INSTALL-WXMUPEN64PLUS"
                    ;;
                8)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_ZSNES"
                    add_packagemanager "package_install \"$INSTALL_ZSNES\" 'INSTALL-ZSNES'" "INSTALL-ZSNES"
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
fi
# -------------------------------------
install_fps_games_menu()
{
    local -r menu_name="INSTALL-FPS-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                  # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""             # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 1-5 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-FPS-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Alienarena"      "" "" ""  "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Warsow"          "" "" ""  "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Wolfenstein"     "" "$AUR" "Wolfenstein: Enemy Territory" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "World of Padman" "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Xonotic"         "" ""     "" "MenuTheme[@]" # 5
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_ALIENARENA"
                    add_packagemanager "package_install \"$INSTALL_ALIENARENA\" 'INSTALL-ALIENARENA'" "INSTALL-ALIENARENA"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_WARSOW"
                    add_packagemanager "package_install \"$INSTALL_WARSOW\" 'INSTALL-WARSOW'" "INSTALL-WARSOW"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ENEMY_TERRITORY"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ENEMY_TERRITORY\" 'AUR-INSTALL-ENEMY-TERRITORY'" "AUR-INSTALL-ENEMY-TERRITORY"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_WORLD_OF_PADMAN"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_WORLD_OF_PADMAN\" 'AUR-INSTALL-WORLD-OF-PADMAN'" "AUR-INSTALL-WORLD-OF-PADMAN"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_XONOTIC"
                    add_packagemanager "package_install \"$INSTALL_XONOTIC\" 'INSTALL-XONOTIC'" "INSTALL-XONOTIC"
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
fi
# -------------------------------------
install_mmo_games_menu()
{
    local -r menu_name="INSTALL-MMO-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                  # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""             # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 1-6 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-MMO-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Heroes of Newerth" "" "$AUR" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Manaplus"          "" "$AUR" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Runescape"         "" "$AUR" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Savage 2"          "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Spiral Knights"    "" "$AUR" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Wakfu"             "" "$AUR" "" "MenuTheme[@]" # 6
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_HON"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_HON\" 'AUR-INSTALL-HON'" "AUR-INSTALL-HON"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MANAPLUS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MANAPLUS\" 'AUR-INSTALL-MANAPLUS'" "AUR-INSTALL-MANAPLUS"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_RUNESCAPE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_RUNESCAPE\" 'AUR-INSTALL-RUNESCAPE'" "AUR-INSTALL-RUNESCAPE"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SAVAGE_2"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SAVAGE_2\" 'AUR-INSTALL-SAVAGE-2'" "AUR-INSTALL-SAVAGE-2"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SPIRAL_KNIGHTS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_KNIGHTS\" 'AUR-INSTALL-SPIRAL-KNIGHTS'" "AUR-INSTALL-SPIRAL-KNIGHTS"
                    ;;
                6)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_WAKFU"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_WAKFU\" 'AUR-INSTALL-WAKFU'" "AUR-INSTALL-WAKFU"
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
fi
# -------------------------------------
install_puzzle_games_menu()
{
    local -r menu_name="INSTALL-PUZZLE-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                     # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"               # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 1-2 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-PUZZLE-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "frozen-bubble" "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Numptyphysics" "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_FROZEN_BUBBLE"
                    add_packagemanager "package_install \"$INSTALL_FROZEN_BUBBLE\" 'INSTALL-FROZEN-BUBBLE'" "INSTALL-FROZEN-BUBBLE"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_NUMPTYPHYSICS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_NUMPTYPHYSICS\" 'AUR-INSTALL-NUMPTYPHYSICS'" "AUR-INSTALL-NUMPTYPHYSICS"
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
fi
# -------------------------------------
install_rpg_games_menu()
{
    local -r menu_name="INSTALL-RPG-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                  # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""             # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 1-3 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-RPG-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Ardentryst"    "" "$AUR" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Flare RPG"     "" "$AUR" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Freedroid RPG" "" ""     "" "MenuTheme[@]" # 3
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ARDENTRYST"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ARDENTRYST\" 'AUR-INSTALL-ARDENTRYST'" "AUR-INSTALL-ARDENTRYST"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_FLARE_RPG"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_FLARE_RPG\" 'AUR-INSTALL-FLARE-RPG'" "AUR-INSTALL-FLARE-RPG"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_FREEDROUDRPG"
                    add_packagemanager "package_install \"$INSTALL_FREEDROUDRPG\" 'INSTALL-FREEDROUDRPG'" "INSTALL-FREEDROUDRPG"
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
fi
# -------------------------------------
install_racing_games_menu()
{
    local -r menu_name="INSTALL-RACING-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                     # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""                # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 1-5 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 5 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-RACING-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Maniadrive"   "" "$AUR" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Death Rally"  "" "$AUR" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Stun Trally"  "" "$AUR" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Supertuxkart" "" ""     "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Speed Dreams" "" ""     "" "MenuTheme[@]" # 5
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MANIADRIVE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MANIADRIVE\" 'AUR-INSTALL-MANIADRIVE'" "AUR-INSTALL-MANIADRIVE"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DEATH_RALLY"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DEATH_RALLY\" 'AUR-INSTALL-DEATH-RALLY'" "AUR-INSTALL-DEATH-RALLY"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_STUNTRALLY"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_STUNTRALLY\" 'AUR-INSTALL-STUNTRALLY'" "AUR-INSTALL-STUNTRALLY"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_SUPTERTUXKART"
                    add_packagemanager "package_install \"$INSTALL_SUPTERTUXKART\" 'INSTALL-SUPTERTUXKART'" "INSTALL-SUPTERTUXKART"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_SPEED_DREAMS"
                    add_packagemanager "package_install \"$INSTALL_SPEED_DREAMS\" 'INSTALL-SPEED-DREAMS'" "INSTALL-SPEED-DREAMS"
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
fi
# -------------------------------------
install_simulation_games_menu()
{
    local -r menu_name="INSTALL-SIMULATION-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                         # Q=Quit, D=Done, B=Back
    local RecommendedOptions="3"                   # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 1 2 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 1 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-SIMULATION-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Simutrans"      ""     "" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Theme Hospital" "$AUR" "" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Openttd"        ""     "" "" "MenuTheme[@]" # 3
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_SIMUTRANS"
                    add_packagemanager "package_install \"$INSTALL_SIMUTRANS\" 'INSTALL-SIMUTRANS'" "INSTALL-SIMUTRANS"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_CORSIX_TH"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_CORSIX_TH\" 'AUR-INSTALL-CORSIX-TH'" "AUR-INSTALL-CORSIX-TH"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_OPENTTD"
                    add_packagemanager "package_install \"$INSTALL_OPENTTD\" 'INSTALL-OPENTTD'" "INSTALL-OPENTTD"
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
fi
# -------------------------------------
install_strategy_games_menu()
{
    local -r menu_name="INSTALL-STRATEGY-GAMES"  # You must define Menu Name here
    local BreakableKey="B"                       # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""                  # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 1-7 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-STRATEGY-GAMES-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "0ad"              "" ""     "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dedgewars"        "" ""     "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Megaglest"        "" ""     "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Unknown-horizons" "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Warzone2100"      "" ""     "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Wesnoth"          "" ""     "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Zod"              "" "$AUR" "" "MenuTheme[@]" # 7
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_0AD"
                    add_packagemanager "package_install \"$INSTALL_0AD\" 'INSTALL-0AD'" "INSTALL-0AD"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_HEDGEWARS"
                    add_packagemanager "package_install \"$INSTALL_HEDGEWARS\" 'INSTALL-HEDGEWARS'" "INSTALL-HEDGEWARS"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_MEGAGLEST"
                    add_packagemanager "package_install \"$INSTALL_MEGAGLEST\" 'INSTALL-MEGAGLEST'" "INSTALL-MEGAGLEST"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_UNKNOW_HORIZONS"
                    add_packagemanager "package_install \"$INSTALL_UNKNOW_HORIZONS\" 'INSTALL-UNKNOW-HORIZONS'" "INSTALL-UNKNOW-HORIZONS"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_WARZONE2100"
                    add_packagemanager "package_install \"$INSTALL_WARZONE2100\" 'INSTALL-WARZONE2100'" "INSTALL-WARZONE2100"
                    ;;
                6)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_WESNOTH"
                    add_packagemanager "package_install \"$INSTALL_WESNOTH\"  'INSTALL-WESNOTH'" "INSTALL-WESNOTH"
                    ;;
                7)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_COMMANDER_ZOD"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_COMMANDER_ZOD\" 'AUR-INSTALL-COMMANDER-ZOD'" "AUR-INSTALL-COMMANDER-ZOD"
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
    localize_info "INSTALL-WEB-SERVER-MENU-1" "LAMP - APACHE, MYSQL & PHP + ADMINER"
    localize_info "INSTALL-WEB-SERVER-MENU-2" "LAPP - APACHE, POSTGRESQL & PHP + ADMINER"
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
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}" "${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        #
        print_title "INSTALL-WEB-SERVER-TITLE" " - https://wiki.archlinux.org/index.php/LAMP|LAPP"
        print_caution "${StatusBar1}" "${StatusBar2}"
        #
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-WEB-SERVER-MENU-1" "" "" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-WEB-SERVER-MENU-2" "" "" "" "MenuTheme[@]" # 2
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    WEBSERVER="$S_OPT"
                    add_package "$INSTALL_WEB_SERVER_1"
                    add_packagemanager "package_install \"$INSTALL_WEB_SERVER_1\" 'INSTALL-WEB-SERVER-1'" "INSTALL-WEB-SERVER-1"
                    add_aur_package "$AUR_INSTALL_ADMINER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ADMINER\" 'AUR-INSTALL-ADMINER'" "AUR-INSTALL-ADMINER" # if you add something, change this name
                    add_packagemanager "systemctl enable httpd.service mysqld.service" "SYSTEMD-ENABLE-WEBSERVER-1"
                    add_packagemanager "systemctl start mysqld.service" "SYSTEMD-START-MYSQL"
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    WEBSERVER="$S_OPT"
                    add_package "$INSTALL_WEB_SERVER_2" 
                    add_packagemanager "package_install \"$INSTALL_WEB_SERVER_2\" 'INSTALL-WEB-SERVER-2'" "INSTALL-WEB-SERVER-2"
                    add_aur_package "$AUR_INSTALL_ADMINER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ADMINER\" 'AUR-INSTALL-ADMINER'" "AUR-INSTALL-ADMINER" # if you add something, change this name
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
    localize_info "INSTALL-FONTS-MENU-2-I" "ttf-google-webfonts Note: Removes: ttf-droid ttf-roboto ttf-ubuntu-font-family"
    localize_info "INSTALL-FONTS-MENU-8-I" "wqy-microhei: Chinese/Japanese/Korean Support"
fi
# -------------------------------------
install_fonts_menu()
{
    # 12
    local -r menu_name="INSTALL-FONTS"  # You must define Menu Name here
    local BreakableKey="D"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 5-7"    # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-FONTS-DESC" " - https://wiki.archlinux.org/index.php/Fonts"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-dejavu"           "" ""     "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-google-webfonts"  "" "$AUR" "INSTALL-FONTS-MENU-2-I" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-funfonts"         "" ""     "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-kochi-substitute" "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-liberation"       "" ""     "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-ms-fonts"         "" ""     "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "ttf-vista-fonts"      "" ""     "" "MenuTheme[@]" # 7 
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "wqy-microhei"         "" ""     "INSTALL-FONTS-MENU-8-I" "MenuTheme[@]" # 8
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_TTF_DEJAVU"
                    add_packagemanager "package_install \"$INSTALL_TTF_DEJAVU\" 'INSTALL-TTF-DEJAVU'" "INSTALL-TTF-DEJAVU"
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_packagemanager "package_remove 'ttf-droid ttf-roboto ttf-ubuntu-font-family'" "REMOVE-GOOGLE-WEBFONTS"
                    add_aur_package "$AUR_INSTALL_GOOGLE_WEBFONTS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GOOGLE_WEBFONTS\" 'AUR-INSTALL-GOOGLE-WEBFONTS'" "AUR-INSTALL-GOOGLE-WEBFONTS"
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_FUN_FONTS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_FUN_FONTS\" 'AUR-INSTALL-FUN-FONTS'" "AUR-INSTALL-FUN-FONTS"
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_KOCHI_FONTS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_KOCHI_FONTS\" 'AUR-INSTALL-KOCHI-FONTS'" "AUR-INSTALL-KOCHI-FONTS"
                    ;;
                5)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_TTF_LIBERATION"
                    add_packagemanager "package_install \"$INSTALL_TTF_LIBERATION\" 'INSTALL-TTF-LIBERATION'" "INSTALL-TTF-LIBERATION"
                    ;;
                6)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MS_FONTS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MS_FONTS\" 'AUR-INSTALL-MS-FONTS'" "AUR-INSTALL-MS-FONTS"
                    ;;
                7)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_VISTA_FONTS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_VISTA_FONTS\" 'AUR-INSTALL-VISTA-FONTS'" "AUR-INSTALL-VISTA-FONTS"
                    ;;
                8)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_WQY_FONTS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_WQY_FONTS\" 'AUR-INSTALL-WQY-FONTS'" "AUR-INSTALL-WQY-FONTS"
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
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
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
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # networkmanager
                    NETWORK_MANAGER="networkmanager"
                    S_OPT="$BreakableKey"
                    break
                    ;;
                2)  # wicd
                    NETWORK_MANAGER="wicd"
                    S_OPT="$BreakableKey"
                    break
                    ;;
                3)  # None
                    NETWORK_MANAGER="" # @FIX Insure Null value in save
                    S_OPT="$BreakableKey"
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
        if [[ "$KDE_INSTALLED" -eq 1 ]]; then
            add_package "$INSTALL_NETWORKMANAGER_KDE"
            add_packagemanager "package_install \"$INSTALL_NETWORKMANAGER_KDE\" 'INSTALL-NETWORKMANAGER-KDE'" "INSTALL-NETWORKMANAGER-KDE"
            if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                add_package "$INSTALL_NETWORKMANAGER_APPLET"
                add_packagemanager "package_install \"$INSTALL_NETWORKMANAGER_APPLET\" 'INSTALL-NETWORKMANAGER-APPLET'" "INSTALL-NETWORKMANAGER-APPLET"
            fi
        else
            add_package "$INSTALL_NETWORKMANAGER"
            add_packagemanager "package_install \"$INSTALL_NETWORKMANAGER\" 'INSTALL-NETWORKMANAGER'" "INSTALL-NETWORKMANAGER"
        fi
        add_package "$INSTALL_NETWORKMANAGER_NTP"
        add_packagemanager "package_install \"$INSTALL_NETWORKMANAGER_NTP\" 'INSTALL-NETWORKMANAGER-NTP'" "INSTALL-NETWORKMANAGER-NTP"
        add_user_group "networkmanager"
        # Network Management daemon
        # Application development toolkit for controlling system-wide privileges
        # polkit.service
        add_packagemanager "systemctl enable NetworkManager.service" "SYSTEMD-ENABLE-NETWORKMANAGER"
        add_packagemanager "add_user_2_group 'networkmanager'" "GROUPADD-NETWORKMANAGER"
    elif [[ "$NETWORK_MANAGER" == "wicd" ]]; then
        if [[ "$KDE_INSTALLED" -eq 1 ]]; then
            add_aur_package "$AUR_INSTALL_WICD_KDE"
            add_packagemanager "aur_package_install \"$AUR_INSTALL_WICD_KDE\" 'AUR-INSTALL-WICD-KDE'" "AUR-INSTALL-WICD-KDE"
            if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                add_package "$INSTALL_WICD_GTK"
                add_packagemanager "package_install \"$INSTALL_WICD_GTK\" 'INSTALL-WICD-GTK'" "INSTALL-WICD-GTK"
            fi
        else
            add_package "$INSTALL_WICD_GTK"
            add_packagemanager "package_install \"$INSTALL_WICD_GTK\" 'INSTALL-WICD-GTK'" "INSTALL-WICD-GTK"
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
    localize_info "INSTALL-ACCESSORIES-APPS-DESC"  "Install Accessory Apps"
    localize_info "INSTALL-ACCESSORIES-APPS-NOTES" "Notes."
    localize_info "INSTALL-ACCESSORIES-APPS-TITLE" "ACCESSORIES APPS"
fi
# -------------------------------------
install_accessories_apps_menu()
{
    # 4
    local -r menu_name="ACCESSORIES-APPS"  # You must define Menu Name here
    local BreakableKey="D"                 # Q=Quit, D=Done, B=Back
    local RecommendedOptions="15"          # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 6 7 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions 6 7 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 6 7 12 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-ACCESSORIES-APPS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Cairo"                     "" "$AUR" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Conky + CONKY-colors"      "" "$AUR" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Deepin Scrot"              "" "$AUR" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Dockbarx"                  "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Docky"                     "" "$AUR" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Speedcrunch or galculator" "" "$AUR" "Depending on DE" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Gnome Pie"                 "" "$AUR" "" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Guake"                     "" ""     "Nice Terminal Popup F12" "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Kupfer"                    "" "$AUR" "" "MenuTheme[@]" # 9
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Pyrenamer"                 "" "$AUR" "" "MenuTheme[@]" # 10
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Shutter"                   "" "$AUR" "" "MenuTheme[@]" # 11
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Synapse"                   "" "$AUR" "" "MenuTheme[@]" # 12
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Terminator"                "" ""     "" "MenuTheme[@]" # 13
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Zim"                       "" ""     "" "MenuTheme[@]" # 14
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Revelation"                "" "$AUR" "Password Safe." "MenuTheme[@]" # 15
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_CAIRO"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_CAIRO\" 'AUR-INSTALL-CAIRO'" "AUR-INSTALL-CAIRO"
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_CONKY" 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_CONKY\" 'AUR-INSTALL-CONKY'" "AUR-INSTALL-CONKY"
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DEEPIN_SCROT"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DEEPIN_SCROT\" 'AUR-INSTALL-DEEPIN-SCROT'" "AUR-INSTALL-DEEPIN-SCROT"
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DOCKBARX"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DOCKBARX\" 'AUR-INSTALL-DOCKBARX'" "AUR-INSTALL-DOCKBARX"
                    ;;
                5)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_DOCKY"
                    add_packagemanager "package_install \"$INSTALL_DOCKY\" 'INSTALL-DOCKY'" "INSTALL-DOCKY"
                    ;;
                6)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                            add_aur_package "$AUR_INSTALL_GALGULATOR"
                            add_packagemanager "aur_package_install \"$AUR_INSTALL_GALGULATOR\" 'AUR-INSTALL-GALCULATOR'" "AUR-INSTALL-GALCULATOR"
                        fi
                        add_aur_package "$AUR_INSTALL_SPEEDCRUNCH"
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_SPEEDCRUNCH\" 'AUR-INSTALL-SPEEDCRUNCH'" "AUR-INSTALL-SPEEDCRUNCH"
                    else
                        add_aur_package "$AUR_INSTALL_GALGULATOR"
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_GALGULATOR\" 'AUR-INSTALL-GALGULATOR'" "AUR-INSTALL-GALGULATOR"
                    fi
                    ;;
                7)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GNOME_PIE" 
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GNOME_PIE\" 'AUR-INSTALL-GNOME-PIE'" "AUR-INSTALL-GNOME-PIE"
                    ;;
                8)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GUAKE"
                    add_packagemanager "package_install \"$INSTALL_GUAKE\" 'INSTALL-GUAKE'" "INSTALL-GUAKE"
                    ;;
                9)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_KUPFER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_KUPFER\" 'AUR-INSTALL-KUPFER'" "AUR-INSTALL-KUPFER"
                    ;;
               10)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_PYRENAMER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_PYRENAMER\" 'AUR-INSTALL-PYRENAMER'" "AUR-INSTALL-PYRENAMER"
                    ;;
               11)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SHUTTER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SHUTTER\" 'AUR-INSTALL-SHUTTER'" "AUR-INSTALL-SHUTTER"
                    ;;
               12)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_ZEITGEIST"
                    add_packagemanager "package_install \"$INSTALL_ZEITGEIST\" 'INSTALL-ZEITGEIST'" "INSTALL-ZEITGEIST"
                    add_aur_package "$AUR_INSTALL_ZEITGEIST"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ZEITGEIST\" 'AUR-INSTALL-ZEITGEIST'" "AUR-INSTALL-ZEITGEIST"
                    ;;
               13)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_TERMINATOR"
                    add_packagemanager "package_install \"$INSTALL_TERMINATOR\" 'INSTALL-TERMINATOR'" "INSTALL-TERMINATOR"
                    add_aur_package "$AUR_INSTALL_TERMINATOR"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_TERMINATOR\" 'AUR-INSTALL-TERMINATOR'" "AUR-INSTALL-TERMINATOR"
                    ;;
               14)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_ZIM"
                    add_packagemanager "package_install \"$INSTALL_ZIM\" 'INSTALL-ZIM'" "INSTALL-ZIM"
                    ;;
               15)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_REVELATION"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_REVELATION\" 'AUR-INSTALL-REVELATION'" "AUR-INSTALL-REVELATION"
                    add_packagemanager "make_dir '/etc/gconf/schemas/' \"$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO\"; cd /etc/gconf/schemas/; ln -s /usr/share/gconf/schemas/revelation.schemas; cd \$(pwd)" "AUR-INSTALL-REVELATION-SETUP"
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
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-1"    "Qt and Creator"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-1-I"                   "Qt and Creator"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-2"    "Wt"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-2-I"                   "Wt Pronounced [Witty]: C++ Web Applications Frame work based on Widgets."
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-3"    "MySQL and Workbench"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-3-I"                   "MySQL and Workbench"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-4"    "Aptana-Studio"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-4-I"                   "Aptana-Studio"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-5"    "Bluefish"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-5-I"                   "Bluefish"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-6"    "Eclipse"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-6-I"                   "Eclipse: Sub menu for Customizing."
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-7"    "emacs"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-7-I"                   "emacs"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-8"    "gvim"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-8-I"                   "gvim"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-9"    "geany"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-9-I"                   "geany"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-10"   "IntelliJ IDEA"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-10-I"                  "IntelliJ IDEA"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-11"   "kdevelop"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-11-I"                  "kdevelop"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-12"   "Netbeans"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-12-I"                  "Netbeans"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-13"   "Oracle Java"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-13-I"                  "Oracle Java: https://wiki.archlinux.org/index.php/Java"    
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-14"   "Sublime Text 2"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-14-I"                  "Sublime Text 2"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-15"   "Debugger Tools"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-15-I"                  "Debugger Tools"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-16"   "meld"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-16-I"                  "meld"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-17"   "RabbitVCS"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-17-I"                  "RabbitVCS"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-18"   "astyle"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-18-I"                  "astyle"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-19"   "putty"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-19-I"                  "putty"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-20"   "Utilities"
    localize_info "INSTALL-DEVELOPMENT-APPS-MENU-20-I"                  "Utilities"
fi
# -------------------------------------
install_development_apps_menu()
{
    # 3
    local -r menu_name="DEVELOPMENT-APPS"  # You must define Menu Name here
    local BreakableKey="D"                 # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"           # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 2 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions 2 5 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 2 3 5 6 12 15 18-20 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-DEVELOPMENT-APPS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-1"  "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-1-I"  "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-2"  "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-2-I"  "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-3"  "" "$AUR" "INSTALL-DEVELOPMENT-APPS-MENU-3-I"  "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-4"  "" "$AUR" "INSTALL-DEVELOPMENT-APPS-MENU-4-I"  "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-5"  "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-5-I"  "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-6"  "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-6-I"  "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-7"  "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-7-I"  "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-8"  "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-8-I"  "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-9"  "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-9-I"  "MenuTheme[@]" # 9
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-10" "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-10-I" "MenuTheme[@]" # 10
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-11" "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-11-I" "MenuTheme[@]" # 11
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-12" "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-12-I" "MenuTheme[@]" # 12
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-13" "" "$AUR" "INSTALL-DEVELOPMENT-APPS-MENU-13-I" "MenuTheme[@]" # 13
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-14" "" "$AUR" "INSTALL-DEVELOPMENT-APPS-MENU-14-I" "MenuTheme[@]" # 14
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-15" "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-15-I" "MenuTheme[@]" # 15
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-16" "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-16-I" "MenuTheme[@]" # 16
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-17" "" "$AUR" "INSTALL-DEVELOPMENT-APPS-MENU-17-I" "MenuTheme[@]" # 17
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-18" "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-18-I" "MenuTheme[@]" # 18
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-19" "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-19-I" "MenuTheme[@]" # 19
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-DEVELOPMENT-APPS-MENU-20" "" ""     "INSTALL-DEVELOPMENT-APPS-MENU-20-I" "MenuTheme[@]" # 20
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # Qt and Creator
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_QT"
                    add_packagemanager "package_install \"$INSTALL_QT\" 'INSTALL-QT'" "INSTALL-QT"
                    add_packagemanager "mkdir -p /home/\$USERNAME/.config/Nokia/qtcreator/styles" "RUN-QT-1"
                    add_packagemanager "curl -o monokai.xml http://angrycoding.googlecode.com/svn/branches/qt-creator-monokai-theme/monokai.xml" "RUN-QT-2"
                    add_packagemanager "mv monokai.xml /home/\$USERNAME/.config/Nokia/qtcreator/styles/" "RUN-QT-3"
                    add_packagemanager "chown -R \$USERNAME:\$USERNAME /home/\$USERNAME/.config" "RUN-QT-4"
                    ;;
                2)  # Wt
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_WT"
                    add_packagemanager "package_install \"$INSTALL_WT\" 'INSTALL-WT'" "INSTALL-WT"
                    ;;
                3)  # MySQL and Workbenchhttps://wiki.archlinux.org/index.php/Java
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MYSQL_WORKBENCH"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MYSQL_WORKBENCH\" 'AUR-INSTALL-MYSQL-WORKBENCH'" "AUR-INSTALL-MYSQL-WORKBENCH"
                    ;;
                4)  # Aptana-Studio
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_APTANA_STUDIO"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_APTANA_STUDIO\" 'AUR-INSTALL-APTANA-STUDIO'" "AUR-INSTALL-APTANA-STUDIO"
                    ;;
                5)  # Bluefish
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_BLUEFISH"
                    add_packagemanager "package_install \"$INSTALL_BLUEFISH\" 'INSTALL-BLUEFISH'" "INSTALL-BLUEFISH"
                    ;;
                6)  # Eclipse
                    MenuChecks[$((S_OPT - 1))]=1
                    install_eclipse_dev_menu
                    ;;
                7)  # emacs
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_EMACS"
                    add_packagemanager "package_install \"$INSTALL_EMACS\" 'INSTALL-EMACS'" "INSTALL-EMACS"
                    ;;
                8)  # gvim
                    MenuChecks[$((S_OPT - 1))]=1
                    add_packagemanager "package_remove 'vim'" "REMOVE-GVIM"
                    add_package "$INSTALL_VIM"
                    add_packagemanager "package_install \"$INSTALL_VIM\" 'INSTALL-VIM'" "INSTALL-VIM"
                    add_aur_package "$AUR_INSTALL_DISCOUNT"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DISCOUNT\" 'AUR-INSTALL-DISCOUNT'" "AUR-INSTALL-DISCOUNT"
                    ;;
                9)  # geany
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GEANY"
                    add_packagemanager "package_install \"$INSTALL_GEANY\" 'INSTALL-GEANY'" "INSTALL-GEANY"
                    ;;
               10)  # IntelliJ IDEA
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_INTELLIJ"
                    add_packagemanager "package_install \"$INSTALL_INTELLIJ\" 'INSTALL-INTELLIJ'" "INSTALL-INTELLIJ"
                    ;;
               11)  # kdevelop
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_KDEVELOP"
                    add_packagemanager "package_install \"$INSTALL_KDEVELOP\" 'INSTALL-KDEVELOP'" "INSTALL-KDEVELOP"
                    ;;
               12)  # Netbeans
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_NETBEANS"
                    add_packagemanager "package_install \"$INSTALL_NETBEANS\" 'INSTALL-NETBEANS'" "INSTALL-NETBEANS"
                    ;;
               13)  # Oracle Java
                    MenuChecks[$((S_OPT - 1))]=1
                    add_packagemanager "package_remove 'jre7-openjdk jdk7-openjdk'" "REMOVE-JDK"
                    add_aur_package "$AUR_INSTALL_JDK"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_JDK\" 'AUR-INSTALL-JDK'" "AUR-INSTALL-JDK"
                    ;;
               14)  # Sublime Text 2
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_SUBLIME"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SUBLIME\" 'AUR-INSTALL-SUBLIME'" "AUR-INSTALL-SUBLIME"
                    ;;
               15)  # Debugger Tools
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DEBUGGER_TOOLS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DEBUGGER_TOOLS\" 'AUR-INSTALL-DEBUGGER-TOOLS'" "AUR-INSTALL-DEBUGGER-TOOLS"
                    ;;
               16)  # meld
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_MELD"
                    add_packagemanager "package_install \"$INSTALL_MELD\" 'INSTALL-MELD'" "INSTALL-MELD"
                    ;;
               17)  # RabbitVCS
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_RABBITVCS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_RABBITVCS\" 'AUR-INSTALL-RABBITVCS'" "AUR-INSTALL-RABBITVCS"
                    # @FIX check what is to be installed
                    add_aur_package "$AUR_INSTALL_RABBITVCS_NAUTILUS"
                    add_packagemanager "[[ check_package 'nautilus' ]] && aur_package_install \"$AUR_INSTALL_RABBITVCS_NAUTILUS\" 'AUR-INSTALL-RABBITVCS-NAUTILUS'" "AUR-INSTALL-RABBITVCS-NAUTILUS"
                    add_aur_package "$AUR_INSTALL_RABBITVCS_THUNAR"
                    add_packagemanager "[[ check_package 'thunar' ]] && aur_package_install \"$AUR_INSTALL_RABBITVCS_THUNAR\" 'AUR-INSTALL-RABBITVCS-THUNAR'" "AUR-INSTALL-RABBITVCS-THUNAR"
                    add_aur_package "$AUR_INSTALL_RABBITVCS_CLI"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_RABBITVCS_CLI\" 'AUR-INSTALL-RABBITVCS-CLI'" "AUR-INSTALL-RABBITVCS-CLI"
                    ;;
               18)  # astyle
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_ASTYLE"
                    add_packagemanager "package_install \"$INSTALL_ASTYLE\"  'INSTALL-ASTYLE'" "INSTALL-ASTYLE"
                    ;;
               19)  # putty
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_PUTTY"
                    add_packagemanager "package_install \"$INSTALL_PUTTY\" 'INSTALL-PUTTY'" "INSTALL-PUTTY"
                    ;;
               20)  # Utilities
                    MenuChecks[$((S_OPT - 1))]=1
                    install_utilities
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
    localize_info "INSTALL-ECLIPSE-DEV-MENU-7" "Aptana Studio plugin for Eclipse"
    localize_info "INSTALL-ECLIPSE-DEV-MENU-8" "Vim-like editing plugin for Eclipse"
    localize_info "INSTALL-ECLIPSE-DEV-MENU-9" "Git support plugin for Eclipse"
fi
# -------------------------------------
install_eclipse_dev_menu()
{
    local -r menu_name="INSTALL-ECLIPSE-DEV"  # You must define Menu Name here
    local BreakableKey="B"                    # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 2"            # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 6 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions 3 6 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 3 4 5 6 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-ECLIPSE-DEV-DESC" " - https://wiki.archlinux.org/index.php/Eclipse"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info  "INSTALL-ECLIPSE-DEV-INFO-1"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-1" "" ""     "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-2" "" ""     "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-3" "" "$AUR" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-4" "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-5" "" "$AUR" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-6" "" "$AUR" "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-7" "" "$AUR" "" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-8" "" "$AUR" "" "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-ECLIPSE-DEV-MENU-9" "" "$AUR" "" "MenuTheme[@]" # 9
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_ECLIPSE"
                    add_packagemanager "package_install \"$INSTALL_ECLIPSE\" 'INSTALL-ECLIPSE'" "INSTALL-ECLIPSE"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_ECLIPSE_CDT"
                    add_packagemanager "package_install \"$INSTALL_ECLIPSE_CDT\" 'INSTALL-ECLIPSE-CDT'" "INSTALL-ECLIPSE-CDT"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_ANDROID"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_ANDROID\" 'AUR-INSTALL-ECLIPSE-ANDROID'" "AUR-INSTALL-ECLIPSE-ANDROID"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_WTP"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_WTP\" 'AUR-INSTALL-ECLIPSE-WTP'" "AUR-INSTALL-ECLIPSE-WTP"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_PDT"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_PDT\" 'AUR-INSTALL-ECLIPSE-PDT'" "AUR-INSTALL-ECLIPSE-PDT"
                    ;;
                6)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_PYDEV"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_PYDEV\" 'AUR-INSTALL-ECLIPSE-PYDEV'" "AUR-INSTALL-ECLIPSE-PYDEV"
                    ;;
                7)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_APTANA"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_APTANA\" 'AUR-INSTALL-ECLIPSE-APTANA'" "AUR-INSTALL-ECLIPSE-APTANA"
                    ;;
                8)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_VRAPPER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_VRAPPER\" 'AUR-INSTALL-ECLIPSE-VRAPPER'" "AUR-INSTALL-ECLIPSE-VRAPPER"
                    ;;
                9)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ECLIPSE_EGIT"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ECLIPSE_EGIT\" 'AUR-INSTALL-ECLIPSE-EGIT'" "AUR-INSTALL-ECLIPSE-EGIT"
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
# INSTALL UTILITES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_utilities"
    USAGE="install_utilities"
    DESCRIPTION=$(localize "Install Utilities")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "Install Utilities" "Install Utilities" 
fi
# -------------------------------------
install_utilities()
{
    # 3 sub 20
    print_title "Utilites"
    print_info "faac gpac espeak faac antiword unrtf odt2txt txt2tags nrg2iso bchunk gnome-disk-utility"
    print_info "Full List: $INSTALL_UTILITES" 
    read_input_yn "Install Utilities" " " 1  # Allow Bypass
    if [[ "$YN_OPTION" -eq 1 ]]; then
        add_package "$INSTALL_UTILITES"
        add_packagemanager "package_install \"$INSTALL_UTILITES\" 'INSTALL-UTITILTIES'" "INSTALL-UTITILTIES"
    fi
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
    localize_info "INSTALL-INTERNET-APPS-TITLE" "INTERNET APPS"
    #
    localize_info "INSTALL-INTERNET-MENU-1"     "Browser"
    localize_info "INSTALL-INTERNET-MENU-2"     "Download | Fileshare"
    localize_info "INSTALL-INTERNET-MENU-3"     "Email | RSS"
    localize_info "INSTALL-INTERNET-MENU-4"     "Instant Messaging"
    localize_info "INSTALL-INTERNET-MENU-5"     "IRC"
    localize_info "INSTALL-INTERNET-MENU-6"     "Mapping Tools"
    localize_info "INSTALL-INTERNET-MENU-7"     "VNC | Desktop Share"
fi
# -------------------------------------
install_internet_apps_menu()
{
    # 7
    local -r menu_name="INTERNET-APPS"  # You must define Menu Name here
    local BreakableKey="D"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-4 6"    # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 5 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions 5 7 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 5 7 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-INTERNET-APPS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-1" "" "" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-2" "" "" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-3" "" "" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-4" "" "" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-5" "" "" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-6" "" "" "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-INTERNET-MENU-7" "" "" "" "MenuTheme[@]" # 7
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_browsers_menu
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_download_fileshare_menu
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_email_menu
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_im_menu
                    ;;
                5)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_irc_menu
                    ;;
                6)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_mapping_menu
                    ;;
                7)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_desktop_share_menu
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
    USAGE="install_internet_apps_menu"
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
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 2 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions 2 3 4 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 2 3 4 5 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
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
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_FIREFOX"
                    add_packagemanager "package_install \"$INSTALL_FIREFOX\" 'INSTALL-FIREFOX'" "INSTALL-FIREFOX"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_CHROMIUM"
                    add_packagemanager "package_install \"$INSTALL_CHROMIUM\" 'INSTALL-CHROMIUM'" "INSTALL-CHROMIUM"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GOOGLE_CHROME"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GOOGLE_CHROME\" 'AUR-INSTALL-GOOGLE-CHROME'" "AUR-INSTALL-GOOGLE-CHROME"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_OPERA"
                    add_packagemanager "package_install \"$INSTALL_OPERA\" 'INSTALL-OPERA'" "INSTALL-OPERA"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        add_package "$INSTALL_REKONQ"
                        add_packagemanager "package_install \"$INSTALL_REKONQ\" 'INSTALL-REKONQ'" "INSTALL-REKONQ"
                    else
                        add_package "$INSTALL_MIDORI"
                        add_packagemanager "package_install \"$INSTALL_MIDORI\" 'INSTALL-MIDORI'" "INSTALL-MIDORI"
                    fi
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
fi
# -------------------------------------
install_download_fileshare_menu()
{
    local -r menu_name="INSTALL-DOWNLOAD-FILESHARE"  # You must define Menu Name here
    local BreakableKey="B"                           # Q=Quit, D=Done, B=Back
    local RecommendedOptions="8"                     # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-DOWNLOAD-FILESHARE-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "deluge"         "" "$AUR" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "dropbox"        "" "$AUR" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "insync"         "" "$AUR" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "jdownloader"    "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "nitroshare"     "" "$AUR" "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "sparkleshare"   "" ""     "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "steadyflow-bzr" "" "$AUR" "" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Transmission"   "" ""     "" "MenuTheme[@]" # 8
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_DELUGE"
                    add_packagemanager "package_install \"$INSTALL_DELUGE\" 'INSTALL-DELUGE'" "INSTALL-DELUGE"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_DROPBOX"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DROPBOX\" 'AUR-INSTALL-DROPBOX'" "AUR-INSTALL-DROPBOX"
                    add_aur_package "$AUR_INSTALL_DROPBOX_NAUTILUS"
                    add_packagemanager "[[ check_package 'nautilus' ]] && aur_package_install \"$AUR_INSTALL_DROPBOX_NAUTILUS\" 'AUR-INSTALL-DROPBOX-NAUTILUS'" "AUR-INSTALL-DROPBOX-NAUTILUS"
                    add_aur_package "$AUR_INSTALL_DROPBOX_THUNAR"
                    add_packagemanager "[[ check_package 'thunar' ]] && aur_package_install \"$AUR_INSTALL_DROPBOX_THUNAR\" 'AUR-INSTALL-DROPBOX-THUNAR'" "AUR-INSTALL-DROPBOX-THUNAR"
                    add_aur_package "$AUR_INSTALL_DROPBOX_KFILEBOX"
                    add_packagemanager "[[ check_package 'kdebase-dolphin' ]] && aur_package_install \"$AUR_INSTALL_DROPBOX_KFILEBOX\" 'AUR-INSTALL-DROPBOX-KFILEBOX'" "AUR-INSTALL-DROPBOX-KFILEBOX"
                    add_aur_package "$AUR_INSTALL_DROPBOX_CLI"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_DROPBOX_CLI\" 'AUR-INSTALL-DROPBOX-CLI'" "AUR-INSTALL-DROPBOX-CLI"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_INSYNC"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_INSYNC\" 'AUR-INSTALL-INSYNC'" "AUR-INSTALL-INSYNC"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_JDOWNLOADER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_JDOWNLOADER\" 'AUR-INSTALL-JDOWNLOADER'" "AUR-INSTALL-JDOWNLOADER"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_NITROSHARE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_NITROSHARE\" 'AUR-INSTALL-NITROSHARE" "AUR-INSTALL-NITROSHARE"
                    ;;
                6)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_SPARKLESHARE"
                    add_packagemanager "package_install \"$INSTALL_SPARKLESHARE\" 'INSTALL-SPARKLESHARE'" "INSTALL-SPARKLESHARE"
                    ;;
                7)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_STEADYFLOW"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_STEADYFLOW\" 'AUR-INSTALL-STEADYFLOW'" "AUR-INSTALL-STEADYFLOW"
                    ;;
                8)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        if [[ "$GNOME_INSTALL" -eq 1 ]]; then
                            add_package "$INSTALL_TRANSMISSION_GTK"
                            add_packagemanager "package_install \"$INSTALL_TRANSMISSION_GTK\" 'INSTALL-TRANSMISSION-GTK'" "INSTALL-TRANSMISSION-GTK"
                        fi
                        add_package "$INSTALL_TRANSMISSION_QT"
                        add_packagemanager "package_install \"$INSTALL_TRANSMISSION_QT\" 'INSTALL-TRANSMISSION-QT'" "INSTALL-TRANSMISSION-QT"
                    else
                        add_package "$INSTALL_TRANSMISSION_GTK"
                        add_packagemanager "package_install \"$INSTALL_TRANSMISSION_GTK\" 'INSTALL-TRANSMISSION-GTK'" "INSTALL-TRANSMISSION-GTK"
                    fi
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
    localize_info "INSTALL-EMAIL-DESC"   "Install Email / RSS Apps"
fi
# -------------------------------------
install_email_menu()
{
    local -r menu_name="INSTALL-EMAIL"  # You must define Menu Name here
    local BreakableKey="B"              # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 2"      # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-EMAIL-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Evolution"   "" "" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Thunderbird" "" "" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Liferea"     "" "" "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Lightread"   "" "" "" "MenuTheme[@]" # 4
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_EVOLUTION"
                    add_packagemanager "package_install \"$INSTALL_EVOLUTION\" 'INSTALL-EVOLUTION'" "INSTALL-EVOLUTION"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_THUNDERBIRD"
                    add_packagemanager "package_install \"$INSTALL_THUNDERBIRD\" 'INSTALL-THUNDERBIRD'" "INSTALL-THUNDERBIRD"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_LIFEREA"
                    add_packagemanager "package_install \"$INSTALL_LIFEREA\" 'INSTALL-LIFEREA'" "INSTALL-LIFEREA"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_LIGHTREAD"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_LIGHTREAD\" 'AUR-INSTALL-LIGHTREAD'" "AUR-INSTALL-LIGHTREAD"
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
fi
# -------------------------------------
install_im_menu()
{
    local -r menu_name="INSTALL-IM"  # You must define Menu Name here
    local BreakableKey="B"           # Q=Quit, D=Done, B=Back
    local RecommendedOptions="3 4"   # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-IM-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Emesene"           "" ""     "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Google Talkplugin" "" "$AUR" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Pidgin"            "" ""     "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Skype"             "" ""     "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Teamspeak3"        "" "$AUR" "" "MenuTheme[@]" # 5
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_EMESENE"
                    add_packagemanager "package_install \"$INSTALL_EMESENE\"  'INSTALL-EMESENE'" "INSTALL-EMESENE"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_GOOGLE_TALKPLUGIN"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GOOGLE_TALKPLUGIN\" 'AUR-INSTALL-GOOGLE-TALKPLUGIN'" "AUR-INSTALL-GOOGLE-TALKPLUGIN"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_PIDGIN"
                    add_packagemanager "package_install \"$INSTALL_PIDGIN\" 'INSTALL-PIDGIN'" "INSTALL-PIDGIN"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_taskmanager "required_repo 'multilib'" "REQUIRED-REPO-MULTILIB"                    
                    add_package "$INSTALL_SKYPE"
                    add_packagemanager "package_install \"$INSTALL_SKYPE\" 'INSTALL-SKYPE'" "INSTALL-SKYPE"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_TEAMSPEAK3"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_TEAMSPEAK3\" 'AUR-INSTALL-TEAMSPEAK3'" "AUR-INSTALL-TEAMSPEAK3"
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
fi
# -------------------------------------
install_irc_menu()
{
    local -r menu_name="INSTALL-IRC"  # You must define Menu Name here
    local BreakableKey="B"            # Q=Quit, D=Done, B=Back
    local RecommendedOptions="2"      # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-IRC-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "irssi" "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "quassel or xchat" "Depending on DE" "" "quassel or xchat: Depending on DE" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_IRSSI"
                    add_packagemanager "package_install \"$INSTALL_IRSSI\" 'INSTALL-IRSSI'" "INSTALL-IRSSI"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                            add_package "$INSTALL_XCHAT"
                            add_packagemanager "package_install \"$INSTALL_XCHAT\" 'INSTALL-XCHAT'" "INSTALL-XCHAT"
                        fi
                        add_package "$INSTALL_QUASSEL"
                        add_packagemanager "package_install \"$INSTALL_QUASSEL\" 'INSTALL-QUASSEL'" "INSTALL-QUASSEL"
                    else
                        add_package "$INSTALL_XCHAT"
                        add_packagemanager "package_install \"$INSTALL_XCHAT\" 'INSTALL-XCHAT'" "INSTALL-XCHAT"
                    fi
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
    localize_info "INSTALL-MAPPING-DESC"   "Install Mapping Tools"
    localize_info "INSTALL-MAPPING-MENU-1" "Google Earth"
    localize_info "INSTALL-MAPPING-MENU-2" "NASA World Wind"
fi
# -------------------------------------
install_mapping_menu()
{
    local -r menu_name="INSTALL-MAPPING"  # You must define Menu Name here
    local BreakableKey="B"                # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1 2"        # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #                    
    while [[ 1 ]];  do
        print_title "INSTALL-MAPPING-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAPPING-MENU-1" "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-MAPPING-MENU-2" "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_taskmanager "required_repo 'multilib'" "REQUIRED-REPO-MULTILIB"
                    add_package "$INSTALL_GOOGLE_EARTH"
                    add_packagemanager "package_install \"$INSTALL_GOOGLE_EARTH\" 'INSTALL-GOOGLE-EARTH'" "INSTALL-GOOGLE-EARTH"
                    add_aur_package "$AUR_INSTALL_GOOGLE_EARTH"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GOOGLE_EARTH\" 'AUR-INSTALL-GOOGLE-EARTH'" "AUR-INSTALL-GOOGLE-EARTH"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_WORLDWIND"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_WORLDWIND\" 'AUR-INSTALL-WORLDWIND'" "AUR-INSTALL-WORLDWIND"
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
fi
# -------------------------------------
install_desktop_share_menu()
{
    local -r menu_name="INSTALL-DESKTOP-SHARE"  # You must define Menu Name here
    local BreakableKey="B"                      # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1"                # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-DESKTOP-SHARE-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Remmina"    "" "" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Teamviewer" "" "" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_REMMINA"
                    add_packagemanager "package_install \"$INSTALL_REMMINA\" 'INSTALL-REMMINA'" "INSTALL-REMMINA"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_TEAMVIEWER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_TEAMVIEWER\" 'AUR-INSTALL-TEAMVIEWER'" "AUR-INSTALL-TEAMVIEWER"
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
    localize_info "INSTALL-GRAPHICS-APPS-DESC"   "Install Graphic Apps"
    #
    localize_info "INSTALL-GRAPHICS-APPS-TITLE"    "GRAPHICS APPS"
    localize_info "INSTALL-GRAPHICS-APPS-INFO"     "AV Studio:"
    localize_info "INSTALL-GRAPHICS-APPS-INFO-2"   "and from AUR"
    #
    localize_info "INSTALL-GRAPHICS-APPS-MENU-1"   "AV Studio"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-2"   "Blender"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-3"   "Handbrake"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-4"   "CD/DVD Burners"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-5"   "Gimp"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-6"   "Gimp-plugins"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-7"   "Gthumb"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-8"   "Inkscape"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-9"   "Mcomix"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-10"  "MyPaint"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-11"  "Scribus"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-12"  "Shotwell"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-13"  "Simple-scan"
    localize_info "INSTALL-GRAPHICS-APPS-MENU-14"  "Xnviewmp"

    localize_info "INSTALL-GRAPHICS-APPS-MENU-I-1"   "AV Studio: Installs all Below and more Audio and Video Apps"
fi
# -------------------------------------
install_graphics_apps_menu()
{
    # 6
    local -r menu_name="INSTALL-GRAPHICS-APPS"  # You must define Menu Name here
    local BreakableKey="D"                      # Q=Quit, D=Done, B=Back
    local RecommendedOptions=""                # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions 3-13 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 1 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions 1 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 1 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-GRAPHICS-APPS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        print_info  "INSTALL-GRAPHICS-APPS-INFO" " $AV_STUDIO $(localize "INSTALL-GRAPHICS-APPS-INFO-2") $AV_STUDIO_AUR"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-1"  "" "Some $AUR" "INSTALL-GRAPHICS-APPS-MENU-I-1" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-2"  "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-3"  "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-4"  "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-5"  "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-6"  "" "$AUR" "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-7"  "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-8"  "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-9"  "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-10" "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-11" "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-12" "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-13" "" ""     "" "MenuTheme[@]"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-GRAPHICS-APPS-MENU-14" "" "$AUR" "" "MenuTheme[@]"
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_av_studio
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_BLENDER"
                    add_packagemanager "package_install \"$INSTALL_BLENDER\" 'INSTALL-BLENDER'" "INSTALL-BLENDER"
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_HANDBRAKE"
                    add_packagemanager "package_install \"$INSTALL_HANDBRAKE\" 'INSTALL-HANDBRAKE'" "INSTALL-HANDBRAKE"
                    ;;
                4)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_BRASERO"
                    add_packagemanager "package_install \"$INSTALL_BRASERO\" 'INSTALL-BRASERO'" "INSTALL-BRASERO"
                    ;;
                5)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GIMP"
                    add_packagemanager "package_install \"$INSTALL_GIMP\"  'INSTALL-GIMP'" "INSTALL-GIMP"
                    ;;
                6)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GIMP"
                    add_packagemanager "package_install \"$INSTALL_GIMP\"  'INSTALL-GIMP'" "INSTALL-GIMP"
                    #
                    add_aur_package "$AUR_INSTALL_GIMP_PLUGINS"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_GIMP_PLUGINS\" 'AUR-INSTALL-GIMP-PLUGINS'" "AUR-INSTALL-GIMP-PLUGINS"
                    ;;
                7)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_GTHUMB"
                    add_packagemanager "package_install \"$INSTALL_GTHUMB\" 'INSTALL-GTHUMB'" "INSTALL-GTHUMB"
                    ;;
                8)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_INKSCAPE"
                    add_packagemanager "package_install \"$INSTALL_INKSCAPE\" 'INSTALL-INKSCAPE'" "INSTALL-INKSCAPE"
                    add_aur_package "$AUR_INSTALL_SOZI"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_SOZI\" 'AUR-INSTALL-SOZI'" "AUR-INSTALL-SOZI"
                    ;;
                9)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_MCOMIX"
                    add_packagemanager "package_install \"$INSTALL_MCOMIX\" 'INSTALL-MCOMIX'" "INSTALL-MCOMIX"
                    ;;
               10)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_MYPAINT"
                    add_packagemanager "package_install \"$INSTALL_MYPAINT\"  'INSTALL-MYPAINT'" "INSTALL-MYPAINT"
                    ;;
               11)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_SCRIBUS"
                    add_packagemanager "package_install \"$INSTALL_SCRIBUS\" 'INSTALL-SCRIBUS'" "INSTALL-SCRIBUS"
                    ;;
               12)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_SHOTWELL"
                    add_packagemanager "package_install \"$INSTALL_SHOTWELL\" 'INSTALL-SHOTWELL'" "INSTALL-SHOTWELL"
                    ;;
               13)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_SIMPLE_SCAN"
                    add_packagemanager "package_install \"$INSTALL_SIMPLE_SCAN\" 'INSTALL-SIMPLE-SCAN'" "INSTALL-SIMPLE-SCAN"
                    ;;
               14)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_XNVIEWMP"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_XNVIEWMP\" 'AUR-INSTALL-XNVIEWMP'" "AUR-INSTALL-XNVIEWMP"
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
# INSTALL AV STUDIO {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_av_studio"
    USAGE="install_av_studio"
    DESCRIPTION=$(localize "INSTALL-AV-STUDIO-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-AV-STUDIO-DESC"  "Install AV Studio"
    #
    localize_info "INSTALL-AV-STUDIO-TITLE" "Audio Video Studio"
    localize_info "INSTALL-AV-STUDIO-INFO"  "Full List"
fi
# -------------------------------------
install_av_studio()
{
    # 6 sub 14
    print_title "INSTALL-AV-STUDIO-TITLE"
    print_info "INSTALL-AV-STUDIO-INFO" ": $AV_STUDIO" 
    #
    add_package "$AV_STUDIO"
    add_packagemanager "package_install \"$AV_STUDIO\" 'INSTALL-AUDIO-VIDEO-STUDIO'" "INSTALL-AUDIO-VIDEO-STUDIO" 
    if [[ "$GNOME_INSTALL" -eq 1 ]]; then
        add_package "$AV_STUDIO_GTK"
        add_packagemanager "package_install \"$AV_STUDIO_GTK\" 'INSTALL-AUDIO-VIDEO-STUDIO-GTK'" "INSTALL-AUDIO-VIDEO-STUDIO-GTK"
    fi
    #
    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
        add_package "$AV_STUDIO_KDE"
        add_packagemanager "package_install \"$AV_STUDIO_KDE\" 'INSTALL-AUDIO-VIDEO-STUDIO-KDE'" "INSTALL-AUDIO-VIDEO-STUDIO-KDE"
    else
        add_package "$AV_STUDIO_KDEGRAPHICS"
        add_packagemanager "package_install \"$AV_STUDIO_KDEGRAPHICS\" 'INSTALL-AUDIO-VIDEO-STUDIO-KDEGRAPHICS'" "INSTALL-AUDIO-VIDEO-STUDIO-KDEGRAPHICS"
    fi
    #
    add_aur_package "$AV_STUDIO_AUR"
    add_packagemanager "aur_package_install \"$AV_STUDIO_AUR\" 'AUR-INSTALL-AUDIO-VIDEO-STUDIO'" "AUR-INSTALL-AUDIO-VIDEO-STUDIO"
    if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
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
    localize_info "INSTALL-VIDEO-APPS-DESC"   "Install Video Apps"
    localize_info "INSTALL-VIDEO-APPS-MENU-1" "Players"
    localize_info "INSTALL-VIDEO-APPS-MENU-2" "Editors | Tools"
    localize_info "INSTALL-VIDEO-APPS-MENU-3" "Codecs"
fi
# -------------------------------------
install_video_apps_menu()
{
    # 9
    local -r menu_name="INSTALL-VIDEO-APPS"  # You must define Menu Name here
    local BreakableKey="D"                   # Q=Quit, D=Done, B=Back
    local RecommendedOptions="1-3"           # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-VIDEO-APPS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-APPS-MENU-1" "" "" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-APPS-MENU-2" "" "" "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-APPS-MENU-3" "" "" "" "MenuTheme[@]" # 3
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local S_OPT
        for S_OPT in ${OPTIONS[@]}; do
            case "$S_OPT" in
                1)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_video_players_menu
                    ;;
                2)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    install_video_editors_tools_menu
                    ;;
                3)  # 
                    MenuChecks[$((S_OPT - 1))]=1
                    add_package "$INSTALL_VIDEO_CODECS"
                    add_packagemanager "package_install \"$INSTALL_VIDEO_CODECS\"  'INSTALL-VIDEO-CODECS'" "INSTALL-VIDEO-CODECS"
                    if [[ "$ARCHI" != "x86_64" ]]; then
                        add_aur_package "$AUR_INSTALL_CODECS"
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_CODECS\" 'AUR-INSTALL-CODECS'" "AUR-INSTALL-CODECS"
                    else
                        add_aur_package "$AUR_INSTALL_CODECS_64"
                        add_packagemanager "aur_package_install \"$AUR_INSTALL_CODECS_64\" 'AUR-INSTALL-CODECS-64'" "AUR-INSTALL-CODECS-64"
                    fi
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
fi
# -------------------------------------
install_video_players_menu()
{
    local -r menu_name="INSTALL-VIDEO-PLAYERS"  # You must define Menu Name here
    local BreakableKey="B"                      # Q=Quit, D=Done, B=Back
    local RecommendedOptions="2 3 7 8"          # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions 4 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions  4 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions 1-9 $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-VIDEO-PLAYERS-DESC"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Audience-bzr"      "" "$AUR" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Gnome-mplayer"     "" ""     "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Parole"            "" ""     "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "MiniTube"          "" "$AUR" "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Miro"              "" ""     "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Rosa Media Player" "" "$AUR" "" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "SM Player"         "" ""     "" "MenuTheme[@]" # 7
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "VLC"               "" ""     "" "MenuTheme[@]" # 8
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "XBMC"              "" ""     "" "MenuTheme[@]" # 9
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
            case "$SS_OPT" in
                1)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_AUDIENCE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_AUDIENCE\" 'AUR-INSTALL-AUDIENCE'" "AUR-INSTALL-AUDIENCE"
                    ;;
                2)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_GNOME_MPLAYER"
                    add_packagemanager "package_install \"$INSTALL_GNOME_MPLAYER\"  'INSTALL-GNOME-MPLAYER'" "INSTALL-GNOME-MPLAYER"
                    ;;
                3)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_PAROLE"
                    add_packagemanager "package_install \"$INSTALL_PAROLE\" 'INSTALL-PAROLE'" "INSTALL-PAROLE"
                    ;;
                4)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_MINITUBE"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_MINITUBE\" 'AUR-INSTALL-MINITUBE'" "AUR-INSTALL-MINITUBE"
                    ;;
                5)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_MIRO"
                    add_packagemanager "package_install \"$INSTALL_MIRO\" 'INSTALL-MIRO'" "INSTALL-MIRO"
                    ;;
                6)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_aur_package "$AUR_INSTALL_ROSA_MEDIA_PLAYER"
                    add_packagemanager "aur_package_install \"$AUR_INSTALL_ROSA_MEDIA_PLAYER\" 'AUR-INSTALL-ROSA-MEDIA-PLAYER'" "AUR-INSTALL-ROSA-MEDIA-PLAYER"
                    ;;
                7)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_SMPLAYER"
                    add_packagemanager "package_install \"$INSTALL_SMPLAYER\" 'INSTALL-SMPLAYER'" "INSTALL-SMPLAYER"
                    ;;
                8)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_VLC"
                    add_packagemanager "package_install \"$INSTALL_VLC\" 'INSTALL-VLC'" "INSTALL-VLC"
                    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
                        add_package "$INSTALL_VLC_KDE"
                        add_packagemanager "package_install \"$INSTALL_VLC_KDE\" 'INSTALL-VLC-KDE'" "INSTALL-VLC-KDE"
                    fi
                    ;;
                9)  # 
                    MenuChecks[$((SS_OPT - 1))]=1
                    add_package "$INSTALL_XBNC"
                    add_packagemanager "package_install \"$INSTALL_XBNC\" 'INSTALL-XBNC'" "INSTALL-XBNC"
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
fi
# -------------------------------------
install_video_editors_tools_menu()
{
    local -r menu_name="INSTALL-VIDEO-EDITORS-TOOLS"  # You must define Menu Name here
    local BreakableKey="B"                            # Q=Quit, D=Done, B=Back
    local RecommendedOptions="4"                      # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
    #
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions 3 $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    #
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}/${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        print_title "INSTALL-VIDEO-EDITORS-TOOLS-TITLE"
        print_caution "${StatusBar1}" "${StatusBar2}"
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        #
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Arista-transcoder" "" "$AUR" "" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Transmageddon"     "" ""     "" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "KDEenlive"         "" ""     "" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Openshot"          "" ""     "" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Pitivi"            "" ""     "" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "Kazam-bzr"         "" "$AUR" "" "MenuTheme[@]" # 6
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        #
        local SS_OPT
        for SS_OPT in ${OPTIONS[@]}; do
           case "$SS_OPT" in
               1)  # 
                   MenuChecks[$((SS_OPT - 1))]=1
                   add_package "$AUR_INSTALL_ARISTA_TRANSCODER"
                   add_packagemanager "aur_package_install \"$AUR_INSTALL_ARISTA_TRANSCODER\" 'AUR-INSTALL-ARISTA-TRANSCODER'" "AUR-INSTALL-ARISTA-TRANSCODER"
                   ;;
               2)  # 
                   MenuChecks[$((SS_OPT - 1))]=1
                   add_package "$INSTALL_TRAMSMAGEDDON"
                   add_packagemanager "package_install \"$INSTALL_TRAMSMAGEDDON\" 'INSTALL-TRAMSMAGEDDON'" "INSTALL-TRAMSMAGEDDON"
                   ;;
               3)  # 
                   MenuChecks[$((SS_OPT - 1))]=1
                   add_package "$INSTALL_KDENLIVE"
                   add_packagemanager "package_install \"$INSTALL_KDENLIVE\" 'INSTALL-KDENLIVE'" "INSTALL-KDENLIVE"
                   ;;
               4)  # 
                   MenuChecks[$((SS_OPT - 1))]=1
                   add_package "$INSTALL_OPENSHOT"
                   add_packagemanager "package_install \"$INSTALL_OPENSHOT\" 'INSTALL-OPENSHOT'" "INSTALL-OPENSHOT"
                   ;;
               5)  # 
                   MenuChecks[$((SS_OPT - 1))]=1
                   add_package "$INSTALL_PITIVI"
                   add_packagemanager "package_install \"$INSTALL_PITIVI\" 'INSTALL-PITIVI'" "INSTALL-PITIVI"
                   ;;
               6)  # 
                   MenuChecks[$((SS_OPT - 1))]=1
                   add_aur_package "$AUR_INSTALL_KAZAM_BZR"
                   add_packagemanager "aur_package_install \"$AUR_INSTALL_KAZAM_BZR\" 'AUR-INSTALL-KAZAM-BZR'" "AUR-INSTALL-KAZAM-BZR"
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
    add_package "$INSTALL_SCIENCE_EDUCATION"
    add_packagemanager "package_install \"$INSTALL_SCIENCE_EDUCATION\" 'INSTALL-SCIENCE'" "INSTALL-SCIENCE"
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
        add_package "$INSTALL_NVIDIA"
        add_packagemanager "package_install \"$INSTALL_NVIDIA\" 'INSTALL-NVIDIA'" "INSTALL-NVIDIA"
        add_packagemanager "nvidia-xconfig" "RUN-NVIDIA-XCONFIG"
    elif [[ "$VIDEO_CARD" -eq 2 ]]; then    # Nouveau
        add_package "$INSTALL_NOUVEAU"
        add_packagemanager "package_install \"$INSTALL_NOUVEAU\" 'INSTALL-NOUVEAU'" "INSTALL-NOUVEAU"
        add_module "nouveau" "MODULE-NOUVEAU"
    elif [[ "$VIDEO_CARD" -eq 3 ]]; then    # Intel
        add_package "$INSTALL_INTEL"
        add_packagemanager "package_install \"$INSTALL_INTEL\" 'INSTALL-INTEL'" "INSTALL-INTEL"
    elif [[ "$VIDEO_CARD" -eq 4 ]]; then    # ATI
        add_package "$INSTALL_ATI"
        add_packagemanager "package_install \"$INSTALL_ATI\" 'INSTALL-ATI'" "INSTALL-ATI"
        add_module "radeon" "MODULE-RADEON"
    elif [[ "$VIDEO_CARD" -eq 5 ]]; then    # Vesa
        add_package "$INSTALL_VESA"
        add_packagemanager "package_install \"$INSTALL_VESA\" 'INSTALL-VESA'" "INSTALL-VESA"
    elif [[ "$VIDEO_CARD" -eq 6 ]]; then    # Virtualbox
        add_package "$INSTALL_VIRTUALBOX"
        add_packagemanager "package_install \"$INSTALL_VIRTUALBOX\" 'INSTALL-VIRTUALBOX'" "INSTALL-VIRTUALBOX"
        add_module "vboxguest" "MODULE-VIRUALBOX-GUEST"
        add_module "vboxsf"    "MODULE-VITRUALBOX-SF"
        add_module "vboxvideo" "MODULE-VIRTUALBOX-VIDEO"
        add_user_group "vboxsf"
    else
        write_error "INSTALL-VIDEO-CARD-NOW-WARN" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    fi
    #
    if [[ "$SHOW_PAUSE" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL VIDEO CARDS {{{
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
    local SUB_OPTIONS=""        
    if [[ "$INSTALL_TYPE" -eq 0 ]]; then   # Normal
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 1 ]]; then # Gamer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 2 ]]; then # Professional
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"        
    elif [[ "$INSTALL_TYPE" -eq 3 ]]; then # Programmer
        SUB_OPTIONS="$RecommendedOptions $BreakableKey"    
    fi
    # @FIX do a snoop and auto fill a recommendation
    # 
    local Last_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    local -a MenuChecks=( $(load_array "${MENU_PATH}" "${menu_name}.db" 0 0 ) ) # MENU_PATH is Global
    IFS="$Last_IFS"
    #
    StatusBar1="INSTALL-MENU-REC"
    StatusBar2="$RecommendedOptions"
    #
    while [[ 1 ]]; do
        #
        print_title "INSTALL-VIDEO-CARDS-TITLE" " - https://wiki.archlinux.org/index.php/HCL/Video_Cards"
        print_caution "${StatusBar1}" "${StatusBar2}"
        #
        local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
        # "nVidia" "Nouveau" "Intel" "ATI" "Vesa" "Virtualbox" "Skip"
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-1" "" "" "INSTALL-VIDEO-CARDS-MENU-1-I" "MenuTheme[@]" # 1
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-2" "" "" "INSTALL-VIDEO-CARDS-MENU-2-I" "MenuTheme[@]" # 2
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-3" "" "" "INSTALL-VIDEO-CARDS-MENU-3-I" "MenuTheme[@]" # 3
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-4" "" "" "INSTALL-VIDEO-CARDS-MENU-4-I" "MenuTheme[@]" # 4
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-5" "" "" "INSTALL-VIDEO-CARDS-MENU-5-I" "MenuTheme[@]" # 5
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-6" "" "" "INSTALL-VIDEO-CARDS-MENU-6-I" "MenuTheme[@]" # 6
        add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "INSTALL-VIDEO-CARDS-MENU-7" "" "" "INSTALL-VIDEO-CARDS-MENU-7-I" "MenuTheme[@]" # 7
        #
        print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
        #
        local Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
        read_input_options "$SUB_OPTIONS" "$BreakableKey"
        SUB_OPTIONS="" # Clear All previously entered Options so we do not repeat them
        BYPASS="$Old_BYPASS" # Restroe Bypass
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
                    break
                    ;;
                7)  # SKIP
                    MenuChecks[$((SS_OPT - 1))]=1
                    VIDEO_CARD=7 # 7 SKIP, No Video Card Installed
                    SS_OPT="$BreakableKey"
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
    finish 2
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

