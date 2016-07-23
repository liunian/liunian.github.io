---
layout: post
title: "html readonly 属性"
date: 2016-07-23 13:15:38 +0800
comments: true
categories: frontend
---

`readonly` 属性用于控制表单字段不可编辑，但和 `disabled` 不同，form 表单提交时会把值提交上去。

但对以下表单元素无效，包括 type 是 `hidden`、`range`、`color`、`checkbox`、`radio`、`file` 以及按钮类型（button 或 submit）。
