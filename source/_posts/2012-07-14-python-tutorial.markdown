---
layout: post
title: "Python Tutorial"
date: 2012-07-14 02:21:51 +0800
comments: true
categories: Python, memo
---

## Python Interactive Shell

`_` 变量代表最后一次 return 的值。

## Source Code Encoding

Python 2.x 默认识别源码为 ASCII，对于需要使用如中文等，可以在源码中指定编码类型，如：

```
# -*- coding: utf-8 -*-
```

此方法不使用与 2.2 及更旧版本，3.x 后默认为 utf-8 编码，无需如此。

注意：

- 如果第一行是如 `/usr/bin/env python` 这样的指定，那么指定的编码类型必须位于第二行，中间不能有空行。
- 如果第一行不是程序指定，那么编码类型注释前面可以有空行。
- 加了编码类型注释后，注释中可以直接使用中文了，但在代码中，需要用 u`'中文'`，而不能直接想 JS 中那样使用字符串。

## Number

0 == 0.0

/ （除法）

2.x 中对两个整数应用 / ，得到的是 math.floor，但其中一个 float，则得到 float。如：5 / 2 = 2； 5 / 2.0 = 2.5；

3.x 中默认是普通的除法，不取 floor。

## 复数（complex）

用 1j 或 2J 等形式来表示虚数，也可以用 complex 类来构建复数。如：`(1+2j) + complex(2, 1)`。得到的复数 i，可以用 `i.real` 和 `i.imag` 来分别获取实数部分和虚数部分。

<!-- more -->

## unicode

### unicode to str

对于用 `u’string’` 声明的 unicode 变量，如果都是 ASCII 码，那么可以用 `str` 来转换为普通的字符串，但如果有非 ASCII 的，那么则无法。

这使用需要使用 `aunicodeObj.encode('utf-8')` 等形式来转换为对应编码的字符串。

## multiple assignment

可以用 `a, b = 0, 1` 这种形式来同时多个赋值，利用这个特性，可以做到交换值的功能：`a, b = b, a`。

## Control Flow

### if else

```Python
if condition:
    doSomething
elif otherCondition:
    doSomething Else
else:
    others
```

### for

```Python
for i in iterable:
    print i
```

### while

```Python
while conditon:
    doSomething
```

### range([start, ] end [, step])

```Python
range(5)            # => [0, 1, 2, 3, 4]
range(1, 5)         # => [1, 2, 3, 4]
range(1, 5, 2)      # => [1, 3]
range(-10, -20, -3) # => [-10, -13, -16, -19]

for i in range(len(aList)):
    print i, aList[i]
```

### function

函数参数的默认值仅生效一次（why？），在其为可变对象（如 list，dictionary 等）时，可能会带来困扰。如：

```python
def f(a, L=[]):
    L.append(a)
    return L

print f(1)      # => [1]
print f(2)      # => [1, 2]
print f(3)      # => [1, 2, 3]
```

调用函数时，一旦某个参数使用了命名参数形式，则其后面的参数都必须使用命名参数形式。

### *args 和 **keywords

定义函数时，args 表示用一个 args 元组来代表后面任意多个基于位置的参数，**keywords 则用一个 dict 来记录后面的基于命名的参数，且必须在 args 后面。

```python
def t(a, b, *c, **d):
    print 'a: ', a
    print 'b: ', b
    for i in c:
        print '-', i
    keys = sorted(d.keys())
    for k in keys:
        print k, ':', d[k]

t(1, 2, 3, 4, d=5, e=6, f=7)    # =>
                                    a: 1
                                    b: 2
                                    - 3
                                    - 4
                                    d : 5
                                    e : 6
                                    f : 7
```

调用函数时，使用 *args 和 **keywords 可以展开一个 tuple/list 和 dict 来传参。

```python
args = [3, 6]
range(*args)    # => [3, 4, 5]
```

## Doc Strings

```python
def t():
    """Short summary.

    Other description.
    """
    pass
```

## Data Structures

### list

methods: `list.append(x), list.count(x), list.extend(L), list.index(x), list.insert(i, x), insert.pop([i]), list.remove(x), list.reverse(), list.sort()`

list.sort() 和 list.reverse() 是原地修改的，返回值是 `None`

