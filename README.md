# precision-native
Command line menu driven front end for Migration Use cases

## Quick Usage
```
git clone git@github.com:ennovatenow/precision-native.git
cd precision-native

python3 -m pip install --index-url https://test.pypi.org/simple/ precision_100
python3 -m pip install --index-url https://test.pypi.org/simple/ precision_100_operators


./bin/configure-project.sh
./init-exec.sh mock1
./migrate.sh
```

This will create the `$HOME/precision100` folder and execute the `simple-demo` project.

## A longer example
To execute a **precision 100 project** using the **precision-native** client we need to follow the steps mentioned below,

### Prerequisites
To execute the project the requirements are

1. **python3** version ** > 3.8**
2. Precision-100 Framework
3. Precision-100 Operators

**python3** version should be **> 3.8**
   
```
python3 --version
Python 3.13.2
```

For demo/testing purposes we can create a virtual environment

```
python3 -m venv app
source app/bin/activate
```

Install Precision 100 and Precision 100 operators (for now the components are installed in https://test.pypi.org not http://pypi.org)

```
python3 -m pip install --index-url https://test.pypi.org/simple precision_100
python3 -m pip install --index-url https://test.pypi.org/simple precision_100_operators
```

### Execution
To execute the project, follow the below steps,

```
./bin/configure-project.sh
```


Initialize mock1

```
./bin/init-exec.sh mock1
```

Execute the mock
```
./migrate.sh
```


## Operating System Requirements
The native client uses the `bash` shell for most of its work, more specifically it uses bash 4.2 features like associative arrays. Although all development and tests of the framework is done on `linux`, the framwork should run on any operating system supporting the `bash` shell.
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
