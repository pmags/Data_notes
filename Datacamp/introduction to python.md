---
PageTitle: Introduction to python
---

# Python Basics
In order to generate output from a python command we have to explicitly use the command print.

Python is perfectly suited to do basic calculations. Apart from addition, subtraction, multiplication and division, there is also support for more advanced operations such as:

    Exponentiation: `**`. This operator raises the number to its left to the power of the number to its right. For example `4**2` will give 16.
    Modulo: `%`. This operator returns the remainder of the division of the number to the left by the number on its right. For example `18 % 7` equals 4.
> Notice that in R the power is written as `^`

```py
# How much is your $100 worth after 7 years?
print(100 * 1.1**7) 
```
In order to declare a variable we use `=` as in R we use `<-` although we can use `=` too, but is not a best practice.
= in Python means assignment, it doesn't test equality!

The `type()` function tells us the type of a variable. `float` is py class to represent a real number (equal to double). As `int` represents and integer (equals 1l in R). Other types are strings `str` (equivalente to `character`) or bolean (bool), that means TRUE/FALSE (equivalente to `logical`).

In py with you sum to strings together it will return a pasted number. Python does not return and error like in Python/C.

```py
"ab" + "cd"
"abcd"
```
The following code is an example for using variables in Py. Notice that, as oposition to R, we explicitly have to call the print function when we call a variable.

```py
# Create a variable savings
savings = 100

# Create a variable growth_multiplier
growth_multiplier = 1.1

# Calculate result
result = savings * growth_multiplier ** 7

# Print out result
print(result)
```

Using the + operator to paste together two strings can be very useful in building custom messages.

Suppose, for example, that you've calculated the return of your investment and want to summarize the results in a string. Assuming the floats savings and result are defined, you can try something like this:

```py
print("I started with $" + savings + " and now have $" + result + ". Awesome!")

```
This will not work, though, as you cannot simply sum strings and floats.

To fix the error, you'll need to explicitly convert the types of your variables. More specifically, you'll need str(), to convert a value into a string. str(savings), for example, will convert the float savings to a string.

Similar functions such as int(), float() and bool() will help you convert Python values into any type.

# Python lists
As opposed to int, bool etc., a list is a compound data type; you can group values together.

A list can contain any Python type. Although it's not really common, a list can also contain a mix of Python types including strings, floats, booleans, etc.

Subsetting Python lists is a piece of cake. Take the code sample below, which creates a list x and then selects "b" from it. Remember that this is the second element, so it has index 1. You can also use negative indexing.

```py
x = ["a", "b", "c", "d"]
x[1]
x[-3] # same result!
```

electing single values from a list is just one part of the story. It's also possible to slice your list, which means selecting multiple elements from your list. Use the following syntax:

```
my_list[start:end]

```
The start index will be included, while the end index is not.

You saw before that a Python list can contain practically anything; even other lists! To subset lists of lists, you can use the same technique as before: square brackets. 

```py
x = [["a", "b", "c"],
     ["d", "e", "f"],
     ["g", "h", "i"]]
x[2][0]
x[2][:2]
```
If you can change elements in a list, you sure want to be able to add elements to it, right? You can use the + operator:

```py
x = ["a", "b", "c", "d"]
y = x + ["e", "f"]
```
Finally, you can also remove elements from your list. You can do this with the del statement:

```py
x = ["a", "b", "c", "d"]
del(x[1])
```
**Please notice that after we remove an element from a list them the lists index will change.**

The ; sign is used to place commands on the same line. The following two code chunks are equivalent:

```py
# Same line
command1; command2

# Separate lines
command1
command2
```
# Functions and Packages

A function is a peace of reproducible code.

The general recipe for calling functions and saving the result to a variable is thus:

```py
output = function_name(input)
```
Methods are functions that belong to objects.

Strings are not the only Python types that have methods associated with them. Lists, floats, integers and booleans are also types that come packaged with a bunch of useful methods. In this exercise, you'll be experimenting with:

- index(), to get the index of the first element of a list that matches its input and

- count(), to get the number of times an element appears in a list.

Most list methods will change the list they're called on. Examples are:

- append(), that adds an element to the list it is called on,
- remove(), that removes the first element of a list that matches the input, and
- reverse(), that reverses the order of the elements in the list it is called on.

In order to use python packages we first have to install them. One of the options is to use pip. In order do do that we have to:

```py
Download get-pip.py
# Terminal
python3 get-pip.py

# to install a package
pip3 install numpy

# We can either import th entire package or just a specific module

import numpy as np
from numpy import array
```
General imports, like import math, make all functionality from the math package available to you. However, if you decide to only use a specific part of a package, you can always make your import more selective:

from math import pi


