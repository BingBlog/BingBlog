---
title: SurviveJs-Webpack中文翻译文档-13包清理.md
date: 2016-10-13 16:39:52
author: Bing
tags:
  - Webpack
  - 学习
  - SurviveJs
  - javascript
categories: []
---
# Cleaning the Build
当前我们的应用不能在重新大包时删掉`build`目录下老的文件。我们将增加一个插件来清除build目录。

另外一个比较好的方法就是在启动webpack的时候，执行`rm -rf ./build && webpack`。

## 使用clean-webpack-plugin
首先要安装***[clean-webpack-plugin](https://www.npmjs.com/package/clean-webpack-plugin)***:
```
npm i clean-webpack-plugin --save-dev
```
接下来，我们用一个函数来实现上面的想法。虽然可以直接使用这个插件，但是，为了跨项目使用，我们仍将其添加到我们的libs中。
**libs.parts.js**
```
const webpack = require('webpack');
leanpub-start-insert
const CleanWebpackPlugin = require('clean-webpack-plugin');
leanpub-end-insert

...

leanpub-start-insert
exports.clean = function(path) {
  return {
    plugins: [
      new CleanWebpackPlugin([path], {
        // Without `root` CleanWebpackPlugin won't point to our
        // project and will fail to work.
        root: process.cwd()
      })
    ]
  };
}
leanpub-end-insert
```
在主配置文件中引入：
**webpack.config.js**
```
...

// Detect how npm is run and branch based on that
switch(process.env.npm_lifecycle_event) {
  case 'build':
    config = merge(
      common,
      {
        devtool: 'source-map',
        output: {
          path: PATHS.build,
          filename: '[name].[chunkhash].js',
          // This is used for require.ensure. The setup
          // will work without but this is useful to set.
          chunkFilename: '[chunkhash].js'
        }
      },
leanpub-start-insert
      parts.clean(PATHS.build),
leanpub-end-insert
      ...
    );
    break;
  default:
    ...
}

module.exports = validate(config);
```
如此更改后，`build `文件夹在打包后变得很干净。

>如果想在特定的时候保留旧版本的文件，可以使用`path.join(PATHS.build,'*')`来替换`PATHS.build｀。

## 小结
我们的应用变得越来越好。还有一个主要的问题，我们的css文件还是内联在javascript文件中，这将是**Flash of Unstyled Content (FOUC)**的噩梦。不是我们的追求。

css中一个小小的改动就是是我们的应用失效。这在开发中也许没有坏处，但是在生产中问题就大了。我们需要同过将css拆分到其单独的包中来解决这个问题。

























































