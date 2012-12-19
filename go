#!/bin/bash
#
FULL_SCRIPT_PATH=$(dirname $(readlink -f "$0"))
if [ -f "${FULL_SCRIPT_PATH}/wizard.sh" ]; then
    declare -i RUN_LOCALIZER=0
    declare -r LOCALIZED_PATH="${FULL_SCRIPT_PATH}/locale-go"
    declare LOCALIZED_FILE="go-wizard.sh"
    #. "${FULL_SCRIPT_PATH}/wizard.sh"
    source "${FULL_SCRIPT_PATH}/wizard.sh"
else
    echo "ERROR - ${FULL_SCRIPT_PATH}/wizard.sh NOT FOUND"
    exit 1
fi

LOG_PATH="${SCRIPT_DIR}/LOG"
CONFIG_NAME="go"
ERROR_LOG="${LOG_PATH}/${CONFIG_NAME}-error.log"
ACTIVITY_LOG="${LOG_PATH}/${CONFIG_NAME}-activity.log"

copy2flash()
{
    #
    cp -fv wiz            $1
    cp -fv wizard.sh      $1
    cp -fv common-wiz.sh  $1
    cp -fv package-wiz.sh $1
    cp -fv arch-wiz.sh    $1
    cp -fv packages.sh    $1
    cp -fv bashtest       $1
    cp -fv help.html      $1
    cp -rfv locale/       $1
}

#
localize_info "CHANGE-OWNER" "Change Owner on Flash Drive"
localize_info "" ""
#
if [[ "$RUN_LOCALIZER" -eq 1 ]]; then
    localize_save
    #print_help
else
    #
    ./bashtest
    #
    pause_function "Press any key to continue" "$LINENO"
    #
    read_input_yn "CHANGE-OWNER" " " 0
    if [[ "$YN_OPTION" -eq 1 ]]; then
        sudo chown -R $2:$2 $1
    fi
    copy2flash
    #
    sync
    #
fi
#
echo "Completed"
