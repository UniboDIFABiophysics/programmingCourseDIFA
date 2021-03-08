# Functional programming

## part 2 - iterators

# Iterators

The framework of functions as first class citizens already gives us a lot of power, but we also need something to apply those function on.

The most common application of functional programming is sequence manipulation.
In particular, these sequences are represented by **iterators**.

Iterators are something that can be iterated over, i.e. can run a for loop over.

The two biggest defining characteristic of iterators are that they are:
* lazy
* irreversible

this means that they don't return any values until they are explicitely demanded to do to, and once they returned that value, they don't keep any track of it.
This means that they will only be able to be iterated over once.

this seems counterintuitive: I can iterate on a list how many times I want!


```python
my_list = [1, 2]
print("--- first iteration ---")
for element in my_list:
    print(element)
print("--- second iteration ---")
for element in my_list:
    print(element)
```

    --- first iteration ---
    1
    2
    --- second iteration ---
    1
    2


what is happening is that python does not actually iterate of the list!

Everytime you put the list in a for loop, python generates an iterator for the list, loops over it and discard it.

we can explicitely do the generation ourselves using the `iter` function


```python
my_list = [1, 2]
my_list_iterator = iter(my_list)

print("--- first iteration ---")
for element in my_list_iterator:
    print(element)
print("--- second iteration ---")
for element in my_list_iterator:
    print(element)
```

    --- first iteration ---
    1
    2
    --- second iteration ---


this is the default behavior for files, for example: once you iterate over them, you have to reset them or they will not iterate anymore!

to reset it we can use the `file.seek(0)` function.

but file-reading is an exception, resetting the sequence is normally not possible or desirable


```python
%%file temp.txt
tuna
mayo
bread
```

    Overwriting temp.txt



```python
with open("temp.txt") as infile:
    for line in infile:
        print(line.strip())
    print('-'*20)
    for line in infile:
        print(line.strip())
```

    tuna
    mayo
    bread
    --------------------



```python
with open("temp.txt") as infile:
    for line in infile:
        print(line.strip())
    print('-'*20)
    infile.seek(0)
    for line in infile:
        print(line.strip())
```

    tuna
    mayo
    bread
    --------------------
    tuna
    mayo
    bread


we can control the advancement of our iterator by using the function `next`


```python
my_list = [1, 2]
my_list_iterator = iter(my_list)
```


```python
next(my_list_iterator)
```




    1




```python
next(my_list_iterator)
```




    2




```python
next(my_list_iterator)
```


    ---------------------------------------------------------------------------

    StopIteration                             Traceback (most recent call last)

    <ipython-input-154-19e354f49d7b> in <module>
    ----> 1 next(my_list_iterator)
    

    StopIteration: 


The `StopIteration` is the signal that the iteration is ended.
We could in theory implement an artigianal version of the for loop using an infinite while cycle:


```python
mylist = [1, 2, 3]
for element in mylist:
    print(element)
```

    1
    2
    3



```python
iterator = iter(mylist)
while True:
    try:
        element = next(iterator)
        print(element)
    except StopIteration:
        break
```

    1
    2
    3


the `next` method also have a possible default to be returned if the sequence is terminated


```python
my_list = [1, 2]
my_list_iterator = iter(my_list)
assert next(my_list_iterator)==1
assert next(my_list_iterator)==2
next(my_list_iterator, "end of iteration")
```




    'end of iteration'



Of course this is not a very efficient way of doing it, but it helps to clarify what is going on under the hood.

The most important property of the iterators is that, by combining lazyness and irreversibility, they can potentially represent huge sequences (or even infinite) without any issues.

After all, unless you ask to see all the elements, but only some of them, the iterator is not going to be fazed by it.

This is not hypotetical: in the **itertools** library there is a function `count` that literally counts from 0 to infinity!

One of the most common iterators that we used is the `range` function, as well as the `enumerate` one.

In particular `enumerate` is a function that takes an iterator as input and returns anoter iterator as output.

This is very similar to what we seen when we discussed function manipulation.

The python structure to implement this function while maintaing the lazy and lightweight nature of the iterators are the **generators**

## Generators

Generators are special function that allow to perform lazy iteration

when called they create a **generator object**, but do not execute anything (more or less, see later).

the proper execution starts when one iterates over them.

for each call to `next` done to them they return one value, pause their execution and wait to be called again.

In a way they are half-way between a function and an object

for more in-detail information, read: https://www.dabeaz.com/generators/

The only difference between a generator and a normal function is the usage of `yield` instead of `return` to give back the result of the function.

using `return` inside a generator is possible but nothing will happen and will break the flow.
Just don't do it.


```python
def my_generator():
    yield 1
    yield 4
    yield 9
    
for i in my_generator():
    print(i)
```

    1
    4
    9



```python
iterable = my_generator()
print(next(iterable))
print(next(iterable))
print(next(iterable))
```

    1
    4
    9



```python
# they don't execute until iterated over!
def my_generator():
    print("prepare the state. this does not execute until the first `next`")
    yield 1
    yield 4
    yield 9
    
gen = my_generator()
```


