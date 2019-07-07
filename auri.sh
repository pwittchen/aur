#!/usr/bin/env bash

function help() {
  echo "
       auri is an utility for downloading and installing software packages from AUR
       
       usage:

       help      shows help
       search    searches package
       fetch     fetches package
       install   installs package
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

  mkdir -p "/tmp/auri/$1"
  git clone "https://aur.archlinux.org/$1.git" "/tmp/auri/$1"
  echo "done"
}

function install() {
  if [ -z "$1" ]; then
    echo "you haven't provided package name!"
    exit
  fi

  echo "installing package $1"
  #todo: implement
}

function clean() {
  echo "cleaning temporary files"
  rm -rf /tmp/auri || true
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
  if [ "$1" == "clean" ] ; then
    clean
    exit
  else
    echo "wrong argument: $1"
  fi
}

main "$@"
