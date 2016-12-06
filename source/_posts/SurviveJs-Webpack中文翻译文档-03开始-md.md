---
title: SurviveJs-Webpack中文翻译文档-03开始.md
date: 2016-10-13 16:36:03
author: Bing
tags:
  - Webpack
  - 学习
  - SurviveJs
  - javascript
categories: []
---

## 开始！
首先确认你实用的是当前的Node.js版本。推荐至少使用最近的长期支持的版本。请终端应该能使用确保node和npm命令。

完整的配置文件请参考*[Github](https://github.com/survivejs-demos/webpack-demo)*。在学习时可以作为参考。

>也可以使用Vagrant或者nvm来创建一个更可控的环境。Vagrant基于虚拟机，会造成性能下降。Vagrant在团队环境中特别有用，它可以给你一个可预见的环境来进行开发。


>老版本的Node.js会有很多问题，需要一些额外处理，不建议使用。

## 设置项目
开始之前，创建一个项目文件夹，并生成一个pakage.json文件。npm会使用这个文件来管理项目依赖。命令如下：
```
mkdir Webpack
cd Webpack
npm init -y # -y generates *package.json*, skip for more control
```
终端显示：
```
{
  "name": "Webpack",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "webpack": "^1.13.2"
  }
}

```
你也可以手动创建pakage.json文件，并做自己的更改。我们也将通过npm工具对其进行修改，但是手动更改是可以的。*[官方文档](https://docs.npmjs.com/files/package.json)*详细描述了各类pakage.json文件的选项。

>You can set those npm init defaults at ~/.npmrc.


## 安装Webpack
虽然Webpack可以全局安装（`npm install -g`）,但还是建议作为一个单独的依赖维护在项目中。这样将避免后期你将使用其它版本的Webpack是所引起的不兼容。

这种方式在**持续集成－Continuous Integration (CI)**配置中也很好用。持续集成系统可以安装本地依赖，使用依赖编译项目，然后将结果更新到服务器。

使用如下命令来安装Webpack到我们的项目中：
```
npm i webpack --save-dev # or just -D if you want to save typing
```
安装技术后你将在你的pakage.json文件中的`devDependencies`里面看到Webpack的版本信息。除了将模块包安装到了node_modules文件夹中，npm也创建了一个可执行程序。

## 执行Webpack
在终端中输入：
```
npm bin
```
终端展示如下：
```
/Users/bing/Documents/workspase/Webpack/node_modules/.bin
```
其中Webpack是项目文件，node_modules/.bin是执行文件路径。通过这个命令可以执行Webpack:
```
node_modules/.bin/webpack 
```
终端输出：
```
webpack 1.13.2
Usage: https://webpack.github.io/docs/cli.html

Options:
  --help, -h, -?      
  --config     
  --context       
  --entry 
  --module-bind
  --module-bind-post
  --module-bind-pre
  --output-path                                                                  
  --output-file      
  --output-chunk-file              
```
>使用`--save`和`--save-dev`将应用依赖和开发依赖分开。前者将信息写在pakage.json文件中的`dependencies`中，后者写在`devDependencies`中。


## 目录结构
作为一个项目仅有一个孤零零的pakage.json文件是不行的，我们需要创建一些更具体的东西。现在，我们开始实现一个小小的web网站并加载一些JavaScript，而且我们将用Webpack来对这些文件进行构建。现在开始按照一些结构创建一个项目文件：

-app/
--index.js
--component.js
-build/
-package.json
-webpack.config.js

我们的想法就是将app/中的文件通过转换后输出到build/。接下来，我们开始编写代码和配置最关键的webpack.config.js。

## 编写资源代码
就像你从来不会对`hello word`厌烦，我们也将实现一个类似的东西。如下创建一个组建：
**app/component.js**

```
module.exports = function () {
  var element = document.createElement('h1');

  element.innerHTML = 'Hello world';

  return element;
};
```
再创建一个应用的入口文件并加载我们之前创建的component组建同时渲染到DOM中。

**app/index.js**

```
var component = require('./component');

document.body.appendChild(component());
```

## 编写Webpack配置文件
我们需要告诉webpack如何处理我们之前创建的文件。因此，我们要编写一个webpack.config.js文件。Webpack及其开发服务将会根据惯例找到该配置文件。

为了更好的维护项目，我们将使用*[html-webpack-plugin](https://www.npmjs.com/package/html-webpack-plugin)来为应用生成一个index.html文件。html-webpack-plugin将该文件同之前的文件连接起来。安装命令：
```
npm i html-webpack-plugin --save-dev
```
下面是用来配置插件和在build文件夹中生成bundle文件的webpack配置文件：
**webpack.config.js**
```
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

const PATHS = {
  app: path.join(__dirname, 'app'),
  build: path.join(__dirname, 'build')
};

module.exports = {
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
```

`entry`路径可以设置成相对路径。官方文档中的[*context*](https://webpack.github.io/docs/configuration.html#context)（上下文）段落可用来配置查找。由于很多地方需要使用绝对定位路径，我也喜欢都在任何地方用绝对路径来避免懵掉。

在终端执行:
```
https://webpack.github.io/docs/configuration.html#context
```
将会看到：

```
Hash: 87c1e5f935ae062f6501
Version: webpack 1.13.2
Time: 510ms
     Asset       Size  Chunks             Chunk Names
    app.js    1.69 kB       0  [emitted]  app
index.html  180 bytes          [emitted]  
   [0] ./app/index.js 80 bytes {0} [built]
   [1] ./app/component.js 140 bytes {0} [built]
Child html-webpack-plugin for "index.html":
        + 3 hidden modules
```

输出信息很多：
-`Hash: 87c1e5f935ae062f6501`-本次build构建的hash值。你可以通过`[hash]`占位符来废弃资源文件。我们将在**向文件名中添加hash(Adding Hashes to Filenames)**章节来详细讲解。
-`Version: webpack 1.13.2`-Webpack版本
-`Time: 510ms`执行构建的时间
-`app.js    1.69 kB       0  [emitted]  app`-资源文件名，大小，关联的模块ID，状态信息标示资源如何生成，模块名称。
-`[0] ./app/index.js 80 bytes {0} [built]`-生成文件的id，名称，大小，入口模块ID，生成方式
-`Child html-webpack-plugin for"index.html":`-插件相关的输出信息。html-webpack-plugin生成了index.html
-`+ 3 hidden modules`Webpack隐藏了一些信息，也就是一些模块信息和路径。在终端输入`node_modules/.bin/webpack --display-modules`将会展示这些信息。点击查看*[更多解释](https://stackoverflow.com/questions/28858176/what-does-webpack-mean-by-xx-hidden-modules)*。

>Webpack hides modules coming from folders like `["node_modules", "bower_components", "jam", "components"]` in your console output by default. This helps you to focus on your modules instead on your dependencies.
You can display them by using the `--display-modules` argument.

查看`build`目录下的输出。如果瞧仔细了，你会看见和输入信息中ID相同的资源。在浏览器中直接打开`build/index.html`文件，在mac中可直接输入`open ./build/index.html `.你将在浏览器看到输出的hello world。

>使用一个类似于server的工具来将`build`目录添加都服务端将很方便，可以使用`npm i serve -g`来安装这个工具，然后在输出文件夹中输入`server`,之后浏览器访问`localhost:3000'。可以使用`--port`参数指定端口。


>个人比较喜欢使用`path.join`，但是`path.resolve`也是一个不错测选择。具体请查看 *[Node.js path API](https://nodejs.org/api/path.html)*,两者作用如下,官方解释还请看文档。
**path.join**
```
path.join('/foo', 'bar', 'baz/asdf', 'quux', '..')
// returns '/foo/bar/baz/asdf'

path.join('foo', {}, 'bar')
// throws TypeError: Arguments to path.join must be string
```
**strong text**
```
path.resolve('/foo/bar', './baz')
// returns '/foo/bar/baz'

path.resolve('/foo/bar', '/tmp/file/')
// returns '/tmp/file'

path.resolve('wwwroot', 'static_files/png/', '../gif/image.gif')
// if the current working directory is /home/myself/node,
// this returns '/home/myself/node/wwwroot/static_files/gif/image.gif'
```

>*[favicons-webpack-plugin](https://www.npmjs.com/package/favicons-webpack-plugin)*可以让webpack很方便的处理网站图标,而且可以和*html-webpack-plugin*结合使用。


## 添加打包命令缩写
由于执行node_modules/.bin/webpack输入太多，我们可以在pakage.json中配置命令。如下：
**pakage.json**
```
"scripts": {
  "build": "webpack"
},
```
现在我们可以使用npm run 来启动脚本。例如，我们在终端输入：
```
npm run build
```
你将看到和之前一样的结果。

由于`npm`将`node_modules/.bin`临时的添加到了执行目录。所以我们不用写`"build": "node_modules/.bin/webpack"`，仅配置`"build": "webpack"`就够了。

>也有一些缩写，如 npm start 和 npm test。这些简写不需要输入 npm run

>在项目的任意地方都可以执行npm run而不仅限于项目的根目录。

## 小结
现在我们已经搭建了一个Webpack的基本应用，但这远远不够。用这样的构建来开发仍然比较痛苦。每次我们更改了应用，都需要手动输入`npm run build`,然后刷新浏览器。

稍后我们将介绍Webpack用来解决以上问题的更先进的特性。同时由于这些特性需要特定的环境，我将在下一章向你展示如何将Webpack的配置文件进行分离。