```python
next(gen)
```

    prepare the state. this does not execute until the first `next`





    1



There are two main uses for generators:
* generate a new sequence of data from a starting value (for example iterating all the numbers up to a value in `range`)
* take a sequence and generate a new one performing some operation on it (for example adding an index such as `enumerate`)


```python
# generate an infinite sequence
def fibonacci():
    a, b = 1, 1
    while True:
        yield a
        a, b = b, a+b
        
sequence = fibonacci()
numbers = [next(sequence) for i in range(8)]
numbers
```




    [1, 1, 2, 3, 5, 8, 13, 21]




```python
# modify an existing sequence
def square(sequence):
    for element in sequence:
        yield element**2
        
data = [1, 2, 3, 4]
list(square(data))
```




    [1, 4, 9, 16]



### `yield from` - concatenating generators


```python
def _cat(seq_1, seq_2):
    for element in seq_1:
        yield element
    for element in seq_2:
        yield element

def cat(seq_1, seq_2):
    yield from seq_1
    yield from seq_2
    
data_1 = [1, 2, 3]
data_2 = [4, 5, 6]
list(cat(data_1, data_2))
```




    [1, 2, 3, 4, 5, 6]




```python
def cat(*sequences):
    for sequence in sequences:
        yield from sequence
        
data_1 = [1, 2, 3]
data_2 = [4, 5, 6]
list(cat(data_1, data_2))
```




    [1, 2, 3, 4, 5, 6]



### generator comprehension


```python
def _(seq):
    for element in seq:
        yield element**2

data = (x**2 for x in [1, 2, 3])
print(data)
```

    <generator object <genexpr> at 0x7fbd1c1c8678>



```python
list(data)
```




    [1, 4, 9]



as a matter of facts, list, dict and set coprehensions can be seen as a particular case of generator comprehension that also concretize the generator in a data structure!

#### the advantage of lazy evaluation

one does not need to evaluate all the results of a computation, but only the one they need.
This can be important when calculating the items is expensive.

consider this kind of code:
```python
any([item.is_positive() for item in collection])
```

this will estimate the `is_positive` function for all the items in the collection, even if our function only need to find one positive result to return.
All the other values after that are useless!

using a generator expression we can avoid all the function call after the first positive result...and it's also shorter!

```python
any(item.is_positive() for item in collection)
```

### side note - generators and context managers

generators are a very useful tool to generate context managers, using the `contextmanager` decorator from the `contextlib` module.

This decorator takes a generator as an input and returns a context manager as an output


```python
from contextlib import contextmanager

@contextmanager
def test_manager(name):
    print(f"hello {name}, entering the manager")
    yield
    print(f"hello {name}, exiting the manager")
    
with test_manager("Franco"):
    print("I'm inside the manager")
```

    hello Franco, entering the manager
    I'm inside the manager
    hello Franco, exiting the manager


context managers are an extremely common structure in programming.
They are useful any time one has to guarantee that something will happen before and after a piece of code.
This is typical of:

* change the status of the program and then revert it back
* get a resource, do something with it and then release it (locks in parallel programming)


```python
@contextmanager
def duration():
    from datetime import datetime
    import logging
    start = datetime.now()
    try:
        yield
    finally:
        end = datetime.now()
        logging.warning(end-start)
```


```python
with duration():
    import time
    time.sleep(0.5)
    a = [i for i in range(1000)]
```

    WARNING:root:0:00:00.500756



```python
@contextmanager
def print_as_log():
    import logging
    _old_print = print
    globals()['print'] = logging.warning
    try:
        yield
    finally:
        globals()['print'] = _old_print
```


```python
with print_as_log():
    print("ciao mondo!")
```

    WARNING:root:ciao mondo!



```python
@contextmanager
def get_sorted_list():
    result = []
    yield result
    result.sort()
```


```python
with get_sorted_list() as mylist:
    mylist.append(3)
    mylist.append(1)
    
print(mylist)
```

    [1, 3]



```python
@contextmanager
def ignore_exceptions(*exception_classes):
    try:
        yield
    except exception_classes:
        pass
    
```


```python
with ignore_exceptions(IndexError, ValueError):
    a = [1, 2]
    a[4]
```


```python
with ignore_exceptions(IndexError):
    a = 1 + "2"
```


    ---------------------------------------------------------------------------

    TypeError                                 Traceback (most recent call last)

    <ipython-input-38-792d97826bdf> in <module>
          1 with ignore_exceptions(IndexError):
    ----> 2     a = 1 + "2"
          3 


    TypeError: unsupported operand type(s) for +: 'int' and 'str'



```python
with ignore_exceptions(IndexError, TypeError):
    a = 1 + "2"
```

## Map

A very common operation on sequences is the **mapping** operation, that consist in applying a function to all the elements of an iterable and returning them one at the time

For example, I might want to obtain the square of every number in a sequence


