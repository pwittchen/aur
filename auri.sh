#!/usr/bin/env bash

function help() {
  echo "
       auri is a utility for downloading and installing software packages from AUR
       
       usage:
       help      shows help
       search    searches package
       fetch     fetches package
       install   installs package
       "
}

function search() {
  if [ -z "$1" ]; then
    echo "you haven't provided package name!"
    exit
  fi

  echo "searching for a package $1"
}

function fetch() {
  if [ -z "$1" ]; then
    echo "you haven't provided package name!"
    exit
  fi

  echo "fetching package $1"
}

function install() {
  if [ -z "$1" ]; then
    echo "you haven't provided package name!"
    exit
  fi

  echo "installing package $1"
}

function main() {
  if [ -z "$1" ] || [ "$1" == "help" ] ; then
    help 
    exit
  fi
  if [ "$1" == "search" ] ; then
    search $2
    exit
  fi
  if [ "$1" == "fetch" ] ; then
    fetch $2
    exit
  fi
  if [ "$1" == "install" ] ; then
    install $2
    exit
  else
    echo "wrong argument: $1"
  fi
}

main "$@"
