---
layout: post
title: "Rest parameters and defaults in ES6"
date: 2015-12-28 17:25:10 +0800
comments: true
categories: frontend javascript
---

ES6 给函数增加了剩余参数（rest parameters）和参数默认值的功能。

## 剩余参数

因为 JavaScript 并没有重载功能，以及为了支持可变参数的情况，是通过 `arguments` 来实现的。ES6 增加了剩余参数这个功能，希望能简化下这种情况下的实现。

```js
function containsAll(haystack, ...needles) {
  for (let needle of needles) {
    if (haystack.indexOf(needle) === -1) {
      return false;
    }
  }

  return true;
}

console.log(containsAll('abc', 'a', 'b'));
console.log(containsAll('abc', 'a', 'd'));
console.log(containsAll('abc'));
console.log(containsAll());
```

## 参数默认值

参数默认值可用来解决以前需要用 `param = param || 'default'` 或 `if` 判断设置的情况。

```js
function sayHello(name, word="hello") {
  console.log(`${word}, ${name}`);
}
sayHello('Jimmy');
sayHello('Kate', '你好');
sayHello('Jimmy', undefined);
```


ES6 中，由于默认参数的表达式实在调用时自左而右地计算，所以，默认参数可以使用其之前的参数，如下：

```js
function conditionalParameter(a, b=(a==1 ? 2 : 3)) {
  return a + b;
}

console.log(conditionalParameter(2, 5));// 7
console.log(conditionalParameter(1));   // 3
console.log(conditionalParameter(2));   // 5
```

## 参考资料

- [ES6 In Depth: Rest parameters and defaults](https://hacks.mozilla.org/2015/05/es6-in-depth-rest-parameters-and-defaults/)