```python
numbers = [0, 1, 2, 3, 4, 5, 6]
squares = []
for number in numbers:
    square = number **2
    squares.append(square)
    
print(squares)
```

    [0, 1, 4, 9, 16, 25, 36]


This can be written in a shorter and more readable way using a *generator comprehension*, that is has the same behavior as the code above.


```python
numbers = [0, 1, 2, 3, 4, 5, 6]
squares = (x**2 for x in numbers)
print(list(squares))
```

    [0, 1, 4, 9, 16, 25, 36]


The concept of **map** is an abstraction of this idea.

Python provide a function, called `map`, that takes a function and an iterator and returns a new iterator that have as elements the function applied to each element of the original sequence


```python
def square(n):
    return n**2

numbers = [0, 1, 2, 3, 4, 5, 6]
squares = map(square, numbers)
print(squares)
```

    <map object at 0x7fbd0e6e6e80>


We have to remember that the result is an iterator, and as such, we don't obtain any result until we explicitely ask for them

If we want to see the results we can concretize them in a container such as `list`


```python
list(squares)
```




    [0, 1, 4, 9, 16, 25, 36]



We should also remember that iterators are irreversible, so we can only iterate on them once.

This means that we can only create a list out of them once.


```python
list(squares)
```




    []



The basic implementation of map as a generator is the following:


```python
def _map(function, sequence):
    for item in sequence:
        yield function(sequence)
```

the builtin map function has an additional ability: if the function passed takes many parameters, and one passes several iterators to it, it will return the sequence of the function applied to all the tuples of items composed from the various sequences.


```python
def _add(a, b):
    return a+b

list(map(_add, [1, 2, 3], [4, 5, 6]))
```




    [5, 7, 9]



so the complete implementation of map would be something like:


```python
def _map(function, *sequences):
    for items in zip(*sequences):
        yield function(*items)
```


```python
list(_map(_add, [1, 2, 3], [4, 5, 6]))
```




    [5, 7, 9]



We could implement an alternative version of map, that takes named arguments instead of just ordered ones.

for each named parameter we get a sequence, so that we can call the function as:

```python
def _add(a, b):
    return a+b

list(_map(_add, b=[1, 2, 3], a=[4, 5, 6]))
```

to be able to use this we have to pass a dictionary splitting the lists into a series of dictionaries


```python
kwargs = {'a': [1, 2, 3], 'b': [4, 5, 6]}
names = kwargs.keys()
values = kwargs.values()
```


```python
first = next(zip(*values))
first
```




    (1, 4)




```python
list(zip(names, first))
```




    [('a', 1), ('b', 4)]




```python
values_pairs = list(zip(*values))
values_pairs
```




    [(1, 4), (2, 5), (3, 6)]




```python
couples = [list(zip(names, value)) for value in values_pairs]
couples
```




    [[('a', 1), ('b', 4)], [('a', 2), ('b', 5)], [('a', 3), ('b', 6)]]




```python
[dict(c) for c in couples]
```




    [{'a': 1, 'b': 4}, {'a': 2, 'b': 5}, {'a': 3, 'b': 6}]




```python
def _map(function, **kw_seq):
    names = kw_seq.keys()
    kw_sequences = kw_seq.values()
    kwargs_seq = zip(*kw_sequences)
    kw_seq = (dict(zip(names, values)) for values in kwargs_seq)
    for kwarg in kw_seq:
        yield function(**kwarg)
```


```python
def _add(a, b):
    return a-b

list(_map(_add, b=[1, 2, 3], a=[4, 5, 6]))
```




    [3, 3, 3]




```python
from itertools import repeat

def _add_pow(a, b, p):
    return a-b**p

list(_map(_add_pow, b=[1, 2, 3], a=[4, 5, 6], p=repeat(2)))
```




    [3, 1, -3]



## Filter

Filter uses a similar logic, but instead of applying a function, it selects only those elements in the sequence where the property is true.

this is implemented by the `filter` function in base python.


```python
numbers = [-2, -1, 0, 1, 2]
positive = []
for number in numbers:
    if number>0:
        positive.append(number)

print(positive)
```

    [1, 2]


In a similar way to the **map** operation, the **filter** can be implemented as a comprehension


```python
numbers = [-2, -1, 0, 1, 2]
positive = (x for x in numbers if x>0)
print(list(positive))
```

    [1, 2]


It is also possible to combine the map and filter operation in a comprehension, obtaining the full expression for the generator comprehension!


```python
numbers = [-2, -1, 0, 1, 2]
squares_of_positive = (x**2 for x in numbers if x>0)
print(list(squares_of_positive))
```

    [1, 4]


Exactly as before, we have a function **filter** that takes an iterator and a function that returns true or false (keep the element or drop it)


```python
def is_positive(n):
    return n>0

positivi = filter(is_positive, numbers)
print(list(positivi))
```

    [1, 2]


From a formal perspective a filter function should be a pure function, so it should not depend on a state.

using generators it is possible to implement less pure, but sometimes more useful, type of filtering.


