```python
%matplotlib inline
```


```python
!ls divine_comedy
```

    divinacommedia_cleaned.txt  divina_commedia_with_copyright_notice.txt



```python
text_file = "./divine_comedy/divinacommedia_cleaned.txt"
```

# Familiarize with the data


```python
# can I read the data
with open(text_file, 'r', encoding='utf8') as infile:
    for line in infile:
        pass
```

how many couples do I need?

I have 30 characters possible (26 letters + space, newline, full stop, exclamation point)


```python
# first order chain
30**2
```




    900




```python
# second order chain
30**3
```




    27000




```python
# third order chain
30**4
```




    810000



how many letters do we have in our corpus?


```python
letters = 0
with open(text_file, 'r', encoding='utf8') as infile:
    for line in infile:
        for letter in line:
            letters += 1
print(letters)
```

    529771



```python
# how many and which letters do I have in my text?
from collections import Counter
observed = Counter()

with open(text_file, 'r', encoding='utf8') as infile:
    for line in infile:
        for letter in line:
            observed[letter] += 1
```


```python
observed
```




    Counter({'\ufeff': 1,
             'N': 258,
             'e': 46094,
             'l': 23087,
             ' ': 83019,
             'm': 11681,
             'z': 1848,
             'o': 37254,
             'd': 14599,
             'c': 20267,
             'a': 42035,
             'i': 39200,
             'n': 26229,
             's': 22188,
             't': 22478,
             'r': 25805,
             'v': 7946,
             '\n': 19053,
             'p': 10790,
             'u': 13408,
             ',': 8513,
             'h': 7109,
             'é': 903,
             '.': 3275,
             'A': 377,
             'q': 3025,
             'è': 925,
             'g': 7121,
             'f': 4947,
             '!': 232,
             'T': 283,
             '’': 7623,
             'ù': 1080,
             ';': 1628,
             'b': 2758,
             'ò': 938,
             'I': 359,
             'M': 405,
             'à': 855,
             'E': 586,
             'ì': 1383,
             'P': 473,
             'Q': 328,
             '«': 1062,
             '»': 1062,
             'R': 117,
             ':': 988,
             'ï': 427,
             'ó': 30,
             '?': 278,
             'O': 356,
             'V': 222,
             'D': 407,
             'C': 554,
             'L': 411,
             'S': 443,
             'ë': 83,
             '“': 51,
             'B': 223,
             '”': 51,
             '—': 18,
             '‘': 109,
             'G': 199,
             'F': 180,
             'Z': 7,
             'ü': 55,
             'U': 43,
             'H': 2,
             'ö': 1,
             'ä': 8,
             'x': 3,
             'y': 1,
             '(': 3,
             ')': 3,
             'È': 2,
             'j': 2,
             'Ë': 2,
             'Ï': 1,
             '-': 1})




```python
# how many and which letters do I have in my text?
# try with a different encoding
from collections import Counter
observed = Counter()

with open(text_file, 'r', encoding='utf-8-sig') as infile:
    for line in infile:
        for letter in line:
            observed[letter] += 1
```


```python
observed
```




    Counter({'N': 258,
             'e': 46094,
             'l': 23087,
             ' ': 83019,
             'm': 11681,
             'z': 1848,
             'o': 37254,
             'd': 14599,
             'c': 20267,
             'a': 42035,
             'i': 39200,
             'n': 26229,
             's': 22188,
             't': 22478,
             'r': 25805,
             'v': 7946,
             '\n': 19053,
             'p': 10790,
             'u': 13408,
             ',': 8513,
             'h': 7109,
             'é': 903,
             '.': 3275,
             'A': 377,
             'q': 3025,
             'è': 925,
             'g': 7121,
             'f': 4947,
             '!': 232,
             'T': 283,
             '’': 7623,
             'ù': 1080,
             ';': 1628,
             'b': 2758,
             'ò': 938,
             'I': 359,
             'M': 405,
             'à': 855,
             'E': 586,
             'ì': 1383,
             'P': 473,
             'Q': 328,
             '«': 1062,
             '»': 1062,
             'R': 117,
             ':': 988,
             'ï': 427,
             'ó': 30,
             '?': 278,
             'O': 356,
             'V': 222,
             'D': 407,
             'C': 554,
             'L': 411,
             'S': 443,
             'ë': 83,
             '“': 51,
             'B': 223,
             '”': 51,
             '—': 18,
             '‘': 109,
             'G': 199,
             'F': 180,
             'Z': 7,
             'ü': 55,
             'U': 43,
             'H': 2,
             'ö': 1,
             'ä': 8,
             'x': 3,
             'y': 1,
             '(': 3,
             ')': 3,
             'È': 2,
             'j': 2,
             'Ë': 2,
             'Ï': 1,
             '-': 1})




