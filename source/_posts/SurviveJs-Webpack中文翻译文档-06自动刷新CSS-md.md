---
title: SurviveJs-Webpack中文翻译文档-06自动刷新CSS.md
date: 2016-10-13 16:38:29
author: Bing
tags:
  - Webpack
  - 学习
  - SurviveJs
  - javascript
categories: []
---

# Refreshing CSS
本章我们将在项目中增加CSS并在我们更改CSS文件后使浏览器自动刷新。更加轻巧的是Webpack被没有完全强制刷新。我们将看到，Webpack对此采用的更机智的方法。

## 加载CSS
为了引入CSS，我么需要安装一些加载器(loaders)。终端输入：
```
npm i css-loader style-loader --save-dev
```
我们已经安装了所需要的loaders。现在将在Webpack中来配置这些loaders。如下配置：
**libs/parts.js**
```
...

leanpub-start-insert
exports.setupCSS = function(paths) {
  return {
    module: {
      loaders: [
        {
          test: /\.css$/,
          loaders: ['style', 'css'],
          include: paths
        }
      ]
    }
  };
}
leanpub-end-insert
```
接下来我们将在主配置文件中引入CSS的配置
**webpack.config.js**
```
...

switch(process.env.npm_lifecycle_event) {
  case 'build':
leanpub-start-delete
    config = merge(common, {});
leanpub-end-delete
leanpub-start-insert
    config = merge(
      common,
      parts.setupCSS(PATHS.app)
    );
leanpub-end-insert
    break;
  default:
    config = merge(
      common,
leanpub-start-insert
      parts.setupCSS(PATHS.app),
leanpub-end-insert
      ...
    );
}

module.exports = validate(config);
```
配置中`test: /\.css$/`表示以`.css`结尾的文件将触发我们配置的加载器。`test`通过Javascript正则表达式来匹配从右到左执行的loaders。

在当前情况下，css-loader首先执行，然后是style-loader。css-loader会先处理css文件中的`@import`和`url`语句。style-loader将会处理JavaScript文件中的`require`语句。这就像Sass和Less的预处理器一样，不过二者有自己的loader。

T>loaders应用到各类资源文件后会对这些文件进行转化，然后返回新的资源。loaders可以像unix系统中的管道那样链式执行。关于loaders详见***[What are loaders?](http://webpack.github.io/docs/using-loaders.html)*** 和 ***[list of loaders](http://webpack.github.io/docs/list-of-loaders.html)***。

W>如果`include`没有设置，Webpack将对更目录下的所有文件进行处理。太伤性能（li）了！因此，建议总是设置include。`include`也可以手动设置来配置执行目录。但我还是喜欢用`include`。

## 搞些初始化的CSS样式
现在，我们还缺好具体的CSS样式
**app/main.css**
```
body {
  background: cornsilk;
}
```
然后，让Webpack可以处理这个文件。使用`require`引入：
**app/index.js**
```
leanpub-start-insert
require('./main.css');
leanpub-end-insert

...
```
执行`npm start`，访问`localhost:8080`。

页面显示后，再打开`main.css`,然后修改背景颜色。你会发现，浏览没有刷新但显示出来的样式却发生变化。我们可以稍微分析下。

打开浏览开发者工具，选择**Network**,清空信息后我们将颜色改为`red`。然后发现浏览器有两个新的网络请求：
```
e59f32cbca2dc3d3204f.hot-update.json	200	xhr	app.js:26	282 B
0.e59f32cbca2dc3d3204f.hot-update.js    200	script	app.js:15
```
**.json**
```
{"h":"52c6f25d568fa2254f97","c":[0]}
```
**.hot-update.js**
```
webpackHotUpdate(0,{

/***/ 80:
/***/ function(module, exports, __webpack_require__) {

	exports = module.exports = __webpack_require__(81)();
	// imports


	// module
	exports.push([module.id, "body{\n    background:red;\n}", ""]);

	// exports


/***/ }

})
```
我们发现浏览器中更新的网络请求仅仅是一些碎片信息，而没有完整的文件，我们可以大胆的想象Webpack在检测到CSS的修改后，仅将修改的部分以JavaScript碎片的形式push到的浏览器中，并使其在浏览器中执行，进而改变了页面的背景颜色。

>加载CSS还有其它方法，比如定一个单独的入口文件。

## 理解CSS区块和CSS模块
当你`require`一个CSS文件，Webpack将会在打包后的文件中包含其中的信息。如果你用的是style-loader,Webpack将会将它写到`style｀标记的地方。这样的话，该部分样式就会默认是全局的！

可以利用 ***[CSS Modules](https://github.com/css-modules/css-modules)***可以让其成为局部的区块。而起Webpack的css-loader的也支持它。如果你想在全局中包含局部的样式，可以通过`css?module`来实现。之后需要将全局样式用:global(body){...}这样来申明。

T>匹配语法,`css?modules`将会在**定义加载其(Loader Definitions)**章节详细讲解。在webpack中用很多中实现这样效果的方法。

这样你就可以用 `require`语法将提供给你局部样式类，你可以将它们应用的具体的html元素上。假设我们的样式如下：
**app/main.css**
```
:local(.redButton){
 background:red;
}
```
让后我么可以在组建中这样使用：
**app/component.js**
```
var styles = require('./main.css');

...

// Attach the generated class name
element.className = styles.redButton;
```
尽管这样工作起来感觉很奇怪，但默认让样式成为局部区块会在处理css时减少很多痛苦。之后我们在这个小项目中国年仍将使用老技术，但这个技术了解下也很很有必要的。

## 小结
本章，学习了如何构建一个在开发中可自动刷新的Webpack服务。下一章，我们将学习一个叫做sourcemaps的利器


































