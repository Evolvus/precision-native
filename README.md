# precision-native
Command line menu driven front end for Migration Use cases


## Quick Usage
```
git clone --recurse-submodules git@github.com:ennovatenow/precision-native.git
cd precision-native
./bin/install.sh

./init-exec.sh

./migrate.sh
```

This will create the `$HOME/precision100` folder and execute the `simple-demo` project.

> The `--recurse-submodules` parameter is required while cloning because we have a dependency with Precision100 framework.


### A longer example
To-do

## Operating System Requirements
The simple client has the same requirements as the Precision 100 Framework, it uses the `bash` shell for most of its work, more specifically it uses bash 4.2 features like associative arrays. Although all development and tests of the framework is done on `linux`, the framwork should run on any operating system supporting the `bash` shell.
Make sure you check your `bash` version.

```
$ bash --version
GNU bash, version 4.4.19(1)-release (x86_64-pc-linux-gnu)
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```

## Contributing
Thank you very much for considering to contribute!

Please make sure you follow our [Code Of Conduct](CODE_OF_CONDUCT.md) and we also strongly recommend reading our [Contributing Guide](CONTRIBUTING.md).
