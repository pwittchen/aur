aur
===
an utility for downloading and installing software packages from [aur](https://aur.archlinux.org/)

requirements
------------
`curl`, `jq`, `git`

installation
------------

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/pwittchen/aur/master/install.sh)"
```

or

```
git clone https://github.com/pwittchen/aur.git
cd aur
cp aur.sh /usr/local/bin/aur
```

uninstallation
--------------

```
sudo rm /usr/local/bin/aur
```

usage
-----

type `aur` command with one of the following parameters

```
help      shows help
search    searches for a package
fetch     fetches a package
install   installs a package
get       fetches and installs the package
clean     cleans temporary files
```

**example**

```
aur get urlview-git
```