```python
# keep only the incremental values, dropping those that diminish
def incremental(sequence):
    last = None
    for item in sequence:
        if last is None or item>=last:
            yield item
            last = item

data = [1, 2, 3, 1, 4, 2, 5]
list(incremental(data))
```




    [1, 2, 3, 4, 5]




```python
# we can generalize by returning the pairs of elements
def pairwise(seq):
    seq = iter(seq)
    previous = next(seq)
    for element in seq:
        yield (previous, element)
        previous = element

data = [1, 2, 3, 1, 4, 2, 5]
pairs = list(pairwise(data))
print(pairs)
# return only the values where the first value is greater than the one that follows
result = (p[1] for p in pairs if p[1]>=p[0])
list(result)
```

    [(1, 2), (2, 3), (3, 1), (1, 4), (4, 2), (2, 5)]





    [2, 3, 4, 5]



### notes on parameter ordering

Sometimes it might seem weird the choice of parameter ordering, such as using the function as first argument rather than as last.

This is often due to the desire to combine this functions with **partial** applications and other functional tools such as those seen in the previous lessons.


```python
def is_positive(x):
    return x>0

def square(x):
    return x**2

data = [-1, 2, -3, 4]
result = map(square, filter(is_positive, data))
print(list(result))
```

    [4, 16]



```python
from functools import partial

only_positive = partial(filter, is_positive)
get_squares = partial(map, square)

result = get_squares(only_positive(data))
print(list(result))
```

    [4, 16]


## Reduce

Finally, after we transform and filter the data (and combine them in various ways), we can perform an operation of **reduction**.

Reduction operations take the element one by one and combine them in a single "pot".

One simple example is to sum all the values thta are observed divided by group.


```python
numbers = [1, 2, 3, 4]
total = 0
for number in numbers:
    total += number
    
print(total)
```

    10


as before, there is a function that implements it given a sequence and a combination function.

the only difference is that is not in the builtins but in the `functools`


```python
from functools import reduce

def add(a, b):
    return a+b

numbers = [1, 2, 3, 4]
total = reduce(add, numbers, 0)
print(total)
```

    10


These kind of operations are so common that the most common one are already implemented as default functions:

* **sum** for summing
* **min** and **max** for estimating the minimum and maximum of a sequence
* **all** and **any** for logical operations

A typical reduction that is often used, is frequency estimation


```python
from collections import Counter
numbers = [1, 1, 1, 2, 2, 3, 3, 4, 4, 4, 4, 4]
Counter(numbers)
```




    Counter({1: 3, 2: 2, 3: 2, 4: 5})



The interesting property of the reductions is that the results can be combined: given the counts of two series, I can sum the counts and obtain the result of the counts in the combinations of the two original series.

For example, in the case of Counter, various Counters can be summed together.

The formal definition is the following:

**DATA**:
* Array of Type B

**DEFAULT**:
* Type A (can be equal to B)

**FUNCTION**:
* Type A + Type B -> Type A
* Type A + Type A -> Type A




```python
def double(x): return 2*x
def square(x): return x**2

def apply_function(number, function):
    return function(number)

reduce(apply_function, [double, square, double], 2)
```




    32




```python
def generate_pipe(*functions):
    def execute(value):
        return reduce(apply_function, functions, value)
    return execute

pipe = generate_pipe(double, square, double)
pipe(2)
```




    32



## Map Reduce

The famous MAP-REDUCE approach is a combination of these approaches:
* take a sequence, divide it into sub-sequences
* divide them across several servers
* perform the transformation and reduction on each server independently
* collect the partial result of each server and combine them
* recursively combine them all until the final result is obtained

## Itertools - functions to manipulate iterators

python provides few useful functions to manipulate iterators at the builtins level, namely:

* map
* filter
* reducers (sum, max, min, all, any)
* range
* enumerate
* zip

but it also provides plenty of other functions, really useful, in the **itertools** module

**Infinite iterators:**

