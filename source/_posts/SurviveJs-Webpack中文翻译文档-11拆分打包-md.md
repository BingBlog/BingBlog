---
title: SurviveJs-Webpack中文翻译文档-11拆分打包.md
date: 2016-10-13 16:39:21
author: Bing
tags:
  - Webpack
  - 学习
  - SurviveJs
  - javascript
categories: []
---
# Splitting Bundles
目前我们应用的生产版本仅仅包含Javascript文件。这不是理想的。如我我们改变了应用，客户端还需要加载依赖。最好只需要加载改变的部分。如果依赖发生了改变，客户端仅需要加载依赖就行了。在实际生产中代码就该如此。

这就是代码拆分（bundle splitting）。我们可以将支持依赖打包为单独的文件，以利于客户端缓存。由于整个应用的大小没有改变。即使请求的数量会变多，但是缓存的好处足以弥补多请求带来的损失。

比如，相比于一个单独的app.js(100kB),我们可以处理成app(10kB)vendor.js(90kB)。现在如果一个用户已经使用过该应用，那么效率将会更高。

缓存会带来新的问题。我们将在下一章节来讲解。现在我们要对代码进行拆分。

## 配置一个`vendor`包
我们的应用目前仅有一个单独的入口文件`app`。你也许还记得，我们的配置文件告诉Webpack的依赖依次从`app`入口文件开始处理，然后将文件以入口文件名称命名并以`.js`结尾输出到`build`出口文件中。

为了进步改善，我们定义一个包含react的`vendor`入口。这是通过匹配依赖的名称来实现的。我们可以想本节后面讨论的那样来自动生成这些信息，但现在我想通过添加一个静态的数组来更好的描述这个想法。如下更改代码：

```
...

const common = {
  // Entry accepts a path or an object of entries.
  // We'll be using the latter form given it's
  // convenient with more complex configurations.
  entry: {
leanpub-start-insert
    app: PATHS.app,
    vendor: ['react']
leanpub-end-insert
leanpub-start-delete
    app: PATHS.app
leanpub-end-delete
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

...
```
我们现在有两个分离的入口，后者叫做**entry chunks**。**Understanding Chunks**章节将会深入讲解其它的模块类型。现在我们有了一个入口和出口的映射配置。`[name].js`将以入口文件的名称自动生成出口文件的名称。然后执行，`npm run build`,你将看到如下结果：
```
> Webpack@1.0.0 build /Users/bing/Documents/workspase/Webpack/SurvivejsWebpack/webpack06-Splitting
> webpack

Hash: 0653dc1114687102bdc1
Version: webpack 1.13.2
Time: 1825ms
        Asset       Size  Chunks             Chunk Names
       app.js    27.7 kB       0  [emitted]  app
    vendor.js    23.4 kB       1  [emitted]  vendor
   app.js.map     296 kB       0  [emitted]  app
vendor.js.map     265 kB       1  [emitted]  vendor
   index.html  236 bytes          [emitted]
   [0] ./app/index.js 121 bytes {0} [built]
   [0] multi vendor 28 bytes {1} [built]
   [1] ./app/component.js 218 bytes {0} [built]
    + 33 hidden modules
Child html-webpack-plugin for "index.html":
        + 3 hidden modules
```
app.js和vendor.js分离开了。现在的输出还是比较大，显然，app.js应该明显的变小才能实现我们的目标。

如果你查看最终生成的包，通过它包含的React可以发现默认的工作原理。

我们可以用Webpack的一个叫做`CommonsChunkPlugin`插件的插件来实现我们所期望的包分离。