```python
# we decide to normalize the uncommon letters
to_replace = {'Ë': 'E', 'Ï': 'I', 
              'ö': 'o', 'ä': 'a', 
              'ü': 'u', 'ë': 'e', 
              'ï': 'i'}
def letter_normalization_naive(letter):
    if letter in to_replace:
        return to_replace[letter] 
    return letter

def letter_normalization_short(letter):
    return to_replace.get(letter, letter)
```


```python
letter_normalization_naive('Ë')
```




    'E'




```python
letter_normalization_short('Ë')
```




    'E'




```python
%timeit letter_normalization_naive('Ë')
```

    116 ns ± 2.36 ns per loop (mean ± std. dev. of 7 runs, 10000000 loops each)



```python
%timeit letter_normalization_short('Ë')
```

    158 ns ± 2.01 ns per loop (mean ± std. dev. of 7 runs, 10000000 loops each)



```python
letter_normalization = letter_normalization_naive
```


```python
from collections import Counter
observed = Counter()

with open(text_file, 'r', encoding='utf-8-sig') as infile:
    for line in infile:
        for letter in line:
            modified_letter = letter_normalization(letter)
            observed[modified_letter] += 1
```


```python
observed
```




    Counter({'N': 258,
             'e': 46177,
             'l': 23087,
             ' ': 83019,
             'm': 11681,
             'z': 1848,
             'o': 37255,
             'd': 14599,
             'c': 20267,
             'a': 42043,
             'i': 39627,
             'n': 26229,
             's': 22188,
             't': 22478,
             'r': 25805,
             'v': 7946,
             '\n': 19053,
             'p': 10790,
             'u': 13463,
             ',': 8513,
             'h': 7109,
             'é': 903,
             '.': 3275,
             'A': 377,
             'q': 3025,
             'è': 925,
             'g': 7121,
             'f': 4947,
             '!': 232,
             'T': 283,
             '’': 7623,
             'ù': 1080,
             ';': 1628,
             'b': 2758,
             'ò': 938,
             'I': 360,
             'M': 405,
             'à': 855,
             'E': 588,
             'ì': 1383,
             'P': 473,
             'Q': 328,
             '«': 1062,
             '»': 1062,
             'R': 117,
             ':': 988,
             'ó': 30,
             '?': 278,
             'O': 356,
             'V': 222,
             'D': 407,
             'C': 554,
             'L': 411,
             'S': 443,
             '“': 51,
             'B': 223,
             '”': 51,
             '—': 18,
             '‘': 109,
             'G': 199,
             'F': 180,
             'Z': 7,
             'U': 43,
             'H': 2,
             'x': 3,
             'y': 1,
             '(': 3,
             ')': 3,
             'È': 2,
             'j': 2,
             '-': 1})




```python
from random import choices
```


```python
letters = list(observed.keys())
occurrences = list(observed.values())
generated = choices(letters, occurrences, k=20)
collated = "".join(generated)
print(collated)
```

    a ,v
    suì trdt r i ac


# first order markov chains

we need to take our letters in couples

if we have a text such "home"
we want to obtain the couples:

(h, o)
(o, m)
(m, e)


