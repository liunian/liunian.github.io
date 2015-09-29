---
layout: post
title: "shadow dom"
date: 2015-09-29 10:17:55 +0800
comments: true
categories: frontend
---

Shadow DOM 的用途是封装隔离一个元素，从而在组件化的过程中隔离外部样式和 JS 的影响。

## 使用

### 创建

通过在一个元素（A）上创建一个 shadow root 的方式来创建 shadow dom，返回的值成为 shadow root，A 成为 shadow host。

一旦创建了 shadow root，那么宿主元素的原内容将不被展示，而是展示 shadow root 的内容。

可以在一个 shadow host 上创建多个 shadow root（但只有最新的一个会生效，但可以通过 `<shadow></shadow>` 来内嵌引用前一个 shadow；并且目前无法移除 shadow root），还可以把一个 shadow root 里的元素作为 shadow host 来继续创建 shadow root。

```
<button>Hello, world!</button>
<script>
var host = document.querySelector('button');
var root = host.createShadowRoot();
root.textContent = 'こんにちは、影の世界!';
</script>
```

通过配合使用 [html template](http://liunian.github.io/blog/html-template/) 可以简化创建时的繁琐，如：

```
var shadow = document.querySelector('#nameTag').createShadowRoot();
var template = document.querySelector('#nameTagTemplate');
var clone = document.importNode(template.content, true);
shadow.appendChild(clone);
```

<!-- more -->

#### 相关属性

- `element.shadownRoot`：获取一个元素挂着的生效的 shadow root
- `shadowRoot.host`：获取 shadow root 的宿主元素

### 引用、多个和嵌套

#### 引用 host 内容

创建了 shadow root 后，宿主元素的原内容将不被展示，而是展示 shadow root 的内容，但可以在 shadow root 中使用`<content></content>` 来引用宿主**直接子元素**的内容。

> 下面假定 #host 表示 shadow root 的 host，shadow root 的内容是 #template 里的内容

```
<div id="host">
    <p>paragraph</p>
    <div class="a">with selector .a</div>
    <div>something in <span>span0</span></div>
    <span>span1</span>
    <br>
    <span>span2</span>
</div>

<template id="template">
    <header>header</header>
    <nav>nav</nav>
    <div class="main">
        <content></content>
    </div>
    <footer>footer</footer>
</template>
```

对于上面的代码，`#host` 标签里的原内容会被投射到 div.main 里。

`content` 是表示选择什么内容来投射到当前位置，默认是投射全部内容。

可以使用 `select="immediate_child_selector"` 来选择 host 里直接子元素来投射，如 `<content select="p"></content>` 可以引用 `p`；`<content select="span"></content>` 来引用 span1 和 span2，但不会引用 span0，因为 span0 不是直接子元素。

可以有多个 `<content>` 标签，但被引用的内容仅能被引用一次，先到先得，后来的将只能在挑剩的里面找匹配的。

```
<div id="host">
    <div class="a">div0</div>
    <div class="b">div1</div>
    <div class="a">div2</div>
    <div class="c">div3</div>
</div>

<template id="template">
    <content select=".a, .b"></content>
    <hr>
    <content select="div"></content>
</template>
```

上面的例子中， `<content select=".a, .b"></content>` 引用了 div0，div1 和 div2，那么位于其后的 `<content select="div"></div>` 将只能匹配到剩下的一个 div3。

#### 多个 shadow root 和嵌套

对于一个宿主，可以创建多个 shadow root，但仅有最新的一个会生效。

```
<div id="host">
    <div class="a">a</div>
    <div class="b">b</div>
    <div class="c">c</div>
</div>

<template id="t1">
    <content select=".a"></content>
</template>

<template id="t2">
    <content select=".b"></content>
</template>

<template id="t3">
    <conent select=".c"></conent>
</template>

<script>
    var $ = function(id) {return document.getElementById(id);},
        host = $('a'),
        t1 = $('t1'),
        t2 = $('t2'),
        t3 = $('t3');

    function addShadow(templateNode) {
        host.appendChild(document.importNode(templateNode.content), true);
    }

    addShadow(t1);
    addShadow(t2);
    addShadow(t3);
</script>
```

上面最终将只展示 `div.c`。

#### 嵌套

但如果在 `#t3` 的 `<content>` 后添加 `<shadow></shadow>`，那么则可以引用上一个 shadow root（可以看做是 FILO 的栈），这样展示的 `div.c` 后会展示 `div.b`。还可以在 `#t2` 的 `<content>` 后添加 `<shadow></shadow>`，那么会在 `div.b` 后展示 `div.a`。

需要注意的是，嵌套时，如果使用了 `content`（有或没 select），那么最外层的 shadow root 引用了的元素将不会被内层的 shadow root 再次引用。

```
<template id="t1">
    <content select=".a"></content>
    <shadow></shadow>
</template>

<template id="t2">
    <content select=".b"></content>
    <shadow></shadow>
</template>

<template id="t3">
    <conent select=".c"></conent>
    <shadow></shadow>
</template>
```

### 样式

shadow root 隔离了普通的的样式，这意味外面的样式影响不了里面的，而里面的也影响不了外面的。

但还是可以通过特定的选择器来在内部对 host 或从外部对内部设置样式。

#### 在内部设置 host 的样式

```
:host(x-foo) { 
  /* Applies if the host is a <x-foo> element.*/
}

:host(x-foo:host) { 
  /* Same as above. Applies if the host is a <x-foo> element. */
}

:host(div) {  {
  /* Applies if the host element is a <div>. */
}
```

- `:host`，对 host 设置样式
- `:host(selector)`，如果 host 匹配了 selector，那么设置样式
- `:host-context(selector)`，如果 host 或其祖先元素匹配了 selector，那么设置样式


#### 在外部影响内部样式

```
x-tabs::shadow x-panel::shadow h2 {
  ...
}

x-tabs /deep/ x-panel {
  ...
}

body /deep/ .library-theme {
  ...
}
```

- `::shadow`，选择当前 host 的 shadow root
- ` /deep/ `，选择其 shadow root、子元素的 shadow root 和嵌套的 shadow root

#### 投射的元素的样式

通过 `<content>` 来投射的元素的样式不是在 shadow root 内生效的，而是受原节点结构相关联的样式影响。这是因为投射过去的元素并不是在 shadow root 内，那只是一个渲染节点而已。

如果需要在 shadow root 内设置投射过来的元素的样式，那么需要使用 `::content` 伪元素来选择对应的 content 映射空间，然后再接上待匹配的元素的选择器即可，如 `::content[select=div] .header`。

### 遍历

遍历 shadow root 和其后代元素，可以通过 `element.shadowRoot` 来获取 shadow root，然后通过选择器 api（`querySelector` 等） 来获取后代元素。

但需要注意的是，通过 `content` 来投射的内容并不能这样获取，因为其并不在 shadow 树上。这需要在 `content` 节点上调用 `getDistributedNodes()` 来获取所有被引用的节点列表（NodeList）。

## 参考

- [Shadow DOM 101](http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom/)
- [Shadow DOM 201 - CSS and Styling](http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom-201/)
- [Shadow DOM 301 - Advanced Concepts & DOM APIs](http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom-301/)
