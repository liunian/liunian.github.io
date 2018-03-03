# Blog 环境设置

> 工作在 `source` 分支就可以了，`master` 分支由 `bundle exec rake deploy` 来生成

## 安装 `rbenv`

- 先卸载 `rvm`: `$ rvm implode`
- 安装 rbenv: `$ brew install rbenv`
- 把 rbenv shims 目录添加进路径，如 bash `export PATH=~/.rbenv/shims:$PATH`

## 安装 ruby

> 设置镜像
> `$ gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/`

- 安装 ruby，如：`$ rbenv install 2.5.0`
- 切换 ruby 版本，如 `$ rbenv local 2.5.0`，切换后需要运行 `$ rbenv rehash`

## 安装 bundler

- 安装 bundler，`$ gem install bundler`

> 设置 bundle 镜像
> `$ bundle config mirror.https://rubygems.org https://gems.ruby-china.org`

## 安装 gems

- 安装 gems，`$ bundle install`

## 运行 Rake 命令

octopress 的 rake 命令需要前置 `bundle exec` 运行，如 `bundle exec rake preview`