<table border="1" class="docutils">
<colgroup>
<col width="14%" />
<col width="14%" />
<col width="39%" />
<col width="33%" />
</colgroup>
<thead valign="bottom">
<tr class="row-odd"><th class="head">Iterator</th>
<th class="head">Arguments</th>
<th class="head">Results</th>
<th class="head">Example</th>
</tr>
</thead>
<tbody valign="top">
<tr class="row-even"><td><a class="reference internal" href="#itertools.count" title="itertools.count"><code class="xref py py-func docutils literal notranslate"><span class="pre">count()</span></code></a></td>
<td>start, [step]</td>
<td>start, start+step, start+2*step, …</td>
<td><code class="docutils literal notranslate"><span class="pre">count(10)</span> <span class="pre">--&gt;</span> <span class="pre">10</span> <span class="pre">11</span> <span class="pre">12</span> <span class="pre">13</span> <span class="pre">14</span> <span class="pre">...</span></code></td>
</tr>
<tr class="row-odd"><td><a class="reference internal" href="#itertools.cycle" title="itertools.cycle"><code class="xref py py-func docutils literal notranslate"><span class="pre">cycle()</span></code></a></td>
<td>p</td>
<td>p0, p1, … plast, p0, p1, …</td>
<td><code class="docutils literal notranslate"><span class="pre">cycle('ABCD')</span> <span class="pre">--&gt;</span> <span class="pre">A</span> <span class="pre">B</span> <span class="pre">C</span> <span class="pre">D</span> <span class="pre">A</span> <span class="pre">B</span> <span class="pre">C</span> <span class="pre">D</span> <span class="pre">...</span></code></td>
</tr>
<tr class="row-even"><td><a class="reference internal" href="#itertools.repeat" title="itertools.repeat"><code class="xref py py-func docutils literal notranslate"><span class="pre">repeat()</span></code></a></td>
<td>elem [,n]</td>
<td>elem, elem, elem, … endlessly or up to n times</td>
<td><code class="docutils literal notranslate"><span class="pre">repeat(10,</span> <span class="pre">3)</span> <span class="pre">--&gt;</span> <span class="pre">10</span> <span class="pre">10</span> <span class="pre">10</span></code></td>
</tr>
</tbody>
</table>

**Iterators terminating on the shortest input sequence:**
    
