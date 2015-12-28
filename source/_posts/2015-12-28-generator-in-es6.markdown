---
layout: post
title: "Generator in ES6"
date: 2015-12-28 17:13:20 +0800
comments: true
categories: frontend javascript
---

生成器（Generator）是一个由生成器函数返回的对象，其既是一个迭代器，也是一个可迭代对象。

生成器函数则是一个使用 `function*` 来声明的函数，如：

```js
function* gen() {
}
```

## 能够暂停的函数

由于 JavaScript 是单线程的，所以一旦执行一个函数，那么一定是按顺序执行完函数体里的语句才能执行这个函数后面的语句。

生成器提供一个能力，可以在指定地方暂停，然后再在需要的时候回到暂停处继续执行。

```js
function* gen() {
  console.log(1);
  yield;
  console.log(2);
}

var it = gen();
it.next();
console.log(3);
it.next();
```

上面代码中，log 的顺序将是 `1 3 2`。

首先，调用生成器函数不会运行里面的代码，而是返回一个生成器。对于一个生成器而言，调用 `next` 方法来开始运行，然后在里面碰到 `yield` 时暂停里面的运行，而回到 `next` 调用处继续往下执行；再次调用 `next`，则回到生成器上次停止的地方继续往下执行，直至碰到 `yield` 而暂停里面回到外面或执行完毕。

<!-- more -->

## 作为可迭代对象使用

上面说到，生成器也是一个可迭代对象，那么，这样就可以使用 `for-of` 来迭代。

```js
function* foo() {
    yield 1;
    yield 2;

    return 100;
}

var it = foo();

console.log(it.next());
console.log(it.next());
console.log(it.next());

console.log('=== for of ===');
for (var v of foo()) {
    console.log(v);
}
```

由于 `for-of` 是直接迭代值，所以，log 出来的直接就是 `1`、`2` 这样的值。

但需要注意的是，`for-of` 仅能遍历通过 `yield` 返回的值，通过 `return` 返回的值并不在其遍历范围。但 `next` 是可以拿到的，且 `return` 时拿到的迭代结果中的 `done` 是 `true`。

## 生成器内外双向传值

在调用 `next` 触发生成器运行到下一个 `yield` 处时，会同时返回迭代结果；下一次调用 `next` 时，可以传递一个参数进去，而这个值将是 `yield` 表达式的值。

```js
function* first() {
    var y = (yield 'foo');
    console.log(1 + y);
    yield 'ok';
}

var it = first();
console.log(it.next());
// send 3 into the place of the first yield as the pass-in value
console.log(it.next(3));
console.log(it.next());
```

上面代码输出结果将是

```
{done: false, value: 'foo'}
4
{done: false, value: 'ok'}
{done: true, value: undefined}
```

1. 第一次调用 `next`，生成器在运行了 `yield 'foo'` 后暂停，把 `foo` 给 `next` 返回；
2. 调用 `next(3)`，回到第一次 yield 的地方，把传入的 `3` 作为 yield 表达式的值赋给 `y`；然后运行到第二个 `yield` 处暂停，向 `next` 调用提供 `'ok'`；中间 log 了一下；
3. 最后调用 `next`，生成器运行至结束

## `yield*` 委托

`yield*` 的作用是迭代一个可迭代对象，把拿到的值再 yield 出去。

```js
function* foo() {
    yield 3;
    yield 4;
}

function* bar() {
    yield 1;
    yield 2;
    yield* foo();
    yield 5;
}

for (var v of bar()) {
    console.log(v); // 1 2 3 4 5
}
```

`yield*` 这个表达式本身的值是迭代可迭代对象最后返回的值（第一次 done 是 true 时的值），一般地是 `undefined`，如果是委托了一个生成器，并且这个生成器最后有 return，那么表达式的值则是 return 的值。

## 错误捕捉

可以对生成器函数体做捕捉，也可以对生成器的调用做捕捉。

```js
function* foo() {
    try {
        var x = yield 3;
        console.log(x);
        x();
    } catch (err) {
        console.log('Error: ' + err);
    }
}

var it = foo();
it.next();
it.next();


// catch from the outside
function* bar() {
    var x = yield 3;
    console.log(x);
    x();
}

var it2 = bar();
it2.next();
try {
    it2.next();
} catch (err) {
    console.log(err);
}
```

## 异步

生成器能在 yield 时暂停，next 的时候再继续运行。这样，或许能在碰到异步操作时 yield 来暂停，异步完成后再 next 继续运行，从而解决回调嵌套过深以及带来的理解问题。

### 常见的嵌套回调

```js
function asyncA(callback) {
  setTimeout(() => callback(1), 1000);
}

function asyncB(input, callback) {
  setTimeout(() => callback(input + 1), 1000);
}

asyncA((data) => {
  console.log('asyncA data', data);
  asyncB(data, (newData) => console.log('asyncB data', newData));
});
```

### 尝试使用 generator

```js
var it;

function a() {
  setTimeout(() => it.next(1), 1000);
}

function b(input) {
  setTimeout(() => it.next(input + 1), 1000);
}

function* gc() {
  var dataA = yield a();
  console.log('dataA', dataA);
  var dataB = yield b(dataA);
  console.log('dataB', dataB);
}

var it = gc();
it.next();
```

两个异步的调用和依赖看起来是和同步一样一条路下来了，但却对异步函数本身造成了入侵。一来依赖了一个外部迭代器；二来，无法在多次运行的场景保证正确。

### generator 配合 promise

上面的例子中，之所以会造成入侵，是因为需要在异步完成后通知生成器来继续运行，而异步代码本身没提供完成态的钩子。

ES6 中提供了 Promise，可以设置异步完成或错误时的相应行为。

这样，可以异步行为的函数返回一个 promise，然后在 promise 的 then 中调用 next。但这个过程不应手动，否则直接使用 promise 就可以了，没必要再配合 generator。应该让 next 的过程自动完成，方法是使用一个运行器。

```js
function runGenerator(g) {
  var it = g(), ret;

  (function iter(val) {
    ret = it.next(val);
    if (!ret.done) {
      // 简化，假定一定是返回 promise
      ret.value.then(iter);
    }
  })();
}

function a2() {
  return new Promise(function(resolve, reject) {
    setTimeout(() => resolve(1), 1000);
  });
}

function b2(input) {
  return new Promise(function(resolve, reject) {
    setTimeout(() => resolve(input + 1), 1000);
  });
}

runGenerator(function*() {
  var res1 = yield a2();
  console.log('res1', res1);
  var res2 = yield b2(res1);
  console.log('res2', res2);
});
```

可以看到，这样，异步函数本身保持了纯净，调用过程也能和同步一样看起来顺畅，把复杂性放到了运行器中。当然，这个运行器只是一个简单的模拟，实际需要考虑不是返回 promise 的情况，promise 里是 reject 的情况。



## 参考资料

- [ES6 In Depth: Generator](https://hacks.mozilla.org/2015/05/es6-in-depth-generators/)
- [async generators](https://davidwalsh.name/async-generators)
- [No promises: asynchronous JavaScript with only generators](http://www.2ality.com/2015/03/no-promises.html)
- [Async/Await: The Hero JavaScript Deserved](https://www.twilio.com/blog/2015/10/asyncawait-the-hero-javascript-deserved.html)
- [Async Functions](https://tc39.github.io/ecmascript-asyncawait/)
