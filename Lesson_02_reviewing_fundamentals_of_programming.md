## programming and coding

This two concept are often mixed up.
We could use this two informal descriptions:

**Programming** is about thinking how to formalize a certain sequence of operation.

**Coding** is writing a computer program that actually perform the operations we have in mind.

While **coding** is strictly related to a specific programming language, but most of the **programming** skills are identical among different languages.

As a matter of fact, one does not even need a computer to be able to "program"

### how do you prepare coffee?

Try describing the steps necessary to prepare a coffee.

### pointers

* are you describing a moka or a capsule machine?
* how expert is the other person?
* is the coffee already available?

## programming concepts

There are really only 5 basic concepts to programming; anything else, in all languages, is basically just rehashing of these ideas.

* storing and retrieving things
* Conditional execution
* functions and routines
* iteration
* data structure(s)

We will discuss these ideas (and all that follows) using python.

Python was **not** chosen because it's **the best language**.
It's a solid all-rounder, that will allow you to experiment with ease in a lot of different facets of programming.

> Python is not the best language at anything, but it's the second best for most things
(*someone on Twitter*)

Python is a **high level** and **interpreted** language.

**high level** means that it tries to express its concepts in a way closer to the human than to the machine

**interpreted** means that it does not execute directly on the machine, but generates commands for the python interpreter, that executes them

for sake of completeness, it's also a **dynamically typed** language.

## Python tutor

To see what python is doing in the inside, you can go and play in this website.

It allows you to write python code and see what the python interpreter is doing with each piece of code.


http://pythontutor.com/visualize.html#mode=edit


```python
a = 0+1j
b = 1 + a**2 / 2
print(b)
```

    (0.5+0j)


#### notes:

we did not need to declare the existence of variables **a** and **b** beforehand

we did not need to declare their type beforehand

Python handles complex number naturally (not important, but nice)


```python
a = 1
b = '2'
c = a + b
```


    ---------------------------------------------------------------------------

    TypeError                                 Traceback (most recent call last)

    <ipython-input-95-0be4553b3466> in <module>
          1 a = 1
          2 b = '2'
    ----> 3 c = a + b
    

    TypeError: unsupported operand type(s) for +: 'int' and 'str'


#### notes:

Python will complain loudly if you make a mistake, and does not try to guess what you want to do if it's not uniquely defined.
It's for your own good.
Really.

Before panicking, read the error message, they are usually very clear!

if you are not sure what to look for, download and print this flowchart:
https://www.dropbox.com/s/cqsxfws52gulkyx/drawing.pdf


```python
import this
```

    The Zen of Python, by Tim Peters
    
    Beautiful is better than ugly.
    Explicit is better than implicit.
    Simple is better than complex.
    Complex is better than complicated.
    Flat is better than nested.
    Sparse is better than dense.
    Readability counts.
    Special cases aren't special enough to break the rules.
    Although practicality beats purity.
    Errors should never pass silently.
    Unless explicitly silenced.
    In the face of ambiguity, refuse the temptation to guess.
    There should be one-- and preferably only one --obvious way to do it.
    Although that way may not be obvious at first unless you're Dutch.
    Now is better than never.
    Although never is often better than *right* now.
    If the implementation is hard to explain, it's a bad idea.
    If the implementation is easy to explain, it may be a good idea.
    Namespaces are one honking great idea -- let's do more of those!


### conditional execution

do something only if a certain condition is met


```python
x = 5
if x>0:
    print("positive number")
else:
    print("negative number")
```

    positive number



```python
y = 1 if x>0 else -1
print(y)
```

    1


### important note:

Python uses whitespaces (indentations) to represent code scoping:
what is indented after the **if** and the **else** is related to those two commands, and only executed when you are inside them.

this is referred as a code block.

Before starting a new block, the previous line ends with a `:`


```python
x = 0
if x>0:
    print("positive number")
elif x<0:
    print("negative number")
else:
    print("x is zero")
```

    x is zero


