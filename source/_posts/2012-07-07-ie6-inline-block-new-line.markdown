---
layout: post
title: "Ie6 Inline-block 折行问题"
date: 2012-07-07 12:49:50 +0800
comments: true
categories: css fronter
---

## 问题描述

IE6 下使用 `display:inline-block` 可能会发现中间出现了折行。

## 解决方法

`display:inline-block` 的元素前后不能有空白符，需要紧紧相连。