<table border="1" class="docutils">
<colgroup>
<col width="17%" />
<col width="17%" />
<col width="30%" />
<col width="37%" />
</colgroup>
<thead valign="bottom">
<tr class="row-odd"><th class="head">Iterator</th>
<th class="head">Arguments</th>
<th class="head">Results</th>
<th class="head">Example</th>
</tr>
</thead>
<tbody valign="top">
<tr class="row-even"><td><a class="reference internal" href="#itertools.accumulate" title="itertools.accumulate"><code class="xref py py-func docutils literal notranslate"><span class="pre">accumulate()</span></code></a></td>
<td>p [,func]</td>
<td>p0, p0+p1, p0+p1+p2, …</td>
<td><code class="docutils literal notranslate"><span class="pre">accumulate([1,2,3,4,5])</span> <span class="pre">--&gt;</span> <span class="pre">1</span> <span class="pre">3</span> <span class="pre">6</span> <span class="pre">10</span> <span class="pre">15</span></code></td>
</tr>
<tr class="row-odd"><td><a class="reference internal" href="#itertools.chain" title="itertools.chain"><code class="xref py py-func docutils literal notranslate"><span class="pre">chain()</span></code></a></td>
<td>p, q, …</td>
<td>p0, p1, … plast, q0, q1, …</td>
<td><code class="docutils literal notranslate"><span class="pre">chain('ABC',</span> <span class="pre">'DEF')</span> <span class="pre">--&gt;</span> <span class="pre">A</span> <span class="pre">B</span> <span class="pre">C</span> <span class="pre">D</span> <span class="pre">E</span> <span class="pre">F</span></code></td>
</tr>
<tr class="row-even"><td><a class="reference internal" href="#itertools.chain.from_iterable" title="itertools.chain.from_iterable"><code class="xref py py-func docutils literal notranslate"><span class="pre">chain.from_iterable()</span></code></a></td>
<td>iterable</td>
<td>p0, p1, … plast, q0, q1, …</td>
<td><code class="docutils literal notranslate"><span class="pre">chain.from_iterable(['ABC',</span> <span class="pre">'DEF'])</span> <span class="pre">--&gt;</span> <span class="pre">A</span> <span class="pre">B</span> <span class="pre">C</span> <span class="pre">D</span> <span class="pre">E</span> <span class="pre">F</span></code></td>
</tr>
<tr class="row-odd"><td><a class="reference internal" href="#itertools.compress" title="itertools.compress"><code class="xref py py-func docutils literal notranslate"><span class="pre">compress()</span></code></a></td>
<td>data, selectors</td>
<td>(d[0] if s[0]), (d[1] if s[1]), …</td>
<td><code class="docutils literal notranslate"><span class="pre">compress('ABCDEF',</span> <span class="pre">[1,0,1,0,1,1])</span> <span class="pre">--&gt;</span> <span class="pre">A</span> <span class="pre">C</span> <span class="pre">E</span> <span class="pre">F</span></code></td>
</tr>
<tr class="row-even"><td><a class="reference internal" href="#itertools.dropwhile" title="itertools.dropwhile"><code class="xref py py-func docutils literal notranslate"><span class="pre">dropwhile()</span></code></a></td>
<td>pred, seq</td>
<td>seq[n], seq[n+1], starting when pred fails</td>
<td><code class="docutils literal notranslate"><span class="pre">dropwhile(lambda</span> <span class="pre">x:</span> <span class="pre">x&lt;5,</span> <span class="pre">[1,4,6,4,1])</span> <span class="pre">--&gt;</span> <span class="pre">6</span> <span class="pre">4</span> <span class="pre">1</span></code></td>
</tr>
<tr class="row-odd"><td><a class="reference internal" href="#itertools.filterfalse" title="itertools.filterfalse"><code class="xref py py-func docutils literal notranslate"><span class="pre">filterfalse()</span></code></a></td>
<td>pred, seq</td>
<td>elements of seq where pred(elem) is false</td>
<td><code class="docutils literal notranslate"><span class="pre">filterfalse(lambda</span> <span class="pre">x:</span> <span class="pre">x%2,</span> <span class="pre">range(10))</span> <span class="pre">--&gt;</span> <span class="pre">0</span> <span class="pre">2</span> <span class="pre">4</span> <span class="pre">6</span> <span class="pre">8</span></code></td>
</tr>
<tr class="row-even"><td><a class="reference internal" href="#itertools.groupby" title="itertools.groupby"><code class="xref py py-func docutils literal notranslate"><span class="pre">groupby()</span></code></a></td>
<td>iterable[, key]</td>
<td>sub-iterators grouped by value of key(v)</td>
<td>&#160;</td>
</tr>
<tr class="row-odd"><td><a class="reference internal" href="#itertools.islice" title="itertools.islice"><code class="xref py py-func docutils literal notranslate"><span class="pre">islice()</span></code></a></td>
<td>seq, [start,] stop [, step]</td>
<td>elements from seq[start:stop:step]</td>
<td><code class="docutils literal notranslate"><span class="pre">islice('ABCDEFG',</span> <span class="pre">2,</span> <span class="pre">None)</span> <span class="pre">--&gt;</span> <span class="pre">C</span> <span class="pre">D</span> <span class="pre">E</span> <span class="pre">F</span> <span class="pre">G</span></code></td>
</tr>
<tr class="row-even"><td><a class="reference internal" href="#itertools.starmap" title="itertools.starmap"><code class="xref py py-func docutils literal notranslate"><span class="pre">starmap()</span></code></a></td>
<td>func, seq</td>
<td>func(*seq[0]), func(*seq[1]), …</td>
<td><code class="docutils literal notranslate"><span class="pre">starmap(pow,</span> <span class="pre">[(2,5),</span> <span class="pre">(3,2),</span> <span class="pre">(10,3)])</span> <span class="pre">--&gt;</span> <span class="pre">32</span> <span class="pre">9</span> <span class="pre">1000</span></code></td>
</tr>
<tr class="row-odd"><td><a class="reference internal" href="#itertools.takewhile" title="itertools.takewhile"><code class="xref py py-func docutils literal notranslate"><span class="pre">takewhile()</span></code></a></td>
<td>pred, seq</td>
<td>seq[0], seq[1], until pred fails</td>
<td><code class="docutils literal notranslate"><span class="pre">takewhile(lambda</span> <span class="pre">x:</span> <span class="pre">x&lt;5,</span> <span class="pre">[1,4,6,4,1])</span> <span class="pre">--&gt;</span> <span class="pre">1</span> <span class="pre">4</span></code></td>
</tr>
<tr class="row-even"><td><a class="reference internal" href="#itertools.tee" title="itertools.tee"><code class="xref py py-func docutils literal notranslate"><span class="pre">tee()</span></code></a></td>
<td>it, n</td>
<td>it1, it2, … itn  splits one iterator into n</td>
<td>&#160;</td>
</tr>
<tr class="row-odd"><td><a class="reference internal" href="#itertools.zip_longest" title="itertools.zip_longest"><code class="xref py py-func docutils literal notranslate"><span class="pre">zip_longest()</span></code></a></td>
<td>p, q, …</td>
<td>(p[0], q[0]), (p[1], q[1]), …</td>
<td><code class="docutils literal notranslate"><span class="pre">zip_longest('ABCD',</span> <span class="pre">'xy',</span> <span class="pre">fillvalue='-')</span> <span class="pre">--&gt;</span> <span class="pre">Ax</span> <span class="pre">By</span> <span class="pre">C-</span> <span class="pre">D-</span></code></td>
</tr>
</tbody>
</table>

**Combinatoric iterators:**

