---
layout: post
title: "Iterator in ES6"
date: 2015-12-24 16:17:41 +0800
comments: true
categories: frontend javascript
---

`for-of` 使用迭代器（iterator）来迭代一个可迭代（iterable）的对象，主要是想取代传统的比较繁琐的 `for` 及会遍历非自带属性以及无法 `continue/break/return` 的 `forEach`，其基本示例如：

```js
for (let i of [1, 2, 3]) {
	console.log(i);
}
```

`for-of` 默认支持了数组、字符串、类数组以及 ES6 中的 Map 和 Set 等，但不支持平对象（字面量对象）（实际支持情况还看浏览器，比如在此刻 firefox 支持了 NodeList，但 Chrome 还不支持）。

迭代 Map 可以像上面那样使用单变量来在每次迭代时得到一个数组，也可以配合列表结构来直接得到 key 和 value。

```js
let aMap = new Map();
aMap.set('a', 1)
aMap.set('b', [2]);

for (let [k, v] of aMap) {
  console.log(k, v);
}
```

<!-- more -->

## 迭代器

一个对象只要遵循迭代器协议就是一个迭代器。

### 迭代器协议

实现了 `.next()` 方法，该方法返回一个字面量对象，里面需要有两个属性，`done` 表示是否迭代了最后，`value` 则是每次迭代需要返回的值。

## 可迭代对象

一个对象只要遵循了下面的协议，那么就是可迭代对象。

### 可迭代协议

一个对象或其原型上有 `@@iterator` 函数（ `[Symbol.iterator]`），该函数无实参，返回一个遵循迭代器协议的对象。

下面是一个简单的迭代器（同时也是一个可迭代对象），for-of 将会输出 5 4 3 2 1.

```js
var fiveTimesIterator = {
  _count: 5,
  [Symbol.iterator]: function () {
    return this;
  },
  next: function () {
    if (this._count == 0) {
      this._count = 5;
      return {done: true, value: 0};
    } else {
      return {done: false, value: this._count--};
    }
  }
};

for(var f of fiveTimesIterator) {
  console.log(f);
}
```

## 参考资料

- [ES6 In Depth: Iterators and the for-of loop](https://hacks.mozilla.org/2015/04/es6-in-depth-iterators-and-the-for-of-loop/)
- [Iteration protocols](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols)
