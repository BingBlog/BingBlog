---
title: SurviveJs-Webpack中文翻译文档-04配置拆分.md
date: 2016-10-13 16:37:35
author: Bing
tags:
  - Webpack
  - 学习
  - SurviveJs
  - javascript
categories: []
---
在需求极少的时候，你的webpack配置文件可以维护在一个单独的文件中。当项目的需求增加，你就需要采取措施来解决这个问题。针对不同的环境将Webpack的配置文件进行拆分，变得非常必要，这样可以让你更好的控制项目的输出结果。虽然没有非常简单的处理方法，但下面的方法都还较为可行。

-将配置文件维护在多个文件中，在执行Webpack的时候用`--config`参数来指定使用那个配置文件。共同需要的配置通过模块引入。请参考*[webpack/react-starter](https://github.com/webpack/react-starter)*

-将配置信息都放到一个库里面，使用时再处理a。例如*[HenrikJoreteg/hjs-webpack](https://github.com/HenrikJoreteg/hjs-webpack)*

-将配置文件维护在一个单独的文件中，但拆分成分支。当我们用npm启动一个脚本时，npm会将脚本信息设置到一个变量中。我们可以通过这个变量来匹配对应的配置信息。

我个人喜欢最后一种方式，因为看起来很好理解。为此我开发了一个叫做`webpack-merge`的小工具。稍后我将为你展示。


## 安装webpack-merge
直接终端执行：
```
npm i webpack-merge --save-dev
```
就将webpack-merge添加到了项目中。

下一步，需要在配置文件中定义一些拆分的标示是我们可以对不同的npm启动脚本进行自定义

**webpack.config.js**
```
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
leanpub-start-insert
const merge = require('webpack-merge');
leanpub-end-insert

const PATHS = {
  app: path.join(__dirname, 'app'),
  build: path.join(__dirname, 'build')
};

leanpub-start-delete
module.exports = {
leanpub-end-delete
leanpub-start-insert
const common = {
leanpub-end-insert
  // Entry accepts a path or an object of entries.
  // We'll be using the latter form given it's
  // convenient with more complex configurations.
  entry: {
    app: PATHS.app
  },
  output: {
    path: PATHS.build,
    filename: '[name].js'
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: 'Webpack demo'
    })
  ]
};

leanpub-start-insert
var config;

// Detect how npm is run and branch based on that
switch(process.env.npm_lifecycle_event) {
  case 'build':
    config = merge(common, {});
    break;
  default:
    config = merge(common, {});
}

module.exports = config;
leanpub-end-insert

```
更改之后的输出结果和之前是一样的。现在我们有了扩展的空间。下一章我们将添加**Hot Module Replacement**来时浏览器自动刷新，并在开发模式下添加更有用的东西。

## 增加webpack-validator
为了使编写配置文件变得更简单，我们可以在项目中整合进来一个叫做*[webpack-validator](https://www.npmjs.com/package/webpack-validator)*的工具。它将通过一个规范来验证我们的配置文件，并且警告我们那些是不可取的，这样将减少学习Webpack的痛苦。

安装：
```
npm i webpack-validator --save-dev
```
在配置文件中进行如下修改：

**webpack.config.js**
```
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const merge = require('webpack-merge');
leanpub-start-insert
const validate = require('webpack-validator');
leanpub-end-insert

...

leanpub-start-delete
module.exports = config;
leanpub-end-delete
leanpub-start-insert
module.exports = validate(config);
leanpub-end-insert
```
现在，如果你的Webpack配置文件弄错了，验证器将会提示一个友好的错误信息并告诉你如何解决。

## 小结
尽管只是一个简单的技术，如此进行配置拆分后，配置文件便有了扩展空间。当然各种方法也都是互有利弊。我的这种方法用在不大的项目中比较合适。大型项目也许需要采用其它方式。

接下来的章节我们将增加自动检测执行脚本和浏览器自动刷新的功能。



























































