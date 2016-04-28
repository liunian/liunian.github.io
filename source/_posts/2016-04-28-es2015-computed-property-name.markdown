---
layout: post
title: "ES2015之对象计算属性值（computed property name）"
date: 2016-04-28 10:04:55 +0800
comments: true
categories: javascript frontend
---

对于 JavaScript 普通对象，定义和使用一般如下：

```js
var obj = {
     a: 1
};
obj.b = 2;
var k = 'c';
obj[k] = 3;
obj['a'] = 0;
```

如果属性名（property name）是变量，那么引用时需要使用 `[]` 语法。

ES2015 中，使用字面量创建对象时也可以使用变量来创建属性名，具体方案是使用计算属性名（computed property name），使用形式是 `[property]`，如：

```js
var i = 1;
var obj = {
  [i]: 3
};
console.log(obj); // {'1': 3}
```

并不是只能使用变量，而是可以使用一切表达式，如：

```js
// Computed property names (ES6)
var i = 0;
var a = {
  ["foo" + ++i]: i,
  ["foo" + ++i]: i,
  ["foo" + ++i]: i
};

console.log(a.foo1); // 1
console.log(a.foo2); // 2
console.log(a.foo3); // 3

var param = 'size';
var config = {
  [param]: 12,
  ["mobile" + param.charAt(0).toUpperCase() + param.slice(1)]: 4
};

console.log(config); // { size: 12, mobileSize: 4 }
```

## 参考链接

- [Computed property names](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Object_initializer#Computed_property_names)