## 构建CommonsChunkPlugin
***[CommonsChunkPlugin](https://webpack.github.io/docs/list-of-plugins.html#commonschunkplugin)***是一个很强大也很复杂的插件。我们要学习的是一个很基本也很有用的例子。首先我们可以构建一个函数。

为了今后更加方便，我们可以生成一个叫做**manifest**的文件。它包含了webpack用来启动应用的运行脚本和所有它需要的依赖。浙江可以避免严重的失效问题。尽管它需要浏览器多加载一个文件，它也可以使我们引入下一章会学习的可靠的缓存机制。

如果我们不生成一个manifest文件，Webpack会在vendor包中生成运行脚本。当我们更改了应用的代码，应用包的哈西值将会更改。而此时，vendor包也会接受一个新的哈西值。这就是为什么我们要将manifest文件单独存放。

>在下一章学习时，如果你想实际操作以下，你可以去掉使其不生成manifest文件。更改代码后，你将会发现应用的包发生的变化。
**libs/parts.js**
```
...

leanpub-start-insert
exports.extractBundle = function(options) {
  const entry = {};
  entry[options.name] = options.entries;

  return {
    // Define an entry point needed for splitting.
    entry: entry,
    plugins: [
      // Extract bundle and manifest files. Manifest is
      // needed for reliable caching.
      new webpack.optimize.CommonsChunkPlugin({
        names: [options.name, 'manifest']
      })
    ]
  };
}
leanpub-end-insert
```
由于上面的函数包含了入口信息，所以我们要删掉之前配置的vendor入口。
**webpack.config.js**
```
...

const common = {
  // Entry accepts a path or an object of entries.
  // We'll be using the latter form given it's
  // convenient with more complex configurations.
  entry: {
leanpub-start-insert
    app: PATHS.app
leanpub-end-insert
leanpub-start-delete
    app: PATHS.app,
    vendor: ['react']
leanpub-end-delete
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

...

// Detect how npm is run and branch based on that
switch(process.env.npm_lifecycle_event) {
  case 'build':
    config = merge(
      common,
      {
        devtool: 'source-map'
      },
      parts.setFreeVariable(
        'process.env.NODE_ENV',
        'production'
      ),
leanpub-start-insert
      parts.extractBundle({
        name: 'vendor',
        entries: ['react']
      }),
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
如果现在执行 `npm run build`,你可以发现：
```
> Webpack@1.0.0 build /Users/bing/Documents/workspase/Webpack/SurvivejsWebpack/webpack06-Splitting
> webpack

Hash: 11284db48d6483090d79
Version: webpack 1.13.2
Time: 1492ms
          Asset       Size  Chunks             Chunk Names
         app.js    4.39 kB    0, 2  [emitted]  app
      vendor.js    23.1 kB    1, 2  [emitted]  vendor
    manifest.js  954 bytes       2  [emitted]  manifest
     app.js.map    31.1 kB    0, 2  [emitted]  app
  vendor.js.map     262 kB    1, 2  [emitted]  vendor
manifest.js.map    8.73 kB       2  [emitted]  manifest
     index.html  294 bytes          [emitted]
   [0] ./app/index.js 121 bytes {0} [built]
   [0] multi vendor 28 bytes {1} [built]
   [1] ./app/component.js 218 bytes {0} [built]
    + 33 hidden modules
Child html-webpack-plugin for "index.html":
        + 3 hidden modules
```
现在就实现了我们的目标。
>除此之外，我们可以定义模块动态加载。这需要通过 require.ensure来实现。我们将在***Understanding Chunks***章节详细讲解。


## 自动加载`dependencies`到`vendor`包

如果你的依赖是按照`dependencies`和`devDependencies`来严格区分的，你可以使Webpack来通过`dependencies`字段信息来自动将依赖大包到`vendor`目录中。可参考：
```
...

const pkg = require('./package.json');

...

const common = {
  entry: {
    app: PATHS.app,
    vendor: Object.keys(pkg.dependencies)
  },
  ...
}

...
```
也可以仅将特定的依赖打包到`vendor`目录，仅仅需要多添加一些代码。也可以使用`filter`来去掉你不想打报道`vendor｀的代码。

## 小结
现在情况要好多了。请注意`app`包要比`vendor`包小的多。为了更好的利用包分离，我们可以进行缓存构建。这可以通过增加缓存哈西数来实现。


















