```python
list_1 = ['a', 'b', 'c']
list_2 = [1, 2, 3]
list(zip(list_1, list_2))
```




    [('a', 1), ('b', 2), ('c', 3)]




```python
text = "home"
list(zip(text, text[1:]))
```




    [('h', 'o'), ('o', 'm'), ('m', 'e')]




```python
def couples_from_seq(seq):
    """`seq` is a list of characters"""
    return zip(seq, seq[1:])

list(couples_from_seq('home'))
```




    [('h', 'o'), ('o', 'm'), ('m', 'e')]




```python
with open(text_file, 'r', encoding='utf-8-sig') as infile:
    whole_text = "".join(line for line in infile)
```


```python
print(whole_text[:120])
```

    Nel mezzo del cammin di nostra vita
    mi ritrovai per una selva oscura,
    ché la diritta via era smarrita.
    
    Ahi quanto a dir



```python
all_couples = list(couples_from_seq(whole_text))
```


```python
all_couples[:10]
```




    [('N', 'e'),
     ('e', 'l'),
     ('l', ' '),
     (' ', 'm'),
     ('m', 'e'),
     ('e', 'z'),
     ('z', 'z'),
     ('z', 'o'),
     ('o', ' '),
     (' ', 'd')]




```python
from collections import defaultdict
foo = defaultdict(Counter)
foo['b']['a'] += 1
foo
```




    defaultdict(collections.Counter, {'b': Counter({'a': 1})})




```python
foo['b']
```




    Counter({'a': 1})




```python
# defaultdict allow me to avoid this check:
if 'c' not in foo:
    foo['c'] = Counter()
# and just leave this command
foo['c'] ['a'] += 1
```


```python
from collections import defaultdict
# Counter ~= defaultdict(int)
couples_counter = defaultdict(Counter)
for first_letter, second_letter in all_couples:
    counter_of_first_letter = couples_counter[first_letter]
    counter_of_first_letter[second_letter] += 1
```


```python
# too big for visualization?
# couples_counter
```


```python
sum(sum(counts.values()) for counts in couples_counter.values())
```




    529769




```python
letter = 'N'
letter_counts = couples_counter[letter]
possible_letters = list(letter_counts.keys())
counts = list(letter_counts.values())
next_letter = choices(possible_letters, counts)[0]
next_letter
```




    'o'




```python
text = ['N']
for i in range(200):
    last_letter = text[-1]
    letter_counts = couples_counter[last_letter]
    possible_letters = list(letter_counts.keys())
    counts = list(letter_counts.values())
    next_letter = choices(possible_letters, counts)[0]  
    text.append(next_letter)
print("".join(text))
```

    No ial’i: co veterondonn sesa is’a pa norarni
    nce draiere piolì che qu fomoronte: ppe ’ fuià dè e pi,
    atiagi vi s’lli ’ cit’ ch’ fe coruto figua sso pienco v’a be ge
    Ver eropuan de,
    
    Qu qumer ce so,
    so


# exercise

write a code that generates few hundred letters using arbitrary long markov chains, such as triples and quadruplets, and discuss the resulting text

# solution to the exercise

    text = "hello world"
    
    [('h', 'e', 'l'), ('e', 'l', 'l'), ...]


```python
def groups_from_seq(seq, order=2):
    """`seq` is a list of characters
    
    horrible version number 1
    """
    if order==2:
        return zip(seq[0:], seq[1:])
    elif order==3:
        return zip(seq[0:], seq[1:], seq[2:])
    elif order==4:
        return zip(seq[0:], seq[1:], seq[2:], seq[3:])
    else:
        raise ValueError("only order 2 or 3 accepted")

list(groups_from_seq('home sweet home', 3))
```




    [('h', 'o', 'm'),
     ('o', 'm', 'e'),
     ('m', 'e', ' '),
     ('e', ' ', 's'),
     (' ', 's', 'w'),
     ('s', 'w', 'e'),
     ('w', 'e', 'e'),
     ('e', 'e', 't'),
     ('e', 't', ' '),
     ('t', ' ', 'h'),
     (' ', 'h', 'o'),
     ('h', 'o', 'm'),
     ('o', 'm', 'e')]




