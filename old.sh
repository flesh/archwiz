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
    echo " $SCRIPT_NAME      - prints this screen"  1>&2
    echo " $SCRIPT_NAME -d   - install with debugging help, must be first argument: ex: -dn"  1>&2
    echo " $SCRIPT_NAME -i   - $MENU_OPTION_I"  1>&2
    echo " $SCRIPT_NAME -l   - $MENU_OPTION_L"  1>&2
    echo " $SCRIPT_NAME -s   - create install_scripts for reviewing."  1>&2
    echo " $SCRIPT_NAME -n   - Network Troubleshooting."  1>&2
    echo " $SCRIPT_NAME -t   - Test Install: will check what packages it did not install, other checks, and create an error.log file."  1>&2
    echo " $SCRIPT_NAME -r   - Fix Pacman Repository"  1>&2
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
copy_file "$ERROR_LOG" "$ERROR_LOG.last.log" "$LINENO"
copy_file "$ACTIVITY_LOG" "$ACTIVITY_LOG.last.log" "$LINENO"
echo "# Error Log: $SCRIPT_NAME Version: $SCRIPT_VERSION on $DATE_TIME." > "$ERROR_LOG"
echo "# Log: $SCRIPT_NAME Version: $SCRIPT_VERSION on $DATE_TIME."  > "$ACTIVITY_LOG"
#
# @FIX add a menu item for Software install on a Live OS
while getopts ":dlntriuo" M_OPTION; do
    case $M_OPTION in
        d)
            DEBUGGING=1
            ;;
        l)
            #
            MOUNTPOINT=" " # Live mode only
            source "${FULL_SCRIPT_PATH}/${COMMON_SCRIPT_NAME}"
            set_debugging_mode "$LINENO"
            DRIVE_FORMATED=1
            install_loaded_software
            break;
            ;;
        n)
            #
            source "${FULL_SCRIPT_PATH}/${COMMON_SCRIPT_NAME}"
            set_debugging_mode "$LINENO"
            network_troubleshooting
            break;
            ;;
        t) 
            #
            MOUNTPOINT=" "
            source "${FULL_SCRIPT_PATH}/${COMMON_SCRIPT_NAME}"
            set_debugging_mode "$LINENO"
            # Assume Boot install mode
            #test_install
            load_software
            configure_user_account
            break;
            ;;
        r)
            #
            source "${FULL_SCRIPT_PATH}/${COMMON_SCRIPT_NAME}"
            set_debugging_mode "$LINENO"
            # Assume Boot install mode
            fix_repo
            break;
            ;;
        i)  # Install Software Mode
            MOUNTPOINT=" "
            source "${FULL_SCRIPT_PATH}/${COMMON_SCRIPT_NAME}"
            set_debugging_mode "$LINENO"
            print_title "Install Software"
            print_info "$TEXT_SCRIPT_ID"
            print_info $"$MENU_OPTION_A"
            # get_install_mode # Ask for install mode
            verify_config
            print_warning "Only use this Option if you just used $SCRIPT_NAME -a to install a new OS, it assues this, use mode -x to load eXtra Software on a Live OS that is already setup."
            print_this "Copy over all Configuration files to Live OS if you are using this for first time on a new install, since pacstrap may have overwritten some configuration files during installation."
            read_input_yn "Overwrite etc with custom saved files" 1
            if [[ "$YN_OPTION" -eq 1 ]]; then
                copy_dir "$SCRIPT_DIR/etc/" "/" "$LINENO"
            fi
            get_install_software 2
            break;
            ;;
        u)  # Upgrade all
            source "$FULL_SCRIPT_PATH/${COMMON_SCRIPT_NAME}"
            update_system
            break;
            ;;
        o)  # Optimize
            optimize_pacman 0
            break;
            ;;
    esac
done





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
    echo " $SCRIPT_NAME      - prints this screen"  1>&2
    echo " $SCRIPT_NAME -d   - install with debugging help, must be first argument: ex: -dn"  1>&2
    echo " $SCRIPT_NAME -a   - $MENU_OPTION_A"  1>&2
    echo " $SCRIPT_NAME -f   - Fast: Create a Bootable OS and option to install software list; using saved Configuration."  1>&2
    echo " $SCRIPT_NAME -s   - create install_scripts for reviewing."  1>&2
    echo " $SCRIPT_NAME -n   - Network Troubleshooting."  1>&2
    echo " $SCRIPT_NAME -t   - Test Install: will check what packages it did not install, other checks, and create an error.log file."  1>&2
    echo " $SCRIPT_NAME -r   - Fix Pacman Repository"  1>&2
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
cls
make_dir "$LOG_PATH" "$LINENO"
make_dir "$MENU_PATH" "$LINENO"
make_dir "$CONFIG_PATH" "$LINENO"
copy_file "${ERROR_LOG}"    "${ERROR_LOG}.last.log"    "$LINENO"
copy_file "${ACTIVITY_LOG}" "${ACTIVITY_LOG}.last.log" "$LINENO"
echo "# Error Log: $SCRIPT_NAME Version: $SCRIPT_VERSION on $DATE_TIME." > "$ERROR_LOG"
echo "# Log: $SCRIPT_NAME Version: $SCRIPT_VERSION on $DATE_TIME."  > "$ACTIVITY_LOG"
#
# @FIX add a menu item for Software install on a Live OS
while getopts ":dafnstuo" M_OPTION; do
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
        n)
            #
            set_debugging_mode "$LINENO"
            network_troubleshooting
            break;
            ;;
        s)
            #
            source "${FULL_SCRIPT_PATH}/${PACKAGE_SCRIPT_NAME}"
            set_debugging_mode "$LINENO"
            SAFE_MODE=1
            verify_config    
            run_script
            break;
            ;;
        t) 
            #
            cls
            set_debugging_mode "$LINENO"
            print_info "SCRIPT_DIR=[${SCRIPT_DIR}]\nFULL_SCRIPT_PATH=[${FULL_SCRIPT_PATH}]"
            # Assume Boot install mode
            #test_install
            #load_software
            #configure_user_account
            break;
            ;;
        u)  # Upgrade all
            copy_file "${CUSTOM_PACKAGES}" "${PACMAN_CACHE}" "$LINENO"
            update_system
            break;
            ;;
        o)  # Optimize
            PACSTRAP_PACKAGES="base base-devel sudo wget dbus git systemd haveged btrfs-progs xorg-xauth pkgfile aria2 rsync"
            optimize_pacman 1
            break;
            ;;
    esac
done


