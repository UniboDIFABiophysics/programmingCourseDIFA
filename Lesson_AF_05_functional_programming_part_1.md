# Functional programming

**Functional Programming** is the 3th and last programming paradigm that we will discuss, after the **Procedural** and the **Object Oriented** one.

just as a review:

* **procedural** refers to the idea of chaining one direct command after the other, explaining to the machine how to perform each step in order
* **object oriented** refers to the idea of using objects and messages to subdivide the responsabilities of the execution

In the functional programming we shift the attention from **how** to do something and **who** should be doing it, but rather on **what** should be done.

The idea of functional programming derive from the mathematical theory of **lambda (λ) calculus**.

You will see this reflected in some higher level of formality in some passages in these lessons.

One of core concepts of functional programming is the lack of **side effects**.

When it is referred to functions, that implies **function purity** (we discussed this already).

When it is referred to objects, it is defined **immutability**.

Just as a reminder, what are side effects? anything that does change the state of the objects passed as input or world as a whole:

* reading o writing any filesystem, database, network, terminal, screen, etc...
* raising exceptions (this is an hard one in python!)
* accessing global or nonlocal state
* changing any object state

ideally any side effect should only happend at the most external layer of the program, at least as much as posible

To make it clear, functional programming should not be treated as a religious dogma, but more like a guideline.

The more you can align your program with it, the easier it will be to:
* test (in particular unit testing)
* optimize
* parallelize
* reason about

but it is not a rule, only a possible approach!

Funcional programming has also some downsides that you have to keep in mind:

* can bring the programs to be extremely "dense" and somewhat hard to reason about
* most programmers are not familiar with it and might find it difficult to reason about
* the lack of side effects can sometimes require convoluted approaches to solve somewhat simple problems, like recursive functions
* data immutability is not conveniente for big monolithic data structure, where data duplication could lead to serious memory issues (usually one tries to break it down)

in particular the last point is strongly related to the idea of tidy data: if we can represent our data in a tidy fashion, it's often easier to distribute and avoid unnecessary duplications.

In the standard library there are 3 modules that focus all the necessary for functional programming applications:

* **functools**, that contains the main methods for functional programming
* **operator**, a collection of methods intended to be composed with others
* **itertools**, that contains all the function to process and generate iterators

# Functions as first class citizens

As the name implies, functions (in particular pure ones) hold a special place in the theory of functional programming.

The main idea is that functions need to be **first class citizen** of the language, meaning that they can be created, inspected, modified and passed around as arguments to other functions.

In the same way as in Object Oriented programming the whole focus was on creating, inspecting, modifying and passing around objects to do the same.

From python's point of view the distinction between the two is actually less sharp than normal: functions are just another kind of object, objects can behave as functions

## function arity

one definition that will pop up here and there is the concept of **function arity**

this number basically express the number of arguments that a function accepts.

functions with a well defined number of arguments are classified based on them:

0. nullary
1. monadic
2. dyadic
3. triadic
etc..

functions that have a non well defined number of arguments (typically involving the `*args` argument in the function definition) are referred as **variadic**.

in functional programming variadic functions are not very common, because it makes impossible to make assumptions on the number of arguments available and thus some operations (such as currying) becomes undefined.

### Lambdas

The first element we need to talk about are **anonymous functions**, usually referred as **lambdas** in functional programming (from the idea of lambda calculus).

Anonymous functions are functions created on the fly, usually for some small task.

Python allows the creation of lambdas, but with the limitation that they can only contain one single expression (something that returns a value, but not stuff like assignments and such).

```python
    lambda <arguments_list>: <single_expression>
```

lamdas can accept arguments basically with the same exact syntax of a normal function

the definition:

```python
lambda x, y: x+y
```

is exactly equivalent to:

```python

def sum(x, y):
    return x+y
```

Lambdas, due to the way they are defined, are missing insight informations such as the function name, docstrings, etc...