```python
def groups_from_seq(seq, order=2):
    """`seq` is a list of characters
    
    appropriate for short sequences
    """
    truncated_lists = [seq[i:] for i in range(order)]
    return zip(*truncated_lists)

list(groups_from_seq('home sw', 3))
```




    [('h', 'o', 'm'),
     ('o', 'm', 'e'),
     ('m', 'e', ' '),
     ('e', ' ', 's'),
     (' ', 's', 'w')]




```python

```


```python
*previous_letters, last_letter = "home"
print(previous_letters, last_letter)
```

    ['h', 'o', 'm'] e



```python
*previous_letters, last_letter = "h"
print(previous_letters, last_letter)
```

    [] h



```python
from collections import defaultdict, Counter
# Counter ~= defaultdict(int)
all_groups = list(groups_from_seq('home sweet home', 2))

groups_counter = defaultdict(Counter)
for *previous_letters, last_letter in all_groups:
    previous_letters = tuple(previous_letters)
    counter_of_previous_letters = groups_counter[previous_letters]
    counter_of_previous_letters[last_letter] += 1
    
groups_counter
```




    defaultdict(collections.Counter,
                {('h',): Counter({'o': 2}),
                 ('o',): Counter({'m': 2}),
                 ('m',): Counter({'e': 2}),
                 ('e',): Counter({' ': 1, 'e': 1, 't': 1}),
                 (' ',): Counter({'s': 1, 'h': 1}),
                 ('s',): Counter({'w': 1}),
                 ('w',): Counter({'e': 1}),
                 ('t',): Counter({' ': 1})})




```python
text = ['N', 'e', 'l', ' ', 'm', 'e']
print(text[-1])
print(text[-1:])
print(text[-2:])
```

    e
    ['e']
    ['m', 'e']



```python
from random import choices

text = ['h', 'o']
order = 2
for i in range(50):
    last_letters = tuple(text[-order+1:])
    
    letter_counts = groups_counter[last_letters]
    possible_letters = list(letter_counts.keys())
    counts = list(letter_counts.values())
    next_letter = choices(possible_letters, counts)[0]  
    text.append(next_letter)
print("".join(text))
```

    homee homet home home home swe swee swet homet homee


let's transform these pieces of code in functions


```python
def counts_from_groups(group_seq):
    groups_counter = defaultdict(Counter)
    for *previous_letters, last_letter in group_seq:
        previous_letters = tuple(previous_letters)
        count_of_previous_letters = groups_counter[previous_letters]
        count_of_previous_letters[last_letter] += 1
    return groups_counter
    
```


```python
def generate_text(groups_counter, text_seed, order=2, lenght=200):
    text = list(text_seed)
    for i in range(lenght):
        last_letters = tuple(text[-order+1:])

        letter_counts = groups_counter[last_letters]
        possible_letters = list(letter_counts.keys())
        counts = list(letter_counts.values())
        next_letter = choices(possible_letters, counts)[0]  
        text.append(next_letter)
    return "".join(text)
```


```python
source_text = "home sweet home"
order = 3
all_groups = groups_from_seq(source_text, order)
groups_counter = counts_from_groups(all_groups)
output_text = generate_text(groups_counter, "home", order=order)

print(output_text)
```

    home sweet home sweet home sweet home sweet home sweet



```python
with open(text_file, 'r', encoding='utf-8-sig') as infile:
    source_text = "".join(line for line in infile)
order = 5
all_groups = groups_from_seq(source_text, order)
groups_counter = counts_from_groups(all_groups)
seed_text = "Nel mezzo"
output_text = generate_text(groups_counter, seed_text, 
                            order=order, lenght=200)

print(output_text)
```

    Nel mezzo ’l qual era forse
    che fossa
    farai che passi aspetto in là ’ve s’interno Augusto
    perché seguire a vendue oscura cornuta ne fretta».
    
    «Né creatura
    ch’uscì de la dier suo ne rito a cotesta:
    
    esce disio 


