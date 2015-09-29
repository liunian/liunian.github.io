---
layout: post
title: "html template"
date: 2015-09-21 17:49:18 +0800
comments: true
categories: frontend
---

HTML 5.1 计划增加 template 元素，提供一段可被后续被 JavaScript 克隆和插入的代码片段。

## what

`<template></template>` 元素是提供页面渲染是不被解析渲染，但在 JavaScript 使用并插入到文档后才解析渲染的代码片段。其可存放任意合法的 HTML 内容，可位于任何合法的非替换元素里，包括 `<head>` 等。

如[示例一](http://defg.sinaapp.com/demos/template/1.html)：

	<template>
		<style>
		div {
			color: red;
		}
		</style>
	
		<div>
			<h1>template</h1>
			<img src="http://holdit.sinaapp.com/300" />
		</div>
	
		<script>
		alert('template');
		</script>
	
	</template>

需要注意的是，这是一个可被重复使用的文档片段，并没有像 Mustache 那样的模板插值（`{{variable}}`）甚至更高级的流程处理的功能。这是一个静态的模板，不是根据数据来动态生成 HTML 字符串。

<!-- more -->

## why

一直都有着重复使用一段内容（模板）的需求，以前使用的主要方式有两种：

一是使用隐藏的 DOM 元素来存放模板，这样可以直接使用 DOM API 来操作，但浏览器默认会解析结构、发送请求（如果有图片等）和解析脚本（如果有）；

二是使用 script 或 textarea 等默认不会解析的元素来存放，然后后续用 `innerHTML` 来放进文档，但容易造成 xss。

所以提出这个 `template` 来直接使用 DOM 来避免 xss，同时也延迟解析。

## how

### 判断是否支持

	function supportsTemplate() {
	  return 'content' in document.createElement('template');
	}
	
	if (supportsTemplate()) {
	  // 检测通过！
	} else {
	  // 使用旧的模板技术或库。
	}

### 获取模板内容

	var templateNode = document.querySelector('template');
	var fragDoc = templateNode.content;

模板的 `content` 是一个 `documentFragment`，所以可以对其做 DOM 能做的任何操作，也可以直接把其插入到文档中。

### 克隆使用

[示例二](http://defg.sinaapp.com/demos/template/2.html)

虽然可以直接把模板内容插入文档，但如果需要重复使用，那就不合适了。因为插入后就把内容从模板中移动到了文档中，模板中的内容就是空的了。

这样，可以使用 `fragDoc.cloneNode(true)` 或 `document.importNode(fragDoc, true)` 来获取其克隆，然后再做处理。两种克隆方式的差别是：后者还适用于跨文档的情况，比如 iframe 和 shadow dom 这些情况；另，当前测试中（2015-09-18），Chrome 下 importNode 会请求 img 等，但 cloneNode 不会，暂没去确定规范是如何的。

需要注意的是，克隆后，并不会运行模板中的脚本，而是在插入到文档中后才会运行里面的 js 脚本。

## 参考文档

- [Introduction to template element](http://webcomponents.org/articles/introduction-to-template-element/)
- [HTML’s new template tag](http://www.html5rocks.com/en/tutorials/webcomponents/template/)
- [w3c template spec](https://html.spec.whatwg.org/multipage/scripting-1.html#the-template-element)
