# writing command line applications

## using *plumbum*

Command line applications are a generalization of the idea of script: the execution of the program is conditioned on some parameters provided by the user.

This is typically done using **options**, **parameters** and **flags**, and are the typical interface used by bash programs.

## Why applications?

functionalities implemented as CLI applications share a lot of the advantages with libraries

1. Commands are repeatable
2. Commands can be shared
3. Commands ca be automated (and this scales well)
4. Commands should be readable
5. Commands can be composed together

In this lesson we will (quickly) overview how to implement one of these program, leveraging a 3rd party library called **plumbum**

Everything we are doing today with **plumbum** can be done in a reasonable way in basic python, but plumbum will provide us a more simple and consistent way of doing it.


```python
import plumbum
# this script uses plumbum version 1.6.9
print(plumbum.__version__)
```

    (1, 6, 9)


## CLI application good practices

### Errors management


#### clean up after yourself, especially on errors
If something goes wrong, try to avoid leaving the system in an invalid state, and clean unnecessary files

#### allow if possible to recover partial results
This is especially important in long executions: take a hint from the snakemake approach, and try to have partial results stored as temporary files to avoid unnecessary repetition when possible

#### try to be robust to bad data and configuration
it is better to do less things, but making sure that those things are well covered and the program will not trow a fit for some input data in an awkward format.

Utilities should handle arbitrarily long lines, huge files, and so on.
It is perhaps tolerable for a utility to fail on a data set larger than it can hold in memory, but some utilities don't do this.
for instance, sort, by using temporary files, can generally sort data sets much larger than it can hold in memory. 

#### Exit with different error codes
this is the values that is returned by the **main**
0 means success, any other number means failure
the best solution is to code each error to a specific return value (and document it)

### User interaction


#### give feedback for task longer than a second or two (such as progress bars)
Users might worry that something has gone wrong and just kill the process if they have to wait without any prompt that the program is doing something.
Even better, try to use a progress bar with a time estimate (plumbum has you covered)

#### let the user control the level of verbosity of the output
include a `--verbose`, a `--terse` and a `--silent` option to allow the user to control the level of feedback they wants

#### Colour code your output

Ideally, your script should:
* output white/default (it’s the foreground process), 
* child processes should output grey (usually not needed unless things screw up), 
* success should be denoted with green, 
* failure, red, and 
* warnings in yellow.

#### Have both short ie one letter (Eg `-h`) and long forms (eg `--help`) of the command's switches
long format helps readability and long term maintanability, and are good for scripting and manuals

