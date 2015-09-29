---
layout: post
title: "Ie6 float right 导致换行"
date: 2012-06-29 02:11:20 +0800
comments: true
categories: css frontend
---

## 问题描述

IE6 下，当一个 float:right 的元素不是第一个子元素并且其前面没有 float:left 的元素时，那么将会将会导致一个换行。

## 解决方法

将 float:right 的元素放到最前面
把 float:right 前面的一个或多个元素加上 float:left（视样式而定)

<!-- more -->

## demos

{% include_code ie6_float_right.html %}