### functions and routines

From the language perspective of python they are the same thing, but from a conceptual perspective, they are very different.

* routines do something to the system, and usually don't return anything interesting (like printing). 
* functions create new objects from the inputs, but don't modify the input themselves

they are both referred as functions, and can do both, but try to know which is which and plan accordingly.

And try to avoid mixing the two.


```python
def get_sign_of_number(number_to_be_tested):
    sign = 1 if number_to_be_tested>0 else -1
    return sign

get_sign_of_number(-3)
```




    -1



An important concept related to functions is the concept of **scoping**.

When we execute a function we can use variables that are *reserved to the function*.

This allows to write simpler code.


```python
def my_adder(x):
    global y
    g  = 3
    result = x + y + g
    y += 1
    return result

y = 4
print(my_adder(1))
```

    8



```python
print(my_adder(1))
```

    11



```python
print(g)
```


    ---------------------------------------------------------------------------

    NameError                                 Traceback (most recent call last)

    <ipython-input-8-e1cdc681402c> in <module>()
    ----> 1 print(g)
    

    NameError: name 'g' is not defined


### libraries

libraries are collections of functions and classes that allows to reuse well-written code (from you or from somebody else) in your new code.

to import a library you can do it in several ways.

whatever you need to implement, it is usually worth checking if there is already a library doing it for you.


```python
import math
math.log(math.e)
```




    1.0




```python
from math import log, e
log(e)
```




    1.0




```python
from math import log as take_logarithm
take_logarithm(math.e)
```




    1.0



there is another way of importing functions from libraries:

    from math import *
    
**don't do this**

everytime you `import *`, a puppy dies.

don't kill the puppies.

the most commonly imported libraries are usually imported with standard shorter names, and you will see most code using these conventions.
Don't stray from conventions unless you need why you are doing it.

in scientific code, the most common ones are:

    import numpy as np
    import pandas as pd
    import pylab as plt
    

### DRY principle

**DRY**: Do not Repeat Yourself.

Repeating code (or copy pasting it) can lead to sever errors:

* dependencies on surrounding code
* forgetting to change a variable name
* visual clutter

Functions are the primary way of implementing DRY principles.

The rule of thumb is that if you are going to do it more than twice, write a function instead...
Sometime even if you are going to do it once!


```python
import statistics

x = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
x_med = statistics.median(x)
x_min = min(x)
x_max = max(x)
x_top = x_max - x_med
x_bot = x_med - x_min
x_ratio = x_top/x_bot
x_ratio
```




    1.25



This code is obscure and pollute the namespace!


```python
def interquantile_asymmetry(data):
    """calculate the asymmetry between min, max and median"""
    x_med = statistics.median(data)
    x_min = min(data)
    x_max = max(data)
    x_top = x_max - x_med
    x_bot = x_med - x_min
    x_ratio = x_top / x_bot
    return x_ratio

interquantile_asymmetry(x)
```




    1.25



### iterations

Repeating an operation over and over, typically with a different input each time, or with an exit condition.

Typically they underpin the usage of words like: `while`, `for`/`for each`, `until`.

There are two main approaches to iteration: **bounded** and **unbounded**.

In the **bounded** kind of iteration, the program have an idea on how many iteration cycles it will need.
It usually corresponds to saying: *for every one of these objects, do this*.

The **unbounded** iterations are more related to exploration.
The program has no idea beforehand on how many steps might be necessary.
It usually corresponds to saying: *to this thing until something happens*

**Unbounded** iterations usually require some form of internal state that is used to perform decision to continue based on what has been seen previously.

In python, bounded iterations are represented with a `for`, while unbuonded with a `while`.

It is important to notice that:
* These are not clear-cut distinctions, and sometimes things can get murky
* **bounded** does not mean finite
* the bounds might be known to the program but not to you
* Python often transforms unbounded loops in bounded ones under the hood


