#!/bin/bash
#
declare LAST_UPDATE="24 Jan 2013 16:33"
declare SCRIPT_VERSION="1.0.0.A"
declare SCRIPT_NAME="ArchLinux Installation Wizard"
#
#
# Things to Fix
# Check for USERNAME in all Log functions and replace it with $USERNAME
#
shopt -s expand_aliases
alias cls='printf "\033c"'
cls
# Get current Device Script is Executing from
declare SCRIPT_DEVICE=""
if [[ "$EUID" -eq 0 ]]; then
    SCRIPT_DEVICE=`df | grep -w "$FULL_SCRIPT_PATH" | awk {'print \$1'}`
fi
declare SCRIPT_DEVICE="${SCRIPT_DEVICE:5:4}"
declare MENU_PATH="${FULL_SCRIPT_PATH}/MENU"
# Debugging
declare -i DEBUGGING=0
declare -i SET_DEBUGGING=0 # Used in set_debugging_mode
declare -i SILENT_MODE=0   # Used to Silentance Loging and warnings
declare -i SHOW_PAUSE=1 
# Localization
declare -a LOCALIZE_ID=( "" )
declare -a LOCALIZE_MSG=( "" )
# Help
declare -a HELP_ARRAY=()
# 
declare -r FILE_SIGNATURE="# ARCH WIZARD ID Signature" # Copy this into file to test for changes made by this script
# Network Detection
declare -a NIC=( "" )
declare -i ETH0_ACTIVE=0
declare -i ETH1_ACTIVE=0
declare -i ETH2_ACTIVE=0
#
declare USERNAME=$(whoami)
declare USERPASSWD='archlinux'
declare ROOTPASSWD='archlinux'
# 
declare -a USER_GROUPS=() 
#
declare EXCLUDE_FILE_WARN=( "${CONFIG_NAME}-1-taskmanager-name.db" "${CONFIG_NAME}-1-taskmanager.db" "${CONFIG_NAME}-0-packagemanager-name.db" "${CONFIG_NAME}-0-packagemanager.db" "${CONFIG_NAME}-2-packages.db" "${CONFIG_NAME}-2-aur-packages.db" "${CONFIG_NAME}-3-user-groups.db" "${CONFIG_NAME}-4-software-config.db" )
#
declare OPTION=" "           # Options - Used in Input
declare -a OPTIONS=()        # Array of Options - Used in Input
declare -i INSTALL_WIZARD=0  # Install Wizard - Setup default list to execute; do it in code so recording Marcors is not needed.
declare -i AUTOMAN=0         # Automatic / Manual
declare -i BYPASS=1          # Allow Bypass in Input
# Network
declare check_eth0=" "
declare check_eth1=" "
declare check_eth2=" "
declare SPACE='\x20'
declare HELP_TAB="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
#
declare -i VIDEO_CARD=7
declare -a VIDEO_CARDS=( "nVidia" "Nouveau" "Intel" "ATI" "Vesa" "Virtualbox" "Skip" );
# COLORS {{{
# Text color variables
# Regular Colors
declare Black='\e[0;30m'        # Black
declare Blue='\e[0;34m'         # Blue
declare Cyan='\e[0;36m'         # Cyan
declare Green='\e[0;32m'        # Green
declare Purple='\e[0;35m'       # Purple
declare Red='\e[0;31m'          # Red
declare White='\e[0;37m'        # White
declare Yellow='\e[0;33m'       # Yellow
# Bold
declare BBlack='\e[1;30m'       # Black
declare BBlue='\e[1;34m'        # Blue
declare BCyan='\e[1;36m'        # Cyan
declare BGreen='\e[1;32m'       # Green
declare BPurple='\e[1;35m'      # Purple
declare BRed='\e[1;31m'         # Red
declare BWhite='\e[1;37m'       # White
declare BYellow='\e[1;33m'      # Yellow
# Background
declare BgBlack='\e[0;40m'        # Black
declare BgBlue='\e[0;44m'         # Blue
declare BgCyan='\e[0;46m'         # Cyan
declare BgGreen='\e[0;42m'        # Green
declare BgPurple='\e[0;45m'       # Purple
declare BgRed='\e[0;41m'          # Red
declare BgWhite='\e[0;47m'        # White
declare BgYellow='\e[0;43m'       # Yellow
#}}}
# Menu Theme
declare -a MenuTheme=( "${BYellow}" "${White}" ")" )
# -----------------------------------------------------------------------------
declare -i CREATE_HELP=1
#
# CREATE HELP {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="create_help"
    USAGE=$(gettext -s  "CREATE-HELP-USAGE")
    DESCRIPTION=$(gettext -s  "CREATE-HELP-DESC")
    NOTES=$(gettext -s  "CREATE-HELP-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="1 OCT 2012"
    REVISION="1 NOV 2012"
fi
# -------------------------------------
create_help()
{
    if [[ "$RUN_HELP" -eq 0 ]]; then return 0; fi
    if [[ "$CREATE_HELP" -eq 1 ]]; then
        echo "$(gettext -s "CREATE-HELP-WORKING")"
        CREATE_HELP=0
    fi
    echo -n "."
    #echo "> $1"
    MY_HELP="<p class=\"function\" style=\"font-family:'Courier New'\"><span style=\"color:Crimson\">NAME&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: $1</span> <br /><span style=\"color:Blue\">USAGE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: $2  </span><br /><span style=\"color:DarkBlue\">DESCRIPTION: $3  </span><br /><span style=\"color:RoyalBlue\">NOTES&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: $4  </span><br /><span style=\"color:Red\">AUTHOR&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: $5  </span><br /><span style=\"color:Cyan\">VERSION&nbsp;&nbsp;&nbsp;&nbsp;: $6  </span><br /><span style=\"color:DarkRed\">CREATED&nbsp;&nbsp;&nbsp;&nbsp;: $7  </span><br /><span style=\"color:FireBrick\">REVISION&nbsp;&nbsp;&nbsp;: $8  </span><br /><span style=\"color:Teal\">LINENO&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: $9 </span></p>"
    HELP_ARRAY[$[${#HELP_ARRAY[@]}]]="$MY_HELP"
}
if [[ "$RUN_HELP" -eq 1 ]]; then
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
#}}}
# -----------------------------------------------------------------------------
# PRINT HELP {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="print_help"
    USAGE="print_help"
    DESCRIPTION=$(gettext -s "PRINT-HELP-DESC")
    NOTES=$(gettext -s "PRINT-HELP-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="1 OCT 2012"
    REVISION="1 NOV 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# -------------------------------------
print_help()
{
    echo "<!DOCTYPE html>" > "${FULL_SCRIPT_PATH}/help.html"
    echo "<html>" >> "${FULL_SCRIPT_PATH}/help.html"
    echo "<body>" >> "${FULL_SCRIPT_PATH}/help.html"
    echo "$(gettext -s "PRINT-HELP-TITLE"): $DATE_TIME" >> "${FULL_SCRIPT_PATH}/help.html"
    show_help  >> "${FULL_SCRIPT_PATH}/help.html"
    show_custom_help >> "${FULL_SCRIPT_PATH}/help.html" # Must be defined in Custom Script
    echo "<hr />" >> "${FULL_SCRIPT_PATH}/help.html"
    if [[ "${#HELP_ARRAY}" -ne 0 ]]; then
        total="${#HELP_ARRAY[@]}"
        for (( i=0; i<${total}; i++ )); do
            echo "$(gettext -s "PRINT-HELP-FUNCT") #$i" >> "${FULL_SCRIPT_PATH}/help.html"
            echo "${HELP_ARRAY[$i]}" >> "${FULL_SCRIPT_PATH}/help.html"
            echo "<hr />" >> "${FULL_SCRIPT_PATH}/help.html"
        done
    else
        print_error "PRINT-HELP-ERROR"
    fi        
    echo "" >> "${FULL_SCRIPT_PATH}/help.html"
    echo "" >> "${FULL_SCRIPT_PATH}/help.html"
    echo "</body>" >> "${FULL_SCRIPT_PATH}/help.html"
    echo "</html>" >> "${FULL_SCRIPT_PATH}/help.html"
    print_info "Help Printed to ${FULL_SCRIPT_PATH}/help.html"
}
#}}}
# -----------------------------------------------------------------------------
# PAUSE FUNCTION {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="pause_function"
    USAGE=$(gettext -s "PAUSE-FUNCTION-USAGE")
    DESCRIPTION=$(gettext -s "PAUSE-FUNCTION-DESC")
    NOTES=$(gettext -s "PAUSE-FUNCTION-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# -------------------------------------
pause_function()
{
    print_line
    tput sgr0
    read -e -sn 1 -p "$(gettext -s "PRESS-ANY-KEY-CONTINUE") [$1]..."
    tput sgr0
} 
#}}}
# -----------------------------------------------------------------------------
# IS STRING IN FILE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="is_string_in_file"
    USAGE=$(gettext -s "IS-STRING-IN-FILE-USAGE")
    DESCRIPTION=$(gettext -s "IS-STRING-IN-FILE-DESC")
    NOTES=$(gettext -s "IS-STRING-IN-FILE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# -------------------------------------
is_string_in_file()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if [ -z "$2" ]; then return 1; fi
    if [ -e "$1" ]; then
        count=`egrep -ic "$2" "$1"`
        [[ "$count" -gt 0 ]] &&	return 0
    else
        # Do not try this; recyclic - write_error "IS-STRING-IN-FILE-FNF" "($1) - ($2) -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        echo -e "\t${BRed}$(gettext -s "IS-STRING-IN-FILE-FNF") is_string_in_file ($1) - ($2) @ $(basename $BASH_SOURCE) : $LINENO${White}"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi            
    fi
    return 1
}
#}}}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if is_string_in_file "${FULL_SCRIPT_PATH}/wizard.sh" "# DO NOT EDIT THE TEXT ON THIS LINE" ; then # look for this static text
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED") is_string_in_file @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed} $(gettext -s "TEST-FUNCTION-FAILED") is_string_in_file @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
# ----------------------------------------------------------------------------- 
# WRITE ERROR {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="write_error"
    USAGE=$(gettext -s "WRITE-ERROR-USAGE")
    DESCRIPTION=$(gettext -s "WRITE-ERROR-DESC")
    NOTES=$(gettext -s "WRITE-ERROR-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# -------------------------------------
write_error()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if [ ! -f "$ERROR_LOG" ]; then
        [[ ! -d "$LOG_PATH" ]] && (mkdir -pv "$LOG_PATH")
        touch "$ERROR_LOG"
    fi
    echo "$(gettext -s "$1") ($2)" >> "$ERROR_LOG"
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    write_error "MY-ERROR-WRITE-ERROR" "write_error @ $(basename $BASH_SOURCE) : $LINENO"
    if is_string_in_file "${ERROR_LOG}" "MY-ERROR-WRITE-ERROR" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED") write_error @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED") write_error @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# TRIM {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="trim"
    USAGE="trim 1->( String to Trim )"
    DESCRIPTION=$(gettext -s "TRIM-DESC")
    NOTES=$(gettext -s "TRIM-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="21 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# -------------------------------------
trim() 
{ 
    echo "$(rtrim "$(ltrim "$1")")"
}
#}}}
# -----------------------------------------------------------------------------
# LEFT TRIM {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="ltrim"
    USAGE="ltrim 1->( String to Trim )"
    DESCRIPTION=$(gettext -s "LEFT-TRIM-DESC")
    NOTES=$(gettext -s "LTRIM-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# -------------------------------------
ltrim()
{
    # Remove Left or Leading Space
    echo "$1" | sed 's/^ *//g'
}
#}}}
# -----------------------------------------------------------------------------
# RIGHT TRIM {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="rtrim"
    USAGE=$(gettext -s "RIGHT-TRIM-USAGE")
    DESCRIPTION=$(gettext -s "RIGHT-TRIM-DESC")
    NOTES=$(gettext -s "RTRIM-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# -------------------------------------
rtrim()
{
    # Remove Right or Trailing Space
    [ -z "$1" ] && return 1
    echo "$1" | sed 's/ *$//g'
}
#}}}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then  # Test All Trim Functions together
    MY_SPACE=' Left and Right '
    if [[ $(rtrim "$MY_SPACE") == ' Left and Right' ]]; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED") rtrim @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed} $(gettext -s "TEST-FUNCTION-FAILED") rtrim @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
    if [[ $(ltrim "$MY_SPACE") == 'Left and Right ' ]]; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED") ltrim @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed} $(gettext -s "TEST-FUNCTION-FAILED") ltrim @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
    if [[ $(trim "$MY_SPACE") == 'Left and Right' ]]; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED") trim @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed} $(gettext -s "TEST-FUNCTION-FAILED") trim @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
# -----------------------------------------------------------------------------
declare -i ARR_INDEX=0
declare SearchMyArray=""
#
# IS IN ARRAY {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="is_in_array"
    USAGE=$(gettext -s "IS-IN-ARRAY-USAGE")
    DESCRIPTION=$(gettext -s "IS-IN-ARRAY-DESC")
    NOTES=$(gettext -s "IS-IN-ARRAY-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# -------------------------------------
is_in_array()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    [[ -z "$1" ]] && return 1
    local -a array=("${!1}")          # Cast as Array 'array[@]'
    local -i total="${#array[@]}"     # Total in Array
    local -i i=0
    for (( i=0; i<${total}; i++ )); do  # Iterate Array
        if [ "$2" == "${array[$i]}" ]; then
            ARR_INDEX="$i" # used if you want to know what the index is
            return 0 # Return true
        fi
    done
    return 1 # Return false
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    MyArrary=( "1" "2" "3" )
    if is_in_array "MyArrary[@]" "2" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED") is_in_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed} $(gettext -s "TEST-FUNCTION-FAILED") is_in_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
#
# IS NEEDLE IN HAYSTACK {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="is_needle_in_haystack"
    USAGE=$(gettext -s "IS-NEEDLE-IN-HAYSTACK-USAGE")
    DESCRIPTION=$(gettext -s "IS-NEEDLE-IN-HAYSTACK-DESC")
    NOTES=$(gettext -s "IS-NEEDLE-IN-HAYSTACK-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="22 Jan 2013"
    REVISION="22 Jan 2013"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# -------------------------------------
is_needle_in_haystack()
{
    local -i SearchResults=0
    case $2 in # Haystack
        "$1") SearchResults=1 ;; # Match Exact Haystack String
       "$1"*) SearchResults=2 ;; # Match Beginning of Haystack String
       *"$1") SearchResults=3 ;; # Match End of Haystack String
      *"$1"*) SearchResults=4 ;; # Needle String can be anywhere in the Haystack String
    esac
    if [[ "$SearchResults" -eq "$3" ]]; then # SearchResults=0-4
        return 0
    else
        if [[ "$3" -ge "5" ]]; then                     # Anywhere in String
            if [[ "$SearchResults" -ne "0" && "$3" -ne "6" ]]; then # SearchResults=0-4 - 0=No Found
                if [[ "$RUN_TEST" -eq 3 ]]; then echo "SearchResults=$SearchResults return at line $LINENO"; fi
                return 0
            else                                            # Check it like its an Array
                local -a MyNeedle=( $(echo $1) )            # Create an Array from the Needle
                local -a Haystack=( $(echo $2) )            # Create an Array from the Haystack
                local -i MyNeedleTotal="${#MyNeedle[@]}";   # 1 or Greater
                local -i HaystackTotal="${#Haystack[@]}";   # 1 or Greater
                local -i index=0;                           # Index
                local -i HayStackIndex=0;                   # Index
                local -i count=0                            # count how many times we find it
                local -a FoundIndex=()                      #
                trak=0
                if [[ "$3" -eq "5" ]]; then                 # Anywhere Exactly in String: Haystack=1ABS 2ABS 1POS 2POS and Needle=ABS POS, 
                    for (( HayStackIndex=0; HayStackIndex<${HaystackTotal}; HayStackIndex++ )); do
                        ((trak++))
                        for (( index=0; index<${MyNeedleTotal}; index++ )); do
                            local -i SearchResults=0
                            case ${Haystack[$HayStackIndex]} in # Haystack Array
                                "${MyNeedle[$index]}") SearchResults=1 ;; # Match Exact Haystack String
                               "${MyNeedle[$index]}"*) SearchResults=2 ;; # Match Beginning of Haystack String
                               *"${MyNeedle[$index]}") SearchResults=3 ;; # Match End of Haystack String
                              *"${MyNeedle[$index]}"*) SearchResults=4 ;; # Needle String can be anywhere in the Haystack String
                            esac
                            if [[ "$SearchResults" -ne "0" ]]; then # SearchResults=0-4 - 0=No Found
                                if [[ "${#FoundIndex[@]}" -eq 0 ]]; then
                                    if [[ "$RUN_TEST" -eq 3 ]]; then echo "5. Needle=${MyNeedle[$index]} | SearchResults=$SearchResults | index=$index"; fi
                                    array_push "FoundIndex" "$index" 
                                    ((count++))
                                else
                                    if ! is_in_array "FoundIndex[@]" "$index" ; then
                                        if [[ "$RUN_TEST" -eq 3 ]]; then echo "5. Needle=${MyNeedle[$index]} | SearchResults=$SearchResults | index=$index"; fi
                                        array_push "FoundIndex" "$index" 
                                        ((count++))
                                    fi
                                fi
                            fi
                        done
                    done
                    if [[ "$RUN_TEST" -eq 3 ]]; then echo "count=$count and MyNeedleTotal=$MyNeedleTotal"; fi
                    if [[ "$count" -eq "$MyNeedleTotal" ]]; then   # Keep in mind that we need another
                        return 0
                    else
                        return 1
                    fi                
                else
                    for (( index=0; index<${MyNeedleTotal}; index++ )); do
                        if is_in_array "Haystack[@]" "${MyNeedle[$index]}" ; then
                            if [[ "$RUN_TEST" -eq 3 ]]; then echo "Found ${MyNeedle[$index]}"; fi
                            if [[ "$3" -eq "6" ]]; then        # Anywhere Exactly in String: Haystack=12 13 and Needle=1 3, 
                                if [[ "$RUN_TEST" -eq 3 ]]; then echo "6. Needle=${MyNeedle[$index]} | SearchResults=$SearchResults | ARR_INDEX=$ARR_INDEX"; fi
                                ((count++))
                            fi
                        else
                            if [[ "$RUN_TEST" -eq 3 ]]; then echo "Not Found ${MyNeedle[$index]}"; fi
                        fi
                    done
                    if [[ "$RUN_TEST" -eq 3 ]]; then echo "count=$count and MyNeedleTotal=$MyNeedleTotal"; fi
                    if [[ "$count" -eq "$MyNeedleTotal" ]]; then   # Keep in mind that we need another
                        return 0
                    else
                        return 1
                    fi                
                fi
            fi
        else
            return 1
        fi
    fi
    return 1 # We should never make it, but if we do, its an error
}
#}}}
# -----------------------------------------------------------------------------
#
# LOAD 2D ARRAY {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="load_2d_array"
    USAGE="Array=( &#36;(load_2d_array 1->(/Path/ArrayName.ext) 2->(0=First Array, 1=Second Array) ) )"
    DESCRIPTION=$(gettext -s "LOAD-2D-ARRAY-DESC")
    NOTES=$(gettext -s "LOAD-2D-ARRAY-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# -------------------------------------
load_2d_array()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    local OLD_IFS="$IFS"
    IFS=$' '
    if [ -f "$1" ]; then
        local lines=()
        local line=""
        while read line; do 
            lines=($line) # Stored Data - Do not quote
            echo -e "${lines[$2]}"
        done < "$1" # Load Array from serialized disk file
    else
        echo -e "${BRed}$(gettext -s "LOAD-2D-ARRAY-MISSING") :${White} $1"
        write_error "LOAD-2D-ARRAY-MISSING" ": $1 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        exit 1
    fi
    IFS="$OLD_IFS"
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    OLD_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    TransLate=( $(load_2d_array "${FULL_SCRIPT_PATH}/Test/Source/gtranslate-cc.db" "0" ) ) # 1 is for Country
    if is_in_array "TransLate[@]" "English" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED") load_2d_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED") load_2d_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
    TransLate=( $(load_2d_array "${FULL_SCRIPT_PATH}/Test/Source/gtranslate-cc.db" "1" ) ) # 1 is for Country Code
    if is_in_array "TransLate[@]" "en" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED") load_2d_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED") load_2d_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
    IFS="$OLD_IFS"
fi
#}}}
# -----------------------------------------------------------------------------
declare -i CREATE_LOCALIZER=1
#
# LOCALIZE SAVE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="localize_save"
    USAGE=$(gettext -s "LOCALIZE-SAVE-USAGE")
    DESCRIPTION=$(gettext -s "LOCALIZE-SAVE-DESC")
    NOTES=$(gettext -s "LOCALIZE-SAVE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# -------------------------------------
localize_save()
{
    if [[ "$RUN_LOCALIZER" -eq 0 ]]; then return 0; fi
    echo "Starting localize_save..."
    
    make_dir "${LOCALIZED_PATH}/en/LC_MESSAGES/" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    echo "make_dir ${LOCALIZED_PATH}/en/LC_MESSAGES/"
    
    local -i total="${#LOCALIZE_ID[@]}"
    echo "total=$total"
    
    for (( i=0; i<${total}; i++ )); do
        if [[ "$i" == 0 ]]; then
            echo "msgid \"${LOCALIZE_ID[$i]}\""    >  "${LOCALIZED_PATH}/en/en.po" # Overwrite
            echo "msgstr \"${LOCALIZE_MSG[$i]}\""  >> "${LOCALIZED_PATH}/en/en.po" # Append
        else
            echo "msgid \"${LOCALIZE_ID[$i]}\""    >> "${LOCALIZED_PATH}/en/en.po" # Append
            echo "msgstr \"${LOCALIZE_MSG[$i]}\""  >> "${LOCALIZED_PATH}/en/en.po" # Append
        fi
    done
    msgfmt -o "${LOCALIZED_PATH}/en/LC_MESSAGES/${LOCALIZED_FILE}.mo"      "${LOCALIZED_PATH}/en/en.po"
        
    print_info "LOCALIZER-COMPLETED"
    return 0
        
        
        
    TRANSLATOR="moses"
    if [[ "$TRANSLATOR" == "google" ]]; then
        local -a TransLate=( $(load_2d_array "${FULL_SCRIPT_PATH}/gtranslate-cc.db" "1" ) ) # 1 is for Code
    elif [[ "$TRANSLATOR" == "bing" ]]; then
        echo "Bing Translator"
        # Available for free up to 5,000 queries per month
              
        # curl 'http://api.apertium.org/json/translate?q=hello%20world&langpair=en%7Ces&callback=foo'
        #       http://api.apertium.org/json/translate?q=QUIT&langpair=en%7Csq
        # %7C = | (vertical bar)
    elif [[ "$TRANSLATOR" == "apertium" ]]; then
        TRANSURL="http://api.apertium.org/json/translate"
        echo "set URL"
        local -a TransLate=( "af" "ca" "de" "es" "fr" "ga" "gl" "hi" "it" "lt" "lv" "mt" "nl" "pl" "pt" "sco" "sq" )
        API_Key="cwZdfGDhEkATSCydtSVYI7e3LI4" # @FIX config
    elif [[ "$TRANSLATOR" == "moses" ]]; then
        local -a TransLate=( "af" "ca" "de" "es" "fr" "ga" "gl" "hi" "it" "lt" "lv" "mt" "nl" "pl" "pt" "sco" "sq" )
    fi
                
                
    return 0         
                
        local -i transtotal="${#TransLate[@]}"
        echo "transtotal=$transtotal"
        local -i index=0
        local LocalePath=""
        for (( index=0; index<${transtotal}; index++ )); do
            echo "index=$index"
            
            if [[ "$TRANSLATOR" == "google" ]]; then
                LANGPAIR="en%7C${TransLate[$index]}" # "en|${TransLate[$index]}"
                echo "LANGPAIR=$LANGPAIR"
            fi

            LocalePath="${LOCALIZED_PATH}/${TransLate[$index]}/${TransLate[$index]}.po" # [/script/locale]/lang/lang.po
            echo "LocalePath=$LocalePath"
            make_dir "${LOCALIZED_PATH}/${TransLate[$index]}/LC_MESSAGES/" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            for (( i=0; i<${total}; i++ )); do
                if [ ! -f "$LocalePath" ]; then
                    touch "$LocalePath"
                fi
                if ! is_string_in_file "$LocalePath" "msgid \"${LOCALIZE_ID[$i]}\"" ; then


                    if [[ "$TRANSLATOR" == "google" ]]; then

                        #PSTRING=$(echo "${LOCALIZE_MSG[$i]}" | tr ' ' '%20') # +
                        PSTRING=${LOCALIZE_MSG[$i]// /%20}
                        echo "PSTRING=$PSTRING"
                        # PSTRING=Invalid%Option

                        # Get translation
                        echo "URL=${TRANSURL}?q=${PSTRING}&langpair=${LANGPAIR}&key=${API_Key}"
                        # URL=http://api.apertium.org/json/translate?q=Load%20Software:%20Will%20install%20Software%20Packages%20from%20above%20option.&langpair=en%7Ces&key=cwZdfGDhEkATSCydtSVYI7e3LI4

                        RESPONSE=$(/usr/bin/env curl -s -A Mozilla ${TRANSURL}?q=${PSTRING}&langpair=${LANGPAIR}&key=${API_Key}) # '&langpair='$LANGPAIR'&q='$PSTRING
                        # Parse and clean response, to show only translation.
                        RETURN_TRANS=$(echo "$RESPONSE" | cut -d ':' -f 3 | cut -d '}' -f 1)

                    elif [[ "$TRANSLATOR" == "moses" ]]; then
                        ~/mosesdecoder/bin/moses -f phrase-model/moses.ini < "${LOCALIZE_MSG[$i]}" > RESPONSE
                        ~/mosesdecoder/bin/moses -f phrase-model/moses.ini < "Test" > RESPONSE
                        RETURN_TRANS=$(echo "$RESPONSE" | cut -d ':' -f 3 | cut -d '}' -f 1)
                    
                    fi
                    #
                    if [[ "$i" == 0 ]]; then
                        echo "msgid \"${LOCALIZE_ID[$i]}\""    >> "$LocalePath" # 
                        echo "msgstr \"$RETURN_TRANS}\""  >> "$LocalePath" # 
                    else
                        echo "msgid \"${LOCALIZE_ID[$i]}\""    >> "$LocalePath" # 
                        echo "msgstr \"$RETURN_TRANS}\""  >> "$LocalePath" # 
                    fi
                fi    
            done
        done
    print_info "LOCALIZER-COMPLETED"
} 
#}}}
# -----------------------------------------------------------------------------
declare progress=( "-" "\\" "|" "/" )
declare -i progresion=0
# LOCALIZE INFO {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="localize_info"
    USAGE=$(gettext -s "LOCALIZE-INFO-USAGE")
    DESCRIPTION=$(gettext -s "LOCALIZE-INFO-DESC")
    NOTES=$(gettext -s "LOCALIZE-INFO-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# -------------------------------------
localize_info()
{
    [[ "$RUN_LOCALIZER" -eq 0 ]] && return 0
    if [[ "$CREATE_LOCALIZER" -eq 1 ]]; then
        echo "$(gettext -s "CREATE-LOCALIZER-WORKING")"
        CREATE_LOCALIZER=0
    fi
    echo -en "\b${progress[$((progresion++))]}"
    [[ "$progresion" -ge 3 ]] && progresion=0
    #    
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    [ -z "$1" ] && return 1
    [ -z "$2" ] && return 1
    #echo ">: $1"
    # Check to see if its in Array    
    if [[ "${#LOCALIZE_ID}" -eq 0 ]]; then
        LOCALIZE_ID[0]="$1"
        LOCALIZE_MSG[0]="$2"
    else    
        if ! is_in_array "LOCALIZE_ID[@]" "$1" ; then
            LOCALIZE_ID=( "${LOCALIZE_ID[@]}" "$1" )
            LOCALIZE_MSG[${#LOCALIZE_MSG[*]}]="$2"
        fi
    fi
    # if [[ "$DEBUGGING" -eq 1 ]]; then echo "localize_info (ID = [$1] - Message = [$2] at line number: [$3])"; fi
}
#}}}
# -----------------------------------------------------------------------------
# LOCALIZE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="localize"
    USAGE="localize 1->(Localize ID) 2->(Optional: Print this with no Localization)"
    DESCRIPTION=$(gettext -s "LOCALIZE-DESC")
    NOTES=$(gettext -s "LOCALIZE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# Help file Localization
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "LOCALIZE-DESC"  "Localize Text, look up ID and return Localized string."
    localize_info "LOCALIZE-NOTES" "Localized. Used to Centralized the Localization Function, also to add more Functionality."
fi
# -------------------------------------
localize()
{
    if [ "$#" -eq "1" ]; then
        echo -e "$(gettext -s "$1")"
    else
        echo -e "$(gettext -s "$1") $2"
    fi
}
#}}}
# ----------------------------------------------------------------------------- 
# CLEAN LOGS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="clean_logs"
    USAGE=$(localize "CLEAN-LOGS-USAGE")
    DESCRIPTION=$(localize "CLEAN-LOGS-DESC")
    NOTES=$(localize "CLEAN-LOGS-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "CLEAN-LOGS-USAGE" "clean_logs 1->(Log-Entry)"
    localize_info "CLEAN-LOGS-DESC"  "Clean Log Entry of UserName and Passwords."
    localize_info "CLEAN-LOGS-NOTES" "None."
    #
    localize_info "CLEAN-LOGS-ARG"   "Wrong Number of Arguments passed to clean_logs!"
    localize_info "CLEAN-LOGS-TEST"  "Test Log file with username"
fi
# -------------------------------------
clean_logs()
{
    if [[ "$#" -ne "1" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    local LogString="$1"
    local ReplaceWith='$USERNAME'
    #
    if [[ "$LogString" == *"$USERNAME"* ]]; then
        LogString=${LogString/$USERNAME/$ReplaceWith}
    fi
    #
    if [[ "$LogString" == *"$USERPASSWD"* ]]; then
        ReplaceWith='$USERPASSWD'
        LogString=${LogString/$USERPASSWD/$ReplaceWith}
    fi
    #
    if [[ "$LogString" == *"$ROOTPASSWD"* ]]; then
        ReplaceWith='$ROOTPASSWD'
        LogString=${LogString/$ROOTPASSWD/$ReplaceWith}
    fi
    echo "$LogString"
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    
    if [[ $(clean_logs "$(gettext -s "WRITE-LOG-TEST") $USERNAME $USERPASSWD $ROOTPASSWD MY-TEST -> clean_logs @ $(basename $BASH_SOURCE) : $LINENO")  != *"$USERNAME"* ]]; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED") clean_logs @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED") clean_logs @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# ----------------------------------------------------------------------------- 
# WRITE LOG {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="write_log"
    USAGE=$(localize "WRITE-LOG-USAGE")
    DESCRIPTION=$(localize "WRITE-LOG-DESC")
    NOTES=$(localize "WRITE-LOG-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "WRITE-LOG-USAGE" "write_log 1->(Log) 2->(Debugging Information)"
    localize_info "WRITE-LOG-DESC"  "Write Log Entry."
    localize_info "WRITE-LOG-NOTES" "Localized."
    #
    localize_info "WRITE-LOG-ARG"   "Wrong Number of Arguments passed to write_log!"
    localize_info "WRITE-LOG-TEST"  "Test Log file with username"
fi
# -------------------------------------
write_log()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if [ ! -f "$ACTIVITY_LOG" ]; then
        [[ ! -d "$LOG_PATH" ]] && (mkdir -pv "$LOG_PATH")
        touch "$ACTIVITY_LOG"
    fi
    echo $(clean_logs "$(gettext -s "$1") ${2}")  >> "$ACTIVITY_LOG"
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    write_log "WRITE-LOG-TEST" "MY-TEST $USERNAME $USERPASSWD $ROOTPASSWD -> write_log @ $(basename $BASH_SOURCE) : $LINENO"
    if is_string_in_file "${ACTIVITY_LOG}" "MY-TEST" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED") write_log @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED") write_log @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# PRINT LINE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="print_line"
    USAGE="print_line"
    DESCRIPTION=$(localize "PRINT-LINE-DESC")
    NOTES=$(localize "PRINT-LINE-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "PRINT-LINE-DESC"  "Prints a line of dashes --- across the screen."
    localize_info "PRINT-LINE-NOTES" "None."
fi
# Help file Localization
# -------------------------------------
print_line()
{ 
    printf "%$(tput cols)s\n"|tr ' ' '-'
    tput sgr0
} 
#}}}
# -----------------------------------------------------------------------------
# PRINT TITLE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="print_title"
    USAGE="print_title 1->(Localized Text ID) 2->(Optional Text not Localized)"
    DESCRIPTION=$(localize "PRINT-TITLE-DESC")
    NOTES=$(localize "PRINT-TITLE-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# Help file Localization
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "PRINT-TITLE-DESC"  "This will print a Header and clear the screen"
    localize_info "PRINT-TITLE-NOTES" "Localized."
fi
# -------------------------------------
print_title()
{ 
    clear
    print_line
    if [ "$#" -eq "1" ]; then
        echo -e "# ${BWhite}$(localize "$1")${White}"
    else
        echo -e "# ${BWhite}$(localize "$1") ${2}${White}"
    fi
    print_line
    echo ""
} 
#}}}
# -----------------------------------------------------------------------------
# PRINT INFO {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="print_info"
    USAGE=$(localize "PRINT-INFO-USAGE")
    DESCRIPTION=$(localize "PRINT-INFO-DESC")
    NOTES=$(localize "PRINT-INFO-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "PRINT-INFO-USAGE" "print_info 1->(Localized Text ID) 2->(Optional Not Localized Text)"
    localize_info "PRINT-INFO-DESC"  "Prints information on screen for end users to read, in a Column that is as wide as display will allow."
    localize_info "PRINT-INFO-NOTES" "Localized."
fi
# -------------------------------------
print_info()
{ 
    # Console width number
    T_COLS=`tput cols`
    tput sgr0
    echo -ne "${BgBlack}"
    if [ "$#" -eq "1" ]; then
        echo -e "${BWhite}$(localize "$1")${White}\n" | fold -sw $(( $T_COLS - 18 )) | sed 's/^/\t/'
    else
        echo -e "${BWhite}$(localize "$1") ${2}${White}\n" | fold -sw $(( $T_COLS - 18 )) | sed 's/^/\t/'
    fi
    echo -ne '\e[00m'
    tput sgr0
} #}}}
# -----------------------------------------------------------------------------
# PRINT THIS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="print_this"
    USAGE=$(localize "PRINT-THIS-USAGE")
    DESCRIPTION=$(localize "PRINT-THIS-DESC")
    NOTES=$(localize "PRINT-THIS-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "PRINT-THIS-USAGE" "print_this 1->(Localized Text ID) 2->(Optional Not Localized Text)"
    localize_info "PRINT-THIS-DESC"  "Like print_info, without a blank line."
    localize_info "PRINT-THIS-NOTES" "Localized."
fi
# -------------------------------------
print_this()
{ 
    # Console width number
    T_COLS=`tput cols`
    tput sgr0
    if [ "$#" -eq "1" ]; then
        echo -e "${BWhite}$(localize "$1")${White}" | fold -sw $(( $T_COLS - 18 )) | sed 's/^/\t/'
    else
        echo -e "${BWhite}$(localize "$1") ${2}${White}" | fold -sw $(( $T_COLS - 18 )) | sed 's/^/\t/'
    fi
    tput sgr0
} 
#}}}
# -----------------------------------------------------------------------------
# PRINT THAT {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="print_that"
    USAGE=$(localize "PRINT-THAT-USAGE")
    DESCRIPTION=$(localize "PRINT-THAT-DESC")
    NOTES=$(localize "PRINT-THAT-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "PRINT-THAT-USAGE" "print_that 1->(Localized Text ID) 2->(Optional Not Localized Text)"
    localize_info "PRINT-THAT-DESC"  "Like print_info, without a blank line and indented."
    localize_info "PRINT-THAT-NOTES" "Localized."
fi
# -------------------------------------
print_that()
{ 
    # Console width number
    T_COLS=`tput cols`
    tput sgr0
    if [ "$#" -eq "1" ]; then
        echo -e "\t\t${BWhite}$(localize "$1")${White}" | fold -sw $(( $T_COLS - 18 )) | sed 's/^/\t/'
    else
        echo -e "\t\t${BWhite}$(localize "$1") ${2}${White}" | fold -sw $(( $T_COLS - 18 )) | sed 's/^/\t/'
    fi
    tput sgr0
} 
#}}}
# -----------------------------------------------------------------------------
# PRINT INFO {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="print_caution"
    USAGE=$(localize "PRINT-INFO-USAGE")
    DESCRIPTION=$(localize "PRINT-INFO-DESC")
    NOTES=$(localize "PRINT-INFO-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "PRINT-INFO-USAGE" "print_caution 1->(Localized Text ID) 2->(Optional Not Localized Text)"
    localize_info "PRINT-INFO-DESC"  "Prints information on screen for end users to read, in a Column that is as wide as display will allow."
    localize_info "PRINT-INFO-NOTES" "Localized."
fi
# -------------------------------------
print_caution()
{ 
    # Console width number
    T_COLS=`tput cols`
    tput sgr0
    if [ "$#" -eq "1" ]; then
       echo -e "${BYellow}$(localize "$1")${White}\n" | fold -sw $(( $T_COLS - 18 )) | sed 's/^/\t/'
    else
        echo -e "${BYellow}$(localize "$1") ${2}${White}\n" | fold -sw $(( $T_COLS - 18 )) | sed 's/^/\t/'
    fi
    tput sgr0
} #}}}
# -----------------------------------------------------------------------------
# PRINT WARNING {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="print_warning"
    USAGE=$(localize "PRINT-WARNING-USAGE")
    DESCRIPTION=$(localize "PRINT-WARNING-DESC")
    NOTES=$(localize "PRINT-WARNING-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "PRINT-WARNING-USAGE" "print_warning 1->(Localized Text ID) 2->(Optional Not Localized Text)"
    localize_info "PRINT-WARNING-DESC"  "Print Warning"
    localize_info "PRINT-WARNING-NOTES" "Localized."
fi
# -------------------------------------
print_warning()
{ 
    # Console width number
    T_COLS=`tput cols`
    tput sgr0
    if [ "$#" -eq "1" ]; then
        echo -e "\t${BPurple}$(localize "$1")${White}\n" | fold -sw $(( $T_COLS - 1 ))
    else
        echo -e "\t${BPurple}$(localize "$1") ${2}${White}\n" | fold -sw $(( $T_COLS - 1 ))
    fi
    tput sgr0
} 
#}}}
# -----------------------------------------------------------------------------
# PRINT TEST {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="print_test"
    USAGE="print_test 1->(Localized Text ID) 2->(Optional Not Localized Text)"
    DESCRIPTION=$(localize "PRINT-TEST-DESC")
    NOTES=$(localize "PRINT-TEST-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "PRINT-TEST-DESC"  "Print Test"
    localize_info "PRINT-TEST-NOTES" "Localized."
fi
# -------------------------------------
print_test()
{ 
    # Console width number
    T_COLS=`tput cols`
    tput sgr0
    if [ "$#" -eq "1" ]; then
        echo -e "\t${BBlue}$(localize "$1")     ${White}" | fold -sw $(( $T_COLS - 1 ))
    else
        echo -e "\t${BBlue}$(localize "$1") ${2}${White}" | fold -sw $(( $T_COLS - 1 ))
    fi
    tput sgr0
} 
#}}}
# -----------------------------------------------------------------------------
# PRINT ERROR {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="print_error"
    USAGE="print_error 1->(Localized Text ID) 2->(Optional Not Localized Text)"
    DESCRIPTION=$(localize "PRINT-ERROR-DESC")
    NOTES=$(localize "PRINT-ERROR-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "PRINT-ERROR-DESC"  "Print error"
    localize_info "PRINT-ERROR-NOTES" "Localized."
fi
# -------------------------------------
print_error()
{ 
    # Console width number
    T_COLS=`tput cols`
    tput sgr0
    if [ "$#" -eq "1" ]; then
        echo -e "\t${BRed}$(localize "$1")${White}\n" | fold -sw $(( $T_COLS - 1 ))
    else
        echo -e "\t${BRed}$(localize "$1") ${2}${White}\n" | fold -sw $(( $T_COLS - 1 ))
    fi
    tput sgr0
} 
#}}}
# -----------------------------------------------------------------------------
# CHECK BOX {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="checkbox"
    USAGE=$(localize "CHECK-BOX-USAGE")
    DESCRIPTION=$(localize "CHECK-BOX-DESC")
    NOTES=$(localize "CHECK-BOX-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "CHECK-BOX-USAGE" "checkbox 1->(0={ }, 1={X}, 2={U})"
    localize_info "CHECK-BOX-DESC"  "Display {X} or { } or {U} in Menus."
    localize_info "CHECK-BOX-NOTES" "Used in Menu System."
fi
# -------------------------------------
checkbox()
{ 
    if [[ "$1" -eq 0 ]]; then 
        echo -e "${BBlue}[${White} ${BBlue}]${White}"
    elif [[ "$1" -eq 1 ]]; then 
        echo -e "${BBlue}[${BWhite}X${BBlue}]${White}"
    elif [[ "$1" -eq 2 ]]; then 
        echo -e "${BBlue}[${BWhite}U${BBlue}]${White}"
    fi
} 
#}}}
# -----------------------------------------------------------------------------
# CHECKBOX PACKAGE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="checkbox_package"
    USAGE="checkbox_package 1->(checkboxlist)"
    DESCRIPTION=$(localize "CHECKBOX-PACKAGE-DESC")
    NOTES=$(localize "CHECKBOX-PACKAGE-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "CHECKBOX-PACKAGE-DESC"  "check if {X} or { }"
    localize_info "CHECKBOX-PACKAGE-NOTES" "None."
fi
# -------------------------------------
checkbox_package()
{ 
    check_package "$1" && checkbox 1 || checkbox 0
} 
# -----------------------------------------------------------------------------
#}}}
# CONTAINS ELEMENT {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="contains_element"
    USAGE="contains_element 1->(Search) 2->(&#36;{array[@]})" 
    DESCRIPTION=$(localize "CONTAINS-ELEMENT-DESC")
    NOTES=$(localize "CONTAINS-ELEMENT-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "CONTAINS-ELEMENT-DESC"  "Array Contains Element"
    localize_info "CONTAINS-ELEMENT-NOTES" "Used to Search Options in Select Statement for Valid Selections."
fi
# -------------------------------------
contains_element()
{ 
    # check if an element exist in a string
    for e in "${@:2}"; do [[ $e == $1 ]] && break; done;
} 
#}}}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    MyArrary=( "1" "2" "3" )    
    if contains_element "2" "${MyArrary[@]}"; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  contains_element @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  contains_element @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
# -----------------------------------------------------------------------------
# INVALID OPTION {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="invalid_option"
    USAGE="invalid_option 1->(Invalid Option)"
    DESCRIPTION=$(localize "INVALID-OPTION-DESC")
    NOTES=$(localize "INVALID-OPTION-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "INVALID-OPTION-DESC"  "Invalid option"
    localize_info "INVALID-OPTION-NOTES" "None."
    #
    localize_info "INVALID-OPTION-TEXT-1" "Invalid option"
fi
# -------------------------------------
invalid_option()
{ 
    print_line
    if [ "$#" -eq 0 ]; then
        print_this "INVALID-OPTION-TEXT-1"
    else
        print_this "INVALID-OPTION-TEXT-1" ": $1"
    fi
    if [[ "$INSTALL_WIZARD" -eq 0 && "$AUTOMAN" -eq 0 ]]; then
        pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    fi
} 
# -----------------------------------------------------------------------------
#}}}
# INVALID OPTIONS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="invalid_options"
    USAGE="invalid_options 1->(Invalid Options)"
    DESCRIPTION=$(localize "INVALID-OPTIONS-DESC")
    NOTES=$(localize "INVALID-OPTIONS-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "INVALID-OPTIONS-DESC"  "Invalid options"
    localize_info "INVALID-OPTIONS-NOTES" "Idea was to show all valid options, still in work.."
fi
# -------------------------------------
invalid_options()
{
    print_line
    if [ -z "$1" ]; then
        print_this "INVALID-OPTION-TEXT"
    else
        print_this "INVALID-OPTION-TEXT" ":$1"
    fi
} 
#}}}
# -----------------------------------------------------------------------------
# ASSERT {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="assert"
    USAGE="assert 1->(Called from) 2->(Test] 1->(Debugging Information)"
    DESCRIPTION=$(localize "ASSERT-DESC")
    NOTES=$(localize "ASSERT-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "ASSERT-DESC"  "assert for debugging variables"
    localize_info "ASSERT-NOTES" "None."
fi
# -------------------------------------
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
# DEBUGGER {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="debugger"
    USAGE=$(localize "DEBUGGER-USAGE")
    DESCRIPTION=$(localize "DEBUGGER-DESC")
    NOTES=$(localize "DEBUGGER-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "DEBUGGER-USAGE" "debugger 1->(1=On, x=Off)"
    localize_info "DEBUGGER-DESC"  "Add Option: Ran from Task Manager."
    localize_info "DEBUGGER-NOTES" "None."
fi
# -------------------------------------
debugger()
{
    if [[ "$1" -eq 1 ]]; then
        set -v
        set -x
    else
        set +v
        set +x
    fi
}
#}}}
# -----------------------------------------------------------------------------
# GET NETWORK DEVICE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="get_network_devices"
    USAGE="get_network_devices"
    DESCRIPTION=$(localize "GET-NETWORK-DEVICE-DESC")
    NOTES=$(localize "GET-NETWORK-DEVICE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "GET-NETWORK-DEVICE-DESC"  "Get Network Devices."
    localize_info "GET-NETWORK-DEVICE-NOTES" "Holds IP Address if its an Active connection; no test of Internet Access are done."
fi
# -------------------------------------
get_network_devices()
{
    local -a arr=( "" )
    if ifconfig | grep 'eth0' >/dev/null ; then
        check_eth0="$(ifconfig eth0 | grep 'inet addr:')"
        arr=(${check_eth0})
        check_eth0="${arr[1]:5}"
        # @FIX can we determine if it has Internet on it
    fi
    if ifconfig | grep 'eth1' >/dev/null ; then
        check_eth1="$(ifconfig eth1 | grep 'inet addr:')"
        arr=(${check_eth1})
        check_eth1="${arr[1]:5}"
    fi
    if ifconfig | grep 'eth2' >/dev/null ; then
        check_eth2="$(ifconfig eth2 | grep 'inet addr:')"
        arr=(${check_eth2})
        check_eth2="${arr[1]:5}"
    fi
    i=0
    if [[ "$check_eth0" != " "  ]]; then
        ETH0_ACTIVE=1
        NIC[$((i++))]="eth0"
        echo "device eth0 active: $check_eth0"
    fi
    if [[ "$check_eth1" != " "  ]]; then
        ETH1_ACTIVE=1
        NIC[$((i++))]="eth1"
        echo "device eth1 active: $check_eth1"
    fi
    if [[ "$check_eth2" != " " ]]; then
        ETH2_ACTIVE=1
        NIC[$((i++))]="eth2"
        echo "device eth2 active: $check_eth2"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# SHOW USERS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="show_users"
    USAGE="show_users"
    DESCRIPTION=$(localize "SHOW-USERS-DESC")
    NOTES=$(localize "SHOW-USERS-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "SHOW-USERS-DESC"  "Show Users."
    localize_info "SHOW-USERS-NOTES" "Shows users in /etc/passwd."
fi
# -------------------------------------
show_users()
{
    echo $(gawk -F: '{ print $1 }' /etc/passwd)
}
#}}}
# -----------------------------------------------------------------------------
# DEVICE LIST {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="device_list"
    USAGE="device_list"
    DESCRIPTION=$(localize "DEVICE-LIST-DESC")
    NOTES=$(localize "DEVICE-LIST-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "DEVICE-LIST-DESC"  "Get Device List."
    localize_info "DEVICE-LIST-NOTES" "Used to get Hard Drive Letter, assumes you are running this from a Flash Drive."
fi
# -------------------------------------
device_list()
{
    local OLD_IFS="$IFS"; IFS=$' ';
    # Get all SD devices
    LIST_ALL_DEVICES=$(ls /dev/sd*)
    # List: /dev/sda /dev/sda1 /dev/sda2 /dev/sdb /dev/sdb1
    LIST_DEVICES=( "" )
    IFS=$'\n'
    arr=$(echo $LIST_ALL_DEVICES | tr " " "\n")
    for x in $arr; do
        if [[ "${#x}" -eq 8 ]]; then
            if [ -z "$LIST_DEVICES" ]; then
                if [[ "$(cat /sys/block/${x: -3}/removable)" == "1" ]]; then
                    if [[ "$SCRIPT_DEVICE" == "${x: -4}" ]]; then
                        LIST_DEVICES[0]="${x: -3} Removable Device Script is Exexcuting."
                        SCRIPT_DEVICE="/dev/${x: -4}"
                    else
                        LIST_DEVICES[0]="${x: -3} Removable"
                    fi
                else
                    if [[ "$SCRIPT_DEVICE" == "${x: -4}" ]]; then
                        LIST_DEVICES[0]="${x: -3} Device Script is Exexcuting."
                        SCRIPT_DEVICE="/dev/${x: -4}"
                    else
                        LIST_DEVICES[0]="${x: -3}"
                    fi
                fi
            else
                if [[ "$(cat /sys/block/${x: -3}/removable)" == "1" ]]; then
                    if [[ "$SCRIPT_DEVICE" == "${x: -4}" ]]; then
                        LIST_DEVICES[$[${#LIST_DEVICES[@]}]]="${x: -3} Removable Device Script is Exexcuting."
                        SCRIPT_DEVICE="/dev/${x: -4}"
                    else
                        LIST_DEVICES[$[${#LIST_DEVICES[@]}]]="${x: -3} Removable"
                    fi
                else
                    if [[ "$SCRIPT_DEVICE" == "${x: -4}" ]]; then
                        LIST_DEVICES[$[${#LIST_DEVICES[@]}]]="${x: -3} Device Script is Exexcuting."
                        SCRIPT_DEVICE="/dev/${x: -4}"
                    else
                        LIST_DEVICES[$[${#LIST_DEVICES[@]}]]="${x: -3}"
                    fi
                fi
            fi
        fi
    done    
    IFS="$OLD_IFS"
}
#}}}
# -----------------------------------------------------------------------------    
# UMOUNT PARTITION {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="umount_partition"
    USAGE="umount_partition 1->(Device Name)"
    DESCRIPTION=$(localize "UMOUNT-PARTITION-DESC")
    NOTES=$(localize "UMOUNT-PARTITION-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "UMOUNT-PARTITION-DESC"  "Umount partition."
    localize_info "UMOUNT-PARTITION-NOTES" "None."
fi
# -------------------------------------
umount_partition()
{
    swapon -s|grep $1 && swapoff $1 # check if swap is on and umount
    mount|grep $1 && umount $1      # check if partition is mounted and umount
}
#}}}
# -----------------------------------------------------------------------------
# IS BREAKABLE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="is_breakable"
    USAGE="is_breakable 1->(Breakable Key) 2->(Key)"
    DESCRIPTION=$(localize "IS-BREAKABLE-DESC")
    NOTES=$(localize "IS-BREAKABLE-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "IS-BREAKABLE-DESC"  "is breakable checks to see if key input meets exit condition."
    localize_info "IS-BREAKABLE-NOTES" "Used to break out of Loops."
fi
# -------------------------------------
is_breakable() 
{ 
    local BreakableKey="$(to_lower_case "$1")"
    local Key="$(to_lower_case "$2")"
    [[ "$BreakableKey" == "$Key" ]] && break;
} 
#}}}
# -----------------------------------------------------------------------------
# TO LOWER CASE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="to_lower_case"
    USAGE="to_lower_case 1->(Word)"
    DESCRIPTION=$(localize "TO-LOWER-CASE-DESC")
    NOTES=$(localize "TO-LOWER-CASE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "TO-LOWER-CASE-DESC"  "Make all Lower Case."
    localize_info "TO-LOWER-CASE-NOTES" "None."
fi
# -------------------------------------
to_lower_case()
{ 
    echo $1 | tr '[A-Z]' '[a-z]'
} 
#}}}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if [[ $(to_lower_case "A") == 'a' ]]; then # Only make changes once
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  to_lower_case @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  to_lower_case @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
# -----------------------------------------------------------------------------
# TO UPPER CASE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="to_upper_case"
    USAGE="to_upper_case 1->(Word)"
    DESCRIPTION=$(localize "TO-UPPER-CASE-DESC")
    NOTES=$(localize "TO-UPPER-CASE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "TO-UPPER-CASE-DESC"  "Make all Upper Case."
    localize_info "TO-UPPER-CASE-NOTES" "None."
fi
# -------------------------------------
to_upper_case()
{ 
    echo $1 | tr '[a-z]' '[A-Z]'
} 
#}}}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if [[ $(to_upper_case "a") == 'A' ]]; then # Only make changes once
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  to_upper_case @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  to_upper_case @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
# -----------------------------------------------------------------------------
# PRINT ARRAY {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="print_array"
    USAGE=$(localize "PRINT-ARRAY-USAGE")
    DESCRIPTION=$(localize "PRINT-ARRAY-DESC")
    NOTES=$(localize "PRINT-ARRAY-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="21 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "PRINT-ARRAY-USAGE" "print_array 1->(array{@})"
    localize_info "PRINT-ARRAY-DESC"  "Print Array; normally for Troubleshooting; but could be used to print a list."
    localize_info "PRINT-ARRAY-NOTES" "None."
fi
# -------------------------------------
print_array()
{
    local OLD_IFS="$IFS"; IFS=$' '; 
    local -a myArray=("${!1}")     # Array 
    local -i total="${#myArray[@]}"
    echo -e "\t---------------------------------"
    echo -e "\t${BBlue}$1 total=$total ${White}"
    for (( i=0; i<${total}; i++ )); do
        echo -e "\t${BBlue}$1[$i]=|${myArray[$i]}| ${White}"
    done    
    echo -e "\t---------------------------------"
    IFS="$OLD_IFS"
}
#}}}
# -----------------------------------------------------------------------------
# Keyboard Input Functions
# -----------------------------------------------------------------------------
# READ INPUT {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="read_input"
    USAGE="read_input"
    DESCRIPTION=$(localize "READ-INPUT-DESC")
    NOTES=$(localize "READ-INPUT-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "READ-INPUT-DESC"  "read keyboard input."
    localize_info "READ-INPUT-NOTES" "Sets Variable OPTION as return; do not us in AUTOMAN or INSTALL_WIZARD Mode."
fi
# -------------------------------------
read_input()
{ 
    read -p "$prompt1" OPTION
} 
#}}}
# -----------------------------------------------------------------------------
# GET INPUT OPTION {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="get_input_option"
    USAGE="GET-INPUT-OPTION-USAGE"
    DESCRIPTION=$(localize "GET-INPUT-OPTION-DESC")
    NOTES=$(localize "GET-INPUT-OPTION-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "GET-INPUT-OPTION-USAGE"   "get_input_option 1->(array[@] of options) 2->(default) <- return value OPTION"
    localize_info "GET-INPUT-OPTION-DESC"    "Get Keyboard Input Options between two numbers."
    localize_info "GET-INPUT-OPTION-NOTES"   "None."
    localize_info "GET-INPUT-OPTION-CHOOSE"  "Choose a number between 1 and "
    localize_info "GET-INPUT-OPTION-DEFAULT" "Default is"
fi
# -------------------------------------
get_input_option()
{ 
    if [[ "$AUTOMAN" -eq 1 || "$INSTALL_WIZARD" -eq 1 && "$BYPASS" -eq 1 ]]; then
        OPTION="$2"
        return 0
    fi
    local -a array=("${!1}")
    local -i total="${#array[@]}"
    local -i index=0
    for var in "${array[@]}"; do
        echo "$(( ++index ))) ${var}"
    done    
    print_warning "GET-INPUT-OPTION-CHOOSE" "$total"
    print_this    "GET-INPUT-OPTION-DEFAULT" ": $2 (${array[$(( $2 - 1 ))]})"
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
    return 0
} 
#}}}
# -----------------------------------------------------------------------------
# READ INPUT OPTIONS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="read_input_options"
    USAGE=$(localize "READ-INPUT-OPTIONS-USAGE")
    DESCRIPTION=$(localize "READ-INPUT-OPTIONS-DESC")
    NOTES=$(localize "READ-INPUT-OPTIONS-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "READ-INPUT-OPTIONS-USAGE"   "read_input_options 1->(options) 2->(Breakable Key) <- return value OPTIONS"
    localize_info "READ-INPUT-OPTIONS-DESC"    "Read Keyboard Input Options:  String of values: 1 2 3 or 1-3 or 1,2,3"
    localize_info "READ-INPUT-OPTIONS-NOTES"   "AUTOMAN, INSTALL_WIZARD and BYPASS to easily configure default values, hit 'r' to run Recommended Options."
    localize_info "READ-INPUT-OPTIONS-OPTIONS" "Use Options"
    localize_info "READ-INPUT-OPTIONS-IT-1"    "read_input_options Return Array"
    localize_info "READ-INPUT-OPTIONS-IT-2"    "read_input_options Removed Dupplicates"
fi
# -------------------------------------
read_input_options()
{ 
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    # |1|
    # |1 2 3 4-6 8,7,9 10 Q|
    #debugger 1
    local -i count=0
    local -a MyArray=()
    local OLD_IFS="$IFS"; IFS=$'\n\t';
    OPTION="" # Clear it; we have no idea whats in it
    IFS=$' '
    if [[ "$AUTOMAN" -eq 1 || "$INSTALL_WIZARD" -eq 1 && "$BYPASS" -eq 1 ]]; then
        if [ -z "$1" ]; then
            MyArray=( $( echo "$2" ) ) # @FIX this should not happen; how to fix it?
        else
            MyArray=( $( echo "$1" ) )
        fi
    else
        while [[ -z "$OPTION" ]]; do
            OPTION="" # Clear it again; we still have no idea whats in it
            read -p "        $prompt2" OPTION
        done
        if [[ $(echo "$OPTION" | tr '[:upper:]' '[:lower:]') == 'r' ]]; then
            MyArray=( $( echo "$1" ) )
        else
            MyArray=( $( echo "$(trim "$OPTION")" ) ) # |1 2 3 4-6 8 7,9 10 Q|
        fi
    fi
    local line=""
    local packages_opt=""
    # "1" "2" "3-6" "7" "8,9" "Q"
    IFS=$' ';
    # Fix any problems with input
    local -i total="${#MyArray[@]}"
    for (( i=0; i<${total}; i++ )); do
        if [[ "${MyArray[$i]:0:1}" == "-" ]]; then
            MyArray[$i]=${MyArray[$i]:1}
        fi
    done
    #    
    for line in ${MyArray[@]/,/ }; do
        if [[ ${line/-/} != $line ]]; then
            for ((i=${line%-*}; i<=${line#*-}; i++)); do # Start at line with a - after it (%-*), 1-, then end with the - before it (#*-) -3, then count each item in between it, or expand it
                [[ -n "$i" ]] && packages_opt+=( "$i" );
            done
        else
            packages_opt+=( "$line" ) # This is building an Array; bash you have to love it for allowing this type of declaration; normally only works with strings in other languages; normally in bash: array=($array "new") or array[${#array[*]}]="new"
        fi
    done
    OPTIONS=( $(echo "${packages_opt[@]}" | tr '[:upper:]' '[:lower:]') )
    if [[ "$RUN_TEST" -eq 2 ]]; then
        print_test "READ-INPUT-OPTIONS-OPTIONS" "$1" # Use Options Passed in as is
    fi
    if [[ "$RUN_TEST" -eq 2 ]]; then
        print_test "READ-INPUT-OPTIONS-IT-1" ":" # read_input_options Return Array
        print_array "OPTIONS[@]"
    fi
    IFS=$'\t\n';
    OPTIONS=( $(remove_array_duplicates "OPTIONS[@]") )
    IFS=" ";
    if [[ "$RUN_TEST" -eq 2 ]]; then
        print_test "READ-INPUT-OPTIONS-IT-2" ":" # read_input_options Removed Dupplicates
        print_array "OPTIONS[@]"
    fi
    IFS="$OLD_IFS"
    #debugger 0
    write_log "read_input_options  $OPTION" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
} 
#}}}
# -----------------------------------------------------------------------------
# READ INPUT YN {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="read_input_yn"
    USAGE=$(localize "READ-INPUT-YN-USAGE")
    DESCRIPTION=$(localize "READ-INPUT-YN-DESC")
    NOTES=$(localize "READ-INPUT-YN-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="12 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "READ-INPUT-YN-USAGE" "read_input_yn 1->(Question) 2->(None Localize) 3->(0=No, 1=Yes) <- return value YN_OPTION"
    localize_info "READ-INPUT-YN-DESC"  "Read Keyboard Input for Yes and No."
    localize_info "READ-INPUT-YN-NOTES" "Localized."
    #
    localize_info "Wrong-Key-Yn" "Wrong Key, (Y)es or (n)o required."
    localize_info "Wrong-Key-Ny" "Wrong Key, (y)es or (N)o required."
fi
# -------------------------------------
read_input_yn()
{ 
    if [[ "$#" -ne "3" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if [[ "$AUTOMAN" -eq 1 || "$INSTALL_WIZARD" -eq 1 && "$BYPASS" -eq 1 ]]; then
        YN_OPTION="$3"
        return 0
    fi
    local MY_OPTION=0
    # read_input_yn "Is this Correct" "This" 1
    # GET INPUT YN {{{
    get_input_yn()
    {
        echo ""
        if [[ "$3" == "1" ]]; then
            read  -n 1 -p "$(localize $1) $2 [Y/n]: " 
        else
            read  -n 1 -p "$(localize $1) $2 [y/N]: " 
        fi
        YN_OPTION=$(echo "$REPLY" | tr '[:upper:]' '[:lower:]')
        echo ""
    }
    #}}}
    MY_OPTION=0
    while [[ "$MY_OPTION" -ne 1 ]]; do
        get_input_yn "$1" "$2" "$3"
        if [ -z "$YN_OPTION" ]; then
            MY_OPTION=1
            YN_OPTION="$3"
        elif [[ "$YN_OPTION" == 'y' ]]; then
            MY_OPTION=1
            YN_OPTION=1
        elif [[ "$YN_OPTION" == 'n' ]]; then
            MY_OPTION=1
            YN_OPTION=0
        else 
            MY_OPTION=0
            if [[ "$3" -eq 1 ]]; then
                print_error "Wrong-Key-Yn"
            else
                print_error "Wrong-Key-Ny"
            fi
            pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        fi
    done
    write_log "read_input_yn [$3] answer $YN_OPTION" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO" # Left out data, it could be a password or user name.
} 
#}}}
# -----------------------------------------------------------------------------
# READ INPUT DEFAULT {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="read_input_default"
    USAGE=$(localize "READ-INPUT-DEFAULT-USAGE")
    DESCRIPTION=$(localize "READ-INPUT-DEFAULT-DESC")
    NOTES=$(localize "READ-INPUT-DEFAULT-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="15 Jan 2013"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "READ-INPUT-DEFAULT-USAGE" "read_input_default 1->(Prompt) 2->(Default Value)"
    localize_info "READ-INPUT-DEFAULT-DESC"  "Read Keyboard Input and allow Edit of Default value."
    localize_info "READ-INPUT-DEFAULT-NOTES" "None."
fi
# -------------------------------------
read_input_default()
{ 
    # read_input_default "Enter Data" "Default-Date"
    if [[ "$AUTOMAN" -eq 1 || "$INSTALL_WIZARD" -eq 1 && "$BYPASS" -eq 1 ]]; then
        OPTION="$2"
        return 0
    fi
    read -e -p "$(localize "$1") >" -i "$2" OPTION
    echo ""
} 
#}}}
# -----------------------------------------------------------------------------
# READ INPUT DATA {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="read_input_data"
    USAGE=$(localize "READ-INPUT-DATA-USAGE")
    DESCRIPTION=$(localize "READ-INPUT-DATA-DESC")
    NOTES=$(localize "READ-INPUT-DATA-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "READ-INPUT-DATA-USAGE" "read_input_data 1->(Localized Prompt) <- return value OPTION"
    localize_info "READ-INPUT-DATA-DESC"  "Read Data."
    localize_info "READ-INPUT-DATA-NOTES" "Return value in variable OPTION; not to be used in AUTOMAN or INSTALL_WIZARD Mode, since there is no default value."
fi
# -------------------------------------
read_input_data()
{ 
    read -p "$(localize "$1") : " OPTION
    write_log "read_input_data  $1 = $OPTION" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO" 
} 
#}}}
# -----------------------------------------------------------------------------
# VERIFY INPUT DEFAULT DATA {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="verify_input_default_data"
    USAGE=$(localize "VERIFY-INPUT-DEFAULT-DATA-USAGE")
    DESCRIPTION=$(localize "VERIFY-INPUT-DEFAULT-DATA-DESC")
    NOTES=$(localize "VERIFY-INPUT-DEFAULT-DATA-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "VERIFY-INPUT-DEFAULT-DATA-USAGE"     "verify_input_default_data 1->(Prompt) 2->(Default-Value) 3->(Default 1=Yes or 0=No) <- return value in OPTION"
    localize_info "VERIFY-INPUT-DEFAULT-DATA-DESC"      "Verify Keyboard Input of Default Editable Value."
    localize_info "VERIFY-INPUT-DEFAULT-DATA-NOTES"     "None."
    #
    localize_info "VERIFY-INPUT-DEFAULT-DATA-ENTER"     "Enter"
    localize_info "VERIFY-INPUT-DEFAULT-DATA-VERIFY"    "Verify"
    localize_info "VERIFY-INPUT-DEFAULT-DATA-NOT-EMPTY" "Can not be empty"
fi
# -------------------------------------
verify_input_default_data()
{ 
    if [[ "$#" -ne "3" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if [[ "$AUTOMAN" -eq 1 || "$INSTALL_WIZARD" -eq 1 && "$BYPASS" -eq 1 ]]; then
        write_log "$FUNCNAME $1 = $YN_OPTION" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO" # Left out data, it could be a password or user name.
        OPTION="$2"
        return 0
    fi
    # READ VERIFY INPUT {{{
    read_verify_input()
    {
        echo ""
        read -e -p "$(localize "VERIFY-INPUT-DEFAULT-DATA-ENTER") $(localize "$1") >" -i "$2" OPTION
        echo ""
    }
    #}}}
    YN_OPTION=0
    while [[ "$YN_OPTION" -ne 1 ]]; do
        read_verify_input "$1" "$2"
        read_input_yn "VERIFY-INPUT-DEFAULT-DATA-VERIFY" " $(localize "$1") :  [$OPTION]" "$3"
        if [ -z "$YN_OPTION" ]; then
            echo "$(localize "VERIFY-INPUT-DEFAULT-DATA-NOT-EMPTY")!"
            YN_OPTION=0
        fi
    done
    write_log "$FUNCNAME $1 = $YN_OPTION" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO" # Left out data, it could be a password or user name.
    return 0
} 
#}}}
# -----------------------------------------------------------------------------
# VERIFY INPUT DATA {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="verify_input_data"
    USAGE=$(localize "VERIFY-INPUT-DATA-USAGE")
    DESCRIPTION=$(localize "VERIFY-INPUT-DATA-DESC")
    NOTES=$(localize "VERIFY-INPUT-DATA-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "VERIFY-INPUT-DATA-USAGE"  "verify_input_data 1->(Prompt) 2->(Data) <- return value OPTION"
    localize_info "VERIFY-INPUT-DATA-DESC"   "verify input data."
    localize_info "VERIFY-INPUT-DATA-NOTES"  "Localized."
    #
    localize_info "VERIFY-INPUT-DATA-ENTER"  "Enter"
    localize_info "VERIFY-INPUT-DATA-VERIFY" "Verify"
    localize_info "VERIFY-INPUT-DATA-EMPTY"  "Can not be empty"
fi
# -------------------------------------
verify_input_data()
{ 
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if [[ "$AUTOMAN" -eq 1 || "$INSTALL_WIZARD" -eq 1 && "$BYPASS" -eq 1 ]]; then
        OPTION="$2"
        return 0
    fi
    # READ VERIFY INPUT {{{
    read_verify_input()
    {
        read -p "$(localize "VERIFY-INPUT-DATA-ENTER") $(localize "$1") : " OPTION
    }
    #}}}
    YN_OPTION=0
    while [[ "$YN_OPTION" -ne 1 ]]; do
        read_verify_input "$1" # Returns OPTION
        read_input_yn "VERIFY-INPUT-DATA-VERIFY" "$(localize "$1"): [$OPTION]" "$2" # Returns YN_OPTION
        if [ -z "$OPTION" ]; then
            echo "$(localize "VERIFY-INPUT-DATA-EMPTY")!"
            YN_OPTION=0
        fi
    done
    write_log "$FUNCNAME $1 = $YN_OPTION" "$(basename $BASH_SOURCE) : $LINENO" # Left out data, it could be a password or user name.
    return 0
} 
#}}}
# -----------------------------------------------------------------------------
# IS OS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="is_os"
    USAGE=$(localize "IS-OS-USAGE")
    DESCRIPTION=$(localize "IS-OS-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "IS-OS-USAGE" "is_os 1->(os-name)"
    localize_info "IS-OS-DESC"  "Check to see if OS matches what you think it is"
fi
# -------------------------------------
is_os()
{
    count=$(egrep -ic "$1" '/etc/os-release')
    [[ "$count" -gt 0 ]] &&	return 0
    if [[ "$count" -gt 0 ]]; then
        return 0
    else
        return 1
    fi    
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 2 ]]; then
    #if is_os "UBUNTU" ; then
    if is_os "Arch Linux" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_os @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_os @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi    
fi
#}}}
# -----------------------------------------------------------------------------
# IS WILDCARD FILE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="is_wildcard_file"
    USAGE="is_wildcard_file 1->(/from/path/) 2->(filter)" 
    DESCRIPTION=$(localize "IS-WILDCARD-FILE-DESC")
    NOTES=$(localize "IS-WILDCARD-FILE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="12 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "IS-WILDCARD-FILE-DESC"  "Test for Files: is_wildcard_file '/from/path/' 'log' # if &lowast;.log exist."
    localize_info "IS-WILDCARD-FILE-NOTES" "filter: if ' ' all, else use extension, do not pass 'Array' in &lowast; as wildcard. If looking for a '/path/.hidden' file, a /path/&lowast; fails, so use no wild card, i.e. /path/."
fi
# -------------------------------------
is_wildcard_file()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    get_filter()
    {
        echo $(find "$1" -type f \( -name "*.$2" \))
    }
    if [ ! -d "$1" ]; then
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "[$1] Directory Not Found : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        return 1 # Path does not exist
    fi
    if [[ "$2" == " " ]]; then
        if find "$1" -maxdepth 0 -empty | read; then
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "[$1] * Not Found : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
            return 1  # EMPTY
        else
            return 0  # NOT EMPTY
        fi
    else
        FILTER=$(get_filter "$1" "$2")
        if [ -z "${FILTER}" ]; then    
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "get_filter [$1] *.$2 Not Found : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
            return 1  # EMPTY
        else
            return 0  # NOT EMPTY
        fi
    fi
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if [ -f "${FULL_SCRIPT_PATH}/Test/Target/Source/gtranslate-cc.db" ]; then
        if is_wildcard_file "${FULL_SCRIPT_PATH}/Test/Target/Source/" "db" ; then # " " | "ext" 
            echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_wildcard_file @ $(basename $BASH_SOURCE) : $LINENO${White}"
        else
            echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_wildcard_file @ $(basename $BASH_SOURCE) : $LINENO${White}"
        fi
        if is_wildcard_file "${FULL_SCRIPT_PATH}/Test/Target/Source/" " " ; then # " " | "ext" 
            echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_wildcard_file @ $(basename $BASH_SOURCE) : $LINENO${White}"
        else
            echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_wildcard_file @ $(basename $BASH_SOURCE) : $LINENO${White}"
        fi
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# MAKE DIR {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="make_dir"
    USAGE="make_dir 1->(/Full/Path) 2->(Debugging Information)"
    DESCRIPTION=$(localize "MAKE-DIR-DESC")
    NOTES=$(localize "MAKE-DIR-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "MAKE-DIR-DESC"  "Make Directory."
    localize_info "MAKE-DIR-NOTES" "return 0 if dir created."
fi
# -------------------------------------
make_dir()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if [[ -n "$1" ]]; then # Check for Empty
        [[ ! -d "$1" ]] && mkdir -pv "$1"
        if [ -d "$1" ]; then
            if [[ "$SILENT_MODE" -eq 0 ]]; then
                write_log "make_dir $1 from $2 at $DATE_TIME" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            fi
            return 0
        else
            write_error "make_dir $1 failed to create directory from line $2." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            print_error "make_dir $1 failed to create directory from line $2." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
            return 1
        fi
    else
        write_error "Empty: make_dir [$1] failed to create directory from line $2." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        print_error "make_dir $1 failed to create directory from line $2." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        return 1
    fi
    return 0
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if make_dir "${FULL_SCRIPT_PATH}/Test/Target/Source/MakeMe/" ": make_dir @ $(basename $BASH_SOURCE) : $LINENO" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  make_dir @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  make_dir @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# COPY DIRECTORY {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="copy_dir"
    USAGE=$(localize "COPY-DIRECTORY-USAGE")
    DESCRIPTION=$(localize "COPY-DIRECTORY-DESC")
    NOTES=$(localize "COPY-DIRECTORY-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "COPY-DIRECTORY-USAGE" "copy_dir 1->(/full-path/) 2->(/full-path/to_must_end_with_a_slash/) 3->(Debugging Information)"
    localize_info "COPY-DIRECTORY-DESC"  "Copy Directory."
    localize_info "COPY-DIRECTORY-NOTES" "None."
    #
    localize_info "COPY-DIRECTORY-PATH"  "Empty Path."
    localize_info "COPY-DIRECTORY-COPY"  "Copied Directory"
    localize_info "COPY-DIRECTORY-ERROR" "Failed to copy Directory."
    localize_info "COPY-DIRECTORY-MAKE"  "Failed to Make Directory."
fi
# -------------------------------------
copy_dir()
{
    if [[ "$#" -ne "3" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    #
    if [[ -z "$1" ]]; then
        print_error "COPY-DIRECTORY-PATH" "[$1] -> [$2] | $3 : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        write_error "COPY-DIRECTORY-PATH" "[$1] -> [$2] | $3 : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        return 1
    fi
    #
    if [ -z "$2" ]; then
        print_error "COPY-DIRECTORY-PATH" "[$1] -> [$2] | $3 : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        write_error "COPY-DIRECTORY-PATH" "[$1] -> [$2] | $3 : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        return 1
    fi
    #
    local dir_to="${2%/*}"
    # local file_to="${2##*/}"
    if [ ! -d "$dir_to" ]; then
        if [ -n "$dir_to" ]; then
            if ! make_dir "$dir_to" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO" ; then
                print_error "COPY-DIRECTORY-MAKE" "[$1] -> [$2] | $3 : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                write_error "COPY-DIRECTORY-MAKE" "[$1] -> [$2] | $3 : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
            fi
        fi
    fi
    #
    TEMP=$(cp -rfv "$1" "$2")
    if [ $? -eq 0 ]; then
        print_this "COPY-DIRECTORY-COPY" "[$1] -> [$2] : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        write_log  "COPY-DIRECTORY-COPY" "[$1] -> [$2] : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    else
        print_error "COPY-DIRECTORY-ERROR" "[$1] -> [$2] | $3 : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        write_error "COPY-DIRECTORY-ERROR" "[$1] -> [$2] | $3 : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        # @FIX if /etc resolv.conf needs its attributes changed
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        return 1
    fi
    return 0
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if copy_dir "${FULL_SCRIPT_PATH}/Test/Source/" "${FULL_SCRIPT_PATH}/Test/Target/" ": copy_dir @ $(basename $BASH_SOURCE) : $LINENO" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  copy_dir @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  copy_dir @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# REMOVE FILE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="remove_file"
    USAGE=$(localize "REMOVE-FILE-USAGE")
    DESCRIPTION=$(localize "REMOVE-FILE-DESC")
    NOTES=$(localize "REMOVE-FILE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "REMOVE-FILE-USAGE"     "remove_file 1->(/full-path/from.ext) 2->(Debugging Information)"
    localize_info "REMOVE-FILE-DESC"      "Remove File if it exist."
    localize_info "REMOVE-FILE-NOTES"     "if -f > rm -f."
    localize_info "REMOVE-FILE-NOT_FOUND" "Not Found"
fi
# -------------------------------------
remove_file()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if [ -f "$1" ]; then
        rm -f "$1"
        write_log  "remove_file $1" " -> $2"
        print_this "remove_file $1" " -> $2"
        return 0
    else
        write_error "REMOVE-FILE-NOT_FOUND" ": remove_file [$1] @ $2"
        print_error "REMOVE-FILE-NOT_FOUND" ": remove_file [$1] @ $2"
        return 1
    fi
} 
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    remove_file "${FULL_SCRIPT_PATH}/Test/Target/Source/README.md" "remove_file @ $(basename $BASH_SOURCE) : $LINENO"
    if [ ! -f "${FULL_SCRIPT_PATH}/Test/Target/Source/README.md" ]; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED") remove_file @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED") remove_file @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# REMOVE FILES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="remove_files"
    USAGE=$(localize "REMOVE-FILES-USAGE")
    DESCRIPTION=$(localize "REMOVE-FILES-DESC")
    NOTES=$(localize "REMOVE-FILES-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "REMOVE-FILES-USAGE"      "remove_files 1->(/Full-Path/) 2->(ext or Blank for *) 3->(Debugging Information)"
    localize_info "REMOVE-FILES-DESC"       "Remove Files if it exist."
    localize_info "REMOVE-FILES-NOTES"      "if -f > rm -f."
    localize_info "REMOVE-FILES-NOT_FOUND"  "Not Found"
    localize_info "REMOVE-FILES-FNF"        "File Not Found Failed to remove files"
    localize_info "REMOVE-FILES-FAIL"       "Failed to remove files"
fi
# -------------------------------------
remove_files()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if ! is_wildcard_file "$1" "$2" ; then # " " | "ext" 
        if [[ "$2" == " " ]]; then
            write_error "REMOVE-FILES-FNF" "[$1] -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME [$1] @ $(basename $BASH_SOURCE) : $LINENO)"; fi
        else
            write_error "REMOVE-FILES-FNF" "[$1*.$2] -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME [$1*.$2] @ $(basename $BASH_SOURCE) : $LINENO)"; fi
        fi
        return 1
    fi
    #
    if [[ "$2" == " " ]]; then
        TEMP=$(rm -rfv "$1.")           # /path/. remove all files and folders recursively
    else
        TEMP=$(rm -rfv "${1}"*."${2}")  # /path/*.ext remove only files with matching extensions
    fi
    if [ $? -eq 0 ]; then
        if [[ "$2" == " " ]]; then
            write_log "REMOVE-FILES-FAIL" " remove_file -rfv [$1.] $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        else
            write_log "REMOVE-FILES-FAIL" " remove_file -rfv [$1*.$2] $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        fi
    fi    
} 
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    copy_files "${FULL_SCRIPT_PATH}/Test/Extras/" " " "${FULL_SCRIPT_PATH}/Test/Target/Source/Extras/" "remove_files @ $(basename $BASH_SOURCE) : $LINENO"
    remove_files "${FULL_SCRIPT_PATH}/Test/Target/Extras/" "log" "remove_files @ $(basename $BASH_SOURCE) : $LINENO"
    if [ ! -f "${FULL_SCRIPT_PATH}/Test/Target/Extras/*.log" ]; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED") remove_files @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED") remove_files @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# REMOVE FOLDER {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="remove_folder"
    USAGE=$(localize "REMOVE-FOLDER-USAGE")
    DESCRIPTION=$(localize "REMOVE-FOLDER-DESC")
    NOTES=$(localize "REMOVE-FOLDER-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "REMOVE-FOLDER-USAGE"     "remove_folder 1->(/Full-Path/) 2->(Debugging Information)"
    localize_info "REMOVE-FOLDER-DESC"      "Remove Folder if it exist."
    localize_info "REMOVE-FOLDER-NOTES"     "if -d > rm -rf -- /Full-Path/"
    localize_info "REMOVE-FOLDER-NOT_FOUND" "Not Found"
fi
# -------------------------------------
remove_folder()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if [ -d "$1" ]; then
        rm -rf -- "$1"
        write_log  "remove_folder $1" " -> $2 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        print_this "remove_folder $1" " -> $2 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        return 0
    else
        write_error "REMOVE-FOLDER-NOT_FOUND" ": remove_folder [$1] @ $2 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        print_error "REMOVE-FOLDER-NOT_FOUND" ": remove_folder [$1] @ $2 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        return 1
    fi
} 
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    mkdir -p ${FULL_SCRIPT_PATH}/Test/Target/RemoveMe/
    remove_folder "${FULL_SCRIPT_PATH}/Test/Target/RemoveMe/" "remove_folder @ $(basename $BASH_SOURCE) : $LINENO"
    if [ ! -d "${FULL_SCRIPT_PATH}/Test/Target/RemoveMe/" ]; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED") remove_folder @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED") remove_folder @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# COPY FILE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="copy_file"
    USAGE="copy_file 1->(/full-path/from.ext) 2->(/full-path/to_must_end_with_a_slash/) 3->(Debugging Information)"
    DESCRIPTION=$(localize "COPY-FILE-DESC")
    NOTES=$(localize "COPY-FILE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "COPY-FILE-DESC"  "Copy File."
    localize_info "COPY-FILE-NOTES" "Creates Destination Folder if not exist. LINENO is for Logging and Debugging."
fi
# -------------------------------------
copy_file()
{
    if [[ "$#" -ne "3" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    # 
    if [ ! -f "$1" ]; then
        if [[ "${EXCLUDE_FILE_WARN[@]}" != *"$1"* ]]; then
            write_error "File Not Found! copy_file $1 to $2 failed to copy file from $3 at $DATE_TIME." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "File Not Found! $1 to $2 from $3 (: $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO)"; fi
        fi
        return 1
    fi
    if [ -z "$2" ]; then # Check for Empty
        write_error "Path Emtpy! copy_file $1 to $2 failed to copy file from $3 at $DATE_TIME." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "Path Emtpy! $1 to $2 from $3 (: $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO)"; fi
        return 1
    fi
    local dir_to="${2%/*}"
    # local file_to="${2##*/}"
    if [ ! -d "$dir_to" ]; then # Check for Empty
        make_dir "$dir_to" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    fi
    if [[ -n "$1" && -n "$2" ]]; then # Check for Empty
        cp -fv "$1" "$2"
        if [ $? -eq 0 ]; then
            write_log "copy_file $1 to $2 from $3 at $DATE_TIME" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        else
            write_error "copy_file $1 to $2 failed to copy file from $3 at $DATE_TIME." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$1 to $2 from $3 (: $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO)"; fi
            return 1
        fi
    else
        write_error "Empty: copy_file [$1] to [$2] failed to copy file from $3 at $DATE_TIME." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "Empty: [$1] to [$2] from $3 (: $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO)"; fi
        return 1
    fi
    return 0
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    copy_file "${FULL_SCRIPT_PATH}/Test/Source/README.md" "${FULL_SCRIPT_PATH}/Test/Target/Source/README.md" "copy_file @ $(basename $BASH_SOURCE) : $LINENO"
    if [ -f "${FULL_SCRIPT_PATH}/Test/Target/Source/README.md" ]; then # Only make changes once
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  copy_file @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  copy_file @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# COPY FILES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="copy_files"
    USAGE=$(localize "COPY-FILES-USAGE")
    DESCRIPTION=$(localize "COPY-FILES-DESC")
    NOTES=$(localize "COPY-FILES-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "COPY-FILES-USAGE" "copy_files 1->(/full-path/) 2->(ext or Blank for *) 3->(/full-path/to_must_end_with_a_slash/) 4->(Debugging Information)<br />${HELP_TAB}copy_files 1->(/full-path/) 2->( ) 3->(/full-path/to_must_end_with_a_slash/) 4->(Debugging Information)"
    localize_info "COPY-FILES-DESC"  "Creates Destination Folder if not exist. LINENO is for Logging and Debugging."
    localize_info "COPY-FILES-NOTES" "If looking for a '/path/.hidden' file, a /path/&lowast; fails, so use no wild card, i.e. /path/"
fi
# -------------------------------------
copy_files()
{
    if [[ "$#" -ne "4" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if ! is_wildcard_file "$1" "$2" ; then # " " | "ext" 
        if [[ "$2" == " " ]]; then
            write_error "Files Not Found! copy_files->is_wildcard_file [$1] to [$3] failed to copy file from $4 at $DATE_TIME." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "Files Not Found! -rfv [$1] to [$3] from $4 (: $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO)"; fi
        else
            write_error "Files Not Found! copy_files->is_wildcard_file [$1*.$2] to [$3] failed to copy file from $4 at $DATE_TIME." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "Files Not Found! -fv [$1*.$2] to [$3] from $4 (: $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO)"; fi
        fi
        return 1
    fi
    if [[ -z "$3" ]]; then # Check for Empty
        write_error "Path Emtpy! copy_files $1 to $3 failed to copy file from $4 at $DATE_TIME." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "Path Emtpy! $1 to $3 from $4 (: $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO)"; fi
        return 1
    fi
    local dir_to="${3%/*}"
    # local file_to="${3##*/}"
    if [ ! -d "$dir_to" ]; then  # Check for Empty
        make_dir "$dir_to" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    fi
    if [[ -n "$1" && -n "$3" ]]; then  # Check for Empty
        echo -e "${BWhite} copy_files [$1*.$2] to [$3] ${White}"
        if [[ "$2" == " " ]]; then
            TEMP=$(cp -rfv "$1." "$3")     # /path/. copy all files and folders recursively
        else
            TEMP=$(cp -rfv "${1}"*."${2}" "$3")   # /path/*.ext copy only files with matching extensions
        fi
        if [ $? -eq 0 ]; then
            if [[ "$2" == " " ]]; then
                write_log "copy_files -rfv [$1.] to [$3] from $4 at $DATE_TIME" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            else
                write_log "copy_files -rfv [$1*.$2] to [$3] from $4 at $DATE_TIME" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            fi
        else
            print_error "copy_files -rfv [$1*.$2] to [$3] failed to copy file from $4 at $DATE_TIME." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            if [[ "$2" == " " ]]; then
                write_error "copy_files -rfv [$1.] to [$3] failed to copy file from $4." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            else
                write_error "copy_files -rfv [$1*.$2] to [$3] failed to copy file from $4 at $DATE_TIME." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            fi
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$1*.$2 to $3 from $4 returned $TEMP (: $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO)"; fi
            return 1
        fi
    else
        write_error "Empty: copy_files [$1*.$2] to [$2] failed to copy file from $3 at $DATE_TIME." "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "Empty: [$1*.$2] to [$2] from $3 (: $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO)"; fi
        return 1
    fi
    return 0
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    copy_files "${FULL_SCRIPT_PATH}/Test/Extras/" "log" "${FULL_SCRIPT_PATH}/Test/Target/Source/Extras/" "copy_files @ $(basename $BASH_SOURCE) : $LINENO"
    if [ -f "${FULL_SCRIPT_PATH}/Test/Target/Source/README.md" ]; then # Only make changes once
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  copy_files @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  copy_files @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
    copy_files "${FULL_SCRIPT_PATH}/Test/Extras/" " " "${FULL_SCRIPT_PATH}/Test/Target/Source/Extras/" "copy_files @ $(basename $BASH_SOURCE) : $LINENO"
    if [ -f "${FULL_SCRIPT_PATH}/Test/Target/Source/README.md" ]; then # Only make changes once
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  copy_files @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  copy_files @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# DELETE LINE IN FILE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="delete_line_in_file"
    USAGE=$(localize "DELETE-LINE-IN-FILE-USAGE")
    DESCRIPTION=$(localize "DELETE-LINE-IN-FILE-DESC")
    NOTES=$(localize "DELETE-LINE-IN-FILE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" " @ $(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "DELETE-LINE-IN-FILE-USAGE" "delete_line_in_file 1->(Text to Delete) 2->(/FullPath/FileName.ext)"
    localize_info "DELETE-LINE-IN-FILE-DESC"  "Given text of Line, Delete it in File"
    localize_info "DELETE-LINE-IN-FILE-NOTES" "This function is not ready to use, I forgot to finish it, so its just a stub that needs to be finished"
fi
# -------------------------------------
delete_line_in_file()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    sed -i '/'${1}'/ d' "$2"
    return "$?"
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    print_info "TEST-FUNCTION-RUN"
    # @FIX; This function is not ready to use, I forgot to finish it, so its just a stub that needs to be finished
fi
# -----------------------------------------------------------------------------
# COMMENT FILE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="comment_file"
    USAGE=$(localize "COMMENT-FILE-USAGE")
    DESCRIPTION=$(localize "COMMENT-FILE-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" " @ $(basename $BASH_SOURCE) : $LINENO"
fi
# Help file Localization
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "COMMENT-FILE-USAGE" "comment_file 1->(Text to Comment) 2->(/FullPath/FileName.ext)"
    localize_info "COMMENT-FILE-DESC"  "Given text of Line, Comment it out in File"
    #
    localize_info "COMMENT-FILE-FNF"  "File not found"
fi
# -------------------------------------
comment_file()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    [[ ! -f "$2" ]] && (print_error "COMMENT-FILE-FNF" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; return 1)
    sed -i 's/^'${1}'/#'${1}'/g' "$2"
    return "$?"
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if comment_file "Defaults:${USERNAME}" "${FULL_SCRIPT_PATH}/Test/Target/Source/sudoers" ; then
        print_test "TEST-FUNCTION-PASSED" "comment_file @ $(basename $BASH_SOURCE) : $LINENO"
    else
        print_error "TEST-FUNCTION-FAILED" "comment_file @ $(basename $BASH_SOURCE) : $LINENO"
    fi
fi
# -----------------------------------------------------------------------------
# UN-COMMENT FILE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="un_comment_file"
    USAGE=$(localize "UN-COMMENT-FILE-USAGE")
    DESCRIPTION=$(localize "UN-COMMENT-FILE-DESC")
    NOTES=$(localize "NONE")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
# Help file Localization
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_info "UN-COMMENT-FILE-USAGE" "un_comment_file 1->(Text) 2->(/FullPath/FileName.ext)"
    localize_info "UN-COMMENT-FILE-DESC"  "Given text of Line, un-Comment it out in File"
fi
# -------------------------------------
un_comment_file()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    [[ ! -f "$2" ]] && (print_error "COMMENT-FILE-FNF" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; return 1)
    sed -i 's/^#'${1}'/'${1}'/g' "$2"           
    return "$?"
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if un_comment_file "#Defaults:${USERNAME}" "${FULL_SCRIPT_PATH}/Test/Target/Source/sudoers" ; then
        print_test "TEST-FUNCTION-PASSED" "un_comment_file @ $(basename $BASH_SOURCE) : $LINENO"
    else
        print_error "TEST-FUNCTION-FAILED" "un_comment_file @ $(basename $BASH_SOURCE) : $LINENO"
    fi
fi
# -----------------------------------------------------------------------------
# ADD OPTION {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="add_option"
    USAGE=$(localize "ADD-OPTION-USAGE")
    DESCRIPTION=$(localize "ADD-OPTION-DESC")
    NOTES=$(localize "ADD-OPTION-NOTES")
    # http://www.grymoire.com/Unix/Quote.html
    # http://www.grymoire.com/Unix/Sed.html
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "ADD-OPTION-USAGE" "add_option 1->(/Config/FullPath/FileName.ext) 2->(Option-String) 3->(Text to Add) 4->(Package Name)"
    localize_info "ADD-OPTION-DESC"  "Add Option: Given File Name, Option and Text, add option to end of line in file."
    localize_info "ADD-OPTION-NOTES" "If you have a string in a file: i.e. '[Option]=', you can append Text to add to it: i.e. '[Option]=Text Added'"
    localize_info "ADD-OPTION-SF"    "Warning: String Exist:"
    localize_info "ADD-OPTION-ERROR" "Error: String not Found:"
    localize_info "ADD-OPTION-FNF"   "File Not Found:"
fi
# -------------------------------------
add_option()
{
    if [[ "$#" -ne "4" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if [ -f "$1" ]; then
        if is_string_in_file "$1" "$2" ; then
            if ! is_string_in_file "$1" "$3" ; then
                sed -i '/'${2}'/ s_$_'${3}'_' ${1}
                return "$?"
            else
                print_error "ADD-OPTION-SF" "$1 - $2 - $3 - Package: $4 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                write_error "ADD-OPTION-SF" "$1 - $2 - $3 - Package: $4 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            fi
        else
            print_error "ADD-OPTION-ERROR" "$1 - $2 - $3 - Package: $4 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            write_error "ADD-OPTION-ERROR" "$1 - $2 - $3 - Package: $4 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        fi
    else
        print_error "ADD-OPTION-FNF" "$1 - $2 - $3 - Package: $4 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        write_error "ADD-OPTION-FNF" "$1 - $2 - $3 - Package: $4 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    # add_option "/usr/share/config/kdm/kdmrc" "SessionsDirs=" ",/usr/share/xsessions" "APPEND-FILE-"
    # SessionsDirs=/usr/share/config/kdm/sessions,/usr/share/apps/kdm/sessions
    add_option "${FULL_SCRIPT_PATH}/Test/Target/Source/kdmrc" 'SessionsDirs=' ',/usr/share/xsessions' 'ADD-OPTION-KDM'
    if is_string_in_file "${FULL_SCRIPT_PATH}/Test/Target/Source/kdmrc" ",/usr/share/xsessions" ; then
        print_test "TEST-FUNCTION-PASSED" "add_option @ $(basename $BASH_SOURCE) : $LINENO"
    else
        print_error "TEST-FUNCTION-FAILED" "add_option @ $(basename $BASH_SOURCE) : $LINENO"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# REPLACE OPTION {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="replace_option"
    USAGE=$(localize "REPLACE-OPTION-USAGE")
    DESCRIPTION=$(localize "REPLACE-OPTION-DESC")
    NOTES=$(localize "REPLACE-OPTION-NOTES")
    # http://www.grymoire.com/Unix/Quote.html
    # http://www.grymoire.com/Unix/Sed.html
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "REPLACE-OPTION-USAGE" "replace_option 1->(/Config/FullPath/FileName.ext) 2->(Option-String) 3->(Text to Replace) 4->(Package Name)"
    localize_info "REPLACE-OPTION-DESC"  "Replace Option: Given File Name, Option and Text, add option to end of line in file."
    localize_info "REPLACE-OPTION-NOTES" "If you have a string in a file: i.e. '[Option]=', you can append Text to add to it: i.e. '[Option]=Text Added'"
    localize_info "REPLACE-OPTION-SF"    "Warning: String Exist:"
    localize_info "REPLACE-OPTION-ERROR" "Error: String not Found:"
    localize_info "REPLACE-OPTION-FNF"   "File Not Found:"
fi
# -------------------------------------
replace_option()
{
    # replace_option "/usr/share/config/kdm/kdmrc" "AllowClose=" "true" "APPEND-FILE-"
    # sed '/AllowClose=/ c\AllowClose=true' /home/jflesher/Downloads/arch-git/archwiz/Test/Target/Source/kdmrc
    # AllowClose=false to AllowClose=true
    if [[ "$#" -ne "4" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if [ -f "$1" ]; then
        if is_string_in_file "$1" "$2" ; then
            if ! is_string_in_file "$1" "${2}$3" ; then
                #debugger 1
                sed -i 's/^'${2}'.*$/'${2}${3}'/' ${1}
                #echo "sed returned: $?"
                #debugger 0
                return "$?"
            else
                print_error "REPLACE-OPTION-SF" "$1 - $2 - $3 - Package: $4 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
                write_error "REPLACE-OPTION-SF" "$1 - $2 - $3 - Package: $4 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            fi
        else
            print_error "REPLACE-OPTION-ERROR"
            write_error "REPLACE-OPTION-ERROR" "$1 - $2 - $3 - Package: $4 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        fi
    else
        print_error "REPLACE-OPTION-FNF" "$1 - $2 - $3 - Package: $4 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        write_error "REPLACE-OPTION-FNF" "$1 - $2 - $3 - Package: $4 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
    fi
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    replace_option "${FULL_SCRIPT_PATH}/Test/Target/Source/kdmrc" 'AllowClose=' 'true' 'ADD-OPTION-KDM'
    if is_string_in_file "${FULL_SCRIPT_PATH}/Test/Target/Source/kdmrc" "AllowClose=true" ; then
        print_test "TEST-FUNCTION-PASSED" "replace_option @ $(basename $BASH_SOURCE) : $LINENO"
    else
        print_error "TEST-FUNCTION-FAILED" "replace_option @ $(basename $BASH_SOURCE) : $LINENO"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# MAKE FILE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="make_file"
    USAGE="make_file 1->(FileName.ext) 2->(Debugging Information)"
    DESCRIPTION=$(localize "MAKE-FILE-DESC")
    NOTES=$(localize "MAKE-FILE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "MAKE-FILE-DESC"  "Make file."
    localize_info "MAKE-FILE-NOTES" "None."
    localize_info "MAKE-FILE-PASSED" "Make File created"
    localize_info "MAKE-FILE-FAILED" "Failed to create File"
fi
# -------------------------------------
make_file()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if [[ -n "$1" && -n "$2" ]]; then # Check for Empty
        [[ ! -f "$1" ]] && touch "$1"    
        if [ -f "$1" ]; then
            write_log "MAKE-FILE-PASSED" ": $1 # $2 : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            return 0
        else
            write_error "MAKE-FILE-FAILED" ": $1 # $2 : -f : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
            return 1
        fi
    else
        write_error "MAKE-FILE-FAILED" "$1 # $2 : -n : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        print_error "MAKE-FILE-FAILED" "$1 # $2 : -n : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "Empty: [$1] at $3 : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        return 1
    fi
    return 0
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if make_file "${FULL_SCRIPT_PATH}/Test/Target/Source/MakeMe/me.txt" ": make_file @ $(basename $BASH_SOURCE) : $LINENO" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  make_file @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  make_file @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# SAVE ARRAY {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="save_array"
    USAGE=$(localize "SAVE-ARRAY-USAGE")
    DESCRIPTION=$(localize "SAVE-ARRAY-DESC")
    NOTES=$(localize "SAVE-ARRAY-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "SAVE-ARRAY-USAGE" "save_array 1->(Array(@)) 2->(/Path) 3->(MenuName.ext)"
    localize_info "SAVE-ARRAY-DESC"  "Save Array."
    localize_info "SAVE-ARRAY-NOTES" "None."
    localize_info "SAVE-ARRAY-ERROR" "Error Saving Array."
fi
# -------------------------------------
save_array()
{
    if [[ "$#" -ne "3" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    make_dir "${2}" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    touch "${2}/$3"
    local -a array=("${!1}")
    local -i total="${#array[@]}"
    for (( i=0; i<${total}; i++ )); do
        if [[ "$i" == 0 ]]; then
            echo "${array[$i]}"  > "${2}/$3" # Overwrite
        else
            echo "${array[$i]}" >> "${2}/$3" # Append
        fi
    done
    if [ ! -f "${2}/$3" ]; then
        write_error "SAVE-ARRAY-ERROR" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        print_error "SAVE-ARRAY-ERROR" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        if [[ "$DEBUGGING" -eq 1 ]]; then pause_function "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"; fi
        return 1
    fi
    return 0
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    MyArray=( "1" "2" "3")
    if save_array "MyArray[@]" "${FULL_SCRIPT_PATH}/Test/Target/Source/" "MyArray.db" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  save_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  save_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# LOAD ARRAY {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="load_array"
    USAGE=$(localize "LOAD-ARRAY-USAGE")
    DESCRIPTION=$(localize "LOAD-ARRAY-DESC")
    NOTES=$(localize "LOAD-ARRAY-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "LOAD-ARRAY-USAGE" "Array=( &#36;(load_array 1->(/Path/ArrayName.ext) 2->(ArrarySize) 3->(Default Data) ) )"
    localize_info "LOAD-ARRAY-DESC"  "Load a saved Array from Disk."
    localize_info "LOAD-ARRAY-NOTES" "None."
fi
# -------------------------------------
load_array()
{
    if [[ "$#" -ne "3" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    if [[ -f "$1" ]]; then
        while read line; do 
            echo "$line" # Stored Data
        done < "$1" # Load Array from serialized disk file
    else
        for (( i=0; i<${2}; i++ )); do
            echo "$3" # Default Data
        done
    fi
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    OLD_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    MyArray=( $(load_array "${FULL_SCRIPT_PATH}/Test/Target/Source/MyArray.db" 0 0 ) ) 
    total="${#MyArray[@]}"
    if [[ "$total" -eq 3 ]]; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  load_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  load_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
    IFS="$OLD_IFS"
fi
#}}}
# -----------------------------------------------------------------------------
# CREATE DATA ARRAY {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="create_data_array"
    USAGE=$(localize "CREATE-DATA-ARRAY-USAGE")
    DESCRIPTION=$(localize "CREATE-DATA-ARRAY-DESC")
    NOTES=$(localize "CREATE-DATA-ARRAY-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "CREATE-DATA-ARRAY-USAGE" "create_data_array 1->(ArrarySize) 2->(Default Data)"
    localize_info "CREATE-DATA-ARRAY-DESC"  "Create Data Array."
    localize_info "CREATE-DATA-ARRAY-NOTES" "None."
fi
# -------------------------------------
create_data_array()
{ 
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    [[ "$1" -eq 0 ]] && return 0
    for (( i=0; i<${1}; i++ )); do
        echo "$1" # Default Data
    done
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    OLD_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    MyArray=( $(create_data_array 3 0 ) ) 
    total="${#MyArray[@]}"
    if [[ "$total" -eq 3 ]]; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  create_data_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  create_data_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
    IFS="$OLD_IFS"
fi
#}}}
# -----------------------------------------------------------------------------
# IS NUMBER {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="is_number"
    USAGE=$(localize "IS-NUMBER-USAGE")
    DESCRIPTION=$(localize "IS-NUMBER-DESC")
    NOTES=$(localize "IS-NUMBER-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "IS-NUMBER-USAGE" "is_number 1->(value)"
    localize_info "IS-NUMBER-DESC"  "Is Number."
    localize_info "IS-NUMBER-NOTES" "None."
fi
# -------------------------------------
is_number()
{ 
    if [[ "$1" =~ ^[0-9]+$ ]] ; then
        return 0
    else
        return 1
    fi    
} 
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if $(is_number "1") && ! $(is_number "A") ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_number @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_number @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# PRINT MENU {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="print_menu"
    USAGE=$(localize "PRINT-MENU-USAGE")
    DESCRIPTION=$(localize "PRINT-MENU-DESC")
    NOTES=$(localize "PRINT-MENU-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "PRINT-MENU-USAGE" "print_menu 1->(MenuArray[@]) 2->(MenuInfoArray[@]) 3->(Letter to Exit)"
    localize_info "PRINT-MENU-DESC"  "Print Menu."
    localize_info "PRINT-MENU-NOTES" "Localized."
    #
    localize_info "MENU-Q" "Quit"
    localize_info "MENU-B" "Back"
    localize_info "MENU-D" "Done"
fi
# -------------------------------------
print_menu()
{ 
    if [[ "$#" -ne "3" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    local -a arrayMenu=("${!1}")     # Array 
    local -i total="${#arrayMenu[@]}"
    #
    local -a arrayInfo=("${!2}")     # Array 
    local -i totalInfo="${#arrayInfo[@]}"
    #
    local -i index=0
    tput sgr0
    #
    for (( index=0; index<${totalInfo}; index++ )); do
        if [[ "$totalInfo" -le 8 ]]; then
            if [ "${#arrayInfo[$index]}" -gt 0 ]; then
                print_this "${SPACE}${arrayInfo[$index]}"; tput sgr0
            fi
        else
            if [ "${#arrayInfo[$index]}" -gt 0 ]; then
                print_this "${arrayInfo[$index]}"; tput sgr0    
            fi
        fi
    done
    #
    echo ""
    for (( index=0; index<${total}; index++ )); do
        if [[ "$index" -le 8 ]]; then
            echo -e "${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${arrayMenu[$index]}"; tput sgr0
        else
            echo -e "${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${arrayMenu[$index]}"; tput sgr0    
        fi
    done
    MY_ACTION=" "
    if [[ "$3" == 'Q' ]]; then
        MY_ACTION=$(localize "MENU-Q")
    elif [[ "$3" == 'B' ]]; then
        MY_ACTION=$(localize "MENU-B")
    elif [[ "$3" == 'D' ]]; then
        MY_ACTION=$(localize "MENU-D")
    fi
    echo ""
    if [[ "$index" -le 8 ]]; then
        echo -e "${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${3}) $MY_ACTION"; tput sgr0 
    else
        echo -e "${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${3}) $MY_ACTION"; tput sgr0 
    fi
    echo ""
} 
#}}}
# -----------------------------------------------------------------------------
# ADD MENU ITEM {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="add_menu_item"
    USAGE=$(localize "ADD-MENU-ITEM-USAGE")
    DESCRIPTION=$(localize "ADD-MENU-ITEM-DESC")
    NOTES=$(localize "ADD-MENU-ITEM-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "ADD-MENU-ITEM-USAGE" "add_menu_item 1->(Checkbox_List_Array) 2->(Menu_Array) 3->(Info_Array) 4->(Menu Description in White) 5->(In Yellow) 6->(In Red) 7->(Information Printed Above Menu) 8->(MenuTheme_Array[@])"
    localize_info "ADD-MENU-ITEM-DESC"  "Add Menu Item."
    localize_info "ADD-MENU-ITEM-NOTES" "Text should be Localize ID."
fi
# -------------------------------------
add_menu_item()
{ 
    if [[ "$#" -ne "8" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    # 1. Checkbox List Array -> 0 based Array
    # 2. Menu Array
    # 3. Info-Array
    # 4. Menu Description (In White)
    # 5. Menu Description (In Yellow)
    # 6. Menu Description (In Red)
    # 7. Informatin Printed Above Menu -> Build InfoArray
    # 8. Theme
    # @FIX pass in Checkbox-List-Array
    # RESET_MENU Unused; but lets function knows its a new menu
    
    #local -a checkbox_array=("${!1}")  # Checkbox List Array 
    #echo "checkbox_array=${checkbox_array[@]}"
    eval "total_checkbox=\${#$1[@]}" # Checkbox_List_Array = 0 First Time
    if [[ "$total_checkbox" -eq 0 ]]; then
        array_push "$1" "0" # First Time we Create a Blank Checkbox Array; this means that a Save menu has not been Restored; so set it to 0
        total_checkbox=1
    fi
    eval "total=\${#$2[@]}" # Menu_Array = 0 First Time; we push results into it
    #    
    if [[ "$total" -ge "$total_checkbox" ]]; then # First time total=0 and total_checkbox=1, Second time total=1 and total_checkbox=1, so we need to push a new chechbox, since we will push another menu item
        array_push "$1" "0"
        ((total_checkbox++))
    fi
    #
    eval "cba=\${$1[$total]}" # First time=0, Second time=1...
    #
    if [[ -z "$cba" ]]; then
        cba=0
        if [[ "$RUN_TEST" -eq 2 ]]; then
            print_error "add_menu_item checkbox null value is wrong! Menu Description: $4 " "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        fi
        write_error "add_menu_item checkbox null value is wrong! Menu Description: $4 " "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    fi
    if ! is_number "$cba" ; then
        if [[ "$RUN_TEST" -eq 2 ]]; then
            print_error "add_menu_item checkbox value is wrong! total=$total cba=$cba Menu Description: $4 " "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        fi
        write_error "add_menu_item checkbox value is wrong! total=$total cba=$cba Menu Description: $4 " "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        cba=0
    fi
    #
    local -a arrayTheme=("${!8}")     # Theme Array 
    local -i total_theme="${#arrayTheme[@]}"
    if [[ "$total_theme" -ne 3 ]]; then
        write_error "add_menu_item MenuTheme_Array should have 3 elements: total=$total Menu Description: $4 " "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        arrayTheme[0]="${Yellow}"
        arrayTheme[1]="${White}"
        arrayTheme[2]=")"
    fi
    #
    array_push "$2" "${arrayTheme[0]}$(( total + 1 ))${arrayTheme[2]}${arrayTheme[1]} $(checkbox ${cba}) ${BWhite}$(localize "$4") ${BYellow}$(localize "$5") ${BRed}$(localize "$6")${White}"
    array_push "$3" "$(localize "$7")"
    return 0
} 
#}}}
# -----------------------------------------------------------------------------
# IS INTERNET {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="is_internet"
    USAGE="is_internet"
    DESCRIPTION=$(localize "IS-INTERNET-DESC")
    NOTES=$(localize "IS-INTERNET-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "IS-INTERNET-DESC"  "Check if Internet is up by Pinging two Major DNS servers."
    localize_info "IS-INTERNET-NOTES" "This pings google.com and wikipedia.org; they are good to ping to see if the Internet is up."
    #
    localize_info "IS-INTERNET-INFO" "Checking for Internet Connection..."
fi
# -------------------------------------
is_internet()
{
    host1="google.com"
    host2="wikipedia.org"
    print_info "IS-INTERNET-INFO"
    ((ping -w5 -c3 "$host1" || ping -w5 -c3 "$host2") > /dev/null 2>&1) && return 0 || return 1
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if is_internet ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_internet @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_internet @ $(basename $BASH_SOURCE) : $LINENO${White}"
        fix_network
        if is_internet ; then
            echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_internet @ $(basename $BASH_SOURCE) : $LINENO${White}"
        else
            echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_internet @ $(basename $BASH_SOURCE) : $LINENO${White}"
        fi
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# IS ONLINE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="is_online"
    USAGE="is_online 1->(url)"
    DESCRIPTION=$(localize "IS-ONLINE-DESC")
    NOTES=$(localize "IS-ONLINE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "IS-ONLINE-DESC"  "Check if URL can be Pinged through the Internet."
    localize_info "IS-ONLINE-NOTES" "This pings URL passed in."
    #
    localize_info "IS-ONLINE-INFO" "Checking URL for Internet Connection..."
fi
# -------------------------------------
is_online()
{
    print_info "IS-INTERNET-INFO"
    if ! ((ping -w5 -c3 "$1") > /dev/null 2>&1) ; then
        if ! ((ping -w5 -c3 "$1") > /dev/null 2>&1) ; then
            return 1
        fi
    fi
    return 0
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if is_online "google.com" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_online @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_online @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# -------------------------- Array Functions ----------------------------------
# -----------------------------------------------------------------------------
# ARRAY PUSH {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="array_push"
    USAGE=$(localize "ARRAY-PUSH-USAGE")
    DESCRIPTION=$(localize "ARRAY-PUSH-DESC")
    NOTES=$(localize "ARRAY-PUSH-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "ARRAY-PUSH-USAGE" "array_push 1->(array) 2->(Element)"
    localize_info "ARRAY-PUSH-DESC"  "Push Element into an Array."
    localize_info "ARRAY-PUSH-NOTES" "None."
fi
# -------------------------------------
array_push()
{
	eval "shift; $1+=(\"\$@\")"
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    MyArray=( "1" "2" )
    array_push "MyArray" "3"
    total="${#MyArray[@]}"
    if [[ "$total" -eq 3 ]]; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  array_push @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  array_push @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# REMOVE FROM ARRAY {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="remove_from_array"
    USAGE=$(localize "REMOVE-FROM-ARRAY-USAGE")
    DESCRIPTION=$(localize "REMOVE-FROM-ARRAY-DESC")
    NOTES=$(localize "REMOVE-FROM-ARRAY-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "REMOVE-FROM-ARRAY-USAGE" "remove_from_array 1->(array) 2->(Element)"
    localize_info "REMOVE-FROM-ARRAY-DESC"  "Remove Element from an Array."
    localize_info "REMOVE-FROM-ARRAY-NOTES" "Pass in Array by name 'array'."
    #
    localize_info "REMOVE-FROM-ARRAY-ERROR" "Wrong Parameters passed to remove_from_array"
fi
# -------------------------------------
remove_from_array()
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    # Check to see if its in Array    
    if is_in_array "$1[@]" "$2" ; then
        eval "local -a array=(\${$1[@]})"
        eval "$1=(${array[@]:0:$ARR_INDEX} ${array[@]:$(($ARR_INDEX + 1))})"
        return "$?"
    fi
    return 1
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    MyArray=( "1" "2" "3" )
    if is_in_array "MyArray[@]" "2" ; then
        remove_from_array "MyArray" "2"
    fi
    if ! is_in_array "MyArray[@]" "2" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  remove_from_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  remove_from_array @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# GET INDEX {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="get_index"
    USAGE="get_index 1->(array[@]) 2->(Search)"
    DESCRIPTION=$(localize "GET-INDEX-DESC")
    NOTES=$(localize "GET-INDEX-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "GET-INDEX-DESC"  "Get Index into an Array."
    localize_info "GET-INDEX-NOTES" "Bombs if not found; but finds errors in data; you could ask for data; but if its not in Array; this is a bug in Data not logic."
fi
# -------------------------------------
get_index() 
{
    if [[ "$#" -ne "2" ]]; then echo -e "${BRed}$(gettext -s "WRONG-NUMBER-ARGUMENTS-PASSED-TO") $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO ${White}"; exit 1; fi
    local -a i_array=("${!1}")
    #echo "i_array=${i_array[@]}"
    local -i total="${#i_array[@]}"
    local -i index=0
    for (( index=0; index<${total}; index++ )); do
        if [[ "${i_array[$index]}" = "$2" ]]; then
            echo -n "$[index]"
            return 0
        fi
    done
    write_error "FAILED:only use this if you know the record exist in get_index [$1] [$2]; check  " "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    pause_function "FAILED:only use this if you know the record exist in get_index [$1] [$2] at line $LINENO" 
    exit 1
}    
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    MyArray=( "1" "2" "3" )
    if [[ $(get_index "MyArray[@]" "2") -eq 1 ]]; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  get_index @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  get_index @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
declare -a REMOVED_INDEXES=() 
#
# REMOVE ARRAY DUPLICATES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="remove_array_duplicates"
    USAGE="remove_array_duplicates 1->(Search)"
    DESCRIPTION=$(localize "REMOVE-ARRAY-DUPLICATES-DESC")
    NOTES=$(localize "REMOVE-ARRAY-DUPLICATES-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "REMOVE-ARRAY-DUPLICATES-DESC"  "Remove array duplicates."
    localize_info "REMOVE-ARRAY-DUPLICATES-NOTES" "None."
fi
# -------------------------------------
remove_array_duplicates()
{
    # Test Code
    # MY_ARR=("MY" "MY" "2" "2" "LIST" "LIST" "OK")
    # local -i total=${#MY_ARR[@]}
    # echo ${MY_ARR[@]} # Prints: MY MY 2 2 LIST LIST OK
    # MY_ARR=( $(remove_array_duplicates MY_ARR[@]) )
    # echo ${MY_ARR[@]} # Prints: MY 2 LIST OK    declare -a array=("${!1}")
    # for (( index=0; index<${total}; index++ )); do echo "ARRAY= ${MY_ARR[$index]}"; done # to echo with new line
    local -a array=("${!1}")
    local -i total="${#array[@]}"
    local -a sarray=( "" )
    local -i i=0
    local -i j=0
    local -i y=0
    for (( i=0; i<${total}; i++ )); do
        (( j = i + 1 ))
        while (( j < total )); do
            if [ "${array[$i]}" == "${array[$j]}" ]; then
                break
            fi
            (( j = j + 1 ))
        done
        if [[ "$j" = "$total" ]]; then
            sarray[$y]="${array[$i]}"
            (( y = y + 1 ))
        else
            REMOVED_INDEXES[$[${#REMOVED_INDEXES[@]}]]="$i"
        fi
    done
    # Must echo to fill array
    for element in ${sarray[*]}; do
        echo -e "${element}"
    done
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    OLD_IFS="$IFS"; IFS=$'\n\t'; # Very Important
    MyArray=( "1" "2" "3" "4" "4" "5" "6-8" "6-8" )
    MyArray=( $( remove_array_duplicates "MyArray[@]") )
    total="${#MyArray[@]}"
    if [[ "$total" -eq 6 ]]; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  remove_array_duplicates @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  remove_array_duplicates @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
    IFS="$OLD_IFS"
fi
#}}}
# ----------------------------------------------------------------------------- 
# IS LAST ITEM {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="is_last_item"
    USAGE="is_last_item 1->(array[@]) 2->(search)"
    DESCRIPTION=$(localize "IS-LAST-ITEM-DESC")
    NOTES=$(localize "IS-LAST-ITEM-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "IS-LAST-ITEM-DESC"  "is last item in array."
    localize_info "IS-LAST-ITEM-NOTES" "None."
fi
# -------------------------------------
is_last_item() 
{
    local -a i_array=("${!1}")
    local -i total="${#i_array[@]}"
    local -i index=0
    for (( index=0; index<${total}; index++ )); do
        if [[ "${i_array[$index]}" = "$2" ]]; then
            if [[ "$[index + 1]" -eq "${#i_array[@]}" ]]; then
                return 0 # True
            else
                return 1 # False
            fi
        fi
    done
    return 1
}    
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    MyArray=( "1" "2" "3" "4" "5" "6" )
    if is_last_item "MyArray[@]" "6" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_last_item @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_last_item @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# ----------------------------------------------------------------------------- 
# DATE2STAMP {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="date2stamp"
    USAGE=$(localize "DATE2STAMP-USAGE")
    DESCRIPTION=$(localize "DATE2STAMP-DESC")
    NOTES=$(localize "DATE2STAMP-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "DATE2STAMP-USAGE" "date2stamp 1->(date)"
    localize_info "DATE2STAMP-DESC"  "Convert Date to Datetime stamp."
    localize_info "DATE2STAMP-NOTES" "None."
fi
# -------------------------------------
date2stamp()
{
    date --utc --date "$1" +%s
}
#}}}
# ----------------------------------------------------------------------------- 
# DETECTED VIDEO CARD {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="detected_video_card"
    USAGE="detected_video_card"
    DESCRIPTION=$(localize "DETECTED-VIDEO-CARD-DESC")
    NOTES=$(localize "DETECTED-VIDEO-CARD-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="19 Jan 2013"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "DETECTED-VIDEO-CARD-DESC"  "Detect Video Card."
    localize_info "DETECTED-VIDEO-CARD-NOTES" "Need to add more support for Video Cards, currently it supports: nVidia, Intel, ATI and Vesa."
fi
# -------------------------------------
detected_video_card()
{
    # @FIX Add more Video cards and Options
    #  1        2         3       4     5      6            7
    # "nVidia" "Nouveau" "Intel" "ATI" "Vesa" "Virtualbox" "Skip"
    if (lspci | grep -q 'VGA compatible controller: NVIDIA'); then 
        VIDEO_CARD=1
    elif (lspci | grep -q 'VGA compatible controller: NVIDIA'); then # This will never get set
        VIDEO_CARD=2
    elif (lspci | grep -q 'VGA compatible controller: Intel'); then 
        VIDEO_CARD=3
    elif (lspci | grep -q 'VGA compatible controller: ATI'); then 
        VIDEO_CARD=4
    elif (lspci | grep -q 'VGA compatible controller: Vesa'); then # Don't know if this works
        VIDEO_CARD=5
    elif (lspci | grep -q 'VGA compatible controller: Virtualbox'); then  # This doesn't work, just putting it out there for a better fix, since its just an option and not hardware
        VIDEO_CARD=6
    else
        VIDEO_CARD=7
    fi
}
#}}}
# ----------------------------------------------------------------------------- 
# CLEAR LOGS {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="clear_logs"
    USAGE="clear_logs"
    DESCRIPTION=$(localize "CLEAR-LOGS-DESC")
    NOTES=$(localize "CLEAR-LOGS-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "CLEAR-LOGS-DESC"    "Clear all Log Entries."
    localize_info "CLEAR-LOGS-NOTES"   "None."
    localize_info "CLEAR-LOGS-CLEAR-1" "Clearing Log Files"
    localize_info "CLEAR-LOGS-CLEAR-2" "Creaded Log Folders"
fi
# -------------------------------------
clear_logs()
{
    print_this "CLEAR-LOGS-CLEAR-1" "..."
    make_dir "$LOG_PATH"    "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    make_dir "$MENU_PATH"   "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    make_dir "$CONFIG_PATH" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    print_this "CLEAR-LOGS-CLEAR-2" "..."
    copy_file "${ERROR_LOG}"    "Archive/${ERROR_LOG}.${LOG_DATE_TIME}.log"    "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    copy_file "${ACTIVITY_LOG}" "Archive/${ACTIVITY_LOG}.${LOG_DATE_TIME}.log" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    echo "# Error Log: $SCRIPT_NAME Version: $SCRIPT_VERSION on $DATE_TIME." > "$ERROR_LOG"
    echo "# Log: $SCRIPT_NAME Version: $SCRIPT_VERSION on $DATE_TIME."  > "$ACTIVITY_LOG"
    echo "Logs Cleared"
}
#}}}
# -----------------------------------------------------------------------------
# IS USER {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="is_user"
    USAGE="is_user 1->(USERNAME)"
    DESCRIPTION=$(localize "IS-USER-DESC")
    NOTES=$(localize "IS-USER-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "IS-USER-DESC"  "Checks if USERNAME exist."
    localize_info "IS-USER-NOTES" "None."
fi
# -------------------------------------
is_user()
{
    egrep -i "^$1" /etc/passwd > /dev/null 2>&1
    return "$?"
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if is_user $(whoami) ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_user @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_user @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# ADD USER GROUP {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="add_user_group"
    USAGE="add_user_group 1->(Group Name)"
    DESCRIPTION=$(localize "ADD-USER-GROUP-DESC")
    NOTES=$(localize "ADD-USER-GROUP-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "ADD-USER-GROUP-DESC"  "Add User group."
    localize_info "ADD-USER-GROUP-NOTES" "None."
fi
# -------------------------------------
add_user_group()
{
    USER_GROUPS[${#USER_GROUPS[*]}]="$1"
    local OLD_IFS="$IFS"; IFS=$'\n\t';
    USER_GROUPS=( $( remove_array_duplicates "USER_GROUPS[@]") )
    IFS=$"$OLD_IFS"
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    add_user_group "TestMyAccount"
    if is_in_array "USER_GROUPS[@]" "TestMyAccount" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  add_user_group @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  add_user_group @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# REMOVE USER GROUP {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="add_user_group"
    USAGE=$(localize "REMOVE-USER-GROUP-USAGE")
    DESCRIPTION=$(localize "REMOVE-USER-GROUP-DESC")
    NOTES=$(localize "REMOVE-USER-GROUP-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "REMOVE-USER-GROUP-USAGE" "remove_user_group 1->(Group Name)"
    localize_info "REMOVE-USER-GROUP-DESC"  "Remove User group."
    localize_info "REMOVE-USER-GROUP-NOTES" "None."
fi
# -------------------------------------
remove_user_group()
{
    if is_in_array "USER_GROUPS[@]" "$1" ; then
        remove_from_array "USER_GROUPS" "$1"
    fi
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    add_user_group "TestMyAccount2"
    remove_user_group "TestMyAccount2"
    if ! is_in_array "USER_GROUPS[@]" "TestMyAccount2" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  remove_user_group @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  remove_user_group @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# IS USER IN GROUP {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="is_user_in_group"
    USAGE="is_user_in_group 1->(GroupName)"
    DESCRIPTION=$(localize "IS-USER-IN-GROUP-DESC")
    NOTES=$(localize "IS-USER-IN-GROUP-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "IS-USER-IN-GROUP-DESC"  "is user in group."
    localize_info "IS-USER-IN-GROUP-NOTES" "None."
fi
# -------------------------------------
is_user_in_group()
{
    groups "${USERNAME}" | grep "$1" > /dev/null 2>&1
    return "$?"
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if is_user_in_group $(whoami) ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_user_in_group @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_user_in_group @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# IS GROUP {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="is_group"
    USAGE="is_group 1->(GROUPNAME)"
    DESCRIPTION=$(localize "IS-GROUP-DESC")
    NOTES=$(localize "IS-GROUP-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "IS-GROUP-DESC"  "Is Group."
    localize_info "IS-GROUP-NOTES" "None."
fi
# -------------------------------------
is_group()
{
    egrep -i "^$1" /etc/group > /dev/null 2>&1
    return "$?"
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if is_group "users" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_group @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_group @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# ADD GROUP {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="add_group"
    USAGE="add_group 1->(GroupName)"
    DESCRIPTION=$(localize "ADD-GROUP-DESC")
    NOTES=$(localize "ADD-GROUP-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "ADD-GROUP-DESC"  "Add Group."
    localize_info "ADD-GROUP-NOTES" "None."
    localize_info "ADD-GROUP-OK"    "Added Group"
    localize_info "ADD-GROUP-FAIL"  "Failed to add Group"
fi
# -------------------------------------
add_group()
{
    if ! is_group "$1" ; then
        if groupadd "$1" ; then
            write_log "ADD-GROUP-OK" ": $1 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"    
            return 0
        else
            print_error "ADD-GROUP-FAIL" ": $1 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            write_error "ADD-GROUP-FAIL" ": $1 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"    
            return 1
        fi
    fi
    return 0
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if add_group "testgroup" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  add_group @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  add_group @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# ADD USER 2 GROUP {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="add_user_2_group"
    USAGE="add_user_2_group 1->(GroupName)"
    DESCRIPTION=$(localize "ADD-USER-2-GROUP-DESC")
    NOTES=$(localize "ADD-USER-2-GROUP-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "ADD-USER-2-GROUP-DESC"  "Add User to Group."
    localize_info "ADD-USER-2-GROUP-NOTES" "None."
    #
    localize_info "ADD-USER-2-GROUP-ERROR" "Error in adding User to group"
fi
# -------------------------------------
add_user_2_group()
{
    if ! is_user_in_group "$1" ; then
        if gpasswd -a "${USERNAME}" "$1" ; then
            write_log "add_user_2_group $1" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"    
            return 0
        else
            write_error "ADD-USER-2-GROUP-ERROR" ": gpasswd -a ${USERNAME} $1 -> $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"    
            return 1
        fi
    fi
    return 0
}
# -------------------------------------
if [[ "$RUN_TEST" -eq 1 ]]; then
    if add_user_2_group "testgroup" ; then
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  add_user_2_group @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  add_user_2_group @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
#}}}
# -----------------------------------------------------------------------------
# SET DEBUGGING MODE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="set_debugging_mode"
    USAGE=$(localize "SET-DEBUGGING-MODE-USAGE")
    DESCRIPTION=$(localize "SET-DEBUGGING-MODE-DESC")
    NOTES=$(localize "SET-DEBUGGING-MODE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "SET-DEBUGGING-MODE-USAGE" "set_debugging_mode 1->(1=Boot, 2=Live) 2->(Debugging Information)"
    localize_info "SET-DEBUGGING-MODE-DESC"  "Set Debugging Mode: also checks for Internet Connection."
    localize_info "SET-DEBUGGING-MODE-NOTES" "Fill try to Repair Internet Connection. Only sets Debugging switch if DEBUGGING is set to 1."
    #
    localize_info "SET-DEBUGGING-MODE-TITLE"         "Starting setup..."
    localize_info "SET-DEBUGGING-MODE-INTERNET-UP"   "Internet is Up!"
    localize_info "SET-DEBUGGING-MODE-TRIED-TO-FIX"  "I tried to fix Network, I will test it again, if it fails, first try to re-run this script over, if that fails, try Network Troubleshooting."
    localize_info "SET-DEBUGGING-MODE-TRY-AGAIN"     "trying again in 13 seconds..."
    localize_info "SET-DEBUGGING-MODE-INTERNET-DOWN" "Internet is Down: Internet is Down, this script requires an Internet Connection, fix and retry; try Network Troubleshooting; first try to rerun this script, I did try to fix this. Select Install with No Internet Connection option."
    localize_info "SET-DEBUGGING-MODE-NO-INTERNET"   "No Internet Install Set; if it fails; you must establish an Internet connection first; try Network Troubleshooting."
    localize_info "SET-DEBUGGING-MODE-WARN-1"        "Debug Mode will insert a Pause Function at critical functions and give you some information about how the script is running, it also may set other variables and run more test."
    localize_info "SET-DEBUGGING-MODE-WARN-2"        "Debugging is set on, if set -o nounset or set -u, you may get unbound errors that need to be fixed."
    localize_info "BOOT-MODE-DETECTED"               "Boot Mode Detected."
    localize_info "LIVE-MODE-DETECTED"               "Live Mode Detected."
fi
# -------------------------------------
set_debugging_mode()
{
    if [[ "$SET_DEBUGGING" -eq 0 ]]; then
        SET_DEBUGGING=1 # So we only run this once.
    else
        return 0        
    fi
    print_title "SET-DEBUGGING-MODE-TITLE"
    print_info "$TEXT_SCRIPT_ID"
    if is_internet ; then
        print_info "SET-DEBUGGING-MODE-INTERNET-UP"
    else
        fix_network
        print_error "SET-DEBUGGING-MODE-TRIED-TO-FIX"
        print_this "SET-DEBUGGING-MODE-TRY-AGAIN"
        sleep 13
        if ! is_internet ; then
            write_error "SET-DEBUGGING-MODE-INTERNET-DOWN" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
            print_error "SET-DEBUGGING-MODE-INTERNET-DOWN" 
            if [[ "$INSTALL_NO_INTERNET" -eq 0 ]]; then
                INSTALL_NO_INTERNET=1
                print_error "SET-DEBUGGING-MODE-NO-INTERNET"
            fi
            pause_function "set_debugging_mode $1 : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        fi
    fi
    if [[ "$DEBUGGING" -eq 1 ]]; then
        #set -u
        set -o nounset 
        print_error "SET-DEBUGGING-MODE-WARN-1"
        print_error "SET-DEBUGGING-MODE-WARN-2"
        pause_function "set_debugging_mode $1 : $FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
    fi
}
#}}}
# -----------------------------------------------------------------------------
# GET COUNTRY CODES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="country_list"
    USAGE="country_list"
    DESCRIPTION=$(localize "GET-COUNTRY-CODES-DESC")
    NOTES=$(localize "GET-COUNTRY-CODES-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "GET-COUNTRY-CODES-DESC"  "country list."
    localize_info "GET-COUNTRY-CODES-NOTES" "Sets COUNTRY."
    #
    localize_info "GET-COUNTRY-CODES-SELECT" "Select your Country:"
fi
# -------------------------------------
country_list()
{
    #`reflector --list-countries | sed 's/[0-9]//g' | sed 's/^/"/g' | sed 's/,.*//g' | sed 's/ *$//g'  | sed 's/$/"/g' | sed -e :a -e '$!N; s/\n/ /; ta'`
    PS3="$prompt1"
    print_info "GET-COUNTRY-CODES-SELECT"
    select COUNTRY in "${COUNTRIES[@]}"; do
        if contains_element "$COUNTRY" "${COUNTRIES[@]}"; then
          break
        else
          invalid_option "$REPLY"
        fi
    done
}
#}}}
# -----------------------------------------------------------------------------
# GET COUNTRY CODES {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="get_country_codes"
    USAGE="get_country_codes"
    DESCRIPTION=$(localize "GET-COUNTRY-CODES-DESC")
    NOTES=$(localize "GET-COUNTRY-CODES-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "GET-COUNTRY-CODES-DESC"    "Get Country Code and set Counter."
    localize_info "GET-COUNTRY-CODES-NOTES"   "None."
    #
    localize_info "GET-COUNTRY-CODES-WARN"    "You must enter your Country correctly, no validation is done!"
    localize_info "GET-COUNTRY-CODES-INPUT"   "Country Code for Mirror List: (US) "
    localize_info "GET-COUNTRY-CODES-TITLE"   "Country Code for Mirror List"
    #
    localize_info "GET-COUNTRY-CODES-INFO-1"  "Australia     = AU | Belarus       = BY | Belgium       = BE"
    localize_info "GET-COUNTRY-CODES-INFO-2"  "Brazil        = BR | Bulgaria      = BG | Canada        = CA"
    localize_info "GET-COUNTRY-CODES-INFO-3"  "Chile         = CL | China         = CN | Colombia      = CO"
    localize_info "GET-COUNTRY-CODES-INFO-4"  "Czech Repub   = CZ | Denmark       = DK | Estonia       = EE"
    localize_info "GET-COUNTRY-CODES-INFO-5"  "Finland       = FI | France        = FR | Germany       = DE"
    localize_info "GET-COUNTRY-CODES-INFO-6"  "Greece        = GR | Hungary       = HU | India         = IN"
    localize_info "GET-COUNTRY-CODES-INFO-7"  "Ireland       = IE | Israel        = IL | Italy         = IT"
    localize_info "GET-COUNTRY-CODES-INFO-8"  "Japan         = JP | Kazakhstan    = KZ | Korea         = KR"
    localize_info "GET-COUNTRY-CODES-INFO-9"  "Macedonia     = MK | Netherlands   = NL | New Caledonia = NC"
    localize_info "GET-COUNTRY-CODES-INFO-10" "New Zealand   = NZ | Norway        = NO | Poland        = PL"
    localize_info "GET-COUNTRY-CODES-INFO-11" "Portugal      = PT | Romania       = RO | Russian Fed   = RU"
    localize_info "GET-COUNTRY-CODES-INFO-12" "Serbia        = RS | Singapore     = SG | Slovakia      = SK"
    localize_info "GET-COUNTRY-CODES-INFO-13" "South Africa  = ZA | Spain         = ES | Sri Lanka     = LK"
    localize_info "GET-COUNTRY-CODES-INFO-14" "Sweden        = SE | Switzerland   = CH | Taiwan        = TW"
    localize_info "GET-COUNTRY-CODES-INFO-15" "Ukraine       = UA | United King   = GB | United States = US"
    localize_info "GET-COUNTRY-CODES-INFO-16" "Uzbekistan    = UZ | Viet Nam = VN"
fi
# -------------------------------------
get_country_codes() 
{
    # I pull the code from Locale, so it should always be right, so no need for a menu; default should work.
    print_title "GET-COUNTRY-CODES-TITLE" " - https://www.archlinux.org/mirrorlist/"
    print_this  "GET-COUNTRY-CODES-INFO-1"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-2"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-3"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-4"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-5"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-6"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-7"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-8"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-9"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-10"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-11"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-12"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-13"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-14"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-15"
    print_line
    print_this  "GET-COUNTRY-CODES-INFO-16"
    print_line
    print_error "GET-COUNTRY-CODES-WARN"
    #
    Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
    read_input_default "GET-COUNTRY-CODES-INPUT" "${LOCALE#*_}"
    BYPASS="$Old_BYPASS" # Restore Bypass
    COUNTRY_CODE=`echo "$OPTION" | tr '[:lower:]' '[:upper:]'`  # Upper case only
    COUNTRY="${COUNTRIES[$(get_index "COUNTRY_CODES[@]" "$COUNTRY_CODE")]}"
}   
#}}}
# -----------------------------------------------------------------------------
# GET COUNTRY CODE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="get_country_code"
    USAGE="get_country_code"
    DESCRIPTION=$(localize "GET-COUNTRY-CODE-DESC")
    NOTES=$(localize "GET-COUNTRY-CODE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "GET-COUNTRY-CODE-DESC"    "Get Country and Country Code."
    localize_info "GET-COUNTRY-CODE-NOTES"   "Localized."
    #
    localize_info "GET-COUNTRY-CODE-CONFIRM" "Confirm Country Code"
fi
# -------------------------------------
get_country_code() 
{
    YN_OPTION=0 
    Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
    while [[ $YN_OPTION -ne 1 ]]; do
        get_country_codes
        read_input_yn "GET-COUNTRY-CODE-CONFIRM" "$COUNTRY_CODE" 1 # Returns YN_OPTION
    done
    BYPASS="$Old_BYPASS" # Restore Bypass
    OPTION="$COUNTRY_CODE"
}   
#}}}
# -----------------------------------------------------------------------------
# GET ROOT PASSWORD {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="get_root_password"
    USAGE="get_root_password"
    DESCRIPTION=$(localize "GET-ROOT-PASSWORD-DESC")
    NOTES=$(localize "GET-ROOT-PASSWORD-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "GET-ROOT-PASSWORD-DESC"   "Get root password."
    localize_info "GET-ROOT-PASSWORD-NOTES"  "This shows the password on screen; not very secure, but its used so you can see the password, you do not want a mistake putting in passwords."
    #
    localize_info "GET-ROOT-PASSWORD-TITLE"  "root"
    localize_info "GET-ROOT-PASSWORD-INFO-1" "No Special Characters, until I figure out how to do this."
    localize_info "GET-ROOT-PASSWORD-INFO-2" "Enter Root Password."
    localize_info "GET-ROOT-PASSWORD-VD"     "root Password"
    localize_info "GET-ROOT-PASSWORD-INFO-3" "Root Password is Set."
fi
# -------------------------------------
get_root_password()
{
    # @FIX Special Characters: How to embed ! $ into a variable, then to disk so a pipe can echo it; tried single tic '!' and escape \!, get error ! processes not found
    print_title "GET-ROOT-PASSWORD-TITLE" " - https://wiki.archlinux.org/index.php/Users_and_Groups"
    print_info  "GET-ROOT-PASSWORD-INFO-1"
    print_info  "GET-ROOT-PASSWORD-INFO-2"
    Old_BYPASS="$BYPASS"; BYPASS=0;
    verify_input_data "GET-ROOT-PASSWORD-VD" 1
    ROOTPASSWD="$OPTION"
    BYPASS="$Old_BYPASS"
    print_title "GET-ROOT-PASSWORD-TITLE" "https://wiki.archlinux.org/index.php/Users_and_Groups"
    print_info  "GET-ROOT-PASSWORD-INFO-3"
    # @FIX check for empty name
}
#}}}
# -----------------------------------------------------------------------------
# GET USER NAME {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="get_user_name"
    USAGE="get_user_name"
    DESCRIPTION=$(localize "GET-USER-NAME-DESC")
    NOTES=$(localize "GET-USER-NAME-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "GET-USER-NAME-DESC"   "Get User Name."
    localize_info "GET-USER-NAME-NOTES"  "Sets USERNAME."
    #
    localize_info "GET-USER-NAME-TITLE"  "User"
    localize_info "GET-USER-NAME-INFO-1" "No Special Characters, until I figure out how to do this."
    localize_info "GET-USER-NAME-INFO-2" "Enter User Name."
    localize_info "GET-USER-NAME-VD"     "User Name"
fi
# -------------------------------------
get_user_name()
{
    # @FIX Special Characters: How to embed ! $ into a variable, then to disk so a pipe can echo it; tried single tic '!' and escape \!, get error ! processes not found
    print_title "GET-USER-NAME-TITLE" " - https://wiki.archlinux.org/index.php/Users_and_Groups"
    print_info  "GET-USER-NAME-INFO-1"
    print_info  "GET-USER-NAME-INFO-2"
    Old_BYPASS="$BYPASS"; BYPASS=0;
    verify_input_default_data "GET-USER-NAME-VD" "${USERNAME}" 1
    USERNAME="$OPTION"
    BYPASS="$Old_BYPASS"
    return 0
}
#}}}
# -----------------------------------------------------------------------------
# GET USER PASSWORD {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="get_user_password"
    USAGE="get_user_password"
    DESCRIPTION=$(localize "GET-USER-PASSWORD-DESC")
    NOTES=$(localize "GET-USER-PASSWORD-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "GET-USER-PASSWORD-DESC"   "get user password."
    localize_info "GET-USER-PASSWORD-NOTES"  "Password in clear text."
    #
    localize_info "GET-USER-PASSWORD-TITLE"  "User"
    localize_info "GET-USER-PASSWORD-INFO-1" "No Special Characters, until I figure out how to do this."
    localize_info "GET-USER-PASSWORD-INFO-2" "Enter User Password for"
    localize_info "GET-USER-PASSWORD-VD"     "User Password"
    localize_info "GET-USER-PASSWORD-INFO-3" "User Name and Password is Set."
fi
# -------------------------------------
get_user_password()
{
    print_title "GET-USER-PASSWORD-TITLE" " - https://wiki.archlinux.org/index.php/Users_and_Groups"
    print_info  "GET-USER-PASSWORD-INFO-1"
    print_info  "GET-USER-PASSWORD-INFO-2" ": ${USERNAME}"
    Old_BYPASS="$BYPASS"; BYPASS=0;
    verify_input_data "GET-USER-PASSWORD-VD" 1
    USERPASSWD="$OPTION"
    BYPASS="$Old_BYPASS"
    print_title "GET-USER-PASSWORD-TITLE" "https://wiki.archlinux.org/index.php/Users_and_Groups"
    print_info  "GET-USER-PASSWORD-INFO-3"
    # @FIX check for empty name
}
#}}}
# -----------------------------------------------------------------------------
# GET LOCALE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="get_locale"
    USAGE="get_locale"
    DESCRIPTION=$(localize "GET-LOCALE-DESC")
    NOTES=$(localize "GET-LOCALE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "GET-LOCALE-DESC"     "Get Locale."
    localize_info "GET-LOCALE-NOTES"    "Used to get a Locale."
    #
    localize_info "GET-LOCALE-TITLE"    "LOCALE"
    localize_info "GET-LOCALE-INFO-1"   "Locales are used in Linux to define which language the user uses."
    localize_info "GET-LOCALE-INFO-2"   "As the locales define the character sets being used as well, setting up the correct locale is especially important if the language contains non-ASCII characters."
    localize_info "GET-LOCALE-INFO-3"   "We can only initialize those Locales that are Available, if not in list, Install Language and rerun script."
    localize_info "GET-LOCALE-SELECT"   "Select your Language Locale:"
    localize_info "GET-LOCALE-TITLE-2"  "LANGUAGE/LOCALE"
    localize_info "GET-LOCALE-INFO-4"   "Locales are used in Linux to define which language the user uses."
    localize_info "GET-LOCALE-INFO-5"   "As the locales define the character sets being used as well, setting up the correct locale is especially important if the language contains non-ASCII characters."
    localize_info "GET-LOCALE-INFO-6"   "We can only initialize those Locales that are Available, if not in list, Install Language and rerun script."
    localize_info "GET-LOCALE-INFO-7"   "First list shows all Available Languages, if yours is not in list choose No, then a full list will appear."
    localize_info "GET-LOCALE-INFO-8"   "Pick your Primary Language first, then you have an option to select as many languages as you wish."
    localize_info "GET-LOCALE-CONFIRM"  "Confirm Language Locale"
    localize_info "GET-LOCALE-DEFAULT"  "Use Default System Language" 
    localize_info "GET-LOCALE-ADD-MORE" "Add more Locales"
    localize_info "GET-LOCALE-EDIT"     "Edit system language (ex: en_US): "
fi
# -------------------------------------
get_locale()
{
    # -------------------------------------
    # GET LOCALES LIST {{{
    get_locales_list()
    {
        print_title "GET-LOCALE-TITLE" " - https://wiki.archlinux.org/index.php/Locale"
        print_info  "GET-LOCALE-INFO-1"
        print_info  "GET-LOCALE-INFO-2"
        print_info  "GET-LOCALE-INFO-3"
        # Another way to show all available, lots of work
        # @FIX create Localized po files for Localization
        # mkdir {af,sq,ar,eu,be,bs,bg,ca,hr,zh_CN,zh_TW,cs,da,en,et,fa,ph,fi,fr_FR,fr_CH,fr_BE,fr_CA,ga,gl,ka,de,el,gu,he,hi,hu,is,id,it,ja,kn,km,ko,lo,lt,lv,ml,ms,mi,mn,no,pl,pt_PT,pt_BR,ro,ru,mi,sr,sk,sl,so,es,sv,tl,ta,th,mi_NZ,tr,uk,vi}
        # @FIX do I need to localize Locale
        LOCALE_LANG=("Afrikaans" "Albanian" "Arabic" "Basque" "Belarusian" "Bosnian" "Bulgarian" "Catalan" "Croatian" "Chinese (Simplified)" "Chinese (Traditional)" "Czech" "Danish" "Dutch" "English" "Estonian" "Farsi" "Filipino" "Finnish" "French(FR)" "French (CH)" "French (BE)" "French (CA)" "Gaelic" "Gallego" "Georgian" "German" "Greek" "Gujarati" "Hebrew" "Hindi" "Hungarian" "Icelandic" "Indonesian" "Italian" "Japanese" "Kannada" "Khmer" "Korean" "Lao" "Lithuanian" "Latvian" "Malayalam" "Malaysian" "Maori" "Mongolian" "Norwegian" "Polish" "Portuguese" "Portuguese (Brazil)" "Romanian" "Russian" "Samoan" "Serbian" "Slovak" "Slovenian" "Somali" "Spanish" "Swedish" "Tagalog" "Tamil" "Thai" "Tongan" "Turkish" "Ukrainian" "Vietnamese");
        LOCALE_CODES=("af_ZA" "sq_AL" "ar_SA" "eu_ES" "be_BY" "bs_BA" "bg_BG" "ca_ES" "hr_HR" "zh_CN" "zh_TW" "cs_CZ" "da_DK" "nl_NL" "en_US" "et_EE" "fa_IR" "ph_PH" "fi_FI" "fr_FR" "fr_CH" "fr_BE" "fr_CA" "ga" "gl_ES" "ka_GE" "de_DE" "el_GR" "gu" "he_IL" "hi_IN" "hu" "is_IS" "id_ID" "it_IT" "ja_JP" "kn_IN" "km_KH" "ko_KR" "lo_LA" "lt_LT" "lv" "ml_IN" "ms_MY" "mi_NZ" "no_NO" "pl" "pt_PT." "pt_BR" "ro_RO" "ru_RU" "mi_NZ" "sr_CS" "sk_SK" "sl_SI" "so_SO" "es_ES" "sv_SE" "tl" "ta_IN" "th_TH" "mi_NZ" "tr_TR" "uk_UA" "vi_VN");
        LOCALE_LANG[$[${#LOCALE_LANG[@]}]]="Not-in-List" # No Spaces
        PS3="$prompt1"
        echo "GET-LOCALE-SELECT"
        select LOCALE in "${LOCALE_LANG[@]}"; do
            if contains_element "$LOCALE" ${LOCALE_LANG[@]}; then
                is_last_item "LOCALE_LANG[@]" "$LOCALE"
                if [[ "$?" -ne 1 ]]; then
                    LOCALE="${LOCALE_CODES[$(get_index "LOCALE_LANG[@]" "$LOCALE")]}"
                    return 0 # True
                else
                    return 1 # False
                fi
                break
            else
                invalid_option "$LOCALE"
            fi
        done
    }
    #}}}    
    # -------------------------------------
    #LANGUAGE SELECTOR {{{
    language_selector()
    {
        #       
        print_title "GET-LOCALE-TITLE-2" " - https://wiki.archlinux.org/index.php/Locale"
        print_info  "GET-LOCALE-INFO-4"
        print_info  "GET-LOCALE-INFO-5"
        print_info  "GET-LOCALE-INFO-6"
        print_info  "GET-LOCALE-INFO-7"
        print_info  "GET-LOCALE-INFO-8"
        #
        read_input_yn "GET-LOCALE-DEFAULT" "${LANGUAGE}" 1 # Returns YN_OPTION
        if [[ "$YN_OPTION" -eq 1 ]]; then
            LOCALE="$LANGUAGE"
            set_language "$LOCALE"
        else
            get_locales_list
            read_input_default "GET-LOCALE-EDIT" "$LOCALE"
            set_language "$LOCALE"
        fi
    }
    #}}}
    #
    LOCALE_ARRAY=( "" )
    Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
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
        read_input_yn "GET-LOCALE-ADD-MORE" " " 0 # Returns YN_OPTION
        if [[ "$YN_OPTION" -eq 1 ]]; then
            get_locales_list
            read_input_default "GET-LOCALE-EDIT" "$LOCALE"
            read_input_yn "GET-LOCALE-CONFIRM" "$LOCALE" 1
            if [[ "$YN_OPTION" -eq 0 ]]; then
               LOCALE="NONE"
            fi
            YN_OPTION=0
        else
            YN_OPTION=1
            break;
        fi
    done
    BYPASS="$Old_BYPASS" # Restore Bypass
}    
#}}}
# -----------------------------------------------------------------------------
# YES NO {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="yes_no"
    USAGE="yes_no 1->(0=no, 1=yes)"
    DESCRIPTION=$(localize "YES-NO-DESC")
    NOTES=$(localize "YES-NO-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "YES-NO-DESC"  "Convert Digital to Analog."
    localize_info "YES-NO-NOTES" "Localized. Used to Show simple settings."
    #
    localize_info "YES" "Yes"
    localize_info "NO"  "No" 
fi
# -------------------------------------
yes_no()
{
    if [[ "$1" -eq 1 ]]; then
        localize "YES" ""
    else
        localize "NO" ""
    fi
}
#}}}
# -----------------------------------------------------------------------------
# SELECT CREATE USER {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="select_create_user"
    USAGE="select_create_user"
    DESCRIPTION=$(localize "SELECT-CREATE-USER-DESC")
    NOTES=$(localize "SELECT-CREATE-USER-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "SELECT-CREATE-USER-DESC"  "select user."
    localize_info "SELECT-CREATE-USER-NOTES" "None."
    #
    localize_info "SUDO-WARNING" "WARNING: THE SELECTED USER MUST HAVE SUDO PRIVILEGES"
    localize_info "Create-new-user" "Create new user"
    localize_info "SELECT-CREATE-USER-AVAILABLE-USERS" "Available Users: "
fi
# -------------------------------------
select_create_user()
{
    print_title "SELECT/CREATE USER ACCOUNT - https://wiki.archlinux.org/index.php/Users_and_Groups"
    users=(`cat /etc/passwd | grep "/home" | cut -d: -f1`);
    PS3="$prompt1"
    print_info "SELECT-CREATE-USER-AVAILABLE-USERS"
    if [[ "$(( ${#users[@]} ))" -gt 0 ]]; then
        print_error localize "SUDO-WARNING" ""
    else
        echo ""
    fi
    TEMP=$(localize "Create-new-user" "")
    select OPT in "${users[@]}" "$TEMP"; do
        if [[ "$OPT" == "$TEMP" ]]; then
            create_new_user
            break
        elif contains_element "$OPT" "${users[@]}"; then
            USERNAME=$OPT
            break
        else
            invalid_option "$OPT"
        fi
    done
    [[ ! -f "/home/${USERNAME}/.bashrc" ]] && configure_user_account;
}
#}}}
# -----------------------------------------------------------------------------
# RESTART INTERNET {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="restart_internet"
    USAGE="restart_internet"
    DESCRIPTION=$(localize "RESTART-INTERNET-DESC")
    NOTES=$(localize "RESTART-INTERNET-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "RESTART-INTERNET-DESC"  "Restart Internet."
    localize_info "RESTART-INTERNET-NOTES" "Assumes system.d; uses systemctl restart; needs generic functions for other then Arch Linux calls."
fi
# -------------------------------------
restart_internet()
{
    # @FIX Works in Arch Linux; if you make this Generic; make a case for it
    if [[ "$NETWORK_MANAGER" == "networkmanager" ]]; then
        systemctl restart NetworkManager.service
    elif [[ "$NETWORK_MANAGER" == "wicd" ]]; then
        systemctl restart wicd.service
    fi
}
#}}}
# -----------------------------------------------------------------------------
# FIX NETWORK {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="fix_network"
    USAGE="fix_network"
    DESCRIPTION=$(localize "FIX-NETWORK-DESC")
    NOTES=$(localize "FIX-NETWORK-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "FIX-NETWORK-DESC"  "Fix Network."
    localize_info "FIX-NETWORK-NOTES" "None."
    #
    localize_info "FIX-NETWORK-NETWORKMANAGER" "Restarting networkmanager via systemctl..."
    localize_info "FIX-NETWORK-WICD"           "Restarting wicd via systemctl..."
    localize_info "FIX-NETWORK-TRIED-TO-FIX"   "Tried to fix network connection; you may have to run this script again."
fi
# -------------------------------------
fix_network()
{
    if [[ "$NETWORK_MANAGER" == "networkmanager" ]]; then
        # networkmanager
        # Internet is down; no use trying to install software
        #if ! check_package networkmanager ; then
        #    if [[ "$KDE_INSTALLED" -eq 1 ]]; then
        #        package_install "networkmanager kdeplasma-applets-networkmanagement" "INSTALL-NETWORKMANAGER-KDE"
        #        if [[ "$MATE_INSTALLED" -eq 1 ]]; then
        #            package_install "network-manager-applet" "INSTALL-NETWORKMANAGER-MATE"
        #        fi
        #    else
        #        package_install "networkmanager network-manager-applet" "INSTALL-NETWORKMANAGER-OTHER"
        #    fi
        #    package_install "networkmanager-dispatcher-ntpd" "INSTALL-NETWORKMANAGER"
        #fi
        #add_group "networkmanager"
        #add_user_2_group "networkmanager" 
        print_info "FIX-NETWORK-NETWORKMANAGER"
        systemctl enable NetworkManager.service
        systemctl start NetworkManager.service
    elif [[ "$NETWORK_MANAGER" == "wicd" ]]; then
        #if ! check_package networkmanager ; then
        #    if [[ "$KDE" -eq 1 ]]; then
        #        aur_package_install "wicd wicd-kde" "AUR-INSTALL-NETWORKMANAGER-KDE"
        #    else
        #        package_install "wicd wicd-gtk" "INSTALL-NETWORKMANAGER-GTK"
        #    fi
        #fi                    
        print_info "FIX-NETWORK-WICD"
        systemctl enable wicd.service
        systemctl start wicd.service
        wicd-client
    fi
    # @FIX More testing and repairing
    sleep 20
    if [[ "$INSTALL_NO_INTERNET" -eq 0 ]]; then
        if ! is_internet ; then
            sleep 10
            if ! is_internet ; then
                print_error "FIX-NETWORK-TRIED-TO-FIX" # if you see this; 20 seconds wasn't long enough, add another 10 for a full half minute
                return 1
            fi
        fi
    fi
    return 0
}
#}}}
# -----------------------------------------------------------------------------
# NETWORK TROUBLESHOOTING {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="network_troubleshooting"
    USAGE="network_troubleshooting"
    DESCRIPTION=$(localize "NETWORK-TROUBLESHOOTING-DESC")
    NOTES=$(localize "NETWORK-TROUBLESHOOTING-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "NETWORK-TROUBLESHOOTING-DESC"    "Network Troubleshooting."
    localize_info "NETWORK-TROUBLESHOOTING-NOTES"   "None."
    #
    localize_info "NETWORK-TROUBLESHOOTING-TITLE"   "Network Troubleshooting"
    localize_info "NETWORK-TROUBLESHOOTING-INFO-1"  "Network Debugging"
    localize_info "NETWORK-TROUBLESHOOTING-INFO-2"  "Networkmanager: install and start, this is always the best way to start troubleshooting."
    localize_info "NETWORK-TROUBLESHOOTING-INFO-3"  "Disk Resolv: Edit/Review namerservers.txt on disk, then copy it to local disk."
    localize_info "NETWORK-TROUBLESHOOTING-INFO-4"  "Local Resolv:Edit/Review local /etc/resolv.conf"
    localize_info "NETWORK-TROUBLESHOOTING-INFO-5"  "Identify which network interfaces"
    localize_info "NETWORK-TROUBLESHOOTING-INFO-6"  "Link status: "
    localize_info "NETWORK-TROUBLESHOOTING-INFO-7"  "IP Address: "
    localize_info "NETWORK-TROUBLESHOOTING-INFO-8"  "Ping: "
    localize_info "NETWORK-TROUBLESHOOTING-INFO-9"  "Devices: Show all ethx that are active"
    localize_info "NETWORK-TROUBLESHOOTING-INFO-10" "Show Users: "
    localize_info "NETWORK-TROUBLESHOOTING-INFO-11" "Static IP: "
    localize_info "NETWORK-TROUBLESHOOTING-INFO-12" "Gateway: "
    localize_info "NETWORK-TROUBLESHOOTING-INFO-13" "Quit"
    localize_info "NETWORK-TROUBLESHOOTING-INFO-14" "Identify"
    localize_info "NETWORK-TROUBLESHOOTING-INFO-15" "Link status"
    localize_info "NETWORK-TROUBLESHOOTING-INFO-16" "Network Debugging"
    localize_info "NETWORK-TROUBLESHOOTING-RD-1"    "Enter IP address (192.168.1.2) "
    localize_info "NETWORK-TROUBLESHOOTING-RD-2"    "Enter IP Mask (255.255.255.0 = 24) "
    localize_info "NETWORK-TROUBLESHOOTING-RD-3"    "Enter IP address for Gateway (192.168.1.1) "
    localize_info "NETWORK-TROUBLESHOOTING-SELECT"  "Select an Option:"
    localize_info "NETWORK-TROUBLESHOOTING-NIC"     "Select a NIC:"
fi
# -------------------------------------
network_troubleshooting()
{
    get_network_devices
    load_software
    while [[ 1 ]]; do
        print_title "NETWORK-TROUBLESHOOTING-TITLE" " - https://wiki.archlinux.org/index.php/Network_Debugging"
        print_info  "NETWORK-TROUBLESHOOTING-INFO-1"
        print_info  "NETWORK-TROUBLESHOOTING-INFO-2"
        print_info  "NETWORK-TROUBLESHOOTING-INFO-3"
        print_info  "NETWORK-TROUBLESHOOTING-INFO-4"
        print_info  "NETWORK-TROUBLESHOOTING-INFO-5"
        print_info  "NETWORK-TROUBLESHOOTING-INFO-6"
        print_info  "NETWORK-TROUBLESHOOTING-INFO-7"
        print_info  "NETWORK-TROUBLESHOOTING-INFO-8"
        print_info  "NETWORK-TROUBLESHOOTING-INFO-9"
        print_info  "NETWORK-TROUBLESHOOTING-INFO-10"
        print_info  "NETWORK-TROUBLESHOOTING-INFO-11"
        print_info  "NETWORK-TROUBLESHOOTING-INFO-12"
        echo ""
        print_info  "NETWORK-TROUBLESHOOTING-INFO-13"
        #                   1              2              3             4          5         6         7          8         9         10           11        12
        NETWORK_TROUBLE=("Networkmanager" "Disk Resolv" "Local Resolv" "Identify" "Link" "IP address" "Ping"  "Devices" "Show Users" "Static IP" "Gateway" "Quit");
        PS3="$prompt1"
        print_this "NETWORK-TROUBLESHOOTING-SELECT"
        echo ""
        select OPT in "${NETWORK_TROUBLE[@]}"; do
            case "$REPLY" in
                1)
                    fix_network
                    pause_function "network_troubleshooting $LINENO"
                    break
                    ;;
                2)
                    # Disk Resolv
                    custom_nameservers   
                    cat /etc/resolv.conf      
                    pause_function "network_troubleshooting $LINENO"
                    break
                    ;;
                3)
                    # Local Resolv
                    $EDITOR /etc/resolv.conf     
                    break
                    ;;
                4)
                    # Identify
                    print_info "NETWORK-TROUBLESHOOTING-INFO-14" ": ip a "
                    ip a
                    pause_function "network_troubleshooting $LINENO"
                    break
                    ;;
                5)
                    # Link
                    print_info "NETWORK-TROUBLESHOOTING-INFO-15" ": ip link show dev eth0"
                    if [[ "$ETH0_ACTIVE" -eq 1 ]]; then
                        ip link show dev eth0
                    fi
                    if [[ "$ETH1_ACTIVE" -eq 1 ]]; then
                        ip link show dev eth1
                    fi
                    if [[ "$ETH2_ACTIVE" -eq 1 ]]; then
                        ip link show dev eth2
                    fi
                    pause_function "network_troubleshooting $LINENO"
                    break
                    ;;
                6)
                    # IP address
                    print_info "NETWORK-TROUBLESHOOTING-INFO-15" ": ip addr show dev eth0"
                    if [[ "$ETH0_ACTIVE" -eq 1 ]]; then
                        ip addr show dev eth0
                    fi
                    if [[ "$ETH1_ACTIVE" -eq 1 ]]; then
                        ip addr show dev eth1
                    fi
                    if [[ "$ETH2_ACTIVE" -eq 1 ]]; then
                        ip addr show dev eth2
                    fi
                    pause_function "network_troubleshooting $LINENO"
                    break
                    ;;
                7)
                    # Ping
                    ping -c 3 www.google.com
                    pause_function "network_troubleshooting $LINENO"
                    break
                    ;;
                8)
                    # Devices
                    get_network_devices
                    pause_function "network_troubleshooting $LINENO"
                    break
                    ;;
                9)
                    # Show Users
                    show_users
                    pause_function "network_troubleshooting $LINENO"
                    break
                    ;;
               10)
                    print_title "NETWORK-TROUBLESHOOTING-TITLE" " - https://wiki.archlinux.org/index.php/Network_Debugging"
                    print_info  "NETWORK-TROUBLESHOOTING-INFO-16"
                    # Add Static IP address
                    PS3="$prompt1"
                    print_this "NETWORK-TROUBLESHOOTING-NIC"
                    echo ""
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
                    Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
                    read_input_data "NETWORK-TROUBLESHOOTING-RD-1" # Enter IP Address
                    IP_ADDRESS="$OPTION"
                    read_input_data "NETWORK-TROUBLESHOOTING-RD-2"
                    BYPASS="$Old_BYPASS" # Restore Bypass
                    IP_MASK="$OPTION"
                    ip addr add "${IP_ADDRESS}/${IP_MASK}" dev "$NIC_DEV"
                    pause_function "network_troubleshooting $LINENO"
                    break
                    ;;
                    
               11)
                    # Add Static Gateway
                    Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
                    read_input_data "NETWORK-TROUBLESHOOTING-RD-3"
                    BYPASS="$Old_BYPASS" # Restore Bypass
                    IP_ADDRESS="$OPTION"
                    ip route add default via "$IP_ADDRESS"
                    pause_function "network_troubleshooting $LINENO"
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
#}}}
# -----------------------------------------------------------------------------
# GET KEYBOARD LAYOUT {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="get_keyboard_layout"
    USAGE="get_keyboard_layout"
    DESCRIPTION=$(localize "GET-KEYBOARD-LAYOUT-DESC")
    NOTES=$(localize "GET-KEYBOARD-LAYOUT-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "GET-KEYBOARD-LAYOUT-DESC"   "Get Keyboard Layout, makes changes for some variants."
    localize_info "GET-KEYBOARD-LAYOUT-NOTES"  "None."
    #
    localize_info "GET-KEYBOARD-LAYOUT-TITLE"  "Keymap."
    localize_info "GET-KEYBOARD-LAYOUT-SELECT" "Select keyboard layout:"
fi
# -------------------------------------
get_keyboard_layout()
{
    if [[ "$LANGUAGE" == 'es_ES' ]]; then
        print_title "GET-KEYBOARD-LAYOUT-TITLE" "https://wiki.archlinux.org/index.php/KEYMAP"
        KBLAYOUT=("es" "latam");
        PS3="$prompt1"
        print_info "GET-KEYBOARD-LAYOUT-SELECT"
        select KBRD in "${KBLAYOUT[@]}"; do
            KEYBOARD="$KBRD"
        done
    fi    
}
#}}}
# -----------------------------------------------------------------------------
# CONFIGURE KEYMAP {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="configure_keymap"
    USAGE="configure_keymap"
    DESCRIPTION=$(localize "CONFIGURE-KEYMAP-DESC")
    NOTES=$(localize "CONFIGURE-KEYMAP-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "CONFIGURE-KEYMAP-DESC"    "Allows user to decide if they wish to change the Default Keymap."
    localize_info "CONFIGURE-KEYMAP-NOTES"   "None."
    #
    localize_info "Load-Keymap"              "Load Keymap"
    localize_info "Confirm-Keymap"           "Confirm Keymap"
    localize_info "CONFIGURE-KEYMAP-TITLE"   "KEYMAP"
    localize_info "CONFIGURE-KEYMAP-INFO"    "The KEYMAP variable is specified in the /etc/rc.conf file. It defines what keymap the keyboard is in the virtual consoles. Keytable files are provided by the kbd package."
    localize_info "CONFIGURE-KEYMAP-DEFAULT" "If Default is ok, then no changes needed: "
    localize_info "CONFIGURE-KEYMAP-LAYOUT"  "Keyboard Layout (ex: us-acentos): "
    #
    localize_info "CONFIGURE-KEYMAP-INFO-1"  "Belgian                = be-latin1    | Brazilian Portuguese = br-abnt2     | Canadian-French = cf"
    localize_info "CONFIGURE-KEYMAP-INFO-2"  "Canadian Multilingual  = ca_multi     | Colemak (US)         = colemak      | Croatian        = croat"
    localize_info "CONFIGURE-KEYMAP-INFO-3"  "Czech                  = cz-lat2      | Dvorak               = dvorak       | French          = fr-latin1"
    localize_info "CONFIGURE-KEYMAP-INFO-4"  "German                 = de-latin1 or de-latin1-nodeadkeys                  | Italian         = it"
    localize_info "CONFIGURE-KEYMAP-INFO-5"  "Lithuanian             = lt.baltic    | Norwegian            = no-latin1    | Polish          = pl"
    localize_info "CONFIGURE-KEYMAP-INFO-6"  "Portuguese             = pt-latin9    | Romanian             = ro_win       | Russian         = ru4"
    localize_info "CONFIGURE-KEYMAP-INFO-7"  "Singapore              = sg-latin1    | Slovene              = slovene      | Swedish         = sv-latin1"
    localize_info "CONFIGURE-KEYMAP-INFO-8"  "Swiss-French           = fr_CH-latin1 | Swiss-German         = de_CH-latin1 | Spanish         = es"
    localize_info "CONFIGURE-KEYMAP-INFO-9"  "Spanish Latinoamerican = la-latin1    | Turkish              = tr_q-latin5  | Ukrainian       = ua"
    localize_info "CONFIGURE-KEYMAP-INFO-10" "United States          = us or us-acentos                                   | United Kingdom  = uk"
fi
# -------------------------------------
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
            elif [[ "$KEYMAP" == more ]]; then
                read -p "CONFIGURE-KEYMAP-LAYOUT" KEYMAP
                loadkeys $KEYMAP
                break
            else
                invalid_option "$KEYMAP"
            fi
        done
    }
    print_title "CONFIGURE-KEYMAP-TITLE" " - https://wiki.archlinux.org/index.php/KEYMAP"
    print_this  "CONFIGURE-KEYMAP-INFO"
    print_line
    print_this "CONFIGURE-KEYMAP-INFO-1"
    print_line
    print_this "CONFIGURE-KEYMAP-INFO-2"
    print_line
    print_this "CONFIGURE-KEYMAP-INFO-3"
    print_line
    print_this "CONFIGURE-KEYMAP-INFO-4"
    print_line
    print_this "CONFIGURE-KEYMAP-INFO-5"
    print_line
    print_this "CONFIGURE-KEYMAP-INFO-6"
    print_line
    print_this "CONFIGURE-KEYMAP-INFO-7"
    print_line
    print_this "CONFIGURE-KEYMAP-INFO-8"
    print_line
    print_this "CONFIGURE-KEYMAP-INFO-9"
    print_line
    print_this "CONFIGURE-KEYMAP-INFO-10"
    print_line
    print_this  "CONFIGURE-KEYMAP-DEFAULT" " [$KEYMAP]"
    Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
    read_input_default "Keymap" "$KEYMAP"
    read_input_yn "Load-Keymap" "$KEYMAP" 0
    if [[ "$YN_OPTION" -eq 1 ]]; then
        while [[ $YN_OPTION -ne 1 ]]; do
            setkeymap
            read_input_yn "Confirm-Keymap" "$KEYMAP" 1
        done
    else
        KEYMAP="us"
    fi
    BYPASS="$Old_BYPASS" # Restore Bypass
}
#}}}
# -----------------------------------------------------------------------------
# GET EDITOR {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="get_editor"
    USAGE="get_editor"
    DESCRIPTION=$(localize "GET-EDITOR-DESC")
    NOTES=$(localize "GET-EDITOR-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "GET-EDITOR-DESC"  "This gets called from Boot mode and Live mode; it does not add software, only ask if you wish to change the default editor, called from the create_config function."
    localize_info "GET-EDITOR-NOTES" "None."
    #
    localize_info "GET-EDITOR-DEFAULT"   "Do you wish to change the Default Editor of "
    localize_info "GET-EDITOR-TITLE"     "DEFAULT EDITOR"
    localize_info "GET-EDITOR-INSTALLED" "Installed Editor(s): "
    localize_info "GET-EDITOR-EDITORS"   "Editors"
    localize_info "GET-EDITOR-SELECT"    "Select default editor:"
fi
# -------------------------------------
get_editor()
{
    print_title "GET-EDITOR-TITLE"
    if [[ -f /usr/bin/vim ]]; then
        print_info "GET-EDITOR-INSTALLED" "emacs"
    else
        print_info "GET-EDITOR-INSTALLED" "emacs & vim"
    fi
    print_this "GET-EDITOR-EDITORS" ": ${EDITORS[*]}"
    Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
    read_input_yn "GET-EDITOR-DEFAULT" "$EDITOR" 0
    BYPASS="$Old_BYPASS" # Restore Bypass
    if [[ "$YN_OPTION" -eq 1 ]]; then
        PS3="$prompt1"
        print_this "GET-EDITOR-SELECT"
        select OPT in "${EDITORS[@]}"; do
            case "$REPLY" in
                1)
                    EDITOR="nano"
                    break
                    ;;
                2)
                    EDITOR="emacs"
                    break
                    ;;
                3)
                    EDITOR="vi"
                    break
                    ;;
                4)
                    EDITOR="vim"
                    break
                    ;;
                5)
                    EDITOR="joe"
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
# SELECT EDITOR {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="select_editor"
    USAGE="select_editor"
    DESCRIPTION=$(localize "SELECT-EDITOR-DESC")
    NOTES=$(localize "SELECT-EDITOR-NOTES")
    AUTHOR="helmuthdu and Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "SELECT-EDITOR-DESC"  "This gets called from Boot mode only; it installs on the Boot OS, and schedules an install on the Live OS."
    localize_info "SELECT-EDITOR-NOTES" "None."
fi
# -------------------------------------
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
# CONFIGURE TIMEZONE {{{
if [[ "$RUN_HELP" -eq 1 ]]; then
    NAME="configure_timezone"
    USAGE="configure_timezone"
    DESCRIPTION=$(localize "CONFIGURE-TIMEZONE-DESC")
    NOTES=$(localize "CONFIGURE-TIMEZONE-NOTES")
    AUTHOR="Flesher"
    VERSION="1.0"
    CREATED="11 SEP 2012"
    REVISION="5 Dec 2012"
    create_help "$NAME" "$USAGE" "$DESCRIPTION" "$NOTES" "$AUTHOR" "$VERSION" "$CREATED" "$REVISION" "$(basename $BASH_SOURCE) : $LINENO"
fi
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "CONFIGURE-TIMEZONE-DESC"     "Configure Timezone."
    localize_info "CONFIGURE-TIMEZONE-NOTES"    "None."
    #
    localize_info "CONFIGURE-TIMEZONE-DEFAULT"  "Is the Default Timezone Correct"
    localize_info "CONFIGURE-TIMEZONE-CONFIRM"  "Confirm Timezone "
    localize_info "CONFIGURE-TIMEZONE-TITLE"    "TIMEZONE"
    localize_info "CONFIGURE-TIMEZONE-INFO-1"   "In an operating system the time (clock) is determined by four parts: Time value, Time standard, Time Zone, and DST (Daylight Saving Time if applicable)."
    localize_info "CONFIGURE-TIMEZONE-ZONE"     "Select zone:"
    localize_info "CONFIGURE-TIMEZONE-SUBZONE"  "Select subzone:"
    #
    localize_info "CONFIGURE-TIMEZONE-ZONE-1"   "Africa"
    localize_info "CONFIGURE-TIMEZONE-ZONE-2"   "America"
    localize_info "CONFIGURE-TIMEZONE-ZONE-3"   "Antarctica"
    localize_info "CONFIGURE-TIMEZONE-ZONE-4"   "Arctic"
    localize_info "CONFIGURE-TIMEZONE-ZONE-5"   "Asia"
    localize_info "CONFIGURE-TIMEZONE-ZONE-6"   "Atlantic"
    localize_info "CONFIGURE-TIMEZONE-ZONE-7"   "Australia"
    localize_info "CONFIGURE-TIMEZONE-ZONE-8"   "Brazil"
    localize_info "CONFIGURE-TIMEZONE-ZONE-9"   "Canada"
    localize_info "CONFIGURE-TIMEZONE-ZONE-10"  "Chile"
    localize_info "CONFIGURE-TIMEZONE-ZONE-11"  "Europe"
    localize_info "CONFIGURE-TIMEZONE-ZONE-12"  "Indian"
    localize_info "CONFIGURE-TIMEZONE-ZONE-13"  "Mexico"
    localize_info "CONFIGURE-TIMEZONE-ZONE-14"  "Midest"
    localize_info "CONFIGURE-TIMEZONE-ZONE-15"  "Pacific"
    localize_info "CONFIGURE-TIMEZONE-ZONE-16"  "US"
fi
# -------------------------------------
configure_timezone()
{
    settimezone()
    {
        # @FIX Localize?
        local zone=("$(localize "CONFIGURE-TIMEZONE-ZONE-1")" "$(localize "CONFIGURE-TIMEZONE-ZONE-2")" "$(localize "CONFIGURE-TIMEZONE-ZONE-3")" "$(localize "CONFIGURE-TIMEZONE-ZONE-4")" "$(localize "CONFIGURE-TIMEZONE-ZONE-5")" "$(localize "CONFIGURE-TIMEZONE-ZONE-6")" "$(localize "CONFIGURE-TIMEZONE-ZONE-7")" "$(localize "CONFIGURE-TIMEZONE-ZONE-8")" "$(localize "CONFIGURE-TIMEZONE-ZONE-9")" "$(localize "CONFIGURE-TIMEZONE-ZONE-10")" "$(localize "CONFIGURE-TIMEZONE-ZONE-11")" "$(localize "CONFIGURE-TIMEZONE-ZONE-12")" "$(localize "CONFIGURE-TIMEZONE-ZONE-13")" "$(localize "CONFIGURE-TIMEZONE-ZONE-14")" "$(localize "CONFIGURE-TIMEZONE-ZONE-15")" "$(localize "CONFIGURE-TIMEZONE-ZONE-16")");
        PS3="$prompt1"
        echo "CONFIGURE-TIMEZONE-ZONE"
        select ZONE in "${zone[@]}"; do
            if contains_element "$ZONE" ${zone[@]}; then
                local subzone=(`ls /usr/share/zoneinfo/$ZONE/`)
                PS3="$prompt1"
                echo "CONFIGURE-TIMEZONE-SUBZONE"
                select SUBZONE in "${subzone[@]}"; do
                if contains_element "$SUBZONE" ${subzone[@]}; then
                    add_packagemanager "remove_file \"/etc/localtime\" \"$LINENO\"; ln -s /usr/share/zoneinfo/${ZONE}/${SUBZONE} /etc/localtime" "RUN-TIMEZONE"
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
    print_title "CONFIGURE-TIMEZONE-TITLE" " - https://wiki.archlinux.org/index.php/Timezone"
    print_info  "CONFIGURE-TIMEZONE-INFO-1"
    Old_BYPASS="$BYPASS"; BYPASS=0; # Do Not Allow Bypass
    read_input_yn "CONFIGURE-TIMEZONE-DEFAULT" "$ZONE/$SUBZONE" 1
    while [[ $YN_OPTION -ne 1 ]]; do
        settimezone
        read_input_yn "CONFIGURE-TIMEZONE-CONFIRM" "($ZONE/$SUBZONE)" 1
    done
    BYPASS="$Old_BYPASS" # Restore Bypass
    if [[ "$RUNTIME_MODE" -eq 2 ]]; then # Live Mode
        if [[ "$DRIVE_FORMATED" -eq 1 ]]; then
            touch ${MOUNTPOINT}/etc/timezone
            echo "${ZONE}/${SUBZONE}" > ${MOUNTPOINT}/etc/timezone
            copy_file ${MOUNTPOINT}/etc/timezone "${FULL_SCRIPT_PATH}/etc/timezone" "$FUNCNAME @ $(basename $BASH_SOURCE) : $LINENO"
        else
            echo "${ZONE}/${SUBZONE}" > "${FULL_SCRIPT_PATH}/etc/timezone" 
        fi
    else # Boot Mode
        echo "${ZONE}/${SUBZONE}" > "${FULL_SCRIPT_PATH}/etc/timezone"
    fi
}
#}}}
# -----------------------------------------------------------------------------
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "SCRIPT-ID1" "Arch Linux Wizard Installation Script"
    localize_info "SCRIPT-ID2" "Versions"
    localize_info "SCRIPT-ID3" "Last updated"
    # Menu
    localize_info "Make-Choose" "Make a Choose:"
    # PROMPT {{{
    localize_info "ENTER-OPTION"  "Enter your Option:"
    localize_info "ENTER-OPTIONS" "Enter n° of options (ex: 1 2 3 or 1-3 or 1,2,3 d b q r): " # n°
    #}}}
    # All others that need to run before function is hit
    localize_info "LOCALIZER-COMPLETED" "Localizer Completed."
    # Help file Localization
    localize_info "CREATE-HELP-USAGE"   "create_help 1->(NAME of Function.) 2->(USAGE) 3->(DESCRIPTION) 4->(NOTES) 5->(AUTHOR) 6->(VERSION) 7->(CREATED) 8->(REVISION) 9->(Source File and LINENO)"
    localize_info "CREATE-HELP-DESC"    "Create an HTML Help File on the Fly"
    localize_info "CREATE-HELP-NOTES"   "This Allows easy reading and Look up of all Functions in Program.<br />${HELP_TAB}This Function must be first Function all scripts see, so put it at the top of file.<br />${HELP_TAB}You can get as elaborate with help files as you want."
    localize_info "CREATE-HELP-WORKING" "Create Help Working"
    localize_info "PRINT-HELP-ERROR"    "Help Array Empty!"
    # Help file Localization
    localize_info "PRINT-HELP-DESC"  "Print an HTML Help File on the Fly"
    localize_info "PRINT-HELP-NOTES" "This Allows easy reading and Look up of all Functions in Program."
    localize_info "PRINT-HELP-TITLE" "Arch Wizard Help File Generated on"
    localize_info "PRINT-HELP-FUNCT" "Function"
    # -----------------------------------------------------------------------------
    # PAUSE FUNCTION {{{
    localize_info "PAUSE-FUNCTION-USAGE"   "pause_function 1->(Description Debugging Information)"
    localize_info "PAUSE-FUNCTION-DESC"    "Pause function"
    localize_info "PAUSE-FUNCTION-NOTES"   "Localized: Arguments passed in are not Localize, this is used for passing in Function names, that can not be localized; if required: localize before passing in."
    #
    localize_info "PRESS-ANY-KEY-CONTINUE" "Press any key to continue"
    # ----------------------------------------------------------------------------- 
    # WRITE ERROR
    localize_info "WRITE-ERROR-USAGE" "write_error 1->(Error) 2->(Debugging Information)"
    localize_info "WRITE-ERROR-DESC"  "Write Error to log."
    localize_info "WRITE-ERROR-NOTES" "Localized."
    #
    localize_info "WRITE-ERROR-ARG"   "Wrong Number of Arguments passed to write_error!"
    localize_info "NOT-FOUND"         "Not Found"
    # Help file Localization
    localize_info "TRIM-DESC"   "Remove space on Right and Left of string"
    localize_info "TRIM-NOTES"  "MY_SPACE=' Left and Right '<br />${HELP_TAB}MY_SPACE=&#36;(trim &#34;&#36;MY_SPACE&#34;)<br />${HELP_TAB}echo &#34;|&#36;(trim &#34;&#36;MY_SPACE&#34;)|&#34;"
    localize_info "LTRIM-NOTES" "MY_SPACE=' Left and Right '<br />${HELP_TAB}MY_SPACE=&#36;(ltrim &#34;&#36;MY_SPACE&#34;)<br />${HELP_TAB}echo &#34;|&#36;(ltrim &#34;&#36;MY_SPACE&#34;)|&#34;"
    localize_info "RTRIM-NOTES" "MY_SPACE=' Left and Right '<br />${HELP_TAB}MY_SPACE=&#36;(rtrim &#34;&#36;MY_SPACE&#34;)<br />${HELP_TAB}echo &#34;|&#36;(rtrim &#34;&#36;MY_SPACE&#34;)|&#34;"
    # Help file Localization
    localize_info "LEFT-TRIM-DESC"  "Remove space on Left of string"
    # Help file Localization
    localize_info "RIGHT-TRIM-USAGE" "rtrim 1->(' String to Trim ')"
    localize_info "RIGHT-TRIM-DESC"  "Remove space on Right of string"
    # Help file Localization
    localize_info "IS-IN-ARRAY-USAGE" "is_in_array 1->(Array{@}) 2->(Search)"
    localize_info "IS-IN-ARRAY-DESC"  "Is Search in Array{@}; return true (0) if found"
    localize_info "IS-IN-ARRAY-NOTES" "Use of Global ARR_INDEX can be used in array index: if is_in_array 'Array{@}' 'Search' ; then MyArray{ARR_INDEX}=1 ; fi; much like get_index; which bombs on not found; takes more code to write it."
    # Help file Localization 
    localize_info "IS-NEEDLE-IN-HAYSTACK-USAGE" "is_needle_in_haystack 1->(Needle to search in Haystack) 2->(Haystack to search in) 3->(Type of Seach: 1=Exact, 2=Beginning, 3=End, 4=Middle, 5=Anywhere)"
    localize_info "IS-NEEDLE-HAYSTACK-DESC"  "Search for a Needle in the Haystack"
    localize_info "IS-NEEDLE-HAYSTACK-NOTES" "None."
    # Help file Localization
    localize_info "LOAD-2D-ARRAY-DESC"    "Load a saved 2D Array from Disk"
    localize_info "LOAD-2D-ARRAY-NOTES"   "This Function Expects a file, bombs if not found."
    localize_info "LOAD-2D-ARRAY-MISSING" "Missing File"
    # Help file Localization
    localize_info "LOCALIZE-SAVE-USAGE" "localize 1->(Localize ID) 2->(Message to Localize) 3->(Print this with no Localization)"
    localize_info "LOCALIZE-SAVE-DESC"  "Localize ID and Message in &#36;{FULL_SCRIPT_PATH}/Localize/en.po file."
    localize_info "LOCALIZE-SAVE-NOTES" "Localization Support"
    # Help file Localization
    localize_info "LOCALIZE-INFO-DESC"  "Localize Info creates the &#36;{FULL_SCRIPT_PATH}/Localize/en.po file used for Localization."
    localize_info "LOCALIZE-INFO-NOTES" "Localized."
    localize_info "LOCALIZE-INFO-USAGE" "localize_info 1->(Localize ID) 2->(Message to Localize)"
    localize_info "CREATE-LOCALIZER-WORKING" "Create Localizer Working..."
    #
    localize_info "WRONG-NUMBER-ARGUMENTS-PASSED-TO" "Wrong Number of Arguments passed to "
    #
    localize_info "IS-STRING-IN-FILE-USAGE" "is_string_in_file 1->(/full-path/file) 2->(search for string)"
    localize_info "IS-STRING-IN-FILE-DESC"  "Return true if string is in file."
    localize_info "IS-STRING-IN-FILE-NOTES" "Used to test files for Updates."
    #
    localize_info "IS-STRING-IN-FILE-FNF" "File Not Found"
    # Show Help
    localize_info "SHOW-HELP-INFO-USAGE-1"  "Usage:"
    localize_info "SHOW-HELP-INFO-USAGE-2"  "./ScriptName &nbsp;&nbsp;   # Run Script in Interactive Mode."
    localize_info "SHOW-HELP-INFO-USAGE-3"  "./ScriptName -l # Run Localizer"
    localize_info "SHOW-HELP-INFO-USAGE-4"  "./ScriptName -h # Build Help File, must run -l first."
    localize_info "SHOW-HELP-INFO-USAGE-5"  "./ScriptName -a # Automatically Run Scripts without Prompts."
    localize_info "SHOW-HELP-INFO-USAGE-6"  "./ScriptName -t # Run Test in mode 1"
    localize_info "SHOW-HELP-INFO-USAGE-7"  "./ScriptName -s # Run Special Test in mode 2"
    # About
    localize_info "SHOW-HELP-INFO-1"  "The Wizard API script was designed to help in writing complex scripts, it handles must of the input and handles common functions."
    localize_info "SHOW-HELP-INFO-2"  "Wizard API:"
    localize_info "SHOW-HELP-INFO-3"  "&nbsp;&nbsp;&nbsp;&nbsp; The Wizard API is the base of the script engine used to write this script, which in itself only writes another script,"
    localize_info "SHOW-HELP-INFO-4"  "&nbsp;&nbsp;&nbsp;&nbsp; so this is known as a script engine, whereas the API or Application Programming Interface, is the syntax,"
    localize_info "SHOW-HELP-INFO-5"  "&nbsp;&nbsp;&nbsp;&nbsp; which is the parameters sent to the function, as such Documenting all the functions would be a huge undertaking in most projects this size,"
    localize_info "SHOW-HELP-INFO-6"  "&nbsp;&nbsp;&nbsp;&nbsp; so I decided to make this script self Documenting, as well as self Localizing, a non-localized script is worthless to the world,"
    localize_info "SHOW-HELP-INFO-7"  "&nbsp;&nbsp;&nbsp;&nbsp; in a perfect Society we would all talk the same Language, for me that would be C++, "
    localize_info "SHOW-HELP-INFO-8"  "&nbsp;&nbsp;&nbsp;&nbsp; so lets just say that no one can agree on what Language to speak in, let alone program in, so even this text needs to be translated,"
    localize_info "SHOW-HELP-INFO-9"  "&nbsp;&nbsp;&nbsp;&nbsp; for those that do not read English; and this is static text; so these instructions really need to be in the script itself;"
    localize_info "SHOW-HELP-INFO-10" "&nbsp;&nbsp;&nbsp;&nbsp; which is why its self Documenting; so it can translate that into the language the person reading it can read it in,"
    localize_info "SHOW-HELP-INFO-11" "&nbsp;&nbsp;&nbsp;&nbsp; so that is it for this static file, all other Documentation will be built in."
    localize_info "SHOW-HELP-INFO-12" "&nbsp;&nbsp;&nbsp;&nbsp; Every program ever write should do 3 things, besides running flawlessly:"
    localize_info "SHOW-HELP-INFO-13" "&nbsp;&nbsp;&nbsp;&nbsp; 1. Localized for every language that will be using it."
    localize_info "SHOW-HELP-INFO-14" "&nbsp;&nbsp;&nbsp;&nbsp; 2. Self Documenting."
    localize_info "SHOW-HELP-INFO-15" "&nbsp;&nbsp;&nbsp;&nbsp; 3. Self Testing, ability to run Test and Determine if program is working correctly."
    localize_info "SHOW-HELP-INFO-16" ""
    localize_info "SHOW-HELP-INFO-17" ""
    localize_info "SHOW-HELP-INFO-18" ""
    localize_info "SHOW-HELP-INFO-19" ""
    # -----------------------------------
    # Troubleshooting Functions
    localize_info "TEST-FUNCTION-PASSED"      "Test Passed"
    localize_info "TEST-FUNCTION-FAILED"      "Test Failed"
    localize_info "TEST-FUNCTION-RUN"         "Running Test"
    localize_info "TEST-FUNCTION-FNF"         "File Not Found"
    localize_info "WRONG-NUMBER-OF-ARGUMENTS" "Wrong Number of Arguments"
    localize_info "INSTALL-MENU-RECOMMENDED"  "Recommended Menu Options"
fi
# -----------------------------------------------------------------------------
show_help()
{
    echo -e "<hr />"
    echo -e "<br />"
    # Usage
    echo -e "$(gettext -s "SHOW-HELP-INFO-USAGE-1")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-USAGE-2")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-USAGE-3")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-USAGE-4")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-USAGE-5")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-USAGE-6")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-USAGE-7")<br />"
    #
    echo '<br />'
    echo -e "$(gettext -s "SHOW-HELP-INFO-1")<br />"
    echo '<br />'
    echo -e "$(gettext -s "SHOW-HELP-INFO-2")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-3")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-4")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-5")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-6")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-7")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-8")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-9")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-10")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-11")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-12")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-13")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-14")<br />"
    echo -e "$(gettext -s "SHOW-HELP-INFO-15")<br />"
}
#}}}
declare TEXT_SCRIPT_ID="$(localize "SCRIPT-ID1"): $SCRIPT_NAME $(localize "SCRIPT-ID2"): $SCRIPT_VERSION $(localize "SCRIPT-ID3"): $LAST_UPDATE"
declare prompt1=$(localize "ENTER-OPTION")
declare prompt2=$(localize "ENTER-OPTIONS")
declare StatusBar1=$(localize "Make-Choose")
declare StatusBar2=" "
# -------------------------------------
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then 
    localize_info "READ-INPUT-OPTIONS-TEST-1"  "Test Options."
    localize_info "READ-INPUT-OPTIONS-TEST-2"  "Option :"
    localize_info "READ-INPUT-OPTIONS-TEST-3"  "Testing Menu System with Options: "
    localize_info "READ-INPUT-OPTIONS-TEST-4"  "Status of Option :"
    localize_info "READ-INPUT-OPTIONS-TEST-5"  "Menu System Test"
    localize_info "READ-INPUT-OPTIONS-MENU-1"  "Menu 1"
    localize_info "READ-INPUT-OPTIONS-MENU-2"  "Menu 2"
    localize_info "READ-INPUT-OPTIONS-MENU-3"  "Menu 3"
    localize_info "READ-INPUT-OPTIONS-MENU-4"  "Menu 4"
    localize_info "READ-INPUT-OPTIONS-MENU-5"  "Menu 5"
    localize_info "READ-INPUT-OPTIONS-MENU-6"  "Menu 6"
    localize_info "READ-INPUT-OPTIONS-MENU-7"  "Menu 7"
    localize_info "READ-INPUT-OPTIONS-MENU-8"  "Menu 8"
    localize_info "READ-INPUT-OPTIONS-MENU-9"  "Menu 9"
    localize_info "READ-INPUT-OPTIONS-MENU-10" "Menu 10"
    #
    localize_info "READ-INPUT-OPTIONS-MENU-1-I"  "Menu 1: Information."
    localize_info "READ-INPUT-OPTIONS-MENU-2-I"  "Menu 2: Information."
    localize_info "READ-INPUT-OPTIONS-MENU-3-I"  "Menu 3: Information."
    localize_info "READ-INPUT-OPTIONS-MENU-4-I"  "Menu 4: Information."
    localize_info "READ-INPUT-OPTIONS-MENU-5-I"  "Menu 5: Information."
    localize_info "READ-INPUT-OPTIONS-MENU-6-I"  "Menu 6: Information."
    localize_info "READ-INPUT-OPTIONS-MENU-7-I"  "Menu 7: Information."
    localize_info "READ-INPUT-OPTIONS-MENU-8-I"  "Menu 8: Information."
    localize_info "READ-INPUT-OPTIONS-MENU-9-I"  "Menu 9: Information."
    localize_info "READ-INPUT-OPTIONS-MENU-10-I" "Menu 10: Information."
fi
if [[ "$RUN_TEST" -eq 2 ]]; then
    test_read_input_options()
    {
        local -r menu_name="TestMenu"  # You must define Menu Name here
        local BreakableKey="Q"         # Q=Quit, D=Done, B=Back
        local RecommendedOptions="1-3" # Recommended Options to run in AUTOMAN or INSTALL_WIZARD Mode
        #
        if [[ "$INSTALL_WIZARD" -eq 1 ]]; then
            RecommendedOptions="$RecommendedOptions 6 6"
        elif [[ "$AUTOMAN" -eq 1 ]]; then
            RecommendedOptions="$RecommendedOptions 7 7"
        fi
        RecommendedOptions="$RecommendedOptions $BreakableKey"
        #
        OLD_IFS="$IFS"; IFS=$'\n\t'; # Very Important
        local -a MenuChecks=( $(create_data_array 0 0 ) )
        IFS="$OLD_IFS"
        #
        StatusBar1="READ-INPUT-OPTIONS-TEST-1"
        StatusBar2=": $RecommendedOptions"
        #
        while [[ 1 ]]; do
            #
            print_line
            print_info "READ-INPUT-OPTIONS-TEST-5"
            print_caution "${StatusBar1}" "${StatusBar2}"
            #
            local -a MenuItems=(); local -a MenuInfo=(); RESET_MENU=1; # Reset
            #
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "READ-INPUT-OPTIONS-MENU-1"  "" "" "READ-INPUT-OPTIONS-MENU-1-I"  "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "READ-INPUT-OPTIONS-MENU-2"  "" "" "READ-INPUT-OPTIONS-MENU-2-I"  "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "READ-INPUT-OPTIONS-MENU-3"  "" "" "READ-INPUT-OPTIONS-MENU-3-I"  "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "READ-INPUT-OPTIONS-MENU-4"  "" "" "READ-INPUT-OPTIONS-MENU-4-I"  "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "READ-INPUT-OPTIONS-MENU-5"  "" "" "READ-INPUT-OPTIONS-MENU-5-I"  "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "READ-INPUT-OPTIONS-MENU-6"  "" "" "READ-INPUT-OPTIONS-MENU-6-I"  "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "READ-INPUT-OPTIONS-MENU-7"  "" "" "READ-INPUT-OPTIONS-MENU-7-I"  "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "READ-INPUT-OPTIONS-MENU-8"  "" "" "READ-INPUT-OPTIONS-MENU-8-I"  "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "READ-INPUT-OPTIONS-MENU-9"  "" "" "READ-INPUT-OPTIONS-MENU-9-I"  "MenuTheme[@]"
            add_menu_item "MenuChecks" "MenuItems" "MenuInfo" "READ-INPUT-OPTIONS-MENU-10" "" "" "READ-INPUT-OPTIONS-MENU-10-I" "MenuTheme[@]"
            #
            print_menu "MenuItems[@]" "MenuInfo[@]" "$BreakableKey"
            #
            read_input_options "$RecommendedOptions" "$BreakableKey"
            RecommendedOptions="" # Clear All previously entered Options so we do not repeat them
            #            
            for S_OPT in ${OPTIONS[@]}; do
                case "$S_OPT" in
                    1)  # Option 1
                        MenuChecks[$((S_OPT - 1))]=1
                        print_warning "READ-INPUT-OPTIONS-TEST-2" "$S_OPT"
                        StatusBar1=$(localize "READ-INPUT-OPTIONS-TEST-4")
                        StatusBar2="$S_OPT"
                        ;;
                    2)  # Option 2
                        MenuChecks[$((S_OPT - 1))]=1
                        print_warning "READ-INPUT-OPTIONS-TEST-2" "$S_OPT"
                        StatusBar1=$(localize "READ-INPUT-OPTIONS-TEST-4")
                        StatusBar2="$S_OPT"
                        ;;
                    3)  # Option 3
                        MenuChecks[$((S_OPT - 1))]=1
                        print_warning "READ-INPUT-OPTIONS-TEST-2" "$S_OPT"
                        StatusBar1=$(localize "READ-INPUT-OPTIONS-TEST-4")
                        StatusBar2="$S_OPT"
                        ;;
                    4)  # Option 4
                        MenuChecks[$((S_OPT - 1))]=1
                        print_warning "READ-INPUT-OPTIONS-TEST-2" "$S_OPT"
                        StatusBar1=$(localize "READ-INPUT-OPTIONS-TEST-4")
                        StatusBar2="$S_OPT"
                        ;;
                    5)  # Option 5
                        MenuChecks[$((S_OPT - 1))]=1
                        print_warning "READ-INPUT-OPTIONS-TEST-2" "$S_OPT"
                        StatusBar1=$(localize "READ-INPUT-OPTIONS-TEST-4")
                        StatusBar2="$S_OPT"
                        ;;
                    6)  # Option 6
                        MenuChecks[$((S_OPT - 1))]=1
                        print_warning "READ-INPUT-OPTIONS-TEST-2" "$S_OPT"
                        StatusBar1=$(localize "READ-INPUT-OPTIONS-TEST-4")
                        StatusBar2="$S_OPT"
                        ;;
                    7)  # Option 7
                        MenuChecks[$((S_OPT - 1))]=1
                        print_warning "READ-INPUT-OPTIONS-TEST-2" "$S_OPT"
                        StatusBar1=$(localize "READ-INPUT-OPTIONS-TEST-4")
                        StatusBar2="$S_OPT"
                        ;;
                    8)  # Option 8
                        MenuChecks[$((S_OPT - 1))]=1
                        print_warning "READ-INPUT-OPTIONS-TEST-2" "$S_OPT"
                        StatusBar1=$(localize "READ-INPUT-OPTIONS-TEST-4")
                        StatusBar2="$S_OPT"
                        ;;
                    9)  # Option 9
                        MenuChecks[$((S_OPT - 1))]=1
                        print_warning "READ-INPUT-OPTIONS-TEST-2" "$S_OPT"
                        StatusBar1=$(localize "READ-INPUT-OPTIONS-TEST-4")
                        StatusBar2="$S_OPT"
                        ;;
                   10)  # Option 10
                        MenuChecks[$((S_OPT - 1))]=1
                        print_warning "READ-INPUT-OPTIONS-TEST-2" "$S_OPT"
                        StatusBar1=$(localize "READ-INPUT-OPTIONS-TEST-4")
                        StatusBar2="$S_OPT"
                        ;;
                    *)  # Not programmed key
                        print_warning "READ-INPUT-OPTIONS-TEST-2" "$S_OPT"
                        if [[ "$S_OPT" == $(to_lower_case "$BreakableKey") ]]; then
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
    #
    AUTOMAN=1
    INSTALL_WIZARD=0
    print_this "READ-INPUT-OPTIONS-TEST-3" "AUTOMAN=$AUTOMAN and INSTALL_WIZARD=$INSTALL_WIZARD"
    test_read_input_options
    #
    AUTOMAN=0
    INSTALL_WIZARD=1
    print_this "READ-INPUT-OPTIONS-TEST-3" "AUTOMAN=$AUTOMAN and INSTALL_WIZARD=$INSTALL_WIZARD"
    test_read_input_options
    #
    AUTOMAN=0
    INSTALL_WIZARD=0
    print_this "READ-INPUT-OPTIONS-TEST-3" "AUTOMAN=$AUTOMAN and INSTALL_WIZARD=$INSTALL_WIZARD"
    test_read_input_options
fi
# -------------------------------------
# Run Test down here to avoid function calls before they are defined.
if [[ "$RUN_TEST" -eq 1 ]]; then
    HayStack="1 2 3 4 5"
    Needle="1 2 3 4 5" # 1=Exact     : 1 2 3 4 5 
    if $(is_needle_in_haystack "$Needle" "$HayStack" 1) ; then # 1=Exact
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_needle_in_haystack @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_needle_in_haystack @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
    Needle="1"         # 2=Beginning : 1, 1 2 3 4, 1 2 3, 1 2
    if $(is_needle_in_haystack "$Needle" "$HayStack" 2) ; then # 2=Beginning
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_needle_in_haystack @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_needle_in_haystack @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
    Needle="5"         # 3=End       : 5, 2 3 4 5, 3 4 5, 4 5
    if $(is_needle_in_haystack "$Needle" "$HayStack" 3) ; then # 3=End
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_needle_in_haystack @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_needle_in_haystack @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
    Needle="3"         # 4=Middle    : 2 3, 2 3 4, 3 4, 3, 4
    if $(is_needle_in_haystack "$Needle" "$HayStack" 4) ; then # 4=Middle
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_needle_in_haystack @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_needle_in_haystack @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
    HayStack="1ABS 2ABS 1POS 2POS"
    Needle="ABS POS"       # 5=Anywhere  : 1 5, 5 1, 1 2 3 5, 2 1 3 4 5, ...
    if $(is_needle_in_haystack "$Needle" "$HayStack" 5) ; then # 5=Anywhere
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_needle_in_haystack @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_needle_in_haystack @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
    HayStack="1 4 5 12 3 15"
    Needle="1 3"       # 6=Anywhere Exactly  : Not found
    if $(is_needle_in_haystack "$Needle" "$HayStack" 6) ; then # 6=Anywhere Exactly
        echo -e "\t${BBlue}$(gettext -s "TEST-FUNCTION-PASSED")  is_needle_in_haystack @ $(basename $BASH_SOURCE) : $LINENO${White}"
    else
        echo -e "\t${BRed}$(gettext -s "TEST-FUNCTION-FAILED")  is_needle_in_haystack @ $(basename $BASH_SOURCE) : $LINENO${White}"
    fi
fi
# ************************************* END OF SCRIPT *************************
