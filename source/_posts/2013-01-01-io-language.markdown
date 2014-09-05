---
layout: post
title: "Io Language"
date: 2013-01-01 03:13:05 +0800
comments: true
categories: memo
---

这是 [Io](http://iolanguage.org/) 的简单笔记。

相关资源

- [官网](http://iolanguage.org/)
- [wiki](http://en.wikibooks.org/wiki/Io_Programming)
- [一个中文博客](http://www.iolanguage.net/)
- [Tutorial](http://iolanguage.org/scm/io/docs/IoTutorial.html)

## Basic

1. 字符串只能用双引号，不能用单引号
2. 没有类，只有类型和对象。两者的区别是前者有type标识(slot)，并且该标识是在创建时因为其为大写字母开头而确定为类型来添加的。
3. 不是对象式的方法调用，而是向对象发送信息，比如 "abc" print。
4. 一般地，赋值使用 := 而不是 =，如 obj := Object clone。在对象或对象 slot 还没存在的情况下，使用 = 会出错，但使用 := 则会先创建然后赋值。
5. 从上可以看到，从某种类型创建一个对象使用 clone 消息。
6. 查看一个对象可用 obj slotNames。
7. 继承机制使用原型（proto）而不是父子类，如：
{% include_code 1.io %}
8. 方法使用 method() 创建，如：Car dirve := method("Vroom" print)，给 ferrari 发送 drive 消息将有 ferrari drive => "Vroom"。
9. 和 Ruby 一样，0 是 true 而不是 false。nil 是 false。

<!-- more -->

## List & Map
{% include_code 2.io %}

## Control Flow

```io
loop("getting dizzy..." println)

# while(condiction, other_codes)
i := 0
while(i <= 11, i println; i = i + 1);   "This one goes up to 11" println

# for(counter, init, end, step, msg_slot)
for(i, 1, 11, 2, i println)

# if(condition, true_code, false_code)
if(true, "It is true.", "It is false.")
if(false) then("It is true.") else("It is false")
```
