# Logging and Debugging

This lesson will deal on how to make sure that our code is doing what is supposed to be doing.

This is related to testing, but can be viewed as complementary to it

We will discuss:

* debugging
* assertions
* logging

and, given time:

* linters
* type checkers
* warnings


All these tools help us ensure that the program is doing what is supposed to be doing.

While tests check that the program logic is correct, these tools helps you check that the program is implementing the operations you think it's doing.

### the logic

most of these techniques are necessary to help you understand what you program is *actually* doing, instead of what you think it is supposed to be doing

## Debugging

A debugger is a program that attach itself to yours and monitor it state and allow you to control the execution in real time.

It doesn't sound that crazy for python, but consider that the original debuggers were doing it for C programs...

What we do when we execute our programs one line at the time from an editor like spyder is basically a manual for of a debugger

Python and IPython comes with a basic debugger for the command line, but most programs provide you with more advanced (and easy to use ones).

We will discuss the basic ones, but (as usual) just to explain the basic concepts that they use.

The basic operations can be divided in two main categories: 

* managing the execution
* examine and modify the program state

* **l**(list)	Lists the code at the current position

* **w**(here) What is the exact position in the call stack
* **n**(ext)	Execute the next line (does not go down in new functions)
* **s**(tep)	Execute the next statement (goes down in new functions)
* **r**(eturn)	Return out of a subroutine
* **bt**	Print the call stack
* **p**(rint) <expression>	print the result of the expression

* **a**	Print the local variables
* !command	Execute the given Python command (instead of pdb commands)

* **u**(p)	Walk up the call stack
* **d**(own)	Walk down the call stack
* **h**(elp)	Show a list of commands, or find help on a specific command
* **q**(uit)	Quit the debugger and the program
* **c**(ontinue)	Quit the debugger, continue in the program
* `<Return>`	Repeat the previous command



```python
%%file test.py

dati = [1, 2, 3, 4]

def my_function():
    for dato in dati:
        print(dati[dato])
        
my_function()
```

    Overwriting test.py



```python
%run test.py
```

    2
    3
    4



    ---------------------------------------------------------------------------

    IndexError                                Traceback (most recent call last)

    ~/didattica/corso_programmazione_1819/programmingCourseDIFA/test.py in <module>
          6         print(dati[dato])
          7 
    ----> 8 my_function()
    

    ~/didattica/corso_programmazione_1819/programmingCourseDIFA/test.py in my_function()
          4 def my_function():
          5     for dato in dati:
    ----> 6         print(dati[dato])
          7 
          8 my_function()


    IndexError: list index out of range