Full disclosure: I explained lambdas just because it's a construct you will find often in the wild.

Personally I **never** use them, and I still have to see a convincing case where using a lambda would be more appropriate than using a fully named function.

Also, most functions that one thinks needs to be implemented as lambdas are usually either:
* better written as a comprehension
* included in the **operator** standard library module
* already a method of the class of object you want to work on
* easily obtained through function composition
* already present in a third party library such as **toolz** (a very common library for functional programming in python)
* better and clearer once implemented as named functions if the previous solutions are not possible

There is actually one situation where I find the lambdas to be useful: interactive programming.

if you are writing code on the fly to perform some operations using python, sometimes it's easier to write a lambda rather than a full fledged function, and it might not be worth the time to search the libraries to find a replacement for it.

## Higher order function

One quirk of the pyhton syntax is the ability to define functions and classes inside the body of other functions and classes.

This means that a function can not only have another function as input, but can also output a third function as a result.

we will see two different application of this ability in **partial** functions and **decorated** functions


```python
def factory(name):
    def internal_function():
        print(f" hi {name}!")
    return internal_function
        
greeter = factory("everybody")
print(greeter)
greeter()
```

    <function factory.<locals>.internal_function at 0x7f077c439af0>
     hi everybody!


for example the following function takes a base function and return another one that repeats the original one a certain number of times.


```python
def repeat(function, n):
    def _internal_function(*args, **kwargs):
        result = []
        for i in range(n):
            res = function(*args, **kwargs)
            results.append(res)
        return result
    return _internal_function

def wave(name):
    return f"hello {name}!"

triple_string = repeat(wave, 3)

triple_string("Paolo")
```




    ['hello Paolo!', 'hello Paolo!', 'hello Paolo!']



### Closures

As you can see, there is something odd in the previous function: we called the external one with the parameter `n=3`, and then we reference that value of n, even if we define a global one with a different value.

The function keeps track of the environment it was created into, and brings with it the values it needs in the future. this is called a **closure**, and it is fundamental for the higher functions management.


```python
triple_string.__closure__
```




    (<cell at 0x7ff3284e8f78: function object at 0x7ff32854d950>,
     <cell at 0x7ff3284e8a98: int object at 0x55a0cf2109e0>)




```python
a = triple_string.__closure__[0]
a.cell_contents
```




    <function __main__.wave(name)>




```python
a = triple_string.__closure__[1]
a.cell_contents
```




    3



### Abstracting program logic

A main use of functional programming is to abstract pieces of logic of a program and encapsulate them in function.

For example, one common pattern that is often encountered is:
1. take a list of objects and a function
2. create a new list
3. one at the time aplly the function to all the elements of the initial list
4. store each result in the new list

This operation is very common in programs, and can be abstracted using the `map` function, that takes a function and a list and does exactly that.

`map` is already implemented in python, but for the sake of teaching, let's implement a simplified version of it


```python
def _map(function, sequence):
    new_seq = []
    for element in sequence:
        result = function(element)
        new_seq.append(result)
    return new_seq

data = ['1', '3', '5.3']
_map(float, data)
```




    [1.0, 3.0, 5.3]




```python
[float(s) for s in data]
```




    [1.0, 3.0, 5.3]



#### example - fixed point function

A common pattern in numerical operations is to use a fixed point function, meaning that we apply a function repeatedly until the result is identical to the input.

This for example is common to iterative solvers: we take an approximate solution, improve it, and if it's not good enough we repeat the procedure

```python
def fixed_point(mapper, stop_condition, starting_state):
    old_state = starting_state
    while True:
        new_state = mapper(old_state)
        if stop_condition(new_state, old_state):
            break
    return new_state
```

This approach allows to create "verbs" that express ideas in a language closer to the one that is used in the specific field that one is working it.

This has the advantage of making the program more readable to those that understand the domain.
At the same time, if one is not familiar with the domain and the verbs defined, it can make it hard to understand.

