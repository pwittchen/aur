#!/usr/bin/env bash

function showHelp() {
  echo "
       auri is a utility for downloading and installing software packages from AUR
       
       usage:
       -h      shows help
       -s      searches package
       -f      fetches package
       -i      installs package
       "
}

function search() {
  echo "search"
}

function fetch() {
  echo "fetch"
}

function install() {
  echo "install"
}

OPTIND=1 # reset in case getopts has been used previously in the shell.

while getopts "hsfi" opt; do
    case "$opt" in
    h)
        showHelp
        exit 0
        ;;
    s)  search
		;;
    f)  fetch
        ;;
    i)  install
        ;;
    esac
done

 shift $((OPTIND-1))

[ "$1" = "--" ] && shift
