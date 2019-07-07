#!/usr/bin/env bash

function help() {
  echo "
       aur is an utility for downloading and installing software packages from aur
       
       usage:

       help      shows help
       search    searches for a package
       fetch     fetches a package
       install   installs a package
       get       fetches and installs the package
       clean     cleans temporary files
       "
}

function search() {
  if [ -z "$1" ] ; then
    echo "you haven't provided package name!"
    exit
  fi

  echo "searching for a package $1"
  output=$(curl "https://aur.archlinux.org/rpc?type=suggest&arg=$1" -s | jq '.[]')
  if [ -z "$output" ] ; then
    echo "nothing was found"
  else
    echo "the following candidates were found:"
    output_array=($output)
    for i in "${output_array[@]}"
    do
        :
        echo $i | sed -e 's/^"//' -e 's/"$//'
    done
  fi
}

function fetch() {
  if [ -z "$1" ]; then
    echo "you haven't provided package name!"
    exit
  fi

  echo "fetching package $1"
  output=$(curl "https://aur.archlinux.org/rpc?type=suggest&arg=$1" -s | jq '.[]')

  if [ -z "$output" ] ; then
    echo "there's not such package in aur"
    exit
  fi

  mkdir -p "/tmp/aur/$1"
  git clone "https://aur.archlinux.org/$1.git" "/tmp/aur/$1"
  echo "done"
}

function install() {
  if [ -z "$1" ]; then
    echo "you haven't provided package name!"
    exit
  fi

  echo "checking package $1"
  if [ ! -d "/tmp/aur/$1" ] ; then
    echo "package is not fetched!"
    exit
  fi

  echo "installing package $1"
  cd "/tmp/aur/$1"
  makepkg -si
  cd -
  echo "cleaning installation files"
  rm -rf "/tmp/aur/$1"
  echo "$1 installed"
  echo "done"
}

function clean() {
  echo "cleaning temporary files"
  rm -rf /tmp/aur || true
  echo "done"
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
  fi
  if [ "$1" == "get" ] ; then
    fetch $2
    install $2
    exit
  fi
  if [ "$1" == "clean" ] ; then
    clean
    exit
  else
    echo "wrong argument: $1"
  fi
}

main "$@"