### partial application

a very common use of higher order functions is partial applications.

partial applications means "freezing" some of the parameters of a function so that they don't need to be re-typed every time.

this is implemented using the function **partial** from the module **functools**.


```python
from functools import partial

def retrieve_key(mapping, keyname):
    return mapping[keyname]

get_name = partial(retrieve_key, keyname='name')

data = {'name': 'luigi', 'age': 39}
get_name(data)
```




    'luigi'



#### note - bound methods

bound methods are, at their most fundamental point, just partial version of the class method, where the first parameter, usually calle `self`, has been bound to the instance calling the method.

If you recall the lesson on object oriented programming, we discussed how to dynamically add attribute to an instance using the `MethodType` from the `types` module.

This is basically how it worked: `MethodType` is nothing more than a glorified **partial**... it does even have the same arguments order!


```python
class Empty:
    pass

namespace = Empty()

def myfun(self):
    return "hello!"

namespace.f = partial(myfun, namespace)
namespace.f()
```




    'hello!'



#### replacing objects with partials

Sometimes we end up defining objects that are just a simple container for a status that gets initialized in the init and then only one method get called everytime.

These objects are basically implementing the partial function, and can be replaced with a restructured function, obtaining even more flexibility in the transition.

```python
class GetDataFromDB:
    def __init__(self, database_uri):
        self.database = database_uri
        
    def query(self, sql_query):
        return self.database.run(sql_query)
```

This can be replace by a simple function, and the the equivalent of the instance of the object replace simply by a partial

```python
def query_db(database_uri, sql_query):
    return database_uri.run(sql_query)

run_on_sqlite = partial(query_db, "my_sqlite_uri")
run_on_sqlite("SELECT * FROM users")
```

Not only is simpler to implement and understand (assuming one knows how partial works), but it also lends itself to a greater generalization.

We could for example bind the other parameter and immediately obtain something that run the same query on several databases!

```python
get_all_db_users = partial(sql_query, "SELECT * FROM users")
get_all_db_users("my_sqlite_uri")
```

Most of the functions that can be found in the operator module are designed to be used with partial, or are returning partial objects.

for example, **itemgetter**, is basically equivalent to the function we implemented earlier (just a bit more powerful, as it can return multiple elements as a tuple)


```python
from operator import itemgetter

data = {'name': 'franco'}

get_name = itemgetter('name')
get_name(data)
```




    'franco'



## Currying

**Currying** a function is a common concept in functional programming, and is often confused with partial applications.

We don't really need currying in python, but if used properly it can lead to some interesting results.

The starting point for the discussion is that currying is a tranformation method applied to a function with a specifi arity (so it is not well defined for variadic functions)

The formal idea is that currying transform a poly-adic function in an equivalent serie of monadic functions.

For example it transform a diadic function in one monadic function, that returns another monadic function that can finally return the result.

Let's see an example of this idea, that could come off as weird at the start.

Let's consider a function that add two numbers.

```python
def add(x, y):
    return x+y
```

the curryfied version of it would be:


```python
def add(x):
    def _add(y):
        return x+y
    return _add

add_3 = add(3)
add_3(4)
```




    7




```python
add(3)(4)
```




    7



This can seem quite contrived, but it can be quite convenient when we want to pipe functions together.

for example, using a map or a filter function with a curried function saves us from having to write unwieldy lambdas:

```python
map(add(3), numbers)
```

going back to the function seen earlier of `attrgetter`, the proper idea is this:

1. we have a function `getattr` that allows us to get a generic attribute from an object
2. the `attrgetter` function from the `operator` is the curried version of that function
3. once the first call `attrgetter("attrname")` has been done, we have a partial application of the base function with the attribute name as the fixed parameter, as if we called `partial(getattr, name="attrname")`
4. once we call it on something else, it extract the chosen attribute and return it to us

In this case we also performed the curry transformation manually, but it is relatively easy to implement a function to do the currying to us.

