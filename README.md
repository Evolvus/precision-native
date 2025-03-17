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

1. **python3** version ** > 3.11**
2. Precision-100 Framework
3. Precision-100 Operators

**python3** version should be **> 3.11**
   
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
python3 -m pip install --index-url https://test.pypi.org/simple precision_100_orcl_operators

```

### Execution
To execute the project, follow the below steps,

#### Configure the project

```
./bin/configure-project.sh
```

##### Select the protocol for the project location (FILE or GIT location) *(screenshot below)*
<img width="597" alt="Select the protocol to fetch the data" src="https://github.com/user-attachments/assets/136cd94b-5754-44a4-bd82-cb4a556c8d1e" />


##### Select the URI of the project to be executed *(screenshot below)*
<img width="830" alt="Select the URI to fetch the data" src="https://github.com/user-attachments/assets/8c3a9040-ae7f-4d2d-a515-50585c63eb89" />


##### Select the name of the project to be executed *(screenshot below)*
<img width="830" alt="Give a name for the project" src="https://github.com/user-attachments/assets/bd14b720-8747-4b4a-8e5e-e742e84eddbb" />

##### Upon successfull configuration
<img width="860" alt="Screenshot 2025-02-12 at 1 06 37 PM" src="https://github.com/user-attachments/assets/87327894-0b20-492a-9d29-e26a81bf18bb" />



#### Initialize mock1

```
./bin/init-exec.sh mock1
```
##### Upon successfull initialization of the mock
<img width="860" alt="Start mock successfully" src="https://github.com/user-attachments/assets/d84e244e-7965-41d0-ba27-f6d012b0d7b0" />

#### Execute the mock

```
./migrate.sh
```

##### The mock execution brings up the all the menus available for the precison 100 project.
<img width="488" alt="Screenshot 2025-02-12 at 2 26 48 PM" src="https://github.com/user-attachments/assets/971de739-d87f-463a-bc1e-494448d1b452" />



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