<table border="1" class="docutils">
<colgroup>
<col width="36%" />
<col width="16%" />
<col width="48%" />
</colgroup>
<thead valign="bottom">
<tr class="row-odd"><th class="head">Iterator</th>
<th class="head">Arguments</th>
<th class="head">Results</th>
</tr>
</thead>
<tbody valign="top">
<tr class="row-even"><td><a class="reference internal" href="#itertools.product" title="itertools.product"><code class="xref py py-func docutils literal notranslate"><span class="pre">product()</span></code></a></td>
<td>p, q, … [repeat=1]</td>
<td>cartesian product, equivalent to a nested for-loop</td>
</tr>
<tr class="row-odd"><td><a class="reference internal" href="#itertools.permutations" title="itertools.permutations"><code class="xref py py-func docutils literal notranslate"><span class="pre">permutations()</span></code></a></td>
<td>p[, r]</td>
<td>r-length tuples, all possible orderings, no repeated elements</td>
</tr>
<tr class="row-even"><td><a class="reference internal" href="#itertools.combinations" title="itertools.combinations"><code class="xref py py-func docutils literal notranslate"><span class="pre">combinations()</span></code></a></td>
<td>p, r</td>
<td>r-length tuples, in sorted order, no repeated elements</td>
</tr>
<tr class="row-odd"><td><a class="reference internal" href="#itertools.combinations_with_replacement" title="itertools.combinations_with_replacement"><code class="xref py py-func docutils literal notranslate"><span class="pre">combinations_with_replacement()</span></code></a></td>
<td>p, r</td>
<td>r-length tuples, in sorted order, with repeated elements</td>
</tr>
<tr class="row-even"><td><code class="docutils literal notranslate"><span class="pre">product('ABCD',</span> <span class="pre">repeat=2)</span></code></td>
<td>&#160;</td>
<td><code class="docutils literal notranslate"><span class="pre">AA</span> <span class="pre">AB</span> <span class="pre">AC</span> <span class="pre">AD</span> <span class="pre">BA</span> <span class="pre">BB</span> <span class="pre">BC</span> <span class="pre">BD</span> <span class="pre">CA</span> <span class="pre">CB</span> <span class="pre">CC</span> <span class="pre">CD</span> <span class="pre">DA</span> <span class="pre">DB</span> <span class="pre">DC</span> <span class="pre">DD</span></code></td>
</tr>
<tr class="row-odd"><td><code class="docutils literal notranslate"><span class="pre">permutations('ABCD',</span> <span class="pre">2)</span></code></td>
<td>&#160;</td>
<td><code class="docutils literal notranslate"><span class="pre">AB</span> <span class="pre">AC</span> <span class="pre">AD</span> <span class="pre">BA</span> <span class="pre">BC</span> <span class="pre">BD</span> <span class="pre">CA</span> <span class="pre">CB</span> <span class="pre">CD</span> <span class="pre">DA</span> <span class="pre">DB</span> <span class="pre">DC</span></code></td>
</tr>
<tr class="row-even"><td><code class="docutils literal notranslate"><span class="pre">combinations('ABCD',</span> <span class="pre">2)</span></code></td>
<td>&#160;</td>
<td><code class="docutils literal notranslate"><span class="pre">AB</span> <span class="pre">AC</span> <span class="pre">AD</span> <span class="pre">BC</span> <span class="pre">BD</span> <span class="pre">CD</span></code></td>
</tr>
<tr class="row-odd"><td><code class="docutils literal notranslate"><span class="pre">combinations_with_replacement('ABCD',</span> <span class="pre">2)</span></code></td>
<td>&#160;</td>
<td><code class="docutils literal notranslate"><span class="pre">AA</span> <span class="pre">AB</span> <span class="pre">AC</span> <span class="pre">AD</span> <span class="pre">BB</span> <span class="pre">BC</span> <span class="pre">BD</span> <span class="pre">CC</span> <span class="pre">CD</span> <span class="pre">DD</span></code></td>
</tr>
</tbody>
</table>

#### short note - parallelism with multiprocessing

The main way to implement true parallelism in python right now is to use the **multiprocessing** module.

This module implements many ways of working with parallel processes.

The one we are interested about is `Pool.map`, that implementes a parallel version of the **map** function.


```python
import multiprocessing as mp

data = range(5)
def squares(x):
    return x**2

with mp.Pool(processes=4) as pool:
    result = pool.map(squares, data)
result
```




    [0, 1, 4, 9, 16]



An example on how to distribute a list of string and tranform them in lowercase in a parallel fashion


```python
_missing = object()
def grouper(iterable, n, fillvalue=_missing):
    "Collect data into fixed-length chunks or blocks"
    # grouper('ABCDEFG', 3, 'x') --> ABC DEF Gxx"
    args = [iter(iterable)] * n
    sets = zip_longest(*args, fillvalue=_missing)
    return  ([i for i in s if i is not _missing] for s in sets)

list(grouper('ABCDEFG', 3))
```




    [['A', 'B', 'C'], ['D', 'E', 'F'], ['G']]




```python
import itertools as it
sequence = iter('ABCDEFG')
def mapl(f, *seqs):
    return list(map(f, *seqs))

lower = partial(mapl, str.lower)
groups = grouper(sequence, 3)
with mp.Pool(processes=4) as pool:
    result = pool.map(lower, groups)
    result = list(it.chain.from_iterable(result))
result
```




    ['a', 'b', 'c', 'd', 'e', 'f', 'g']



## Problem - counting file types

scan all the files in a directory in your computer, including the subdirectories, and count the number of files of each extension type.

The extension to be considered is the one after the last dot, lowercase.

The count should be divided by subdirectory and the overall total.

If possible, implement it in parallel.

suggestion: check the `os.walk function` to explore the filesystem from a starting point.