the library **toolz** provides us as a function that explicitely curry a function in a more elastic way:

```python
from toolz import curry

@curry
def mul(x, y):
    return x * y

double = mul(2) 
double(5)
```

## Decorators

decorators are a "syntax sugar" way of applying monadic functions to other functions.

Let's assume we have a function that, applied to a function, modifies it and returns it (or return another one that does something different).

For example we might want to mark some methods to be save to be called over a web api, and assume all the others are not.
To signal this we could use a function attribute such as `is_web_safe` and set it to true.
the test could be performed on the functions to be called as:

```python
getattr(function, "is_web_safe", False) # if the attribute is missing, it returns False
```


```python
def my_function(param):
    return do_something_with_it(param)
my_function.is_web_safe = True

def set_as_web_safe(function):
    function.is_web_safe = True
    return function

def my_function(param):
    return do_something_with_it(param)
set_as_web_safe(my_function)
```


```python
# we wrap the old function to keep this function pure
def set_web_safe(function):
    def wrapped_fun(*args, **kwargs):
        return function(*args, **kwargs)
    wrapped_fun.is_web_safe = True
    return wrapped_fun
```


```python
def myfunction(a, b):
    return a+b
```

we would apply `set_web_safe` to `myfunction`, and a good option would be to override the original name with the function returned.

we wrote a pure function that returns a wrapper to the old one, so to avoid nasty side effects, and we want the user to not have access anymore to the old, undecorated one!


```python
myfunction = set_web_safe(myfunction)
```


```python
myfunction.is_web_safe
```




    True



this operation is so common that python provides an easier way to do it: the **decorator**.

You have already seen them, are those names preceded by `@` before the definition of a function


```python
@set_web_safe
def myfunction(a, b):
    return a+b

myfunction.is_web_safe
```




    True



Wrapping could also be used for things like logging, control checks on the parameters, and so on.


```python
logger = []
def logging_wrapper(func_to_wrap):
    def _wrap(*args, **kwargs):
        result = func_to_wrap(*args, **kwargs)
        logger.append({'args': args, 
                       'kwargs': kwargs, 
                       'result':result})
        return result
    return _wrap
```


```python
@logging_wrapper
def mysum(a, b):
    """docstring of mysum"""
    return a+b

mysum(3, 4)
```




    7




```python
print(logger)
```

    [{'args': (3, 4), 'kwargs': {}, 'result': 7}]


on this note, when returning some form of wrapper fucntion it is usually a good idea to make sure that the wrapping function returns the same interface as the wrapped one, otherwise it could create some confusion.

This can be done using `from functools import wraps`


```python
help(mysum)
```

    Help on function _wrap in module __main__:
    
    _wrap(*args, **kwargs)
    



```python
from functools import wraps

logger = []
def logging_wrapper(func_to_wrap):
    @wraps(func_to_wrap)
    def _wrap(*args, **kwargs):
        result = func_to_wrap(*args, **kwargs)
        logger.append((args, kwargs, result))
        return result
    return _wrap
```


```python
@logging_wrapper
def mysum(a, b):
    """docstring of mysum"""
    return a+b

mysum(3, 4)
```




    7




```python
help(mysum)
```

    Help on function mysum in module __main__:
    
    mysum(a, b)
        docstring of mysum
    


You might have seen decorators that take arguments.

The easiest way to create this kind of decorator is to implement them using a class.

Due to the way that decorators are defined implementing them using functions means creating a function that returns the decorator that then operates on the function given as an argument.

yeah, it's messy...


```python
from dataclasses import dataclass

@dataclass
class DecoratorWithArguments:
    a: int = 1
    b: int = 3
        
    def __call__(self, function):
        """this behaves like a normal decorator"""
        function.a = self.a
        function.b = self.b
        return function
        
@DecoratorWithArguments(a=1)
def myfunction(a, b):
    return a+b

myfunction.a, myfunction.b
```




    (1, 3)



