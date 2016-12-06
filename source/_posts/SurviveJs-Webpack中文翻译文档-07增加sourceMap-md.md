---
title: SurviveJs-Webpack中文翻译文档-07增加sourceMap.md
date: 2016-10-13 16:38:37
author: Bing
tags:
  - Webpack
  - 学习
  - SurviveJs
  - javascript
categories: []
---

# Enabling Sourcemaps
为了增强应用排查错误的能力（debuggability），我们对代码（code）和样式表(styling)可以构建源代码追踪（Sourcemaps ）。Sourcemaps可以让你观察到错误到底在哪儿里出现的。Webpack可以创建内联在bundle的Sourcemap或者分离的Sourcemap文件。前者效率高在开发环境中比较用用，后者bundle文件更小，在生产环境使用较多。

## 在生产环境中使用Sourcemaps
为了在开发中实现sourcemaps，我们可以使用与之相符的`eval-source-map`默认项，而在生产环境中，我们可以使用普通的Sourcemaps（分离文件）：
```
...

switch(process.env.npm_lifecycle_event) {
  case 'build':
    config = merge(
      common,
leanpub-start-insert
      {
        devtool: 'source-map'
      },
leanpub-end-insert
      parts.setupCSS(PATHS.app)
    );
  default:
    config = merge(
      common,
leanpub-start-insert
      {
        devtool: 'eval-source-map'
      },
leanpub-end-insert
      parts.setupCSS(PATHS.app),
      ...
    );
}

module.exports = validate(config);
```
`eval-source-map`在初始化打包时比较缓慢，但是非初始化打包就会更快，而且生成正真的文件。开发时较快速的打包选线，如`cheap-module-eval-source-map` 和 `eval`,效果不是那么好。所有带`eval`的选项都回将sourcemaps作为JavaScript代码的一部分生成。

为了实现sourcemaps,你需要在浏览器开发这工具中设置中开启sourcemaps。

## Webpack支持的sourcemap类型
尽管在开发中使用`eval-source-map`或者`eval`已经足够了，Webpack还提供了其它的类型。由于这些类型将会同bundles一起生成，所以在生产环境是无用的。
















