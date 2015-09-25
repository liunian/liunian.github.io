---
layout: post
title: "JavaScript 严格模式"
date: 2015-08-01 00:29:35 +0800
comments: true
categories: fronteer, javascript
---

严格模式的提出是为了约束一些 JavaScript 的使用方式，修改一些容易导致失误和安全问题的地方。因为严格模式和非严格模式下的语义有所不同，所以使用上需要谨慎，最好渐进的使用。

## 使用

有两种使用方式，影响整个脚本的脚本方式和影响函数的方式。

### 脚本方式

在脚本最前面（需要是第一个有效语句，注释不是）添加 `'use strict';`，只是字符串，所以可以用双引号或单引号。

```js
// Whole-script strict mode syntax
'use strict';
var v = "Hi! I'm a strict mode script!";
```

<!-- more -->

### 函数方式

```js
function strict(){
  // Function-level strict mode syntax
  'use strict';
  function nested() { return "And so am I!"; }
  return "Hi!  I'm a strict mode function!  " + nested();
}

function notStrict() { return "I'm not strict."; }
```

## 变更

严格模式影响了语法和语义。

### 把失误转为错误

- 防止无意间创建全局变量

```js
'use strict';
                        
mistypedVariable = 17;  // 拼写失误或故意不用 var 来声明将抛异常
```

- 把静默失败的赋值调整为抛出异常

包括 `NaN`，非严格模式下给不可写、只读的属性赋值，给不可扩展、sealed 或 froze 的对象添加属性会静默失败，严格模式下会抛出异常。

```js
"use strict";

// throws exception
NaN = 1;

// Assignment to a non-writable property
var obj1 = {};
Object.defineProperty(obj1, "x", { value: 42, writable: false });
obj1.x = 9; // throws a TypeError

// Assignment to a getter-only property
var obj2 = { get x() { return 17; } };
obj2.x = 5; // throws a TypeError

// Assignment to a new property on a non-extensible object
var fixed = {};
Object.preventExtensions(fixed);
fixed.newProp = "ohai"; // throws a TypeError
```

- 删除不可移除的属性时报错（以前是返回 false 表示不可移除）

```js
"use strict";
delete Object.prototype; // throws a TypeError
```

- 对象字面量存在相同的 key 时报错

以前会取最后一个 key 的值为该 key 的值。

```js
"use strict";
var o = { p: 1, p: 2 }; // !!! syntax error
```

- 函数的参数名必须唯一

非严格模式下会取重复参数名最后的一个作为参数的值，但可以通过 `arguments` 来获取完整的参数。

```js
function sum(a, a, c){ // !!! syntax error
  "use strict";
  return a + b + c; // wrong if this code ran
}
```

- 不允许使用八进制语法

虽然说不上好坏，但严格模式的确是禁止了使用八进制语法。

```js
"use strict";
var sum = 015 + // !!! syntax error
          197 +
          142;
```

### 简化变量的使用

- 禁止使用 `with`
- `eval` 不再在作用域（全局或局部）中生成新的变量
- 不允许删除普通变量（需要删除对象属性）

```js
"use strict";

var x;
delete x; // !!! syntax error

eval("var y; delete y;"); // !!! syntax error
```

### 简化 `eval` 和 `arguments`

- 不能被赋值和作为参数或函数名等

```js
"use strict";
eval = 17;
arguments++;
++eval;
var obj = { set p(arguments) { } };
var eval;
try { } catch (arguments) { }
function x(eval) { }
function arguments() { }
var y = function eval() { };
var f = new Function("arguments", "'use strict'; return 17;");
```

- `arguments` 中的成员不是引用（意味着把实参拷贝到 arguments 中）

> 注意：至少在 node.js 0.12.7 中是浅拷贝而不是深拷贝。这样如果不是改变整个参数而是修改参数的属性时，会双向影响

非严格模式下，修改实参会改变 arguments，但严格模式下不会改变；同样地，改变 arguments 中的值不会改变实参。这样意味着双方将独立变化。

```js
function f(a){
  "use strict";
  a = 42;
  return [a, arguments[0]];
}
var pair = f(17);
console.assert(pair[0] === 42);
console.assert(pair[1] === 17);
```

- 不能使用 `arguments.callee`

请使用命名函数

```js
"use strict";
var f = function() { return arguments.callee; };
f(); // throws a TypeError
```

### 更「安全」

- 函数中的 this 不再被强制装箱包装成对象，这意味着对于普通调用，`this` 将是 `undefined` 而不是非严格模式下的 `global`（浏览器中是 `window`）。
- 无法遍历调用栈，`fn.caller`、`fn.arguments` 等禁止访问

```js
function restricted()
{
  "use strict";
  restricted.caller;    // throws a TypeError
  restricted.arguments; // throws a TypeError
}
function privilegedInvoker()
{
  return restricted();
}
privilegedInvoker();
```

- 禁止使用 `arguments.caller`

```js
"use strict";
function fun(a, b)
{
  "use strict";
  var v = 12;
  return arguments.caller; // throws a TypeError
}
fun(1, 2); // doesn't expose v (or a or b)
```

### 为后续 ECMAScript 版本做准备

- 部分标识符变为保留字，包括 `implements`、`interface`、`let`、`package`、`private`、`protected`、`public`、`static` 和 `yield`。
- 禁止函数声明提升（注意，变量依然 ok），相应地，禁止了在块（如 if）中声明函数

```js
"use strict";
if (true){
  function f() { } // !!! syntax error
  f();
}

for (var i = 0; i < 5; i++){
  function f2() { } // !!! syntax error
  f2();
}

function baz(){ // kosher
  function eit() { } // also kosher
}
```

## 参考

- [Strict mode](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)