```python
whole_text = load_source()
generator = TextGenerator(order=3, split='letters')
generator.learn(whole_text)
generator.generate(seed='Nel', lenght=400)
```


```python
class TextGenerator:
    def __init__(self, order):
        self.order = order
        self.data = defaultdict(Counter)
        
    def learn(self, text):
        all_groups = groups_from_seq(text, self.order)
        self.data = counts_from_groups(all_groups)
        
    def generate(self, seed, lenght):
        output_text = generate_text(self.data, 
                                    seed, 
                                    order=self.order,
                                    lenght=lenght)
        return output_text
```


```python
generator = TextGenerator(order=3)
generator.learn(source_text)
output_text = generator.generate(seed='Nel', lenght=400)
print(output_text)
```

    Nelo inò morselliuntor ch’enimanta nonve quellor figliento,
    e ri nongualtrissa,
    sì chietta, cesti cogli etè lo solucello so, con pre se vid’ultra.
    
    Ellassanna,
    però ci pornai:
    
    Ma vedispedi a in or fu visello e vel salzio
    lumi
    co’ el pre tarra fa, offal be ’ngor dissaliand’ iradavolsemperà; s’erte lorgo, e s’ioterso
    giun non sandi ’l ser dimalte.
    
    luma
    la ché s’afincommio
    tar se fu che distrà diesti 



```python
class NotLearnedError(Exception):
    pass

class TextGenerator:
    def __init__(self, order):
        self.order = order
        self.data = defaultdict(Counter)
        # have I ever alled the learn function
        self._learned = False
        
    def learn(self, text):
        all_groups = groups_from_seq(text, self.order)
        self.data = counts_from_groups(all_groups)
        # we have learned something
        self._learned = True
        # fluent interface
        return self
        
    def generate(self, seed, lenght):
        """
        raises:
        -------
            `NotLearnedError` if the `self.learn` function 
            has not been called before
        """
        # check that we performed the learn function
        if not self._learned:
            raise NotLearnedError()
        output_text = generate_text(self.data, 
                                    seed, 
                                    order=self.order,
                                    lenght=lenght)
        return output_text
```


```python
output_text = (TextGenerator(order=3)
               .learn(source_text)
               .generate(seed='Nel', lenght=400))
print(output_text)
```

    Nel foste più dessen diserga pice,
    e qualsi pinfacciai e anivivintente si cannece ’nciei».
    
    Ma di a v’ amon que mi lia l’affio mia verratto ve for, sce lacella gricesir sù alle
    dicernonnellanda ti Balietro piedo cal me la lonoi ma re piati a sa che que: «Tutto.
    
    E queste
    che pre.
    
    Lo ch’aspo ve imone sa, po e pare
    ne,
    ch’ il fatericun lucestra.
    
    I’ enti,
    da.
    
    «Vatrovia però vinsibra di?».
    
    Qui obbito



