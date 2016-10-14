---
title: SurviveJs-Webpack中文翻译文档-10设置环境变量.md
date: 2016-10-13 16:39:12
author: Bing
tags:
  - Webpack
  - 学习
  - SurviveJs
  - javascript
categories: []
---
# Setting Environment Variables

React优化依赖`process.env.NODE_ENV`变量。如果我们强制该变量为`production`，React将采取更优化的构建行为。这样会失去一些检查，如属性类型检查。但重要的是，这样将会是我们的项目变得更小更有效率。

## definePlugin的基本概念
Webpack提供了DefinePlugin。它可以使我们重写**自由变量**。
>自由变量：在A作用域中使用的变量x，却没有在A作用域中声明（即在其他作用域中声明的），对于A作用域来说，x就是一个自由变量
DefinePlugin让我们可以创建全局的常数，在编译时这些常数将被设置。这在开发或者生产等不同的构建中非常有用。例如，你可能需要一个全局常数来决定在哪里输出打印日志信息；但是你希望你的日志信息在开发环境中输出，而在生产环境中不会输出。这只是DefinePlugin功能的一种设想。例如：
```
new webpack.DefinePlugin({
    PRODUCTION: JSON.stringify(true),
    VERSION: JSON.stringify("5fa3b9"),
    BROWSER_SUPPORTS_HTML5: true,
    TWO: "1+1",
    "typeof window": JSON.stringify("object")
})
```
我们通过上面的配置后，希望如下可以打印出构建的版本信息

```
console.log("Running App version " + VERSION);
if(!BROWSER_SUPPORTS_HTML5) require("html5shiv");
```
这些设定的值将会被配置到代码中，并且在对代码压缩处理时会更具条件去除冗余的代码。
例如：
```
if (!PRODUCTION)
    console.log('Debug info')
if (PRODUCTION)
    console.log('Production log')
```
如果Webpack没有配置代码压缩，最终的代码会是：
```
if (!true)
    console.log('Debug info')
if (true)
    console.log('Production log')
```
如果Webpack配置了代码压缩，最终的代码会是：
```
console.log('Production log')
```
上面介绍的就是DefinePlugin的原理，我们在配置中也可以这样来控制我们的代码。

## 设置process.env.NODE_ENV
为了更好的理解这个概念，在我们的项目代码中可以如此声明：`if(process.env.NODE_ENV === 'development')`。使用`DefinePlugin`我门可以用`development`来替换`process.env.NODE_ENV`，然后让我们的代码语句变得很简单。

和之前一样，我们可以将这个想法写成一个函数：
**libs/parts.js**
```
...

leanpub-start-insert
exports.setFreeVariable = function(key, value) {
  const env = {};
  env[key] = JSON.stringify(value);

  return {
    plugins: [
      new webpack.DefinePlugin(env)
    ]
  };
}
leanpub-end-insert
```
然后在主配置文件中：
**webpack.config.js**
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
      parts.setFreeVariable(
        'process.env.NODE_ENV',
        'production'
      ),
leanpub-end-insert
      parts.minify(),
      parts.setupCSS(PATHS.app)
    );
    break;
  default:
    ...
}

module.exports = validate(config);
```
执行`npm run build`，会发现明显的进步：
```
> Webpack@1.0.0 build /Users/bing/Documents/workspase/Webpack/SurvivejsWebpack/webpack05-EnvVariables
> webpack

Hash: 139e0b775e45d80b20af
Version: webpack 1.13.2
Time: 1472ms
     Asset       Size  Chunks             Chunk Names
    app.js    27.7 kB       0  [emitted]  app
app.js.map     296 kB       0  [emitted]  app
index.html  180 bytes          [emitted]
   [0] ./app/index.js 121 bytes {0} [built]
   [1] ./app/component.js 218 bytes {0} [built]
    + 33 hidden modules
Child html-webpack-plugin for "index.html":
        + 3 hidden modules
```
所以，我们的构建从之前的155kB,到44kB,再到27kB。最终的版本将会比之前的更快一些。由于27kB可以处理成gzip，而gzip还能在缩小40%左右。它将很好的支持浏览器。
>***[babel-plugin-transform-inline-environment-variables](https://www.npmjs.com/package/babel-plugin-transform-inline-environment-variables)***Babel插件也可以实现这个功能。详见***[官方文档](https://babeljs.io/docs/plugins/transform-inline-environment-variables/)***

>请注意我们的项目中遗漏了react-dom。在实际的项目中，应用将会很大，除非我们使用轻量级的版本如`***[preact](https://www.npmjs.com/package/preact)***`或者`***[react-lite](https://www.npmjs.com/package/react-lite)***`这些框架也许会丢失一些特性，但是如果你使用react，应该要了解。

## 小结
尽管如此使用`process.env.NODE_ENV`在使用react的时候左右尤其明显。但是，我们可以做的更好。我们可以拆分`app`和`bundle`,然后给他们的文件名增加hass值，使浏览器可以更好的进行缓存。毕竟，数据不需要加载才是最快的。















































