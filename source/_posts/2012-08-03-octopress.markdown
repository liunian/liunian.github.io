---
layout: post
title: "Octopress memo"
date: 2012-08-03 02:51:34 +0800
comments: true
categories: Octopress memo
---

## Install

```bash
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
```

Add to bash command

```bash
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile
source ~/.bash_profile

# If using Zsh do this instead
echo '[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm' >> ~/.zshrc
source ~/.zshrc
```

Install Ruby

```bash
rvm install 1.9.2 && rvm use 1.9.2
# 1.9.3 will not fit here for now
```

Switch back to system

```bash
rvm use system
```

when using zsh, should add something in .zshrc to make it work right.

```bash
alias rake="noglob rake"
```

After adding it, restart the terminal or source the .zshrc file.

<!-- more -->

## code snippets

### [Basic](http://octopress.org/docs/blogging/code/)

```
``` [language] [title] [url] [link text]
code snippet
\```
```

### Gists

```
{\% gist gist_id [filename] %}
```

### Include Code Snippets

Import files on your filesystem into any blog post as embedded code snippets with syntax highlighting and a download link. In the _config.yml you can set your code_dir but the default is `source/downloads/code`. Simply put a file anywhere under that directory and use the following tag to embed it in a post.

```
{% include_code [title] [lang:language] path/to/file %}
```

Following example will include the code file: `source/downloads/code/test.js`

```
{% include_code test.js  %}
```

## image

```
{% img [class names] /path/to/image [width] [height] [title text [alt text]] %}
```

## extended blockquote

```
{% blockquote [author[, source]] [link] [source_link_title] %}
Quote string
{% endblockquote %}
```

## Render Partial

```
{% render_partial path/to/file %}
```

## add about page

```
http://gangmax.github.com/blog/2012/05/04/add-about-page-in-octopress/
```