list comprehension 在规则简单的情况下比 filter 和 map 更简洁易读。

```python
squares = [x ** 2 for x in range(10)]
[(x, y) for x in [1, 2, 3] for y in [3, 1, 4] if x != y]

vec = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
[num for elem in vec for num in elem]   # => [1, 2, 3, 4, ..., 9]
```

### tuple

```python
t = 1, 2, 'a'       # => (1, 2, 'a')
u =  1,             # => (1, )
v = (1, )           # => (1, )
a, b, c = t         # => a = 1, b = 3, c = 'a'
```

### set

set（集合）是无序去重的结构，支持 in，-， |， &，^ 等操作。

```Python
a = set('abr')
b = set('ac')
a - b               # => set(['b', 'r'])
a | b               # => set(['a', 'b', 'c', 'r'])
a & b               # => set(['a'])
a ^ b               # => set(['b', 'c', 'r'])
```

`pop()` 随机返回并移除 set 中的一个元素，当为空时返回 `KeyError` 异常。

`remove(element)` 移除 set 中指定的元素，当其不存在时，返回 `KeyError` 异常。

### dictionary

除了字面量构建 dict 外，还可以从 tuple 的 list 或命名参数赋值的方式来构建，如：

```python
dict([('a', 1), ('b', 2)])
dict(a=1, b=2)
```

`dict.keys()` 获取所有的 key 组成的 list，`dict.values()` 获取所有的 value 组成的 list，`dict.items()` 或得 (key, value) 的 list。

## loop

在 for in 循环中，若需要 index，除了使用 range 的方式外，还可以使用 `enumerate` 函数。

```python
for i, v in enumerate(['tic', 'tac', 'toc']):
    print i, v
```

同时遍历多个序列，先使用 zip 处理一下或会更好一点。

```python
a = ['a', 'b', 'c']
b = [1, 2, 3]
for i, j in zip(a, b):
    print i, j
```

## Input & Output

`print 1`, 最后带 `,` 这种方式将不会自动换行。

下面这些函数可用来作为输出布局，都是返回一个新的字符串（String 是不可变的），当字符串长度大于 width 时，返回原字符串的拷贝，不作任何修改。

```python
str.rjust(width[, fillchar]);
str.ljust(width [, fillchar];
str.center(width [, fillchar]);
str.zfill(width);
```

### str.format

```python
str.format( *args, **kargs)  # => unicode
```

str 中用 `{}` 来代表预置的变量，可存在着多个，比如：`'first: {}, second: {}'.format(1, 2)`；也可以用 `{3}` 这样的方式来指定使用第4个参数（从0开始）；如果`format`中的参数带命名，那么还可以采用这样的方式：`'a: {a}'.format(1, a=2)`。

可以使用 `:` 来指定更加详细高级的格式，比如 `'a: {a:.3f}'.format(a=3.141592535)' # => 3.142` 从定义可知，还可以采用参数展开的方法来给 `format` 传参。

### str % var

This is the old style formatting. `'abc %s %d' % ('happy', 1)`

### file.seek(offset, from_what)

`from_what` 有 3 个值， 0（默认值）、1 和 2，分别代表 文件头、当前位置和文件尾。

## Errors & Exceptions

可以用 `except (Exception1, Exception2)` 的方式来对多种异常做相同的处理；`except Exception1`, `e` 是 `except Exception1 as e` 的简写；还可以用 `raise` 继续往外抛。

```python
import sys

try:
    f = open('file')
    s = f.readline()
    i = int(s.strip())
    s = i + str(notExist)
except (IOError, ValueError) as e:
    print "File content error({0}): {1}".format(e.errno, e.strerror)
except NameError:
    print "Not exist variable: notExist"
except:
    print 'other exception no expected'
    raise
```

raise 出来的异常对象（e）可带有信息，这些存在 `e.args` 这个元组中，并且，Exception 对象的 `__str__` 默认作了 print args 的效果，故不用特意去 print。

```python
`raise Exception('spam', 'eggs')`
```

`try except` 后还可带 else 和 finally 块，前者在无异常发生时执行，而后者则总会执行到。

## Classes

### Names & Objects

对象（Object）是独立自由的，可以用多个名字（Names）来指向它。可以认为 Name 是 Object 的别名（Alias）或软链接、快捷方式之类。Python 中，参数传递和赋值使用的都是 Name 而不是直接使用 Object，因此，传参的代价就很小了。

