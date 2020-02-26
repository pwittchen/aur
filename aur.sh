#!/usr/bin/env bash

AUR_URL="https://aur.archlinux.org"
TMP_DIR="/tmp/aur"

function validate_package_not_empty {
  if [ -z "$1" ] ; then
    echo "you haven't provided a package name!"
    exit
  fi
}

function validate_package_exists_in_suggestions {
  echo "searching for the package $1"
  output=$(curl "$AUR_URL/rpc?type=suggest&arg=$1" -s | jq '.[]')
  if [ -z "$output" ] ; then
    echo "nothing was found"
    exit
  fi
}

function validate_package_exists_on_aur {
  output=$(curl "$AUR_URL/cgit/aur.git/plain/PKGBUILD?h=$1" -s)
  if [[ $output == *"Invalid branch"* ]] ; then
    echo "package $1 does not exist on aur"
    exit
  fi
}

function validate_package_is_fetched {
  if [ ! -d "$TMP_DIR/$1" ] ; then
    echo "package is not fetched!"
    exit
  fi
}

function validate_package_has_pkgbuild {
  if [ ! -f "$TMP_DIR/$1/PKGBUILD" ] ; then
    echo "PKBUILD was not found in fetched directory"
    exit
  fi
}

function help {
  echo "
       aur is a script for downloading and installing packages from aur.archlinux.org

       usage:

       help      shows help
       search    searches for a package
       pkg       shows contents of PKGBUILD file of the package
       newest    shows newest packages
       fetch     fetches a package
       fetched   shows fetched packages
       deps      shows dependencies of the fetched package
       install   installs a package
       get       fetches and installs the package
       remove    removes installed package via pacman
       clean     cleans temporary files
       "
}

function search {
  validate_package_not_empty $1
  validate_package_exists_in_suggestions $1
  echo "the following candidates were found:"
  output_array=($output)
  for i in "${output_array[@]}"
  do :
      echo $i | sed -e 's/^"//' -e 's/"$//'
  done
}

function pkg {
  validate_package_not_empty $1
  validate_package_exists_on_aur $1
  echo "contents of PKGBUILD for $1:"
  echo ""
  echo "$output"
}

function newest {
  echo "newest packages:"
  curl "$AUR_URL/rss/" -s | grep title | tail -n +3 | sed 's/<[^>]*>//g' | sed 's/ //g'
}

function fetch {
  validate_package_not_empty $1
  validate_package_exists_on_aur $1
  echo "fetching the package $1"
  rm -rf "$TMP_DIR/$1" || true
  mkdir -p "$TMP_DIR/$1"
  git clone "$AUR_URL/$1.git" "$TMP_DIR/$1"
  validate_package_has_pkgbuild $1
  echo "done"
}

function fetched {
  ls -1 /tmp/aur
}

function deps {
  validate_package_has_pkgbuild $1
  deps=$(awk '/depends/,/){1}/' "$TMP_DIR/$1/PKGBUILD" | tr -d "'()" | sed 's/makedepends=//g' | sed 's/depends=//g' | tr '\n' ' ' | tr -s ' ')
  deps_array=($deps)
  for i in "${deps_array[@]}"
  do :
      echo $i
  done
}

function install {
  validate_package_not_empty $1
  validate_package_is_fetched $1
  validate_package_has_pkgbuild $1
  echo "installing package $1"
  cd "$TMP_DIR/$1"
  makepkg -si
  cd -
  echo "cleaning installation files"
  rm -rf "$TMP_DIR/$1"
  echo "$1 installed"
  echo "done"
}

function remove {
  validate_package_not_empty $1
  echo "removing $1"
  sudo pacman -Rns $1
  echo "done"
}

function clean {
  echo "cleaning temporary files"
  rm -rf $TMP_DIR || true
  echo "done"
}

function main {
  if [ -z "$1" ] || [ "$1" == "help" ] ; then
    help
    exit
  fi
  if [ "$1" == "search" ] ; then
    search $2
    exit
  fi
  if [ "$1" == "pkg" ] ; then
    pkg $2
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
  if [ "$1" == "fetched" ] ; then
    fetched
    exit
  fi
  if [ "$1" == "deps" ] ; then
    deps $2
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
  if [ "$1" == "remove" ] ; then
    remove $2
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
