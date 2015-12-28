---
layout: post
title: "Arrow function in ES6"
date: 2015-12-28 17:27:28 +0800
comments: true
categories: frontend javascript
---

Arrow function 的使用一来能简化匿名函数的使用，二来能解决匿名函数中不时碰到的 `this` 指向的问题。

在 JavaScript 中，大量地使用到匿名函数，比如事件绑定和像 map/reduce/filter 等这些方法中。

```js
var selected = allJobs.filter(function (job) {
  return job.isSelected();
});
```

使用 arrow function 后，可以简化为下面这样：

```js
var selected = allJobs.filter(job => job.isSelected());
```
<!-- more -->

可以注意到的是，在上面的语句中，不需要显示地 return。

在多参数的情况下或无参数的情况下，参数列表需要用 `()` 来包围，如：

```js
// ES5
var total = values.reduce(function (a, b) {
  return a + b;
}, 0);

// ES6
var total = values.reduce((a, b) => a + b, 0);
```

在函数体不是一个语句的时候，需要用 `{}` 来包住，并且这个时候将需要显示的 `return` 才会返回值。

```js
// ES5
$("#confetti-btn").click(function (event) {
  playTrumpet();
  fireConfettiCannon();
});

// ES6
$("#confetti-btn").click(event => {
  playTrumpet();
  fireConfettiCannon();
});
```

## this

arrow function 没有自己的 this 值，任何情况下 arrow function 里的 this 的值都是继承自 arrow function 的上下文。

这同时也意味着，即便使用 `call` 或 `apply`，也不会改变 `this` 的指向。

```js
let i = {
  a: function() {
    return 'i.a'
  }
}

let obj = {
  a: function() {
    return 'obj.a'
  },
  b: function() {
    setTimeout(() => {
      console.log('obj.b', this.a())
    }, 1000)
  },
  c: function() {
    var f = function() {
      console.log('obj.c', this.a())
    }
    f.call(i)
  },
  d: function() {
    var f = () => console.log('obj.d', this.a())
    f.call(i)
  }
}

obj.b() // obj.b obj.a
obj.c() // obj.c i.a
obj.d() // obj.d obj.a
```

## 参考资料
- [ES6 In Depth: Arrow functions](https://hacks.mozilla.org/2015/06/es6-in-depth-arrow-functions/)
- [Arrow functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions)
