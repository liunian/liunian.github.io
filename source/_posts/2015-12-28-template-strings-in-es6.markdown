---
layout: post
title: "Template Strings in ES6"
date: 2015-12-28 17:22:27 +0800
comments: true
categories: frontend javascript
---

ES6 中的 template string 并不是 Mustache 这类模板库的替代品，最重要的是提供字符串插值功能，但并不提供诸如 if/for 等控制功能

## 定义

普通的字符串是使用 `'` 或 `"` 来定义，template string 是使用 `````。

```js
let s = `This is a template string`
```

不同的是，template string 可以直接用来定义多行的字符串，并且保留其换行和空白。

```js
let ss = `This is a 
multiple line templat string
  which reserves space`
```

## 插值

和普通字符串相比，除了能够方便地定义多行的字符串外，还支持字符串插值，插值处支持任何 JavaScript 表达式，如果表达式返回值不是字符串，那么则按照通用的规则来做转换。

```js
let obj = {
  name: 'obj',
  say: () => {return 3}
}

let c = `The ${obj.name} says: ${obj.say()}`
console.log(c) // The obj says: 3
```

## 参考资料

- [ES6 In Depth: Template strings](https://hacks.mozilla.org/2015/05/es6-in-depth-template-strings-2/)
