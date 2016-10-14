---
title: SurviveJs-Webpack中文翻译文档-09压缩代码.md
date: 2016-10-13 16:39:01
author: Bing
tags:
  - Webpack
  - 学习
  - SurviveJs
  - javascript
categories: []
---
# Minifying the Build
到目前为止，我们还没有思考正式上线时的发布，不用怀疑，这个包将会很大，尤其是当我们引入了React这些库的时候。我们可以使用一些技术来降低打包后的体积。我们也可以控制客户端来对资源进行缓存和懒加载。我们将在**理解Webpack模块(Understanding Chunks)**这一章节详细讲解。

我们首先学习的就是代码压缩。就是不丢失原意的翻译来简化代码，最终会使代码变得很混乱，并且难以阅读。但这就是关键。

>尽管我们压缩了代码，我们还是可以通过配置`devtool`选项生成之前讨论的sourcemaps文件，这样将会使我们更好的debug我们的代码。


## 生成一个基本的构建
为了能开始，我们要生成一个基本的环境，是我们有东西来压缩。由于我们的项目比较小，没有太多东西可以操作。我们可以引入一个比较大的依赖，如React,这样就可以方便我们后面的操作了。

安装React:
```
npm i reat --save
```

在项目中使用：
**app/index.js**
```
leanpub-start-insert
require('react');
leanpub-end-insert

...
```
执行`npm run build`,我们可以看到以下信息：
```
> Webpack@1.0.0 build /Users/bing/Documents/workspase/Webpack/SurvivejsWebpack/webpack04-minifyingTheBuild
> webpack

Hash: be35c97f613d965955d9
Version: webpack 1.13.2
Time: 956ms
     Asset       Size  Chunks             Chunk Names
    app.js     155 kB       0  [emitted]  app
app.js.map     181 kB       0  [emitted]  app
index.html  180 bytes          [emitted]
   [0] ./app/index.js 121 bytes {0} [built]
   [1] ./app/component.js 218 bytes {0} [built]
    + 37 hidden modules
Child html-webpack-plugin for "index.html":
        + 3 hidden modules
```
155kB，太大了！压缩可以减少很大的一部分。

## 压缩代码
压缩（Minification）会是我们的代码在不改变功能的情况下变成体积更小的格式。这使用了通过预定义的转化器对代码进行重写的方式。有时，它会因为重写了部分代码而不经意的破坏代码。

最简单的代码压缩就是使用`webpack -p`。`-p`是`--optimize-minimize`的缩写，你可以认为它代表“production”。我们也可以直接使用插件（plugin）来更好的进行控制。默认的情况下，Uglify将输出很多警告而且这些警告没有太多价值，我们可以关闭警告。

首先，我们可以定义一个简单的函数来实现这个功能：
**libs/parts.js**
```
...

leanpub-start-insert
exports.minify = function() {
  return {
    plugins: [
      new webpack.optimize.UglifyJsPlugin({
        compress: {
          warnings: false
        }
      })
    ]
  };
}
leanpub-end-insert
```
并且在主配置文件中引用：
```
...

// Detect how npm is run and branch based on that
switch(process.env.npm_lifecycle_event) {
  case 'build':
    config = merge(
      common,
      {
        devtool: 'source-map'
      },
leanpub-start-insert
      parts.minify(),
leanpub-end-insert
      parts.setupCSS(PATHS.app)
    );
    break;
  default:
    ...
}

module.exports = validate(config);
}

```
现在执行`npm run build`,你看到的输出代码提交将较小很多：
```
> Webpack@1.0.0 build /Users/bing/Documents/workspase/Webpack/SurvivejsWebpack/webpack04-minifyingTheBuild
> webpack

Hash: 648ef070247f37de3b26
Version: webpack 1.13.2
Time: 1719ms
     Asset       Size  Chunks             Chunk Names
    app.js    44.8 kB       0  [emitted]  app
app.js.map     378 kB       0  [emitted]  app
index.html  180 bytes          [emitted]
   [0] ./app/index.js 121 bytes {0} [built]
   [1] ./app/component.js 218 bytes {0} [built]
    + 37 hidden modules
Child html-webpack-plugin for "index.html":
        + 3 hidden modules
```
由于需要对代码进行处理，所以打包时间较长。但最终我们得到了小的多的文件。

>Uglify warnings可以帮助我们很好的理解它是如何处理这些这些代码的。所以过段时间看看这些警告信息也有些作用。




## 通过Webpack来控制UglifyJs
 UglifyJS有一个叫做**mangling**的功能会默认开启。这个功能将会缩短局部函数的变量和名称，通常会使其变为一个字母。通过特殊配置后它也会对属性进行重写。
 由于这些转换将会破坏代码，所以需要特别小心。一个很好的例子就是Angular1和它的注入依赖系统。由于其依赖strings,所以你需要特别小心，不要压缩这些东西，以免代码无法运行。
 
 除了**mangling**，我们还在Webpack中通过***[UglifyJS features](http://lisperator.net/uglifyjs/)***初始化：
 ```
 new webpack.optimize.UglifyJsPlugin({
  // Don't beautify output (enable for neater output)
  beautify: false,

  // Eliminate comments
  comments: false,

  // Compression specific options
  compress: {
    warnings: false,

    // Drop `console` statements
    drop_console: true
  },

  // Mangling specific options
  mangle: {
    // Don't mangle $
    except: ['$'],

    // Don't care about IE8
    screw_ie8 : true,

    // Don't mangle function names
    keep_fnames: true
  }
})
```
如果开启meaning功能，最好配置`except: ['webpackJsonp']`来防止破坏Webpack的运行。

>删除`console`信息也可以通过babel的插件来实现。这个在后面的章节会详细讲解

>也可以通过***[uglify-loader](https://www.npmjs.com/package/uglify-loader)***来控制压缩操作。

## 小结
尽管我们的项目现在已经被压缩的很小了，但是我们还有更多事情要做。接下来的就是通过配置环境变量使构建时

React可以优化它自己。这个技术也可以对平时的代码进行处理。你也许希望在生产环境构建时减少一些检查来使项目变得更小。



