```python
import os
import itertools as it
from collections import Counter

def get_extension(fname):
    return fname.split('.')[-1]

def is_image(ext):
    return ext in images_extension

images_extension = ['png', 'jpg', 'svg']

flatten_lists = it.chain.from_iterable
make_lowercase = partial(map, str.lower)
extract_extensions = partial(map, get_extension)
select_images = partial(filter, is_image)

files_seq = (files for _, _, files in os.walk('.'))
files = flatten_lists(files_seq)
files = make_lowercase(files)
extension = extract_extensions(files)
images = select_images(extension)
Counter(images)
```




    Counter({'png': 45, 'svg': 7})




```python
from pathlib import Path

def _is_hidden_path(path):
    return path.absolute().stem.startswith('.')

def my_walk(position, *, remove_hidden=True):
    """generator reimplementing the os.walk function using the `yield from` syntax"""
    # convert the parameter to make sure it's a path object
    position = Path(position)
    # gets all the files and directories in the current path
    paths = list(position.iterdir())
    # select the files and folders
    sub_files = [path for path in paths if not path.is_dir()]
    sub_dirs = [path for path in paths if path.is_dir()]
    if remove_hidden:
        sub_files = [path for path in sub_files if not _is_hidden_path(path)]
        sub_dirs = [path for path in sub_dirs if not _is_hidden_path(path)]
    # returns the current position, subdirectories and files
    yield position, sub_dirs, sub_files
    # returns all the content of all the subdirectories
    for sub_dir in sub_dirs:
        yield from my_walk(sub_dir)
```


```python
for pos, dirs, files in my_walk('immagini'):
    print(pos)
    print([d.name for d in dirs])
    print([f.name for f in files])
    print()
```

    immagini
    ['property']
    ['interfaccia_fossil_3.png', 'power_triangle.png', 'interfaccia_fossil_2.png', 'snakemake_dag.svg', 'interfaccia_fossil_7.png', 'tradeoff_spazio_velocita.svg', 'interfaccia_fossil_8.png', 'interfaccia_fossil_10.png', 'time.png', 'net.png', 'time2.png', 'interfaccia_fossil_4.png', 'FastPCA.png', 'tradeoff_spazio_velocita.png', 'interfaccia_fossil_9.png', 'interfaccia_fossil_5.png', 'vec.png', 'realtime.png', 'interfaccia_fossil_6.png', 'mapreduce.png', 'interfaccia_fossil_1.png', 'snakemake_dag.png', '5v.png', 'google.png']
    
    immagini/property
    []
    ['property_commutative.png', 'property_induction.png', 'property_invariant.png', 'property_test_oracle.png', 'property_inverse.png', 'property_easy_verification.png', 'property_idempotence.png']
    


## Dynamical code Generation and execution


```python
a = 4
b = 7
eval('a+b')
```




    11




```python
a = {'a':1, 'b':2}
result = eval("a + b", globals(), a)
print(a, result)
```

    {'a': 1, 'b': 2} 3



```python
a = {'a':1, 'b':2}
exec("c = a+b", globals(), a)
a
```




    {'a': 1, 'b': 2, 'c': 3}




```python
expr = compile("a+b", filename='__main__', mode='eval')
expr
```




    <code object <module> at 0x7f8ac41a2e40, file "__main__", line 1>




```python
a = {'a':1, 'b':2}
eval(expr, globals(), a)
```




    3




```python
a
```




    {'a': 1, 'b': 2}



## AST

https://greentreesnakes.readthedocs.io/en/latest/



```python
import ast
commands = """
a = 2+3
b = 4
print(a+b)
"""
tree = ast.parse(commands)
print(tree)
```

    <_ast.Module object at 0x7f0988910390>



```python
# expect the value 9
compiled_expr = compile(tree, filename="<ast>", mode="exec")
exec(compiled_expr)
```

    9



```python
def walker(branch, offset=0, indent='\t'):
    for child in ast.iter_child_nodes(branch):
        print(indent*offset, child)
        walker(child, offset=offset+1, indent=indent)
```


```python
walker(tree, indent='  ')
```

     <_ast.Assign object at 0x7f0988910400>
       <_ast.Name object at 0x7f0988910470>
         <_ast.Store object at 0x7f098f1c4dd8>
       <_ast.BinOp object at 0x7f09889103c8>
         <_ast.Num object at 0x7f0988910550>
         <_ast.Add object at 0x7f098f1c7be0>
         <_ast.Num object at 0x7f09889104a8>
     <_ast.Assign object at 0x7f09889101d0>
       <_ast.Name object at 0x7f0988910780>
         <_ast.Store object at 0x7f098f1c4dd8>
       <_ast.Num object at 0x7f0988910438>
     <_ast.Expr object at 0x7f09889104e0>
       <_ast.Call object at 0x7f0988910b00>
         <_ast.Name object at 0x7f0988910630>
           <_ast.Load object at 0x7f098f1c4cc0>
         <_ast.BinOp object at 0x7f09889105f8>
           <_ast.Name object at 0x7f0988910940>
             <_ast.Load object at 0x7f098f1c4cc0>
           <_ast.Add object at 0x7f098f1c7be0>
           <_ast.Name object at 0x7f09889108d0>
             <_ast.Load object at 0x7f098f1c4cc0>

