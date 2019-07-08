#!/usr/bin/env bash

AUR_URL="https://aur.archlinux.org"
TMP_DIR="/tmp/aur/"

function help() {
  echo "
       aur is a simple script for downloading and installing software packages from aur (aur helper)
       
       usage:

       help      shows help
       search    searches for a package
       newest    shows newest packages
       fetch     fetches a package
       install   installs a package
       get       fetches and installs the package
       clean     cleans temporary files
       "
}

function validate_package_name() {
  if [ -z "$1" ] ; then
    echo "you haven't provided a package name!"
    exit
  fi
}

function search() {
  validate_package_name $1
  echo "searching for the package $1"
  output=$(curl "$AUR_URL/rpc?type=suggest&arg=$1" -s | jq '.[]')
  if [ -z "$output" ] ; then
    echo "nothing was found"
    exit
  fi

  echo "the following candidates were found:"
  output_array=($output)
  for i in "${output_array[@]}"
  do
      :
      echo $i | sed -e 's/^"//' -e 's/"$//'
  done
}

function newest() {
  echo "newest packages:"
  curl "$AUR_URL/rss/" -s | grep title | tail -n +3 | sed 's/<[^>]*>//g' | sed 's/ //g'
}

function fetch() {
  validate_package_name $1
  echo "searching for the package $1"
  output=$(curl "$AUR_URL/rpc?type=suggest&arg=$1" -s | jq '.[]')

  if [ -z "$output" ] ; then
    echo "nothing was found"
    exit
  fi

  echo "fetching the package $1"
  mkdir -p "$TMP_DIR/$1"
  git clone "$AUR_URL/$1.git" "$TMP_DIR/$1"
  echo "done"
}

function install() {
  validate_package_name $1
  echo "checking package $1"
  if [ ! -d "$TMP_DIR/$1" ] ; then
    echo "package is not fetched!"
    exit
  fi

  echo "installing package $1"
  cd "$TMP_DIR/$1"
  makepkg -si
  cd -
  echo "cleaning installation files"
  rm -rf "$TMP_DIR/$1"
  echo "$1 installed"
  echo "done"
}

function clean() {
  echo "cleaning temporary files"
  rm -rf $TMP_DIR || true
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
  if [ "$1" == "newest" ] ; then
    newest
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