```python
years = [2010, 2011, 2012]
for year in years:
    print("The year is", year)
```

    The year is 2010
    The year is 2011
    The year is 2012



```python
import random
x = 0
while x<3:
    print("position=", x)
    step = random.choice([-1, 1])
    x = x + step
    
```

    position= 0
    position= 1
    position= 2
    position= 1
    position= 0
    position= 1
    position= 2
    position= 1
    position= 2


sometimes one needs to break out early from a loop.

this can be done using the `break` keyword, that kills the loop immediately and completely

similarly, one can skip a single iteration of the loop with the `continue` keyword


```python
# the `break` keyword is useful to perform a do-while loop

import random
x = 0
while True:
    print("position=", x)
    step = random.choice([-1, 1])
    x = x + step
    if x>=3:
        break
```

    position= 0
    position= 1
    position= 2
    position= 1
    position= 0
    position= 1
    position= 2



```python
# continue can be used to skip data that we don't want to process

years = [2018, 2019, 2020, 2021, 2022, 2023]
for year in years:
    if year<2020:
        continue
    print(year)
```

    2020
    2021
    2022
    2023


## data structures

These are containers that holds the informations, and make more or less easy to retrieve and manipulate this information.

Programming can be described as creating and modifying data structures with the previous concept until the desired result is obtained.

There are a great number of data structures, and more get introduced in a language by libraries.

I will use the python names for these concepts, but they can be found one way or another in basically all programming languages.

#### basics

* strings
* maps
* list
* tuples

#### more advanced

* objects
* enum

## Fundamental structures

### Strings

They contain text, and allows for some (relatively)
complex manipulation of it.

strings can be enclosed in single quotes, double quotes, 
triple single and triple double.

    "text to be used"
    'text to be used'
    '''text to be used'''
    """text to be used"""
    
single or double quotes are identical,
just chose the one you like the most.

triple quotes (both single and double) 
can span several lines

    """this string starts here
    keeps going
    and ends here"""




```python
a = "hello WORLD"

"hello" in a
```




    True




```python
a.title()
```




    'Hello World'




```python
a.lower()
```




    'hello world'




```python
a.upper()
```




    'HELLO WORLD'




```python
a.startswith("hello")
```




    True




```python
a.endswith("world")
```




    False




```python
a.replace("hello", "ciao")
```




    'ciao WORLD'




```python
pi = 3.141592653589793
"value of π: {:.3e}".format(pi)
```




    'value of π: 3.142e+00'



#### special characters

by default, special characters that cannot be rendered directly are represented with `\` followed by some letters or codes that uniquely identify them

* `\n` newline
* `\t` tabulation
* `\U0001f604` unicode point for smiley face


```python
print('\U0001f604')
```

    😄


it can recognized the whole unicode point name, if you want to have a more human description of it


```python
print('\N{grinning face with smiling eyes}')
print('\N{GREEK SMALL LETTER ALPHA}')
```

    😁
    α



```python
print("α")
```

    α


### Indexing of objects

Several objects in python allow extracting subsequences by using the indexing operator `[]`.

Each object specify how it reacts to the specific index you pass it.

Strings, lists and most other iterable objects use 0-based indexing


```python
a = "hello world"
a[0]
```




    'h'




```python
a[-1]
```




    'd'



it is also possible to specify **ranges**, with a start and stop positions (assumed by default to be the first and last element).

in a range the last element indicated is excluded from the sequence


```python
a[:5]
```




    'hello'




```python
a[-5:]
```




    'world'




```python
a[:5] + a[5:] == a
```




    True



It is also possible to specify a **step**, that indicates if it has to skip some elements of the sequence


```python
a[::2]
```




    'hlowrd'




```python
a[::-1]
```




    'dlrow olleh'



### Lists

Lists are collections of items all with some common characteristic.

    [1, 2, 3]
    
is a list of integer numbers

    ['hello', 'world']
    
is a list of strings

    ['hello', 1, 'world']
    
is a list of generic python objects

Python will not enforce the kind of objects you can keep in a list, but you should in general be careful of the meaning of what you are doing.

Other programming languages can be more strict about it

The typical usage is to store object on which you want to perform some specific operation.

Therefore, the only restriction is that this operation is allowed on the data contained.


```python
data = ['hello', 1, 'world']

