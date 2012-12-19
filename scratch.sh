add_taskmanager "required_repo 'multilib'" "REQUIRED-REPO-MULTILIB"


    #
    if [ "$#" -ne "3" ]; then echo -e "${BRed} get_aur_packages $(gettext -s "Wrong-Number-of-Arguments") ${White}"; fi
    #

    local parms="-s"
    if [[ "$3" -eq 1 ]]; then # AUR Repo 
        parms="-s"
    else                      # No Repo
        parms="-si"           # Install
    fi
    echo -e "${BWhite}\t Compileing Package ${1} makepkg ${parms} --noconfirm in function: get_aur_packages at line: $LINENO ${White}"
    cd "${1}"
    if ! makepkg ${parms} --noconfirm ; then
        if [[ "$2" -eq 1 ]]; then # DEBUGGING
            echo -e "${BRed}\t${1} Failed to compile makepkg ${parms} --noconfirm in function: get_aur_packages at line: $LINENO ${White}"
            read -e -sn 1 -p "Press any key to continue (get_aur_packages ${1})..."
        fi
        return 1
    fi

