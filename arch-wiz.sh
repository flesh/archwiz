#!/bin/bash
#
# LAST_UPDATE="30 Dec 2012 16:33"
#
#-------------------------------------------------------------------------------
# This script will install Arch Linux, although it could be adapted to install any Linux distro that uses the same package names.
# This Script Assumes you wish GPT disk format, and gives you the choice to use UEFI, BIOS or no boot loader.
# The first time you use it, you will want to build the Software Configuration, follow instructions.
# You have the Option of Installing Software, this is just a list of Configuration files, and will save a series of files for later use.
# After reboot you have the option to install software; you can load the Software list if you already saved it; or create a new one.
# If after reboot you have no Internet access, the Script will try to correct this, Network Troubleshooting might help if this fails, then the option to ping.
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
declare -i BOOT_PARTITION_NO=0
declare SCRIPT_STAGE="Alpha"
# -----------------------------------------------------------------------------
# BACKUP {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="backup"
    USAGE="backup"
    DESCRIPTION=$(localize "BACKUP-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="13 Dec 2012"
    REVISION="13 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "BACKUP-DESC"  "Backup all Configuration Files from Hard Drive to Flash."
fi
# -------------------------------------
backup()
{
    copy_file ${MOUNTPOINT}/etc/pacman.conf         "${FULL_SCRIPT_PATH}/etc/pacman.conf"         ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file ${MOUNTPOINT}/etc/pacman.d/mirrorlist "${FULL_SCRIPT_PATH}/etc/pacman.d/mirrorlist" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file ${MOUNTPOINT}/etc/fstab               "${FULL_SCRIPT_PATH}/etc/fstab"               ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file ${MOUNTPOINT}/etc/hosts               "${FULL_SCRIPT_PATH}/etc/hosts"               ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file ${MOUNTPOINT}/etc/hostname            "${FULL_SCRIPT_PATH}/etc/hostname"            ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file ${MOUNTPOINT}/etc/resolv.conf         "${FULL_SCRIPT_PATH}/etc/resolv.conf"         ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file ${MOUNTPOINT}/etc/locale.conf         "${FULL_SCRIPT_PATH}/etc/locale.conf"         ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file ${MOUNTPOINT}/etc/locale.gen          "${FULL_SCRIPT_PATH}/etc/locale.gen"          ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file ${MOUNTPOINT}/etc/sudoers             "${FULL_SCRIPT_PATH}/etc/sudoers"             ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file ${MOUNTPOINT}/etc/vconsole.conf       "${FULL_SCRIPT_PATH}/etc/vconsole.conf"       ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file ${MOUNTPOINT}/etc/conf.d/dhcpd        "${FULL_SCRIPT_PATH}/etc/conf.d/dhcpd"        ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file ${MOUNTPOINT}/etc/dhcpcd.conf         "${FULL_SCRIPT_PATH}/etc/dhcpcd.conf"         ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    #copy_file ${MOUNTPOINT}/etc/ssh/sshd_config     "${FULL_SCRIPT_PATH}/etc/ssh/sshd_config"     ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
}
#}}}
# -----------------------------------------------------------------------------
# INSTALL BASE SYSTEM {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="install_base_system"
    USAGE="install_base_system"
    DESCRIPTION=$(localize "INSTALL-BASE-SYSTEM-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "INSTALL-BASE-SYSTEM-DESC"        "Install Base System"
    #
    localize_info "INSTALL-BASE-SYSTEM-BASE-SYSTEM" "INSTALL BASE SYSTEM"
    localize_info "INSTALL-BASE-SYSTEM-MSG-1"       "Using the pacstrap script we install the base system. The base-devel package group will be installed also."
    localize_info "INSTALL-BASE-SYSTEM-COMPLETE"    "INSTALL BASE SYSTEM Completed..."
    localize_info "INSTALL-BASE-SYSTEM-ERROR"       "INSTALL BASE SYSTEM: pacstrap Failed!"
fi
# -------------------------------------
install_base_system()
{
    print_title "INSTALL-BASE-SYSTEM-BASE-SYSTEM" ' - https://wiki.archlinux.org/index.php/Beginners%27_Guide#Install_the_base_system'
    print_info "INSTALL-BASE-SYSTEM-MSG-1"
    #
    run_task_manager # May modify pacman.conf
    #
    local extras=""
    if [[ "$BOOT_SYSTEM_TYPE" -eq 0 ]]; then # Grub2 -> ("Grub2" "Syslinux" "Skip")
        if [[ "$UEFI" -eq 0 ]]; then # UEFI=0, BIOS=1 and NONE=2
           if [[ "$ARCHI" == "x86_64" ]]; then
              extras="os-prober grub2-efi-x86_64 efibootmgr"
           else
              extras="os-prober grub-efi-i386 efibootmgr"
           fi
        elif [[ "$UEFI" -eq 1 ]]; then # BIOS
            extras="os-prober grub grub-bios"
        fi
    elif [[ "$BOOT_SYSTEM_TYPE" -eq 1 ]]; then # "Syslinux" 
        extras="os-prober syslinux"
    fi
    #
    # @FIX Install Languages for each Locale
    #total="${#LOCALE_ARRAY1[@]}"
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
    if [[ "$PACMAN_REPO_TYPE" -eq 1 || "$PACMAN_REPO_TYPE" -eq 2 ]]; then # 1=Server
        extras="$extras nfs-utils"
    fi
    extras="$extras arj cabextract p7zip sharutils unace unrar unzip uudeview zip"

    #
    if [[ "$PACMAN_OPTIMIZER" -eq 1 ]]; then
        PACMAN_OPTIMIZE_PACKAGES="reflector aria2 rsync"
        optimize_pacman
    fi
    #
    PACSTRAP_PACKAGES="base base-devel sudo wget dbus git systemd systemd-sysvcompat haveged btrfs-progs xorg-xauth pkgfile $PACMAN_OPTIMIZE_PACKAGES $NETWORK_MANAGER $extras"
    #
    copy_dir "${FULL_SCRIPT_PATH}/etc/" "${MOUNTPOINT}/" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    #
    create_custom_repo 1
    #
    copy_file "${MOUNTPOINT}/etc/pacman.conf" "${FULL_SCRIPT_PATH}/etc/pacman.conf" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO" # Get Fresh Copy of pacman.conf
    #        
    
    #pacman_args+=(--cachedir="$newroot/var/cache/pacman/pkg")
    
    #if ! pacman -r "${MOUNTPOINT}" -S --noconfirm --needed "${pacman_args[@]}"; then die 'Failed to install packages to new root'; fi
    
    
    if ! pacstrap "${MOUNTPOINT}" ${PACSTRAP_PACKAGES} ; then # do not quote PACSTRAP_PACKAGES
        write_error    "INSTALL-BASE-SYSTEM-ERROR" " : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        print_warning  "INSTALL-BASE-SYSTEM-ERROR" " : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        pause_function "install_base_system FAILED : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        exit 1
    fi

    # pacman -Sy --noconfirm --needed --cachedir="$CUSTOM_PACKAGES" -r "${MOUNTPOINT}" "$PACSTRAP_PACKAGES" 
    # ${MOUNTPOINT}/var/cache/pacman/pkg
    #if [[ "$USE_PACMAN" -eq 1 ]]; then
    #    pacstrap ${MOUNTPOINT} "$PACSTRAP_PACKAGES" 
    #else
    #    copy_file "${FULL_SCRIPT_PATH}/pacstrap2" "/usr/bin/" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    #    #
    #    pacstrap2 ${MOUNTPOINT} "$PACSTRAP_PACKAGES"
    #fi
    # ADD KEYMAP TO THE NEW SETUP
    # $KM_FONT="lat9w-16"
    # $KM_FONT_MAP="8859-1_to_uni"
    # Note: As of systemd version 194, it uses the kernel font and keymap by default. 
    #       It is no longer necessary to leave KEYMAP= and FONT= empty.
    # Now files can be copied to MOUNTPOINT
    echo "KEYMAP=$KEYMAP" > ${MOUNTPOINT}/etc/vconsole.conf
    echo "FONT=\"\""     >> ${MOUNTPOINT}/etc/vconsole.conf
    echo "FONT_MAP=\"\"" >> ${MOUNTPOINT}/etc/vconsole.conf
    copy_file ${MOUNTPOINT}/etc/vconsole.conf "${FULL_SCRIPT_PATH}/etc/vconsole.conf" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    mv -f "${MOUNTPOINT}/${CUSTOM_PACKAGES_NAME}/" "${MOUNTPOINT}${MOUNTPOINT}/${CUSTOM_PACKAGES_NAME}/"
    print_info "INSTALL-BASE-SYSTEM-COMPLETE"
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# CONFIGURE AUR HELPER {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="configure_aur_helper"
    USAGE="configure_aur_helper"
    DESCRIPTION=$(localize "CONFIGURE-AUR-HELPER-DESC")
    NOTES=$(localize "CONFIGURE-AUR-HELPER-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "CONFIGURE-AUR-HELPER-DESC"  "Configure AUR Helper"
    localize_info "CONFIGURE-AUR-HELPER-NOTES" "Should only be run from Live Mode."
    #
    localize_info "CONFIGURE-AUR-HELPER-CONFIG-HELP"   "Configuring AUR Helper"
    localize_info "CONFIGURE-AUR-HELPER-NOT-INSTALLED" "Not Installed"
    localize_info "CONFIGURE-AUR-HELPER-INSTALLED"     "Installed"
fi
# -------------------------------------
configure_aur_helper()
{
    # base-devel installed with pacstrap
    if [[ "$AUR_HELPER" == 'yaourt' ]]; then
        if ! check_package "yaourt" ; then
            print_info "CONFIGURE-AUR-HELPER-CONFIG-HELP" " $AUR_HELPER"
            package_install "yajl namcap" "INSTALL-AUR-HELPER-$AUR_HELPER"
            pacman -D --asdeps yajl namcap
            if ! aur_download_packages "package-query yaourt" ; then
                write_error    "CONFIGURE-AUR-HELPER-NOT-INSTALLED" " $AUR_HELPER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                print_warning  "CONFIGURE-AUR-HELPER-NOT-INSTALLED" " $AUR_HELPER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                if ! aur_download_packages "package-query yaourt" ; then
                    write_error    "CONFIGURE-AUR-HELPER-NOT-INSTALLED" " $AUR_HELPER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                    print_warning  "CONFIGURE-AUR-HELPER-NOT-INSTALLED" " $AUR_HELPER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                    pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                    return 1
                fi    
            else
                print_info "CONFIGURE-AUR-HELPER-INSTALLED" " $AUR_HELPER"        
            fi
            pacman -D --asdeps package-query
            if ! check_package "yaourt" ; then
                print_warning "CONFIGURE-AUR-HELPER-NOT-INSTALLED" ": $AUR_HELPER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                write_error   "CONFIGURE-AUR-HELPER-NOT-INSTALLED" ": $AUR_HELPER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                # @FIX how to fix this
                pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                return 1
            fi
        fi
    elif [[ "$AUR_HELPER" == 'packer' ]]; then
        if ! check_package "packer" ; then
            print_info "CONFIGURE-AUR-HELPER-CONFIG-HELP" " $AUR_HELPER"
            package_install "git jshon" "INSTALL-AUR-HELPER-$AUR_HELPER"
            pacman -D --asdeps jshon
            aur_download_packages "packer"
            if ! check_package "packer" ; then
                echo "Packer not installed. EXIT now"
                write_error    "CONFIGURE-AUR-HELPER-NOT-INSTALLED" " $AUR_HELPER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                print_warning  "CONFIGURE-AUR-HELPER-NOT-INSTALLED" " $AUR_HELPER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                return 1
            fi
        fi
    elif [[ "$AUR_HELPER" == 'pacaur' ]]; then
        if ! check_package "pacaur" ; then
            print_info "CONFIGURE-AUR-HELPER-CONFIG-HELP" " $AUR_HELPER"
            package_install "yajl expac" "INSTALL-AUR-HELPER-$AUR_HELPER"
            pacman -D --asdeps yajl expac
            #fix pod2man path
            ln -s /usr/bin/core_perl/pod2man /usr/bin/
            aur_download_packages "cower pacaur"
            pacman -D --asdeps cower
            if ! check_package "pacaur" ; then
                echo "Pacaur not installed. EXIT now"
                write_error    "CONFIGURE-AUR-HELPER-NOT-INSTALLED" " $AUR_HELPER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                print_warning  "CONFIGURE-AUR-HELPER-NOT-INSTALLED" " $AUR_HELPER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                return 1
            fi
        fi
    fi
    $AUR_HELPER -S python3-aur
    # $AUR_HELPER -Syua --devel --noconfirm # Do I need to do this?
    return 0
}
#}}}
# -----------------------------------------------------------------------------
# CONFIGURE SUDO {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="configure_sudo"
    USAGE="configure_sudo"
    DESCRIPTION=$(localize "CONFIGURE-SUDO-DESC")
    NOTES=$(localize "CONFIGURE-SUDO-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "CONFIGURE-SUDO-DESC"  "Configure sudo"
    localize_info "CONFIGURE-SUDO-NOTES" "Called from Boot Mode."
    #
    localize_info "CONFIGURE-SUDO-COMPLETE" "Sudo Configured"
    localize_info "CONFIGURE-SUDO-SUDO" "SUDO"
fi
# -------------------------------------
configure_sudo()
{
    # sudo is installed during pacstrap
    if [[ ! -f  "${MOUNTPOINT}/etc/sudoers-old" ]]; then                            # Used to get the lastest sudoers file from ISO boot OS
        copy_file "/etc/sudoers" "${MOUNTPOINT}/etc/sudoers-old" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        if ! is_string_in_file "${MOUNTPOINT}/etc/sudoers" "$FILE_SIGNATURE" ; then # Only make changes once
            echo "$FILE_SIGNATURE"                                            >> ${MOUNTPOINT}/etc/sudoers
            ## Uncomment to allow members of group wheel to execute any command
            sed -i '/%wheel ALL=(ALL) ALL/s/^#//' ${MOUNTPOINT}/etc/sudoers
            ## This config is especially helpful for those using terminal multiplexers like screen, tmux, or ratpoison, and those using sudo from scripts/cronjobs:
            echo ' '                                                          >> ${MOUNTPOINT}/etc/sudoers
            echo 'Defaults !requiretty, !tty_tickets, !umask'                 >> ${MOUNTPOINT}/etc/sudoers
            echo 'Defaults visiblepw, path_info, insults, lecture=always'     >> ${MOUNTPOINT}/etc/sudoers
            echo 'Defaults loglinelen = 0, logfile =/var/log/sudo.log, log_year, log_host, syslog=auth' >> ${MOUNTPOINT}/etc/sudoers
            echo 'Defaults passwd_tries = 8, passwd_timeout = 1'              >> ${MOUNTPOINT}/etc/sudoers
            echo 'Defaults env_reset, always_set_home, set_home, set_logname' >> ${MOUNTPOINT}/etc/sudoers
            # @FIX for each EDITOR
            if [[ "$EDITOR" == "nano" ]]; then
                echo 'Defaults !env_editor, editor=/usr/bin/nano:/usr/bin/vim:/usr/bin/vi' >> ${MOUNTPOINT}/etc/sudoers
            else
                echo 'Defaults !env_editor, editor=/usr/bin/vim:/usr/bin/vi:/usr/bin/nano' >> ${MOUNTPOINT}/etc/sudoers
            fi
            #
            echo 'Defaults timestamp_timeout=300'                 >> ${MOUNTPOINT}/etc/sudoers
            echo 'Defaults passprompt="[sudo] password for %u: "' >> ${MOUNTPOINT}/etc/sudoers
            #echo "Defaults:${USERNAME} timestamp_timeout=300"     >> ${MOUNTPOINT}/etc/sudoers
            ## Allow user to execute any command with sudo and password 
            echo "${USERNAME}   ALL=(ALL) ALL"                    >> ${MOUNTPOINT}/etc/sudoers
            ## Uncomment to allow user to execute any command with No Password; not secure
            ## Make sure you disable this after software install.
            echo "$FILE_SIGNATURE COMMENT-OUT"                    >> ${MOUNTPOINT}/etc/sudoers
            echo "Defaults:${USERNAME}   !authenticate"           >> ${MOUNTPOINT}/etc/sudoers
            chown -c root:root ${MOUNTPOINT}/etc/sudoers
            chmod -c 0440 ${MOUNTPOINT}/etc/sudoers
        fi
        copy_file "${MOUNTPOINT}/etc/sudoers" "${FULL_SCRIPT_PATH}/etc/sudoers" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    fi
    print_this "CONFIGURE-SUDO-COMPLETE"
}
#}}}
# -----------------------------------------------------------------------------
# RUN TASK MANAGER  {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="run_task_manager"
    USAGE="run_task_manager"
    DESCRIPTION=$(localize "RUN-TASK-MANAGER-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "RUN-TASK-MANAGER-DESC"  "Run Task"
    #   
    localize_info "RUN-TASK-MANAGER-ERROR" "Error in run_task_manager..."
    localize_info "RUN-TASK-MANAGER-INFO"  "Install TASK MANAGER..."
fi
# -------------------------------------
run_task_manager()
{
    # Install TASKMANAGER
    if [[ "${#TASKMANAGER}" -ne 0 ]]; then
        print_info "RUN-TASK-MANAGER-INFO"
        total="${#TASKMANAGER[@]}"
        for (( index=0; index<${total}; index++ )); do
            # @FIX test return logic; 0 = success; 
            eval "${TASKMANAGER[$index]}"
            if [ "$?" -eq 0 ]; then
                write_log "$TASKMANAGER_NAME - ${TASKMANAGER[$index]}" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            else
                write_error   "RUN-TASK-MANAGER-ERROR" " $TASKMANAGER_NAME - ${TASKMANAGER[$index]} -> $(basename $BASH_SOURCE) : $LINENO"
                print_warning "RUN-TASK-MANAGER-ERROR" " $TASKMANAGER_NAME - ${TASKMANAGER[$index]} -> $(basename $BASH_SOURCE) : $LINENO"
                if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "eval TASKMANAGER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO (line by line errors)"; fi
            fi
        done
        # Copy all files that can be changed by Task Manager
        copy_file "/etc/pacman.conf" "${MOUNTPOINT}/etc/pacman.conf" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO" # Get Copy of pacman.conf
        copy_file "/etc/pacman.conf" "${FULL_SCRIPT_PATH}/etc/pacman.conf" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO" # Get Copy of pacman.conf
        REFRESH_REPO=1
        refresh_pacman
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "eval TASKMANAGER : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
}
#}}}
# -----------------------------------------------------------------------------
# WRITE SECRET  {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="write_secret"
    USAGE="write_secret"
    DESCRIPTION=$(localize "WRITE SECRET-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "WRITE SECRET-DESC"  "Write Secret"
fi    
# -------------------------------------    
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
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="get_secret"
    USAGE="get_secret"
    DESCRIPTION=$(localize "GET-SECRET-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "GET-SECRET-DESC"  "Get Secret"
fi    
# -------------------------------------
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
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="delete_secret"
    USAGE="delete_secret @1[root_user or user_user]"
    DESCRIPTION=$(localize "DELETE-SECRET-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "DELETE-SECRET-DESC"  "Delete Secret"
fi
# -------------------------------------
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
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="create_script_lib"
    USAGE="create_script_lib"
    DESCRIPTION=$(localize "CREATE-SCRIPT-LIB-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "CREATE-SCRIPT-LIB-DESC"  "Create Script to run in arch-chroot"
fi
# -------------------------------------
create_script_lib()
{
    touch ${MOUNTPOINT}/install_scripts
    chmod a+x ${MOUNTPOINT}/install_scripts
    echo "#!/bin/bash" > ${MOUNTPOINT}/install_scripts
    echo "# install_scripts $ARCH_WIZ_SCRIPT_NAME Version: $SCRIPT_VERSION on $DATE_TIME This script will run from arch-chroot." >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    echo "declare -i REFRESH_REPO=1" >> ${MOUNTPOINT}/install_scripts
    echo "USERNAME=\"$USERNAME\"" >> ${MOUNTPOINT}/install_scripts
    # ------------------------- Library ------------------------------------------------ 
    echo "# *************** Library *****************************" >> ${MOUNTPOINT}/install_scripts
    echo "BWhite='\\e[1;37m'       # White" >> ${MOUNTPOINT}/install_scripts
    echo "White='\\e[0;37m'        # White" >> ${MOUNTPOINT}/install_scripts
    echo "BRed='\\e[1;31m'         # Red" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    #
    echo "pause_function()" >> ${MOUNTPOINT}/install_scripts
    echo "{ #{{{" >> ${MOUNTPOINT}/install_scripts
    echo "    print_line" >> ${MOUNTPOINT}/install_scripts
    echo "    read -e -sn 1 -p \"Press any key to continue (\$1)...\"" >> ${MOUNTPOINT}/install_scripts
    echo "} #}}}" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    #
    echo "# TRIM {{{" >> ${MOUNTPOINT}/install_scripts
    echo "trim()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts
    echo "    echo \$(rtrim \"\$(ltrim \"\$1\")\")" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts
    echo "#}}}" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    echo "# LEFT TRIM {{{" >> ${MOUNTPOINT}/install_scripts
    echo "ltrim()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts
    echo "    echo \"\$1\" | sed 's/^ *//g'" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    echo "#}}}" >> ${MOUNTPOINT}/install_scripts
    echo "# RIGHT TRIM {{{" >> ${MOUNTPOINT}/install_scripts
    echo "rtrim()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts
    echo "    echo \"\$1\" | sed 's/ *$//g'" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts
    echo "#}}}" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    #
    echo "# CHECK PACKAGE {{{" >> ${MOUNTPOINT}/install_scripts
    echo "check_package()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts
    echo "    # check if a package is already installed" >> ${MOUNTPOINT}/install_scripts
    echo "    for PACKAGE in \$1; do" >> ${MOUNTPOINT}/install_scripts
    echo "        pacman -Q \"\$PACKAGE\" &> /dev/null && return 0;" >> ${MOUNTPOINT}/install_scripts
    echo "    done" >> ${MOUNTPOINT}/install_scripts
    echo "    return 1" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts
    echo "#}}}" >> ${MOUNTPOINT}/install_scripts    
    echo "#" >> ${MOUNTPOINT}/install_scripts
    #
    echo "# PACKAGE REMOVE {{{" >> ${MOUNTPOINT}/install_scripts
    echo "package_remove()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts 
    echo "    REMOVE_PACKAGES=\" \"" >> ${MOUNTPOINT}/install_scripts
    echo "    for PACKAGE in \$1; do" >> ${MOUNTPOINT}/install_scripts
    echo "        if check_package \"\$PACKAGE\" ; then" >> ${MOUNTPOINT}/install_scripts
    echo "            REMOVE_PACKAGES=\"\$REMOVE_PACKAGES \$PACKAGE\"" >> ${MOUNTPOINT}/install_scripts
    echo "        fi" >> ${MOUNTPOINT}/install_scripts
    echo "    done" >> ${MOUNTPOINT}/install_scripts
    echo "    REMOVE_PACKAGES=\$(trim \"\$REMOVE_PACKAGES\")" >> ${MOUNTPOINT}/install_scripts
    echo "    for PACKAGE in \$REMOVE_PACKAGES; do" >> ${MOUNTPOINT}/install_scripts
    echo "        pacman -Rcsn --noconfirm \"\$PACKAGE\"" >> ${MOUNTPOINT}/install_scripts
    echo "    done" >> ${MOUNTPOINT}/install_scripts
    echo "} #}}}" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    #
    echo "# PRINT LINE {{{" >> ${MOUNTPOINT}/install_scripts
    echo "print_line()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts
    echo "    printf \"%\$(tput cols)s\\n\"|tr ' ' '-'" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts 
    echo "#}}}" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    #
    echo "# PRINT TITLE {{{" >> ${MOUNTPOINT}/install_scripts
    echo "print_title()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts
    echo "    clear" >> ${MOUNTPOINT}/install_scripts
    echo "    print_line" >> ${MOUNTPOINT}/install_scripts
    echo "    echo -e \"# \${BWhite}\$1\${White}\"" >> ${MOUNTPOINT}/install_scripts
    echo "    print_line" >> ${MOUNTPOINT}/install_scripts
    echo "    echo ''" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts 
    echo "#}}}" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    #
    echo "# PRINT INFO {{{" >> ${MOUNTPOINT}/install_scripts
    echo "print_info()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts
    echo "    # Console width number" >> ${MOUNTPOINT}/install_scripts
    echo "    T_COLS=\`tput cols\`" >> ${MOUNTPOINT}/install_scripts
    echo "    echo -e \"\${BWhite}\$1\${White}\\n\" | fold -sw \$(( \$T_COLS - 18 )) | sed 's/^/\\t/'" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts 
    echo "#}}}" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    #
    echo "# PRINT WARNING {{{" >> ${MOUNTPOINT}/install_scripts
    echo "print_warning()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts 
    echo "    # Console width number" >> ${MOUNTPOINT}/install_scripts
    echo "    T_COLS=\`tput cols\`" >> ${MOUNTPOINT}/install_scripts
    echo "    echo -e \"\${BRed}\$1\${White}\\n\" | fold -sw \$(( \$T_COLS - 1 ))" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts 
    echo "#}}}" >> ${MOUNTPOINT}/install_scripts   
    echo "#" >> ${MOUNTPOINT}/install_scripts
    #
    echo "#PACKMAN PACKAGE SIGNING {{{" >> ${MOUNTPOINT}/install_scripts
    echo "configure_pacman_package_signing()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts
    echo "    if [[ ! -d /etc/pacman.d/gnupg ]]; then" >> ${MOUNTPOINT}/install_scripts
    echo "        print_title \"PACMAN PACKAGE SIGNING - https://wiki.archlinux.org/index.php/Pacman-key\"" >> ${MOUNTPOINT}/install_scripts
    echo "        print_info \"Pacman-key is a new tool available with pacman 4. It allows the user to manage pacmans list of trusted keys in the new package signing implementation.\"" >> ${MOUNTPOINT}/install_scripts
    echo "        haveged -w 1024" >> ${MOUNTPOINT}/install_scripts
    echo "        pacman-key --init --keyserver pgp.mit.edu" >> ${MOUNTPOINT}/install_scripts
    echo "        pacman-key --populate archlinux" >> ${MOUNTPOINT}/install_scripts
    echo "        killall haveged" >> ${MOUNTPOINT}/install_scripts
    echo "        package_remove \"haveged\"" >> ${MOUNTPOINT}/install_scripts
    echo "    fi" >> ${MOUNTPOINT}/install_scripts
    echo "    echo \$\"Pacman Package Signing Configured\"" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts
    echo "#}}}" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    #
    echo "#SYSTEM UPDATE {{{" >> ${MOUNTPOINT}/install_scripts
    echo "system_upgrade()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts
    echo "    print_title \"UPDATING YOUR SYSTEM\"" >> ${MOUNTPOINT}/install_scripts
    echo "    pacman -Syu --noconfirm" >> ${MOUNTPOINT}/install_scripts
    echo "    REFRESH_REPO=0" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts
    echo "#}}}" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    #
    echo "# GET AUR PACKAGES {{{" >> ${MOUNTPOINT}/install_scripts
    echo "get_aur_packages()" >> ${MOUNTPOINT}/install_scripts
    echo "{ #{{{" >> ${MOUNTPOINT}/install_scripts
    echo "    #" >> ${MOUNTPOINT}/install_scripts
    echo "    echo \"Downloading: \$1.tar.gz from https://aur.archlinux.org/packages/\${1:0:2}/\$1/\$1.tar.gz\"" >> ${MOUNTPOINT}/install_scripts
    echo "    curl -o \$1.tar.gz https://aur.archlinux.org/packages/\${1:0:2}/\$1/\$1.tar.gz" >> ${MOUNTPOINT}/install_scripts
    echo "    if [ -f \"\$1.tar.gz\" ]; then" >> ${MOUNTPOINT}/install_scripts
    echo "        if tar zxvf \$1.tar.gz ; then" >> ${MOUNTPOINT}/install_scripts
    echo "            rm \$1.tar.gz" >> ${MOUNTPOINT}/install_scripts
    echo "            cd \$1" >> ${MOUNTPOINT}/install_scripts
    echo "            makepkg -si --noconfirm" >> ${MOUNTPOINT}/install_scripts
    echo "         else" >> ${MOUNTPOINT}/install_scripts
    echo "             echo \"File Currupted: curl -o \$1.tar.gz https://aur.archlinux.org/packages/\${1:0:2}/\$1/\$1.tar.gz\"" >> ${MOUNTPOINT}/install_scripts
    echo "         fi" >> ${MOUNTPOINT}/install_scripts
    echo "    else" >> ${MOUNTPOINT}/install_scripts
    echo "        echo \"File Not Found: curl -o \$1.tar.gz https://aur.archlinux.org/packages/\${1:0:2}/\$1/\$1.tar.gz\"" >> ${MOUNTPOINT}/install_scripts
    echo "    fi" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts
    echo "#}}}" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    echo "export -f get_aur_packages" >> ${MOUNTPOINT}/install_scripts
    #
    echo "package_install()" >> ${MOUNTPOINT}/install_scripts
    echo "{ #{{{" >> ${MOUNTPOINT}/install_scripts
    echo "    if [[ \$REFRESH_REPO -eq 1 ]]; then" >> ${MOUNTPOINT}/install_scripts
    echo "        echo \"Update Pacman Database.\"" >> ${MOUNTPOINT}/install_scripts
    echo "        pacman -Syy" >> ${MOUNTPOINT}/install_scripts
    echo "        REFRESH_REPO=0" >> ${MOUNTPOINT}/install_scripts
    echo "    fi" >> ${MOUNTPOINT}/install_scripts
    echo "    # install packages using pacman" >> ${MOUNTPOINT}/install_scripts
    echo "    for PACKAGE in \$1; do" >> ${MOUNTPOINT}/install_scripts
    echo "        if ! check_package \"\$PACKAGE\" ; then" >> ${MOUNTPOINT}/install_scripts
    echo "            pacman -S --noconfirm --needed \"\$PACKAGE\"" >> ${MOUNTPOINT}/install_scripts 
    echo "        fi" >> ${MOUNTPOINT}/install_scripts
    echo "    done" >> ${MOUNTPOINT}/install_scripts
    echo "} #}}}" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    #
    echo "# GET SECRET {{{" >> ${MOUNTPOINT}/install_scripts
    echo "get_secret()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts
    echo "    # @FIX Add decryption escape special characters" >> ${MOUNTPOINT}/install_scripts
    echo "    if [[ \"\$1\" == \"root_user\" ]]; then" >> ${MOUNTPOINT}/install_scripts
    echo "        source install_scripts_root_secrets" >> ${MOUNTPOINT}/install_scripts
    echo "    elif [[ \"\$1\" == \"user_user\" ]]; then" >> ${MOUNTPOINT}/install_scripts
    echo "        source install_scripts_user_secrets" >> ${MOUNTPOINT}/install_scripts
    echo "    fi" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts
    echo "#}}}" >> ${MOUNTPOINT}/install_scripts
    echo "# MAKE DIR {{{" >> ${MOUNTPOINT}/install_scripts
    echo "make_dir()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts
    # @FIX update function
    echo "    [[ ! -d \"\$1\" ]] && mkdir -p \"\$1\"" >> ${MOUNTPOINT}/install_scripts 
    echo "}" >> ${MOUNTPOINT}/install_scripts
    echo "#}}}" >> ${MOUNTPOINT}/install_scripts
    #
    echo "is_user_in_group()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts
    echo "    groups \"\$USERNAME\" | grep \"\$1\"" >> ${MOUNTPOINT}/install_scripts
    echo "    return \"\$?\"" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts
    #
    echo "add_user_2_group()" >> ${MOUNTPOINT}/install_scripts
    echo "{" >> ${MOUNTPOINT}/install_scripts
    echo "    if ! is_user_in_group \"\$1\" ; then" >> ${MOUNTPOINT}/install_scripts
    echo "        gpasswd -a \"\$USERNAME\" \"\$1\"" >> ${MOUNTPOINT}/install_scripts
    #echo "        write_log \"add_user_2_group \$1" >> ${MOUNTPOINT}/install_scripts    # @FIX add command
    echo "    else" >> ${MOUNTPOINT}/install_scripts
    echo "        pause_function \"add_user_2_group [\$1] failed at line: \$(basename \$BASH_SOURCE) \$LINENO\"" >> ${MOUNTPOINT}/install_scripts; 
    echo "    fi" >> ${MOUNTPOINT}/install_scripts
    echo "}" >> ${MOUNTPOINT}/install_scripts
    # ------------------------- End Library ------------------------------------------------ 
}
#}}}
# -----------------------------------------------------------------------------
# CREATE INSTALL SCRIPTS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="create_script_boot"
    USAGE="create_script_boot"
    DESCRIPTION=$(localize "CREATE-INSTALL-SCRIPTS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "CREATE-INSTALL-SCRIPTS-DESC"  "Create Script Boot, which gets run in arch-chroot to install bootloader"
fi
# -------------------------------------
create_script_boot()
{
    echo "print_title \$\"Installing Arch Linux\"" >> ${MOUNTPOINT}/install_scripts
    # Install all software need to do this task; i.e. hostnamectl requires systemd, also it seems systemd will not work till reboot
    # echo "pacman -S " >> ${MOUNTPOINT}/install_scripts
    #
    echo "print_info \$\"Mount boot partitions...\"" >> ${MOUNTPOINT}/install_scripts
    # remount here or grub gets confused
    # Always on the Second Partition, but lets keep track
    # echo "mkdir -p /boot" > ${MOUNTPOINT}/install_scripts
    if [[ "$BOOT_PARTITION_NO" -ne 0 ]]; then        
        echo "mount -t ext2 /dev/${INSTALL_DEVICE}${BOOT_PARTITION_NO} /boot" >> ${MOUNTPOINT}/install_scripts
    fi
    if [[ "$UEFI" -eq 0 ]]; then # UEFI=0
        # Always on the first Partition
        # echo "mkdir -p /boot/efi" > ${MOUNTPOINT}/install_scripts
        echo "mount -t vfat /dev/${INSTALL_DEVICE}1 /boot/efi" >> ${MOUNTPOINT}/install_scripts        
    elif [[ "$UEFI" -eq 1 ]]; then # BIOS=1 
        # Always on the first Partition
        # echo "mkdir -p /boot/efi" > ${MOUNTPOINT}/install_scripts
        echo "mount -t vfat /dev/${INSTALL_DEVICE}1 /boot" >> ${MOUNTPOINT}/install_scripts        
    fi
    if [[ "$DEBUGGING" -eq 1 ]]; then echo "pause_function \"Mount Drives \$(basename \$BASH_SOURCE)  \$LINENO\"" >> ${MOUNTPOINT}/install_scripts; fi
    #        
    # Resolv Nameservers
    if [[ "$IS_CUSTOM_NAMESERVER" -eq 1 ]]; then
        echo "print_info \$\"Resolv...\"" >> ${MOUNTPOINT}/install_scripts
        #echo "mkdir -p /etc" >> ${MOUNTPOINT}/install_scripts
        echo "if [[ -f /etc/resolv.conf ]]; then" >> ${MOUNTPOINT}/install_scripts
        echo "   chattr -i /etc/resolv.conf" >> ${MOUNTPOINT}/install_scripts # Un Write Protect it
        echo "fi" >> ${MOUNTPOINT}/install_scripts
        echo "touch /etc/resolv.conf" >> ${MOUNTPOINT}/install_scripts
        echo "echo \"# Created: $DATE_TIME\" > /etc/resolv.conf" >> ${MOUNTPOINT}/install_scripts
        echo "echo '# /etc/resolv.conf' >> /etc/resolv.conf" >> ${MOUNTPOINT}/install_scripts
        echo "echo '#' >> /etc/resolv.conf" >> ${MOUNTPOINT}/install_scripts
        echo "echo '# search <yourdomain.tld>' >> /etc/resolv.conf" >> ${MOUNTPOINT}/install_scripts
        echo "echo '# nameserver <ip>' >> /etc/resolv.conf" >> ${MOUNTPOINT}/install_scripts
        if [[ -n "$CUSTOM_NS1" ]]; then
            echo "echo \"nameserver $CUSTOM_NS1\" > /etc/resolv.conf" >> ${MOUNTPOINT}/install_scripts
        fi
        if [[ -n "$CUSTOM_NS2" ]]; then
            echo "echo \"nameserver $CUSTOM_NS2\" >> /etc/resolv.conf" >> ${MOUNTPOINT}/install_scripts
        fi
        echo "echo 'nameserver 127.0.1.1' >> /etc/resolv.conf" >> ${MOUNTPOINT}/install_scripts
        if [[ -n $CUSTOM_NS_SEARCH ]]; then
            echo "echo 'search $CUSTOM_NS_SEARCH' >> /etc/resolv.conf" >> ${MOUNTPOINT}/install_scripts
        fi
        echo "chattr +i /etc/resolv.conf" >> ${MOUNTPOINT}/install_scripts # Write Protect it
        # https://wiki.archlinux.org/index.php/Resolv.conf
        echo "mkdir -p /etc/conf.d" >> ${MOUNTPOINT}/install_scripts
        echo "touch /etc/conf.d/dhcpd" >> ${MOUNTPOINT}/install_scripts
        echo "echo 'DHCPD_ARGS=\"-R -t 30 -h \$HOSTNAME\"' > /etc/conf.d/dhcpd" >> ${MOUNTPOINT}/install_scripts # DHCP will overwrite this file each reboot if you don not do this
        echo "touch /etc/dhcpcd.conf" >> ${MOUNTPOINT}/install_scripts
        echo "echo 'nohook resolv.conf' >> /etc/dhcpcd.conf" >> ${MOUNTPOINT}/install_scripts # DHCP will overwrite this file each reboot if you don not do this
        if [[ "$DEBUGGING" -eq 1 ]]; then 
            echo "cat /etc/resolv.conf" >> ${MOUNTPOINT}/install_scripts; 
            echo "pause_function \"cat /etc/resolv.conf \$(basename \$BASH_SOURCE) \$LINENO\"" >> ${MOUNTPOINT}/install_scripts; 
        fi
    fi
    echo "touch /etc/locale.conf" >> ${MOUNTPOINT}/install_scripts
    if [[ "${#LOCALE_ARRAY}" -ne 0 ]]; then
        echo "print_info \$\"Locale...\"" >> ${MOUNTPOINT}/install_scripts
        total="${#LOCALE_ARRAY[@]}"
        for (( index=0; index<${total}; index++ )); do
            if [[ "$index" -eq 0 ]]; then
                echo "echo 'LANG=\"${LOCALE_ARRAY[$index]}.UTF-8\"' > /etc/locale.conf" >> ${MOUNTPOINT}/install_scripts
            else
                echo "echo 'LANG=\"${LOCALE_ARRAY[$index]}.UTF-8\"' >> /etc/locale.conf" >> ${MOUNTPOINT}/install_scripts
            fi
            echo "sed -i '/'${LOCALE_ARRAY[$index]}'/s/^#//' /etc/locale.gen" >> ${MOUNTPOINT}/install_scripts
        done
    fi
    if [[ "$DEBUGGING" -eq 1 ]]; then 
        echo "cat /etc/locale.conf" >> ${MOUNTPOINT}/install_scripts
        echo "pause_function \"cat /etc/locale.conf line \$(basename \$BASH_SOURCE) \$LINENO\"" >> ${MOUNTPOINT}/install_scripts
    fi
    # echo "echo 'LANG=\"${LOCALE}.UTF-8\"' > /etc/locale.conf" >> ${MOUNTPOINT}/install_scripts
    # or   sed -i '/'$LOCALE'/s/^#//' /etc/locale.gen
    # echo "sed -i \"s/#(${LOCALE}\.UTF-8.*$)/\1/\" /etc/locale.gen" >> ${MOUNTPOINT}/install_scripts
    echo "print_info \$\"Locale-gen...\"" >> ${MOUNTPOINT}/install_scripts
    echo "locale-gen" >> ${MOUNTPOINT}/install_scripts 
    if [[ "$DEBUGGING" -eq 1 ]]; then 
        echo "pause_function \"locale-gen \$(basename \$BASH_SOURCE) \$LINENO\"" >> ${MOUNTPOINT}/install_scripts; 
    fi
    # hwclock
    echo "print_info \$\"hwclock...\"" >> ${MOUNTPOINT}/install_scripts
    echo "hwclock --systohc --utc" >> ${MOUNTPOINT}/install_scripts
    # mkinitcpio
    echo "print_info \$\"mkinitcpio...\"" >> ${MOUNTPOINT}/install_scripts
    echo "mkinitcpio -p linux" >> ${MOUNTPOINT}/install_scripts # disable configure_mkinitcpio
    if [[ "$DEBUGGING" -eq 1 ]]; then 
        echo "pause_function \"mkinitcpio \$(basename \$BASH_SOURCE) \$LINENO\"" >> ${MOUNTPOINT}/install_scripts; 
    fi
    # Add passwords and Users
    echo "echo ''" >> ${MOUNTPOINT}/install_scripts
    echo "echo ''" >> ${MOUNTPOINT}/install_scripts
    echo "print_info \$\"Setup Root Password\"" >> ${MOUNTPOINT}/install_scripts
    echo "get_secret 'root_user'" >> ${MOUNTPOINT}/install_scripts
    echo "" >> ${MOUNTPOINT}/install_scripts
    echo "echo ''" >> ${MOUNTPOINT}/install_scripts
    echo "echo ''" >> ${MOUNTPOINT}/install_scripts
    echo "print_info \$\"Setup Group...\"" >> ${MOUNTPOINT}/install_scripts
    echo "groupadd \"\$USERNAME\"" >> ${MOUNTPOINT}/install_scripts
    echo "echo ''" >> ${MOUNTPOINT}/install_scripts
    echo "print_info \$\"Setup User...\"" >> ${MOUNTPOINT}/install_scripts
    # if ! grep $USERNAME /etc/passwd
    # optical,video,audio,scanner,games,lp,power,storage
    echo "useradd -m -g \"\$USERNAME\" -G \"\${USERNAME}\",wheel,users -s /bin/bash \"\$USERNAME\"" >> ${MOUNTPOINT}/install_scripts
    if [[ "$DEBUGGING" -eq 1 ]]; then 
        echo "pause_function \"useradd -m -g \'$USERNAME\' -G \'${USERNAME}\',wheel,users -s /bin/bash \'$USERNAME\' at line \$(basename \$BASH_SOURCE) \$LINENO\"" >> ${MOUNTPOINT}/install_scripts
    fi
    echo "print_info \$\"Setup User Password...\"" >> ${MOUNTPOINT}/install_scripts
    echo "get_secret 'user_user'" >> ${MOUNTPOINT}/install_scripts
    if [[ "$DEBUGGING" -eq 1 ]]; then 
        echo "pause_function \"get_secret 'user_user' at line \$(basename \$BASH_SOURCE) \$LINENO\"" >> ${MOUNTPOINT}/install_scripts
    fi
    # User Groups
    if [[ "${#USER_GROUPS}" -ne 0 ]]; then
        total="${#USER_GROUPS[@]}"
        for (( index=0; index<${total}; index++ )); do
            echo "groupadd \"${USER_GROUPS[$index]}\""         >> ${MOUNTPOINT}/install_scripts
            echo "add_user_2_group \"${USER_GROUPS[$index]}\"" >> ${MOUNTPOINT}/install_scripts
        done
    fi
    if [[ "$DEBUGGING" -eq 1 ]]; then 
        echo "pause_function \"Add User 2 Group: \$(basename \$BASH_SOURCE) \$LINENO\"" >> ${MOUNTPOINT}/install_scripts
    fi
    #echo "print_info \$\"Setup User Information...\"" >> ${MOUNTPOINT}/install_scripts
    #echo "echo 'To enter user information for the GECOS field (e.g. the full user name)'" >> ${MOUNTPOINT}/install_scripts
    #echo "chfn \$USERNAME" >> ${MOUNTPOINT}/install_scripts
    #echo "echo ''" >> ${MOUNTPOINT}/install_scripts
    #echo "echo ''" >> ${MOUNTPOINT}/install_scripts
    # Pause, so we can see if its good so far; maybe pass in a debug switch: -d 
    #echo "read -e -sn 1 -p 'Review then Press any key to continue...'" >> ${MOUNTPOINT}/install_scripts
    #
    #
    echo "# ****** Grub Install *************************** " >> ${MOUNTPOINT}/install_scripts
    #
    echo "modprobe dm-mod" >> ${MOUNTPOINT}/install_scripts
    if [[ "$UEFI" -eq 0 ]]; then # UEFI=0
        # installed grub in pacstrap install_base_system
        echo "if [[ \"\$(cat /sys/class/dmi/id/sys_vendor)\" == 'Apple Inc.' ]] || [[ \"\$(cat /sys/class/dmi/id/sys_vendor)\" == 'Apple Computer, Inc.' ]]; then" >> ${MOUNTPOINT}/install_scripts # If MAC
        echo "    modprobe -r -q efivars || true" >> ${MOUNTPOINT}/install_scripts
        echo "else" >> ${MOUNTPOINT}/install_scripts
        echo "    modprobe -q efivars" >> ${MOUNTPOINT}/install_scripts
        echo "fi" >> ${MOUNTPOINT}/install_scripts
        if [[ "$DEBUGGING" -eq 1 ]]; then
            echo "echo 'modprobe efivars'" >> ${MOUNTPOINT}/install_scripts 
            echo "pause_function \"modprobe efivars line \$(basename \$BASH_SOURCE) \$LINENO\"" >> ${MOUNTPOINT}/install_scripts
        fi
    fi
    echo "#" >> ${MOUNTPOINT}/install_scripts
    if [[ "$BOOT_SYSTEM_TYPE" -eq 0 ]]; then # Grub2 -> ("Grub2" "Syslinux" "Skip")
        if [[ "$UEFI" -eq 0 ]]; then # UEFI=0
            echo "mkdir -p /boot/efi/EFI" >> ${MOUNTPOINT}/install_scripts
            echo "grub-install --directory=/usr/lib/grub/x86_64-efi --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --boot-directory=/boot --recheck --debug &>/boot/grub_uefi.log" >> ${MOUNTPOINT}/install_scripts
            echo "cat /boot/grub_uefi.log" >> ${MOUNTPOINT}/install_scripts
            echo "#" >> ${MOUNTPOINT}/install_scripts
            echo "if [[ \"\$(cat /sys/class/dmi/id/sys_vendor)\" != 'Apple Inc.' ]] && [[ \"\$(cat /sys/class/dmi/id/sys_vendor)\" != 'Apple Computer, Inc.' ]]; then" >> ${MOUNTPOINT}/install_scripts # if MAC
            echo "  for _bootnum in \$(efibootmgr | grep '^Boot[0-9]' | fgrep -i 'ARCH LINUX (GRUB2)' | cut -b5-8) ; do" >> ${MOUNTPOINT}/install_scripts
            echo "      efibootmgr --bootnum \"\${_bootnum}\" --delete-bootnum" >> ${MOUNTPOINT}/install_scripts
            echo "  done" >> ${MOUNTPOINT}/install_scripts
            echo "  efibootmgr --verbose --create --gpt --disk /dev/${INSTALL_DEVICE} --part 1 --write-signature --label 'ARCH LINUX (GRUB2)' --loader '\\EFI\\arch_grub\\grubx64.efi'" >> ${MOUNTPOINT}/install_scripts
            echo "fi" >> ${MOUNTPOINT}/install_scripts
        elif [[ "$UEFI" -eq 1 ]]; then # BIOS=1
            # @FIX test, what is mount point? Install to root?
            echo "grub-install --target=i386-pc --recheck --debug /dev/${INSTALL_DEVICE}" >> ${MOUNTPOINT}/install_scripts
            #echo "grub-install --target=i386-pc --recheck $INSTALL_DEVICE" >> ${MOUNTPOINT}/install_scripts
            echo "grub-mkconfig -o /boot/grub/grub.cfg" >> ${MOUNTPOINT}/install_scripts
            echo "#" >> ${MOUNTPOINT}/install_scripts
        fi
        echo "mkdir -p /boot/grub/locale" >> ${MOUNTPOINT}/install_scripts
        echo "cp /usr/share/locale/en\\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo" >> ${MOUNTPOINT}/install_scripts
        echo "grub-mkconfig -o /boot/grub/grub.cfg" >> ${MOUNTPOINT}/install_scripts
    elif [[ "$BOOT_SYSTEM_TYPE" -eq 1 ]]; then # Syslinux
        echo "syslinux-install_update -iam" >> ${MOUNTPOINT}/install_scripts
        echo "${EDITOR} /boot/syslinux/syslinux.cfg" >> ${MOUNTPOINT}/install_scripts
        echo "#" >> ${MOUNTPOINT}/install_scripts
    fi       
    #
    if [[ "$DEBUGGING" -eq 1 ]]; then
        echo "pause_function \"install_scripts completed. \$(basename \$BASH_SOURCE) \$LINENO\"" >> ${MOUNTPOINT}/install_scripts
    fi
}
#}}}
# -----------------------------------------------------------------------------
# CREATE SCRIPT LOG {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="create_script_log"
    USAGE="create_script_log"
    DESCRIPTION=$(localize "CREATE-SCRIPT-LOG-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "CREATE-SCRIPT-LOG-DESC"  "Create Script Log"
fi
# -------------------------------------
create_script_log()
{
    # -------------------------------------------------------------------------
    # Log file
    # Run from arch-chroot
    # 
    #
    echo "print_info \$\"Writing log files...\"" >> ${MOUNTPOINT}/install_scripts
    echo "make_dir \"$LOG_PATH\"  \"\$(basename \$BASH_SOURCE) \$LINENO\"" >> ${MOUNTPOINT}/install_scripts
    echo "echo '# $TEXT_SCRIPT_ID' > $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    # locale
    echo "echo '## /etc/locale.conf ###########################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    echo "cat /etc/locale.conf >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    echo "echo '## /etc/locale.gen ############################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    echo "cat /etc/locale.gen >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    if [[ "$BOOT_SYSTEM_TYPE" -eq 0 ]]; then # Grub2
        if [[ "$UEFI" -eq 0 ]]; then # UEFI=0, BIOS=1 and NONE=2
            echo "echo '## /boot/grub/grub.cfg ########################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
            echo "cat /boot/grub/grub.cfg >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
            echo "echo '## /boot/grub_uefi.log ########################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
            echo "cat /boot/grub_uefi.log >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
        fi
    elif [[ "$BOOT_SYSTEM_TYPE" -eq 1 ]]; then # Syslinux
        echo "echo '## /boot/syslinux/syslinux.cfg ################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
        echo "cat /boot/syslinux/syslinux.cfg" >> ${MOUNTPOINT}/install_scripts
    fi
    # loadkeys
    echo "echo '## /etc/vconsole.conf #########################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    echo "cat /etc/vconsole.conf >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    # hostname
    echo "echo '## /etc/hostname ##############################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    echo "cat /etc/hostname >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    # hosts
    echo "echo '## /etc/hosts #################################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    echo "cat /etc/hosts >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    # pacman.conf
    echo "echo '## /etc/pacman.conf ###########################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    echo "cat /etc/pacman.conf >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    # resolv.conf
    echo "echo '## /etc/resolv.conf ###########################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    echo "cat /etc/resolv.conf >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    # fstab
    echo "echo '## /etc/fstab #################################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    echo "cat /etc/fstab >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    # /etc/dhcpcd.conf
    echo "echo '## /etc/dhcpcd.conf ###########################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    echo "cat /etc/dhcpcd.conf >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    # /etc/conf.d/dhcpd
    echo "echo '## /etc/conf.d/dhcpd ##########################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    echo "cat /etc/conf.d/dhcpd >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    # install_scripts
    echo "echo '## /etc/install_scripts #######################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    echo "cat install_scripts >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    #    
    echo "echo '## END OF LOG #################################################################' >> $SCRIPT_LOG" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    echo "#" >> ${MOUNTPOINT}/install_scripts
    if [[ "$DEBUGGING" -eq 1 ]]; then
        echo "pause_function \"install_scripts has executed and logs written at line \$(basename \$BASH_SOURCE) \$LINENO\"" >> ${MOUNTPOINT}/install_scripts
    fi
}
#}}}
# -----------------------------------------------------------------------------
# CREATE INSTALL SCRIPTS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="create_install_scripts"
    USAGE="create_install_scripts"
    DESCRIPTION=$(localize "CREATE-INSTALL-SCRIPTS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "CREATE-INSTALL-SCRIPTS-DESC"  "Create Install Scripts"
fi
# -------------------------------------
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
    echo "echo 'You are in arch-chroot, you can make any changes to the OS here.'" >> ${MOUNTPOINT}/install_scripts
    echo "echo 'Type exit and hit enter when complete.'" >> ${MOUNTPOINT}/install_scripts
}
#}}}
# -----------------------------------------------------------------------------
# RUN INSTALL SCRIPTS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="run_install_scripts"
    USAGE="run_install_scripts"
    DESCRIPTION=$(localize "RUN-INSTALL-SCRIPTS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "RUN-INSTALL-SCRIPTS-DESC"  "Run install scripts"
    #
    localize_info "RUN-INSTALL-SCRIPTS-TITLE" "Run Install Scripts in arch-chroot..."
    localize_info "RUN-INSTALL-SCRIPTS-SUDOERS" "Configure sudo..."
    localize_info "RUN-INSTALL-SCRIPTS-MSG-1" "If all went right you should be able to reboot into a fully functioning Desktop."
    localize_info "RUN-INSTALL-SCRIPTS-MSG-2" "Make sure to check the root for install files like install_scripts, install_scripts_root_secrets, install_scripts_user_secrets, you can also delete /boot/grub_uefi.log."
fi
# -------------------------------------
run_install_scripts()
{
    print_title "RUN-INSTALL-SCRIPTS-TITLE" "https://wiki.archlinux.org/index.php/Installation_Chroot"
    #
    write_secret 'user_user'
    write_secret 'root_user'
    #
    create_script_lib
    create_script_boot
    create_script_log
    # 
    # Run in chroot
    arch-chroot "${MOUNTPOINT}" /install_scripts
    #
    print_info "RUN-INSTALL-SCRIPTS-SUDOERS"
    configure_sudo
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    #
    copy_file  ${MOUNTPOINT}/boot/grub_uefi.log "${LOG_PATH}/"  ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file  ${MOUNTPOINT}/install_scripts    "${FULL_SCRIPT_PATH}" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    # Copy all files to root @FIX
    copy_file  "${FULL_SCRIPT_PATH}/arch-wiz.sh"       ${MOUNTPOINT}/${USERNAME}/        ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_files "$CONFIG_PATH/" "db"              ${MOUNTPOINT}/${USERNAME}/CONFIG/ ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_files "${LOG_PATH}/"  "log"             ${MOUNTPOINT}/${USERNAME}/LOG/    ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file  ${MOUNTPOINT}/install_scripts     ${MOUNTPOINT}/${USERNAME}/        ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    rm ${MOUNTPOINT}"/install_scripts"
    # Overwrite all Config files 
    # copy_dir "$FULL_SCRIPT_PATH/etc/" ${MOUNTPOINT}/ ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    # copy_file "${FULL_SCRIPT_PATH}"/etc/hosts "/etc/hosts" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    # Make sure to delete these files, they have passwords in them
    delete_secret 'user_user'
    delete_secret 'root_user'
    #
    print_title "RUN-INSTALL-SCRIPTS-TITLE" 'https://wiki.archlinux.org/index.php/Beginners%27_Guide#Boot_Arch_Linux_Installation_Media'
    print_info "RUN-INSTALL-SCRIPTS-MSG-1"
    print_info "RUN-INSTALL-SCRIPTS-MSG-2"
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# GDISK PARTITION {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="gdisk_partition"
    USAGE="gdisk_partition"
    DESCRIPTION=$(localize "GDISK-PARTITION-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "GDISK-PARTITION-DESC"  "Format Hard Drive and setup Partitions."
    #   
    localize_info "GDISK-PARTITION-TITLE"       "Partition Setup..."
    localize_info "GDISK-PARTITION-ERASING"     "Erasing Disk..."
    localize_info "GDISK-PARTITION-CREATE-UEFI" "Creating UEFI Disk..."
    localize_info "GDISK-PARTITION-CREATE-BIOS" "Creating BIOS Disk..."
    localize_info "GDISK-PARTITION-CREATE-BOOT" "Creating BOOT disk Partition ..."
    localize_info "GDISK-PARTITION-CREATE-SWAP" "Creating SWAP Partition ..."
    localize_info "GDISK-PARTITION-CREATE-ROOT" "Creating ROOT Partition ..."
    localize_info "GDISK-PARTITION-CREATE-HOME" "Creating HOME disk Partition ..."
    localize_info "GDISK-PARTITION-CREATE-VAR"  "Creating VAR disk Partition ..."
    localize_info "GDISK-PARTITION-FORMAT-ROOT" "Formating ROOT Partition..."
    localize_info "GDISK-PARTITION-FORMAT-HOME" "Formating HOME disk Partition..."
    localize_info "GDISK-PARTITION-FORMAT-VAR"  "Formating VAR disk Partition..."
    localize_info "GDISK-PARTITION-FORMAT-BOOT" "Formating BOOT disk Partition..."
    localize_info "GDISK-PARTITION-FORMAT-UEFI" "Formating UEFI disk..."
    localize_info "GDISK-PARTITION-FORMAT-BIOS" "Formating BIOS disk..."
    localize_info "GDISK-PARTITION-MAKE-SWAP"   "Creating SWAP Partition..."
fi
# -------------------------------------
gdisk_partition()
{
    print_title "GDISK-PARTITION-TITLE"
    #
    # Disk prep
    print_warning "GDISK-PARTITION-ERASING" 
    sgdisk -og /dev/"${INSTALL_DEVICE}"        # Clear out all partition data and Convert an MBR or BSD disklabel disk to a GPT disk
    sgdisk -Z /dev/"${INSTALL_DEVICE}"         # Zap all on disk
    sgdisk -a 2048 -o /dev/"${INSTALL_DEVICE}" # new gpt disk 2048 alignment
    #
    # Create partitions
    # in case script gets called twice, you will need to reboot if device is busy
    umount_partition /dev/"${INSTALL_DEVICE}"1
    umount_partition /dev/"${INSTALL_DEVICE}"2
    umount_partition /dev/"${INSTALL_DEVICE}"3
    umount_partition /dev/"${INSTALL_DEVICE}"4
    #
    umount_partition ${MOUNTPOINT}/proc
    umount_partition ${MOUNTPOINT}/sys
    umount_partition ${MOUNTPOINT}/dev
    umount_partition ${MOUNTPOINT}/tmp
    #
    #
    PARTITION_NO=1
    # Partition BIOS (UEFI SYS or BIOS), default start block, user defined size
    if [[ "$UEFI" -eq 0 ]]; then # UEFI=0
        print_info "GDISK-PARTITION-CREATE-UEFI" 
        echo "1"
        CREATE_PARTITION="sgdisk -n 1:0:+${UEFI_SIZE} -c 1:\"UEFISYS\" -t 1:ef00 /dev/$INSTALL_DEVICE"  
        $CREATE_PARTITION
    elif [[ "$UEFI" -eq 1 ]]; then # BIOS=1 
        if [[ "$BOOT_SYSTEM_TYPE" -eq 0 ]]; then # Grub2
           print_info "GDISK-PARTITION-CREATE-BIOS" 
           echo "1"
           CREATE_PARTITION="sgdisk -n 1:0:+${BIOS_SIZE} -c 1:\"BIOS\" -t 1:ef02 /dev/$INSTALL_DEVICE"     
           $CREATE_PARTITION
        fi
        # @FIX NONE=2
    fi
    #
    # Partition (BOOT), default start block, user defined size
    if [[ "$IS_BOOT_PARTITION" -eq 1 ]]; then
        print_info "GDISK-PARTITION-CREATE-BOOT" 
        echo $((++PARTITION_NO)) # NOTE: This will increament PARTITION_NO
        CREATE_PARTITION="sgdisk -n ${PARTITION_NO}:0:+${BOOT_SIZE} -c ${PARTITION_NO}:\"BOOT\" -t ${PARTITION_NO}:8300 /dev/$INSTALL_DEVICE"
        echo "$CREATE_PARTITION"
        $CREATE_PARTITION
        BOOT_PARTITION_NO="$PARTITION_NO"
    fi
    #
    # Partition (SWAP), default start block, user defined size
    if [[ "$IS_SWAP_PARTITION" -eq 1 ]]; then
        echo $((++PARTITION_NO)) # NOTE: This will increament PARTITION_NO
        print_info "GDISK-PARTITION-CREATE-SWAP" 
        CREATE_PARTITION="sgdisk -n ${PARTITION_NO}:0:+${SWAP_SIZE} -c ${PARTITION_NO}:\"SWAP\" -t ${PARTITION_NO}:8200 /dev/$INSTALL_DEVICE" 
        echo "$CREATE_PARTITION"
        $CREATE_PARTITION 
        SWAP_PARTITION_NO="$PARTITION_NO"
    fi
    #        
    # Partition (ROOT), default start, user defined size
    print_info "GDISK-PARTITION-CREATE-ROOT" 
    echo $((++PARTITION_NO)) # NOTE: This will increament PARTITION_NO
    if [[ "$ROOT_SIZE" != "0" ]]; then
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
    if [[ "$IS_HOME_PARTITION" -eq 1 ]]; then
        print_info "GDISK-PARTITION-CREATE-HOME" 
        echo $((++PARTITION_NO)) # NOTE: This will increament PARTITION_NO
        if [[ "$HOME_SIZE" != "0" ]]; then
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
    if [[ "$IS_VAR_PARTITION" -eq 1 ]]; then
        print_info "GDISK-PARTITION-CREATE-VAR" 
        echo $((++PARTITION_NO)) # NOTE: This will increament PARTITION_NO
        if [[ "$VAR_SIZE" != "0" ]]; then
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
    print_info "GDISK-PARTITION-FORMAT-ROOT"
    mkfs -t "$ROOT_FORMAT" -L "ROOT" "/dev/${INSTALL_DEVICE}${ROOT_PARTITION_NO}"                 # Format with user specified format type
    fsck "/dev/${INSTALL_DEVICE}${ROOT_PARTITION_NO}"                                             # Check File System
    make_dir "$MOUNTPOINT" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"                                                              # Create Folder /mnt
    mount -t "$ROOT_FORMAT" "/dev/$INSTALL_DEVICE$ROOT_PARTITION_NO" "$MOUNTPOINT"                # Mount at /mnt
    #
    # Partition HOME
    if [[ "$IS_HOME_PARTITION" -eq 1 ]]; then
        print_info "GDISK-PARTITION-FORMAT-HOME"
        mkfs -t "$HOME_FORMAT" -L "HOME" "/dev/${INSTALL_DEVICE}${HOME_PARTITION_NO}"             # Format with user specified format type
        fsck "/dev/${INSTALL_DEVICE}${HOME_PARTITION_NO}"                                         # Check File System
        make_dir "${MOUNTPOINT}/home" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"                                                   # Make Folder /mnt/home
        mount -t "$HOME_FORMAT" "/dev/${INSTALL_DEVICE}${HOME_PARTITION_NO}" "${MOUNTPOINT}/home" # Mount at /mnt/home
    fi
    #
    # Partition VAR
    if [[ "$IS_VAR_PARTITION" -eq 1 ]]; then
        print_info "GDISK-PARTITION-FORMAT-VAR"
        mkfs -t "$VAR_FORMAT" -L "VAR" "/dev/${INSTALL_DEVICE}${VAR_PARTITION_NO}"                # Format with user specified format type
        fsck "/dev/${INSTALL_DEVICE}${VAR_PARTITION_NO}"                                          # Check File System
        make_dir "${MOUNTPOINT}/var" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"                                                    # Make Folder /mnt/var
        mount -t "$VAR_FORMAT" "/dev/${INSTALL_DEVICE}${VAR_PARTITION_NO}" "${MOUNTPOINT}/var"    # Mount at /mnt/var
    fi
    #
    # Partition BOOT, mount after root
    if [[ "$IS_BOOT_PARTITION" -eq 1 ]]; then
        print_info "GDISK-PARTITION-FORMAT-BOOT"
        mkfs.ext2 -L "BOOT" "/dev/${INSTALL_DEVICE}${BOOT_PARTITION_NO}"                          # Format ext2
        fsck "/dev/${INSTALL_DEVICE}${BOOT_PARTITION_NO}"                                         # Check File System
        make_dir "${MOUNTPOINT}/boot" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"                                                   # Make Folder /mnt/boot in case its not created above
        mount -t ext2 "/dev/${INSTALL_DEVICE}${BOOT_PARTITION_NO}" "${MOUNTPOINT}/boot"           # Mount Drive /mnt/boot; lets also unmount and re-mount this in install_script
    fi
    #        
    # Partition UEFI SYS, mount after root and boot
    if [[ "$UEFI" -eq 0 ]]; then # UEFI=0
        print_info "GDISK-PARTITION-FORMAT-UEFI" 
        mkfs.vfat -F32 -n "UEFISYS" "/dev/${INSTALL_DEVICE}1"                                     # Format vfat 32
        fsck "/dev/${INSTALL_DEVICE}1"                                                            # Check File System   
        make_dir "${MOUNTPOINT}/boot" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"                                                   # Create Folder /mnt/boot
        make_dir "${MOUNTPOINT}/boot/efi" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"                                               # Create Folder /mnt/boot/efi  
        mount -t vfat "/dev/${INSTALL_DEVICE}1" "${MOUNTPOINT}/boot/efi"                          # Mount Drive to /mnt/boot/efi; lets also mount this in install_script
    elif [[ "$UEFI" -eq 1 ]]; then # BIOS=1
        if [[ "$BOOT_SYSTEM_TYPE" -eq 0 ]]; then # 0=Grub2
            print_info "GDISK-PARTITION-FORMAT-BIOS" 
            mkfs.vfat -F32 -n "BIOS" "/dev/${INSTALL_DEVICE}1"                                    # Format vfat 32
            fsck "/dev/${INSTALL_DEVICE}1"                                                        # Check File System    
            make_dir "${MOUNTPOINT}/boot/bios" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"                                          # Create Folder /mnt/boot/bios
            mount -t vfat "/dev/${INSTALL_DEVICE}1" "${MOUNTPOINT}/boot/bios"                     # Mount Drive to /mnt/boot/bios @FIX This can not be right, research did not find answer
        fi
    fi
    #
    # Partition SWAP
    if [[ "$IS_SWAP_PARTITION" -eq 1 ]]; then
        print_info "GDISK-PARTITION-MAKE-SWAP"
        mkswap -L "SWAP" "/dev/${INSTALL_DEVICE}${SWAP_PARTITION_NO}"                             # make swap
        swapon "/dev/${INSTALL_DEVICE}${SWAP_PARTITION_NO}"                                       # set swap on
    fi
    #
    # ------------------------------------------------------------------------
    # mount proc, sys, dev in install root
    # ------------------------------------------------------------------------
    #make_dir "${MOUNTPOINT}/proc" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    #make_dir "${MOUNTPOINT}/sys"  ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    #make_dir "${MOUNTPOINT}/dev"  ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    #make_dir "${MOUNTPOINT}/run"  ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    # do not mount; arch-chroot will mount
    #mount -o bind /proc ${MOUNTPOINT}/proc
    #mount -o bind /sys  ${MOUNTPOINT}/sys
    #mount -o bind /dev  ${MOUNTPOINT}/dev
    #if [[ "$IS_TMP_PARTITION" -eq 0 ]]; then
        # make_dir "${MOUNTPOINT}/tmp"  ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        #mkdir -m 1777 -p "$MOUNTPOINT"/tmp
        #mount -o bind /tmp  ${MOUNTPOINT}/tmp
    #fi
    #
    make_dir "${MOUNTPOINT}${PACMAN_CACHE}" ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    make_dir "${MOUNTPOINT}/etc/"           ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    make_dir "${MOUNTPOINT}/etc/pacman.d/"  ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    #    
    required_repo "multilib"
    if [ ! -f /etc/pacman.conf.old ]; then
        copy_file "/etc/pacman.conf"         /etc/pacman.conf.old              ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    else
        copy_file "/etc/pacman.conf.old"    /etc/pacman.conf                   ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    fi
    copy_file "/etc/pacman.conf"         ${MOUNTPOINT}/etc/pacman.conf         ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file "/etc/pacman.d/mirrorlist" ${MOUNTPOINT}/etc/pacman.d/mirrorlist ": $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    #
    # Print Table
    if [[ "$EDIT_GDISK" -eq 1 ]]; then
        sgdisk -p "/dev/$INSTALL_DEVICE"
        gdisk "/dev/$INSTALL_DEVICE"
    fi
    #
    DRIVE_FORMATED=1
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE)  $LINENO"; fi
}
#}}}
# -----------------------------------------------------------------------------
# SETUP OS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="setup_os"
    USAGE="setup_os"
    DESCRIPTION=$(localize "SETUP-OS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "SETUP-OS-DESC"  "Setup OS"
    #
    localize_info "Install-Arch" "Install Arch Linux on Drive"
    localize_info "Script-uses-GPT" "This Script uses GPT: GUID Partition Table (GPT) is a new style of partitioning which is part of the Unified Extensible Firmware Interface Specification, using the globally unique identifier for devices. It is different from the Master Boot Record (the more commonly used partitioning style) in many aspects and has many advantages."
    localize_info "Partitioning-hard-drive" "Partitioning a hard drive allows one to logically divide the available space into sections that can be accessed independently of one another. Partition information is stored within a hard drive's Master Boot Record."
    localize_info "Running-gdisk" "Running gdisk options will DESTROY all DATA on installation disk!"
    localize_info "Standard-Partition-4-Primary-Types" "This function sets up a Standard Partition of 4 Primary Types: UEFI - BOOT - SWAP and ROOT; you can also specify to create HOME and VAR Partitions."
    localize_info "Unified-Extensible-Firmware-Interface" "Unified Extensible Firmware Interface (or UEFI for short) is a new type of firmware that was initially designed by Intel (known as EFI then) mainly for its Itanium based systems. It introduces new ways of booting an OS that is distinct from the commonly used 'MBR boot code' method followed for BIOS systems. It started as Intel's EFI in versions 1.x and then a group of companies called the UEFI Forum took over its development from which it was called Unified EFI starting with version 2.0."
    localize_info "UEFI is formated as FAT32" "UEFI is formated as FAT32"
    localize_info "BIOS" "If your motherboard supports UEFI Mode, then use it, otherwise use BIOS mode; both use GPT for this Script."
    localize_info "BOOT" "The /boot directory contains the kernel and ramdisk images as well as the bootloader configuration file and bootloader stages."
    localize_info "BOOT-Partition-not-required" "BOOT is not required to be a separate Partition, its recommended, BOOT is formated as Ext2"
    localize_info "ROOT" "ROOT is required, and is recommended to be formated as Ext4."
    localize_info "SWAP" "The swap partition provides memory that can be used as virtual RAM. It is recommended for PCs with 1GB or less of physical RAM."
    localize_info "HOME" "The /home directory contains user-specific configuration files (the so-called 'dot files'). Optionally, it can also hold any type of media (videos, music, etc), and if you use Wine, the games/programs will be installed in ~/.wine/ by default. So please take this into account if you chose to create a separate home partition. While keeping it on a separate partition can be useful in case you reinstall, some prefer to start fresh (because that's usually the reason for a reinstall), instead of reusing old, and possibly deprecated or problematic, configuration files. The main advantage is that, in very rare cases, if the root partition becomes too full, it will not impact your web browser, media player, torrent client, etc. They will keep working uninhibited, and will keep saving new changes to their setting files or to their cache. A home partition can also be shared with other installed Linux distributions, but this is not recommended because of possible incompatibilities between user-specific configuration files. The only exception is if each distribution has its own user dir on the shared home partition."
    localize_info "VAR" "The /var directory stores Contains variable data such as spool directories and files, administrative and logging data, pacman's cache, the ABS tree, etc. It is used for example for caching and logging, and hence frequently read or written. Keeping it in a separate partition avoids running out of disk space due to flunky logs, etc. It exists to make it possible to mount /usr as read-only. Everything that historically went into /usr that is written to during system operation (as opposed to installation and software maintenance) must reside under /var."
    localize_info "series-of-question" "A series of question will guild us to setting up the Partition Table."
    localize_info "Order-Partitions" "The Order the Partitions are made are: UEFI - BOOT - SWAP - ROOT - HOME - VAR"
    localize_info "SETUP-INFO" "You can hit Shift-Page Up or Down to scroll screens, Ctrl-C to exit script at any time."
    localize_info "choose-Drive-install-OS" "You must choose a Drive to install OS on, make sure you wish to Format this Whole Drive."
    localize_info "what-drive" "Figure out what drive you wish to install to, then re-run this Script."
    localize_info "Format-Drive" "About to Format Drive, be very sure you wish to continue! Hit Ctrl-C to Cancel, any key to Continue."
    localize_info "Last-Chance" "Last Chance at line"
    localize_info "same-drive-Script" "You can not install to same drive Script is Executing from."
    localize_info "Install-on-Device" "Installing on Device"
    localize_info "Device-does-not-exist" "Device does not exist! Try running script again using correct device name, run sgdisk -p for a list of Device names."
fi
# -------------------------------------
setup_os()
{
    print_title "https://wiki.archlinux.org/index.php/Partitioning and https://wiki.archlinux.org/index.php/GUID_Partition_Table"
    print_info "Script-uses-GPT"
    print_info "Partitioning-hard-drive"
    print_warning "Running-gdisk"
    print_info "Standard-Partition-4-Primary-Types"
    echo "UEFI"
    print_info "Unified-Extensible-Firmware-Interface" "https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface"
    print_info "UEFI is formated as FAT32"
    echo "BIOS"
    print_info "BIOS" "https://wiki.archlinux.org/index.php/GRUB2#BIOS_systems_2"
    print_info "BIOS is formated as FAT32"
    is_uefi_mode
    echo "BOOT"
    print_info "BOOT" "https://wiki.archlinux.org/index.php/Partitioning#.2Fboot"
    print_info "BOOT-Partition-not-required"
    echo "ROOT"
    print_info "ROOT" "https://wiki.archlinux.org/index.php/Partitioning#.2F_.28root.29"
    echo "SWAP"
    print_info "SWAP" "https://wiki.archlinux.org/index.php/Partitioning#Swap"
    print_info "A SWAP partition is not required, but recommened."
    echo "HOME"
    print_info "HOME" "https://wiki.archlinux.org/index.php/Partitioning#.2Fhome"
    echo "VAR"
    print_info "VAR" "https://wiki.archlinux.org/index.php/Partitioning#.2Fvar"
    # Duplicate code for var and tmp, note usr is too much work, it dumps to gdisk and users can manually add anything they wish at that point
    #
    echo ""
    print_info "series-of-question"
    print_info "Order-Partitions"
    echo ""
    print_info "SETUP-INFO"
    #
    print_info "choose-Drive-install-OS"
    device_list
    get_input_option "LIST_DEVICES[@]" 1
    INSTALL_DEVICE=${LIST_DEVICES[$((OPTION-1))]:0:3}
    read_input_yn "Install-Arch" "$INSTALL_DEVICE" 0
    if [[ "$YN_OPTION" -eq 0 ]]; then
        print_warning "what-drive"
        exit 0
    fi
    if [[ "$SCRIPT_DEVICE" == "$INSTALL_DEVICE" ]]; then
        print_warning "same-drive-Script"
        exit 0
    fi
    INSTALL_DEVICE=`echo $INSTALL_DEVICE | sed 's/[0-9]//'`  # i.e. sda; make sure no partition number is assigned
    if [[ -b "/dev/$INSTALL_DEVICE" ]]; then
        print_info "Install-on-Device" "/dev/$INSTALL_DEVICE"
        write_log "Install-on-Device" "/dev/$INSTALL_DEVICE $(basename $BASH_SOURCE) : $LINENO"
    else
        print_warning "Device-does-not-exist" "/dev/$INSTALL_DEVICE"
        lsblk
        exit # @FIX test before passing it in; make a list and have them pick from it
    fi
    #
    set_log_drive # just run it from mounted drive
    #
    print_warning "Format-Drive" "$INSTALL_DEVICE"
    pause_function "$(localize "Last-Chance") : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    #
    get_user_name           # $USERNAME
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "get_user_name : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    get_user_password       # $USERPASSWD
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "get_user_password : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    get_root_password       # $ROOTPASSWD
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "get_root_password : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    #
    backup_files            # Backup config files
    if [[ "$FAST_INSTALL" -eq 0 ]]; then
        custom_nameservers  # $IS_CUSTOM_NAMESERVER, $CUSTOM_NS1 and $CUSTOM_NS2
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "custom_nameservers : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        configure_keymap    # $KEYMAP
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "configure_keymap : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        select_editor       # $EDITOR
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "select_editor : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    else
        if [[ "$IS_CUSTOM_NAMESERVER" -eq 1 ]]; then
            read_nameserver
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "read_nameserver : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        fi
    fi
    if [[ "$DISK_PROFILE" -eq 0 ]]; then edit_disk; fi # should never get here
    #
    if [[ "$FAST_INSTALL" -eq 0 ]]; then
        get_locale          # $LOCALE and $LOCALE_UTF8
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "get_locale : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    #   
    if [[ "$FAST_INSTALL" -eq 0 ]]; then
        get_flesh               # $FLESH
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "get_flesh : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        configure_mirrorlist    # $COUNTRY_CODE Create Mirror List Write it to ${MOUNTPOINT}/etc/pacman.d/mirrorlist
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "configure_mirrorlist : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        get_hostname            # $CONFIG_HOSTNAME Write to ${MOUNTPOINT}/etc/hosts
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "get_hostname : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        configure_timezone      # add_packagemanager - Write to ${MOUNTPOINT}/etc/timezone and add run command for ln 
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "configure_timezone : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        add_custom_repositories # @FIX save them to disk
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "add_custom_repositories : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    else
        get_mirrorlist "$COUNTRY_CODE"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "get_mirrorlist : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
    #
    if [[ "$FAST_INSTALL" -eq 0 ]]; then
        get_fstab_config        # $FSTAB_CONFIG and $FSTAB_EDIT
    fi
    #
    gdisk_partition         # Create, Format and Mount 
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "gdisk_partition : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    #
    # Add User to boot OS, so we can use it
    groupadd "${USERNAME}"
    useradd -m -g "$USERNAME" -G "${USERNAME}",wheel,users -s /bin/bash "${USERNAME}"
    echo -e "${USERPASSWD}\n${USERPASSWD}" | passwd "${USERNAME}"
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "groupadd/useradd : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    #
    install_base_system     # Must install Base System before editing fstab
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "install_base_system : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    #
    configure_hostname      # Write to ${MOUNTPOINT}/etc/hosts and ${MOUNTPOINT}/etc/hostname
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "configure_hostname : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    #
    # umount or things get confused. we will remount them in the install_scripts arch-chroot.
    umount_partition "${MOUNTPOINT}/boot/efi"
    umount_partition "${MOUNTPOINT}/boot"
    configure_fstab         # Write to ${MOUNTPOINT}/etc/fstab
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "configure_fstab : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    #
    run_install_scripts     # create install_scripts file and do arch-chroot
    #
    if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "run_install_scripts : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    #
    #
    finish 1
}
#}}}
# -----------------------------------------------------------------------------
# START SCREEN {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="start_screen"
    USAGE="start_screen"
    DESCRIPTION=$(localize "START-SCREEN-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "START-SCREEN-DESC"  "Start Screen"
    #
    localize_info "root-privileges" "This script must be run with root privileges"
    localize_info "START-SCREEN-TITLE" "Arch Installation"
    localize_info "START-SCREEN-INFO-1" "The Arch Install Script are a set of Bash scripts that simplify Arch installation."
    localize_info "START-SCREEN-INFO-2" "This program was Originally Created by helmuthdu mailto: helmuthdu[at]gmail[dot]com called Archlinux Ultimate Install or AUI"
    localize_info "START-SCREEN-INFO-3" "And refactored by and new functionally written by Jeffrey Scott Flesher, so its more like a Wizard, and its called: ($ARCH_WIZ_SCRIPT_NAME), it allows the user to chose to install from a menu driven selection, then save it so you can load it next time, making this a one stop custom installer, you can edit all your configuration files, save changes to flash drive, and reuse them to install on someone elses machine."
    localize_info "START-SCREEN-INFO-4" "This Script will write Configuration files on mounted Flash Drive, its up to the user to remove them after Script finishes, so you must have enough space on device to hold files."
    localize_info "START-SCREEN-INFO-5" "This Script will also write a log file on mounted Flash Drive."
    localize_info "START-SCREEN-WARN-1" "This script is still in $SCRIPT_STAGE Stage"
    localize_info "START-SCREEN-WARN-2" "Warning: This script will completely format the Target Drive, its not designed to preserve partitions, it ERASES THE WHOLE HARD DRIVE!. so you have been warned."
    localize_info "START-SCREEN-INFO-6" "If you are installing this to a dual boot Windows System (or any other OS) on the same drive, it will be lost, which in the case of Windoze, will not be all that much of a lost, but in future version of this script, we will work on converting to GPT Disk and preserving Partitions, and mounting them in the fstab and grub."
fi
# -------------------------------------
start_screen()
{
    # Run this script after your first boot with archlinux (as root)
    if [[ "$EUID" -ne 0 ]]; then
        print_warning "root-privileges" 
        exit 0
    fi
    print_title "START-SCREEN-TITLE" " - https://wiki.archlinux.org/index.php/Arch_Install_Scripts"
    print_info "$TEXT_SCRIPT_ID"
    print_info "START-SCREEN-INFO-1"
    print_info "START-SCREEN-INFO-2"
    print_info "START-SCREEN-INFO-3"
    print_info "START-SCREEN-INFO-4"
    print_info "START-SCREEN-INFO-5"
    echo ""
    print_warning "START-SCREEN-WARN-1"
    print_warning "START-SCREEN-WARN-2"
    print_info "START-SCREEN-INFO-6"
    pause_function "$(basename $BASH_SOURCE) : $LINENO"
    setup_os
}
#}}}
# ****** END OF SCRIPT ******