```python
%run -d test.py
```

    *** Blank or comment
    *** Blank or comment
    NOTE: Enter 'c' at the ipdb>  prompt to continue execution.
    > [0;32m/home/enrico/didattica/corso_programmazione_1819/programmingCourseDIFA/test.py[0m(2)[0;36m<module>[0;34m()[0m
    [0;32m      1 [0;31m[0;34m[0m[0m
    [0m[0;32m----> 2 [0;31m[0mdati[0m [0;34m=[0m [0;34m[[0m[0;36m1[0m[0;34m,[0m [0;36m2[0m[0;34m,[0m [0;36m3[0m[0;34m,[0m [0;36m4[0m[0;34m][0m[0;34m[0m[0;34m[0m[0m
    [0m[0;32m      3 [0;31m[0;34m[0m[0m
    [0m[0;32m      4 [0;31m[0;32mdef[0m [0mmy_function[0m[0;34m([0m[0;34m)[0m[0;34m:[0m[0;34m[0m[0;34m[0m[0m
    [0m[0;32m      5 [0;31m    [0;32mfor[0m [0mdato[0m [0;32min[0m [0mdati[0m[0;34m:[0m[0;34m[0m[0;34m[0m[0m
    [0m
    ipdb> n
    > [0;32m/home/enrico/didattica/corso_programmazione_1819/programmingCourseDIFA/test.py[0m(4)[0;36m<module>[0;34m()[0m
    [0;32m      2 [0;31m[0mdati[0m [0;34m=[0m [0;34m[[0m[0;36m1[0m[0;34m,[0m [0;36m2[0m[0;34m,[0m [0;36m3[0m[0;34m,[0m [0;36m4[0m[0;34m][0m[0;34m[0m[0;34m[0m[0m
    [0m[0;32m      3 [0;31m[0;34m[0m[0m
    [0m[0;32m----> 4 [0;31m[0;32mdef[0m [0mmy_function[0m[0;34m([0m[0;34m)[0m[0;34m:[0m[0;34m[0m[0;34m[0m[0m
    [0m[0;32m      5 [0;31m    [0;32mfor[0m [0mdato[0m [0;32min[0m [0mdati[0m[0;34m:[0m[0;34m[0m[0;34m[0m[0m
    [0m[0;32m      6 [0;31m        [0mprint[0m[0;34m([0m[0mdati[0m[0;34m[[0m[0mdato[0m[0;34m][0m[0;34m)[0m[0;34m[0m[0;34m[0m[0m
    [0m
    ipdb> p dati
    [1, 2, 3, 4]
    ipdb> !dati[-1] = 3
    ipdb> p dati
    [1, 2, 3, 3]
    ipdb> c
    2
    3
    3
    3


### breakpoints

Sometimes we know where the error is likely t be, and would like the program to proceed with the regular execution until some given point.
These points are called **breakpoints**, and allow for a smoother debugging experience

Since Python 3.7 there’s a built-in `breakpoint()` function that calls the configured debugger. 

Just place `breakpoint()` anywhere in the code to get into the debugger shell.

Additionally, if you want to run a python script and ignore all `breakpoint()` calls in the code it’s possible to do so by setting the environment variable PYTHONBREAKPOINT=0


```python
%%file test.py

dati = [1, 2, 3, 4]

def my_function():
    breakpoint()
    for dato in dati:
        print(dati[dato])
        
my_function()
```

    Writing test.py



```python
%run test.py
```

    > c:\users\enrico\documents\didattica\programmingcoursedifa\test.py(6)my_function()
    -> for dato in dati:
    (Pdb) l
      1  	
      2  	dati = [1, 2, 3, 4]
      3  	
      4  	def my_function():
      5  	    breakpoint()
      6  ->	    for dato in dati:
      7  	        print(dati[dato])
      8  	
      9  	my_function()
    [EOF]
    (Pdb) a dati
    (Pdb) p dati
    [1, 2, 3, 4]
    (Pdb) q



    ---------------------------------------------------------------------------

    BdbQuit                                   Traceback (most recent call last)

    ~\Documents\didattica\programmingCourseDIFA\test.py in <module>
          7         print(dati[dato])
          8 
    ----> 9 my_function()
    

    ~\Documents\didattica\programmingCourseDIFA\test.py in my_function()
          4 def my_function():
          5     breakpoint()
    ----> 6     for dato in dati:
          7         print(dati[dato])
          8 


    ~\Documents\didattica\programmingCourseDIFA\test.py in my_function()
          4 def my_function():
          5     breakpoint()
    ----> 6     for dato in dati:
          7         print(dati[dato])
          8 


    ~\Miniconda3\lib\bdb.py in trace_dispatch(self, frame, event, arg)
         86             return # None
         87         if event == 'line':
    ---> 88             return self.dispatch_line(frame)
         89         if event == 'call':
         90             return self.dispatch_call(frame, arg)


    ~\Miniconda3\lib\bdb.py in dispatch_line(self, frame)
        111         if self.stop_here(frame) or self.break_here(frame):
        112             self.user_line(frame)
    --> 113             if self.quitting: raise BdbQuit
        114         return self.trace_dispatch
        115 


    BdbQuit: 


## Assertions

they are useful to express your expectations about the code


```python
assert 1==0, "I was not expecting that"
```


    ---------------------------------------------------------------------------

    AssertionError                            Traceback (most recent call last)

    <ipython-input-2-54e203d14fc0> in <module>()
    ----> 1 assert 1==0, "I was not expecting that"
    

    AssertionError: I was not expecting that


but don't rely on it, as they can be removed from the execution by using the flag `-O` (Optimize) when calling the python interpreter.

A common mistake is to use assertions to check the inputs of a function.
this is an improper use of the assert, both due to the fact that it can't be relied and that they are not providing discrimintive and informative errors to the user. 

they should be used for testing for sure, but in normal code they have only one real use: express invariant of your code (think back about property testing).

They express in code that some characteristics of the code **has to** be valid, or something has gone very very wrong.

```python
def my_smart_sort(sequence):
    # some sorting code
    sorted_sequence = someting(partial_result)
    # the resulting sequence has the same lenght of the original one or someting is wrong
    assert len(sorted_sequence) == len(sequence)
    return sorted_sequence
```

you can look at asserts as a stronger form of comments: comments can potentially go out of snc with your code, while assert can't, so they can communicate to the programmer reading the function with a higher degree of confidence.

let's be honest, assert in general does have a terrible syntax

We could use a better (albeit slower) assertion library, **grappa**, to help get better syntax and better error results.


```python
from grappa import should, expect
```


```python
try:
    'foo' | should.be.equal.to('bar')
except AssertionError as e:
    print(e)
```

    Oops! Something went wrong!
    
      The following assertion was not satisfied
        subject "foo" should be equal to "bar"
    
      What we expected
        a value that is equal to "bar"
    
      What we got instead
        an value of type "str" with data "foo"
    
      Difference comparison
        > - foo
        > + bar
    
      Where
        File "<ipython-input-3-dd9644d0aacd>", line 2, in <module>
    
         1|   try:
         2| >     'foo' | should.be.equal.to('bar')
         3|   except AssertionError as e:
         4|       print(e)
    



```python
with should({'foo': 'bar'}):
    should.be.a(dict)
    should.have.length(1)
    should.have.key('foo').that.should.be.equal.to('bar')
```


```python
try:
    'hello' | should.be.empty
except AssertionError as e:
    print(e)
```

    Oops! Something went wrong!
    
      The following assertion was not satisfied
        subject "hello" should be empty
    
      What we expected
        a value that is not "None" and its length is higher than zero
    
      What we got instead
        an object with type "str" which its length cannot be measured
    
      Information
        > An empty object can be "None", "0" or "len(x) == 0".
          Most objects in Python can be tested via "len(x)"
          such as str, list, tuple, dict, generator...
          as well as any object that implements "__len__()" method.
          => Reference: https://docs.python.org/3/library/functions.html#len
    
      Where
        File "<ipython-input-29-fac7d0be13c0>", line 2, in <module>
    
         1|   try:
         2| >     'hello' | should.be.empty
         3|   except AssertionError as e:
         4|       print(e)
    



```python
data = 'hello'
try:
    expect(data).to.be.a('int')
except AssertionError as e:
    print(e)
```

    Oops! Something went wrong!
    
      The following assertion was not satisfied
        subject "hello" expect to be a "<class 'int'>"
    
      What we expected
        an object that is a "<class 'int'>" type
    
      What we got instead
        an object of type "str" with value "hello"
    
      Difference comparison
        > - hello
        > + <class 'int'>
    
      Where
        File "<ipython-input-33-26e9dc31d426>", line 3, in <module>
    
         1|   data = 'hello'
         2|   try:
         3| >     expect(data).to.be.a('int')
         4|   except AssertionError as e:
         5|       print(e)
    


## Logging

When you execute your code and print the internal state of the program to check that is working properly, that is a rudimentary form of logging.

Printing the state of your program works fine as long as your program is simple and the amount of state is small.

For anything more complicated, you need to use a logging system.

The basic idea of a logging system is to standardize how and what gets written on a file


```python
import logging

logging.basicConfig(level=logging.WARNING)

logging.debug('This is a debug message')
logging.info('This is an info message')
logging.warning('This is a warning message')
logging.error('This is an error message')
logging.critical('This is a critical message')
```

    WARNING:root:This is a warning message
    ERROR:root:This is an error message
    CRITICAL:root:This is a critical message



```python
logging.basicConfig(filename='app.log', filemode='w',
                    format='%(name)s - %(levelname)s - %(message)s')

```

A better library is called **eliot**, that allows for a more structured logging instead of just printing to stderr


```python
%%file test.py

from eliot import start_action, to_file, Message
to_file(open("test.log", "w"))

def myfunction(value):
    with start_action(action_type='myfunction', value=value):
        return 1/value

for number in [4, 1, 0, 2, 4]:
    with start_action(action_type="start evaluation", number=number):
        point = number *2
        total = sum(i for i in range(point))
        with start_action(action_type="inside evaluation", total=total):
            result = myfunction(total)

```

    Overwriting test.py



```python
!rm test.log
%run test.py
```


    ---------------------------------------------------------------------------

    ZeroDivisionError                         Traceback (most recent call last)

    ~/didattica/corso_programmazione_1819/programmingCourseDIFA/test.py in <module>()
         12         total = sum(i for i in range(point))
         13         with start_action(action_type="inside evaluation", total=total):
    ---> 14             result = myfunction(total)
    

    ~/didattica/corso_programmazione_1819/programmingCourseDIFA/test.py in myfunction(value)
          5 def myfunction(value):
          6     with start_action(action_type='myfunction', value=value):
    ----> 7         return 1/value
          8 
          9 for number in [4, 1, 0, 2, 4]:


    ZeroDivisionError: division by zero



```python
!eliot-tree test.log
```

    bc135185-26bb-44f4-adbf-93a762eca2f3
    └── start evaluation/1 ⇒ started 2018-09-03 09:03:04 ⧖ 0.003s
        ├── number: 4
        ├── inside evaluation/2/1 ⇒ started 2018-09-03 09:03:04 ⧖ 0.002s
        │   ├── total: 28
        │   ├── myfunction/2/2/1 ⇒ started 2018-09-03 09:03:04 ⧖ 0.001s
        │   │   ├── value: 28
        │   │   └── myfunction/2/2/2 ⇒ succeeded 2018-09-03 09:03:04
        │   └── inside evaluation/2/3 ⇒ succeeded 2018-09-03 09:03:04
        └── start evaluation/3 ⇒ succeeded 2018-09-03 09:03:04
    
    75834879-b121-40f8-97ef-04e27bbc6d61
    └── start evaluation/1 ⇒ started 2018-09-03 09:03:04 ⧖ 0.002s
        ├── number: 1
        ├── inside evaluation/2/1 ⇒ started 2018-09-03 09:03:04 ⧖ 0.001s
        │   ├── total: 1
        │   ├── myfunction/2/2/1 ⇒ started 2018-09-03 09:03:04 ⧖ 0.000s
        │   │   ├── value: 1
        │   │   └── myfunction/2/2/2 ⇒ succeeded 2018-09-03 09:03:04
        │   └── inside evaluation/2/3 ⇒ succeeded 2018-09-03 09:03:04
        └── start evaluation/3 ⇒ succeeded 2018-09-03 09:03:04
    
    e9c68561-2e34-4547-9b08-bade663468cb
    └── start evaluation/1 ⇒ started 2018-09-03 09:03:04 ⧖ 0.002s
        ├── number: 0
        ├── inside evaluation/2/1 ⇒ started 2018-09-03 09:03:04 ⧖ 0.001s
        │   ├── total: 0
        │   ├── myfunction/2/2/1 ⇒ started 2018-09-03 09:03:04 ⧖ 0.000s
        │   │   ├── value: 0
        │   │   └── myfunction/2/2/2 ⇒ failed 2018-09-03 09:03:04
        │   │       ├── exception: builtins.ZeroDivisionError
        │   │       └── reason: division by zero
        │   └── inside evaluation/2/3 ⇒ failed 2018-09-03 09:03:04
        │       ├── exception: builtins.ZeroDivisionError
        │       └── reason: division by zero
        └── start evaluation/3 ⇒ failed 2018-09-03 09:03:04
            ├── exception: builtins.ZeroDivisionError
            └── reason: division by zero
    



```python
!head test.log
```

    {"action_type": "start evaluation", "task_level": [1], "timestamp": 1535965154.3335845, "task_uuid": "409f42e6-0c10-4f59-b882-e4fb7f112241", "action_status": "started", "number": 4}
    {"action_type": "inside evaluation", "task_level": [2, 1], "timestamp": 1535965154.333918, "task_uuid": "409f42e6-0c10-4f59-b882-e4fb7f112241", "action_status": "started", "total": 28}
    {"task_uuid": "409f42e6-0c10-4f59-b882-e4fb7f112241", "timestamp": 1535965154.3341036, "action_type": "inside evaluation", "task_level": [2, 2], "action_status": "succeeded"}
    {"task_uuid": "409f42e6-0c10-4f59-b882-e4fb7f112241", "timestamp": 1535965154.3342803, "action_type": "start evaluation", "task_level": [3], "action_status": "succeeded"}
    {"action_type": "start evaluation", "task_level": [1], "timestamp": 1535965154.334487, "task_uuid": "3d429872-a765-4c18-9559-cc41c68be49f", "action_status": "started", "number": 1}
    {"action_type": "inside evaluation", "task_level": [2, 1], "timestamp": 1535965154.3346956, "task_uuid": "3d429872-a765-4c18-9559-cc41c68be49f", "action_status": "started", "total": 1}
    {"task_uuid": "3d429872-a765-4c18-9559-cc41c68be49f", "timestamp": 1535965154.3348691, "action_type": "inside evaluation", "task_level": [2, 2], "action_status": "succeeded"}
    {"task_uuid": "3d429872-a765-4c18-9559-cc41c68be49f", "timestamp": 1535965154.3350365, "action_type": "start evaluation", "task_level": [3], "action_status": "succeeded"}
    {"action_type": "start evaluation", "task_level": [1], "timestamp": 1535965154.335238, "task_uuid": "7738a51b-a796-478a-8e0a-6b8aad139034", "action_status": "started", "number": 0}
    {"action_type": "inside evaluation", "task_level": [2, 1], "timestamp": 1535965154.3354425, "task_uuid": "7738a51b-a796-478a-8e0a-6b8aad139034", "action_status": "started", "total": 0}


What if you want to see the results in real time?

A better solution is to periodically refresh the result of `eliot-tree`, piping the tail of the log file in it:

    tail -f test.log | eliot-tree
    
for example, if we make our program be slower (simulating a slow computation)

The only limitations are:

* you have to interrupt the tail process manually
* actions are written only when completed, so if you have very high level actions this will not print until they are done


```python
%%file test.py

import time
from eliot import start_action, to_file, Message, start_task
to_file(open("test.log", "w"))

def myfunction(value):
    with start_action(action_type='myfunction', value=value):
        time.sleep(5)
        result = 1/value
        Message.log(result=result)
        return 1/value

for number in [4, 1, 3, 5, 0, 2, 4]:
    with start_action(action_type="start evaluation", number=number):
        point = number *2
        total = sum(i for i in range(point))
        with start_action(action_type="inside evaluation", total=total):
            result = myfunction(total)
```

    Overwriting test.py



```python
!rm test.log
%run test.py
```


    ---------------------------------------------------------------------------

    ZeroDivisionError                         Traceback (most recent call last)

    ~/didattica/corso_programmazione_1819/programmingCourseDIFA/test.py in <module>()
         16         total = sum(i for i in range(point))
         17         with start_action(action_type="inside evaluation", total=total):
    ---> 18             result = myfunction(total)
    

    ~/didattica/corso_programmazione_1819/programmingCourseDIFA/test.py in myfunction(value)
          7     with start_action(action_type='myfunction', value=value):
          8         time.sleep(5)
    ----> 9         result = 1/value
         10         Message.log(result=result)
         11         return 1/value


    ZeroDivisionError: division by zero


Otherwise, if you are used to live in the matrix, you can watch the log file directly with:

    tail -f test.log

## Warning systems

Warnings are a way to comunicate directly with the user and let them know that there is something fishy going on.

While logging is something that is run consistently, warnings should appear only in some specific situations.

A tipical case is to inform your user that one of the functions that is being used is going to be removed from the next version of your library and that they should use something different


```python
import warnings
warnings.warn("this is an old script, use a new one!")

```

    /home/enrico/miniconda3/lib/python3.6/site-packages/ipykernel_launcher.py:2: UserWarning: this is an old script, use a new one!
      


if you want to raise an error when you catch a warning, you can use a specific context manager


```python
with warnings.catch_warnings():
        warnings.simplefilter('error', category=Warning)
        warnings.warn("there is a problem!")
```


    ---------------------------------------------------------------------------

    UserWarning                               Traceback (most recent call last)

    <ipython-input-86-15bf7a32a4ae> in <module>()
          1 with warnings.catch_warnings():
          2         warnings.simplefilter('error', category=Warning)
    ----> 3         warnings.warn("there is a problem!")
    

    UserWarning: there is a problem!


on the opposite, you might want to silence certain warnings as you know what you're doing.

SPOILER: you probably should not use this code!


```python
with warnings.catch_warnings():
        warnings.simplefilter('ignore', category=Warning)
        warnings.warn("there is a problem!")
```

## Linters

Linters are programs that check your code for possible mistakes and errors before the execution.

there are several of them, with various level of informations that they can gather.

Most editors can be configured to run them in the background and show the resulting informations directly in the editor window.

examples of things that they will catch are:

* variable definited but not used
* overloading of existing functions
* syntax errors

and so on.

They are extremely useful when working with a dynamic language such as python, as they provide some functionalities of the traditional compilers

some of these linters are:

* pylint
* pycodestyle (previously called pep8)
* pyflakes
* flake8


```python
%%file test.py

def eleva(n):
    return n**2

dati = [1, 2, 3, 4]

for dato in dati:
    print(eleva(dati[dato]))
    
print(data)
```

    Overwriting test.py



```python
!pylint test.py
```

    ************* Module test
    test.py:9:0: C0303: Trailing whitespace (trailing-whitespace)
    test.py:10:0: C0304: Final newline missing (missing-final-newline)
    test.py:1:0: C0111: Missing module docstring (missing-docstring)
    test.py:2:0: C0103: Argument name "n" doesn't conform to snake_case naming style (invalid-name)
    test.py:2:0: C0111: Missing function docstring (missing-docstring)
    test.py:5:0: C0103: Constant name "dati" doesn't conform to UPPER_CASE naming style (invalid-name)
    test.py:10:6: E0602: Undefined variable 'data' (undefined-variable)
    
    -------------------------------------------------------------------
    Your code has been rated at -8.33/10 (previous run: 0.00/10, -8.33)
    


obviously not all suggestions are equally relevant, but they can spot several **code smells** before you run a long simulation

## Static type checking

A specific type of linter are the static type checkers, that are made possible by new syntax from python 3.

I will not get into the details of it, just the general idea.

Python is a dynamic language, but is still strongly typed.
One just don't have to declare the typed beforehand.

What they introduced is the possibility to annotate the code to express expectations over the type of variables, arguments and functions.
This does not have any effect on running the code, but allow type checkers (the most famous one is `mypy`) to assess if the code is correct

for example, the following code have a lot of issues, but they migh not be immediately apparent just looking at it.

If we don't put any typing information, mypy doesn't complain and doesn't do anything


```python
%%file test.py

def eleva(n):
    return n.upper()

dati = [1, 2, 3, 4]

for dato in dati:
    print(eleva(dati[dato]))
```

    Overwriting test.py



```python
!mypy test.py
```

I can start introducing types informations and will find progressively more possible mistakes.

types are specified with a colon (`:`) after the argument or variable, followed by the type object that it should have.

for the return type, one can use an arrow `->`


```python
%%file test.py

def eleva(n: str) -> str:
    return n.upper()

dati = [1, 2, 3, 4]

for dato in dati:
    print(1+eleva(dati[dato]))
```

    Overwriting test.py



```python
!mypy test.py
```

    test.py:8: error: Unsupported operand types for + ("int" and "str")
    test.py:8: error: Argument 1 to "eleva" has incompatible type "int"; expected "str"


I can specify more complex types using the library `typing`, that allows to specify very complex structures


```python
%%file test.py

from typing import List

def eleva(n: str):
    return n.upper()

dati: List[str] = [1, 2, 3, 4]

for dato in dati:
    print(eleva(dati[dato]))
```

    Overwriting test.py



```python
!mypy test.py
```

    test.py:7: error: List item 0 has incompatible type "int"; expected "str"
    test.py:7: error: List item 1 has incompatible type "int"; expected "str"
    test.py:7: error: List item 2 has incompatible type "int"; expected "str"
    test.py:7: error: List item 3 has incompatible type "int"; expected "str"
    test.py:10: error: No overload variant of "__getitem__" of "list" matches argument type "str"
    test.py:10: note: Possible overload variants:
    test.py:10: note:     def __getitem__(self, int) -> str
    test.py:10: note:     def __getitem__(self, slice) -> List[str]


this allows me to annotate only the code I **care about** without having to deal with typing everywhere

you can find more info about tye checking and how to use it on this blog posts:
  
#### a general overview of the type systems
https://www.bernat.tech/the-state-of-type-hints-in-python/

#### an in-depth discussion of how the type system works and how to use it
* [S01E01](https://blog.daftcode.pl/first-steps-with-python-type-system-30e4296722af)
* [S01E02](https://blog.daftcode.pl/next-steps-with-python-type-system-efc4df5251c9)
* [S02E01](https://blog.daftcode.pl/csi-python-type-system-episode-1-1c2ee1f8047c)
* [S02E02](https://blog.daftcode.pl/csi-python-type-system-episode-2-baf5168038c0)
* [S02E03](https://blog.daftcode.pl/covariance-contravariance-and-invariance-the-ultimate-python-guide-8fabc0c24278)