## Least Recently Used (LRU) Cache

Having functions that works without any side effects means that we have **referential transpacency**, meaning that there is no difference between the function call and the result and we could freely swap the two.

This is fundamental to allow caching, meaning to be able to save previous results of a computation and avoid redoing the calculation again!

python support this by using the `functools.lru_cache` decorator, that activate caching the values of a function.

It is possible to specify a limit to this cache (how many element it should store), as `functools.lru_cache(maxsize=N)`, where N is best set to a power of two for computational efficiency


```python
import time

def fib(n):
    time.sleep(0.1)
    if n < 2:
        return n
    return fib(n-1) + fib(n-2)

%timeit fib(5)
```

    1.5 s ± 65.7 µs per loop (mean ± std. dev. of 7 runs, 1 loop each)



```python
from functools import lru_cache
@lru_cache(maxsize=None)
def fib(n):
    time.sleep(0.1)
    if n < 2:
        return n
    return fib(n-1) + fib(n-2)

%timeit fib(5)
```

    865 ns ± 234 ns per loop (mean ± std. dev. of 7 runs, 1 loop each)



```python
fib.cache_info()
```




    CacheInfo(hits=10, misses=6, maxsize=None, currsize=6)



# single dispatch

Single dispatch is a way of writing functions that recognize the type of the first object called, allowing for a low-level object oriented code.

This allow to write generic functions that can be easily combined in iteration functions such *map*, as they can receive iterable containing a mix of different object and be able to manage all of them.

This can be managed with a combinations of **if-else** and **isinstance** calls, but this approach allows a more readable approach

Let's say that I want to write a function that calculates the mean of an iterable, but uses more efficient functions when available, such as for numpy arrays


```python
from functools import singledispatch
from statistics import mean
import numpy as np

def average(iterable):
    if isinstance(iterable, np.ndarray):
        print("using the specific (and fast) numpy mean")
        return iterable.mean()
    else:
        print("using the generic (and slow) python mean")
        return mean(iterable)
```


```python
average([1, 2, 3])
```

    using the generic (and slow) python mean





    2




```python
data = np.array([1, 2, 3])
average(data)
```

    using the specific (and fast) numpy mean





    2.0



Single dispatch methods allow us to avoid using all those checks explicitely, doing it instead under the hood for us.

It also add the advantage that, if we want to write a specific version of the `average` function for a class of our writing, we don't need to tamper with the original one, but can extend it in a simple way


```python
@singledispatch
def average(iterable):
    print("using the generic (and slow) python mean")
    return mean(iterable)

@average.register(np.ndarray)
def _(np_array):
    print("using the specific (and fast) numpy mean")
    return np_array.mean()
```


```python
average([1, 2, 3])
```

    using the generic (and slow) python mean





    2




```python
data = np.array([1, 2, 3])
average(data)
```

    using the specific (and fast) numpy mean





    2.0



since python 3.7 the single dispatch functions can be defined by simply using type annotations, without needing to specify the type in the register call.


```python
@singledispatch
def average(iterable):
    print("using the generic (and slow) python mean")
    return mean(iterable)

@average.register
def _(np_array: np.ndarray):
    print("using the specific (and very fast) numpy mean")
    return np_array.mean()
```


```python
average([1, 2, 3])
```

    using the generic (and slow) python mean





    2




```python
data = np.array([1, 2, 3])
average(data)
```

    using the specific (and very fast) numpy mean





    2.0



## method dispatching

python 3.8 introduced also `singledispatchmethod`, that allow to perform single dispatch from methods.

a dedicated function is required to avoid weird interactions with the *bounding* process of method calling