```python
output_text = (TextGenerator(order=3)
               .generate(seed='Nel', lenght=400))
print(output_text)
```


    ---------------------------------------------------------------------------

    NotLearnedError                           Traceback (most recent call last)

    <ipython-input-55-6d3227991905> in <module>
          1 output_text = (TextGenerator(order=3)
    ----> 2                .generate(seed='Nel', lenght=400))
          3 print(output_text)


    <ipython-input-53-314a6658a7c3> in generate(self, seed, lenght)
         20         # check that we performed the learn function
         21         if not self._learned:
    ---> 22             raise NotLearnedError()
         23         output_text = generate_text(self.data, 
         24                                     seed,


    NotLearnedError: 


```python
text_1 = load_divina_commedia()
text_2 = load_decameron()

generator = TextGenerator(order=3)
generator.learn(text_1)
generator.learn(text_2)
output_text = generator.generate(seed='Nel', lenght=400)
print(output_text)
```


```python
class NotLearnedError(Exception):
    pass

class TextGenerator:
    def __init__(self, order):
        self.order = order
        self.data = defaultdict(Counter)
        # have I ever alled the learn function
        self._learned = False
        
    def _counts_from_groups(self, group_seq):
        for *previous_letters, last_letter in group_seq:
            previous_letters = tuple(previous_letters)
            count_previous = self.data[previous_letters]
            count_previous[last_letter] += 1
        
    def learn(self, text):
        all_groups = groups_from_seq(text, self.order)
        self._counts_from_groups(all_groups)
        # we have learned something
        self._learned = True
        # fluent interface
        return self
        
    def generate(self, seed, lenght):
        """
        raises:
        -------
            `NotLearnedError` if the `self.learn` function 
            has not been called before
        """
        # check that we performed the learn function
        if not self._learned:
            raise NotLearnedError()
        output_text = generate_text(self.data, 
                                    seed, 
                                    order=self.order,
                                    lenght=lenght)
        return output_text
```


```python
source = "home"
list(groups_from_seq(source, 2))
```




    [('h', 'o'), ('o', 'm'), ('m', 'e')]




```python
source = ["home", "sweet", "home", "nice", "home"]
list(groups_from_seq(source, 2))
```




    [('home', 'sweet'), ('sweet', 'home'), ('home', 'nice'), ('nice', 'home')]




```python
class NotLearnedError(Exception):
    pass

class TextGenerator:
    def __init__(self, order, split='letter'):
        self.order = order
        self.data = defaultdict(Counter)
        self.split = split
        # have I ever alled the learn function
        self._learned = False
        
    def _counts_from_groups(self, group_seq):
        for *previous_letters, last_letter in group_seq:
            previous_letters = tuple(previous_letters)
            count_previous = self.data[previous_letters]
            count_previous[last_letter] += 1
        
    def _generate_text_tokens(self, text):
        if self.split == 'letter':
            return list(text)
        elif self.split == 'word': # TODO: how to manage commas
            return text.split(' ')
        else:
            raise ValueError("splitting method not known")
        
    def learn(self, text):
        tokens = self._generate_text_tokens(text)
        all_groups = groups_from_seq(tokens, self.order)
        self._counts_from_groups(all_groups)
        # we have learned something
        self._learned = True
        # fluent interface
        return self
        
    def _generate_text(self, text_seed, lenght=200):
        groups_counter = self.data
        order = self.order
        text = list(text_seed)
        for i in range(lenght):
            last_letters = tuple(text[-order+1:])
            letter_counts = groups_counter[last_letters]
            possible_letters = list(letter_counts.keys())
            counts = list(letter_counts.values())
            next_letter = choices(possible_letters, counts)[0]  
            text.append(next_letter)
        return text
    
    def _collate_text(self, text_seq):
        if self.split == 'letter':
            return "".join(text_seq)
        elif self.split == 'word': # TODO: how to manage commas
            return " ".join(text_seq)
        else:
            raise ValueError("splitting method not known")
        
        
    def generate(self, seed, lenght):
        """
        raises:
        -------
            `NotLearnedError` if the `self.learn` function 
            has not been called before
        """
        # check that we performed the learn function
        if not self._learned:
            raise NotLearnedError()
        output_seq = self._generate_text(seed, lenght=lenght)
        output_text = self._collate_text(output_seq)
        return output_text
```


```python
output_text = (TextGenerator(order=2, split='word')
               .learn(source_text)
               .generate(seed='Nel', lenght=50))
print(output_text)
```

    N e l ’altro polo,
    là onde ogne cor mi si paia
    che tu se’ in pianta silvestra:
    l’Arpie, pascendo poi che vuo’ veder, li occhi suoi nemici
    non ne rimarita,
    
    come se’ tu riguardi là giù ponesse mente
    al fondamento che la vista al piè de le guance lagrimose;
    ivi mi fec’ io contemplo,
    adora per tua pur su l’erbetta



```python

```
