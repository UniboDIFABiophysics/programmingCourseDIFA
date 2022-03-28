# writing command line applications


Command line applications are a generalization of the idea of script: the execution of the program is conditioned on some parameters provided by the user.

This is typically done using **options**, **parameters** and **flags**, and are the typical interface used by bash programs.

## Why applications?

functionalities implemented as CLI applications share a lot of the advantages with libraries

1. Commands are repeatable
2. Commands can be shared
3. Commands can be automated (and this scales well)
4. Commands should be readable
5. Commands can be composed together

In this lesson we will present how to use the standard library of python to create CLI applications.

There are a **huge** number of libraries dedicated to help you generating good CLI applications, but they might not be available on most systems and have conflicting requirements.

We will see how to implement the vast majority of what we need from basic python, and you will then be free to try out other approaches.

Some libraries that you might want to check out to explore other approaches to CLI generation are:

* plumbum
* click

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

Here I'll show how to implement some simple utilities to quickly improve the experience of the user when using the application we are writing

### colored text output

On nix systems the terminals support natively colored text.

to show it one needs to change the style configuration with specific strings, and reset them afterwards.

to show normal red text on yellow background, the string is `\033[2;31;43m`

To reset the styles, the string is `\033[0;0m`.

the style string contains 3 terms:
* style
* foreground color
* background color

depending on the terminal, the choice of colors might be more or less rich.

a detailed explaination of the (relatively complex) set of possible values can be seems here:

* https://stackoverflow.com/a/28938235/1784138

my preferred approach is to use a simple context manager to write a whole line with the same style.

One could change multiple styles in the same line, but I'm not a big fan of that.

It should also be noted that these characters should not be written to text or logging!
We'll see at the end of the lesson how to distinguish if the text is being printed out or printed to text.


```python
from contextlib import contextmanager

@contextmanager
def highlighted_text():
    print('\033[2;31;43m', end='')
    try:
        yield
    finally:
        print("\033[0;0m", end='')
```