```python
from functools import singledispatchmethod
from dataclasses import dataclass
from numbers import Number

@dataclass
class Container:
    value: Number
    
    @singledispatchmethod
    def __add__(self, other):
        return NotImplemented
    
    @__add__.register
    def _(self, other: Number):
        return self.__class__(self.value+other)
    
    # the forward reference does not work on pyhton 3.9!
    # https://bugs.python.org/issue41987
    #@__add__.register
    #def _(self, other: Container):
    #    return self.__class__(self.value + other.value)
```


```python
cont = Container(3)
print(cont)
print(cont+"1")
```

    Container(value=3)



    ---------------------------------------------------------------------------

    TypeError                                 Traceback (most recent call last)

    Input In [28], in <cell line: 3>()
          1 cont = Container(3)
          2 print(cont)
    ----> 3 print(cont+"1")


    TypeError: unsupported operand type(s) for +: 'Container' and 'str'



```python
cont = Container(3)
print(cont)
print(cont+1)
```

    Container(value=3)
    Container(value=4)


a way to circumvent the current bug with forward referencing, is to use a guard clause in the base function


```python
@dataclass
class Container:
    value: Number
    
    @singledispatchmethod
    def __add__(self, other):
        if isinstance(other, self.__class__):
            return self.__class__(self.value + other.value)
        return NotImplemented
    
    @__add__.register
    def _(self, other:Number):
        return self.__class__(self.value+other)

cont_a = Container(3)
cont_b = Container(2)
print(cont_a+cont_b)
print(cont_a+2)
```

    Container(value=5)
    Container(value=5)


## Function Hooks

A concept similar to single dispatch is function hooking:

* the function will perform some default operation on the datasets
* on functions that conform to a specific protocol, it will call the specialized function

we can implement this quite easily in python using the Protocol definition we discussed in the OOP lesson

this is the basic working underneat the `len` function:
* if the objects defines a `__len__` function, it defers to it
* otherwise it tries to iterate and count the number of elements


```python
from typing import Protocol, runtime_checkable

@singledispatch
def average(array):
    "when not defined, try to use numpy"
    return np.mean(array)

@runtime_checkable
class Provide_mean(Protocol):
    "this is the protocol to identify classes that have a __mean__ function"
    def __mean__(self) -> Number:
        pass

@average.register
def _(instance: Provide_mean):
    "if the class has a __mean__ function, calls it"
    return instance.__mean__()

class MyClass:
    def __mean__(self):
        return "mean of the class called"
        
print(average([1, 2, 3]))
pippo = MyClass()
print(average(pippo))
```

    2.0
    mean of the class called


# Example: creating a pipe function

A pipe function is a way of writing in compact form pipelines of functions, where the result of a function is passed to the the following one.

for example, we might have the following situation: we gets a string, that we know contains a number, and we want to display it after rounding up to the first decimal position.


```python
string = " 3.1415 "
print(round(float(str.strip(string)), 1))
```

    3.1


it's horrible, can we al agree?

and everytime we want to repeat that, we have to reuse that monstrosity.

We could implement it as a single function, of course, and would be legitimate, but functional programming offer us an interesting alternative: creating a function that takes a series of functions and apply it to an object


```python
def apply_pipe(func_serie, obj):
    for function in func_serie:
        obj = function(obj)
    return obj
```


```python
from functools import partial
apply_pipe(
    [
        str.strip, 
        float, 
        partial(round, ndigits=1), 
        print
    ], 
    string,
)
```

    3.1


This has the advantage of displaying our intention in a more human-readable format, but also, exploiting `partial`, can be easily generalized!


```python
print_with_one_digit = partial(
    apply_pipe, 
    [
        str.strip, 
        float, 
        partial(round, ndigits=1), 
        print,
    ])
print_with_one_digit(string)
```

    3.1


if we think that we might need this often, we can again generalize it, by automatically generate the partial application


```python
def create_pipe(func_list):
    return partial(apply_pipe, func_list)

print_with_one_digit = create_pipe(
    [str.strip, float, partial(round, ndigits=1), print]
)
print_with_one_digit(string)
```

    3.1

