---
title: SurviveJs-Webpack中文翻译文档-14CSS拆分.md
date: 2016-10-13 16:39:59
author: Bing
tags:
  - Webpack
  - 学习
  - SurviveJs
  - javascript
categories: []
---
# Separating CSS
现在我们个开发构建看起来已经很不错了，但是，我们的CSS文件都到哪里去了？根据我们的配置，CSS都被内联到JavaScript文件中了！尽管在开发时，这并没有什么问题，但是这看起来并不是个好事儿。当前的方案并不能使我们缓存CSS。在一些情况下，我们可能会遭遇Flash of Unstyled Content (FOUC)。

碰巧的是Webpack给我们提供了生成CSS包的方法。我们可以使用***[ExtractTextPlugin](https://www.npmjs.com/package/extract-text-webpack-plugin)***来实现CSS包分离。它将在编译之前进行处理，并且不支持热加载。但我们仅在生产环境中使用，也没什么影响。

>该技术还可以用来处理其它资源，如模版文件。

>使用内联在JavaScript代码中的CSS样式比较危险，就相当于矢量攻击。赞成使用ExtractTextPlugin或者类似的解决方案。

## 使用***extract-text-webpack-plugin***
先安装依赖：
```
npm i extract-text-webpack-plugin --save-dev
```
该插件分两部分运转。首先又一个loader,`ExtractTextPlugin.extract`，标记要被取出来的文件。该插件将在此基础上进行标注工作。例如：
**libs/parts.js**
```
const webpack = require('webpack');
const CleanWebpackPlugin = require('clean-webpack-plugin');
leanpub-start-insert
const ExtractTextPlugin = require('extract-text-webpack-plugin');
leanpub-end-insert

...

leanpub-start-insert
exports.extractCSS = function(paths) {
  return {
    module: {
      loaders: [
        // Extract CSS during build
        {
          test: /\.css$/,
          loader: ExtractTextPlugin.extract('style', 'css'),
          include: paths
        }
      ]
    },
    plugins: [
      // Output extracted CSS to a file
      new ExtractTextPlugin('[name].[chunkhash].css')
    ]
  };
}
leanpub-end-insert
```
主配置文件修改：
**webpack.config.js**
```
...

// Detect how npm is run and branch based on that
switch(process.env.npm_lifecycle_event) {
  case 'build':
    config = merge(
      ...
      parts.minify(),
leanpub-start-insert
      parts.extractCSS(PATHS.app)
leanpub-end-insert
leanpub-start-delete
      parts.setupCSS(PATHS.app)
leanpub-end-delete
    );
    break;
  default:
    config = merge(
      ...
    );
}

module.exports = validate(config);
```
这样处理后，在开发时，我们仍可以使用热加载。在生产打包中，我们声称了一个单独的CSS文件，而且，*html-webpack-plugin*将自动将该文件注入到`index.html`中。

>在定义时，使用`loaders: [ExtractTextPlugin.extract('style', 'css')]`不起效，而起会造成错误！所以当使用`ExtractTextPlugin`时，使用`loader`语法来代替。

>如果希望`ExtractTextPlugin`加载更多loader,可以使用`!`，例如：`ExtractTextPlugin.extract('style', 'css!postcss')`。


现在运行 `npm run build`,将看到如下信息：
```
> Webpack@1.0.0 build /Users/bing/Documents/workspase/Webpack/SurvivejsWebpack/webpack09-SeparatingCSS
> webpack

clean-webpack-plugin: /Users/bing/Documents/workspase/Webpack/SurvivejsWebpack/webpack09-SeparatingCSS/build has been removed.
Hash: 10c04a03298eb4f6acb9
Version: webpack 1.13.2
Time: 1524ms
                               Asset       Size  Chunks             Chunk Names
         app.ce544f41fa6ccea5a5e3.js  351 bytes    0, 2  [emitted]  app
      vendor.cebe3e051882068470ee.js    23.2 kB    1, 2  [emitted]  vendor
    manifest.58bdd677e3a42e68846a.js  949 bytes       2  [emitted]  manifest
        app.ce544f41fa6ccea5a5e3.css   97 bytes    0, 2  [emitted]  app
     app.ce544f41fa6ccea5a5e3.js.map    2.34 kB    0, 2  [emitted]  app
    app.ce544f41fa6ccea5a5e3.css.map  105 bytes    0, 2  [emitted]  app
  vendor.cebe3e051882068470ee.js.map     262 kB    1, 2  [emitted]  vendor
manifest.58bdd677e3a42e68846a.js.map     8.6 kB       2  [emitted]  manifest
                          index.html  416 bytes          [emitted]
   [0] ./app/index.js 123 bytes {0} [built]
   [0] multi vendor 28 bytes {1} [built]
   [1] ./app/component.js 218 bytes {0} [built]
    + 33 hidden modules
Child html-webpack-plugin for "index.html":
        + 3 hidden modules
Child extract-text-webpack-plugin:
        + 2 hidden modules
```

>如果发生了*`Module build failed: CssSyntaxError:`*请确认`common`配置项中没有包含有关css的设置。

现在我们将css文件单独打包到一个文件中。这也使的我们的JavaScript包文件变得很小。我们同样避免了FOUC的问题，以为浏览器不用等待JavaScript加载完了再从中获取样式信息。同时，它可以单独处理css文件因而避免了样式闪烁的问题。

>如果你的项目很复杂，有很多依赖，使用`DedupePlugin`是一个很好的选择。它可以找到重复的文件然后删除重复的数据。使用`new webpack.optimize.DedupePlugin()`可以定义开启它。请记住在生产环境中使用。

## 拆分应用的JavaScript代码和CSS代码
一个符合逻辑的处理方式是将应用的JavaScript代码和样式代码用不同的入口文件来拆分。这样将去掉它们之间的依赖而且可以解决缓存问题。为了实现这个想法我们需要将样式从当前的模块中拆分出来让，然后在配置中为它新增一个自定义的模块：
**app/index.js**
```
require('react');

leanpub-start-delete
require('./main.css');
leanpub-end-delete

...
```
删除了样式的引入语句，我们需要定义一个新的入口
**webpack.config.js**
```
...

const PATHS = {
  app: path.join(__dirname, 'app'),
leanpub-start-insert
  style: path.join(__dirname, 'app', 'main.css'),
leanpub-end-insert
  build: path.join(__dirname, 'build')
};

const common = {
  // Entry accepts a path or an object of entries.
  // We'll be using the latter form given it's
  // convenient with more complex configurations.
  entry: {
leanpub-start-insert
    style: PATHS.style,
leanpub-end-insert
    app: PATHS.app
  },
  ...
};

// Detect how npm is run and branch based on that
switch(process.env.npm_lifecycle_event) {
  case 'build':
    config = merge(
      ...
      parts.minify(),
leanpub-start-insert
      parts.extractCSS(PATHS.style)
leanpub-end-insert
leanpub-start-delete
      parts.extractCSS(PATHS.app)
leanpub-end-delete
    );
    break;
  default:
    config = merge(
      ...
leanpub-start-insert
      parts.setupCSS(PATHS.style),
leanpub-end-insert
leanpub-start-delete
      parts.setupCSS(PATHS.app),
leanpub-end-delete
      parts.devServer({
        // Customize host/port here if needed
        host: process.env.HOST,
        port: process.env.PORT
      })
    );
}

module.exports = validate(config);
```
现在执行`npm run build`,你将会看到：
```
> Webpack@1.0.0 build /Users/bing/Documents/workspase/Webpack/SurvivejsWebpack/webpack09-SeparatingCSS
> webpack

clean-webpack-plugin: /Users/bing/Documents/workspase/Webpack/SurvivejsWebpack/webpack09-SeparatingCSS/build has been removed.
Hash: 3f01505a5156fb3c17b3
Version: webpack 1.13.2
Time: 1520ms
                               Asset       Size  Chunks             Chunk Names
     app.79ad79eb1d8f9fd9f3a2.js.map    1.55 kB    0, 3  [emitted]  app
         app.79ad79eb1d8f9fd9f3a2.js  246 bytes    0, 3  [emitted]  app
      vendor.cc2ddbcffa7968ff3274.js    23.1 kB    2, 3  [emitted]  vendor
    manifest.927dc801a1b2cec0a16f.js  949 bytes       3  [emitted]  manifest
      style.849465d87dececcd5592.css   85 bytes    1, 3  [emitted]  style
       style.849465d87dececcd5592.js   93 bytes    1, 3  [emitted]  style
   style.849465d87dececcd5592.js.map  430 bytes    1, 3  [emitted]  style
  style.849465d87dececcd5592.css.map  107 bytes    1, 3  [emitted]  style
  vendor.cc2ddbcffa7968ff3274.js.map     262 kB    2, 3  [emitted]  vendor
manifest.927dc801a1b2cec0a16f.js.map     8.6 kB       3  [emitted]  manifest
                          index.html  494 bytes          [emitted]
   [0] ./app/index.js 100 bytes {0} [built]
   [0] multi vendor 28 bytes {2} [built]
   [1] ./app/component.js 141 bytes {0} [built]
    + 33 hidden modules
Child html-webpack-plugin for "index.html":
        + 3 hidden modules
Child extract-text-webpack-plugin:
        + 2 hidden modules
```
这样，我们就可以单独管理从JavaScript中拆出来的样式了。现在更改样式文件就不会影响JavaScript代码的hash值了。但是这种处理方式会造成一个问题。

如果你瞧仔细了，你会在输出目录中看到一个叫做`style.e5eae09a78b3efd50e73.js`的文件。你的这个文件可能hash值不一样，因为它是由Webpack生成的，而它的内容如下：
```
webpackJsonp([1,3],[function(n,c){}]);
```
从技术上来讲这是多余的。通过*HtmlWebpackPlugin*的检查来排除这个文件将是安全的。但是对于我们当前的项目来说却非常好。理想状态下Webpack不应该生成这个文件，详细的可以参考这个与之*[相关的问题](https://github.com/webpack/webpack/issues/1967)*

>将来，我们将通过`[contenthash]`占位符。他将会通过文件的内容来生成hash值。

