for datum in data:
    print(datum*2)
```

    hellohello
    2
    worldworld



```python
data = [1, 2, 3]
2 in data
```




    True



### Tuples

They store heterogeneous data, where the order is relevant.

Sometimes you will see them referred as **immutable lists**.
This is an improper use.

A common use is to pack together multiple return values from a function.


```python
info = ("enrico", "giampieri", "FIS/07")
```


```python
info[0]
```




    'enrico'



They are typically used to return several values at the same time from a function


```python
def min_max(data):
    min_ = min(data)
    max_ = max(data)
    return (min_, max_)

data = [0, 1, 2, 3, 4, 5, 6]
min_, max_ = min_max(data)
print(min_, max_)
```

    0 6


Their greatest limitation is the limited expressivity: each position have a meaning, but there nothing directly expressing that meaning.

to correct this, newer versions of python introduced **namedtuples** in the mix, where the meanings are explicitly referenced by names.


```python
from collections import namedtuple

Person = namedtuple("Person", ['age', 'name'])

person = Person(age=21, name="Tom")
print(person)
print(person.age)
print(person[0])
```

    Person(age=21, name='Tom')
    21
    21


Even more information can be packed in using the **NamedTuple** factory from the typing module, from python 3.6 onward.

This allows to include a class description and informations about the fields expected type (but do not enforce them)


```python
from typing import NamedTuple

class Person(NamedTuple):
    "a person with age and name"
    age: int
    name: str

person = Person(age=21, name="Tom")
print(person)
```

    Person(age=21, name='Tom')


### Dictionaries (maps)

dictionaries encodes relationships between two different groups of values.

it could also be seen as a list indexed by names instead of by position.

these pairs are usually referred as **keys** and **values**.

**values** can be any arbitrary python objects.

**keys** must be hashable objects, such as strings, numbers, booleans, tuples (if all the elements as hashable)


```python
office_by_name = {'Enrico': 'd012', 
                  'Claudia': 'd08'}
office_by_name = dict(Enrico='d012', Claudia='d08')
```


```python
office_by_name.keys()
```




    dict_keys(['Enrico', 'Claudia'])




```python
office_by_name.values()
```




    dict_values(['d012', 'd08'])




```python
for person, office in office_by_name.items():
    print(person, office)
```

    Enrico d012
    Claudia d08



```python
office_by_name['Enrico']
```




    'd012'




```python
'Giulia' in office_by_name
```




    False




```python
info_by_ID = {'001': {'name': 'Enrico', 
                      'office': 'd012'}, 
              '002': {'name': 'Claudia', 
                      'office': 'd08'}
             } 
info_by_ID['001']['office']
```




    'd012'



### Objects

they store data and provide a layer to interact with these data.

We will **not** get into object-oriented programming right now.


```python
class Particle:
    def __init__(self, name, mass, charge=0):
        self.name = name
        self.mass = mass
        self.charge = charge
        
    def invert_charge(self):
        self.charge = - self.charge
        
    def weight(self, g=9.8):
        return self.mass * g
    
my_particle = Particle("mistery particle", 1.4)
my_particle.weight()
```




    13.72



## Advanced data structures

#### Enum


```python
from enum import Enum, auto
class Color(Enum):
    red = auto()
    blue = auto()
    green = auto()
    
Color.red
```




    <Color.red: 1>




```python
for color in Color:
    print(color)