```python
with highlighted_text():
    print("ciao")
print("mondo")
```

    [2;31;43mciao
    [0;0mmondo


#### note on windows terminal

terminal on windows does not follow the same standards as nix systems on how to display colors.

To colorize ouput on windows you'll need specific libraries such as **colorama**

### progress bars

progress bars are an extremely useful way of displaying information to the users that the program is running.

There are several libraries dedicated to generate progress bars of various kinds.

here I'll display a simple "rotating" progress bar, that can be applied to any for-loop, using braille characters

(you will need to copy-paste and try yourself to see the result)


```python
from itertools import cycle

def progress(iterator):
    cycling = cycle("⡇⣆⣤⣰⢸⠹⠛⠏")
    for element in iterator:
        print(next(cycling), end="\r")
        yield element
    print(" \r", end='')
```


```python
import time
for idx in progress(range(10)):
    time.sleep(0.5)
print("finished!")
```

    finished!


### configurations files and defaults

Being able to lead configuration from files is extremely useful, as it allows to costumize the behavior of the program.

This can be perfect by being combined with reading from the environment variables and applying sensible defaults.

To obtain this result we will use three default libraries:

* ConfigParser (to read the config files)
* collections.ChainMap (to manage defaults and priority in configuration)
* os.environ (to manage the environment variables)

#### configuration files

they allow to define the behavior in a more or less permanent way (as long as the file exists).


```python
%%file .myapp_rc
[DEFAULT]
three=3

[OTHER]
a=3
```

    Overwriting .myapp_rc



```python
import configparser
```


```python
config = configparser.ConfigParser()
config.read('.myapp_rc')
```




    ['.myapp_rc']




```python
# it contains also the
list(config["OTHER"].items())
```




    [('a', '3'), ('three', '3')]




```python
# by default it will return lists
config["OTHER"]["a"]
```




    '3'




```python
# we can force it to return and int (or a float, or a bool)
config["OTHER"].getint("a")
```




    3



#### environment variables

they are useful when one want to set the behavior for the whole session, but not store it long term.

all the executions during the session will share the same config.


```bash
%%bash
MY_ENV_VAR=1
echo $MY_ENV_VAR
```

    1



```bash
%%bash
export MY_ENV_VAR=1
echo $MY_ENV_VAR
python -c "import os; print(os.environ['MY_ENV_VAR'])"
```

    1
    1


#### chaining configuration

The class `ChainMap` allows to combine several dictionaries in order of priority, returing the value of the first dictionary in which the key is found.

This can be used to properly handle user configuration in order of logical priority:

* arguments passed to the program (we'll discuss it later using argparse)
* environment variables
* local/user configuration files
* global configuration files
* fundamental program default (a simple dictionary in the program)


```python
from collections import ChainMap
```


```python
import os
default_config = dict(a='4', b='5')
final_config = ChainMap(os.environ, config["OTHER"], default_config)
```


```python
# take it from the config file
final_config['a']
```




    '3'




```python
# take it from the default configuration
final_config['b']
```




    '5'



### reading user input

There are two main functions to read user input: 
* `input` for standard text
* `getpass.getpass` for passwords

In general I strongly discourage relying on user input for managing the program, and strongly suggest to rely on configurations of various kind.

If the program actually needs to be interactive (to generate a REPL), one can use the **cmd** default library (but I'm not going to cover that today)

### Path objects

to manipulate file and directory locations, the best (and most cross-platform) way to do it is to use the **pathlib** library, that defines a `Path` object.


```python
from pathlib import Path
```


```python
Path.home()
```




    PosixPath('/home/enrico')




```python
p = Path.home()/"didattica"/"programmingCourseDIFA"
p
```




    PosixPath('/home/enrico/didattica/programmingCourseDIFA')




```python
p.exists()
```




    True




```python
p.is_dir()
```




    True




```python
p.is_file()
```




    False




```python
list(p.iterdir())[:3]
```




    [PosixPath('/home/enrico/didattica/programmingCourseDIFA/Lesson_08_Data_pipelines_and_Snakemake.html'),
     PosixPath('/home/enrico/didattica/programmingCourseDIFA/README.md'),
     PosixPath('/home/enrico/didattica/programmingCourseDIFA/Lesson_AF_09_random_sampling_and_statistics.slides.html')]




```python
# simple globbing
list(p.glob("*.txt"))[:3]
```




    [PosixPath('/home/enrico/didattica/programmingCourseDIFA/temp.txt'),
     PosixPath('/home/enrico/didattica/programmingCourseDIFA/Conda_Environment_instructions.txt')]




```python
# recursive globbing
list(p.rglob("*.txt"))
```




    [PosixPath('/home/enrico/didattica/programmingCourseDIFA/temp.txt'),
     PosixPath('/home/enrico/didattica/programmingCourseDIFA/Conda_Environment_instructions.txt'),
     PosixPath('/home/enrico/didattica/programmingCourseDIFA/divine_comedy/divina_commedia_with_copyright_notice.txt'),
     PosixPath('/home/enrico/didattica/programmingCourseDIFA/divine_comedy/divinacommedia_cleaned.txt')]




```python
for item in p.iterdir():
    if item.is_dir():
        relative_item = item.relative_to(p)
        print(relative_item)
```

    .ipynb_checkpoints
    immagini
    Lesson_01_introduction_files
    Lesson_AF_03_continuous_time_random_walks_files
    .mypy_cache
    Lesson_AF_09_random_sampling_and_statistics_files
    Lesson_09_DataFrame_and_Pandas_files
    .git
    Lesson_AF_02_Differential_Equations_analysis_files
    divine_comedy
    Lesson_06_Vectorization_files
    Lesson_10_object_oriented_programming_sklearn_files
    .snakemake
    snakemake_exercise
    Lesson_AF_01_random_generation_and_montecarlo_files
    Lesson_07_Scientific_computation_libraries_files


if you want to make sure that a file exists before opening, one can use `Path.touch`, that will create an empty file if none exists


```python
p = Path('Lesson_AF_08_Documentation_and_API.ipynb')
p
```




    PosixPath('Lesson_AF_08_Documentation_and_API.ipynb')




```python
p.exists()
```




    True




```python
p.name
```




    'Lesson_AF_08_Documentation_and_API.ipynb'




```python
p.stem
```




    'Lesson_AF_08_Documentation_and_API'




```python
p.suffixes
```




    ['.ipynb']




```python
p.with_suffix(".py")
```




    PosixPath('Lesson_AF_08_Documentation_and_API.py')




```python
p.absolute()
```




    PosixPath('/home/enrico/didattica/programmingCourseDIFA/Lesson_AF_08_Documentation_and_API.ipynb')




```python
p.absolute().relative_to(Path.home()/"didattica")
```




    PosixPath('programmingCourseDIFA/Lesson_AF_08_Documentation_and_API.ipynb')




```python
p = Path("non_existing_dir")
p.mkdir(exist_ok=True)
assert p.exists()
# before removing, the directory must be empty!
p.rmdir()
assert not p.exists()
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
!python -c "import my_first_app"
```

    this will be executed everytime



```python
!python ./my_first_app.py
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
!python ./my_first_app.py arg1 arg2
```

    ['./my_first_app.py', 'arg1', 'arg2']


Python comes with a module that provide automatic arguments and options parsing, and works reasonably well, called `argparse`, that can be used in situations where external libraries can't be installed.

the official tutorial can be found on the [python documentation](https://docs.python.org/dev/howto/argparse.html)

It works, but it creates a code that can be hard to read and manage when the options get more complicated.

it is also missing all the support classes and functions that other libraries provides and that make easier to create high quality CLI.

But it is also always avaiable and it is still a very powerful library, in particular when combined with the option management discussed earlier, and it is worth knowing about!


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
!python ./my_first_app.py --help
```

    usage: my_first_app.py [-h] echo
    
    positional arguments:
      echo        echo the string you use here
    
    optional arguments:
      -h, --help  show this help message and exit



```python
!python ./my_first_app.py to_be_said
```

    the received string is: to_be_said


the parsed arguments are structures as a simple object (a `NamedSpace`)


```python
%%file my_first_app.py
if __name__=='__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("echo", help="echo the string you use here")
    
    args = parser.parse_args()
    
    print("the received arguments are: {}".format(args))
```

    Overwriting my_first_app.py



```python
!python ./my_first_app.py to_be_said
```

    the received arguments are: Namespace(echo='to_be_said')


The return value of the parsing is an object and as such does not play well with the ChainMap discussed earlier.

A simple solution is to transform it in a dictionary using the `vars` function


```python
%%file my_first_app.py
if __name__=='__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("echo", help="echo the string you use here")
    args = parser.parse_args()
    args_dict = vars(args)
    assert isinstance(args_dict, dict)
    print(args_dict)
```

    Overwriting my_first_app.py



```python
!python ./my_first_app.py to_be_said
```

    {'echo': 'to_be_said'}


# Command line arguments structure

command line applications can be imagined as structured in a similar way to a function:

There are a certain number of ordinal arguments, and a certain number of named options.

*flags* are the binary options, so they relate to named paramaters with boolean options.

Tipically the arguments are the main focus of the program, while the option determines exactly how the execution is performed.

My suggestion would be to allow to always pass values as options alongside as arguments, as it allows to improve the readibility of the commands in a script.


```python
%%file my_app.py
if __name__=='__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("value", help="value to be squared", type=float)
    
    args = parser.parse_args()
    
    print(args.value**2)
```

    Writing my_app.py



```python
!python my_app.py --help
```

    usage: my_app.py [-h] value
    
    positional arguments:
      value       value to be squared
    
    optional arguments:
      -h, --help  show this help message and exit



```python
# type is used to enforce arguments type and convert them.
!python my_app.py 3
```

    9.0



```python
# type is used to enforce arguments type and convert them.
!python my_app.py a
```

    usage: my_app.py [-h] value
    my_app.py: error: argument value: invalid float value: 'a'


### using flags
flags and options are separated from the main, and are either functions of attributes of the class


```python
%%file my_app.py
if __name__=='__main__':
    import argparse
    parser = argparse.ArgumentParser()
    # positional arguments
    parser.add_argument("filename", help="file to be read")
    # named argument, default to False, True is present
    parser.add_argument("-v", "--verbose", help="increase output verbosity", action="store_true")
    
    args = parser.parse_args()
    
    print(f'I will now read the file "{args.filename}"')
    
    if args.verbose:
        print("Yadda "*30)
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
!python my_app.py --help
```

    usage: my_app.py [-h] [-v] filename
    
    positional arguments:
      filename       file to be read
    
    optional arguments:
      -h, --help     show this help message and exit
      -v, --verbose  increase output verbosity



```python
!python my_app.py foo
```

    I will now read the file "foo"



```python
!python my_app.py foo --verbose
```

    I will now read the file "foo"
    Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda 



```python
!python3 my_app.py foo -v
```

    I will now read the file "foo"
    Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda Yadda 



```python
%%file my_app.py
if __name__=='__main__':
    import argparse
    parser = argparse.ArgumentParser()
    
    # positional arguments
    parser.add_argument("filename", help="file to be read")
    
    # named argument, default to False, True is present
    # has an optional short form
    parser.add_argument("-v", "--verbose", help="increase output verbosity", action="store_true")
    
    # named argument, takes a string as a value
    # has no short version
    parser.add_argument("--log-to-file", help="Sets the file into which logs will be emitted", type=str)
    
    args = parser.parse_args()
    
    print(f'I will now read the file "{args.filename}"')
    if args.log_to_file is not None:
        with open(args.log_to_file, 'w') as outfile:
            print("I will now read {0}".format(args.filename), file=outfile)
    
    if args.verbose:
        print("Yadda "*30)
```

    Overwriting my_app.py



```python
!python my_app.py foo
```

    I will now read the file "foo"



```python
!python my_app.py foo --log-to-file temp_log.txt
```

    I will now read the file "foo"



```python
!cat temp_log.txt
```

    I will now read foo


### sub commands

sub-commands are a way to group together several related program under a single umbrella.

a classical example is **git**.

In argparsers they are defined as subparsers.


```python
%%file my_app.py
if __name__=='__main__':
    import argparse
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(help='possible actions', dest='subparser')
    
    square_parser = subparsers.add_parser('pow', help='calculate the square power')
    square_parser.add_argument("value", help="value to be squared", type=float)
    # optional argument
    square_parser.add_argument("power", 
        help="power to raised at", 
        type=float,
        nargs='?', # this argument might be absent
        default=2, # the default value it takes if it absent
    )
    
    sqrt_parser = subparsers.add_parser('sqrt', help='calculate the square root')
    sqrt_parser.add_argument("value", help="value to be square rooted", type=float)
    
    args = parser.parse_args()
    print(args)
```

    Overwriting my_app.py



```python
!python my_app.py --help
```

    usage: my_app.py [-h] {pow,sqrt} ...
    
    positional arguments:
      {pow,sqrt}  possible actions
        pow       calculate the square power
        sqrt      calculate the square root
    
    optional arguments:
      -h, --help  show this help message and exit



```python
!python my_app.py pow --help
```

    usage: my_app.py pow [-h] value [power]
    
    positional arguments:
      value       value to be squared
      power       power to raised at
    
    optional arguments:
      -h, --help  show this help message and exit



```python
!python my_app.py sqrt --help
```

    usage: my_app.py sqrt [-h] value
    
    positional arguments:
      value       value to be square rooted
    
    optional arguments:
      -h, --help  show this help message and exit



```python
!python my_app.py pow 1
```

    Namespace(power=2, subparser='pow', value=1.0)


in general, to manage more complex programs, it is better to break apart the logic in several functions

it will come back useful later when we consider installing the application!


```python
%%file my_app.py
import argparse

def main_square(args):
    print(args.value**args.power)
    
def main_sqrt(args):
    print(args.value**0.5)

def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(help='possible actions', dest='subparser')
    
    square_parser = subparsers.add_parser('pow', help='calculate the square power')
    square_parser.add_argument("value", help="value to be squared", type=float)
    # optional argument
    square_parser.add_argument("power", 
        help="power to raised at", 
        type=float,
        nargs='?', # this argument might be absent
        default=2, # the default value it takes if it absent
    )
    
    sqrt_parser = subparsers.add_parser('sqrt', help='calculate the square root')
    sqrt_parser.add_argument("value", help="value to be square rooted", type=float)
    
    args = parser.parse_args()
    
    if args.subparser=='pow':
        main_square(args)
    if args.subparser=='sqrt':
        main_sqrt(args)
        
if __name__=='__main__':
    main()
```

    Overwriting my_app.py



```python
!python my_app.py pow 4
```

    16.0



```python
!python my_app.py pow 2 3
```

    8.0



```python
!python my_app.py sqrt 4
```

    2.0


### Subcommands in practice

Try to keep the options between the subcommands coherent: if one implements `--help`, another implements `--documentation`, another implement `--explain` to access the help of the function, it is messy. try to maintain consistency in names and behaviors

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
!mkdir -p myapp/myapp/
!touch ./myapp/myapp/__init__.py
```


```python
%%file ./myapp/myapp/__main__.py
import argparse

def main_square(args):
    print(args.value**args.power)
    
def main_sqrt(args):
    print(args.value**0.5)

def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(help='possible actions', dest='subparser')
    
    square_parser = subparsers.add_parser('pow', help='calculate the square power')
    square_parser.add_argument("value", help="value to be squared", type=float)
    # optional argument
    square_parser.add_argument("power", 
        help="power to raised at", 
        type=float,
        nargs='?', # this argument might be absent
        default=2, # the default value it takes if it absent
    )
    
    sqrt_parser = subparsers.add_parser('sqrt', help='calculate the square root')
    sqrt_parser.add_argument("value", help="value to be square rooted", type=float)
    
    args = parser.parse_args()
    
    if args.subparser=='pow':
        main_square(args)
    if args.subparser=='sqrt':
        main_sqrt(args)
        
if __name__=='__main__':
    main()
    
```

    Overwriting ./myapp/myapp/__main__.py


The file necessary for setuptools to work properly is the `setup.py`, where we will use the `setup` function of the `setuptools` module.

This function configure many things for us, but the most important thing is the `entry_point` parameter.

This creates the link to the scripts that we will actually execute.

Inside this parameter we specify that there is an entry point atht is a `console_scripts`, that should execute the script and the function provided.


```python
%%file ./myapp/setup.py
from setuptools import setup

setup(
    name = 'myapp',
    version = '0.1.0',
    packages = ['myapp'],
    #install_requires = ["required_package", ],
    entry_points = {
        'console_scripts': [
            'myapp = myapp.__main__:main',
        ]
    })
```

    Overwriting ./myapp/setup.py


the name we put before the `=` sign is going to be the command name that we will use to call the program from the command line

Last special mention goes to the `install_requires`: this list allows to specify all the dependencies of the package.
If they are not installed, they will automatically downloaded and installed by pip.
In our case we don't have dependencies so we don't need it

### the installation step

from the folder containing the project folder, we can call the pip installation program

by installing it with the `--editable` (or `-e` for short) the program will not be copied in the system, but rather linked in it.
This means that if you edit the program, the modifications will appear live in the systems without need to reinstall


```python
!pip install --editable myapp
```

    Obtaining file:///home/enrico/didattica/programmingCourseDIFA/myapp
    Installing collected packages: myapp
      Running setup.py develop for myapp
    Successfully installed myapp



```python
!myapp --help
```

    usage: myapp [-h] {pow,sqrt} ...
    
    positional arguments:
      {pow,sqrt}  possible actions
        pow       calculate the square power
        sqrt      calculate the square root
    
    optional arguments:
      -h, --help  show this help message and exit


We can call the base program or the specific subcommand, as we specified


```python
!myapp sqrt 9 
```

    3.0


Lastly, we can uninstall the program from any location


```python
!pip uninstall -y myapp
```

    Found existing installation: myapp 0.1.0
    Uninstalling myapp-0.1.0:
      Successfully uninstalled myapp-0.1.0


If one needs to ship non-code files (such as images, configuration files, etc...)
check:

https://python-packaging.readthedocs.io/en/latest/non-code-files.html

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
* check that you can really get as input files in different directories from where you're working, both as input and output
* What happens when the input file doesn’t exist?
* Does our program exit with an error when we provide wrong arguments?
* does the logging system work as intended?

it is also important to not get wrapped in details: for example testing the formatting of the text of the help flag is not a productive activity.

In the same way, try to avoid testing for things that might be platform dependent, such as the exact python version!

being able to run the CLI programmatically means you can also test with hypothesis.

also, this is not actually dependent on the fact that the program is written in python: you can use these lines to test **any** CLI!

### executing local programs - subprocesses

running processes from python (i.e. external programs that exists in the system) can be done from the Subprocesses module.

in general the program is executed in a specific, isolated shell, and the commands is not passed directly, but rather pre-processed for security reasons

#### blocking execution

run a program and wait until it has finished running


```python
from subprocess import run, PIPE
run(["pwd"],
    stdout=PIPE,
    stdin=PIPE,
    stderr=PIPE,
    text=True,
)
```




    CompletedProcess(args=['pwd'], returncode=0, stdout='/home/enrico/didattica/programmingCourseDIFA\n', stderr='')




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

    'Python 3.9.12\n'
    ''
    0


#### running shell lines

if one wants to run a shell command, rather than executing a program, one can use the `shell` option.

beware to not use it on your machine with arbitrary user input, as it can be a massive security risk!


```python
# multiple commands
run(["echo ciao; echo bello"],
    stdout=PIPE,
    stdin=PIPE,
    stderr=PIPE,
    text=True,
    shell=True,
)
```




    CompletedProcess(args=['echo ciao; echo bello'], returncode=0, stdout='ciao\nbello\n', stderr='')




```python
# shell piping
run(["ls *.ipynb | wc -l"],
    stdout=PIPE,
    stdin=PIPE,
    stderr=PIPE,
    text=True,
    shell=True,
)
```




    CompletedProcess(args=['ls *.ipynb | wc -l'], returncode=0, stdout='20\n', stderr='')



### non-blocking execution

run a program and without waiting until it has finished running.

it implements a concept called a future: the first function call return an object that you can pass around and actually use only when needed (and wait if needed).


```python
from subprocess import Popen
```

The `Popen` object has basically the same parameters as the `run` function, but returns a promise instead of directly the results


```python
def execute(*args):
    return Popen(args, stdout=PIPE, stdin=PIPE, stderr=PIPE, text=True)
```

to retrieve the content of the call, one can use the `communicate` function.

it will wait until the program finishes!


```python
p = execute("echo", "ciao")
p.communicate()
```




    ('ciao\n', '')




```python
p.returncode
```




    0



if we want to check if the program has finished running, we can check with the `poll` function:

* if the program ended, it will return the return code
* if it hasn't, it will return None


```python
p = execute("sleep", "2")
if p.poll() is None:
    print("still sleeping")
```

    still sleeping



```python
if p.poll() is None:
    print("still sleeping")
else:
    print("finished sleeping")
```

    finished sleeping


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

To do this we can leverage the `tempfile` module


```python
import tempfile
```


```python
tf = tempfile.NamedTemporaryFile(dir=".")
tf.name
```




    '/home/enrico/didattica/programmingCourseDIFA_repo/master/tmpvlv7cbhl'




```python
temp_path = tempfile.TemporaryDirectory(dir=".")
temp_path
```




    <TemporaryDirectory './tmp0f3r8h3i'>



At this point we can test that our program write to the destination as intended we we pass it as an argument!


```python
%%file temp.py
import sys
print("arguments", sys.argv)
with open(sys.argv[1], "w") as outfile:
    print("printed to file!", file=outfile)
```

    Overwriting temp.py



```python
with tempfile.NamedTemporaryFile(dir=".", mode='w+') as result_file:
    result = run(["python", "temp.py", str(result_file.name)], capture_output=True, encoding='utf8')
    print(result.stdout)
    lines = result_file.readlines()
print("printed in file:", lines)
```

    arguments ['temp.py', '/home/enrico/didattica/programmingCourseDIFA_repo/master/tmp1awoy0t6']
    
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


If you want to be able to parse from both stdin and files you can use the fileinput library

This iterates over the lines of all files listed in `sys.argv[1:]`, defaulting to sys.stdin if the list is empty.

If a filename is `'-'`, it is also replaced by sys.stdin and the optional arguments mode and openhook are ignored.

To specify an alternative list of filenames, pass it as the first argument to input().

A single file name is also allowed.


```python
import fileinput
for line in fileinput.input():
    process(line)
```

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
print('L {:<20} R'.format('x'))
print('L {:^20} R'.format('x'))
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



```python
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("--debug")
args = parser.parse_args()
cli_args = {key: value for key, value in vars(args).items() if value}

```


```python
def execute(*args):
    return Popen(args, stdout=PIPE, stdin=PIPE, stderr=PIPE, text=True)

p = execute("echo", "ciao")
p.communicate()
p = execute("sleep", "10")
p.poll()
# None if running
# retcode if ended

run(["echo ciao; echo bello"], stdout=PIPE, stdin=PIPE, stderr=PIPE, text=True, shell=True)
run(["ssh bio8 pwd"], stdout=PIPE, stdin=PIPE, stderr=PIPE, text=True, shell=True)


import fileinput
for line in fileinput.input():
    process(line)

# This iterates over the lines of all files listed in sys.argv[1:], defaulting to sys.stdin if the list is empty.
# If a filename is '-', it is also replaced by sys.stdin and the optional arguments mode and openhook are ignored.
# To specify an alternative list of filenames, pass it as the first argument to input().
# A single file name is also allowed.

```
