---
title: SurviveJs-Webpack中文翻译文档-12设置hash文件名.md
date: 2016-10-13 16:39:41
author: Bing
tags:
  - Webpack
  - 学习
  - SurviveJs
  - javascript
categories: []
---
# Adding Hashes to Filenames
Webpack使用了占位符的概念。这些占位符可以在Webpack输出时用来获取特定的信息。最常用的占位符如下：

 - [path] - 返回入口路径
 - [name] - 返回入口文件名
 - [hash] - 返回构建包的哈西值
 - [chunkhas]-返回模块特定的哈西值
 
假如我们如下配置：
```
{
  output: {
    path: PATHS.build,
    filename: '[name].[chunkhash].js',
  }
}
```
我们将会得到这样的文件名：
```
app.d587bbd6e38337f5accd.js
vendor.dc746a5db4ed650296e1.js
```
如果与模块相关的内容发生更改，hash值就会更改，这样就会使缓存无效。更准确的来说，浏览器将会对新文件发送新的请求。这就表示,如果`app`包被更新了，浏览仅会请求app的包文件。

另一个可以实现相同效果的方法就是生成静态文件名，通过在请求中增加参数(例如：app.js?d587bbd6e38337f5accd)来是缓存无效。问好后面的部分将缓存失效。这个方式并不推荐使用，根据 ***[Steve Sounders](http://www.stevesouders.com/blog/2008/08/23/revving-filenames-dont-use-querystring/)***,想文件名中增加hash数才是更好的方法。

## 使用hashing
我们已经将我们的应用拆分到`app.js`和`vendor.js`包，并且生成了一个单独的manifest文件来进行引导。稍后我们将增加hash特性，将生成类似app.d587bbd6e38337f5accd.js 和 vendor.dc746a5db4ed650296e1.js的文件。

为了实现这样的效果，我们要在配置文件中添加很重要的占位符:
**webpack.config.js**
```
...

// Detect how npm is run and branch based on that
switch(process.env.npm_lifecycle_event) {
  case 'build':
    config = merge(
      common,
      {
leanpub-start-delete
        devtool: 'source-map'
leanpub-end-delete
leanpub-start-insert
        devtool: 'source-map',
        output: {
          path: PATHS.build,
          filename: '[name].[chunkhash].js',
          // This is used for require.ensure. The setup
          // will work without but this is useful to set.
          chunkFilename: '[chunkhash].js'
        }
leanpub-end-insert
      },
      ...
    );
    break;
  default:
    ...
}

module.exports = validate(config);
```
现在执行`npm run build`，你看一看到如下输出：
```
> Webpack@1.0.0 build /Users/bing/Documents/workspase/Webpack/SurvivejsWebpack/webpack07-HashCaching
> webpack

Hash: a609450064813daf81e7
Version: webpack 1.13.2
Time: 1531ms
                               Asset       Size  Chunks             Chunk Names
         app.2571ef9e5c775581f5c4.js    4.41 kB    0, 2  [emitted]  app
      vendor.cebe3e051882068470ee.js    23.2 kB    1, 2  [emitted]  vendor
    manifest.58bdd677e3a42e68846a.js  949 bytes       2  [emitted]  manifest
     app.2571ef9e5c775581f5c4.js.map    31.2 kB    0, 2  [emitted]  app
  vendor.cebe3e051882068470ee.js.map     262 kB    1, 2  [emitted]  vendor
manifest.58bdd677e3a42e68846a.js.map     8.6 kB       2  [emitted]  manifest
                          index.html  357 bytes          [emitted]
   [0] ./app/index.js 121 bytes {0} [built]
   [0] multi vendor 28 bytes {1} [built]
   [1] ./app/component.js 218 bytes {0} [built]
    + 33 hidden modules
Child html-webpack-plugin for "index.html":
        + 3 hidden modules

```
我们的文件现在支持hash了。为了进行验证，可以修改app/index.js，增加一个console.log()代码。在构建后，应该只有与之相关的`app`和`manifest`文件发生更改。

一个更好的改进就是通过cdn来加载常用的依赖，例如React。这样通过增加额外的项目依赖将进一步减少vendor包的大小。这是因为，如果用户之前命中过CDN,缓存将直接从本地读取。

## 小结
尽管我们的项目已经构建了缓存，增加了hash文件名却会带来新的问题。如果一个文件发生了更改，旧的文件依然存在于我们的输出文件夹。为了解决这个问题，我们可以增加一个小小的插件，来清除旧文件。



