short forms are useful for manual input, especially of commonly used options (don't waste the user time)

#### Ask for confirmation for irreversible action
such as deleting data, changing informations without backup, etc...

there should be an option to make this automatic, but the user should be protected from involuntary changes to the system.

Even better, while asking for confirmation, also suggest which is the option to turn it off

### Documentation

#### consider adding a `help` sub command
alongside the `--help` flag, consider including an help command that contains information about various topics

#### provide some use cases in the documentation
Especially if the case uses are not trivial, with many interlocked features interacting with each other.

And, is possible, put them nearby the start of the documentation, rather than at the end.

#### In case of mistakes try suggesting common correction techniques
Git again does this perfectly: when something goes wrong, it also suggest reliable methods to correct the bad situation, without covering this information in "output noise"

#### make common commands memorable
Don't use weird names, inside jokes, abstract references, words referring to implementation details (unless relevant).

keep it simple and easy to remember.

### Configuration


#### Work independently of current working directory
use only absolute paths (/path/to/something) and paths relative to the script (demonstrated below)

#### consider using configuration files
This allows a greater deal of automation and configurability, reducing the load on the user to write all the options by hand.

on the other hand, a configuration file should never be a necessity, and everything should be used as an option

#### all the options that can have a default value, should have one
Ideally, the program should be executable without specifying any option.

compulsory options are probably candidates for sub-commands

### Interface

#### try to be consistent with other GNU tools : 
For example see a list of options from other GNU tools and if possible try to align to them

http://www.catb.org/esr/writings/taoup/html/ch10s05.html

https://www.gnu.org/prep/standards/standards.html

#### play well with pipes and allow input and output to files
To play well with pipes it should read and write to stdout by default, but the user should be free to redirect to file if necessary

#### If a command has a side effect provide a dry-run/whatif/no_post option.
don't let the user jump blindly without checking what would happen.

This also allows the user to find possible mistakes faster and with less risks

Snakemake perfors this very well.

#### everything should be doable in a script, without human interaction
To allow the program to be fully used in script and automated, it should always be possible to execute it without any input from the user.

When possible, this should be the preferred behavior

#### try to make it composable
programs that play nicely with other can be used to implement even more complicated pipelines and programs.

#### conside adding switches to both turn on and off behaviors
If a switch is in the long-form (for example --foo), which turns “on” some behavior (that is off by default), there should also be another switch that turns “off” the behavior.

This allow the user to be more explicit and change-proof the script for future change of default behavior

#### consider using a long informative name for you app

the GNU convention is to use 2 or 3 letters names, but if one can avoid it, the deafult program name should be something either explicit or memorable.

The user has always the option to alias it to something shorter.

#### if no output is necessary, avoid output unless required
that's what the `--verbose` option is for.

if the program performs an action and doesn't have to return a result in case of success (such as moving a file, changing directory, etc...), the user should see an output only in case of errors or if the verbose option is selected.

This makes the program more script friendly

## Preface - utilities

Plumbum provides us some simple utilities to quickly improve the experience of the user when using the application we are writing

### colored text output

```python
from plumbum import colors
# this will not work in jupyter notebooks
print(colors.green & colors.bold | "This is green and bold.")
```

#### note on windows terminal

terminal on windows does not agree with standard color commands.

If you want to have colored output you can either:
* force the usage of color with the global flag `colors.use_color=True`
* use a different library called **colorama**

### image visualization in the terminal

```python
from PIL import Image as imreader
from plumbum.cli.image import Image as imdisplay
im = imreader.open("fractal_wrongness.png")
# does not work with jupyter
imdisplay().show_pil(im)
```

### progress bars


```python
# progress bars
from plumbum.cli.terminal import Progress
import time

for i in Progress.range(10):
    time.sleep(0.2)
```

                                                                                                                                        

### configurations files

python equivalent - **ConfigParser**


```python
%%file .myapp_rc
[DEFAULT]
three=3

[OTHER]
a=3
```

    Overwriting .myapp_rc



```python
from plumbum import cli

with cli.ConfigINI('.myapp_rc') as conf:
    one = conf['three']
    two = conf.get('one', default='2')
    three = conf.get('OTHER.a')
    
    # changing the configuration file
    conf['OTHER.b'] = 4
print(one, two, three)
```

    3 2 3



```python
!cat .myapp_rc
```

    [DEFAULT]
    three = 3
    one = 2
    
    [OTHER]
    a = 3
    b = 4
    


### reading user input

python equivalent -- `rawinput` function


```python
import plumbum.cli.terminal as terminal
# see also ask and prompt
terminal.choose("favorite color?", ['red', 'green', 'blue'], default='blue')
```

    favorite color?
    (1) red
    (2) green
    (3) blue
    Choice [3]: 




    'blue'



### the local computer

python equivalent - **subprocesses**


```python
from plumbum import local
ls = local["ls"]
print(ls().splitlines()[:4])
```

    ['Code dump.ipynb', 'Conda_Environment_instructions.txt', 'directory_structure.png', 'directory_structure.svg']


the `local.cmd` dynamically loads programs from the environment.

There is actually no such package, everything is created on the fly!


```python
from plumbum.cmd import grep, cat
```

Programs can be combined in pipes in the same way as one could do in the bash shell.

these pipes, in the same way as the individual programs, are not run until called


```python
ls|grep['.png']
```




    Pipeline(LocalCommand(/bin/ls), BoundCommand(LocalCommand(/bin/grep), ['.png']))




```python
pipe = ls|grep['.png']
print(pipe())
```

    directory_structure.png
    file_inode_permissions.png
    fractal_wrongness.png
    OS_structure.png
    __temp_ipython__.png
    users_and_groups.png
    


### background and foreground execution
```python
from plumbum import FG, BG
ls["-l"] & FG
```

### input-output redirection
```python
import sys
((grep["world"] < sys.stdin) > "tmp.txt")()
cat("tmp.txt")
```


```python
pipe = (cat << "hello world\nfoo\nbar\spam" | grep["oo"])
pipe()
```




    'foo\n'




```python
# temporarely change the working directory
with local.cwd(local.cwd / "myapp"):
    print(local.cwd)
```

    /home/enrico/didattica/corso_programmazione_1819/programmingCourseDIFA/myapp


### remote connection to other machines


```python
from plumbum import SshMachine
rem = SshMachine("hostname", user = "john", keyfile = "/path/to/idrsa")
rem.close()
```


```python
# connect to a remote machine 
with SshMachine("hostname", user = "john", keyfile = "/path/to/idrsa") as rem:
    pass
```


```python
# temporarely change the working directory in the remote server
with rem.cwd(rem.cwd / "Desktop"):
    print(rem.cwd)
```


```python
# port tunneling
with rem.tunnel(6666, 8888):
    pass
```


```python
# local grep of a remote ls
from plumbum.cmd import grep
r_ls = rem["ls"]
pipe = r_ls | grep["b"]
pipe()
```

# Command line programs

In python any script can be at the same time a library and a command line program. (better to keep them separate anyway, just because you can, doesn't mean that you should!)

All the code in the general section of the script is executed everytime the script is imported as a library, but one can set a part of the code to be run only when the script is called as a command line program.

this is achieved by testing the `__name__` parameter of the program (a special variable that the interpreter set at the start), that when executed as a program is set to the string `"__main__"`.


```python
%%file my_first_app.py

def mysum(a, b):
    return a+b

print("this will be executed everytime")

if __name__=='__main__':
    print("this will be executed only on the command line")
```

    Writing my_first_app.py



```python
# this execute a single python command and quit
!python3 -c "import my_first_app"
```

    this will be executed everytime



```python
!python3 ./my_first_app.py
```

    this will be executed everytime
    this will be executed only on the command line


This method could be used directly to implement very simple applications, by reading the arguments using `sys.argv`, and then parsing them by hand, but it's not very comfortable


```python
%%file my_first_app.py
if __name__=='__main__':
    import sys
    print(sys.argv)
```

    Overwriting my_first_app.py



```python
!python3 ./my_first_app.py arg1 arg2
```

    ['./my_first_app.py', 'arg1', 'arg2']


Python comes with a module that provide automatic arguments and options parsing, and works reasonably well, called `argparse`, that can be used in situations where external libraries can't be installed.

the official tutorial can be found on the [python documentation](https://docs.python.org/dev/howto/argparse.html)

It works, but it creates a code that is usually hard to read and manage when the options get more complicated.

it is also missing all the support classes and functions that plumbum provides and that make easier to create high quality CLI


```python
%%file my_first_app.py
if __name__=='__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("echo", help="echo the string you use here")
    
    args = parser.parse_args()
    
    print("the received string is: {}".format(args.echo))
```

    Overwriting my_first_app.py



```python
!python3 ./my_first_app.py --help
```

    usage: my_first_app.py [-h] echo
    
    positional arguments:
      echo        echo the string you use here
    
    optional arguments:
      -h, --help  show this help message and exit



```python
!python3 ./my_first_app.py to_be_said
```

    the received string is: to_be_said


# Command line classes

command line applications can be imagined as structured in a similar way to a function:

There are a certain number of ordinal arguments, and a certain number of named options.

*flags* are thebinary options, so they relate to named paramaters with boolean options.

Tipically the arguments are the main focus of the program, while the option determines exactly how the execution is performed.
My suggestion would be to allow to always pass values as optsion alongside as arguments, as it allows to improve the readibility of the commands in a script.

The design approach of plumbum is that a program is a class.

Options and flags connect to methods that configure the **self** attributes

Parameters are given to a **main** function that is the method that performs the program execution.

The **main** function have access to the results of the configuration as the configured **self** instance.


```python
%%file my_app.py
from plumbum import cli

class MyApp(cli.Application):
    """returns the square of a number
    """
    PROGNAME = "MyGloriousApp" # these are special values that Plumbum parses
    VERSION = "0.1" # these are special values that Plumbum parses
    
    def main(self, value: float):
        #value = float(value)
        print("result: {}".format(value**2))

if __name__ == "__main__":
    MyApp()
```

    Overwriting my_app.py



```python
!python3 my_app.py --help
```

    MyGloriousApp 0.1
    
    returns the square of a number
    
    Usage:
        MyGloriousApp [SWITCHES] value
    
    Meta-switches:
        -h, --help         Prints this help message and quits
        --help-all         Prints help messages of all sub-commands and quits
        -v, --version      Prints the program's version and quits
    
    [0m


```python
# type decoration is used to enforce arguments type and convert them.
!python3 my_app.py 3
```

    result: 9.0
    [0m


```python
# type decoration is used to enforce arguments type and convert them.
!python3 my_app.py a
```

    Error: Argument of value expected to be <class 'float'>, not 'a':
        ValueError("could not convert string to float: 'a'",)
    ------
    MyGloriousApp 0.1
    
    returns the square of a number
    
    Usage:
        MyGloriousApp [SWITCHES] value
    
    Meta-switches:
        -h, --help         Prints this help message and quits
        --help-all         Prints help messages of all sub-commands and quits
        -v, --version      Prints the program's version and quits
    
    [0m

### using flags
flags and options are separated from the main, and are either functions of attributes of the class


```python
%%file my_app.py
from plumbum import cli

class MyApp(cli.Application):
    PROGNAME = "MyGloriousApp"
    VERSION = "0.1"
    
    verbose = cli.Flag(["v", "verbose"], help = "If given, I will be very talkative")

    def main(self, filename):
        print("I will now read {0}".format(filename))
        if self.verbose:
            print("Yadda " * 200)

if __name__ == "__main__":
    MyApp()
```

    Overwriting my_app.py


Flags and switches can be:

* compulsory
* dependent on each other
* mutually exclusive
* repeatable
* gouped together in the help description
* bound to have specific values


```python
!python3 my_app.py --help
```

    MyGloriousApp 0.1
    
    Usage:
        MyGloriousApp [SWITCHES] filename
    
    Meta-switches:
        -h, --help         Prints this help message and quits
        --help-all         Prints help messages of all sub-commands and quits
        --version          Prints the program's version and quits
    
    Switches:
        -v, --verbose      If given, I will be very talkative
    
    [0m


```python
!python3 my_app.py foo
```

    I will now read foo
    [0m


```python
!python3 my_app.py foo --verbose
```

    I will now read foo
    Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda 
    [0m


```python
!python3 my_app.py foo -v
```

    I will now read foo
    Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda 
    [0m


```python
%%file my_app.py
from plumbum import cli

class MyApp(cli.Application):
    PROGNAME = "MyGloriousApp"
    VERSION = "0.1"
    _log_file = None
    
    @cli.switch("--log-to-file", str)
    def log_to_file(self, filename):
        """Sets the file into which logs will be emitted"""
        self._log_file = filename

    def main(self, filename):
        print("I will now read {0}".format(filename))
        if self._log_file is not None:
            with open(self._log_file, 'w') as outfile:
                print("I will now read {0}".format(filename), file=outfile)

if __name__ == "__main__":
    MyApp()
```

    Overwriting my_app.py



```python
!rm -f temp_log.txt
```


```python
!python3 my_app.py foo --log-to-file temp_log.txt
```

    I will now read foo
    [0m


```python
!cat temp_log.txt
```

    I will now read foo


### sub commands

sub-commands are a way to group together several related program under a single umbrella.

a classical example is **git**.

They are create in plumbum as classes that are linked to the original one.

In argparsers they are defined as subparsers.


```python
%%file my_app.py
from plumbum import cli

class MyApp(cli.Application):
    """returns the square of a number
    """
    PROGNAME = "MyGloriousApp"
    VERSION = "0.1"
    
    def main(self):
        if not self.nested_command:           # will be ``None`` if no sub-command follows
            print("No command given")
            return 1   # error exit code

@MyApp.subcommand("pow")
class MyAppPow(cli.Application):
    "calculate the square power instead"
    def main(self, value, power=2):
        value = float(value)
        power = float(power)
        print("result: {}".format(value**power))    
    
@MyApp.subcommand("sqrt")
class MyAppSqrt(cli.Application):
    "calculate the square root instead"
    def main(self, value):
        value = float(value)
        print("result: {}".format(value**0.5))
        
if __name__ == "__main__":
    MyApp()
```

    Overwriting my_app.py



```python
!python3 my_app.py --help
```

    MyGloriousApp 0.1
    
    returns the square of a number
    
    Usage:
        MyGloriousApp [SWITCHES] [SUBCOMMAND [SWITCHES]] 
    
    Meta-switches:
        -h, --help         Prints this help message and quits
        --help-all         Prints help messages of all sub-commands and quits
        -v, --version      Prints the program's version and quits
    
    Sub-commands:
        pow                calculate the square power instead; see 'MyGloriousApp
                           pow --help' for more info
        sqrt               calculate the square root instead; see 'MyGloriousApp
                           sqrt --help' for more info
    [0m


```python
!python3 my_app.py sqrt --help
```

    MyGloriousApp sqrt 0.1
    
    calculate the square root instead
    
    Usage:
        MyGloriousApp sqrt [SWITCHES] value
    
    Meta-switches:
        -h, --help         Prints this help message and quits
        --help-all         Prints help messages of all sub-commands and quits
        -v, --version      Prints the program's version and quits
    
    [0m


```python
!python3 my_app.py pow --help
```

    MyGloriousApp pow 0.1
    
    calculate the square power instead
    
    Usage:
        MyGloriousApp pow [SWITCHES] value [power=2]
    
    Meta-switches:
        -h, --help         Prints this help message and quits
        --help-all         Prints help messages of all sub-commands and quits
        -v, --version      Prints the program's version and quits
    
    [0m


```python
!python3 my_app.py sqrt 9
```

    result: 3.0
    [0m


```python
!python3 my_app.py pow 3
```

    result: 9.0
    [0m


```python
!python3 my_app.py pow 3 0.5
```

    result: 1.7320508075688772
    [0m

### Subcommands in practice

Try to keep the options between the subcommands coherent: if one implements `--help`, another implements `--documentation`, another implement `--explain` to accedd the help of the function, it is messy. try to maintain consistency in names and behaviors

two subcommands that could probably be useful in most applications are:
* `help` - to provide a more indept documentation of your program, divided by topics (try to type `help()` in Python)
* `config` - to manage local and global configurations of your program

remember: **easy things should be easy, hard things should be possible**.
Designing your CLI is going to take work to obtain a good interface!

# system wide installation

to perform a system wide installation we will use the `setuptools` package, that allows us to interface our program with the pip installation mechanism.

### preparing the field

The first step is to create a proper folder structure for our program.
In this case I'm creating a CLI program called **myapp**.

* **myapp** (project folder)
    * `setupy.py`
    * **myapp** (program folder)
        * `__init__.py`
        * `__main__.py`
        

the outside folder is the project folder, that will contain everything concerning my app: the app itself, its documentation, the installation procedure, and so on.

Then there is an inside folder, usually with the same name of the app, that will contain the proper files to be executed.

Inside this folder there should be a file `__init__.py`.
This file can be empty, but is used by python to recognize that this directory is a module that can be imported or executed.

My application is going to be in the `__main__.py` file. No special reason for the name, just more consistent


```python
!touch ./myapp/myapp/__init__.py
```


```python
%%file ./myapp/myapp/__main__.py
from plumbum import cli

class MyApp(cli.Application):
    """returns the square of a number
    """
    PROGNAME = "MyGloriousApp"
    VERSION = "0.1"
    
    def main(self):
        if not self.nested_command:           # will be ``None`` if no sub-command follows
            print("No command given")
            return 1   # error exit code

@MyApp.subcommand("pow")
class MyAppPow(cli.Application):
    "calculate the square power instead"
    def main(self, value, power=2):
        value = float(value)
        power = float(power)
        print("result: {}".format(value**power))    
    
@MyApp.subcommand("sqrt")
class MyAppSqrt(cli.Application):
    "calculate the square root instead"
    def main(self, value):
        value = float(value)
        print("result: {}".format(value**0.5))
        
if __name__ == "__main__":
    MyApp.run()
```

    Overwriting ./myapp/myapp/__main__.py


The file necessary for setuptools to work properly is the `setup.py`, where we will use the `setup` function of the `setuptools` module.

This function configure many things for us, but the most important thing is the `entry_point` parameter.
This creates the link to the scripts that we will actually execute.
Inside this parameter we specify that two entry points are `console_scripts` that should execute the script and the function provided.


```python
%%file ./myapp/setup.py
from setuptools import setup

setup(
    name = 'myapp',
    version = '0.1.0',
    packages = ['myapp'],
    install_requires=[ 'plumbum', ],
    entry_points = {
        'console_scripts': [
            'myapp = myapp.__main__:MyApp',
            'myappsqrt = myapp.__main__:MyAppSqrt',
        ]
    })
```

    Overwriting ./myapp/setup.py


In this case we decided to let the user use the standard program (choosing the sub command to use) or to provide a shortcut to the subcommand itself.

In this case the plumbum structure comes very useful: we can call directly the subcommand class to execute our subcommand.

the name we put before the `=` sign is going to be the command name that we will use to call the program from the command line

Last special mention goes to the `install_requires`: this list allows to specify all the dependencies of the package.
If they are not installed, they will automatically downloaded and installed by pip.
In our case the only dependency that we have is for the `plumbum` package

### the installation step

from the folder containing the project folder, we can call the pip installation program

by installing it with the `--editable` (or `-e` for short) the program will not be copied in the system, but rather linked in it.
This means that if you edit the program, the modifications will appear live in the systems without need to reinstall


```python
!pip install --editable myapp
```

    Obtaining file:///home/enrico/didattica/corso_programmazione_1819/programmingCourseDIFA/myapp
    Requirement already satisfied: plumbum in /home/enrico/miniconda3/lib/python3.6/site-packages (from myapp==0.1.0) (1.6.7)
    Installing collected packages: myapp
      Running setup.py develop for myapp
    Successfully installed myapp



```python
!myapp --help
```

    MyGloriousApp 0.1
    
    returns the square of a number
    
    Usage:
        MyGloriousApp [SWITCHES] [SUBCOMMAND [SWITCHES]] 
    
    Meta-switches:
        -h, --help         Prints this help message and quits
        --help-all         Prints help messages of all sub-commands and quits
        -v, --version      Prints the program's version and quits
    
    Sub-commands:
        pow                calculate the square power instead; see 'MyGloriousApp
                           pow --help' for more info
        sqrt               calculate the square root instead; see 'MyGloriousApp
                           sqrt --help' for more info
    [0m

We can call the base program or the specific subcommand, as we specified


```python
!myapp sqrt 9 
```

    result: 3.0
    [0m


```python
!myappsqrt 9
```

    result: 3.0
    [0m

Lastly, we can uninstall the program from any location


```python
!pip uninstall -y myapp
```

    Uninstalling myapp-0.1.0:
      Successfully uninstalled myapp-0.1.0


If one needs to shop non-code files (such as images, configuration files, etc...)
check:

https://python-packaging.readthedocs.io/en/latest/non-code-files.html

given that now **myapp** is a system program, I can load it using `plumbum` as any other application!


```python
myapp_hook = local['myapp']
sqrt_hook = myapp_hook['sqrt']
print(sqrt_hook(9))
```

    result: 3.0
    


# Testing CLI

there are two level of testing:
* the internal working
* the interface

the internal work can be tested as any other standard function, so we'll focus on the interface testing.

it's not an easy problem, let's be clear.

there are again two level of testing:
* filesystem I/O
* printing

the printing testing refers to test the output of the program to the stdout and stderr in response to different inputs (for example testing that the `--verbose` flag turn off the printing, while something get printed without it).
To do it, one can use the subprocess module and capture the output, while providing deterministic input
 
Testing the filesystem I/O is more complicated, and in general one have to create fake files and check for the result in them.

some additional things you might want to test:
* change the current working directory before launcing the program, and verify that it doesnt spaz out
* check that you can really get as ipnut files in different directories from where you're working, both as input and output
* What happens when the input file doesn’t exist?
* Does our program exit with an error when we provide wrong arguments?
* does the logging system work as intended?

it is also important to not get wrapped in details: for example testing the formatting of the text of the help flag is not a productive activity.
In th same way, try to avoid testing for things that might be platform dependent, such as the exact python version!

being able to run the CLI programmatically means you can also test with hypothesis.

also, this is not actually dependent on the fact that the program is written in python: you can use these lines to test **any** CLI!


```python
# encoding was introduced in python 3.6
# capture_output was introduced in python 3.7
import subprocess
from subprocess import run
result = run(["python", "--version"], capture_output=True, encoding='utf8')
print(repr(result.stdout))
print(repr(result.stderr))
print(result.returncode)
```

    'Python 3.7.7\n'
    ''
    0



```python
result
```




    CompletedProcess(args=['python', '--version'], returncode=0, stdout='Python 3.7.7\n', stderr='')



the option `shell=True` makes it easier to write complicated command lines where the division is not clear, but never use it to execute user provided lines, **it is a security breach!**


```python
result = run("python --version", shell=True, capture_output=True, encoding='utf8')
result
```




    CompletedProcess(args='python --version', returncode=0, stdout='Python 3.7.7\n', stderr='')



subprocesses allow us also to pass some input to simulate pipes or the interaction with the user.


```python
%%file temp.py
name = input("tell me your name:")
print("hello", name)
```

    Overwriting temp.py



```python
result = run(["python", "temp.py"], input='enrico\n', capture_output=True, encoding='utf8')
result
```




    CompletedProcess(args=['python', 'temp.py'], returncode=0, stdout='tell me your name:hello enrico\n', stderr='')



It also allow us to keep the process alive and to interact with it by using the PIPE object


```python
process = subprocess.Popen(["python", "temp.py"],
                           stdin=subprocess.PIPE,
                           stdout=subprocess.PIPE)
process.stdin.write(b"enrico\n")
print(process.communicate()[0])
process.stdin.close()
```

    b'tell me your name:hello enrico\r\n'


Finally, we can also simulate multiple programs feeding each other I/O to test how are program would behave in a pipeline of various programs.


```python
# The example reproduces the command line:
# $ cat index.rst | grep ".. literal" | cut -f 3 -d:
import subprocess as sp

cat = sp.Popen(['cat', 'index.rst'], stdout=sp.PIPE,)
grep = sp.Popen(['grep', '.. literal::'], stdin=cat.stdout, stdout=sp.PIPE,)
cut = sp.Popen(['cut', '-f', '3', '-d:'], stdin=grep.stdout, stdout=sp.PIPE,)
end_of_pipe = cut.stdout

print('Included files:')
for line in end_of_pipe:
    print(line.decode('utf-8').strip())
```

### testing filesystem I/O

first we need to create unique files that will not likely conflict with existing one.

To do this we can leverage the `uuid` module


```python
import uuid
random_filename = str(uuid.uuid1())
print(random_filename)
```

    1e9598ca-962b-11ea-aade-94992ee33e3e



```python
from pathlib import Path
temp_path = Path('.')/random_filename
assert not temp_path.exists()
temp_path
```




    WindowsPath('1e9598ca-962b-11ea-aade-94992ee33e3e')




```python
temp_path.touch()
assert temp_path.exists()
temp_path.unlink()
assert not temp_path.exists()
```

At this point we can test that our progrma write to the destination as intended we we pass it as an argument!


```python
%%file temp.py
import sys
print("arguments", sys.argv)
with open(sys.argv[1], "w") as outfile:
    print("printed to file!", file=outfile)
```

    Overwriting temp.py



```python
result = run(["python", "temp.py", str(temp_path)], capture_output=True, encoding='utf8')
print(result.stdout)

assert temp_path.exists()

with temp_path.open() as result_file:
    lines = result_file.readlines()
print("printed in file:", lines)

temp_path.unlink()
assert not temp_path.exists()
```

    arguments ['temp.py', '1e9598ca-962b-11ea-aade-94992ee33e3e']
    
    printed in file: ['printed to file!\n']


# Input and Output of CLI programs

Whenever possible parse and print one line at the time, reading from `sys.stdin` and writing to `sys.stdout`.

They might be printing to screen, to file or piped to a different program, depending on the way the program is called.

It is the same philosophy of the iterators!


```python
%%file temp.py
import sys

for line in map(str.strip, sys.stdin):
    s = '-- ' + line + ' --'
    print(s, file=sys.stdout)
```

    Overwriting temp.py



```python
!echo 1|python temp.py
```

    -- 1 --


### MapReduce philosophy

remember that all great unix command line tools are following the filter-map-reduce design with their input and output.

There is a library that actually implement them explicitely!
https://github.com/sharkdp/shell-functools

## Printing for Machines

input-output on terminal in the **JSONlines** formats

one of the advantages of working with JSONlines input and output is that it's easier to write structured tests: one can easily test the content of the output without doing complicated parsing!


```python
%%file temp.py
import sys, json, glob

patterns = sys.argv[1:]
for each_pattern in patterns:
    filenames = glob.glob(each_pattern)
    for each_filename in filenames:
        data = {'filename': each_filename, "pattern": each_pattern}
        # json.dumps takes a python structure and transform in a JSON string
        json_str = json.dumps(data)
        print(json_str, file=sys.stdout)
```

    Overwriting temp.py



```python
!python temp.py *.py *.svg
```

    {"filename": "temp.py", "pattern": "*.py"}
    {"filename": "test.py", "pattern": "*.py"}
    {"filename": "directory_structure.svg", "pattern": "*.svg"}
    {"filename": "file_inode_permissions.svg", "pattern": "*.svg"}
    {"filename": "OS_structure.svg", "pattern": "*.svg"}
    {"filename": "users_and_groups.svg", "pattern": "*.svg"}



```python
%%file count_by.py
import sys, json, glob
from collections import Counter
counts = Counter()
pattern = sys.argv[1]

for line in map(str.strip, sys.stdin):
    # json.dumps takes a JSON string and transform in a python structure
    data = json.loads(line)
    value = data[pattern]
    counts[value] += 1
    
json_str = json.dumps(counts)
print(json_str, file=sys.stdout)
```

    Overwriting count_by.py



```python
!python temp.py *.py *.svg | python count_by.py pattern
```

    {"*.py": 3, "*.svg": 4}


How to interact with programs that do not return valid JSONlines?


```python
!python -c "from glob import glob;print(*glob('*.py'), sep='\n')"
```

    count_by.py
    JSONifier.py
    temp.py
    test.py



```python
%%file JSONifier.py
import sys, json
pattern = sys.argv[1]
for line in map(str.strip, sys.stdin):
    data = {pattern: line}
    json_str = json.dumps(data)
    print(json_str, file=sys.stdout)
```

    Overwriting JSONifier.py



```python
!python -c "from glob import glob;print(*glob('*.py'), sep='\n')" | python JSONifier.py filename
```

    {"filename": "count_by.py"}
    {"filename": "JSONifier.py"}
    {"filename": "temp.py"}
    {"filename": "test.py"}


This kind of output is extremely useful for logs as well, as it makes them way easier to parse with automatic tools!

## Printing for Humans

using the format controls


```python
import math
print("{:.4}".format(math.pi))
```

    3.142



```python
# Example 1
print('L {:<20} R'.format('x'))
# Example 2
print('L {:^20} R'.format('x'))
# Example 3
print('L {:>20} R'.format('x'))
```

    L x                    R
    L          x           R
    L                    x R



```python
print ('{:=<20}'.format('hello'))
print ('{:_^20}'.format('hello'))
print ('{:.>20}'.format('hello'))
```

    hello===============
    _______hello________
    ...............hello



```python
users = [["Alice", 20],
         ["Bob", 30],
         ["Carol", 25],
         ["Dave", 32],
        ]
columns = ["name", "age"]
```


```python
print('{:<10s}{:>4s}'.format(*columns))
for name, age in users:
    print('{:<10s}{:>4d}'.format(name, age))
```

    name       age
    Alice       20
    Bob         30
    Carol       25
    Dave        32



```python
# use the vertical and horizontal lines to format it according to
# markdown syntax, so that you can have nicely formatted text
print('|{:<10s}|{:>4s}|'.format(*columns))
print('|{:<10s}|{:>4s}|'.format('-'*10, '-'*4))
for name, age in users:
    print('|{:<10s}|{:>4d}|'.format(name, age))
```

    |name      | age|
    |----------|----|
    |Alice     |  20|
    |Bob       |  30|
    |Carol     |  25|
    |Dave      |  32|


By printing in that format you can copy and paste and obtain a nicely formatted MarkDown table!

|name      | age|
|---       | ---|
|Alice     |  20|
|Bob       |  30|
|Carol     |  25|
|Dave      |  32|


```python
# you can use variables to set the formatting by enclosing 
# the name in curly brackets inside the other curly brakets!
size1, size2 = 8, 4
print('|{:<{s1}s}|{:>{s2}s}|'.format(*columns, s1=size1, s2=size2))
print('|{:<{s1}s}|{:>{s2}s}|'.format('-'*size1, '-'*size2, s1=size1, s2=size2))
for name, age in users:
    print('|{:<{s1}s}|{:>{s2}d}|'.format(name, age, s1=size1, s2=size2))
```

    |name    | age|
    |--------|----|
    |Alice   |  20|
    |Bob     |  30|
    |Carol   |  25|
    |Dave    |  32|


#### tetwrapping - adatting to different terminal lenght

the library `textwrap` allow us to flow the text inside a narrow terminal, or to clip the text if the line is too long.


```python
import textwrap
```


```python
s = "some crazy long string that we might need to break on multiple lines"
print(textwrap.fill(s, 15))
```

    some crazy long
    string that we
    might need to
    break on
    multiple lines



```python
s = "another craxy string to be hidden"
textwrap.shorten(s, width=19, placeholder=" [...]")
```




    'another craxy [...]'



### Differentiate output if on terminal or not

this is really tricky to test, but it might be useful to print something different when talking to other programs (probably JSONlines) and humans (simple english, maybe with colors and decorations).

the trick is to use `sys.stdout.isatty()`, that returns true for a terminal aimed to be read by a human.

The only problem is that capturing the output (such as what the notebook does) trick the program into thinking that it's talking to a machine, and so the output will be the machine-oriented one!
This can make testing this functionality a pain...

personally I prefer two different options:
* generate human readable by default, and generate json with a `--json` flag (or vice-versa)
* always generate json data, but also write a **prettifier**, that take the json as input and print out a nice, human, text (the solution used by the loggin library `eliot`)


```python
%%file temp.py
from sys import stdout
with open("temp.txt", "w") as outfile:
    if stdout.isatty():
        print('The output device is a teletype. Or something like a teletype.', file=outfile)
    else:
        print("The output device isn't like a teletype.", file=outfile)
```

    Overwriting temp.py



```python
result = run(["python", "temp.py"], input='enrico\n', capture_output=True, encoding='utf8')
with open("temp.txt") as file:
    for line in file:
        print(line.strip())
```

    The output device isn't like a teletype.



```python
result = run(["python", "temp.py"], input='enrico\n', encoding='utf8')
with open("temp.txt") as file:
    for line in file:
        print(line.strip())
```

    The output device is a teletype. Or something like a teletype.


### dot aligned numbers

printing numbers aligned on their decimal point is a common useful features, but not an simple one to perform, because the actual alignment depends on **all** the numbers included, so it can't be done on a number-by-number basis without some assumption first.

basically one have to split the numbers in before and after the dot, and align the two separately!

I'll provide you a simple function to do the alignment on a single number.
It's not covering all corner cases, but it provides a reasonable starting point if you want to personalize the implementation


```python
def dot_format(number, left_pad, right_pad, padding=''):
    big, small = str(float(number)).split('.')
    format_str = "{b:>{s1}s}.{s:{pad}<{s2}s}"
    result = format_str.format(
        b=big,
        s=small,
        pad=padding,
        s1=left_pad,
        s2=right_pad)
    return result
```


```python
print(dot_format(2, left_pad=2, right_pad=3))
print(dot_format(3.14, left_pad=2, right_pad=3))
print(dot_format(12.1, left_pad=2, right_pad=3))
```

     2.0  
     3.14 
    12.1  



```python
print(dot_format(2, left_pad=2, right_pad=3, padding='0'))
print(dot_format(3.14, left_pad=2, right_pad=3, padding='0'))
print(dot_format(12.1, left_pad=2, right_pad=3, padding='0'))
```

     2.000
     3.140
    12.100



```python
from functools import partial
my_format = partial(dot_format, left_pad=2, right_pad=3, padding='0')
numbers = [2, 3.14, 12.127]
for each_number in numbers:
    print(my_format(each_number))
```

     2.000
     3.140
    12.127


#### Special characters

Python can print almost the full unicode spectrum, use it!

Dingbats: `"✓"`, `"✗"`

blocks: `"▀▁▂▃▄▅▆▇█▉▊▋▌▍▎▏▐░▒▓▔▕▖▗▘▙▚▛▜▝▞▟"`

emoji: `"😆"`, `"👍"`



```python
print('\U0001F606') 
print("👍")
```

    😆
    👍


### inputting passwords

sometimes it's encessary, and it's a good practice to hide them while we type them, to make sure that nobody can spot them.

**Please be careful and never store password in your programs!**


```python
import getpass
pwd = getpass.getpass(prompt='Password: ')
print(pwd)
```

    Password: ········
    ciao


## final readings

Eric Raymond: **The Art of Unix Programming**:
* http://www.catb.org/~esr/writings/taoup/html/index.html

Jeroen Janssens, **Data Science at the Command Line**
* https://www.datascienceatthecommandline.com/

# Exercise

Write a personal knowledge database app.

this app should:
* add new notes
* show notes
* search notes based on words contained in them

## advanced

* set tags, also in previously created notes
* filter by tags (including logic of tags to use or not)
* filter by date

https://codeburst.io/13-tips-tricks-for-writing-shell-scripts-with-awesome-ux-19a525ae05ae

https://eng.localytics.com/exploring-cli-best-practices/

https://amir.rachum.com/blog/2017/07/28/python-entry-points/

# Extra Material

### sending email from the script

**DO NOT STORE PASSWORDS**

**ESPECIALLY FOR YOUR UNIBO ACCOUNT!!!**

Fancy emails and attachments can be sent using the email-mime package (already incuded in python)

https://docs.python.org/3/library/email.mime.html


```python
import smtplib, ssl, getpass

port = 587
smtp_server = "smtp.office365.com"
user = "enrico.giampieri@unibo.it"
password = getpass.getpass(prompt='Password: ')

receiver = "enrico.giampieri@unibo.it"
# the empty line divides the header from the body
msg = """Subject: Hi there

This message is sent from Python.
""" 
```


```python
# Create a secure SSL context
context = ssl.create_default_context()
with smtplib.SMTP(smtp_server, port) as server:
    # Secure the connection
    server.starttls(context=context) 
    server.login(user, password)
    server.sendmail(user, receiver, msg)
```

now, if for some reason you decide that saving the password is fundamental (for example to allow the user to login again in the future without retyping them).... please reconsider it!

Now, if it is **really** necessary, then at least you need to:
* *salt* the password (add a fixed value to it that might depend on the user name or access domain)
* generate a random *cryptographic key* individual to the user
* encrypt the *salted key* and save it somewhere
* store the *cryptographic key* somewhere different
* delete the password and *cryptographic key* from memory once you're done

*salting* a password means to modify it somehow (for example by prepending the username) so that the
crypted values does not depend only on the password, making it harder to break with frequency based attacks

and when you need to acces in the future:
* load the user's *cryptographic key*
* load the *encrypted salted key*
* uncrypt it
* unsalt it
* use it
* delete the password and *cryptographic key* from memory once you're done

the reason to delete it from memory afterward is to avoid that a program crash could unintentionaly display it in clear view.

to implement the steps above you can use the library **cryptography**


```python
from cryptography.fernet import Fernet
salt = b"myusername" # this should depend on the username or the domain, don't always use the same
key = Fernet.generate_key() # save this!!!
message = b"my_important_password"

cipher_suite = Fernet(key)
salted_message = salt+message # this is a very trivial salting, could use something smarter
cipher_text = cipher_suite.encrypt(salted_message)

print(cipher_text)

salted_text = cipher_suite.decrypt(cipher_text)
plain_text = salted_text[len(salt):] # inverse operation of the salting
assert plain_text == message
```

    b'gAAAAABewB2M-k1o9Eh4aBpEnWXc1YvZUncNuXe7_B1ZU6Ym7waVA0JynvRLktfL5igCekLg4ZVQrO9S33tj2lEUHT9CB5F_FfcFE-Gj8JjcSM4VeTJBTds='



```python
key
```




    b'r-62ZvVmkg_L1UiaeU7pK6N4uOW36y1Ybhtm9Y_okZw='



Cryptography is a **very complicated** topic (and I'm not an expert in it), and I **strongly suggest you to not try** to do things yourself as much as possible!

### Spark plots
sometimes it is useful to create very simple graphs in the terminal to represents some data.
To do this you can use some special characters to show your results in a sintetic way!

I'll show some simple functions to represent data in the terminal (that you can combine with things like colors and so on), but if you need there are entire libraries that provide proper plotting functions in a ascii terminal! 

https://github.com/glamp/bashplotlib


```python
bar = '▁▂▃▄▅▆▇█'
barcount = len(bar)
 
def sparkline(numbers):
    mn, mx = min(numbers), max(numbers)
    extent = mx - mn
    sparkline = ''.join(bar[min([barcount - 1,
                                 int((n - mn) / extent * barcount)])]
                        for n in numbers)
    return mn, mx, sparkline

data = [8, 2, 3, 5, 1, 1, 4]
mn, mx, sp = sparkline(data)
print(sp)
```

    █▂▃▅▁▁▄


another commonly used option is to print an histogram by printing a number of gliphs equal to the count


```python
data = [8, 2, 3, 5, 1, 1, 4]
for each_value in data:
    print("="*each_value, each_value)
```

    ======== 8
    == 2
    === 3
    ===== 5
    = 1
    = 1
    ==== 4



```python
blocks=  "▀▁▂▃▄▅▆▇█▉▊▋▌▍▎▏▐░▒▓▔▕▖▗▘▙▚▛▜▝▞▟"
# https://en.wikipedia.org/wiki/Geometric_Shapes
symbols_set_1 = "■□▢▣▤▥▦▧▨▩▪▫▬▭▮▯"
symbols_set_2 = "▰▱▲△▴▵▶▷▸▹►▻▼▽▾▿"
symbols_set_3 = "◀◁◂◃◄◅◆◇◈◉◊○◌◍◎●"
symbols_set_4 = "◐◑◒◓◔◕◖◗◘◙◚◛◜◝◞◟"
symbols_set_5 = "◠◡◢◣◤◥◦◧◨◩◪◫◬◭◮◯"
symbols_set_6 = "◰◱◲◳◴◵◶◷◸◹◺◻◼◽◾◿"
# tables and box drawing
# https://en.wikipedia.org/wiki/Box_Drawing_(Unicode_block)
box_borders_1_of_many = "─━│┃┄┅┆┇┈┉┊┋┌┍┎┏"
# arrows and symbols
# https://en.wikipedia.org/wiki/Miscellaneous_Symbols_and_Arrows
arrows_1_of_many = "⬀⬁⬂⬃⬄⬅⬆⬇⬈⬉⬊⬋⬌⬍⬎⬏"
#https://en.wikipedia.org/wiki/Mathematical_operators_and_symbols_in_Unicode
math_1_of_too_many = "∀∁∂∃∄∅∆∇∈∉∊∋∌∍∎∏"
superscripts = "⁰¹²³⁴⁵⁶⁷⁸⁹" + "ⁱ ⁺ ⁻ ⁼ ⁽ ⁾ ⁿ"
underscripts = "₀₁₂₃₄₅₆₇₈₉ ₊ ₋ ₌ ₍ ₎" + "ₐₑₒₓₔₕ ₖ ₗ ₘ ₙ ₚ ₛ ₜ "
greek_letters= "αβγ…" # and all the others
```

you can use the `'\b'` (**b**ackspace) character to delete the previous one

you can use the carriage return character `'\r'` (carriage **r**eturn) to move back on the line and the print over the old content.

the character `'\r'` **does not delete** the previous characters, just move the position of the cursor to the start of the line!


```python
print("a\b")
```

    a



```python
print("a\r")
```

    a



```python
print("aa\rb")
```

    b



```python
from itertools import cycle
from time import sleep

for idx, frame in enumerate(cycle(r'-\|/-\|/')):
    print('\r', frame, sep='', end='', flush=True)
    sleep(0.2)
    if idx>30:
        print('\r', ' ', sep='', end='', flush=True)
        break

```

     

### Notifications


```python
# play a chime sound, useful to signal the end of some operation
print('\a')
```

    


# Internationalization (i18n)

is based on the locale module, allow to print numbers and currencies according to the user preferences (if set)

you would also need to take care of timezones, and translations.

They are all a massive pain, be aware!

https://lokalise.com/blog/beginners-guide-to-python-i18n/

https://phrase.com/blog/posts/translate-python-gnu-gettext/


```python
import locale
import os
# Default settings based on the user's environment.
locale.setlocale(locale.LC_ALL, '')

# What is the locale?
print('\nLocale from environment:', locale.getlocale())
```

    
    Locale from environment: ('English_United States', '1252')



```python
sample_locales = [
    ('UK', 'en_GB'),
    ('France', 'fr_FR'),
    ('China', 'zh-cn'),
    ('Italy', 'it_IT'),
    ('Poland', 'pl_PL'),
]
```


```python
for name, loc in sample_locales:
    locale.setlocale(locale.LC_ALL, loc)
    print('{:>13}: {:>13}  {:>13}'.format(
        name,
        locale.currency(1234.5678),
        locale.currency(-1234.5689),
    ))
```

               UK:      £1234.57      £-1234.57
           France:     1234,57 €     -1234,57 €
            China:      ￥1234.57      ￥1234.57-
            Italy:     1234,57 €     -1234,57 €
           Poland:    1234,57 zł    -1234,57 zł



```python
print('{:>10} {:>10} {:>15}'.format('Locale', 'Integer', 'Float'))
for name, loc in sample_locales:
    locale.setlocale(locale.LC_ALL, loc)

    print('{:>10}'.format(name), end=' ')
    print(locale.format_string('%10d', 123456, grouping=True), end=' ')
    print(locale.format_string('%15.2f', 123456.78, grouping=True))
```

        Locale    Integer           Float
            UK    123,456      123,456.78
        France    123 456      123 456,78
         China    123,456      123,456.78
         Italy    123.456      123.456,78
        Poland    123 456      123 456,78