```

    Color.red
    Color.blue
    Color.green


#### Counter


```python
from collections import Counter
data1 = "hello worlds!"
C1 = Counter(data1)
C1
```




    Counter({'h': 1,
             'e': 1,
             'l': 3,
             'o': 2,
             ' ': 1,
             'w': 1,
             'r': 1,
             'd': 1,
             's': 1,
             '!': 1})




```python
data2 = "hello everybody"
C2 = Counter(data2)
C1+C2
```




    Counter({'h': 2,
             'e': 4,
             'l': 5,
             'o': 4,
             ' ': 2,
             'w': 1,
             'r': 2,
             'd': 2,
             's': 1,
             '!': 1,
             'v': 1,
             'y': 2,
             'b': 1})




```python
data1 = "hello worlds!"
C1 = Counter(data1)
C1.update(data2)
C1
```




    Counter({'h': 2,
             'e': 4,
             'l': 5,
             'o': 4,
             ' ': 2,
             'w': 1,
             'r': 2,
             'd': 2,
             's': 1,
             '!': 1,
             'v': 1,
             'y': 2,
             'b': 1})




```python
C1.most_common(3)
```




    [('l', 5), ('e', 4), ('o', 4)]



#### defaultdict


```python
from collections import defaultdict
counter = defaultdict(int)

data = [1, 2, 3, 4, 5, 1, 2, 3, 1, 1, 2]

for datum in data:
    counter[datum] += 1
    
counter
```




    defaultdict(int, {1: 4, 2: 3, 3: 2, 4: 1, 5: 1})




```python
text = "this text has some words that starts with the same letter".split()

index = defaultdict(list)

for word in text:
    initial = word[0]
    index[initial].append(word)
    
index
```


```python

```

# IPython

the main way we will use to interact with python will be the ipython shell.

#### ipython special pre-commands

* `%<magic function>` use magic functions
* `%%<cell magic>` use cell magic mode
* `!<function>` call system programs (non-interactive)
* `/<function>` activate autocalling


    /print "a"


* `,<function>` (comma) activate autocalling and autoquoting (divide by whitespace)
* `;<function>` (comma) activate autocalling and autoquoting (ignore whitespaces)


    ,my_function a b c    # becomes my_function("a","b","c")
    ;my_function a b c    # becomes my_function("a b c")
    
all of these should be used as the first letter, the only exception being `!`, that can follow the `=` assignment

* `?` general help
* `<object>?` help of an object
* `pattern?` return all the variables in the namespace that follow the pattern


```python
%whos
```

    Variable         Type                          Data/Info
    --------------------------------------------------------
    NamedTuple       NamedTupleMeta                <class 'typing.NamedTuple'>
    Particle         type                          <class '__main__.Particle'>
    Person           type                          <class '__main__.Person'>
    a                str                           hello world
    b                str                           2
    data             list                          n=7
    datum            str                           world
    e                float                         2.718281828459045
    log              builtin_function_or_method    <built-in function log>
    math             module                        <module 'math' from '/hom<...>36m-x86_64-linux-gnu.so'>
    max_             int                           6
    min_             int                           0
    min_max          function                      <function min_max at 0x7f66401528c8>
    my_particle      Particle                      <__main__.Particle object at 0x7f662b7e7dd8>
    namedtuple       function                      <function namedtuple at 0x7f665d969400>
    np               module                        <module 'numpy' from '/ho<...>kages/numpy/__init__.py'>
    office_by_name   dict                          n=2
    person           Person                        Person(age=21, name='Tom')
    pi               float                         3.141592653589793
    random           module                        <module 'random' from '/h<...>lib/python3.6/random.py'>
    step             int                           1
    take_logarithm   builtin_function_or_method    <built-in function log>
    text             list                          n=11
    this             module                        <module 'this' from '/hom<...>3/lib/python3.6/this.py'>
    x                int                           3



```python
%whos list
```

    Variable   Type    Data/Info
    ----------------------------
    data       list    n=7
    text       list    n=11



```python
%who_ls int
```




    ['max_', 'min_', 'step', 'x']




```python
def myfun():
    import time
    time.sleep(0.1)
    
%timeit myfun()
```

    100 ms ± 8.86 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)

