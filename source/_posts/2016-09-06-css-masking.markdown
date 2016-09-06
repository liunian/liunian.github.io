---
layout: post
title: "CSS 蒙版"
date: 2016-09-06 14:40:54 +0800
comments: true
categories: css frontend
---

使用 CSS 蒙版可以帮助达到类似弹层指引的效果。

css 蒙版的关键点是：黑色表示完全透明展示；白色表示不展示，即图片完全被遮盖，黑色一片；而中间的颜色则表示相应的透明度。

示例代码：

```html
<div id="container" style="position: relative;">
	<svg style="position: absolute;" width="400" height="280">
		<defs>
          <mask id="mask3">
            <rect x="0" y="0" width="100%" height="100%" style="stroke:none; fill: #888"></rect>
            <circle id="circle1" cx="100" cy="100" r="50" />
            <rect x="200" y="200" width="100" height="50"></rect>
          </mask>
		</defs>
      
		<rect x="0" y="0" width="100%" height="100%" style="stroke: none; mask: url(#mask3)"></rect>
	</svg>
   
	<img src="http://img6.cache.netease.com/cnews/2014/11/3/20141103100737855b7.jpg" />
</div>
```

示例效果：

<!--more-->
<a class="jsbin-embed" href="http://jsbin.com/wogunecaqa/embed">JS Bin on jsbin.com</a><script src="http://static.jsbin.com/js/embed.min.js?3.39.15"></script>

## 参考文档

- [CSS Masking](http://www.html5rocks.com/en/tutorials/masking/adobe/)
