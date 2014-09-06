#!/usr/bin/env io

a := List clone             # list(), create by using clone
a := list(1, 2, "a", "b")   # list(1, 2, a, b), create by using method

a at(1)                     # 2
a append(3)                 # list(1, 2, a, b, 3)

# more examples: http://iolanguage.org/scm/io/docs/IoGuide.html#Primitives-List
