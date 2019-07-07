auri
====
an utility for downloading and installing software packages from aur

requirements
------------
- `curl`
- `jq`

installation
------------

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/pwittchen/auri/master/install.sh)"
```

uninstallation
--------------

```
sudo rm /usr/local/bin/auri
```

usage
-----

type `auri` command with one of the following parameters

```
help      shows help
search    searches for a package
fetch     fetches a package
install   installs a package
get       fetches and installs the package
clean     cleans temporary files
```