### Namespaces & Scopes

对于运行时的可直接访问的 Namespaces，有以下作用域：

- 最里层作用域，最先查找，包含局部变量
- 外包装函数作用域，一层层往外查找，包含了非当前局部变量和非全局变量
- 模块作用域，包含了模块全局变量
- 最外层（最后查找）的是内置（built-in）作用域，包含了内置变量

Assignments do not copy data – they just bind names to objects.

### class

```python
class MyClass:
    """class doc"""
    i = 123456
    def f(self):
        return 'hello'

MyClass.i   # => 123456
MyClass.f   # => <unbound method MyClass.f>
```

`__init__` 充当构造函数（如果需要）。

```python
x = MyClass()
x.i         # => 123456
x.f         # => <bound method MyClass.f of ..... at 0x....>
```

*Notes*: 称 MyClass.f 为 function，称 x.f 为 method。

```python
def df():
    print 'df'

x.df = df   # => 认为这是一个 data attribute 而不是 method attribute
```

`x.f()` 实质为 `MyClass.f(x)`。

调用一个实例的属性（attribute）的过程是：首先看是否是 data attribute，是则返回；否则搜索其 class，挡在其 class 中找到对应名字的 function，则用该实例和对应的 function 创建一个 method 对象。当调用该 method 对象时，用该实例和 method 对象实参组成的新实参来调用 class 的 function。

类实例的 class 属性指向该类。

继承机制中，子类的 data attribute 和 method attribute 将会覆盖基类的对应 attribute。这包括 method 调用的 method，如：

```python
class A():
    def p(self):
        print 'a'
    def l(self):
        self.p()

class B(A):
   def p(self):
       print 'b'

b = B()
b.l()           # => 'b'
```

B 的实例 b 调用继承自 A 的 method `l`，里面又调用了 p method，此时，调用的是 B 中 override 后的 method。

## Iterators

```python
s = 'abc'
it = iter(s)
it.next()   # => 'a'
it.next()   # => 'b'
it.next()   # => 'c'
it.next()   # => StopIteration
```

若需要对一个 class 实现 for in 迭代，只需要定义 iter 和 next 方法即可，其中，iter 返回 self，next 负责返回当前结果，越界时抛出 StopIteration 异常。

```python
class Reverse:
    def __init__(self, data):
        self.data = data
        self.index = len(data)
    def __iter__(self):
        return self
    def next(self):
        if self.index == 0:
            raise StopIteration
        self.index = self.index - 1
        return self.data[self.index]
```

## Generators

和普通函数相同，只是在该 return 时使用 `yield`。

```python
def reverse(data):
    for index in range(len(data)-1, -1, -1):
        yield data[index]
```

## Standard Library

### Operating System Interface

use `import os` instead of `from os import *`, this will keep `os.open()` shadowing the built-in `open()` function which operates much differently.

`os.system(command)` execute the command(a string) in a subshell.

for high level file and directory tasks, the shutil module is much more easier.

### 文件通配查找

```python
glob.glob(pathname)
```

### Command Line Arguments

`sys` 模块中常用的是 `sys.argv`，`getopt` 和 `argparse` 可以提供更高级的参数处理。

### 性能测量

timeit, profile, pstats

```python
from timeit import Timer
Timer('t=a; a=b; b=t', 'a=1; b=2').timeit()
```

### 测试

`doctest` 允许运行以一定规则写在 docstring 中的代码，并判断是否和给出的结果相符，若有失败，则输出信息。

```python
def average(values):
    """Computes the arithmetic mean of a list of numbers

    >>> print average([20, 30, 70])
    40.0
    """
    return sum(values, 0.0) / len(values)

import doctest
doctest.testmod()
```

#### unittest

```python
import unittest

class TestStatisticalFunctions(unittest.TestCase):

    def test_average(self):
        self.assertEqual(average([20, 30, 70]), 40.0)
        self.assertEqual(round(average([1, 5, 7]), 1), 4.3)
        self.assertRaises(ZeroDivisionError, average, [])
        self.assertRaises(TypeError, average, 20, 30, 70)

unittest.main() # Calling from the command line invokes all tests
```
